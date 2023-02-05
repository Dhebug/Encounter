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
		"{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK (http://www.osdk.org)\r\n"
		"\r\n"
		"Author:\r\n"
		"  (c) 1998-2020 Pointier Mickael \r\n"
		"\r\n"
		"Purpose:\r\n"
		"  Converting a binary file to a text format that can be later reused in a program\r\n"
		"  written in C, assembly code or BASIC.\r\n"
		"\r\n"
		"USAGE:\r\n"
		"{ApplicationName} -s<number> -f<number> <binary file> <txt file> <label name>\r\n"
		"  [options]:\r\n"
		"  -s[1|2|4]	    For BYTE,WORD,LONG format.\r\n"
		"  -e[1|2]			Define endianness: 1 for little endian, 2 for big endian\r\n"
		"  -f[1|2|3]		For C, ASM, BASIC.\r\n"
		"  -h[1|2]			1 for hexadecimal, 2 for decimal\r\n"
		"  -l[b:s]			Defines line values for BASIC (-l10:10)\r\n"
		"  -n[16|32|..]	Defines the number of entries per line.\r\n"
		);


	TextFileGenerator textFileGenerator;

	ArgumentParser argumentParser(argc,argv);

	while (argumentParser.ProcessNextArgument())
	{
		if (argumentParser.IsSwitch("-s"))
		{
			textFileGenerator.SetDataSize(argumentParser.GetIntegerValue(1));
		}
		else
		if (argumentParser.IsSwitch("-e"))
		{
			textFileGenerator.SetEndianness((TextFileGenerator::Endianness_e)argumentParser.GetIntegerValue(TextFileGenerator::_eEndianness_Undefined_));
		}
		else
		if (argumentParser.IsSwitch("-f"))
		{
			textFileGenerator.SetFileType((TextFileGenerator::Language_e)argumentParser.GetIntegerValue(TextFileGenerator::_eLanguage_Undefined_));
		}
		else
		if (argumentParser.IsSwitch("-h"))
		{
			textFileGenerator.SetNumericBase((TextFileGenerator::NumericBase_e)argumentParser.GetIntegerValue(TextFileGenerator::_eNumericBase_Undefined_));
		}
		else
		if (argumentParser.IsSwitch("-l"))
		{
			textFileGenerator.SetLineNumber(argumentParser.GetIntegerValue(10));
			if (argumentParser.GetSeparator(":"))
			{
				textFileGenerator.SetIncrementLineNumber(argumentParser.GetIntegerValue(10));
			}
		}
		else
		if (argumentParser.IsSwitch("-n"))
		{
			textFileGenerator.SetValuesPerLine(argumentParser.GetIntegerValue(16));
		}
	}

  if (argumentParser.GetParameterCount() != NB_ARG)
  {
    ShowError(0);
  }

	std::string nameSrc(argumentParser.GetParameter(0));
	std::string nameDst(argumentParser.GetParameter(1));
	textFileGenerator.SetLabel(argumentParser.GetParameter(2));

	printf("Converting <%s> to <%s> with label <%s>\n",nameSrc.c_str(),nameDst.c_str(),textFileGenerator.GetLabel().c_str());

	void* ptr_buffer_void;
	size_t file_size;
	if (!LoadFile(nameSrc.c_str(),ptr_buffer_void,file_size))
	{
		ShowError("Unable to load the source file");
	}
	printf("Size Read:%d\n",(signed int) file_size);
	unsigned char *bigBuffer=(unsigned char*)ptr_buffer_void;

	std::string destString(textFileGenerator.ConvertData(bigBuffer,file_size));

	if (!SaveFile(nameDst.c_str(),destString.c_str(),destString.size()))
	{
		ShowError("Unable to save the destination file");
	}

	free(bigBuffer);

  exit(0);
}




