

#include <assert.h>
#include <stdio.h>
#include <fcntl.h>
#include <iostream>
#include <string.h>
#include <unistd.h>

#include <sys/types.h>
#include <sys/stat.h>

#include "FreeImage.h"

#include "defines.h"
#include "getpixel.h"
#include "hires.h"
#include "oric_converter.h"
#include "dithering.h"

#include "common.h"

#include "image.h"



//
// dither_riemersma
//
void dither_riemersma_monochrom(ImageContainer& image,int width,int height);
void dither_riemersma_rgb(ImageContainer& image,int width,int height);


char *PtrSpaces;
char BufferSpaces[]="                                                                                                ";

int gcur_line=0;
int	gmax_count=0;

bool FlagDebug=true;


// ============================================================================
//
//		                         OricRgbColor
//
// ============================================================================

class OricRgbColor : public RgbColor
{
public:
	void SetOricColor(ORIC_COLOR color)
	{
		if (color&1)	m_red=255;
		else			m_red=0;

		if (color&2)	m_green=255;
		else			m_green=0;

		if (color&4)	m_blue=255;
		else			m_blue=0;
	}
};


// ============================================================================
//
//		                         OricPictureConverter
//
// ============================================================================

OricPictureConverter::OricPictureConverter() :
	PictureConverter(MACHINE_ORIC),
	m_format(FORMAT_MONOCHROM),
	m_buffer(0),
	m_flag_setbit6(true)
{

	set_buffer_size(240,200);	// Default size

	clear_screen();
}

OricPictureConverter::~OricPictureConverter()
{
	delete[] m_buffer;
}



void OricPictureConverter::set_buffer_size(int width,int height)
{
	m_buffer_width	=width;
	m_buffer_height	=height;
	m_buffer_cols	=(width+5)/6;
	m_buffer_size	=m_buffer_height*m_buffer_cols;

	delete[] m_buffer;
	m_buffer=new unsigned char[m_buffer_size];
}



void OricPictureConverter::clear_screen()
{
	//
	// Fill the screen with a neutral value (64=white space for hires)
	//
	unsigned char nFillValue;
	if (m_flag_setbit6)
	{
		nFillValue=64;
	}
	else
	{
		nFillValue=0;
	}
	for (unsigned int i=0;i<m_buffer_size;i++)
	{
		m_buffer[i]=nFillValue;
	}
}




ORIC_COLOR OricPictureConverter::convert_pixel_monochrom(const ImageContainer& sourcePicture,unsigned int x,unsigned int y)
{
	RgbColor rgb=sourcePicture.ReadColor(x,y);

	unsigned char r=rgb.m_red;
	unsigned char g=rgb.m_green;
	unsigned char b=rgb.m_blue;

	switch (m_dither)
	{
	case DITHER_NONE:
		//
		// Simple BLACK/WHITE selection
		// based on the global luminosity.
		//
		if ((r+g+b)>127+127+127)
		{
			r=255;
			g=255;
			b=255;
		}
		else
		{
			r=0;
			g=0;
			b=0;
		}
		break;

	case DITHER_ALTERNATE:
	case DITHER_ALTERNATE_INVERSED:
		//
		// Semi dithering :))
		// BLACK/GREY/WHITE
		//
		if ((r+g+b)>170*3)
		{
			r=255;
			g=255;
			b=255;
		}
		else
		if ((r+g+b)<85*3)
		{
			r=0;
			g=0;
			b=0;
		}
		else
		{
			if ((x^y)&1)
			{
				if (m_dither==DITHER_ALTERNATE_INVERSED)
				{
					r=255;
					g=255;
					b=255;
				}
				else
				{
					r=0;
					g=0;
					b=0;
				}
			}
			else
			{
				if (m_dither==DITHER_ALTERNATE_INVERSED)
				{
					r=0;
					g=0;
					b=0;
				}
				else
				{
					r=255;
					g=255;
					b=255;
				}
			}
		}
		break;

	case DITHER_ORDERED:
		{
			//
			// Use a dithering matrix
			//
			int	bit=1 << ((x&3) | ((y&3)<<2));

			unsigned char c=(r+g+b)/3;
			if (DitherMask[(c*8)/255]&bit)	c=255;
			else							c=0;

			r=g=b=c;
		}
		break;

	case DITHER_RIEMERSMA:
		break;
	case DITHER_FLOYD:
		break;

	default:
		break;
	}

	if (r|g|b)
		return ORIC_COLOR_WHITE; 
	return ORIC_COLOR_BLACK; 
}



