
#define _CRT_SECURE_NO_WARNINGS

#include <assert.h>
#include <string.h>
#include <stdio.h>

#include <iostream>

#include "common.h"

#include "defines.h"
#include "getpixel.h"

#include "atari_converter.h"
#include "shifter_color.h"

#include "image.h"

#include "FreeImage.h"

//#define ENABLE_PALETTE_TRACKING 


// ============================================================================
//
//		                         AtariClut
//
// ============================================================================

int AtariClut::convert_pixel_shifter(const ShifterColor& color)
{
	assert(m_clut_index_to_color.size()==m_clut_color_to_index.size());
	std::map<ShifterColor,int>::iterator it=m_clut_color_to_index.find(color);
	if (it==m_clut_color_to_index.end())
	{
		// Not found - need to search the first free slot...
		//int index=m_clut_color_to_index.size();
		for (int index=0;index<16;index++)
		{
			std::map<int,ShifterColor>::iterator it=m_clut_index_to_color.find(index);
			if (it==m_clut_index_to_color.end())
			{
				//assert(index<16);
				m_clut_color_to_index[color]=index;
				m_clut_index_to_color[index]=color;
				assert(m_clut_color_to_index[m_clut_index_to_color[index]]==index);
				assert(m_clut_index_to_color[m_clut_color_to_index[color]]==color);
				assert(m_clut_index_to_color.size()==m_clut_color_to_index.size());
				return index;
			}
		}
		// Color not found, we have a problem... like we have more than 16 colors Oo
		assert(0);
		return 0;	// assert ?
	}
	else
	{
		// Return existing index
		return it->second;
	}
}

int AtariClut::convert_pixel_shifter(const RgbColor& rgb)
{
	ShifterColor color(rgb);
	return convert_pixel_shifter(color);
}

void AtariClut::SetColor(const ShifterColor& color,int index)
{
	assert(index<16);

	m_clut_color_to_index[color]=index;
	m_clut_index_to_color[index]=color;
}

void AtariClut::SetColor(const RgbColor& rgb,int index)
{
	ShifterColor color(rgb);
	SetColor(color,index);
}



// The idea is to reorder the colors in a way that limits the differences
// from one clut to another. An obvious fix is to make the identical colors
// stay on the same index.
void AtariClut::Reorder(AtariClut& baseClut)
{
#if 1
	AtariClut newClut;

	// Code that computes the error between colors and choose the closest one
	std::map<int,ShifterColor>::iterator it=baseClut.m_clut_index_to_color.begin();
	while (it!=baseClut.m_clut_index_to_color.end())
	{
		ShifterColor baseColor=it->second;

		std::map<int,ShifterColor>::iterator foundIt=m_clut_index_to_color.end();
		int foundDifference=0;

		std::map<int,ShifterColor>::iterator searchIt=m_clut_index_to_color.begin();
		while (searchIt!=m_clut_index_to_color.end())
		{
			ShifterColor searchColor=searchIt->second;

			int difference=baseColor.ComputeDifference(searchColor);
			if ((foundIt==m_clut_index_to_color.end()) || (difference<=foundDifference))
			{
				foundIt			=searchIt;
				foundDifference =difference;
			}
			++searchIt;
		}

		if (foundIt!=m_clut_index_to_color.end())
		{
			// Found a match
			ShifterColor foundColor=foundIt->second;
			newClut.convert_pixel_shifter(foundColor);

			std::map<ShifterColor,int>::iterator deleteIt=m_clut_color_to_index.find(foundColor);
			assert(deleteIt!=m_clut_color_to_index.end());

			m_clut_index_to_color.erase(foundIt);
			m_clut_color_to_index.erase(deleteIt);
		}

		++it;
	}
	m_clut_index_to_color.swap(newClut.m_clut_index_to_color);
	m_clut_color_to_index.swap(newClut.m_clut_color_to_index);
#else
	// Code that performs exact match
	std::map<ShifterColor,int>::iterator it=baseClut.m_clut_color_to_index.begin();
	while (it!=baseClut.m_clut_color_to_index.end())
	{
		ShifterColor baseColor=(*it).first;
		int baseIndex=(*it).second;

		std::map<ShifterColor,int>::iterator findIt=m_clut_color_to_index.find(baseColor);
		if (findIt!=m_clut_color_to_index.end())
		{
			// Found a match
			int foundIndex=findIt->second;
			if (foundIndex!=baseIndex)
			{
				// Different indexes in the palette, we need to swap
				ShifterColor swappedColor=m_clut_index_to_color[baseIndex];
				m_clut_index_to_color[foundIndex]=swappedColor;
				m_clut_color_to_index[swappedColor] =foundIndex;

				m_clut_index_to_color[baseIndex]=baseColor;
				m_clut_color_to_index[baseColor]=baseIndex;
			}
		}
		++it;
	}
#endif
}

