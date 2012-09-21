// C Source File
// Created 19/08/2007; 18:19:29

#include "global.h"
#include "unpack.h"

int is_hires = 0;

void spin(myint t)
{
	myint i = 100;
	while (t--)
		while (i--);
}

void mymemset(void *p, myint to, int len)
{
  unsigned char *ptr = p;
  while(len--) {
    *ptr++ = (unsigned char)to;
  }
}

void LZ77_UnCompress(unsigned char *buf_src,unsigned char *buf_dest)
{
	UnpackSrc=buf_src;
	UnpackDst=buf_dest;
	Unpack();
}

void fixup_ascii(void)
{
	uint8 *p;
	p = (uint8 *)0x9800 + 8 * '_';
	// redefine GBP to be '_' as per ASCII
	*p++ = 0;
	*p++ = 0;
	*p++ = 0;
	*p++ = 0;

	*p++ = 0;
	*p++ = 0;
	*p++ = 0;
	*p++ = 0xff;
}