ORIC_COLOR OricPictureConverter::convert_pixel_rgb(const ImageContainer& sourcePicture,unsigned int x,unsigned int y)
{
	RgbColor rgb1=sourcePicture.ReadColor(x,y+0);
	RgbColor rgb2=sourcePicture.ReadColor(x,y+1);
	RgbColor rgb3=sourcePicture.ReadColor(x,y+2);

	unsigned char r=(rgb1.m_red  +rgb2.m_red  +rgb3.m_red )/3;
	unsigned char g=(rgb1.m_green+rgb2.m_green+rgb3.m_green)/3;
	unsigned char b=(rgb1.m_blue +rgb2.m_blue +rgb3.m_blue )/3;

	int	c;

	switch (m_dither)
	{
	case DITHER_NONE:
		//
		// Simple BLACK/COMPONENT selection
		// based on the global luminosity.
		//
		c=y % 3;

		switch (c)
		{
		case 0:
			if (r>127)	r=255;
			else		r=0;
			g=0;
			b=0;
			break;
		case 1:
			if (g>127)	g=255;
			else		g=0;
			r=0;
			b=0;
			break;
		case 2:
			if (b>127)	b=255;
			else		b=0;
			r=0;
			g=0;
			break;
		}
		if (r|g|b)
			return ORIC_COLOR_WHITE; 
		return ORIC_COLOR_BLACK; 
		break;

	case DITHER_ALTERNATE:
		//
		// Semi dithering :))
		// BLACK/GREY/WHITE
		//
		c=y % 3;

		switch (c)
		{
		case 0:
			if (r>170)	r=255;
			else
			if (r<85)	r=0;
			else		r=(unsigned char)(255*((x^y)&1));
			g=0;
			b=0;
			break;
		case 1:
			if (g>170)	g=255;
			else
			if (g<85)	g=0;
			else		g=(unsigned char)(255*((x^y)&1));
			r=0;
			b=0;
			break;
		case 2:
			if (b>170)	b=255;
			else
			if (b<85)	b=0;
			else		b=(unsigned char)(255*((x^y)&1));
			r=0;
			g=0;
			break;
		}
		if (r|g|b)
			return ORIC_COLOR_WHITE; 
		return ORIC_COLOR_BLACK; 
		break;

	case DITHER_ORDERED:
		{
			//
			// Use a dithering matrix
			//
			int bit=1 << ((x&3) | ((y&3)<<2));

			c=y % 3;

			switch (c)
			{
			case 0:
				if (DitherMask[(r*8)/255]&bit)	r=255;
				else							r=0;
				g=0;
				b=0;
				break;
			case 1:
				if (DitherMask[(g*8)/255]&bit)	g=255;
				else							g=0;
				r=0;
				b=0;
				break;
			case 2:
				if (DitherMask[(b*8)/255]&bit)	b=255;
				else							b=0;
				r=0;
				g=0;
				break;
			}
			if (r|g|b)
				return ORIC_COLOR_WHITE; 
			return ORIC_COLOR_BLACK; 
		}
		break;

	case DITHER_FLOYD:
		break;

	default:
		break;
	}
	return ORIC_COLOR_BLACK; 
}





