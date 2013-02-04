/* tap2cd : converts .TAP images to 22050 baud WAV files */
/* F.Frances 1999-2012 */

/* Modified by Chema June 2012 to include a special loader	*/
/* which sets HIRES and loads the screen area first.		*/
/* Also changes a bit the timing of the loading routine to	*/
/* avoid loading errors on some machines					*/

#include <stdio.h>
#define FALSE 0
#define TRUE 1

FILE *in,*out;
int file_size=0;
unsigned char header[9];
unsigned char Mem[48*1024],name[18];
int check_crc=0;
int df_loader=0;

struct {
	char sig[4];
	int riff_size;
	char typesig[4];
	char fmtsig[4];
	int fmtsize;
	short tag;
	short channels;
	int freq;
	int bytes_per_sec;
	short byte_per_sample;
	short bits_per_sample;
	char samplesig[4];
	int datalength;
} sample_riff= { "RIFF",0,"WAVE","fmt ",16,1,1,22050,22050,1,8,"data",0 };


// These files are created by 'CreateLoader.bat'
#include "loader_df.h"      
#include "loader_crc.h"
#include "loader_nocrc.h"


static int current_level=0x20;
void inverse_level() { current_level=255-current_level; }

void usage()
{
  printf("Usage: tap2cd [-c|-h] <.TAP file> <WAV file>\n");
  printf("(-c check CRC, -h load HIRES screen first)\n");
  exit(1);
}

void check_args(int argc,char *argv[])
{
  int opts=0;
  if (argc==1) usage();
  if (argv[1][0]=='-') {
    opts=1;
    if (argv[1][1]=='c' || argv[1][1]=='C') {
      check_crc=1; printf("CRC check activated\n");
	}else
		if (argv[1][1]=='h' || argv[1][1]=='H') {
			df_loader=1;printf("CRC check activated. Loading of HIRES screen first activated\n");
		} else usage();
  }
  if (argc!=1+opts+2) usage();
  in=fopen(argv[1+opts],"rb");
  if (in==NULL) {
    printf("Cannot open %s file\n",argv[1+opts]);
    usage();
  }
  out=fopen(argv[2+opts],"wb");
  if (out==NULL) {
    printf("Cannot create %s file\n",argv[2+opts]);
    usage();
  }
  fwrite(&sample_riff,1,sizeof(sample_riff),out);
}

void emit_level(int size)
{
    int i;
    inverse_level();
    for (i=0;i<size;i++) fputc(current_level,out);
    file_size+=size;
}

void emit_two_fast_bits(int bits)
{
  switch (bits) {
    case 0: emit_level(5); break;
    case 1: emit_level(3); break;
    case 2: emit_level(4); break;
    case 3: emit_level(2); break;
  }
}

void emit_standard_short_level() { emit_level(4); }
void emit_standard_long_level() { emit_level(10); }

void emit_standard_bit(int bit)
{  
  emit_standard_short_level();
  if (bit==0) emit_standard_long_level();
  else emit_standard_short_level();
}

/*
Standard durations are 210 탎 for a short level and 418 탎 for a long level,
hence 420 탎 for a full period of two short levels (i.e a '1' bit),
and 628 탎 for a full period of a short level followed by a long level (a '0' bit).
The threshold when reading with the Oric rom is set at 512 탎.
Here we use a number of 22050 Hz samples, so the values are a bit changed:
4 samples for a short level (i.e. 181 탎), and 10 samples for a long level (454 탎).
So a '1' bit is 362 탎 long, and a '0' bit is 635 탎 long.

The '0' bit waveform is asymetric, since it consists in a short level followed by
a long level. This is a good thing for the Oric reading routines because a bug in the
write routine adds half a bit (half a period) to every byte written... As a result, in
one byte out of two, the second half of the period (the one that differentiates 0 and 1)
is written as the high level instead of the low level. When reading, the high level is
always considered as the first part of the period, so in one byte out of two, the part
of the period that was written in second place becomes the first part when reading 
(it is associated with the first part of next bit). So, thanks to a scheme where
the first part written is always the same duration, the bits read are the same than
the ones written, except that a variable number of stop bits are read between two
consecutives bytes (3 and half stop bits are written between two consecutive bytes,
but the read routines detects alternately 3 and 4 stop bits between two bytes).

This inversing "feature" is corrected here (there's no additional half period), 
but it seems that the waveform emitted by a number of player devices is reversed 
(all the high levels become low levels, and low levels become high levels), 
so it's good to keep this asymetric coding for the standard format. 
*/

