/*==============================================================================

							 Header

==[Description]=================================================================

This program will add a oric header to any binary file

==[History]=====================================================================


==[ToDo]========================================================================


==============================================================================*/

#include "infos.h"

#include "common.h"

#include <memory.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <sys/stat.h>

#ifdef _WIN32
#include <conio.h>
#include <io.h>
#else
#include <sys/stat.h>
#define _open  open
#define _read  read
#define _write write
#define _close close
#define _O_TRUNC  O_TRUNC
#define _O_CREAT  O_CREAT
#define _S_IREAD  S_IREAD
#define _S_IWRITE S_IWRITE
#endif

unsigned char Header[]=
{
	0x16,	// 0 Synchro
	0x16,	// 1
	0x16,	// 2
	0x24,	// 3

	0x00,	// 4
	0x00,	// 5

	0x80,	// 6

	0x00,	// 7  $80=BASIC Autostart $C7=Assembly autostart

	0xbf,	// 8  End adress
	0x40,	// 9

	0xa0,	// 10 Start adress
	0x00,	// 11

	0x00,	// 12
	0x00	// 12
};




/**
 * argv[1] - Original filename (headerless raw binary)
 * argv[2] - Destination filename (tape file)
 * argv[3] - Start adress
 */
 int main(int argc,char *argv[])
{
	//
	// Some initialization for the common library
	//
	SetApplicationParameters(
		"Header",
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
		"  Add a header to a raw binary file in order to make it loadable by an\r\n"
		"  oric using the CLOAD command.\r\n"
		"\r\n"
		"Parameters:\r\n"
		"  <options> <sourcefile> <destinationfile> <loadadress>\r\n"
		"  hexadecimal address should be prefixed by a $ or 0x symbol\r\n"
		"  and should not be present in -h0 mode\r\n"
		"\r\n"
		"Options:\r\n"
		"  -a[0/1] for autorun (1) or non autorun (0)\r\n"
		"  -h[0/1] for header (1) or no header (0)\r\n"
		"  -s[0/1] for showing size of file (1) or not (0)\r\n"
		"\r\n"
		"Exemple:\r\n"
		"  {ApplicationName} -a1 final.out osdk.tap $500\r\n"
		"  {ApplicationName} -a1 h0 final.out osdk.tap\r\n"
		);

	bool flag_auto=true;
	bool flag_header=true;
	bool flag_display_size=true;

	ArgumentParser cArgumentParser(argc,argv);

	while (cArgumentParser.ProcessNextArgument())
	{
		if (cArgumentParser.IsSwitch("-a"))
		{
			//format: [-a]
			//	0 => non auto
			// 	1 => perform auto run
			flag_auto=cArgumentParser.GetBooleanValue(true);
		}
		else
		if (cArgumentParser.IsSwitch("-h"))
		{
			//format: [-h]
			//	0 => suppress header
			// 	1 => save header (default)
			flag_header=cArgumentParser.GetBooleanValue(true);
		}
		else
		if (cArgumentParser.IsSwitch("-s"))
		{
			//format: [-s]
			//	0 => suppress display of size
			// 	1 => show size of generated file (default)
			flag_display_size=cArgumentParser.GetBooleanValue(true);
		}
	}


	int	adress_start=0;
	if (flag_header)
	{
		if (cArgumentParser.GetParameterCount()!=3)
		{
			//
			// Wrong number of arguments
			//
			ShowError(0);
		}

		//
		// Check start address
		//
		adress_start=ConvertAdress(cArgumentParser.GetParameter(2));
	}
	else
	{
		if (cArgumentParser.GetParameterCount()!=2)
		{
			//
			// Wrong number of arguments
			//
			ShowError(0);
		}
	}



	//
	// Read file
	//
	const char *filename_src=cArgumentParser.GetParameter(0);
	int filesize = 0;
#ifdef _WIN32
	struct _finddata_t 	file_info;
	if (_findfirst(filename_src, &file_info)== -1)
	{
		ShowError("file not found");
	}
	filesize = file_info.size;
#else
	struct stat st;
	stat(filename_src, &st);
	filesize = st.st_size;
#endif
	int handle_src=_open(filename_src,O_BINARY|O_RDONLY,0);
    if (handle_src==-1)
	{
		ShowError("unable to open source file");
	}

	void *ptr_buf=malloc(filesize);
	if (!ptr_buf)
	{
		ShowError("not enough memory");
	}

	//
	// Read source data
	//
	_read(handle_src,ptr_buf,filesize);


	//
	// Write file
	//
	const char *filename_dst=cArgumentParser.GetParameter(1);
	int handle_dst=_open(filename_dst,O_BINARY|O_WRONLY|_O_TRUNC|_O_CREAT,_S_IREAD|_S_IWRITE);
    if (handle_dst==-1)
	{
		ShowError("unable to create destination file");
	}

	size_t size_header;
	if (flag_header)
	{
		size_header=sizeof(Header);

		//adress_start=0x800;
		int adress_end	=adress_start+filesize-1;
		//flag_auto=true;

		if (flag_auto)	Header[7]=0xC7;
		else			Header[7]=0;

		Header[10]=(adress_start>>8);
		Header[11]=(adress_start&255);

		Header[8]=(adress_end>>8);
		Header[9]=(adress_end&255);

		//
		// Write header
		//
		_write(handle_dst,Header,size_header);

		//
		// Copy the file
		//
		_write(handle_dst,ptr_buf,filesize);
	}
	else
	{
		// Suppress header mode.
		size_header=0;

		char *ptr_header=(char*)ptr_buf;

		// Skip synchronization bytes
		// 16 16 16 24
		while (*ptr_header==0x16)	ptr_header++;
		if (*ptr_header!=0x24)
		{
			ShowError("bad header");
		}
		ptr_header++;

		// FF FF (or 00 00)
		ptr_header++;
		ptr_header++;

		// Flags (80 00)
		ptr_header++;
		ptr_header++;

		// End adress
		ptr_header++;
		ptr_header++;

		// Start adress
		ptr_header++;
		ptr_header++;

		// Separator (FF or 00)
		ptr_header++;

		// Filename (null terminated)
		while (*ptr_header!=0)	ptr_header++;

		// Null terminator skip
		ptr_header++;

		// Recompute size (without header data)
		filesize-=ptr_header-(char*)ptr_buf;

		//
		// Copy the file
		//
		_write(handle_dst,ptr_header,filesize);
	}

	//
	// Close everything
	//
	_close(handle_dst);
	_close(handle_src);
	free(ptr_buf);


	//
	// Eventually show some information
	//
	if (flag_display_size)
	{
		printf("File '%s' is %d bytes long (%d bytes header and %d bytes of data)\n",filename_dst,size_header+filesize,size_header,filesize);
	}


	exit(0);
}




/*
16 16 16 24 				// Synchro

FF FF (ou 00 00)

80 00

B8 00 					// End adress
B4 00 					// Start adress

FF (or 00)

41 53 4D 32 4B 32 2E 54 41 50 00	// Filename
*/
			/*
			unsigned char Header[]=
			{
				0x16,	// 0
				0x16,	// 1
				0x16,	// 2
				0x24,	// 3

				0x00,	// 4
				0x00,	// 5

				0x80,	// 6

				0x00,	// 7

				0xbf,	// 8
				0x40,	// 9

				0xa0,	// 10
				0x00,	// 11

				0x00,	// 12
				0x00	// 12
			};
			*/



