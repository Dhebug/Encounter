/*==============================================================================

							 PictConv

==[Description]=================================================================

==[History]=====================================================================

==[ToDo]========================================================================

* Upgrade to a more recent version of FreeImage

==============================================================================*/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <fcntl.h>
#include <io.h>
#include <string.h>
#include <stdlib.h>
#include <conio.h>

#include <sys/types.h>
#include <sys/stat.h>

#include "infos.h"

#include "common.h"

#include "FreeImage.h"

#include "defines.h"
#include "getpixel.h"
#include "hires.h"
#include "dithering.h"


// ----------------------------------------------------------

/*

Debug:
======
-f0 pics\sega_240x200_monochrom.png pics\sega.tap
-f2 pics\sega_240x200_hicolor.png pics\sega.tap


  Usage: PictConv [format] [source_name] [destination_name]


Example of usage:

  // Monochrom conversion to TAPE format
  PictConv -f0 -o0:0xa000 source.gif destination.tap

  // Color conversion
  PictConv -f2 -o0:0xa000 source.gif destination.tap





//======================================================

size: [-s]
	0 => keep size
	1 => resize
	2 => resample
	//fullscreen, bigger than screen, small window, etc...

bloc: [-b]
	preshifting
	and/or masks
	list of blocs






Colors suffix:
==============

D Dark
R Red
G Green
Y Yellow
B Blue
M Mangenta
C Cyan
W White

Methods of dithering:
=====================

RGB mode:
We can mix the three scanlines, and dither them component per
component, in order to get a really _cool_ effect.



//- ---------
-d2 -f2 pics\480x400.png pics\480x400.tap

-


// Kid picture:
-m1 -d0 -o7 -f5 C:\sources\atari\Dycp\Pics\fullscreen_416x276.png C:\_emul_\atari\_mount_\genst\DEVPAC\full.kid

// 1985-2005 picture:
-m1 -d0 -o7 -f5 C:\sources\atari\Dycp\Pics\1985-2005.png C:\_emul_\atari\_mount_\genst\DEVPAC\85-2005.pi1

// Proteque Alien picture:
-m1 -d0 -o7 -f5 C:\sources\atari\Dycp\Pics\alien_atari.png C:\_emul_\atari\_mount_\genst\DEVPAC\alien.pi1

// Creators logo:
-m1 -d0 -o7 -f5 C:\sources\atari\Dycp\Pics\creators.png C:\_emul_\atari\_mount_\genst\DEVPAC\creators.pi1

-m1 -d0 -o7 -f5 C:\sources\atari\Dycp\Pics\creators.png C:\_emul_\atari\_mount_\genst\DEVPAC\creators.pi1



-m0 -d0 -o4 -f3 pics\em_SideCabinet.tif pics\iso.s
*/













