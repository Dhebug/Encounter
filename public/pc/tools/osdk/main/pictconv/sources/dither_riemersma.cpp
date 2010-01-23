/* Riemersma dither
*
* This program reads in an uncompressed gray-scale image with one byte per
* pixel and a size of 256*256 pixels (no image header). It dithers the image
* and writes an output image in the same format.
*
* This program was tested with Borland C++ 3.1 16-bit (DOS), compiled in
* large memory model. For other compilers, you may have to replace the
* calls to malloc() and _ffree() with straight malloc() and free() calls.
*/
#include <malloc.h>     // for malloc() and _ffree()
#include <math.h>		// for exp() and log()

#include "getpixel.h"
#include "image.h"


#define max(a,b)	(((a)>(b))?(a):(b))

#define WIDTH   240	//256
#define HEIGHT  200	//256

#define BLOCKSIZE 16384 // read in chunks of 16 kBytes

enum 
{
	NONE,
	UP,
	LEFT,
	DOWN,
	RIGHT,
};



// variables needed for the Riemersma dither algorithm
static int cur_x=0, cur_y=0;
static int img_width=0, img_height=0;
static unsigned char *img_ptr;

#define SIZE 16				// queue size: number of pixels remembered
#define MAX  16				// relative weight of youngest pixel in the queue, versus the oldest pixel

static int weights[SIZE];	// weights for the errors of recent pixels

static void init_weights(int a[],int size,int max)
{
	double m = exp(log((double)max)/(size-1));
	double v;
	int i;
	
	for (i=0, v=1.0; i<size; i++) 
	{
		a[i]=(int)(v+0.5);  // store rounded value
		v*=m;               // next value
	} 
}



static void dither_pixel(unsigned char *pixel)
{
	static int error[SIZE]; // queue with error values of recent pixels
	int i,pvalue,err;
	
	for (i=0,err=0L; i<SIZE; i++)
		err+=error[i]*weights[i];
	pvalue=*pixel + err/MAX;
	pvalue = (pvalue>=128) ? 255 : 0;
	memmove(error,error+1,(SIZE-1)*sizeof error[0]);    // shift queue
	error[SIZE-1] = *pixel - pvalue;
	*pixel=(unsigned char)pvalue;
}



static void move(int direction)
{
	// dither the current pixel
	if (cur_x>=0 && cur_x<img_width && cur_y>=0 && cur_y<img_height)
	{
		dither_pixel(img_ptr);
	}
	
	// move to the next pixel
	switch (direction) 
	{
	case LEFT:
		cur_x--;
		img_ptr--;
		break;
	case RIGHT:
		cur_x++;
		img_ptr++;
		break;
	case UP:
		cur_y--;
		img_ptr-=img_width;
		break;
	case DOWN:
		cur_y++;
		img_ptr+=img_width;
		break;
	}
}



void hilbert_level(int level,int direction)
{
	if (level==1) 
	{
		switch (direction) 
		{
		case LEFT:
			move(RIGHT);
			move(DOWN);
			move(LEFT);
			break;
		case RIGHT:
			move(LEFT);
			move(UP);
			move(RIGHT);
			break;
		case UP:
			move(DOWN);
			move(RIGHT);
			move(UP);
			break;
		case DOWN:
			move(UP);
			move(LEFT);
			move(DOWN);
			break;
		} 
	} 
	else 
	{
		switch (direction) 
		{
		case LEFT:
			hilbert_level(level-1,UP);
			move(RIGHT);
			hilbert_level(level-1,LEFT);
			move(DOWN);
			hilbert_level(level-1,LEFT);
			move(LEFT);
			hilbert_level(level-1,DOWN);
			break;
		case RIGHT:
			hilbert_level(level-1,DOWN);
			move(LEFT);
			hilbert_level(level-1,RIGHT);
			move(UP);
			hilbert_level(level-1,RIGHT);
			move(RIGHT);
			hilbert_level(level-1,UP);
			break;
		case UP:
			hilbert_level(level-1,LEFT);
			move(DOWN);
			hilbert_level(level-1,UP);
			move(RIGHT);
			hilbert_level(level-1,UP);
			move(UP);
			hilbert_level(level-1,RIGHT);
			break;
		case DOWN:
			hilbert_level(level-1,RIGHT);
			move(UP);
			hilbert_level(level-1,DOWN);
			move(LEFT);
			hilbert_level(level-1,DOWN);
			move(DOWN);
			hilbert_level(level-1,LEFT);
			break;
		} 
	} 
}