void AtariClut::SaveClut(long handle) const
{
	unsigned short clut[16];
	memset(clut,0,sizeof(clut));

	assert(m_clut_color_to_index.size()<=16);
	std::map<ShifterColor,int>::const_iterator it=m_clut_color_to_index.begin();
	while (it!=m_clut_color_to_index.end())
	{
		int index=it->second;
		assert(index<16);
		const ShifterColor& color=it->first;
		if (index<16)
		{
			// Atari ST is a big endian machine
			clut[index]=color.GetBigEndianValue();
		}
		++it;
	}	
	write(handle,clut,32);
}


void AtariClut::SaveClutAsText(std::string& text)  const
{
	unsigned short clut[16];
	memset(clut,0,sizeof(clut));

	assert(m_clut_color_to_index.size()<=16);
	std::map<ShifterColor,int>::const_iterator it=m_clut_color_to_index.begin();
	while (it!=m_clut_color_to_index.end())
	{
		int index=it->second;
		assert(index<16);
		const ShifterColor& color=it->first;
		if (index<16)
		{
			clut[index]=color.GetValue();
		}
		++it;
	}	

	char buffer[64];
	for (int index=0;index<16;index++)
	{
		if (index!=0)
		{
			text+=",";
		}
		sprintf(buffer,"$%04x",clut[index]);
		text+=buffer;
	}	
}


void AtariClut::GetColors(std::vector<RGBQUAD>& colors) const
{
	const std::map<ShifterColor,int>& reservedColor=m_clut_color_to_index;
	assert(m_clut_color_to_index.size()==m_clut_index_to_color.size());

	unsigned int color_count=reservedColor.size();
	if (color_count)
	{
		colors.resize(color_count);

		std::vector<RGBQUAD>::iterator itDest=colors.begin();
		std::map<ShifterColor,int>::const_iterator itSource=reservedColor.begin();
		while (itSource!=reservedColor.end())
		{
			const ShifterColor& sourceColor=itSource->first;
			RgbColor rgbColor=sourceColor.GetRgb();

			RGBQUAD& destColor=*itDest;
			destColor.rgbRed	=rgbColor.m_red;
			destColor.rgbGreen	=rgbColor.m_green;
			destColor.rgbBlue	=rgbColor.m_blue;

			++itSource;
			++itDest;
		}
	}
}


// ============================================================================
//
//		                         AtariPictureConverter
//
// ============================================================================

AtariPictureConverter::AtariPictureConverter() :
	PictureConverter(MACHINE_ATARIST),
	m_format(FORMAT_SINGLE_PALETTE),
	m_palette_mode(PALETTE_AUTOMATIC),
	m_buffer(0)
{
	set_buffer_size(320,200);	// Default size

	clear_screen();
}

AtariPictureConverter::~AtariPictureConverter()
{
	delete[] m_buffer;
}


void AtariPictureConverter::set_buffer_size(int width,int height)
{
	m_buffer_width	=width;
	m_buffer_height	=height;
	m_buffer_cols	=((width+15)/16)*2*4;	// *wordsize*bitplanscount
	m_buffer_size=m_buffer_height*m_buffer_cols;

	delete[] m_buffer;
	m_buffer=new unsigned char[m_buffer_size];
}



