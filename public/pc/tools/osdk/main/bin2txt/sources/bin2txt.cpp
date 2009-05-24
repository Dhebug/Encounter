/*==============================================================================

							 Bin2Txt

==[Description]=================================================================

This little command line application can be use to convert binary files to a
text format, than can later be compiled using various languages.

==[History]=====================================================================

First version Mick: Fri  13/09/96  16:16:14

==[ToDo]========================================================================

* Support for Little/Big Endian
* Support for BASIC instructions (nnnn DATA a,b,c,d, ...)

==============================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <ctype.h>
#include <fcntl.h>
#include <io.h>
#include <string.h>

#include "infos.h"

#include "common.h"





#define NB_ARG	3




int main(int argc,char *argv[])
{
	//
	// Some initialization for the common library
	//
	SetApplicationParameters(
		"Bin2Txt",
		TOOL_VERSION_MAJOR,
		TOOL_VERSION_MINOR,
		"{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
		"\r\n"
		"Author:\r\n"
		"  (c) 1998-2006 Pointier Mickael \r\n"
		"\r\n"
		"Purpose:\r\n"
		"  Converting a binary file to a text format that can be later reused in a program\r\n"
		"  written in C, assembly code or BASIC.\r\n"
		"\r\n"
		"USAGE:\r\n"
		"{ApplicationName} -s<number> -f<number> <binary file> <txt file> <label name>\r\n"
		"  [options]:\r\n"
		"  ®-s[1|2|4]	    For BYTE,WORD,LONG format.\r\n"
		"  ®-e[1|2]			Define endianness: 1 for little endian, 2 for big endian\r\n"
		"  ®-f[1|2|3]		For C, ASM, BASIC.\r\n"
		"  ®-h[1|2]			1 for hexadecimal, 2 for decimal\r\n"
		"  ®-l[b:s]			Defines line values for BASIC (-l10:10)\r\n"
		"  ®-n[16|32|..]	Defines the number of entries per line.\r\n"
		);


	TextFileGenerator cTextFileGenerator;

	ArgumentParser cArgumentParser(argc,argv);

	while (cArgumentParser.ProcessNextArgument())
	{
		if (cArgumentParser.IsSwitch("-s"))
		{
			cTextFileGenerator.SetDataSize(cArgumentParser.GetIntegerValue(1));
		}
		else
		if (cArgumentParser.IsSwitch("-e"))
		{
			cTextFileGenerator.SetEndianness((TextFileGenerator::Endianness_e)cArgumentParser.GetIntegerValue(TextFileGenerator::_eEndianness_Undefined_));
		}
		else
		if (cArgumentParser.IsSwitch("-f"))
		{
			cTextFileGenerator.SetFileType((TextFileGenerator::Language_e)cArgumentParser.GetIntegerValue(TextFileGenerator::_eLanguage_Undefined_));
		}
		else
		if (cArgumentParser.IsSwitch("-h"))
		{
			cTextFileGenerator.SetNumericBase((TextFileGenerator::NumericBase_e)cArgumentParser.GetIntegerValue(TextFileGenerator::_eNumericBase_Undefined_));
		}
		else
		if (cArgumentParser.IsSwitch("-l"))
		{
			cTextFileGenerator.SetLineNumber(cArgumentParser.GetIntegerValue(10));
			if (cArgumentParser.GetSeparator(":"))
			{
				cTextFileGenerator.SetIncrementLineNumber(cArgumentParser.GetIntegerValue(10));
			}
		}
		else
		if (cArgumentParser.IsSwitch("-n"))
		{
			cTextFileGenerator.SetValuesPerLine(cArgumentParser.GetIntegerValue(16));
		}
	}

    if (cArgumentParser.GetParameterCount()!=NB_ARG)
    {
		ShowError(0);
    }

	std::string NameSrc(cArgumentParser.GetParameter(0));
	std::string NameDst(cArgumentParser.GetParameter(1));
	cTextFileGenerator.SetLabel(cArgumentParser.GetParameter(2));

	printf("Converting <%s> to <%s> with label <%s>\n",NameSrc.c_str(),NameDst.c_str(),cTextFileGenerator.GetLabel().c_str());

	void* ptr_buffer_void;
	size_t file_size;
	if (!LoadFile(NameSrc.c_str(),ptr_buffer_void,file_size))
	{
		ShowError("Unable to load the source file");
	}
	printf("Size Read:%d\n",file_size);
	unsigned char *BigBuffer=(unsigned char*)ptr_buffer_void;

	std::string cDestString;
	cTextFileGenerator.ConvertData(cDestString,BigBuffer,file_size);

	if (!SaveFile(NameDst.c_str(),cDestString.c_str(),cDestString.size()))
	{
		ShowError("Unable to save the destination file");
	}

	free(BigBuffer);

    exit(0);
}




