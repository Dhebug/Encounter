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
    #ifdef _WIN32
    "{ApplicationName} - Version {ApplicationVersion} - ("__DATE__" / "__TIME__") - This program is a part of the OSDK\r\n"
    #else
    "{ApplicationName} - Version {ApplicationVersion} - (Missing Date) - This program is a part of the OSDK\r\n"
    #endif
    "\r\n"
    "Author:\r\n"
    "  (c) 2002-2015 Pointier Mickael \r\n"
    "\r\n"
    "Usage:\r\n"
    "  {ApplicationName} [switches] <source picture> <destination file>\r\n"
    "\r\n"
    "Switches:\r\n"
    " -mn   Machine\r\n"
    "       -m0 => Oric [default]\r\n"
    "       -m1 => Atari ST\r\n"
    "       -m2 => Limitless\r\n"
    "\r\n"
    " -fn   Rendering format (machine dependent)\r\n"
    "       -Oric:\r\n"
    "         -f0 => to hires monochrom format [default]\r\n"
    "         -f0z => to hires monochrom format (do not set bit 6) *** Not working in this version ***\r\n"
    "         -f1 => precolored picture\r\n"
    "         -f2 => RVB conversion\r\n"
    "         -f3 => Twilight masks\r\n"
    "         -f4 => RB conversion\r\n"
    "         -f5 => CHAR generator\r\n"
    "         -f6 => Sam method (Img2Oric)\r\n"
    "         -f7 => AIC encoding\r\n"
    "       -Atari ST:\r\n"
    "         -f0 => Single palette format [default]\r\n"
    "         -f1 => Multi palette format\r\n"
    "         -f2 => Monochrome format\r\n"
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
    " -sn   Swap mode\r\n"
    "       -s0 => no swapping [default]\r\n"
    "       -s1 => generate two pictures instead of one, designed to be swapped each frame\r\n"
    "\r\n"
    " -an   Alpha mode\r\n"
    "       -a0 => no transparency [default]\r\n"
    "       -a1 => encode alpha as zeroes (only in f0 and f7 modes)\r\n"
    "\r\n"
    " -on   Output file format\r\n"
    "       -o0 => TAP (with a BASIC program that switch to HIRES then load)\r\n"
    "       -o1 => TAP (with a tape header that load in 0xa000)\r\n"
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
    "\r\n"
    " -un   Update check.\r\n"
    "       -u0 => Do not check if files are up to date [default]\r\n"
    "       -u1 => Perform a date check on the files and only update if needed\r\n"
    "\r\n"
    " -vn   Verbosity.\r\n"
    "       -v0 => Silent [default]\r\n"
    "       -v1 => Shows information about what PictConv is doing\r\n"
    );

#ifdef _DEBUG
  int failureCount=RunUnitTests();
  if (failureCount)
  {
    ShowError("UnitTests failed.");
  }