ORIC_COLOR OricPictureConverter::convert_pixel_rb(const ImageContainer& sourcePicture,unsigned int x,unsigned int y)
{
	RgbColor rgb1=sourcePicture.ReadColor(x,y+0);
	RgbColor rgb2=sourcePicture.ReadColor(x,y+1);
	RgbColor rgb3=sourcePicture.ReadColor(x,y+2);

	unsigned char r=(rgb1.m_red+rgb2.m_red	+rgb3.m_red)/3;
	unsigned char gb=(rgb1.m_green+rgb2.m_green+rgb3.m_green+rgb1.m_blue+rgb2.m_blue	+rgb3.m_blue)/6;

	int	c;
	switch (m_dither)
	{
	case DITHER_NONE:
		//
		// Simple BLACK/COMPONENT selection
		// based on the global luminosity.
		//
		c=y % 2;

		switch (c)
		{
		case 0:
			if (r>127)	r=255;
			else		r=0;
			gb=0;
			break;
		case 1:
			if (gb>127)	gb=255;
			else		gb=0;
			r=0;
			break;
		}
		break;

	case DITHER_ALTERNATE:
		//
		// Semi dithering :))
		// BLACK/GREY/WHITE
		//
		c=y % 2;

		switch (c)
		{
		case 0:
			if (r>170)	r=255;
			else
			if (r<85)	r=0;
			else		r=(unsigned char)(255*((x^y)&1));
			gb=0;
			break;
		case 1:
			if (gb>170)	gb=255;
			else
			if (gb<85)	gb=0;
			else		gb=(unsigned char)(255*((x^y)&1));
			r=0;
			break;
		}
		break;

	case DITHER_ORDERED:
		//
		// Use a dithering matrix
		//
		int		bit;

		bit=1 << ((x&3) | ((y&3)<<2));

		c=y % 2;

		switch (c)
		{
		case 0:
			if (DitherMask[(r*8)/255]&bit)	r=255;
			else							r=0;
			gb=0;
			break;
		case 1:
			if (DitherMask[(gb*8)/255]&bit)	gb=255;
			else							gb=0;
			r=0;
			break;
		}
		break;

	case DITHER_FLOYD:
		break;

	default:
		break;
	}

	if (r|gb)
		return ORIC_COLOR_WHITE; 
	return ORIC_COLOR_BLACK; 
}







void OricPictureConverter::convert_monochrom(const ImageContainer& sourcePicture)
{
	ImageContainer convertedPicture(sourcePicture);

	//
	// Perform the global dithering, if required
	//
	switch (m_dither)
	{
	case DITHER_RIEMERSMA:
		dither_riemersma_monochrom(convertedPicture,m_buffer_width,m_buffer_height);
		m_dither=DITHER_NONE;
		break;
	}
	
	//
	// Perform the HIRES convers
	//
	unsigned char* ptr_hires=m_buffer;
	for (unsigned int y=0;y<m_buffer_height;y++)
	{
		int	x=0;
		for (int col=0;col<m_buffer_cols;col++)
		{
			unsigned char val=0;
			for (int bit=0;bit<6;bit++)
			{
				val<<=1;
				ORIC_COLOR color=convert_pixel_monochrom(convertedPicture,x,y);
				if (color!=ORIC_COLOR_BLACK)
				{
					val|=1;
				}
				x++;
			}
			if (m_flag_setbit6)
			{
				// In some cases you don't want to get the bit 6 to be set at all
				val|=64;
			}
			*ptr_hires++=val;
		}
	}
}