void emit_standard_byte_with_no_stop_bit(int val)
{
  int i,parity=1;
  emit_standard_bit(0);
  for (i=0; i<8; i++,val>>=1) {
    parity+=val&1;
    emit_standard_bit(val&1);
  }
  emit_standard_bit(parity&1);
}

void emit_standard_byte(int val)
{
  emit_standard_byte_with_no_stop_bit(val);
  emit_standard_bit(1);
  emit_standard_bit(1);
  emit_standard_bit(1);
}

void emit_fast_byte(int val)
{
  emit_two_fast_bits((val>>6)&3);
  emit_two_fast_bits((val>>4)&3);
  emit_two_fast_bits((val>>2)&3);
  emit_two_fast_bits(val&3);
}

void emit_fast_synchro()
{
/*
The turbo fast format is not affected by the waveform inversion because each high or 
low level is measured independently. However when the standard bytes are read, 
we don't know if the waveform is inversed or not, and thus we don't know if the first turbo 
fast level will be a high or a low level... So, an additional 1/2 bit is used here to be sure the
last bit (parity bit) is complete in standard format: if the waveform is reversed, the last
part of the parity bit will be associated to the first part of the bit that follows.
A standard short level is thus written to complete last bit in case the waveform will be 
inversed, and then a small synchro is written, consisting in a sequence of very short levels
(2 samples each) followed by a longer level (5 samples long).
*/
  emit_standard_short_level();
  emit_two_fast_bits(3); /* two '1' bits */
  emit_two_fast_bits(3); /* two '1' bits */
  emit_two_fast_bits(3); /* two '1' bits */
  emit_two_fast_bits(3); /* two '1' bits */
  emit_two_fast_bits(2); /* a '1' bit and a '0' bit */

/* two bits at once are shifted in the shifter.
  But when the first bit enters the shifter, another bit is shifted out :
  this bit must be a 'one' for the second shift to work correctly (space
  and time constraints of the loader).
  When the second bit enters the shifter, another bit is shifted out too.
  If it is a 'zero', it means a byte is complete.
  This is why the shifter is initialized to 11111110 between two bytes.
  However the shifter is initialized to 11111111 before loading a page,
  so a byte will never appear complete until a first zero bit exits the
  shifter. This allows to implement a synchro : a sequence of ones followed
  by a single 0 (beware that one bit out of two must always be a one).
*/
}

void emit_standard_gap(int size)
{
  int i;
  for (i=0;i<size;i++) emit_standard_bit(1); /* stop bits to skip */
}

int compute_crc8(int start, int size)
{
  int crc=0;
  int i;
  for (i=start;i<start+size;i++) {
    int bits;
    int shifter=Mem[i];
    for (bits=0; bits<8; bits++) {
      shifter<<=1;
      crc<<=1;
      if ((shifter&0x100)!=0) crc|=1;
      if ((crc&0x100)!=0) 
        crc^=0x1D5;  /* x^8+x^7+x^6+x^4+x^2+1 polynomial */
    }
  }
  return crc;
}
      
void emit_fast_page(int adr,int size)
{
  int i;
  int offset=256-size;
  int page=adr-offset;
  int crc = compute_crc8(adr,size);
  emit_standard_gap(10);
  emit_standard_byte(page>>8);
  emit_standard_byte(page&0xFF);
  if (check_crc||df_loader)
    emit_standard_byte(crc);
  emit_standard_byte_with_no_stop_bit(offset);
  emit_fast_synchro();
  for (i=0;i<size;i++)
    emit_fast_byte(Mem[adr+i]);
  if (check_crc||df_loader)	/* give enough time to compute the crc */
    emit_standard_gap(10+115*size/256);
}

