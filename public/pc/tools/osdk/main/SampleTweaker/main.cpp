//
//
//
#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <io.h>
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>

#include <math.h>



/*
bug: having the output (your 0-255) in 0 <= y <= 1 gives "x = 15-2*(log10(1/y)/log10(2))"
 <_Stefan> x is the psg volume from 0 to 15
*/

unsigned char SampleToVolume(unsigned char sample)
{
	if (!sample)
	{
		// To avoid a divide by 0
		return 0;
	}
	else
	{
		double y=(double)sample;
		y=y/255.0;

		double x;
		x = 15.0-2.0*(log10(1.0/y)/log10(2.0));

		if (x<0.0)
		{
			x=0.0;
		}
		else
		if (x>15.0)
		{
			x=15.0;
		}
		return (unsigned char)x;
	}
}



bool LoadFile(const char *ptr_filename,unsigned char *&ptr_buffer,int &size)
{
	struct _finddata_t	file_info_src;
	int	result;

	result=_findfirst(ptr_filename,&file_info_src);
	if (result==-1.L)
	{
		return false;
	}
	_findclose(result);


	size=file_info_src.size;

	ptr_buffer=new unsigned char[size];

	long handle;
	long size_read;

	if (!(handle=_open(ptr_filename,_O_RDONLY|_O_BINARY)))
	{
		return false;
	}
	size_read=_read(handle,ptr_buffer,size);
	_close(handle);

	if (size!=size_read)
	{
		// Read error
		return false;
	}

	return true;
}



bool SaveFile(const char *ptr_filename,unsigned char *ptr_buffer,int size)
{
	long handle;

	if (!(handle=_open(ptr_filename,_O_TRUNC|O_BINARY|O_CREAT|O_WRONLY,_S_IREAD|_S_IWRITE )))
	{
		return false;
	}
	_write(handle,ptr_buffer,size);
	_close(handle);

	return true;
}





// Usage:
// FilePack <source_file> <dest_file>
//


void DisplayError()
{
	printf("\n");
	printf("\nÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿");
	printf("\n³   4bits Sample Merger     ³");
	printf("\n³     vers format ORIC      ³");
	printf("\n³           V0.001          ³");
	printf("\n³ (c) 2002 POINTIER Mickael ³");
	printf("\nÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ");
	printf("\n");
	exit(1);
}



#define NB_ARG	2


bool get_switch(const char *&ptr_arg,const char *ptr_switch)
{
	int	lenght=strlen(ptr_switch);

	if (_memicmp(ptr_arg,ptr_switch,lenght))
	{
		// Not a match
		return false;
	}
	// Validate the parameter
	ptr_arg+=lenght;
	return true;
}


int get_value(const char *&ptr_arg,long default_value)
{
	char	*ptr_end;
	long value=strtoul(ptr_arg,&ptr_end,10);
	if (ptr_arg==ptr_end)
	{
		value=default_value;
	}
	ptr_arg=ptr_end;
	return value;
}


// Calculates log2 of number.  
// http://www-crca.ucsd.edu/~msp/techniques/v0.08/book-html/node8.html
// http://poi.ribbon.free.fr/tmp/freq2regs.htm
// http://logbase2.blogspot.com/2007/12/log-base-2.html
//
// log2(1)=0
// log2(2)=1
// log2(4)=2
// log2(8)=4
float log2( double n )  
{  
  // log(n)/log(2) is log2.  
  return (float)(log( n ) / log( 2.0 ));
}