//
// Contains an hexa dump of the following
// auto-loadable BASIC program:
//
// 10 HIRES
// 20 CLOAD""
//
unsigned char	BasicLoader[]=
{
	0x16,0x16,0x16,0x24,0x00,0xff,0x00,0xc7,0x05,0x11,0x05,0x01,0x00,0x48,0x49,0x52,
	0x4c,0x4f,0x41,0x44,0x00,0x07,0x05,0x0a,0x00,0xa2,0x00,0x0f,0x05,0x14,0x00,0xb6,
	0x22,0x22,0x00,0x00,0x00,0x55
};





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
		"{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
		"\r\n"
		"Author:\r\n"
		"  (c) 2002-2006 Pointier Mickael \r\n"
		"\r\n"
		"Usage:\r\n"
		"  {ApplicationName} [switches] <source picture> <destination file>\r\n"
		"\r\n"
		"Switches:\r\n"
		" -fn   Rendering format\r\n"
		"       -f0 => to hires monochrom format\r\n"
		"       -f0z => to hires monochrom format (do not set bit 6)\r\n"
		"       -f1 => precolored picture\r\n"
		"       -f2 => RVB conversion\r\n"
		"       -f3 => Twilight masks\r\n"
		"       -f4 => RB conversion\r\n"
		"       -f5 => Shifter format (Atari ST)\r\n"
		"\r\n"
		" -mn   Machine\r\n"
		"       -m0 => Oric\r\n"
		"       -m1 => Atari ST\r\n"
		"\r\n"
		" -dn   Dithering mode\r\n"
		"       -d0 => no dithering\r\n"
		"       -d1 => alternate (01010101) dithering\r\n"
		"       -d2 => ordered dither\r\n"
		"       -d3 => riemersma\r\n"
		"       -d4 => floyd steinberg\r\n"
		"\r\n"
		" -on   Output file format\r\n"
		"       -o0 => TAP (with a header that load in 0xa000)\r\n"
		"       -o1 => TAP (with a BASIC program that switch to HIRES then load)\r\n"
		"       -o2 => RAW data\r\n"
		"       -o3[label] => .C format with labels and .h for 'extern' declaration\r\n"
		"       -o4[label] => .S format with labels and .h for 'extern' declaration\r\n"
		"       -o5 => Picture format (PNG, BMP, ...)\r\n"
		"       -o6 => X+Y+RAW\r\n"
		"       -o7 => RAW Palette\r\n"
		"       -o8[line:step] => .BAS format \r\n"
		"\r\n"
		" -tn   Testing mode\r\n"
		"       -t0 => Testing disabled\r\n"
		"       -t1 => Testing enabled\r\n"
		"\r\n"
		" -nn   Defines the number of entries per line.\r\n"
		"       -n16 => Output 16 values each line\r\n"
		"       -n40 => Output 40 values each line\r\n"
		);

	DEVICE_FORMAT	output_format=DEVICE_FORMAT_BASIC_TAPE;
	bool			flag_header=true;
	bool			flag_basic_loader=true;
	bool			flag_testing=false;

	TextFileGenerator cTextFileGenerator;
	cTextFileGenerator.SetLabel("_LabelPicture");
	cTextFileGenerator.SetDataSize(1);											// Byte format
	cTextFileGenerator.SetEndianness(TextFileGenerator::_eEndianness_Little);	// Little endian

	CHires	Hires;

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
			Hires.set_format((CHires::FORMAT)cArgumentParser.GetIntegerValue(CHires::FORMAT_MONOCHROM));
			if (Hires.get_format()==CHires::FORMAT_MONOCHROM)
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
		}
		else
		if (cArgumentParser.IsSwitch("-m"))
		{
			//format: [-m]
			//	0 => Oric
			// 	1 => Atari ST
			Hires.set_machine((CHires::MACHINE)cArgumentParser.GetIntegerValue(CHires::MACHINE_ORIC));
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
			Hires.set_dither((CHires::DITHER)cArgumentParser.GetIntegerValue(CHires::DITHER_NONE));
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
			//  7 => Raw palette mode
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
			case DEVICE_FORMAT_RAW:
			case DEVICE_FORMAT_PICTURE:
			case DEVICE_FORMAT_RAW_XY:
			case DEVICE_FORMAT_RAW_PALETTE:
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
	char	name[_MAX_FNAME];
	char	ext[_MAX_EXT];
	_splitpath(source_name.c_str(),0,0,name,ext);

	FIBITMAP *dib = NULL;

	// check the file signature and deduce its format
	// (the second argument is currently not used by FreeImage)
	FREE_IMAGE_FORMAT fif=FreeImage_GetFileType(source_name.c_str(),0);
	if (fif==FIF_UNKNOWN)
	{
		// no signature ?
		// try to guess the file format from the file extension
		fif=FreeImage_GetFIFFromFilename(source_name.c_str());
	}
	// check that the plugin has reading capabilities ...
	if ((fif != FIF_UNKNOWN) && FreeImage_FIFSupportsReading(fif))
	{
		// ok, let's load the file
		dib=FreeImage_Load(fif,source_name.c_str(),FIT_BITMAP);
		if (!dib)
		{
			printf("\r\n Unable to load specified picture.");
			exit(1);
		}

		FIBITMAP *converted_dib=FreeImage_ConvertTo24Bits(dib);
		FreeImage_Unload(dib);
		dib=converted_dib;
		if (!dib)
		{
			printf("\r\n Unable to convert the picture data to a suitable format.");
			exit(1);
		}
	}
	else
	{
		printf("\r\n Unsupported load file format.");
		exit(1);
	}

	//
	// Display informations about the picture
	//
	printf("\r\n Name of the source picture: '%s'",source_name.c_str());
	printf("\r\n Size: %dx%d",FreeImage_GetWidth(dib),FreeImage_GetHeight(dib));
	printf("\r\n BPP: %d",FreeImage_GetBPP(dib));


	int	color_count=FreeImage_GetColorsUsed(dib);
	if (color_count)
	{
		// paletized
		printf("\r\n Color count: %d",FreeImage_GetColorsUsed(dib));
	}
	else
	{
		// true color
		printf("\r\n True color picture");
	}
	printf("\r\n");

	//
	// Free size pictures are not allowed in COLORED mode
	//
	switch (Hires.get_machine())
	{
	case CHires::MACHINE_ORIC:
		if ( (Hires.get_format()==CHires::FORMAT_COLORED) &&
			 ((FreeImage_GetWidth(dib)%6)==0) &&
			 (FreeImage_GetWidth(dib)>240))
		{
			printf("\r\n Colored pictures should be at most 240 pixels wide, and multiple of 6 pixel wide.");
			exit(1);
		}
		break;

	case CHires::MACHINE_ATARIST:
		break;

	default:
		break;
	}

	//
	// Test if the source picture is valid, considering the
	// requested format
	//
	Hires.set_buffer_size(FreeImage_GetWidth(dib),FreeImage_GetHeight(dib));

	GenerateDitherTable();



	//
	// Convert to destination format
	//
	Hires.set_debug(flag_testing);
	Hires.convert(dib);


	//
	// Save the bitmap to TAP format
	//
	//
	// Save the hir buffer
	//
	switch (output_format)
	{
	case DEVICE_FORMAT_BASIC_TAPE:
	case DEVICE_FORMAT_TAPE:
	case DEVICE_FORMAT_RAW:
	case DEVICE_FORMAT_RAW_XY:
	case DEVICE_FORMAT_RAW_PALETTE:
		{
			long handle=_open(dest_name.c_str(),_O_TRUNC|O_BINARY|O_CREAT|O_WRONLY,_S_IREAD|_S_IWRITE);
			if (!handle)
			{
				printf("_openErrorwrite");	 //write
				exit(1);
			}

			switch (output_format)
			{
			case DEVICE_FORMAT_RAW_XY:
				{
					unsigned char x=Hires.get_buffer_width();
					unsigned char y=Hires.get_buffer_height();

				   _write(handle,&x,1);
				   _write(handle,&y,1);
				}
				break;

			case DEVICE_FORMAT_RAW_PALETTE:
				Hires.save_clut(handle);
				break;

			case DEVICE_FORMAT_RAW:
				// No header for raw
				break;

			case DEVICE_FORMAT_BASIC_TAPE:
				_write(handle,BasicLoader,sizeof(BasicLoader));
			default:	// Fall trough
				if (flag_header)
				{
					Hires.save_header(handle,0xa000);
					//_write(handle,Header,13);
					_write(handle,name,strlen(name)+1);
				}
				break;
			}

			Hires.save(handle);

			_close(handle);
		}
		break;

	case DEVICE_FORMAT_SOURCE_C:
	case DEVICE_FORMAT_SOURCE_S:
	case DEVICE_FORMAT_SOURCE_BASIC:
		{
			std::string cDestString;
			cTextFileGenerator.ConvertData(cDestString,(unsigned char*)Hires.get_buffer_data(),Hires.get_buffer_size());

			if (!SaveFile(dest_name.c_str(),cDestString.c_str(),cDestString.size()))
			{
				ShowError("Unable to save the destination file");
			}
		}
		break;

	case DEVICE_FORMAT_PICTURE:
		{
			//
			// Convert the hires picture back to a RGB one
			//
			Hires.snapshot(dib);

			//
			// Save the picture to the specified format
			//
			char	name[_MAX_FNAME];
			char	ext[_MAX_EXT];
			_splitpath(dest_name.c_str(),0,0,name,ext);

			FREE_IMAGE_FORMAT fif=FreeImage_GetFileType(dest_name.c_str(),0);
			if ((fif==FIF_UNKNOWN) || (!FreeImage_FIFSupportsWriting(fif)))
			{
				printf("\r\n Unsupported save file format.");
				exit(1);
			}

			BOOL bSuccess=FreeImage_Save(fif,dib,dest_name.c_str(),0);
			if (!bSuccess)
			{
				printf("\r\n Unable to save '%s'.",dest_name.c_str());
				exit(1);
			}
		}
		break;

	default:
		break;
	}



	//
	// Free the source picture
	//
	FreeImage_Unload(dib);

	//
	// Terminate free image
	//
	FreeImage_DeInitialise();

	return 0;
}














