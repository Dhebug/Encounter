//
// This program simply display a compressed picture on the hires screen
//

#include <lib.h>

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


void main()
{
	hires();
	//file_unpackc((unsigned char*)0xa000,LabelPicture);
	file_unpack((unsigned char*)0xa000,LabelPicture);
}

