// main.c by Barnsey123
// 22-03-2011 prog to draw a grid (for viking game)
#include <lib.h>
void drawgrid(unsigned int x,unsigned int y, unsigned int boxsize, unsigned int boxcount)
{
	unsigned int a;
	unsigned int b;
	unsigned int c;	// counter
	b1=boxsize*boxcount;
	hires();
	a=x;
	b=y;
	for (c=0;c<=boxcount;c++) // draw vertical lines
		{
		curset(a,b,1);
		draw(b1,0,1);
		//linedraw(a0,0,0,b1);
		a+=boxsize;
		}
	a=x;
	for (c=0;c<=boxcount;c++) // draw horizontal lines
		{
		curset(a,b,1);
		draw(b1,0,1);
		//linedraw(0,a0,b1,0);
		b+=boxsize;
		}
	//curset(x,y,1);
	//draw(x1,y1,1);
} 

void main()
{
	unsigned int boxsize;	// box size
	unsigned int boxcount;	// number of boxes
	boxsize=15;		// adjust for size of boxes
	boxcount=11;	// adjust for number of boxes
	drawgrid(0,0,boxsize,boxcount);
}
