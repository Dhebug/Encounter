

#include <assert.h>
#include <io.h>
#include <conio.h>

#include "freeimage.h"

#include "defines.h"
#include "getpixel.h"
#include "hires.h"
#include "dithering.h"



//
// dither_riemersma
//
void dither_riemersma_monochrom(FIBITMAP *dib,int width,int height);
void dither_riemersma_rgb(FIBITMAP *dib,int width,int height);


char *PtrSpaces;
char BufferSpaces[]="                                                                                                ";

int gcur_line=0;
int	gmax_count=0;

bool FlagDebug=false;



//time_t	gLastTimer;

CHires::CHires()
{
	m_format	=FORMAT_MONOCHROM;
	m_dither	=DITHER_NONE;
	m_machine	=MACHINE_ORIC;

	m_buffer=0;
	m_flag_debug=false;
	m_flag_setbit6=true;

	set_buffer_size(240,200);	// Default size

	clear_screen();
}

CHires::~CHires()
{
}





void CHires::set_buffer_size(int width,int height)
{
	m_buffer_width	=width;
	m_buffer_height	=height;
	switch (m_machine)
	{
	case MACHINE_ORIC:
		m_buffer_cols	=(width+5)/6;
		break;
	case MACHINE_ATARIST:
		m_buffer_cols	=((width+15)/16)*2*4;	// *wordsize*bitplanscount
		break;
	}
	m_buffer_size=m_buffer_height*m_buffer_cols;

	if (m_buffer)
	{
		delete[] m_buffer;
	}
	m_buffer=new unsigned char[m_buffer_size];
}



void CHires::clear_screen()
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
	for (int i=0;i<m_buffer_size;i++)
	{
		m_buffer[i]=nFillValue;
	}
}


void CHires::save(long handle)
{
    _write(handle,m_buffer,m_buffer_size);
}


unsigned char	Header[]=
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



void CHires::save_header(long handle,int adress_begin)
{
	int adress_end=adress_begin+m_buffer_size;
	Header[ 8]=(adress_end>>8)&255;
	Header[ 9]= adress_end&255;
	Header[10]=(adress_begin>>8)&255;
	Header[11]= adress_begin&255;
	_write(handle,Header,13);
}




ORIC_COLOR CHires::convert_pixel_monochrom(FIBITMAP *dib,int x,int y)
{
	RGB				rgb;
	unsigned char	r,g,b;

	GetColor(dib,&rgb,x,y);

	r=rgb.red;
	g=rgb.green;
	b=rgb.blue;

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
		//
		// Use a dithering matrix
		//
		int		bit;

		bit=1 << ((x&3) | ((y&3)<<2));

		int c;

		c=(r+g+b)/3;
		if (DitherMask[(c*8)/255]&bit)	c=255;
		else							c=0;

		r=g=b=c;

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



void CHires::write_pixel_rgb(FIBITMAP *dib,int x,int y,ORIC_COLOR color)
{
	RGB		rgb;

	if (color&1)	rgb.red=255;
	else			rgb.red=0;

	if (color&2)	rgb.green=255;
	else			rgb.green=0;

	if (color&4)	rgb.blue=255;
	else			rgb.blue=0;

	WriteColor(dib,&rgb,x,y);
}




ORIC_COLOR CHires::convert_pixel_rgb(FIBITMAP *dib,int x,int y)
{
	RGB				rgb1;
	RGB				rgb2;
	RGB				rgb3;
	unsigned char	r,g,b;

	int	c;

	GetColor(dib,&rgb1,x,y+0);
	GetColor(dib,&rgb2,x,y+1);
	GetColor(dib,&rgb3,x,y+2);

	r=(rgb1.red+rgb2.red	+rgb3.red)/3;
	g=(rgb1.green+rgb2.green+rgb3.green)/3;
	b=(rgb1.blue+rgb2.blue	+rgb3.blue)/3;

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
			else		r=255*((x^y)&1);
			g=0;
			b=0;
			break;
		case 1:
			if (g>170)	g=255;
			else
			if (g<85)	g=0;
			else		g=255*((x^y)&1);
			r=0;
			b=0;
			break;
		case 2:
			if (b>170)	b=255;
			else
			if (b<85)	b=0;
			else		b=255*((x^y)&1);
			r=0;
			g=0;
			break;
		}
		if (r|g|b)
			return ORIC_COLOR_WHITE; 
		return ORIC_COLOR_BLACK; 
		break;

	case DITHER_ORDERED:
		//
		// Use a dithering matrix
		//
		int		bit;

		bit=1 << ((x&3) | ((y&3)<<2));

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
		break;

	case DITHER_FLOYD:
		break;

	default:
		break;
	}
	return ORIC_COLOR_BLACK; 
}