void AtariPictureConverter::clear_screen()
{
	for (unsigned int i=0;i<m_buffer_size;i++)
	{
		m_buffer[i]=0;
	}
}


bool AtariPictureConverter::Convert(const ImageContainer& sourcePicture)
{
	ImageContainer convertedPicture(sourcePicture);

#ifdef ENABLE_PALETTE_TRACKING
	{
		// ------- debug start
		std::string clutAsText;
		AtariClut& clut=GetClut(0);
		clut.SaveClutAsText(clutAsText);
		clutAsText+="\r\n";
		std::cout << "AtariPictureConverter::Convert:" << clutAsText;
		// ------- debug end
	}
	std::cout << "AtariPictureConverter::Convert:PaletteMode" << m_palette_mode << "\r\n";
#endif

	if (m_blockmode!=BLOCKMODE_DISABLED)
	{
		std::cout << "-b1 (block mode) not supported on this machine";
		return false;
	}

	if (m_format==FORMAT_SINGLE_PALETTE)
	{
		m_flagPalettePerScanline=false;
		if (m_palette_mode==PALETTE_FROM_LAST_PIXELS)
		{
			// Can's use this mode if only one palette should be exported
			std::cout << "-p2 (Last pixels of each line of the picture contains the palette) requires -f1 (Multi palette format)";
			return false;
		}
	}
	else
	{
		m_flagPalettePerScanline=true;
	}

	switch (m_palette_mode)
	{
	case PALETTE_AUTOMATIC:
		// Nothing to do
		break;

	case PALETTE_FROM_LAST_LINE:
		{
			// Cut the first line, and extract the palette
			ImageContainer lockedPalette;
			if (!lockedPalette.CreateFromImage(convertedPicture,0,convertedPicture.GetHeight()-2,convertedPicture.GetWidth(),2))
			{
				return false;
			}
			
			if (!convertedPicture.CreateFromImage(convertedPicture,0,0,convertedPicture.GetWidth(),convertedPicture.GetHeight()-2))
			{
				return false;
			}

			unsigned int clut_start=0;
			unsigned int clut_end=1;
			if (m_format==FORMAT_MULTIPLE_PALETTE)
			{
				clut_end=convertedPicture.GetHeight();
			}

			RgbColor ignoreColor=lockedPalette.ReadColor(0,0);
			for (unsigned int index=0;index<16;index++)
			{
				RgbColor rgbColor=lockedPalette.ReadColor(index,1);
				if (rgbColor!=ignoreColor)
				{
					// This color should be locked for this index
					for (unsigned int line=clut_start;line<clut_end;line++)
					{
						AtariClut& clut=GetClut(line);
						clut.SetColor(rgbColor,index);
					}
				}
			}

		}
		break;

	case PALETTE_FROM_LAST_PIXELS:
		{
			// Cut the first 16 pixels on the left, and extract the palette for each
			ImageContainer lockedPalette;
			if (!lockedPalette.CreateFromImage(convertedPicture,convertedPicture.GetWidth()-17,0,17,convertedPicture.GetHeight()))
			{
				return false;
			}

			if (!convertedPicture.CreateFromImage(convertedPicture,0,0,convertedPicture.GetWidth()-17,convertedPicture.GetHeight()))
			{
				return false;
			}

			for (unsigned int line=0;line<lockedPalette.GetHeight();line++)
			{
				AtariClut& clut=GetClut(line);
				RgbColor ignoreColor=lockedPalette.ReadColor(0,0);
				for (unsigned int index=0;index<16;index++)
				{
					RgbColor rgbColor=lockedPalette.ReadColor(1+index,line);
					if (rgbColor!=ignoreColor)
					{
						// This color should be locked for this index
						clut.SetColor(rgbColor,index);
#ifdef ENABLE_PALETTE_TRACKING
						if (line==0)
						{
							std::cout << "AtariPictureConverter::SetColor:" << (int)rgbColor.m_red << (int)rgbColor.m_green << (int)rgbColor.m_blue << "/" << index << "\r\n";
						}
#endif
					}
				}
#ifdef ENABLE_PALETTE_TRACKING

				{
					// ------- debug start
					std::string clutAsText;
					//AtariClut& clut=GetClut(0);
					clut.SaveClutAsText(clutAsText);
					clutAsText+="\r\n";
					std::cout << "AtariPictureConverter::ConvertLoopForLine:" << line << "=" << clutAsText;
					// ------- debug end
				}
#endif
				//_BREAK_IF_((line==5));
			}
		}
		break;
	}


#ifdef ENABLE_PALETTE_TRACKING
	{
		// ------- debug start
		std::string clutAsText;
		AtariClut& clut=GetClut(0);
		clut.SaveClutAsText(clutAsText);
		clutAsText+="\r\n";
		std::cout << "AtariPictureConverter::Convert:" << clutAsText;
		// ------- debug end
	}
#endif

	set_buffer_size(convertedPicture.GetWidth(),convertedPicture.GetHeight());

	clear_screen();

	switch (m_format)
	{
	case FORMAT_SINGLE_PALETTE:
		convertedPicture.ReduceColorDepth(&GetClut(0));
		convert_shifter(convertedPicture);
		break;

	case FORMAT_MULTIPLE_PALETTE:
		m_flagPalettePerScanline=true;
		convertedPicture.ReduceColorDepthPerScanline(&m_cluts);
		convert_shifter(convertedPicture);
		break;

	default:
		// Oops
		return false;
		break;
	}
	return true;
}


