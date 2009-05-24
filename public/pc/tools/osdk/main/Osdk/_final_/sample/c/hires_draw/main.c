//
// This is a small program that show how to draw graphics with basic commands
//

#include <lib.h>


void draw_rectangle(unsigned char x0,
				 unsigned char y0,
				 unsigned char x1,
				 unsigned char y1)
{
	curset(x0,y0,1);
	draw(x1-x0,0,1);
	draw(0,y1-y0,1);
	draw(x0-x1,0,1);
	draw(0,y0-y1,1);
}


void draw_rectangles()
{
	unsigned char i;
	unsigned char x0,y0;
	unsigned char x1,y1;

	x0=0;
	y0=0;
	x1=2;
	y1=2;
	for (i=0;i<35;i++)
	{
		draw_rectangle(x0,y0,x1,y1);
		x0++;
		y0++;

		x1+=3;
		y1+=2;
	}
}


void draw_circles()
{
	unsigned char i;
	unsigned char x,y;
	unsigned char r;

	x=120;
	y=2;
	r=1;
	for (i=0;i<35;i++)
	{
		curset(x,y,3);
		circle(r,2);
		y=y+2;
		r=r+1;
	}
}

void main()
{
	hires();
	draw_rectangles();
	draw_circles();
}