int log2(int value)
{
	int result=0;
	while (value>1) 
	{
		value >>= 1;
		result++;
	} 
	return result;
}


void dither_riemersma_2(unsigned char *image,int width,int height)
{
	int level,size;
	
	/* determine the required order of the Hilbert curve */
	size=max(width,height);
	level=log2(size);
	if ((1L << level) < size)
		level++;
	
	init_weights(weights,SIZE,MAX);
	img_ptr=image;
	img_width=width;
	img_height=height;
	cur_x=0;
	cur_y=0;
	if (level>0)
	{
		hilbert_level(level,UP);
	}

	move(NONE);
}




void dither_riemersma_monochrom(ImageContainer& sourceImage,int width,int height)
{
	unsigned char *image=(unsigned char*)malloc(width*height);

	//
	// Create a mono buffer
	//
	unsigned char *ptr_image=image;
	for (int y=0;y<height;y++)
	{
		for (int x=0;x<width;x++)
		{
			RgbColor rgb=sourceImage.ReadColor(x,y);
			*ptr_image++=(rgb.m_red+rgb.m_green+rgb.m_blue)/3;
			/*
			if (((rgb.m_red+rgb.m_green+rgb.m_blue)/3)>127)
			{
				*ptr_image++=255;				
			}
			else
			{
				*ptr_image++=0;
			}
			*/
		}
	}

	//
	// Perform dithering
	//
	dither_riemersma_2(image,width,height);

	//
	// Convert again
	//
	ptr_image=image;
	for (int y=0;y<height;y++)
	{
		for (int x=0;x<width;x++)
		{
			RgbColor rgb;
			if ((*ptr_image)>127)
			{
				rgb.m_red		=255;
				rgb.m_green	=255;
				rgb.m_blue	=255;
			}
			else
			{
				rgb.m_red		=0;
				rgb.m_green	=0;
				rgb.m_blue	=0;
			}
			ptr_image++;
			sourceImage.WriteColor(rgb,x,y);
		}
	}

	free(image);
}




void dither_riemersma_rgb(ImageContainer& sourceImage,int width,int height)
{
	RgbColor rgb1;
	RgbColor rgb2;
	RgbColor rgb3;

	unsigned char *image=(unsigned char*)malloc(width*height);

	unsigned char* prgb1=&rgb1.m_red;
	unsigned char* prgb2=&rgb2.m_red;
	unsigned char* prgb3=&rgb3.m_red;
	for (int pass=0;pass<3;pass++)
	{
		//
		// Create a mono buffer
		//
		unsigned char *ptr_image=image;
		for (int y=pass;y<height;y+=3)
		{
			for (int x=0;x<width;x++)
			{
				rgb1=sourceImage.ReadColor(x,y+0);
				rgb2=sourceImage.ReadColor(x,y+1);
				rgb3=sourceImage.ReadColor(x,y+2);
				*ptr_image++=(prgb1[pass]+prgb2[pass]+prgb3[pass])/3;
			}
		}

		//
		// Perform dithering
		//
		dither_riemersma_2(image,width,(height/3));

		//
		// Convert again
		//
		ptr_image=image;
		for (int y=pass;y<height;y+=3)
		{
			for (int x=0;x<width;x++)
			{
				rgb1=sourceImage.ReadColor(x,y+0);
				rgb2=sourceImage.ReadColor(x,y+1);
				rgb3=sourceImage.ReadColor(x,y+2);

				if ((*ptr_image)>127)
				{
					prgb1[pass]=255;
					prgb2[pass]=255;
					prgb3[pass]=255;
				}
				else
				{
					prgb1[pass]=0;
					prgb2[pass]=0;
					prgb3[pass]=0;
				}
				ptr_image++;
				sourceImage.WriteColor(rgb1,x,y+0);
				sourceImage.WriteColor(rgb2,x,y+1);
				sourceImage.WriteColor(rgb3,x,y+2);
			}
		}
	}

	free(image);
}