ORIC_COLOR CHires::convert_pixel_rb(FIBITMAP *dib,int x,int y)
{
	RGB				rgb1;
	RGB				rgb2;
	RGB				rgb3;
	unsigned char	r,gb;

	int	c;

	GetColor(dib,&rgb1,x,y+0);
	GetColor(dib,&rgb2,x,y+1);
	GetColor(dib,&rgb3,x,y+2);

	r=(rgb1.red+rgb2.red	+rgb3.red)/3;
	gb=(rgb1.green+rgb2.green+rgb3.green+rgb1.blue+rgb2.blue	+rgb3.blue)/6;

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
			else		r=255*((x^y)&1);
			gb=0;
			break;
		case 1:
			if (gb>170)	gb=255;
			else
			if (gb<85)	gb=0;
			else		gb=255*((x^y)&1);
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







void CHires::convert_monochrom(FIBITMAP *dib)
{
	//
	// Perform the global dithering, if required
	//
	switch (m_dither)
	{
	case DITHER_RIEMERSMA:
		dither_riemersma_monochrom(dib,m_buffer_width,m_buffer_height);
		m_dither=DITHER_NONE;
		break;
	}

	
	//
	// Perform the HIRES convers
	//
	unsigned char	*ptr_hires;
	ORIC_COLOR	color;
	int	x,y,col,bit,val;

	ptr_hires=m_buffer;
	for (y=0;y<m_buffer_height;y++)
	{
		x=0;
		for (col=0;col<m_buffer_cols;col++)
		{
			val=0;
			for (bit=0;bit<6;bit++)
			{
				val<<=1;
				color=convert_pixel_monochrom(dib,x,y);
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


void CHires::convert_twilighte_mask(FIBITMAP *dib)
{
	//
	// Perform the global dithering, if required
	//
	switch (m_dither)
	{
	case DITHER_RIEMERSMA:
		dither_riemersma_monochrom(dib,m_buffer_width,m_buffer_height);
		m_dither=DITHER_NONE;
		break;
	}

	
	//
	// Perform the HIRES convers
	//
	unsigned char	*ptr_hires;
	int	x,y,col,bit;

	ptr_hires=m_buffer;
	for (y=0;y<m_buffer_height;y++)
	{
		x=0;
		for (col=0;col<m_buffer_cols;col++)
		{
			int mask=0;
			int mask_control=0;
			int val=0;
			for (bit=0;bit<6;bit++)
			{
				val<<=1;
				mask_control<<=1;

				// Get the original pixel color 
				BYTE *ptr_byte=FreeImage_GetBitsRowCol(dib,x,y);
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



void CHires::convert_rgb(FIBITMAP *dib)
{
	//
	// Perform the global dithering, if required
	//
	switch (m_dither)
	{
	case DITHER_RIEMERSMA:
		dither_riemersma_rgb(dib,m_buffer_width,m_buffer_height);
		m_dither=DITHER_NONE;
		break;
	}



	//
	// Perform the HIRES convers
	//
	unsigned char	*ptr_hires;
	ORIC_COLOR	color;
	int	x,y,col,bit,val;

	ptr_hires=m_buffer;
	for (y=0;y<m_buffer_height;y++)
	{
		//
		// Write RGB attrib
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

		x=0;
		for (col=1;col<m_buffer_cols;col++)
		{
			val=0;
			for (bit=0;bit<6;bit++)
			{
				val<<=1;
				color=convert_pixel_rgb(dib,x,y);
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









void CHires::convert_rb(FIBITMAP *dib)
{
	//
	// Perform the global dithering, if required
	//
	switch (m_dither)
	{
	case DITHER_RIEMERSMA:
		dither_riemersma_rgb(dib,m_buffer_width,m_buffer_height);
		m_dither=DITHER_NONE;
		break;
	}



	//
	// Perform the HIRES convers
	//
	unsigned char *ptr_hires=m_buffer;
	for (int y=0;y<m_buffer_height;y++)
	{
		//
		// Write RGB attrib
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
			int val=0;
			for (int bit=0;bit<6;bit++)
			{
				val<<=1;
				ORIC_COLOR color=convert_pixel_rb(dib,x,y);
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
typedef struct
{
	unsigned char	color_count;
	unsigned char	color[2];
	unsigned char	value;
}BLOC6;



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
			int	color;
			for (color=0;color<8;color++)
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
			int	color;
			for (color=0;color<8;color++)
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







void CHires::convert_colored(FIBITMAP *dib)
{
	int				x,y;
	int				col,bit;
	int				color;
	int				val;


	//
	// Phase 1: Create a buffer with infos
	//
	bool flag=false;
	unsigned char *ptr_hires=m_buffer;

	bool error_in_picture=false;

	for (y=0;y<m_buffer_height;y++)
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
		x=0;
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
				BYTE *ptr_byte=FreeImage_GetBitsRowCol(dib,x,y);
				color=0;
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

		PtrSpaces=BufferSpaces+strlen(BufferSpaces);
		gcur_line=y;
		gmax_count=m_buffer_cols;
		if (RecurseLine(m_buffer_cols,ptr_bloc6,ptr_hires,0,7))
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











void CHires::convert(FIBITMAP *dib)
{
	clear_screen();

	switch (m_format)
	{
	case FORMAT_MONOCHROM:
		convert_monochrom(dib);
		break;

	case FORMAT_COLORED:
		convert_colored(dib);
		break;

	case FORMAT_RGB:
		convert_rgb(dib);
		break;

	case FORMAT_RB:
		convert_rb(dib);
		break;

	case FORMAT_TRUETEXT:
		break;

	case FORMAT_SHIFTER:
		convert_shifter(dib);
		break;

	case FORMAT_TWILIGHTE_MASK:
		convert_twilighte_mask(dib);
		break;

	default:
		// Oops
		break;
	}
}



void CHires::snapshot(FIBITMAP *dib)
{
	unsigned char	*ptr_hires;
	ORIC_COLOR		paper,ink;
	ORIC_COLOR		cpaper,cink;
	int	x,y,col,bit,val,val2;

	ptr_hires=m_buffer;
	for (y=0;y<m_buffer_height;y++)
	{
		paper	=ORIC_COLOR_BLACK;
		ink		=ORIC_COLOR_WHITE;

		x=0;
		for (col=0;col<m_buffer_cols;col++)
		{
			val=*ptr_hires++;

			val2=val&127;

			cpaper	=paper;
			cink	=ink;
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

			for (bit=0;bit<6;bit++)
			{
				if (val2 & (1<<(5-bit)))
				{
					write_pixel_rgb(dib,x,y,cink);
				}
				else
				{
					write_pixel_rgb(dib,x,y,cpaper);
				}
				x++;
			}
		}
	}
}



void CHires::convert_shifter(FIBITMAP *dib)
{
	//
	// Perform the Atari ST bitplan conversion
	//
	unsigned char	*ptr_hires=(unsigned char*)m_buffer;
	for (int y=0;y<m_buffer_height;y++)
	{
		int x=0;
		while (x<m_buffer_width)
		{
			int p0=0;
			int p1=0;
			int p2=0;
			int p3=0;

			for (int bit=0;bit<16;bit++)
			{
				p0<<=1;
				p1<<=1;
				p2<<=1;
				p3<<=1;
				int color=convert_pixel_shifter(dib,x,y);
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
			*ptr_hires++=(p0>>8)&255;
			*ptr_hires++=p0&255;
			*ptr_hires++=(p1>>8)&255;
			*ptr_hires++=p1&255;
			*ptr_hires++=(p2>>8)&255;
			*ptr_hires++=p2&255;
			*ptr_hires++=(p3>>8)&255;
			*ptr_hires++=p3&255;
		}
	}
}


int CHires::get_shifter_color(int r,int g,int b)
{
	r=(r>>5)+((r>>1)&8);
	g=(g>>5)+((g>>1)&8);
	b=(b>>5)+((b>>1)&8);

	int color=((r&15)<<8)|((g&15)<<4)|(b&15);
	return color;
}

int CHires::convert_pixel_shifter(FIBITMAP *dib,int x,int y)
{
	RGB				rgb;
	unsigned char	r,g,b;

	GetColor(dib,&rgb,x,y);

	r=rgb.red;
	g=rgb.green;
	b=rgb.blue;

	int color=get_shifter_color(r,g,b);

	std::map<int,int>::iterator it=m_clut.find(color);
	if (it==m_clut.end())
	{
		// Not found
		int index=m_clut.size();
		m_clut[color]=index;
		return index;
	}
	else
	{
		// Return existing index
		return (*it).second;
	}
}

void CHires::save_clut(long handle)
{
	unsigned char clut[32];

	std::map<int,int>::iterator it=m_clut.begin();
	while (it!=m_clut.end())
	{
		int index=(*it).second;
		int color=(*it).first;
		if (index<16)
		{
			// Atari ST is a big endian machine
			clut[index*2+0]=((color>>8)&255);
			clut[index*2+1]=(color&255);
		}
		++it;
	}	
	_write(handle,clut,32);
}
