//
// This program simply display a compressed picture on the hires screen
//

#include <lib.h>

extern unsigned char LabelPicture[];


void file_unpackc(unsigned char *buf_dest,unsigned char *buf_src)
{
	int 	size;
	unsigned char	value;
	unsigned char	maskvalue;
	unsigned char	andvalue;
	unsigned int	offset;
	int		nb;

	lprintf("file_unpackc\n");
	
	buf_src+=4;	// Skipp LZ77 heqder
	size=8000;	//8000;
	buf_src+=4;	// Skipp the size
	
	andvalue=0;
	while (size>0)
	{
		//
		// Reload encoding type mask
		//
		if (!andvalue)
		{
			andvalue=1;
			value=*buf_src++;
			lprintf("Reload mask: %x (%d)\n",value,value);
			maskvalue=value;
		}
		if (maskvalue & andvalue)
		{ 
			//
			// Copy 1 unsigned char
			//
			/*
			if (buf_dest==((unsigned char*)0xb3e7))
			{
				*(unsigned char*)(0xbfdf)=17;
			}
			*/
			
			value=*buf_src++;
			lprintf("New: byte=%x (%d) from %x to %x)\n",value,value,buf_src,buf_dest);
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

			lprintf("Copy: size=%d offset=%d ",nb,offset);
			lprintf("(from %x-%x to %x-%x) ",buf_dest-offset,buf_dest-offset+nb-1,buf_dest,buf_dest+nb-1);
			
			buf_src+=2;

			size-=nb;
			while (nb>0)
			{
				/*
				if (buf_dest==((unsigned char*)0xb3e7))
				{
					*(unsigned char*)(0xbfdf)=18;
				}
				*/
				
				value=*(buf_dest-offset);
				lprintf("%x,",value);
				*buf_dest=value;
				buf_dest++;
				nb--;
			}
			lprintf("\n");
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

