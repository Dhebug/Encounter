/* tap2cd : converts .TAP images to 22050 baud WAV files */
/* F.Frances 1999 */

#pragma warning( disable : 4996)   // #define _CRT_SECURE_NO_WARNINGS

#include "infos.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#define FALSE 0
#define TRUE 1

FILE *in,*out;
int file_size;
unsigned char header[9];
char Mem[48*1024],name[18];

struct RiffSample
{
RiffSample()
{
  sig[0]='R';
  sig[1]='I';
  sig[2]='F';
  sig[3]='F';

  riff_size=0;

  typesig[0]='W';
  typesig[1]='A';
  typesig[2]='V';
  typesig[3]='E';

  fmtsig[0]='f';
  fmtsig[1]='m';
  fmtsig[2]='t';
  fmtsig[3]=' ';

  fmtsize=16;
  tag=1;
  channels=1;
  freq=22050;
  bytes_per_sec=22050;
  byte_per_sample=1;
  bits_per_sample=8;

  samplesig[0]='d';
  samplesig[1]='a';
  samplesig[2]='t';
  samplesig[3]='a';

  datalength=0;
}

public:
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
};

#define Make4CC(a,b,c,d)

RiffSample sample_riff;


unsigned char loader[]={
  0x20,0x6a,0xe7,0xa9,0x70,0x8d,0x45,0x02,0xa9,0x01,0x8d,0x46,0x02,0xa9,0x90,0x8d,
  0x0e,0x03,0xa9,0xff,0x8d,0x08,0x03,0x20,0x9b,0xe5,0x20,0xc9,0xe6,0xc9,0xff,0xf0,
  0x10,0x85,0x34,0x20,0xc9,0xe6,0x85,0x33,0x20,0xc9,0xe6,0xa8,0x20,0x51,0x01,0xd0,
  0xe9,0xa9,0x22,0x8d,0x45,0x02,0xa9,0xee,0x8d,0x46,0x02,0x20,0x3d,0xe9,0x4c,0xd6,
  0xe8,0x2c,0x00,0x03,0xa9,0x10,0x2c,0x0d,0x03,0xf0,0xfb,0xad,0x0c,0x03,0x49,0x10,
  0x8d,0x0c,0x03,0x2c,0x00,0x03,0xa9,0xff,0x8d,0x09,0x03,0x85,0x2f,0x58,0xd0,0xfe,
  0xad,0x0c,0x03,0x49,0x10,0x8d,0x0c,0x03,0x2c,0x00,0x03,0xae,0x08,0x03,0x8e,0x09,
  0x03,0x29,0x10,0xd0,0x0e,0xa5,0x2f,0xe0,0x6e,0xb0,0x04,0xe0,0x44,0xd0,0x0c,0xe0,
  0x9a,0xd0,0x11,0xa5,0x2f,0xe0,0x63,0xb0,0x09,0xe0,0x37,0x2a,0x0a,0x90,0x09,0x85,
  0x2f,0x40,0xe0,0x8d,0x2a,0x2a,0xb0,0xf7,0x91,0x33,0xa9,0xfe,0xc8,0xd0,0xf0,0x68,
  0x68,0x68,0x60
};

void usage()
{
  printf("Usage: TapTool <.TAP file> <WAV file>\n");
  exit(1);
}

void open_files(int argc,char *argv[])
{
  if (argc!=3) usage();
  in=fopen(argv[1],"rb");
  if (in==NULL) {
    printf("Cannot open %s file\n",argv[1]);
    usage();
  }
  out=fopen(argv[2],"wb");
  if (out==NULL) {
    printf("Cannot create %s file\n",argv[2]);
    usage();
  }
  fwrite(&sample_riff,1,sizeof(sample_riff),out);
}

void emit_level(int size)
{
    static int current_level=0x40;
    int i;
    current_level=256-current_level;
    for (i=0;i<size;i++) fputc(current_level,out);
    file_size+=size;
}

void emit_standard_bit(int bit)
{
  if (bit) {
    emit_level(4);
    emit_level(4);
  } else {
    emit_level(4);
    emit_level(9);
  }
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

void emit_standard_byte(int val)
{
  int i,parity=1;
  emit_standard_bit(0);
  for (i=0; i<8; i++,val>>=1) {
    parity+=val&1;
    emit_standard_bit(val&1);
  }
  emit_standard_bit(parity&1);
  emit_standard_bit(1);
  emit_standard_bit(1);
  emit_standard_bit(1);
  emit_standard_bit(1);
}

void emit_standard_byte_with_no_stops(int val)
{
  int i,parity=1;
  emit_standard_bit(0);
  for (i=0; i<8; i++,val>>=1) {
    parity+=val&1;
    emit_standard_bit(val&1);
  }
  emit_standard_bit(parity&1);
}

void emit_fast_byte(int val)
{
  emit_two_fast_bits((val>>6)&3);
  emit_two_fast_bits((val>>4)&3);
  emit_two_fast_bits((val>>2)&3);
  emit_two_fast_bits(val&3);
}

void emit_standard_gap(int size)
{
  int i;
  for (i=0;i<size;i++) emit_standard_bit(1); /* stop bits to skip */
}

void emit_fast_page(int adr,int size)
{
  int i,page,offset;
  offset=256-size; page=adr-offset;
  emit_standard_gap(10);
  emit_standard_byte(page>>8);
  emit_standard_byte(page&0xFF);
  emit_standard_byte_with_no_stops(offset);
  emit_fast_byte(0xFE);		/* small fast synchro */
  for (i=0;i<size;i++)
    emit_fast_byte(Mem[adr+i]);
}

void emit_standard_header(unsigned char header[])
{
  int i;
  for (i=0;i<128;i++) emit_standard_byte(0x16);
  emit_standard_byte(0x24);
  for (i=0;i<9;i++) emit_standard_byte(header[i]);
  for (i=0;name[i];i++) emit_standard_byte(name[i]);
  emit_standard_byte(0);
}

void emit_loader()
{
  int i;
  unsigned char loader_header[9]={ 0,0,0x80,0xC7,0x01,0x10+sizeof(loader)-1,0x01,0x10,0};
  emit_standard_header(loader_header);
  emit_standard_gap(30);
  for (i=0;i<sizeof(loader);i++) emit_standard_byte(loader[i]);
}

void emit_fast_prog(int start,int end)
{
  int i;
  emit_loader();
  emit_standard_gap(50);
  emit_fast_page(0x2A8,9);
  for (i=start;i<=end;i+=256)
    if (i+255<end) emit_fast_page(i,256);
    else emit_fast_page(i,end-i+1);
  emit_standard_gap(4); /* small synchro gap */
  emit_standard_byte(0xFF);	/* marker for last page */
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
  printf("\nTapTool: A multi-tape-tool based on Tap2CD by Fabrice Frances. Version %d.%3d\n\n",TOOL_VERSION_MAJOR,TOOL_VERSION_MINOR);

  int start,end;
  int firstprog=TRUE;
  int i;

  open_files(argc,argv);

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
  fclose(in);
  fseek(out,40,SEEK_SET); fwrite(&file_size,1,4,out);
  file_size+=36;
  fseek(out,4,SEEK_SET); fwrite(&file_size,1,4,out);
  fclose(out);
  return 0;
}