void OricPictureConverter::convert_twilighte_mask(const ImageContainer& sourcePicture)
{
	ImageContainer convertedPicture(sourcePicture);

	//
	// Perform the global dithering, if required
	//
	switch (m_dither)
	{
	case DITHER_RIEMERSMA:
		dither_riemersma_monochrom(convertedPicture,m_buffer_width,m_buffer_height);
		m_dither=DITHER_NONE;
		break;
	}
	
	//
	// Perform the HIRES conversion
	//
	unsigned char* ptr_hires=m_buffer;
	for (unsigned int y=0;y<m_buffer_height;y++)
	{
		int x=0;
		for (int col=0;col<m_buffer_cols;col++)
		{
			unsigned char mask=0;
			unsigned char mask_control=0;
			unsigned char val=0;
			for (int bit=0;bit<6;bit++)
			{
				val<<=1;
				mask_control<<=1;

				// Get the original pixel color 
				BYTE *ptr_byte=FreeImage_GetBitsRowCol(convertedPicture.GetBitmap(),x,y);
				int color=0;
				if ((*ptr_byte++)>128)	color|=4;
				if ((*ptr_byte++)>128)	color|=2;
				if ((*ptr_byte++)>128)	color|=1;

				switch (color)
				{
				case ORIC_COLOR_BLACK:
					// Paper
					val|=0;
					mask_control|=1;
					break;
				
				case ORIC_COLOR_WHITE:
					// Ink
					val|=1;
					mask_control|=1;
					break;

				default:
					// mask
					if (bit<=2)
					{
						mask|=2;
					}
					else
					{
						mask|=1;
					}
					break;
				}
				x++;
			}

			//
			// Test if we have mask/pixels conflicts
			//
			/*
			if ( ((mask&1) && (mask_control&(1+2+4))) ||
				 ((mask&2) && (mask_control&(8+16+32))) )
			{
				printf("\r\nMask/Ink/Paper problem Line %d Bloc %d",y,col);
			}
			*/

			//
			// Write the value
			//
			*ptr_hires++=val|(mask<<6);
		}
	}
}



void OricPictureConverter::convert_rgb(const ImageContainer& sourcePicture)
{
	ImageContainer convertedPicture(sourcePicture);

	//
	// Perform the global dithering, if required
	//
	switch (m_dither)
	{
	case DITHER_RIEMERSMA:
		dither_riemersma_rgb(convertedPicture,m_buffer_width,m_buffer_height);
		m_dither=DITHER_NONE;
		break;
	}

	//
	// Perform the HIRES conversion
	//
	unsigned char* ptr_hires=m_buffer;
	for (unsigned int y=0;y<m_buffer_height;y++)
	{
		//
		// Write RgbColor attrib
		//
		switch (y%3)
		{
		case 0:
			*ptr_hires++=ORIC_COLOR_RED;
			break;
		case 1:
			*ptr_hires++=ORIC_COLOR_GREEN;
			break;
		case 2:
			*ptr_hires++=ORIC_COLOR_BLUE;
			break;
		}

		int x=0;
		for (int col=1;col<m_buffer_cols;col++)
		{
			unsigned char val=0;
			for (int bit=0;bit<6;bit++)
			{
				val<<=1;
				ORIC_COLOR color=convert_pixel_rgb(convertedPicture,x,y);
				if (color!=ORIC_COLOR_BLACK)
				{
					val|=1;
				}
				x++;
			}
			if (m_flag_setbit6)			
			{
				// In some cases you don't want the bit 6 to be set at all
				val|=64;
			}
			*ptr_hires++=val;
		}
	}
}









void OricPictureConverter::convert_rb(const ImageContainer& sourcePicture)
{
	ImageContainer convertedPicture(sourcePicture);

	//
	// Perform the global dithering, if required
	//
	switch (m_dither)
	{
	case DITHER_RIEMERSMA:
		dither_riemersma_rgb(convertedPicture,m_buffer_width,m_buffer_height);
		m_dither=DITHER_NONE;
		break;
	}

	//
	// Perform the HIRES conversion
	//
	unsigned char *ptr_hires=m_buffer;
	for (unsigned int y=0;y<m_buffer_height;y++)
	{
		//
		// Write RgbColor attrib
		//
		switch (y%2)
		{
		case 0:
			*ptr_hires++=ORIC_COLOR_RED;
			break;
		case 1:
			*ptr_hires++=ORIC_COLOR_WHITE;
			break;
		}

		int x=0;
		for (int col=0;col<39;col++)
		{
			unsigned char val=0;
			for (int bit=0;bit<6;bit++)
			{
				val<<=1;
				ORIC_COLOR color=convert_pixel_rb(convertedPicture,x,y);
				if (color!=ORIC_COLOR_BLACK)
				{
					val|=1;
				}
				x++;
			}
			if (m_flag_setbit6)
			{
				// In some cases you don't want the bit 6 to be set at all
				val|=64;
			}
			*ptr_hires++=val;
		}
	}
}



