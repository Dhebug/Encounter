/*
ym2mym.cpp

Converts _unpacked_ YM tunes to a format better suitable for
MSX1. Supports YM2 and YM3 types well plus YM5 somehow.

30.1.2000 Marq/Lieves!Tuore & Fit (marq@iki.fi)

3.2.2000  - Added a rude YM5 loader. Skips most of the header.

Output format:

Rows in the tune, 16 bits (lobyte first)
For each register, 0 - fragment contains only unchanged data
1 - fragment contains packed data

In a packed fragment, 0  - register value is the same as before
11 - raw register data follows. Only regbits[i]
bits, not full 8
10 - offset + number of bytes from preceding
data. As many bits as are required to hold
fragment offset & counter data (OFFNUM).
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REGS    14
#define FRAG    128  //  Number of rows to compress at a time 
#define OFFNUM  14   //  Bits needed to store off+num of FRAG 



void writebits(unsigned data,int bits,FILE *f);

int main(int argc,char *argv[])
{
  unsigned char*data[REGS];    //  The unpacked YM data 

  unsigned current[REGS];

  char id[5]={0,0,0,0,0};
  char ym_new=0;
  char LeOnArD[8];             //  Check string 

  FILE    *f;

  long n,i,row,change,pack,biggest=0,hits,oldrow,remain,offi;
  long regbits[REGS]={8,4,8,4, 8,4,5,8, 5,5,5,8, 8,8};                          // Bits per PSG reg
  long regand[REGS]={255,15,255,15, 255,15,31,255, 31,31,31,255, 255,255};      // AND values to mask out extra bits from register data

  unsigned long length;         //  Song length
  unsigned long ldata;          //  Needed in the loader

  int retune_music=1;

  if (argc!=3)
  {
    printf("Usage: ym2mym source.ym destination.mym\n");
    printf("Raw YM files only. Uncompress with LHA.\n");
    return(EXIT_FAILURE);
  }

  if ((f=fopen(argv[1],"rb"))==NULL)
  {
    printf("File open error.\n");
    return(EXIT_FAILURE);
  }

  fseek(f,0,SEEK_END);
  length=ftell(f)-4;
  fseek(f,0,SEEK_SET);

  fread(id,1,4,f);
  if (!strcmp(id,"YM2!"))        //  YM2 is ok 
  {
    // YM2!
    // First four bytes is the ASCII identifier "YM2!".
  }
  else
  if (!strcmp(id,"YM3!"))      //  YM3 is ok
  {
    // YM3!
    // First four bytes is again the ASCII identifier "YM3!".
    // ------------------------------------------------------
    // Offset	Size    Name    Value   Contents
    // ------------------------------------------------------
    // 0      4       ID      "YM3!"  File type Identificator
    // The next bytes are the data block of AY chip registers values.
    // 
    // Registers are updates one time per VBL interrupt. If music length is N interrupts,
    // then block consist first N bytes for register 0, further N bytes for register 1
    // and so on. In total: N*14 bytes. The number of used VBL for music can be computed
    // as follow: nvbl = (ymfile_size-4)/14;
    // 
    // VBL1:
    //     store reg0,reg1,reg2,...,reg12,reg13  (14 regs)
    // VBL2:
    //     store reg0,reg1,reg2,...,reg12,reg13  (14 regs)
    //       ..........
    // VBLn:
    //     store reg0,reg1,reg2,...,reg12,reg13  (14 regs)
    // 
    // If the current interrupt features no output to register 13 then the byte of the
    // data block for this interrupt and for this register has the value 255 ($FF).
  }
  else 
  if (!strcmp(id,"YM3b"))    //  YM3b is ok
  {
    // YM3b!
    // 
    // This format is nearly identical with YM3. It adds only the ability to use loops.
    // 
    // First four bytes is the ASCII identifier "YM3b".
    // The following bytes are the data block (see YM3 description).
    // Last four bytes is a DWORD (32bits integers) data and contains the frame number
    // at wich the loop restart. That's all.
    fread(id,1,4,f);    //  Skip restart for YM3b 
    length-=4;
  }
  else
  if (!strcmp(id,"YM4!"))    //  YM4 is not yet ok
  {
    // YM4!
    // (note, should be similar to YM5, without extra infos)
    printf("YM4! format is not yet supported.\n");
    exit(EXIT_FAILURE);
  }
  else
  if ( (!strcmp(id,"YM5!")) || (!strcmp(id,"YM6!")) ) //  YM5 is ok but needs a different loader    
  {
    // YM5!
    // This is the actual and most common used format and consist consists of additional information:
    // chip frequency, player frequency, title, author name, comment and specific Atari ST data (Digi-Drum and SID effects).

    // YM6!
    // This format is equivalent to YM5! but can use yet another special Atari effect.
    ym_new=1;
  }
  else
  {
    printf("Unknown file format '%s'.\n",id);
    exit(EXIT_FAILURE);
  }

  if (ym_new)  //  New YM5 format loader     
  {
    fread(LeOnArD,1,8,f);            //  Skip checkstring     
    for (n=length=0;n<4;n++)         //  Number of VBL's  
    {
      length<<=8;
      length+=fgetc(f);
    }
    length*=REGS;

    fread(&ldata,1,3,f);            //  Skip first 3 bytes of info
    if (!(fgetc(f)&1))
    {
      printf("Only interleaved data supported.\n");
      return(EXIT_FAILURE);
    }

    if (fgetc(f) || fgetc(f))        //  Number of digidrums   
    {
      printf("Digidrums not supported.\n");
      return(EXIT_FAILURE);
    }

    fread(&ldata,1,4,f);            /*  Skip external freq      */
    fread(&ldata,1,2,f);            /*  Skip VBL freq           */
    fread(&ldata,1,4,f);            /*  Skip loop position      */
    fread(&ldata,1,2,f);            /*  Skip additional data    */

    while(fgetc(f))                 /*  Skip song name          */
      ;
    while(fgetc(f))                 /*  Skip author name        */
      ;
    while(fgetc(f))                 /*  Skip comments           */
      ;
  }

  /*  Old YM2/YM3 format loader   */
  for (n=0;n<REGS;n++)     /*  Allocate memory & read data */
  {
    /*  Allocate extra fragment to make packing easier  */
    if ((data[n]=(unsigned char*)malloc(length/REGS+FRAG))==NULL)
    {
      printf("Out of memory.\n");
      return(EXIT_FAILURE);
    }
    memset(data[n],0,length/REGS+FRAG);
    fread(data[n],1,length/REGS,f);
  }

  if (retune_music)
  {
    unsigned int frame;
    printf("Retuning the frequency.\n");
    for (frame=0;frame<=length/REGS;frame++)
    {
      int freqA=   ( ((data[1][frame])<<8) | (data[0][frame]) )>>1;
      int freqB=   ( ((data[3][frame])<<8) | (data[2][frame]) )>>1;
      int freqC=   ( ((data[5][frame])<<8) | (data[4][frame]) )>>1;
      int freqEnv= ( ((data[12][frame])<<8) | (data[11][frame]) )>>1;
      int freqNoise= data[6][frame]>>1;

      data[0][frame]=freqA & 255;
      data[1][frame]=(freqA>>8);

      data[2][frame]=freqB & 255;
      data[3][frame]=(freqB>>8);

      data[4][frame]=freqC & 255;
      data[5][frame]=(freqC>>8);

      data[6][frame]=freqNoise;

      data[11][frame]=freqEnv & 255;
      data[12][frame]=(freqEnv>>8);
    }
  }


  if (ym_new)  //  Let's mask the extra YM5 data out
  {
    for (n=0;n<REGS;n++)
    {
      for (row=0;row<length/REGS;row++)
      {
        data[n][row]&=regand[n];
      }
    }
  }

  fclose(f);

  if ((f=fopen(argv[2],"wb"))==NULL)
  {
    printf("Cannot open destination file.\n");
    return(EXIT_FAILURE);
  }

  // Set current values to impossible 
  for (n=0;n<REGS;n++)
  {     
    current[n]=0xffff;
  }

  fputc(length/REGS&0xff,f);  //  Write tune length 
  fputc(length/REGS>>8,f);

  for (n=0;n<length/REGS;n+=FRAG)  //  Go through fragments...   
  {
    for (i=0;i<REGS;i++)         //  ... for each register    
    {
      for (row=change=0;row<FRAG;row++)
        if (data[i][n+row]!=current[i])
          change=1;

      if (!change) //  No changes in the whole fragment   
      {
        writebits(0,1,f);
        continue;   //  Skip the next pass             
      }
      else
      {
        writebits(1,1,f);
      }

      for (row=0;row<FRAG;row++)
      {
        if (data[i][n+row]!=current[i])
        {
          change=1;
          current[i]=data[i][n+row];

          biggest=0;
          if (n)       //  Skip first fragment
          {
            offi=0;
            remain=FRAG-row;

            // Go through the preceding data and try to find similar data 
            for (oldrow=0;oldrow<FRAG;oldrow++)
            {
              hits=0;
              for (pack=0;pack<remain;pack++)
              {
                if (data[i][n+row+pack]==data[i][n-FRAG+row+oldrow+pack]
                && oldrow+pack<FRAG)
                  hits++;
                else
                  break;
              }
              if (hits>biggest)    // Bigger sequence found
              {
                biggest=hits;
                offi=oldrow;
              }
            }
          }

          if (biggest>1)   // Could we pack data?
          {
            row+=biggest-1;
            current[i]=data[i][n+row];
            writebits(2,2,f);
            writebits((offi<<OFFNUM/2)+(biggest-1),OFFNUM,f);
          }
          else    //  Nope, write raw bits   
          {
            writebits(3,2,f);
            writebits(data[i][n+row],regbits[i],f);
          }
        }
        else    //  Same as former value, write 0  
        {
          writebits(0,1,f);
        }
      }
    }
  }

  writebits(0,0,f);   // Pad to byte size
  fclose(f);
  return(EXIT_SUCCESS);
}

//  Writes bits to a file. If bits is 0, pads to byte size.
void writebits(unsigned data,int bits,FILE *f)
{
  static unsigned char    byte=0;

  static int  off=0;

  int n;

  if (!bits && off)
  {
    off=byte=0;
    fputc(byte,f);
    return;
  }

  // Go through the bits and write a whole byte if needed
  for (n=0;n<bits;n++) 
  {
    if (data&(1<<bits-1-n))
      byte|=0x80>>off;

    if (++off==8)
    {
      fputc(byte,f);
      off=byte=0;
    }
  }
}

