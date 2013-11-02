//
// This program simply display a compressed picture on the hires screen
//
// 02-11-2013 NB removed lprintf from file_unpackc saving a couple of K
// adding routine to wipe the screen
#include <lib.h>
void WipeScreen();
extern unsigned char LabelPicture[];


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
 WipeScreen wipes the hires screen attaractively
*/
void WipeScreen(){
	unsigned char Row;
	//unsigned int EvenScreenAddress=0xA001;	// start address of hires screen (even rows)
	//unsigned int OddScreenAddress=0xA029;   // start address of hires screen (odd rows)
	unsigned int StartAddress;
	unsigned char x;
	unsigned char z;
	for ( x=0; x<2 ; x++ ){
		StartAddress=0xA001;
		z=196;
		if (x==1){
			StartAddress=0xA029;
			z=197;
		}
		for (Row=x; Row<z; Row+=2){
			poke(StartAddress+(Row*40),0x0000);	// black
		}
	}
}

void main()
{
	hires();
	//file_unpackc((unsigned char*)0xa000,LabelPicture);
	file_unpack((unsigned char*)0xa000,LabelPicture);
	WipeScreen();
}