/*
	- u8: nombre de couleurs sur le bloc (1, 2, ou invalide)
	- u8: couleur 1
	- u8: couleur 2
	- u8: flag (inverse vidéo possible, ...)
*/
struct BLOC6
{
	unsigned char	color_count;
	unsigned char	color[2];
	unsigned char	value;
};
 

BLOC6	Bloc6Buffer[40];	// For 240 pixel wide pictures


/*

Les cas possibles:
- 6 pixels unis.
	* Ils peuvent être d'une de ces couleurs:
	Utilisation de la couleur courante du papier
	Utilisation de la couleur courante de l'encre
	Utilisation de la couleur courante du papier, avec inversion vidéo
	Utilisation de la couleur courante de l'encre, avec inversion vidéo

	* On peur y faire:
	Changement de papier de la même couleur
	Changement de papier d'une couleur inversée de la couleur, en mettant la vidéo inverse

	

- 6 pixels, utilisant deux couleurs.




*/




bool RecurseLine(unsigned char count,BLOC6 *ptr_bloc6,unsigned char *ptr_hires,unsigned char cur_paper,unsigned char cur_ink)
{
	PtrSpaces-=2;

	/*
	if (gcur_line==138)
	{
		printf("\r\n Count:%d Paper:%d Ink:%d",count,cur_paper,cur_ink);
	}
	*/
	/*
	if ((time(0)-gLastTimer)>2)
	{
		//
		// End of recursion with error
		//
		if (!FlagDebug)
		{
			return false;
		}
	}
	*/

	if (count<gmax_count)
	{
		gmax_count=count;
		//printf("\r\n MaxCount:%d",gmax_count);
		/*
		if ((gcur_line==138) && (gmax_count==34))
		{
			__asm {int 3 }
		}
		*/
	}

	if (!count)
	{
		//
		// End of recursion
		//
		return true;
	}

	unsigned char	color_count=ptr_bloc6->color_count;
	unsigned char	c0=ptr_bloc6->color[0];
	unsigned char	c1=ptr_bloc6->color[1];
	unsigned char	v =ptr_bloc6->value;


	count--;
	ptr_bloc6++;
	ptr_hires++;

	if (color_count==1)
	{
		// ========================================
		// The current bloc of pixels is using only 
		// one color. It's the right opportunity to
		// change either the PAPER or the INK color.
		// ========================================

		if (c0==cur_paper)
		{
			//
			// The 6 pixels are using the current paper color.
			//

			// Use current paper color
			if (FlagDebug)	printf("\r\n %sUse paper color (%d)",PtrSpaces,cur_paper);
			if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
			{
				ptr_hires[-1]=64;
				return true;
			}

			// Try each of the 8 possible ink colors
			for (unsigned char color=0;color<8;color++)
			{
				if (FlagDebug)	printf("\r\n %sUse paper color (%d) while changing ink color to (%d)",PtrSpaces,cur_paper,color);
				if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,color))
				{
					ptr_hires[-1]=color;
					return true;
				}
			}
		}

		// Use current ink color
		if (c0==cur_ink)
		{
			if (FlagDebug)	printf("\r\n %sUse ink color (%d)",PtrSpaces,cur_ink);
			if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
			{
				ptr_hires[-1]=64|63;
				return true;
			}
		}


		if (c0==(7-cur_paper))
		{
			//
			// The 6 pixels are using the current inverted paper color.
			//

			// Use current paper color
			if (FlagDebug)	printf("\r\n %sUse inverted paper color (%d => %d)",PtrSpaces,cur_paper,7-cur_paper);
			if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
			{
				ptr_hires[-1]=128|64;
				return true;
			}

			// Try each of the 8 possible ink colors
			for (unsigned char color=0;color<8;color++)
			{
				if (FlagDebug)	printf("\r\n %sUse inverted paper color (%d => %d) while changing ink color to (%d)",PtrSpaces,cur_paper,7-cur_paper,color);
				if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,color))
				{
					ptr_hires[-1]=128|color;
					return true;
				}
			}
		}

		// Use current inverted ink color
		if (c0==(7-cur_ink))
		{
			if (FlagDebug)	printf("\r\n %sUse inverted ink color (%d => %d)",PtrSpaces,cur_ink,7-cur_ink);
			if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
			{
				ptr_hires[-1]=128|64|63;
				return true;
			}
		}

		// Change paper color
		if (FlagDebug)	printf("\r\n %sChange paper color to (%d)",PtrSpaces,c0);
		if (RecurseLine(count,ptr_bloc6,ptr_hires,c0,cur_ink))
		{
			ptr_hires[-1]=16+c0;
			return true;
		}

		
		// Change paper color, using inverse vidéo
		if (FlagDebug)	printf("\r\n %sChange paper color to (%d) using inversion (%d)",PtrSpaces,7-c0,c0);
		if (RecurseLine(count,ptr_bloc6,ptr_hires,7-c0,cur_ink))
		{
			ptr_hires[-1]=128|16+(7-c0);
			return true;
		}
	}
	else
	{
		// ========================================
		// The current bloc of pixels is using two 
		// different colors. It's totaly impossible
		// to use attributes changes on this one.
		// ========================================


		// Try simple pixels.
		if ((c0==cur_paper) && (c1==cur_ink))
		{
			if (FlagDebug)	printf("\r\n %sUse current colors (%d,%d)",PtrSpaces,cur_paper,cur_ink);
			if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
			{
				ptr_hires[-1]=64|v;
				return true;
			}
		}

		// Try simple pixels, but invert the bitmask.
		if ((c0==cur_ink) && (c1==cur_paper))
		{
			if (FlagDebug)	printf("\r\n %sUse current colors (%d,%d)",PtrSpaces,cur_paper,cur_ink);
			if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
			{
				ptr_hires[-1]=64|(v^63);
				return true;
			}
		}

		// Try simple video inverted pixels.
		if ((c0==(7-cur_paper)) && (c1==(7-cur_ink)))
		{
			if (FlagDebug)	printf("\r\n %sUse current inverted colors (%d,%d) => (%d,%d)",PtrSpaces,cur_paper,cur_ink,7-cur_paper,7-cur_ink);
			if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
			{
				ptr_hires[-1]=128|64|v;
				return true;
			}
		}

		// Try simple video inverted pixels, but invert the bitmask.
		if ((c0==(7-cur_ink)) && (c1==(7-cur_paper)))
		{
			if (FlagDebug)	printf("\r\n %sUse current inverted colors (%d,%d) => (%d,%d)",PtrSpaces,cur_paper,cur_ink,7-cur_paper,7-cur_ink);
			if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
			{
				ptr_hires[-1]=128|64|(v^63);
				return true;
			}
		}
	}

	//printf("\r\n ==== back track !!! ====");
	//getch();
	PtrSpaces+=2;
	return false;
}