void main(int argc,char *argv[]) 
{
  long	param;
  long	nb_arg;

  bool	flag_pack=true;
  param=1;									   

  if (argc>1)
  {
    for (;;)
    {
      nb_arg=argc;
      const char *ptr_arg=argv[param];
      /*
      if (get_switch(ptr_arg,"-u"))	// UNPACK
      {
      flag_pack=false;
      argc--;
      param++;
      }
      else 
      if (get_switch(ptr_arg,"-p"))	// PACK
      {
      flag_pack=true;
      argc--;
      param++;
      }
      */
      if (nb_arg==argc)   break;
    }
  }


  if (argc!=(NB_ARG+1))
  {
    DisplayError();
  }


	//
	// Copy last parameters
	//
	char	source_name[_MAX_PATH];
	char	dest_name[_MAX_PATH];

	strcpy(source_name,argv[param]);
	param++;
	strcpy(dest_name,argv[param]);


	unsigned char *ptr_buffer;
	int size_buffer_src;

	if (!LoadFile(source_name,ptr_buffer,size_buffer_src))
	{
		printf("\nUnable to load file '%s'",source_name);
		printf("\n");
		exit(1);
	}

	/*
	//
	// Stupid Raw=>nibble conversion, no frequency change
	//
	ptr_buffer_dst=new unsigned char[size_buffer_src+8];
	size_buffer_dst=size_buffer_src/2;

	unsigned char	b0,b1,b;
	int i;
	unsigned char	*ptr_src;
	unsigned char	*ptr_dst;

	ptr_src=ptr_buffer;
	ptr_dst=ptr_buffer_dst;
	for (i=0;i<size_buffer_dst;i++)
	{
		b0=*ptr_src++;
		b1=*ptr_src++;
		b=(b1&0xF0)|(b0>>4);
		*ptr_dst++=b;
	}
	*/

	//
	// Try to adapt the size of dest buffer based on complex calculations:
	// Move from source frequency to dest frequency, while trying to round
	// on a multiple of 80 samples (or 40 bytes)
	//
	//size_buffer_dst=(size_buffer_src*4000)/44100;	// overflow and get negative on a 581114 bytes sample...

	/*
	int delta=size_buffer_dst%80;
	if (!delta)
	{
		// Perfectly on a 80 multiple (yoohoo)
	}
	else
	if (delta<40)
	{
		// Reduce the size of dest buffer
		size_buffer_dst-=delta;
	}
	else
	{
		// Increase the size of dest buffer
		size_buffer_dst-=delta;
		size_buffer_dst+=80;
	}
	*/

	int size_buffer_dst;
	unsigned char *ptr_buffer_dst;

	// 4.b 'RIFF'
	// 4.b size
	// 4.b 'WAVE'
	// 4.b 'fmt '
#if 0  // ATARI DELTA PACK CODE
	size_buffer_dst=1+(size_buffer_src/2);
	ptr_buffer_dst=new unsigned char[size_buffer_dst+1];

	// Stores a first byte which is the starting value,
	// then encode each value as a 4 bit signed delta relative to the first value
	unsigned char *ptr_src=ptr_buffer;
	unsigned char *ptr_dst=ptr_buffer_dst;

	// Store first byte twice, so the delta are not on an odd address
	unsigned char prev=ptr_src[0];
	*ptr_dst++=prev;

	bool flip=false;
	unsigned char store=0;

	// Then compute the deltas, they will match the following table:
	// Delta:   0  1  2  4  8 16 32 64 128 -64 -32 -16  -8  -4  -2  -1
	// Code:   $0 $1 $2 $3 $4 $5 $6 $7  $8  $9  $A  $B  $C  $D  $E  $F
	char delta_table[16]=
	{
		-64,
		-32,
		-16,
		-8,
		-4,
		-2,
		-1,
		0,
		1,
		2,
		4,
		8,
		16,
		32,
		64,
		127
	};

	int delta_usage[16]={0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};


	for (int i=1;i<size_buffer_src;i++)
	{
		unsigned char delta_index;

		unsigned char next=ptr_src[i];

		int max_error=999;
		delta_index=0;
		for (int delta_entry=0;delta_entry<16;delta_entry++)
		{
			unsigned char new_next=prev+delta_table[delta_entry];
			int error=next-new_next;
			if (error<0)
			{
				error=-error;
			}
			/*
			if (error>127)
			{
				__asm int 3
			}
			*/
			if (error<max_error)
			{
				max_error=error;
				delta_index=delta_entry;
				if (max_error==0)
				{
					// Can't do better than no error
					break;
				}
			}
		}

		unsigned char delta_value=delta_table[delta_index];
		delta_usage[delta_index]++;
		prev+=delta_value;

		store<<=4;
		store|=delta_index;
		flip=!flip;
		if (!flip)
		{
			*ptr_dst++=store;
		}
	}

#else   // ORIC 4BIT CODE
	size_buffer_dst=(size_buffer_src/2)+1;                  // +1 for the 00 final
	ptr_buffer_dst=new unsigned char[size_buffer_dst];

        // ln(1)  -> 0
        // ln(2)  -> 0.6931
        // ln(16) -> 2.77

        // log(1)=0
        // log(16)=1.204
        // 1/log(16)= 0.830482
        // ACHANGERDESUITE


        // Volume levels
        int voltab[] = { 0, 513/257, 828/257, 1239/257, 1923/257, 3238/257, 4926/257, 9110/257, 10344/257, 17876/257, 24682/257, 30442/257, 38844/257, 47270/257, 56402/257, 65535/257};

        // Create a log table
        // 15 -> 1.0    -> 255
        // 14 -> 0.707  -> 180,285
        // 13 -> 0.5    -> 128
        // 12 -> 0.303  ->  77,265
        // 11 -> 0.25   ->  63,75
        // 10 -> 0.1515 ->  38,6325
        //  9 -> 0.125  ->  31,875
        //  8 -> ? 
        //  7 -> 0,0625    -> 15,9375
        //  6 -> ? 
        //  5 -> 0,03125   -> 7,96875
        //  4 -> ?
        //  3 -> 0,015625  -> 3,984375
        //  2 -> ? 
        //  1 -> 0,0078125 -> 1,9921875 
        //  0 -> 0 
        unsigned char logVolume[256];
        int vol=0;
        for (int i=0;i<16;i++)
        {
          int maxvol=voltab[i];
          while (vol<=maxvol)
          {
            logVolume[vol]=i;
            vol++;
          }
        }

	// Convert to 4 bit sample,
	// each byte contains to sample values; one per nibble
	unsigned char *ptr_src=ptr_buffer;
	unsigned char *ptr_dst=ptr_buffer_dst;
	for (int i=0;i<(size_buffer_dst-1);i++)
	{
#if 1
          // Log conversion
	  unsigned char b0=*ptr_src++;
	  b0=logVolume[b0]; //>>4;

	  unsigned char b1=*ptr_src++;
	  b1=logVolume[b1]; //>>4;
          unsigned char b=(b1<<4)|(b0);
#else
          /*
          // Raw conversion
          unsigned char b0=*ptr_src++;
          b0=(((unsigned int)b0)*15)/255;

          unsigned char b1=*ptr_src++;
          b1=(((unsigned int)b1)*15)/255;

          unsigned char b=(b1<<4)|(b0);
          */
          // Error based conversion
          unsigned char b0=*ptr_src++;
          b0=(((unsigned int)b0)*15)/255;

          unsigned char b1=*ptr_src++;
          b1=(((unsigned int)b1)*15)/255;

          unsigned char b=(b1<<4)|(b0);
#endif

                if (!b)
                {
                  // To avoid a spurious null terminator
                  //b=1;
                }
		*ptr_dst++=b;
	}
        // Null terminator
        *ptr_dst++=0;
#endif

#if 0
	// Depack and save in the source file :p
	ptr_src=ptr_buffer_dst;
	ptr_dst=ptr_buffer;

	// Store first byte
	prev=ptr_src[0];
	*ptr_dst++=prev;

	for (int i=1;i<size_buffer_dst;i++)
	{
		unsigned char store=ptr_src[i];
		unsigned char b1=(store&15);
		unsigned char b0=((store>>4)&15);

		prev+=delta_table[b0];
		*ptr_dst++=prev;

		prev+=delta_table[b1];
		*ptr_dst++=prev;
	}

	if (!SaveFile(dest_name,ptr_buffer,size_buffer_src))
	{
		printf("\nUnable to save file '%s'",source_name);
		printf("\n");
		exit(1);
	}
#else
	// Save the resulting file
	if (!SaveFile(dest_name,ptr_buffer_dst,size_buffer_dst))
	{
		printf("\nUnable to save file '%s'",source_name);
		printf("\n");
		exit(1);
	}
#endif

	//
	// Make some cleaning
	//
	delete[] ptr_buffer;
	delete[] ptr_buffer_dst;
}


