

#include <assert.h>
#include <io.h>
#include <conio.h>
#include <set>

#include "common.h"

#include "freeimage.h"

#include "defines.h"
#include "getpixel.h"

#include "hires.h"
#include "image.h"

#include "atari_converter.h"		// For 'AtariClut', but I need a good abstraction for that


unsigned char* FreeImage_GetBitsRowCol(FIBITMAP *dib,int x,int y)
{
	unsigned int dy=FreeImage_GetHeight(dib);
	unsigned char *ptr_byte=FreeImage_GetScanLine(dib,dy-y-1);
	ptr_byte+=x*3;
	return ptr_byte;
}


// ============================================================================
//
//		                             ImageContainer
//
// ============================================================================

ImageContainer::ImageContainer() :
	m_pBitmap(0)
{
}

ImageContainer::ImageContainer(const ImageContainer& otherImage) :
	m_pBitmap(0)
{
	if (otherImage.m_pBitmap && (&otherImage!=this))
	{
		m_pBitmap=FreeImage_Clone(otherImage.m_pBitmap);
	}	
}

ImageContainer::~ImageContainer()
{
	Clear();
}


void ImageContainer::Clear()
{
	if (m_pBitmap)
	{
		FreeImage_Unload(m_pBitmap);
	}
}

bool ImageContainer::Allocate(unsigned int width,unsigned int height,unsigned int bpp)
{
	// Free eventual data
	Clear();

	m_pBitmap=FreeImage_Allocate(width,height,bpp);
	if (m_pBitmap)
	{
		return true;
	}
	return false;
}



unsigned int ImageContainer::GetWidth() const
{
	if (m_pBitmap)
	{
		return FreeImage_GetWidth(m_pBitmap);
	}
	return 0;
}


unsigned int ImageContainer::GetHeight() const
{
	if (m_pBitmap)
	{
		return FreeImage_GetHeight(m_pBitmap);
	}
	return 0;
}

unsigned int ImageContainer::GetDpp() const
{
	if (m_pBitmap)
	{
		return FreeImage_GetBPP(m_pBitmap);
	}
	return 0;
}

unsigned int ImageContainer::GetPaletteSize() const
{
	if (m_pBitmap)
	{
		return FreeImage_GetColorsUsed(m_pBitmap);
	}
	return 0;
}


bool ImageContainer::LoadPicture(const std::string& fileName)
{
	// Free any previous existing picture - if any
	Clear();

	FIBITMAP *dib = NULL;

	// check the file signature and deduce its format
	// (the second argument is currently not used by FreeImage)
	FREE_IMAGE_FORMAT fif=FreeImage_GetFileType(fileName.c_str(),0);
	if (fif==FIF_UNKNOWN)
	{
		// no signature ?
		// try to guess the file format from the file extension
		fif=FreeImage_GetFIFFromFilename(fileName.c_str());
	}
	// check that the plugin has reading capabilities ...
	if ((fif != FIF_UNKNOWN) && FreeImage_FIFSupportsReading(fif))
	{
		// ok, let's load the file
		dib=FreeImage_Load(fif,fileName.c_str(),FIT_BITMAP);
		if (!dib)
		{
			printf("\r\n Unable to load specified picture.");
			//exit(1);
			return false;
		}

		FIBITMAP *converted_dib=FreeImage_ConvertTo24Bits(dib);
		FreeImage_Unload(dib);
		dib=converted_dib;
		if (!dib)
		{
			printf("\r\n Unable to convert the picture data to a suitable format.");
			//exit(1);
			return false;
		}
	}
	else
	{
		printf("\r\n Unsupported load file format.");
		//exit(1);
		return false;
	}
	m_pBitmap=dib;
	return true;
}


bool ImageContainer::SavePicture(const std::string& fileName) const
{
	if (!m_pBitmap)
	{
		return false;
	}
	FREE_IMAGE_FORMAT fif=FreeImage_GetFIFFromFilename(fileName.c_str());
	if ((fif==FIF_UNKNOWN) || (!FreeImage_FIFSupportsWriting(fif)))
	{
		printf("\r\n Unsupported save file format.");
		//exit(1);
		return false;
	}

	BOOL bSuccess=FreeImage_Save(fif,m_pBitmap,fileName.c_str(),0);
	if (!bSuccess)
	{
		printf("\r\n Unable to save '%s'.",fileName.c_str());
		//exit(1);
		return false;
	}
	return true;
}


void ImageContainer::WriteColor(const RgbColor& rgb,int x,int y)
{
	if (m_pBitmap)
	{
		if (x<0)	return;
		if (y<0)	return;

		int dx=FreeImage_GetWidth(m_pBitmap);
		int dy=FreeImage_GetHeight(m_pBitmap);

		if (x>=dx)	return;
		if (y>=dy)	return;

		BYTE *ptr_byte=FreeImage_GetBitsRowCol(m_pBitmap,x,y);

		*ptr_byte++=rgb.m_blue;
		*ptr_byte++=rgb.m_green;
		*ptr_byte++=rgb.m_red;
	}
}

RgbColor ImageContainer::ReadColor(int x,int y)	const
{
	RgbColor rgb;
	if (m_pBitmap && (x>=0) && (y>=0))
	{
		int dx=FreeImage_GetWidth(m_pBitmap);
		int dy=FreeImage_GetHeight(m_pBitmap);

		if ( (x<dx)	&& (y<dy) )
		{
			BYTE *ptr_byte=FreeImage_GetBitsRowCol(m_pBitmap,x,y);

			//unsigned rm=FreeImage_GetRedMask(m_pBitmap);
			//unsigned gm=FreeImage_GetGreenMask(m_pBitmap);
			//unsigned bm=FreeImage_GetBlueMask(m_pBitmap);

			rgb.m_blue	=*ptr_byte++;
			rgb.m_green	=*ptr_byte++;
			rgb.m_red	=*ptr_byte++;
		}
	}
	return rgb;
}