void OricPictureConverter::convert_colored(const ImageContainer& sourcePicture)
{
	ImageContainer convertedPicture(sourcePicture);

	int				col,bit;

	//
	// Phase 1: Create a buffer with infos
	//
	bool flag=false;
	unsigned char *ptr_hires=m_buffer;

	bool error_in_picture=false;

	for (unsigned y=0;y<m_buffer_height;y++)
	{
		if (m_flag_debug)
		{
			printf("\r\nLine %d ",y);
		}

		BLOC6 *ptr_bloc6=Bloc6Buffer;
		bool error_in_line=false;

		//
		// Create a buffer for the scanline
		//
		int x=0;
		for (col=0;col<m_buffer_cols;col++)
		{
			bool error_in_bloc=false;

			// Init that bloc
			ptr_bloc6->color_count=0;
			ptr_bloc6->color[0]=0;
			ptr_bloc6->color[1]=0;
			ptr_bloc6->value=0;

			for (bit=0;bit<6;bit++)
			{
				ptr_bloc6->value<<=1;

				// Get the original pixel color 
				BYTE *ptr_byte=FreeImage_GetBitsRowCol(convertedPicture.GetBitmap(),x,y);
				unsigned char color=0;
				if ((*ptr_byte++)>128)	color|=4;
				if ((*ptr_byte++)>128)	color|=2;
				if ((*ptr_byte++)>128)	color|=1;

				// Check if it's already present in the color map
				switch (ptr_bloc6->color_count)
				{
				case 0:
					ptr_bloc6->color_count++;
					ptr_bloc6->color[0]=color;
					ptr_bloc6->color[1]=color;	// To avoid later tests
					break;

				case 1:
					if (ptr_bloc6->color[0]!=color)
					{
						// one more color
						ptr_bloc6->color_count++;
						ptr_bloc6->color[1]=color;
						ptr_bloc6->value|=1;
					}
					break;

				case 2:
					if (ptr_bloc6->color[0]!=color)
					{
						if (ptr_bloc6->color[1]==color)
						{
							// second color
							ptr_bloc6->value|=1;
						}
						else
						{
							// color overflow !!!
							ptr_bloc6->color_count++;
							
							error_in_bloc=true;
						}
					}
					break;
				}
				x++;
			}

			if (error_in_bloc)
			{
				if (!error_in_line)
				{
					printf("\r\nLine %d ",y);
				}
				printf("[%d colors bloc %d] ",ptr_bloc6->color_count,col);
				error_in_line=true;
			}
			ptr_bloc6++;
		}
		if (error_in_line)
		{
			error_in_picture=true;
		}

		//
		// Convert to monochrome
		//
		//gLastTimer=time(0);
		ptr_bloc6=Bloc6Buffer;

		unsigned char val;

		PtrSpaces=BufferSpaces+strlen(BufferSpaces);
		gcur_line=y;
		gmax_count=m_buffer_cols;
		if (RecurseLine((unsigned char)m_buffer_cols,ptr_bloc6,ptr_hires,0,7))
		//if (RecurseLine(7,ptr_bloc6,ptr_hires,0,7))
		{
			//
			// Recursion work.
			// Nothing to do.
			//
			if (FlagDebug)	
			{
				printf("\r\n ======= found =====");
				printf("\r\n Dump: ");
				for (col=0;col<7;col++)
				{
					val=ptr_hires[col];
					printf("[%d,%d,%d] ",(val>>7)&1,(val>>6)&1,(val&63));
				}

				//getch();
			}
			ptr_bloc6+=m_buffer_cols;
			ptr_hires+=m_buffer_cols;
		}
		else
		{
			if (!error_in_line)
			{
				printf("\r\nLine %d ",y);
			}
			printf(" max:%d ",gmax_count);

			//
			// Unable to perfom conversion
			// Use standard monochrom algorithm
			//
			x=0;
			for (col=0;col<m_buffer_cols;col++)
			{
				if (flag)
				{
					if (ptr_bloc6->color_count>2)
					{
						val=127;
					}
					else
					{
						val=64;
					}
				}
				else
				{
					val=64+ptr_bloc6->value;
				}
				*ptr_hires++=val;
				ptr_bloc6++;
			}
		}
	}
}


