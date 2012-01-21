
#include "infos.h"

#include "common.h"

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <string.h>



char *keywords[]= 
{ 
	"END","EDIT","STORE","RECALL","TRON","TROFF","POP","PLOT",
	"PULL","LORES","DOKE","REPEAT","UNTIL","FOR","LLIST","LPRINT","NEXT","DATA",
	"INPUT","DIM","CLS","READ","LET","GOTO","RUN","IF","RESTORE","GOSUB","RETURN",
	"REM","HIMEM","GRAB","RELEASE","TEXT","HIRES","SHOOT","EXPLODE","ZAP","PING",
	"SOUND","MUSIC","PLAY","CURSET","CURMOV","DRAW","CIRCLE","PATTERN","FILL",
	"CHAR","PAPER","INK","STOP","ON","WAIT","CLOAD","CSAVE","DEF","POKE","PRINT",
	"CONT","LIST","CLEAR","GET","CALL","!","NEW","TAB(","TO","FN","SPC(","@",
	"AUTO","ELSE","THEN","NOT","STEP","+","-","*","/","^","AND","OR",">","=","<",
	"SGN","INT","ABS","USR","FRE","POS","HEX$","&","SQR","RND","LN","EXP","COS",
	"SIN","TAN","ATN","PEEK","DEEK","LOG","LEN","STR$","VAL","ASC","CHR$","PI",
	"TRUE","FALSE","KEY$","SCRN","POINT","LEFT$","RIGHT$","MID$"
};

unsigned char head[14]={ 0x16,0x16,0x16,0x24,0,0,0,0,0,0,5,1,0,0 };




void Tap2Bas(unsigned char *ptr_buffer,size_t file_size)
{
	unsigned int i, car;

	if (ptr_buffer[0]!=0x16 || ptr_buffer[3]!=0x24) 
	{ 
		ShowError("Not an Oric file");
	}
	if (ptr_buffer[6]) 
	{ 
		ShowError("Not a BASIC file"); 
	}
	i=13; 
	while (ptr_buffer[i++]);
	while (ptr_buffer[i] || ptr_buffer[i+1]) 
	{
		i+=2;
		printf(" %u ",ptr_buffer[i]+(ptr_buffer[i+1]<<8));
		i+=2;
		while (car=ptr_buffer[i++]) 
		{
			if (car<128) 
				putchar(car);
			else 
				printf("%s",keywords[car-128]);
		}
		putchar('\n');
	}
}



// tap2bas
int search_keyword(const char *str)
{
	int i;
	for (i=0;i<sizeof(keywords)/sizeof(char *);i++)
	{
		if (strncmp(keywords[i],str,strlen(keywords[i]))==0)
		{
			return i;
		}
	}
	return -1;
}



void Bas2Tap(const char *pSourceFile,const char *pDestFile,bool bAutoRun,bool bUseColor)
{
	unsigned char buf[48192];
	unsigned int end, lastptr, adr;
	int j,ptr,keyw,string,rem,data;

	// Mike: Need to improve the parsing of this with a global function to split 
	// a text file in separate lines.
	std::vector<std::string> cTextData;
	if (!LoadText(pSourceFile,cTextData))
	{
		ShowError("Unable to load source file");
	}

	std::string cCurrentFile=pSourceFile;
	int nCurrentLine=0;
	int i=0;
	std::vector<std::string>::const_iterator cIt=cTextData.begin();
	while (cIt!=cTextData.end())
	{
		const std::string& cCurrentLine=*cIt;

		++nCurrentLine;

		if (!cCurrentLine.empty())
		{
			const char* ligne=cCurrentLine.c_str();
			if (ligne[0]=='#')
			{
				// Preprocessor directive
				if (memicmp(ligne,"#file",5)==0)
				{
					//"#file font.BAS""
					// Very approximative "get the name of the file and reset the line counter" code.
					// Will clean up that when I will have some more time.
					ligne+=5;
					cCurrentFile=ligne;
					nCurrentLine=0;
				}
				else
				{
					std::string cErrorMessage=StringFormat("Unknown preprocessor directive in file %s line number line %d",cCurrentFile.c_str(),nCurrentLine);
					ShowError(cErrorMessage.c_str());
				}
			}
			else
			{
				// Standard line
				buf[i++]=0; 
				buf[i++]=0;

				int number=get_value(ligne,-1);
				if (number<0) 
				{
					// Mike: Need to add better diagnostic here
					std::string cErrorMessage=StringFormat("Missing line number in file %s line %d",cCurrentFile.c_str(),nCurrentLine);
					ShowError(cErrorMessage.c_str());
					break;
				}
				buf[i++]=number&0xFF; 
				buf[i++]=number>>8;

				ptr=0; 
				rem=0;
				bool bColor=bUseColor;
				string=0; 
				data=0;
				if (ligne[ptr]==' ') ptr++;

				while (ligne[ptr]) 
				{
					if (rem) 
					{
						if (bColor)
						{
							bColor=false;
							buf[i++]=27;	// ESCAPE
							buf[i++]='B';	// GREEN labels
						}
						buf[i++]=ligne[ptr++];
					} 
					else 
					if (string) 
					{
						if (ligne[ptr]=='"') string=0;
						buf[i++]=ligne[ptr++];
					} 
					else 
					if (data) 
					{
						if (ligne[ptr]==':') data=0;
						buf[i++]=ligne[ptr++];
					} 
					else 
					{
						const char* pLine=(ligne+ptr);
						keyw=search_keyword(pLine);
						if (keyw==29 || ligne[ptr]=='\'') rem=1;
						if (keyw==17) data=1;
						if (ligne[ptr]=='"') string=1;
						if (keyw>=0) 
						{
							buf[i++]=keyw+128; 
							ptr+=strlen(keywords[keyw]);
						} 
						else 
						{
							buf[i++]=ligne[ptr++];
						}
					}
				}
				buf[i++]=0;
			}
		}
		++cIt;
	}
	buf[i++]=0;
	buf[i++]=0;

        //following line modified by Wilfrid AVRILLON (Waskol) 06/20/2009
        //It should follow this rule of computation : End_Address=Start_Address+File_Size-1
        //Let's assume a 1 byte program, it starts at address #501 and ends at address #501 (Address=Address+1-1) ! 
        //It was a blocking issue for various utilities (tap2wav for instance)
	//end=0x501+i-1;	        //end=0x501+i;
	end=0x501+i;

	if (bAutoRun)	head[7]=0x80;	// Autorun for basic :)
	else			head[7]=0;

	head[8]=end>>8;
	head[9]=end&0xFF;

	for(j=4,lastptr=0;j<i;j++)
	{
		if (buf[j]==0) 
		{
			adr=0x501+j+1; 
			buf[lastptr]=adr&0xFF; 
			buf[lastptr+1]=adr>>8;
			lastptr=j+1;
			j+=4;
		}
	}
		
	//
	// Save file
	//
	FILE *out=fopen(pDestFile,"wb");
	if (out==NULL) 
	{ 
		printf("Can't open file for writing\n"); 
		exit(1); 
	}
	fwrite(head,1,14,out);
	fwrite(buf,1,i,out); 
	fclose(out);
}