/*
 
15 1.0
14 0.707 <= 0.606 ???
13 0.5
12 0.303
11 0.25
10 0.1515
 9 0.125
 8 0.07575
 7 0.0625
 6 0.037875
 5 0.03125
 4 0.0189375
 3 0.015625
 2 0.00946875
 1 0.0078125
 0 0.0   


V[13]=V[15]/2



    // calculate the volume->voltage conversion table 
    // The AY-3-8910 has 16 levels, in a logarithmic scale (3dB per step) 
    // The YM2149 still has 16 levels for the tone generators, but 32 for
    // the envelope generator (1.5dB per step).
    for (i = 31;i > 0;i--)
    {
        // limit volume to avoid clipping
        if (out > MAX_OUTPUT) PSG->VolTable[i] = MAX_OUTPUT;
        else PSG->VolTable[i] = (unsigned int)out;

        if (AY_filetype==0)
			out = out - (MAX_OUTPUT / 32);
		else
			out /= 1.188502227; // = 10 ^ (1.5/20) = 1.5dB
    }



Volume  Dac output	Volume			Raw		Corrected
					Corrected
					
15		1.0			15.0			255		255
14		0.707		12.62			238
13		0.5			10.61			221
12		0.303		 8.93			204
11		0.25		 7.51			187
10		0.1515		 6.32			170
 9		0.125		 5.32			153
 8		0.07575		 4.47			136
 7		0.0625		 3.76			119
 6		0.037875	 3.17			102
 5		0.03125		 2.66			85
 4		0.0189375	 2.244			68
 3		0.015625	 1.888			51
 2		0.00946875	 1.58			34
 1		0.0078125	 1.33			17
 0		0.0			 0.0			0		0

 */