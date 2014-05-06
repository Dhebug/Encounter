//
// This program will split sources files resulting from the macro conversion.
//
/*
_test
	ldx #6 ;	lda #7 ;	jsr enter ;
	lda #<(0) ;	sta reg1 ;
	lda #<(4) ;	sta reg3 ;
	lda #<(590) ;	sta reg2 ;	lda #>(590) ;	sta reg2+1 ;
	lda reg2 ;	sta tmp0 ;	lda reg2+1 ;	sta tmp0+1 ;

Will become:

_test
	ldx #6
	lda #7
	jsr enter
	lda #<(0)
	sta reg1
	lda #<(4)
	sta reg3
	lda #<(590)
	sta reg2
	lda #>(590)
	sta reg2+1
	lda reg2
	sta tmp0
	lda reg2+1
	sta tmp0+1 ;


*/

#include "infos.h"

#include "common.h"

#include <memory.h>
#include <stdlib.h>
#include <stdio.h>
#ifdef _WIN32
#include <conio.h>
#include <io.h>
#endif
#include <fcntl.h>
#include <sys/stat.h>

#include <string>


bool ConvertBuffer(void* &pBuffer,size_t &nSizeBuffer)
{
	std::string cDestString((const char*)pBuffer,nSizeBuffer);

	// UNIX to DOS replacement
	StringReplace(cDestString,"\n\r","\r\n");

	StringReplace(cDestString,";","\r\n");

	free(pBuffer);
	nSizeBuffer=cDestString.size();
	pBuffer=malloc(nSizeBuffer+1);
	memcpy(pBuffer,cDestString.c_str(),nSizeBuffer+1);

	return true;
}



#define NB_ARG	3


/**
 * argv[1] - Original filename (macro converted file)
 * argv[2] - Destination filename (tape file)
 */
int main(int argc,char *argv[])
{
	//
	// Some initialization for the common library
	//
	SetApplicationParameters(
		"MacroSplitter",
		TOOL_VERSION_MAJOR,
		TOOL_VERSION_MINOR,
		"{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
		"\r\n"
		"Author:\r\n"
		"  Mickael Pointier (aka Dbug)\r\n"
		"  dbug@defence-force.org\r\n"
		"  http://www.defence-force.org\r\n"
		"\r\n"
		"Purpose:\r\n"
		"  Reformat the file resulting from the macro conversion by splitting the\r\n"
		"  lines after the ; character\r\n"
		"\r\n"
		"Parameters:\r\n"
		"  <options> <sourcefile> <destinationfile>\r\n"
		"\r\n"
		"Exemple:\r\n"
		"  {ApplicationName} source.s destination.s\r\n"
		);


    long param=1;
	if (argc>1)
	{
		for (;;)
		{
			long nb_arg=argc;
			if (nb_arg==argc)   break;
		}
	}

	if (argc!=NB_ARG)
	{
		//
		// Wrong number of arguments
		//
		ShowError(0);
	}


	//
	// Read file
	//
	void *pBuffer;
	size_t nSizeBuffer;
	if (!LoadFile(argv[param],pBuffer,nSizeBuffer))
	{
		ShowError("unable to load source file");
	}

	//
	// Convert buffer data
	//
	if (!ConvertBuffer(pBuffer,nSizeBuffer))
	{
		ShowError("unable to convert data");
	}

	//
	// Write file
	//
	if (!SaveFile(argv[param+1],pBuffer,nSizeBuffer))
	{
		ShowError("unable to create destination file");
	}

	free(pBuffer);

	exit(0);
}