bool ImageContainer::ConvertToGrayScale()
{
	int dx=FreeImage_GetWidth(m_pBitmap);
	int dy=FreeImage_GetHeight(m_pBitmap);

	for (int y=0;y<dy;y++)
	{
		for (int x=0;x<dx;x++)
		{
			RgbColor rgb=ReadColor(x,y);
			rgb.m_red=(rgb.m_red+rgb.m_green+rgb.m_blue)/3;
			rgb.m_green=rgb.m_red;
			rgb.m_blue =rgb.m_red;
			WriteColor(rgb,x,y);
		}
	}
	return true;
}


#include "shifter_color.h"

bool ImageContainer::ReduceColorDepth(const AtariClut* pClut)
{
	int dx=FreeImage_GetWidth(m_pBitmap);
	int dy=FreeImage_GetHeight(m_pBitmap);

	for (int y=0;y<dy;y++)
	{
		for (int x=0;x<dx;x++)
		{
			RgbColor rgb=ReadColor(x,y);
			ShifterColor shifterColor(rgb);
			rgb=shifterColor.GetRgb();
			WriteColor(rgb,x,y);
		}
	}

	// Then convert to 16 colors
	RGBQUAD* pReservedPalette=0;
	std::vector<RGBQUAD> reservedPalette;
	if (pClut)
	{
		pClut->GetColors(reservedPalette);
		if (!reservedPalette.empty())
		{
			pReservedPalette=&reservedPalette[0];
		}
	}

	FIBITMAP *dib8  = FreeImage_ColorQuantizeEx(m_pBitmap,FIQ_NNQUANT,16,reservedPalette.size(),pReservedPalette);
	FIBITMAP *dib24 = FreeImage_ConvertTo24Bits(dib8);
	FreeImage_Unload(dib8);
	FreeImage_Unload(m_pBitmap);
	m_pBitmap=dib24;
	return true;
}

bool ImageContainer::ReduceColorDepthPerScanline(const std::map<int,AtariClut>* pCluts)
{
	unsigned int dx=FreeImage_GetWidth(m_pBitmap);
	unsigned int dy=FreeImage_GetHeight(m_pBitmap);

	for (unsigned int y=0;y<dy;y++)
	{
		//_BREAK_IF_(y==5);

		// Convert the current line
		for (unsigned int x=0;x<dx;x++)
		{
			RgbColor rgb=ReadColor(x,y);
			ShifterColor shifterColor(rgb);
			rgb=shifterColor.GetRgb();
			WriteColor(rgb,x,y);
		}

		// Then convert to 16 colors
		RGBQUAD* pReservedPalette=0;
		std::vector<RGBQUAD> reservedPalette;
		if (pCluts)
		{
			std::map<int,AtariClut>::const_iterator it=pCluts->find(y);
			if (it!=pCluts->end())
			{
				const AtariClut& clut=it->second;

				clut.GetColors(reservedPalette);
				if (!reservedPalette.empty())
				{
					pReservedPalette=&reservedPalette[0];
				}
			}
		}

		// Quantize the current line to 16 colors (Atari multi-palette image)
		FIBITMAP *lineCopy = FreeImage_Copy(m_pBitmap,0,y,dx,y+1);
		assert(FreeImage_GetWidth(lineCopy)==dx);
		assert(FreeImage_GetHeight(lineCopy)==1);

		// Then convert to 16 colors
		FREE_IMAGE_QUANTIZE quantize;
		if (pReservedPalette)	quantize=FIQ_NNQUANT;	// FIQ_WUQUANT is better than FIQ_NNQUANT in this particular setup... but it fails handling correctly the reserved palettes...
		else					quantize=FIQ_WUQUANT;	// FIQ_WUQUANT is better than FIQ_NNQUANT in this particular setup...

		FIBITMAP *dib8  = FreeImage_ColorQuantizeEx(lineCopy,quantize,16,reservedPalette.size(),pReservedPalette);	
		FIBITMAP *dib24 = FreeImage_ConvertTo24Bits(dib8);
		{
			// Check that we have 16 colors max... starting to doubt it
			std::set<RgbColor>	colorMap;
			for (unsigned int x=0;x<dx;x++)
			{
				RgbColor rgb;
				BYTE *ptr_byte=FreeImage_GetBitsRowCol(dib24,x,0);
				rgb.m_blue	=*ptr_byte++;
				rgb.m_green	=*ptr_byte++;
				rgb.m_red	=*ptr_byte++;
				colorMap.insert(rgb);
			}
			//_BREAK_IF_(colorMap.size()>16);
		}
		FreeImage_Paste(m_pBitmap,dib24,0,y,256);	// Combine mode
		FreeImage_Unload(dib8);
		FreeImage_Unload(dib24);
		FreeImage_Unload(lineCopy);
	}
	return true;
}


bool ImageContainer::CreateFromImage(const ImageContainer& otherImage,unsigned int x,unsigned int y,unsigned int width,unsigned int height)
{
	if (!otherImage.m_pBitmap)
	{
		assert(otherImage.m_pBitmap);
		return false;
	}

	FIBITMAP* pBitmap=FreeImage_Copy(otherImage.m_pBitmap,x,y,x+width,y+height);
	if (!pBitmap)
	{
		return false;
	}
	Clear();
	m_pBitmap=pBitmap;
	return true;
}