#endif

  DEVICE_FORMAT	output_format=DEVICE_FORMAT_BASIC_TAPE;
  //bool flag_basic_loader=true;
  bool	flag_testing   = false;
  bool  flagUpdateTest = false;
  bool  flagVerbosity  = false;

  TextFileGenerator textFileGenerator;
  textFileGenerator.SetLabel("_LabelPicture");
  textFileGenerator.SetDataSize(1);											// Byte format
  textFileGenerator.SetEndianness(TextFileGenerator::_eEndianness_Little);	// Little endian

  int switchMachine=0;		// Default 0=oric
  int switchFormat=0;
  int switchDither=0;
  int switchPalette=0;		// Default 0=automatically generate the palette
  int switchBlock=0;		// Default 0=no block mode (full picture)
  int switchAlpha=0;            // Default 0=no transparency
  int switchSwap=0;             // Default 0=no swapping

  ArgumentParser argumentParser(argc,argv);

  while (argumentParser.ProcessNextArgument())
  {
    if (argumentParser.IsSwitch("-f"))
    {
      switchFormat=argumentParser.GetIntegerValue(0);
    }
    else
    if (argumentParser.IsSwitch("-m"))
    {
      //format: [-m]
      //	0 => Oric
      // 	1 => Atari ST
      //        2 => Limitless
      switchMachine=argumentParser.GetIntegerValue(0);
    }
    else
    if (argumentParser.IsSwitch("-b"))
    {
      //block mode: [-b]
      //	0 => No blocs (simple picture)
      // 	1 => Blocks enabled
      switchBlock=argumentParser.GetIntegerValue(0);
    }
    else
    if (argumentParser.IsSwitch("-a"))
    {
      //alpha mode: [-a]
      //	0 => No transparency
      // 	1 => Encode full transparent alpha as holes saved as zeroes. Or something like that at least.
      switchAlpha=argumentParser.GetIntegerValue(0);
    }
    else
    if (argumentParser.IsSwitch("-s"))
    {
      //swap mode: [-s]
      //	0 => no swapping [default]
      // 	1 => generate two pictures instead of one, designed to be swapped each frame
      switchSwap=argumentParser.GetIntegerValue(0);
    }
    else
    if (argumentParser.IsSwitch("-p"))
    {
      //format: [-m]
      //	0 => Get the palette from the picture
      // 	1 => The last line of the picture contains the palette
      //  2 => The last pixels of each line contains the palette for the line
      switchPalette=argumentParser.GetIntegerValue(0);
    }
    else
    if (argumentParser.IsSwitch("-n"))
    {
      //format: [-n]
      textFileGenerator.SetValuesPerLine(argumentParser.GetIntegerValue(16));
    }
    else
    if (argumentParser.IsSwitch("-d"))
    {
      //dithering: [-d]
      //	0 => none
      //	1 => alternate (01010101)
      //	2 => ordered dither
      //	3 => riemersma
      //	4 => floyd steinberg
      //  5 => alternate inversed (10101010)
      switchDither=argumentParser.GetIntegerValue(0);
    }
    else
    if (argumentParser.IsSwitch("-o"))
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
      output_format=(DEVICE_FORMAT)argumentParser.GetIntegerValue(DEVICE_FORMAT_BASIC_TAPE);
      switch (output_format)
      {
      case DEVICE_FORMAT_SOURCE_C:
        textFileGenerator.SetFileType(TextFileGenerator::eLanguage_C);
        if (*argumentParser.GetRemainingStuff())
        {
          // Keep this as a label value
          textFileGenerator.SetLabel(argumentParser.GetRemainingStuff());
        }
        break;

      case DEVICE_FORMAT_SOURCE_S:
        textFileGenerator.SetFileType(TextFileGenerator::eLanguage_Assembler);
        if (*argumentParser.GetRemainingStuff())
        {
          // Keep this as a label value
          textFileGenerator.SetLabel(argumentParser.GetRemainingStuff());
        }
        break;

      case DEVICE_FORMAT_SOURCE_BASIC:
        textFileGenerator.SetFileType(TextFileGenerator::eLanguage_BASIC);
        textFileGenerator.SetLabel("Generated by PictConv");
        if (argumentParser.GetSeparator(":"))
        {
          textFileGenerator.SetLineNumber(argumentParser.GetIntegerValue(10));
          if (argumentParser.GetSeparator(":"))
          {
            textFileGenerator.SetIncrementLineNumber(argumentParser.GetIntegerValue(10));
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
    if (argumentParser.IsSwitch("-t"))
    {
      //testing: [-t]
      //	0 => disabled
      //	1 => enabled
      flag_testing=argumentParser.GetBooleanValue(true);
    }
    else
    if (argumentParser.IsSwitch("-u"))
    {
      //testing: [-u]
      //	0 => no update check
      //	1 => do update check
      flagUpdateTest=argumentParser.GetBooleanValue(true);
    }
    else
    if (argumentParser.IsSwitch("-v"))
    {
      //testing: [-v]
      //	0 => silent
      //	1 => verbose
      flagVerbosity=argumentParser.GetBooleanValue(true);
    }
  }

  if (argumentParser.GetParameterCount()!=NB_ARG)
  {
    ShowError(0);
  }

  //
  // Set and validate the parameters
  //	0 => Oric
  // 	1 => Atari ST
  // 	2 => Limitless
  //
  PictureConverter* pictureConverter=PictureConverter::GetConverter((PictureConverter::MACHINE)switchMachine);
  if (!pictureConverter)
  {
    ShowError("Can't create the required converter - Type is unknown");
  }
  PictureConverter& Hires(*pictureConverter);

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

  if (!Hires.SetTransparencyMode(switchAlpha))
  {
    ShowError("Invalid alpha mode (-a) for the selected machine (-m)");
  }

  if (!Hires.SetSwapMode(switchSwap))
  {
    ShowError("Invalid swap mode (-s) for the selected machine (-m)");
  }


  //
  // Copy last parameters
  //
  std::string source_name=argumentParser.GetParameter(0);
  std::string dest_name=argumentParser.GetParameter(1);

  //
  // Eventual time stamp check
  //
  if ( (!flagUpdateTest) || (flagUpdateTest && !IsUpToDate(source_name,dest_name)) )
  {
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
    if (flagVerbosity)
    {
      printf("\r\n Name of the source picture: '%s'",source_name.c_str());
      printf("\r\n Size: %dx%d",sourceImage.GetWidth(),sourceImage.GetHeight());
      printf("\r\n BPP: %d",sourceImage.GetDpp());

      int color_count=sourceImage.GetPaletteSize();
      if (color_count)
      {
        // palletized
        printf("\r\n Color count: %d",color_count);
      }
      else
      {
        // true color
        printf("\r\n True color picture");
      }
      printf("\r\n");
    }

    //
    // Convert to destination format
    //
    Hires.SetDebug(flag_testing);
    if (!Hires.Convert(sourceImage))
    {
      ShowError("Conversion failed");
    }

    if (!Hires.Save(output_format,dest_name,textFileGenerator))
    {
      ShowError("Saving failed");
    }

    //
    // Terminate free image
    //
    FreeImage_DeInitialise();
  }

  //	getch();

  return 0;
}