void emit_standard_header(char header[])
{
  int i;
  for (i=0;i<300;i++) emit_standard_byte(0x16);
  emit_standard_byte(0x24);
  for (i=0;i<9;i++) emit_standard_byte(header[i]);
  for (i=0;name[i];i++) emit_standard_byte(name[i]);
  emit_standard_byte(0);
}

void emit_loader()
{
  int nb_lines = sizeof(loader_no_check) / sizeof(char *);

  int i,addr=0x0100;
  char loader_header[9]={ 
    0, /* not an array of integers */
    0, /* not an array of strings */
    0x80, /* memory block */
    0xC7, /* AUTO-exec */
    0x01,0xFF, /* end address (will be adjusted) */
    0x01,0x00, /* start address (0x100) */
    0	/* not used */
  };


  if (check_crc){
  	  loader_header[5]=sizeof(loader_check_crc)-1 & 0xFF;
      emit_standard_header(loader_header);
      emit_standard_gap(30);
	  for (i=0;i<sizeof(loader_check_crc);i++) emit_standard_byte(loader_check_crc[i]);
  }else{
	   if (df_loader){
		   loader_header[5]=sizeof(loader_df)-1 & 0xFF;
		   emit_standard_header(loader_header);
		   emit_standard_gap(30);
		   for (i=0;i<sizeof(loader_df);i++) emit_standard_byte(loader_df[i]);
	   }else{
		   loader_header[5]=sizeof(loader_no_check)-1 & 0xFF;
		   emit_standard_header(loader_header);
		   emit_standard_gap(30);
		   for (i=0;i<sizeof(loader_no_check);i++) emit_standard_byte(loader_no_check[i]);
	   }
  }

 
}

void emit_fast_prog(int start,int end)
{
  int i;
  emit_loader();
  if (df_loader)
	  emit_standard_gap(2000);
  else
	  emit_standard_gap(100);
  
  emit_fast_page(0x2A8,9);	/* header is emitted as a small 9-bytes page */

  if (df_loader){
	  end=0xbf3f;
	  for(i=0xa000;i<=end;i+=256)
		  if (i+255<end)
			  emit_fast_page(i,256);
		  else
			  emit_fast_page(i,end-i+1);
	  end =0x9fff;
	  for (i=start;i<=end;i+=256)
		  if (i+255<end) emit_fast_page(i,256);
		  else emit_fast_page(i,end-i+1);
  }else{
	  for (i=start;i<=end;i+=256)
		  if (i+255<end) emit_fast_page(i,256);
		  else emit_fast_page(i,end-i+1);
  }

  emit_standard_gap(10); /* small synchro gap */
  emit_standard_byte(0);	/* marker for last page */
}

void ask_name(char *name)
{
  char reply[80];
  do {
    if (name[0]) 
      printf("Stored name is %s, enter new name (or RETURN to keep): ",name);
    else 
      printf("Program has no stored name, enter a name: ");
    gets(reply);
    if (reply[0]) strcpy(name,reply);
  } while (name[0]==0);
}

int main(int argc,char *argv[])
{
  int start,end;
  int firstprog=TRUE;
  int i;
  
  check_args(argc,argv);

  while (!feof(in)) {
    while (fgetc(in)==0x16) ; /* read synchro (0x24 included) */
    if (feof(in)) break;
    for (i=8;i>=0;i--) Mem[0x2A8+i]=header[8-i]=fgetc(in);  /* header */
    start=header[6]*256+header[7]; end=header[4]*256+header[5];
    i=0; while ((name[i++]=fgetc(in))!=0); /* name */
    for (i=start;i<=end;i++) Mem[i]=fgetc(in);
    if (firstprog) ask_name(name);
    emit_fast_prog(start,end);
    firstprog=FALSE;
  }
  emit_standard_gap(1500); /* 0.5s protection at the end */
  fclose(in);
  fseek(out,40,SEEK_SET); fwrite(&file_size,1,4,out);
  file_size+=36;
  fseek(out,4,SEEK_SET); fwrite(&file_size,1,4,out);
  fclose(out);
  return 0;
}

