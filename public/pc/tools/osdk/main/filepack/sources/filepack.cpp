//
//
//
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <io.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <STDLIB.H>

#include "infos.h"

#include "common.h"


long LZ77_Compress(void *buf_src,void *buf_dest,long size_buf_src);
void LZ77_UnCompress(void *buf_src,void *buf_dest,long size);
long LZ77_ComputeDelta(void *buf_comp,long size_uncomp,long size_comp);



#define NB_ARG	2



void main(int argc,char *argv[]) 
{
	//
	// Some initialization for the common library
	//
	SetApplicationParameters(
		"FilePack",
		TOOL_VERSION_MAJOR,
		TOOL_VERSION_MINOR,
		"{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
		"\r\n"
		"Author:\r\n"
		"  Pointier Mickael \r\n"
		"\r\n"
		"Purpose:\r\n"
		"  Compressing or decompressing data so they take less room.\r\n"
		"\r\n"
		"Usage for packing a data file:\r\n"
		"  {ApplicationName} -p[0|1] original_file packed_file\r\n"
		"\r\n"
		"Usage for unpacking a file:\r\n"
		"  {ApplicationName} -u packed_file destination_file\r\n"
		"\r\n"
		"Switches:\r\n"
		" -pn   Packing mode\r\n"
		"       -p0 => No header\r\n"
		"       -p1 => Save with header\r\n"
		);

	bool	flag_save_header=true;
	bool	flag_pack=true;

	ArgumentParser cArgumentParser(argc,argv);

	while (cArgumentParser.ProcessNextArgument())
	{
		if (cArgumentParser.IsSwitch("-u"))	// Unpack
		{
			flag_pack=false;
		}
		else 
		if (cArgumentParser.IsSwitch("-p"))	// Pack data
		{
			flag_pack=true;
			flag_save_header=cArgumentParser.GetBooleanValue(true);
		}
	}


    if (cArgumentParser.GetParameterCount()!=NB_ARG)
    {
		ShowError(0);
    }


	//
	// Copy last parameters
	//
	char	source_name[_MAX_PATH];
	char	dest_name[_MAX_PATH];

	strcpy(source_name	,cArgumentParser.GetParameter(0));
	strcpy(dest_name	,cArgumentParser.GetParameter(1));



	char	SDrive[_MAX_DRIVE];
	char	SDir[_MAX_DIR];
	char	SName[_MAX_FNAME];
	char	SExt[_MAX_EXT];

	char	header_name[_MAX_PATH];

	_splitpath(dest_name,SDrive,SDir,SName,SExt);
	sprintf(header_name,"%s%s%s_fp.s",SDrive,SDir,SName);


	void *ptr_buffer_void;
	size_t size_buffer_src;

	if (!LoadFile(source_name,ptr_buffer_void,size_buffer_src))
	{
		printf("\nUnable to load file '%s'",source_name);
		printf("\n");
		exit(1);
	}
	char *ptr_buffer=(char*)ptr_buffer_void;

	unsigned char *ptr_buffer_dst;
	int size_buffer_dst;

	if (flag_pack)
	{
		//
		// Pack file
		//
		int data_offset;
		if (flag_save_header)
		{
			data_offset=8;
		}
		else
		{
			data_offset=0;
		}
		ptr_buffer_dst=new unsigned char[size_buffer_src+data_offset];
		size_buffer_dst=LZ77_Compress(ptr_buffer,ptr_buffer_dst+data_offset,size_buffer_src);
		if ((size_buffer_dst+data_offset)>=size_buffer_src)
		{
			printf("\nUnable to pack file'%s'",source_name);
			printf("\n");
			exit(1);
		}
		//
		// Create file header
		//
		if (flag_save_header)
		{
			ptr_buffer_dst[0]='L';
			ptr_buffer_dst[1]='Z';
			ptr_buffer_dst[2]='7';
			ptr_buffer_dst[3]='7';

			ptr_buffer_dst[4]=(size_buffer_src&255);
			ptr_buffer_dst[5]=(size_buffer_src>>8)&255;

			ptr_buffer_dst[6]=(size_buffer_dst&255);   
			ptr_buffer_dst[7]=(size_buffer_dst>>8)&255;

			size_buffer_dst+=8;
		}
		else
		{
			FILE *dest_file=fopen(header_name,"w");
			if (!dest_file)
			{
				printf("Unable to open destination header file\n");
				exit(1);
			}

			fprintf(dest_file,"#define run_adress $%x 	; Come from original TAP executable \r\n",0x600);
			fprintf(dest_file,"#define unpacked_size $%x 	; Come from original TAP executable \r\n",size_buffer_src);

			fclose(dest_file);			
		}
	}
	else
	{
		//
		// Unpack file
		//
		if ((ptr_buffer[0]!='L') ||
			(ptr_buffer[1]!='Z') ||
			(ptr_buffer[2]!='7') ||
			(ptr_buffer[3]!='7'))
		{
			printf("\nNot a LZ77 packed file'%s'",source_name);
			printf("\n");
			exit(1);
		}

		int size_unpacked	=ptr_buffer[4] | (ptr_buffer[5]<<8);
		int size_packed		=ptr_buffer[6] | (ptr_buffer[7]<<8);

		if ((size_packed+8)!=size_buffer_src)
		{
			printf("\nInvalid size in packed file'%s'",source_name);
			printf("\n");
			exit(1);
		}

		size_buffer_dst=size_unpacked;

		ptr_buffer_dst=new unsigned char[size_buffer_dst];
		LZ77_UnCompress(ptr_buffer+8,ptr_buffer_dst,size_buffer_dst);
	}

	if (!SaveFile(dest_name,ptr_buffer_dst,size_buffer_dst))
	{
		printf("\nUnable to save file '%s'",source_name);
		printf("\n");
		exit(1);
	}



	//
	// Make some cleaning
	//
	delete[] ptr_buffer;
	delete[] ptr_buffer_dst;
}