/*
I'm trying to convert various pictures to my own binary format (used on an old 8 bit computer called Oric), but I'm not sure of the way I can get the actual bitmap data.

It looks like if FreeImage_GetColorsUsed returns 0, then it's a true color picture, else it has a clut (paletised).

If it's paletized, I can get the colors as an array of RGBQUAD, using the FreeImage_GetPalette function, but how can I access the "pixels" themselves ? And how are they organised ? As single bits (for a monochrome picture), or taking whole bytes ?

Same question for non paletizef pictures. If
it's a 24bpp picture, is it made of RGBQUADS (32 bits, then), or of RGB,RGB,RGB tripplets ?

Thanks in advance.
===========================
You are right that FreeImage_GetColorsUsed returns 0 if the bitmap contains no palette. It returns the maximum number of colors the palette can store (2, 16 or 256) if there is one.

You can get to the bitmap bits of the bitmap via the function FreeImage_GetBits. The way the data is organised differs for each bitmap type:

1 bit: each bit in the bitmap represents a pixel. If the bit is 0, the first entry in the palette is used, otherwise the second.

4 bit: each nibble represents a pixel. The nibble is an index in the palette.

8 bit: each byte represents a pixel. The byte is an index in the palette.

16 bit: each word represents a pixel. The word is an actual pixel value and not a palette entry. The way the 16 bits are layout can be obtained using FreeImage_GetRedMask(), FreeImage_GetBlueMask() and FreeImage_GetGreenMask(). The rgb components are always stored backwards (first blue, then green, then red)

24 bit: the bitmap is formed out of RGB triplets. Again, first blue, then green, then red.

32 bit: the bitmap is formed out of RGBA triplets. First blue, then green, then red, then the alpha value.

In all cases each scanline is padded to be dividable by four bytes. This means that if you have a 1-bit bitmap with dimensions being 1x1, the line will take a whole DWORD and not only one byte. This is done that way for performance reasons.

*/