AtariClut& AtariPictureConverter::GetClut(unsigned int scanline)
{
	if (m_flagPalettePerScanline)	return m_cluts[scanline];
	else							return m_cluts[0];
}


void AtariPictureConverter::convert_shifter(const ImageContainer& sourcePicture)
{
	//
	// Perform the Atari ST bitplan conversion
	// We proceed in three phases for the multi palette pictures, because we want the
	// colors to stay about the same between one line and another, to avoid horrible
	// color glitches when moving the pictures horizontally.

#ifdef ENABLE_PALETTE_TRACKING
	// ------- debug start
	std::string clutAsText;
	AtariClut& clut=GetClut(0);
	clut.SaveClutAsText(clutAsText);
	clutAsText+="\r\n";
	std::cout << "AtariPictureConverter::convert_shifter(start):" << clutAsText;
	// ------- debug end
#endif
	if (m_flagPalettePerScanline)
	{
		// Phase one: Collect palettes
		{
			for (unsigned int y=0;y<m_buffer_height;y++)
			{
				AtariClut& clut=GetClut(y);

				for (unsigned int x=0;x<m_buffer_width;x++)
				{
					//_BREAK_IF_((y==5) && (x==565));
					RgbColor rgb=sourcePicture.ReadColor(x,y);
					clut.convert_pixel_shifter(rgb);
				}
			}
		}

		// Phase two: Optimize the palette
		{
			/*
			for (unsigned int y=0;y<m_buffer_height-1;y++)
			{
				AtariClut& clut1=GetClut(y);
				AtariClut& clut2=GetClut(y+1);
				clut2.Reorder(clut1);
			}
			*/
		}
	}


	// Phase three: Generate the atari format bitplan
	{
		unsigned char *ptr_hires=(unsigned char*)m_buffer;
		for (unsigned int y=0;y<m_buffer_height;y++)
		{
			//_BREAK_IF_(y==110);

			AtariClut& clut=GetClut(y);

			unsigned int x=0;
			while (x<m_buffer_width)
			{
				unsigned int p0=0;
				unsigned int p1=0;
				unsigned int p2=0;
				unsigned int p3=0;

				for (int bit=0;bit<16;bit++)
				{
					p0<<=1;
					p1<<=1;
					p2<<=1;
					p3<<=1;
					RgbColor rgb=sourcePicture.ReadColor(x,y);
					int color=clut.convert_pixel_shifter(rgb);
					if (color&1)
					{
						p0|=1;
					}
					if (color&2)
					{
						p1|=1;
					}
					if (color&4)
					{
						p2|=1;
					}
					if (color&8)
					{
						p3|=1;
					}
					x++;
				}
				*ptr_hires++=static_cast<unsigned char>((p0>>8)&255);
				*ptr_hires++=static_cast<unsigned char>(p0&255);
				*ptr_hires++=static_cast<unsigned char>((p1>>8)&255);
				*ptr_hires++=static_cast<unsigned char>(p1&255);
				*ptr_hires++=static_cast<unsigned char>((p2>>8)&255);
				*ptr_hires++=static_cast<unsigned char>(p2&255);
				*ptr_hires++=static_cast<unsigned char>((p3>>8)&255);
				*ptr_hires++=static_cast<unsigned char>(p3&255);
			}
		}
	}

#ifdef ENABLE_PALETTE_TRACKING
	{
		// ------- debug start
		std::string clutAsText;
		AtariClut& clut=GetClut(0);
		clut.SaveClutAsText(clutAsText);
		clutAsText+="\r\n";
		std::cout << "AtariPictureConverter::convert_shifter(end):" << clutAsText;
		// ------- debug end
	}
#endif
}


