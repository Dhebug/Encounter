//
// This program simply display a compressed picture on the hires screen
//
// 02-11-2013 NB removed lprintf from file_unpackc saving a couple of K
// adding routine to wipe the screen
// 04-11-2013 NB Added credits and tribute text, setting font here instead of main prog
// 05-11-2013 NB Calling Hires from CopyFont saving 3 bytes!
// 02-12-2013 NB slightly different message
// 09-12-2013 NB cycling more times but faster
// 24-12-2013 NB Using CheckerBoard
// 30-12-2013 NB made smaller...
#include <lib.h>
#define BLACK 0
#define RED	1
#define GREEN 2
#define YELLOW 3
#define BLUE 4
#define MAGENTA 5
#define CYAN 6
#define WHITE 7
//void WipeScreen();
void WipeScreenB();
void WipeScreenC();
void Pause();
void PrintMessage();
void subCheckerBoard();
void subCheckerBoard2();
extern unsigned char LabelPicture[];
unsigned int PauseTime,StartAddress;
extern unsigned char Font_6x8_runic1_partial[472]; // runic oric chars (59chars * 8)
unsigned char erasetext=120;		// how many lines to erase (3*40)=120;
extern char* message;
unsigned char a,b,c,cx,cy,x,Row,Count,z,Color;
void file_unpackc(unsigned char *buf_dest,unsigned char *buf_src)
{
	unsigned int 	size;
	unsigned char	value;
	unsigned char	maskvalue;
	unsigned char	andvalue;
	unsigned int	offset;
	unsigned int	nb;
	//buf_src+=4;	// Skipp LZ77 heqder
	size=8000;	//8000;
	//buf_src+=4;	// Skipp the size
	buf_src+=8;	// Skipp LZ77 header and Size
	andvalue=0;
	while (size)
	{
		//
		// Reload encoding type mask
		//
		if (!andvalue)
		{
			andvalue=1;
			value=*buf_src++;
			maskvalue=value;
		}
		if (maskvalue & andvalue)
		{ 
			//
			// Copy 1 unsigned char
			//
			value=*buf_src++;
			*buf_dest++=value;
			size--;
		}
		else
		{
			//
			// Copy with offset
			//
			// At this point, the source pointer points to a two byte
			// value that actually contains a 4 bits counter, and a 
			// 12 bit offset to point back into the depacked stream.
			// The counter is in the 4 high order bits.
			//
			// Original
			offset = buf_src[0];			// Read 16 bits non alligned datas...
			offset|=((unsigned int)(buf_src[1]&0x0F))<<8;
			offset+=1;
			
			nb	   =(buf_src[1]>>4)+3;

			buf_src+=2;

			size-=nb;
			while (nb)
			{
				value=*(buf_dest-offset);
				*buf_dest=value;
				buf_dest++;
				nb--;
			}
		}
		andvalue<<=1;
	}
	*(unsigned char*)(0xbfde)=18;
}
/*
 WipeScreen wipes the hires screen attractively
*/
/*
void WipeScreen(){
	PauseTime=55000; Pause();	// linger on screen for a while
	WipeScreenB();
	WipeScreenB();
	WipeScreenB();
}*/
void WipeScreenB(){
	
	//unsigned int EvenScreenAddress=0xA001;	// start address of hires screen (even rows)
	//unsigned int OddScreenAddress=0xA029;   // start address of hires screen (odd rows)
	//PauseTime=15000;
	//Pause();
	x=0;StartAddress=0xA001;z=198;WipeScreenC();
	//Pause();
	x=1;StartAddress=0xA029;z=199;WipeScreenC();
}
void WipeScreenC(){
	Count=0;
	for (Row=x; Row<=z; Row+=2){
		poke(StartAddress+(Count*80),Color);	
		Count++;
	}
}
// CheckerBoard :screenwipe, x controls number of cols (different at start of game)
void CheckerBoard(){
	a=0;subCheckerBoard2();
	PauseTime=1000; Pause();
	a=1;subCheckerBoard2();
	PauseTime=1000; Pause();
	//PauseTime=25000; Pause();
	a=1;subCheckerBoard2();
	PauseTime=1000; Pause();
	a=0;subCheckerBoard2();
	PauseTime=1000; Pause();

}
void subCheckerBoard(){
	for (cx=b; cx<12; cx+=2){
		inverse2(); PauseTime=50; Pause();
	}
}
void subCheckerBoard2(){
	for (cy=0; cy<9; cy++){
		b=a;
		subCheckerBoard();
		if (cy < 9 ) cy++;
		b=0;
		if (a==0) b=1;
		subCheckerBoard();
	}
}
/* paustime */
void Pause(){
  int p;
  for (p=0; p<PauseTime;p++){};
}
void main()
{
	CopyFont();	// hires called from CopyFont ASM routine
	//hires();
  	setflags(0);	// No keyclick, no cursor, no nothing
  	message="    HNEFATAFL V1.1 BY NEIL BARNES\n  ORIGINAL ARTWORK : DARREN BENNETT\nTHX TO:DBUG,CHEMA,JAMESD,XERON,IBISUM";       	
  	PrintMessage();
	//file_unpackc((unsigned char*)0xa000,LabelPicture);
	file_unpack((unsigned char*)0xa000,LabelPicture);
	PauseTime=50000; Pause();
	CheckerBoard();
	//CheckerBoard();
	//CheckerBoard();
	//CheckerBoard();
	message="            IN MEMORY OF\n    JONATHAN 'TWILIGHTE' BRISTOW\n       ORIC LEGEND: 1968-2013";
  	PrintMessage();
	Color=RED;WipeScreenB();	
	Color=MAGENTA;WipeScreenB(); 
	Color=WHITE;WipeScreenB();
	Color=RED;WipeScreenB();	
	Color=MAGENTA;WipeScreenB(); 
	Color=YELLOW;WipeScreenB();	
	Color=RED;WipeScreenB();
	Color=MAGENTA;WipeScreenB(); 
	Color=BLUE;WipeScreenB();	
	Color=RED;WipeScreenB(); 
	Color=MAGENTA;WipeScreenB();
	Color=GREEN;WipeScreenB();	
	Color=MAGENTA;WipeScreenB(); 
	Color=RED;WipeScreenB();	
	PauseTime=25000;Pause();
}

