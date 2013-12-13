//
// This program simply display a compressed picture on the hires screen
//
// 02-11-2013 NB removed lprintf from file_unpackc saving a couple of K
// adding routine to wipe the screen
// 04-11-2013 NB Added credits and tribute text, setting font here instead of main prog
// 05-11-2013 NB Calling Hires from CopyFont saving 3 bytes!
// 02-12-2013 NB slightly different message
// 09-12-2013 NB cycling more times but faster
#include <lib.h>
void WipeScreen();
void WipeScreenB();
void Pause();
void PrintMessage();
extern unsigned char LabelPicture[];
unsigned int PauseTime;
extern unsigned char Font_6x8_runic1_partial[472]; // runic oric chars (59chars * 8)
unsigned char erasetext=120;		// how many lines to erase (3*40)=120;
extern char* message;
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
void WipeScreen(){
	PauseTime=55000; Pause();	// linger on screen for a while
	WipeScreenB();
	WipeScreenB();
	WipeScreenB();
}
void WipeScreenB(){
	unsigned char Row,x,z,Count;
	unsigned int Cell, StartAddress;
	//unsigned int EvenScreenAddress=0xA001;	// start address of hires screen (even rows)
	//unsigned int OddScreenAddress=0xA029;   // start address of hires screen (odd rows)
	char Color;
	for (Color=7;Color>=1;Color--){ // cycle through colors before blanking
		for ( x=0; x<2 ; x++ ){
			Count=0;
			StartAddress=0xA001;
			z=198;
			if (x==1){
				StartAddress=0xA029;
				z=199;
			}
			//poke(StartAddress,0x0000);
			//PauseTime=100;Pause();
			for (Row=x; Row<=z; Row+=2){
				poke(StartAddress+(Count*80),Color);	
				Count++;
			}
		}
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
  	message="   HNEFATAFL V0.098 BY NEIL BARNES\n  ORIGINAL ARTWORK : DARREN BENNETT\nTHX TO:DBUG,CHEMA,JAMESD,XERON,IBISUM";       	
  	PrintMessage();
	//file_unpackc((unsigned char*)0xa000,LabelPicture);
	file_unpack((unsigned char*)0xa000,LabelPicture);
	WipeScreen();
	message="            IN MEMORY OF\n    JONATHAN 'TWILIGHTE' BRISTOW\n       ORIC LEGEND: 1968-2013";
  	PrintMessage();
}