bool AtariPictureConverter::TakeSnapShot(ImageContainer& sourcePicture)
{
	if (!sourcePicture.Allocate(m_buffer_width,m_buffer_height,24))
	{
		return false;
	}

#ifdef ENABLE_PALETTE_TRACKING
	{
		// ------- debug start
		std::string clutAsText;
		AtariClut& clut=GetClut(0);
		clut.SaveClutAsText(clutAsText);
		clutAsText+="\r\n";
		std::cout << "AtariPictureConverter::TakeSnapShot:" << clutAsText;
		// ------- debug end
	}
#endif

	unsigned short* pShort=(unsigned short*)m_buffer;
	for (unsigned int y=0;y<m_buffer_height;y++)
	{
		AtariClut& clut=GetClut(y);

		for (unsigned int x=0;x<m_buffer_width;x+=16)
		{
			unsigned short p0=*pShort++;
			unsigned short p1=*pShort++;
			unsigned short p2=*pShort++;
			unsigned short p3=*pShort++;

			p0=((p0&255)<<8) | (p0>>8);
			p1=((p1&255)<<8) | (p1>>8);
			p2=((p2&255)<<8) | (p2>>8);
			p3=((p3&255)<<8) | (p3>>8);

			for (int xx=0;xx<16;xx++)
			{
				int index=(p0&1) | ((p1&1)<<1) | ((p2&1)<<2) | ((p3&1)<<3);

				ShifterColor shifterColor=clut.m_clut_index_to_color[index];

				RgbColor rgb(shifterColor.GetRgb());

				sourcePicture.WriteColor(rgb,x+15-xx,y);

				p0>>=1;
				p1>>=1;
				p2>>=1;
				p3>>=1;
			}
		}
	}
	return true;
}



void AtariPictureConverter::SaveToFile(long handle,int output_format)
{
	switch (output_format)
	{
	case DEVICE_FORMAT_RAWBUFFER_WITH_XYHEADER:
		{
			unsigned short x=static_cast<unsigned short>(get_buffer_width());
			unsigned short y=static_cast<unsigned short>(get_buffer_height());

			write(handle,&x,2);
			write(handle,&y,2);
		}
		break;

	case DEVICE_FORMAT_RAWBUFFER_WITH_PALETTE:
		{
			std::string clutAsText;
			if (m_flagPalettePerScanline)
			{
				assert(m_cluts.size()==get_buffer_height());
				std::map<int,AtariClut>::iterator it=m_cluts.begin();
				while (it!=m_cluts.end())
				{
					AtariClut& clut=it->second;
					clut.SaveClut(handle);
					clut.SaveClutAsText(clutAsText);
					clutAsText+="\r\n";
					++it;
				}
			}
			else
			{
				AtariClut& clut=m_cluts[0];
				clut.SaveClut(handle);
				clut.SaveClutAsText(clutAsText);
			}
			clutAsText+="\r\n";
		}
		break;

	case DEVICE_FORMAT_RAWBUFFER:
		// No header for raw
		break;
	}
	write(handle,(unsigned char*)m_buffer,GetBufferSize());
}