bool OricPictureConverter::Convert(const ImageContainer& sourcePicture)
{
	if (m_blockmode==BLOCKMODE_ENABLED)
	{
		// Find the blocks, and then continue the conversion
		sourcePicture.FindBlocks(m_block_data);
		//std::cout << "-b1 (block mode) not supported on this machine";
		//return false;
	}

	if ( (m_format==OricPictureConverter::FORMAT_COLORED) &&
		((sourcePicture.GetWidth()%6)==0) &&
		(sourcePicture.GetWidth()>240))
	{
		printf("\r\n Colored pictures should be at most 240 pixels wide, and multiple of 6 pixel wide.");
		return false;
	}

	set_buffer_size(sourcePicture.GetWidth(),sourcePicture.GetHeight());

	clear_screen();

	switch (m_format)
	{
	case FORMAT_MONOCHROM:
		convert_monochrom(sourcePicture);
		break;

	case FORMAT_COLORED:
		convert_colored(sourcePicture);
		break;

	case FORMAT_RGB:
		convert_rgb(sourcePicture);
		break;

	case FORMAT_RB:
		convert_rb(sourcePicture);
		break;

	case FORMAT_TRUETEXT:
		break;

	case FORMAT_TWILIGHTE_MASK:
		convert_twilighte_mask(sourcePicture);
		break;

	default:
		// Oops
		return false;
		break;
	}
	return true;
}



