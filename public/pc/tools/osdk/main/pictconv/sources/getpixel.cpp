

#include "FreeImage.h"

#include "defines.h"
#include "getpixel.h"


BYTE* FreeImage_GetBitsRowCol(FIBITMAP *dib,int x,int y)
{
	unsigned int dy=FreeImage_GetHeight(dib);
	BYTE *ptr_byte=FreeImage_GetScanLine(dib,dy-y-1);
	ptr_byte+=x*3;
	return ptr_byte;
}



void GetColor(FIBITMAP *dib,RGB *rgb,int x,int y)
{
	rgb->red	=0;
	rgb->green	=0;
	rgb->blue	=0;

	int dx,dy;

	if (x<0)	return;
	if (y<0)	return;

	dx=FreeImage_GetWidth(dib);
	dy=FreeImage_GetHeight(dib);

	if (x>=dx)	return;
	if (y>=dy)	return;

	BYTE *ptr_byte=FreeImage_GetBitsRowCol(dib,x,y);

	unsigned rm,gm,bm;

	rm=FreeImage_GetRedMask(dib);
	gm=FreeImage_GetGreenMask(dib);
	bm=FreeImage_GetBlueMask(dib);

	rgb->blue	=*ptr_byte++;
	rgb->green	=*ptr_byte++;
	rgb->red	=*ptr_byte++;
}



void WriteColor(FIBITMAP *dib,RGB *rgb,int x,int y)
{
	int dx,dy;

	if (x<0)	return;
	if (y<0)	return;

	dx=FreeImage_GetWidth(dib);
	dy=FreeImage_GetHeight(dib);

	if (x>=dx)	return;
	if (y>=dy)	return;

	BYTE *ptr_byte=FreeImage_GetBitsRowCol(dib,x,y);

	*ptr_byte++=rgb->blue;
	*ptr_byte++=rgb->green;
	*ptr_byte++=rgb->red;
}
