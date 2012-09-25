/*==============================================================================

							 PictConv

==[Description]=================================================================

==[History]=====================================================================

==[ToDo]========================================================================

* Upgrade to a more recent version of FreeImage

==============================================================================*/

#include <stdio.h>

#include "FreeImage.h"

#include "infos.h"

#include "common.h"

#include "defines.h"
#include "hires.h"
#include "image.h"

//#include <conio.h>

int RunUnitTests();


#define NB_ARG	2


int __cdecl main(int argc,char *argv[])
{
	//
	// Some initialization for the common library
	//
	SetApplicationParameters(
		"PictConv",
		TOOL_VERSION_MAJOR,
		TOOL_VERSION_MINOR,
		"{ApplicationName} - Version {ApplicationVersion} - ("__DATE__" / "__TIME__") - This program is a part of the OSDK\r\n"
		"\r\n"
		"Author:\r\n"
		"  (c) 2002-2009 Pointier Mickael \r\n"
		"\r\n"
		"Usage:\r\n"
		"  {ApplicationName} [switches] <source picture> <destination file>\r\n"
		"\r\n"
		"Switches:\r\n"
		" -mn   Machine\r\n"
		"       -m0 => Oric [default]\r\n"
		"       -m1 => Atari ST\r\n"
		"\r\n"
		" -fn   Rendering format (machine dependent)\r\n"
		"       -Oric:\r\n"
		"         -f0 => to hires monochrom format [default]\r\n"
		"         -f0z => to hires monochrom format (do not set bit 6) *** Not working in this version ***\r\n"
		"         -f1 => precolored picture\r\n"
		"         -f2 => RVB conversion\r\n"
		"         -f3 => Twilight masks\r\n"
		"         -f4 => RB conversion\r\n"
		"       -Atari ST:\r\n"
		"         -f0 => Single palette format [default]\r\n"
		"         -f1 => Multi palette format\r\n"
		"\r\n"
		" -pn   Palette management\r\n"
		"         -p0 => Generate a palette automatically [default]\r\n"
		"         -p1 => Last line of the picture contains the palette\r\n"
		"         -p2 => Last pixels of each line of the picture contains the palette\r\n"
		"\r\n"
		" -dn   Dithering mode\r\n"
		"       -d0 => no dithering [default]\r\n"
		"       -d1 => alternate (01010101) dithering\r\n"
		"       -d2 => ordered dither\r\n"
		"       -d3 => riemersma\r\n"
		"\r\n"
		" -on   Output file format\r\n"
		"       -o0 => TAP (with a header that load in 0xa000)\r\n"
		"       -o1 => TAP (with a BASIC program that switch to HIRES then load)\r\n"
		"       -o2 => RAW data\r\n"
		"       -o3[label] => .C format with labels and .h for 'extern' declaration\r\n"
		"       -o4[label] => .S format with labels and .h for 'extern' declaration\r\n"
		"       -o5 => Picture format (PNG, BMP, ...)\r\n"
		"       -o6 => X+Y+RAW\r\n"
		"       -o7 => Palette followed by picture data\r\n"
		"       -o8[line:step] => .BAS format \r\n"
		"\r\n"
		" -tn   Testing mode\r\n"
		"       -t0 => Testing disabled [default]\r\n"
		"       -t1 => Testing enabled\r\n"
		"\r\n"
		" -bn   Block mode\r\n"
		"       -b0 => Block mode disabled [default]\r\n"
		"       -b1 => Block mode enabled\r\n"
		"\r\n"
		" -nn   Defines the number of entries per line.\r\n"
		"       -n16 => Output 16 values each line\r\n"
		"       -n40 => Output 40 values each line\r\n"
		);

#ifdef _DEBUG
	int failureCount=RunUnitTests();
	if (failureCount)
	{
		ShowError("UnitTests failed.");
	}
#endif

	DEVICE_FORMAT	output_format=DEVICE_FORMAT_BASIC_TAPE;
	//bool			flag_basic_loader=true;
	bool			flag_testing=false;

	TextFileGenerator cTextFileGenerator;
	cTextFileGenerator.SetLabel("_LabelPicture");
	cTextFileGenerator.SetDataSize(1);											// Byte format
	cTextFileGenerator.SetEndianness(TextFileGenerator::_eEndianness_Little);	// Little endian

	int switchMachine=0;		// Default 0=oric
	int switchFormat=0;		
	int switchDither=0;
	int switchPalette=0;		// Default 0=automatically generate the palette
	int switchBlock=0;			// Default 0=no block mode (full picture)

	ArgumentParser cArgumentParser(argc,argv);

	while (cArgumentParser.ProcessNextArgument())
	{
		if (cArgumentParser.IsSwitch("-f"))
		{
			//format: [-f]
			//	0 => to hires 240x200 monochrome format
			// 	1 => precolored picture (like the Windows 95 picture)
			//	2 => RVB conversion
			//		=> give the scanline colors (RGB/RG/BCW), both for paper and ink
			//  3 => Twilighte mask
			//	4 => RB conversion
			//  5 => Shifter format (Atari ST)
			switchFormat=cArgumentParser.GetIntegerValue(0);
			/*
			Hires.SetFormat((PictureConverter::FORMAT)cArgumentParser.GetIntegerValue(PictureConverter::FORMAT_MONOCHROM));
			if (Hires.GetFormat()==PictureConverter::FORMAT_MONOCHROM)
			{
				// Check extended parameters for monochrome conversion
				switch (*cArgumentParser.GetRemainingStuff())
				{
				case 'z':
					// Clear bitmap bit flag
					Hires.set_bit6(false);
					break;
				}
			}
			*/
		}
		else
		if (cArgumentParser.IsSwitch("-m"))
		{
			//format: [-m]
			//	0 => Oric
			// 	1 => Atari ST
			switchMachine=cArgumentParser.GetIntegerValue(0);
		}
		else
		if (cArgumentParser.IsSwitch("-b"))
		{
			//block mode: [-b]
			//	0 => No blocs (simple picture)
			// 	1 => Blocks enabled
			switchBlock=cArgumentParser.GetIntegerValue(0);
		}
		else
		if (cArgumentParser.IsSwitch("-p"))
		{
			//format: [-m]
			//	0 => Get the palette from the picture
			// 	1 => The last line of the picture contains the palette
			//  2 => The last pixels of each line contains the palette for the line
			switchPalette=cArgumentParser.GetIntegerValue(0);
		}
		else
		if (cArgumentParser.IsSwitch("-n"))
		{
			//format: [-n]
			cTextFileGenerator.SetValuesPerLine(cArgumentParser.GetIntegerValue(16));
		}
		else
		if (cArgumentParser.IsSwitch("-d"))
		{
			//dithering: [-d]
			//	0 => none
			//	1 => alternate (01010101)
			//	2 => ordered dither
			//	3 => riemersma
			//	4 => floyd steinberg
			//  5 => alternate inversed (10101010)
			switchDither=cArgumentParser.GetIntegerValue(0);
		}
		else
		if (cArgumentParser.IsSwitch("-o"))
		{
			//output: [-o]
			//	0 => TAP (with a header)
			//		=> load adress (0xa000 by default for hires, 0xbb80 for text + 0xb400 for attributes))
			//	1 => specify if we want a basic loader
			//		=> load adress (0xa000 by default for hires, 0xbb80 for text + 0xb400 for attributes))
			//	2 => Raw data
			//	3 => .C format with labels and .h for "extern" declaration
			//	4 => .S format with labels and .h for "extern" declaration
			//	5 => Picture
			//	6 => X+Y+RAW
			//  7 => Raw picture + palette mode
			//	8 => .BAS format with labels and .h for "extern" declaration
			output_format=(DEVICE_FORMAT)cArgumentParser.GetIntegerValue(DEVICE_FORMAT_BASIC_TAPE);
			switch (output_format)
			{
			case DEVICE_FORMAT_SOURCE_C:
				cTextFileGenerator.SetFileType(TextFileGenerator::eLanguage_C);
				if (*cArgumentParser.GetRemainingStuff())
				{
					// Keep this as a label value
					cTextFileGenerator.SetLabel(cArgumentParser.GetRemainingStuff());
				}
				break;

			case DEVICE_FORMAT_SOURCE_S:
				cTextFileGenerator.SetFileType(TextFileGenerator::eLanguage_Assembler);
				if (*cArgumentParser.GetRemainingStuff())
				{
					// Keep this as a label value
					cTextFileGenerator.SetLabel(cArgumentParser.GetRemainingStuff());
				}
				break;

			case DEVICE_FORMAT_SOURCE_BASIC:
				cTextFileGenerator.SetFileType(TextFileGenerator::eLanguage_BASIC);
				cTextFileGenerator.SetLabel("Generated by PictConv");
				if (cArgumentParser.GetSeparator(":"))
				{
					cTextFileGenerator.SetLineNumber(cArgumentParser.GetIntegerValue(10));
					if (cArgumentParser.GetSeparator(":"))
					{
						cTextFileGenerator.SetIncrementLineNumber(cArgumentParser.GetIntegerValue(10));
					}
				}
				break;

			case DEVICE_FORMAT_BASIC_TAPE:
			case DEVICE_FORMAT_TAPE:
			case DEVICE_FORMAT_RAWBUFFER:
			case DEVICE_FORMAT_PICTURE:
			case DEVICE_FORMAT_RAWBUFFER_WITH_XYHEADER:
			case DEVICE_FORMAT_RAWBUFFER_WITH_PALETTE:
				break;

			default:
				ShowError("Unknown format");
				break;
			}
		}
		else
		if (cArgumentParser.IsSwitch("-t"))
		{
			//testing: [-t]
			//	0 => disabled
			//	1 => enabled
			flag_testing=cArgumentParser.GetBooleanValue(true);
		}

	}

    if (cArgumentParser.GetParameterCount()!=NB_ARG)
    {
		ShowError(0);
    }

	//
	// Set and validate the parameters
	//	0 => Oric
	// 	1 => Atari ST
	//
	PictureConverter* pPictureConverter=PictureConverter::GetConverter((PictureConverter::MACHINE)switchMachine);
	if (!pPictureConverter)
	{
		ShowError("Can't create the required converter - Type is unknown");
	}
	PictureConverter& Hires(*pPictureConverter);

	Hires.SetDither((PictureConverter::DITHER)switchDither);
	Hires.SetBlockMode((PictureConverter::BLOCKMODE)switchBlock);

	if (!Hires.SetFormat(switchFormat))
	{
		ShowError("Invalid format (-f) for the selected machine (-m)");
	}

	if (!Hires.SetPaletteMode(switchPalette))
	{
		ShowError("Invalid palette mode (-p) for the selected machine (-m)");
	}

	//
	// Copy last parameters
	//
	std::string source_name=cArgumentParser.GetParameter(0);
	std::string dest_name=cArgumentParser.GetParameter(1);


	//
	// Initialize free image
	//
	FreeImage_Initialise();

	//
	// Try to load the source picture
	//
	ImageContainer sourceImage;
	if (!sourceImage.LoadPicture(source_name))
	{
		ShowError("Could not load the source picture");
	}

	//
	// Display informations about the picture
	//
	printf("\r\n Name of the source picture: '%s'",source_name.c_str());
	printf("\r\n Size: %dx%d",sourceImage.GetWidth(),sourceImage.GetHeight());
	printf("\r\n BPP: %d",sourceImage.GetDpp());

	int	color_count=sourceImage.GetPaletteSize();
	if (color_count)
	{
		// palettized
		printf("\r\n Color count: %d",color_count);
	}
	else
	{
		// true color
		printf("\r\n True color picture");
	}
	printf("\r\n");

	//
	// Convert to destination format
	//
	Hires.SetDebug(flag_testing);
	if (!Hires.Convert(sourceImage))
	{
		ShowError("Conversion failed");
	}

	if (!Hires.Save(output_format,dest_name,cTextFileGenerator))
	{
		ShowError("Saving failed");
	}

	//
	// Terminate free image
	//
	FreeImage_DeInitialise();

//	getch();

	return 0;
}