bool OricPictureConverter::TakeSnapShot(ImageContainer& sourcePicture)
{
	if (!sourcePicture.Allocate(m_buffer_width,m_buffer_height,24))
	{
		return false;
	}

	unsigned char *ptr_hires=m_buffer;
	for (unsigned int y=0;y<m_buffer_height;y++)
	{
		ORIC_COLOR paper=ORIC_COLOR_BLACK;
		ORIC_COLOR ink	=ORIC_COLOR_WHITE;

		int x=0;
		for (int col=0;col<m_buffer_cols;col++)
		{
			int val=*ptr_hires++;
			int val2=val&127;

			ORIC_COLOR cpaper=paper;
			ORIC_COLOR cink	 =ink;
			if (val2<8)
			{
				ink=(ORIC_COLOR)val2;
				val2=0;
				cpaper	=paper;
				cink	=ink;
			}
			else
			if ((val2>=16) && (val2<(16+8)))
			{
				paper=(ORIC_COLOR)(val2-16);
				val2=0;
				cpaper	=paper;
				cink	=ink;
			}

			if (val&128)
			{
				cpaper=(ORIC_COLOR)(7-cpaper);
				cink=(ORIC_COLOR)(7-cink);
			}

			for (int bit=0;bit<6;bit++)
			{
				OricRgbColor rgb;
				if (val2 & (1<<(5-bit)))
				{
					rgb.SetOricColor(cink);
				}
				else
				{
					rgb.SetOricColor(cpaper);
				}
				sourcePicture.WriteColor(rgb,x,y);
				x++;
			}
		}
	}
	return true;
}



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




void OricPictureConverter::save_header(long handle,int adress_begin)
{
	unsigned char Header[]=
	{
		// 0
		0x16,0x16,0x16,
		// 3
		0x24,
		// 4
		0x00,0x00,
		// 6 
		0x80,0x00,
		// 8
		0xbf,0xdf,
		// 10
		0xa0,0x00,
		// 12
		0x00
	};

	int adress_end=adress_begin+m_buffer_size;
	Header[ 8]=(unsigned char)((adress_end>>8)&255);
	Header[ 9]=(unsigned char)( adress_end&255);
	Header[10]=(unsigned char)((adress_begin>>8)&255);
	Header[11]=(unsigned char)( adress_begin&255);
	write(handle,Header,13);
}

void OricPictureConverter::SaveToFile(long handle,int output_format)
{
	switch (output_format)
	{
	case DEVICE_FORMAT_RAWBUFFER_WITH_XYHEADER:
		{
			unsigned char x=static_cast<unsigned char>(get_buffer_width());
			unsigned char y=static_cast<unsigned char>(get_buffer_height());

			write(handle,&x,1);
			write(handle,&y,1);
		}
		break;

	case DEVICE_FORMAT_RAWBUFFER_WITH_PALETTE:
		break;

	case DEVICE_FORMAT_RAWBUFFER:
		// No header for raw
		break;

	case DEVICE_FORMAT_BASIC_TAPE:
		write(handle,BasicLoader,sizeof(BasicLoader));
	default:	// Fall trough
		bool flag_header=true;
		if (flag_header)
		{
			save_header(handle,0xa000);
			//write(handle,Header,13);	
			write(handle,"",1);	//write(handle,name,strlen(name)+1);
		}
		break;
	}
	write(handle,(unsigned char*)m_buffer,GetBufferSize());
}