#define NB_ARG	2

void main(int argc, char **argv)
{
	//
	// Some initialization for the common library
	//
	SetApplicationParameters(
		"Bas2Tap",
		TOOL_VERSION_MAJOR,
		TOOL_VERSION_MINOR,
		"{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
		"\r\n"
		"Author:\r\n"
		"  Fabrice Frances \r\n"
		"\r\n"
		"Purpose:\r\n"
		"  Converting a text file containing a BASIC source code to a binary\r\n"
		"  encoded TAPE file that can be loaded using the CLOAD command.\r\n"
		"  (and the opposite operation as well).\r\n"
		"\r\n"
		"Parameters:\r\n" 
		"  <options> <sourcefile> <destinationfile>\r\n"
		"\r\n"
		"Options:\r\n" 
		"  -b2t[0|1] for converting to tape format with autorun (1) or not (0)\r\n"
		"  -t2b for converting from tape format text\r\n"
		"  -color[0|1] for enabling colored comments"
		"\r\n"
		"Exemple:\r\n"
		"  {ApplicationName} -b2t1 final.txt osdk.tap\r\n"
		"  {ApplicationName} -t2b osdk.tap program.txt\r\n"
		);

	bool bBasicToTape=true;
	bool bAutoRun=true;	
	bool bUseColor=false;

	ArgumentParser cArgumentParser(argc,argv);

	while (cArgumentParser.ProcessNextArgument())
	{
		if (cArgumentParser.IsSwitch("-t2b"))
		{
			// Tape to BASIC source code
			bBasicToTape=false;
		}
		else 
		if (cArgumentParser.IsSwitch("-b2t"))
		{
			// BASIC source code to tape
			bBasicToTape=true;
			bAutoRun=cArgumentParser.GetBooleanValue(true);
		}
		else 
		if (cArgumentParser.IsSwitch("-color"))
		{
			// Handling of color codes
			bUseColor=cArgumentParser.GetBooleanValue(false);
		}
	}

    if (cArgumentParser.GetParameterCount()!=NB_ARG)
    {
		ShowError(0);
    }
				   

	std::string NameSrc(cArgumentParser.GetParameter(0));
	std::string NameDst(cArgumentParser.GetParameter(1));

	if (bBasicToTape)
	{
		Bas2Tap(NameSrc.c_str(),NameDst.c_str(),bAutoRun,bUseColor);
	}
	else
	{
		// Load the source file
		void* ptr_buffer_void;
		size_t file_size;
		if (!LoadFile(NameSrc.c_str(),ptr_buffer_void,file_size))
		{
			ShowError("Unable to load the source file");
		}
		unsigned char *ptr_buffer=(unsigned char*)ptr_buffer_void;

		Tap2Bas(ptr_buffer,file_size);
	}

	exit(0);
}
