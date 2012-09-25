
#define _CRT_SECURE_NO_WARNINGS

#include "FreeImage.h"

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "defines.h"

#include "common.h"

#include "hires.h"
#include "oric_converter.h"
#include "atari_converter.h"
#include "image.h"
#include "dithering.h"


PictureConverter::PictureConverter(MACHINE machine)	:
	m_machine(machine)
{
	m_dither	=DITHER_NONE;
	m_flag_debug=false;
	m_block_data="";
}

PictureConverter::~PictureConverter()
{
}

PictureConverter* PictureConverter::GetConverter(MACHINE machine)
{
	switch (machine)
	{
	case MACHINE_ORIC:
		return new OricPictureConverter();
		break;

	case MACHINE_ATARIST:
		return new AtariPictureConverter();
		break;

	default:
		// Invalid type
		return 0;
		break;
	}
}

void PictureConverter::SetDither(DITHER dither)		
{ 
	static bool flagDitherGenerated=false;
	if (!flagDitherGenerated)
	{
		GenerateDitherTable();
		flagDitherGenerated=true;
	}
	m_dither=dither; 
}


bool PictureConverter::Save(int output_format,const std::string& output_filename,TextFileGenerator& cTextFileGenerator)
{
	//
	// Save the bitmap to TAP format
	//
	//char name[_MAX_FNAME];
	//char ext[_MAX_EXT];
	//_splitpath(output_filename.c_str(),0,0,name,ext);

	//
	// Save the hir buffer
	//
	switch (output_format)
	{
	case DEVICE_FORMAT_BASIC_TAPE:
	case DEVICE_FORMAT_TAPE:
	case DEVICE_FORMAT_RAWBUFFER:
	case DEVICE_FORMAT_RAWBUFFER_WITH_XYHEADER:
	case DEVICE_FORMAT_RAWBUFFER_WITH_PALETTE:
		{
			long handle=open(output_filename.c_str(),O_TRUNC|O_BINARY|O_CREAT|O_WRONLY,S_IREAD|S_IWRITE);
			if (handle==-1)
			{
				printf("_openErrorwrite");	 //write
				exit(1);
			}

			SaveToFile(handle,output_format);

			close(handle);
			return true;
		}
		break;

	case DEVICE_FORMAT_SOURCE_C:
	case DEVICE_FORMAT_SOURCE_S:
	case DEVICE_FORMAT_SOURCE_BASIC:
		{
			std::string cDestString;
			cTextFileGenerator.ConvertData(cDestString,(unsigned char*)GetBufferData(),GetBufferSize());

			if (!SaveFile(output_filename.c_str(),cDestString.c_str(),cDestString.size()))
			{
				ShowError("Unable to save the destination file");
			}
			return true;
		}
		break;

	case DEVICE_FORMAT_PICTURE:
		{
			//
			// Convert the hires picture back to a RGB one
			//
			ImageContainer snapshot;
			if (!TakeSnapShot(snapshot))
			{
				ShowError("Unable to take TakeSnapShot");
			}

			if (!snapshot.SavePicture(output_filename))
			{
				ShowError("Unable to save the snapshot file");
			}
			return true;
		}
		break;

	default:
		break;
	}

	return false;
}

