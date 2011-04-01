// main.c by Barnsey123
// 22-03-2011 prog to draw a grid (for viking game)
#include <lib.h>
void linedraw(unsigned int x0,unsigned int y0, unsigned int x1, unsigned int y1)
{
	curset(x0,y0,1);
	draw(x1,y1,1);
} 

void main()
{
	unsigned int a0;
	unsigned int b1;
	unsigned int boxsize;	// box size
	unsigned int boxcount;	// number of boxes
	unsigned int c;	// counter
	boxsize=15;		// adjust for size of boxes
	boxcount=11;	// adjust for number of boxes
	b1=boxsize*boxcount;
	hires();
	a0=0;
	for (c=0;c<=boxcount;c++) // draw vertical lines
		{
		linedraw(a0,0,0,b1);
		a0+=boxsize;
		}
	a0=0;
	for (c=0;c<=boxcount;c++) // draw horizontal lines
		{
		linedraw(0,a0,b1,0);
		a0+=boxsize;
		}
	return;
}
