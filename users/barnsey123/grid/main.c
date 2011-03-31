// main.c by Barnsey123
// 22-03-2011 prog to draw a grid (for viking game)
// 23-03-2011 create new drawgrid function
#include <lib.h>
void drawgrid(unsigned int x,unsigned int y, unsigned int boxsize, unsigned int boxcountx, unsigned int boxcounty)
{
	// draws the main grid
	/* 		***** ARGUMENTS *****
	x			=	starting x position
	y			=	starting y position
	boxsize		=	size of box
	boxcount	=	number of boxes
	*/
	unsigned int a;	// copy of x
	unsigned int b;	// copy of y
	unsigned int c;	// counter
	unsigned int lengthx;	// linelength across
	unsigned int lengthy;	// linelength down
	lengthx=boxsize*boxcountx;	// calculate length of lines across
	lengthy=boxsize*boxcounty;	// calculate length of lines down
	a=x;	// starting x
 	b=y;	// starting y
	for (c=0;c<=boxcountx;c++) // draw vertical lines
		{
		curset(a,b,1);
		draw(0,lengthy,1);
		a+=boxsize;	// add boxsize to a
		}
	a=x;	// reset a
	for (c=0;c<=boxcounty;c++) // draw horizontal lines
		{
		curset(a,b,1);
		draw(lengthx,0,1);
		b+=boxsize;
		}
} 
void drawattacktile(unsigned int x, unsigned int y)
{
	// draws the attackers tile
	// ARGUMENTS starting x, y position for curset
	unsigned short int loop;
	unsigned short int z;	// line length
	z=13;
	for (loop=0;loop<3;loop++)
		{
		curset(x,y,1);
		draw(z,0,1);
		draw(0,z,1);
		draw(-z,0,1);
		draw(0,-z,1);
		z=z-4;
		x+=2;
		y+=2;	
		}
}
void drawdefendtile(unsigned int x, unsigned int y)
{
	// draws the attackers tile
	// ARGUMENTS starting x, y position for curset
	unsigned short int loop;
	unsigned short int z;	// line length
	z=13;
	for (loop=0;loop<3;loop++)
		{
		curset(x,y,1);
		draw(z,0,1);
		draw(0,z,1);
		draw(-z,0,1);
		draw(0,-z,1);
		z=z-4;
		x+=2;
		y+=2;	
		}
}
void drawkingtile(unsigned int x, unsigned int y)
{
	// draws the king tile
	// ARGUMENTS starting x, y position for curset
	curset(x,y,1);
	draw(5,0,1);
	draw(0,5,1);
	draw(-5,0,1);
	draw(0,-5,1);
	curset(x+8,y,1);
	draw(5,0,1);
	draw(0,5,1);
	draw(-5,0,1);
	draw(0,-5,1);
	curset(x,y+8,1);
	draw(5,0,1);
	draw(0,5,1);
	draw(-5,0,1);
	draw(0,-5,1);
	curset(x+8,y+8,1);
	draw(5,0,1);
	draw(0,5,1);
	draw(-5,0,1);
	draw(0,-5,1);
	curset(x+2,y+2,1);
	draw(9,0,2);
	draw(0,9,2);
	draw(-9,0,2);
	draw(0,-9,2);
	/*
	unsigned int row;	
	unsigned int col;
	unsigned int xpos;
	unsigned int ypos;
	unsigned short int tile[14][14]={
	{0,0,0,1,0,0,0,0,0,0,1,0,0,0},	
	{0,0,1,0,1,0,0,0,0,1,0,1,0,0},
	{0,1,0,0,0,1,0,0,1,0,0,0,1,0},
	{1,0,0,0,0,0,1,1,0,0,0,0,0,1},
	{0,1,0,0,0,1,0,0,1,0,0,0,1,0},
	{0,0,1,0,1,0,0,0,0,1,0,1,0,0},
	{0,0,0,1,0,0,1,1,0,0,1,0,0,0},
	{0,0,0,1,0,0,1,1,0,0,1,0,0,0},
	{0,0,1,0,1,0,0,0,0,1,0,1,0,0},
	{0,1,0,0,0,1,0,0,1,0,0,0,1,0},
	{1,0,0,0,0,0,1,1,0,0,0,0,0,1},
	{0,1,0,0,0,1,0,0,1,0,0,0,1,0},
	{0,0,1,0,1,0,0,0,0,1,0,1,0,0},
	{0,0,0,1,0,0,0,0,0,0,1,0,0,0}};
	xpos=x;
	ypos=y;
	for (row=0;row<14;row++)
		{
		for (col=0;col<14;col++)
			{
			curset(xpos,ypos,tile[row][col]);
			xpos++;
			}
		xpos=x;
		ypos++;
		}
	*/	
}

void drawtiles(unsigned int x, unsigned int y, unsigned int box)
{
	// draws the tiles on the board
	/* ARGUMENTS starting x,y position of grid */
	unsigned int tilex;			// starting tile x position
	unsigned int tiley;			// strating tile y position
	unsigned int row;			// loop through tiles array by row
	unsigned int col;			// loop through tiles array by column
	// populate tiles with tile type
	// 0=blank
	// 1=king square
	// 2=attacker square
	// 3=defender square
	unsigned short int tiles[11][11]={
		{1,0,0,2,2,2,2,2,0,0,1},
		{0,0,0,0,0,2,0,0,0,0,0},
		{0,0,0,0,0,0,0,0,0,0,0},
		{2,0,0,0,0,3,0,0,0,0,2},
		{2,0,0,0,3,3,3,0,0,0,2},
		{2,2,0,3,3,1,3,3,0,2,2},
		{2,0,0,0,3,3,3,0,0,0,2},
		{2,0,0,0,0,3,0,0,0,0,2},
		{0,0,0,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,2,0,0,0,0,0},
		{1,0,0,2,2,2,2,2,0,0,1}};
	tilex=x+2;					// offset by 2
	tiley=y+2;					// offset by 2
	for (row=0;row<11;row++)
		{
		for (col=0;col<11;col++)
			{
			if ( tiles[row][col] == 1 ) drawkingtile(tilex,tiley);
			if ( tiles[row][col] == 2 ) drawattacktile(tilex,tiley);
			if ( tiles[row][col] == 3 ) drawdefendtile(tilex,tiley);
			tilex+=box;			
			}
		tilex=x+2;
		tiley+=box;
		}
}
void drawboard(unsigned int gridx, unsigned int gridy)
{
	// draws the main board
	/* ARGUMENTS starting x,y co-ordinates of grid*/
	unsigned int boxsize;	// box size
	unsigned int boxcountx;	// number of boxes across
	unsigned int boxcounty; // number of boxes down	
	// boxsize=15;		// adjust for size of boxes
	boxsize=17;
	boxcountx=11;	// adjust for number of boxes across
	boxcounty=11;	// adjust for number of boxes down	
	hires();
	ink(6);			// color of board
	// draw grid
	drawgrid(gridx,gridy,boxsize,boxcountx,boxcounty);
	// draw tiles
	drawtiles(gridx,gridy,boxsize);
}

void main()
{
	unsigned int boardx;		// starting x co-ord of board
	unsigned int boardy;		// starting y co-ord of board
	boardx=12;		// adjust for starting x pos
	boardy=0;		// adjust for starting y pos
	drawboard(boardx,boardy);
	return;
}
