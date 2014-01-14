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

#include "infos.h"
#include "common.h"
#include "lzh.h"

#define REGS    14
#define FRAG    128  //  Number of rows to compress at a time 
#define OFFNUM  14   //  Bits needed to store off+num of FRAG 



void writebits(unsigned data,int bits,char* &ptrWrite);

int main(int argc,char *argv[])
{
  //
  // Some initialization for the common library
  //
  SetApplicationParameters(
    "Ym2Mym",
    TOOL_VERSION_MAJOR,
    TOOL_VERSION_MINOR,
    "{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
    "\r\n"
    "Author:\r\n"
    "  First version by Marq/Lieves!Tuore & Fit (marq@iki.fi) \r\n"
    "  More recent updates by Pointier Mickael \r\n"
    "\r\n"
    "Purpose:\r\n"
    "  Convert Atari ST/Amstrad musics from the YM to MYM format.\r\n"
    "\r\n"
    "Usage:\r\n"
    "  {ApplicationName} source.ym destination.mym [load adress] [header name] \r\n"
    "\r\n"
    "Switches:\r\n"
    " -tn   Tuning\r\n"
    "       -t0 => No retune\r\n"
    "       -t1 => Double frequency [default]\r\n"
    "\r\n"
    " -hn   Header\r\n"
    "       -h0 => No tape header [default]\r\n"
    "       -h1 => Use tape header (requires a start address and a name)\r\n"
    "\r\n"
    " -vn   Verbosity.\r\n"
    "       -v0 => Silent [default]\r\n"
    "       -v1 => Shows information about what PictConv is doing\r\n"
    "\r\n"
    " -mn   Max size.\r\n"
    "       -m0 => No size limit [default]\r\n"
    "       -m1234 => Outputs an error if the exported size is too large\r\n"
    "\r\n"
    );

  int maxSize=0;
  int retune_music=1;
  bool flagVerbosity=false;
  bool flag_header=false;

  ArgumentParser argumentParser(argc,argv);

  while (argumentParser.ProcessNextArgument())
  {
    if (argumentParser.IsSwitch("-t"))
    {
      //format: [-t]
      //	0 => No retune
      // 	1 => Double frequency [default]
      retune_music=argumentParser.GetIntegerValue(0);
    }
    else
    if (argumentParser.IsSwitch("-v"))
    {
      //testing: [-v]
      //	0 => silent
      //	1 => verbose
      flagVerbosity=argumentParser.GetBooleanValue(true);
    }
    else 
    if (argumentParser.IsSwitch("-h"))
    {
      //format: [-h]
      //	0 => suppress header
      // 	1 => save header (default)
      flag_header=argumentParser.GetBooleanValue(true);
    }
    else 
    if (argumentParser.IsSwitch("-m"))
    {
      //format: [-m]
      //	0 => no max size (default)
      // 	other => maximum size
      maxSize=argumentParser.GetIntegerValue(0);
    }
  }
  
  int adress_start=0;
  std::string headerName;

  if (flag_header)
  {
    // Header mode: Four parameters
    if (argumentParser.GetParameterCount()!=4)
    {
      //
      // Wrong number of arguments
      //
      ShowError(0);
    }

    //
    // Check start address
    //
    adress_start=ConvertAdress(argumentParser.GetParameter(2));
    headerName=argumentParser.GetParameter(3);
  }
  else
  {
    // No header mode: Two parameters
    if (argumentParser.GetParameterCount()!=2)
    {
      ShowError(0);
    }
  }

  unsigned char*data[REGS];    //  The unpacked YM data 
  unsigned current[REGS];

  char ym_new=0;

  unsigned long n,row;
  long i,change,pack,biggest=0,hits,oldrow,remain,offi;
  long regbits[REGS]={8,4,8,4, 8,4,5,8, 5,5,5,8, 8,8};                          // Bits per PSG reg
  long regand[REGS]={255,15,255,15, 255,15,31,255, 31,31,31,255, 255,255};      // AND values to mask out extra bits from register data

  unsigned long length;         //  Song length

  const char* sourceFilename(argumentParser.GetParameter(0));
  void* pcBuffer;
  size_t cBufferSize;
  if (!LoadFile(sourceFilename,pcBuffer,cBufferSize))
  {
    ShowError("Can't load '%s'",sourceFilename);
  }

  const lzhHeader_t* header=(const lzhHeader_t*)pcBuffer;
  if ( (cBufferSize>=sizeof(lzhHeader_t)) && (!strncmp(header->id,"-lh5-",5)) )
  {
    CLzhDepacker depacker;
    int dstSize=header->original;
    void *pDst=malloc(dstSize);
    const char* packedData=(const char*)pcBuffer+sizeof(lzhHeader_t)+header->name_lenght+2;

    if (!depacker.LzUnpack(packedData,header->packed,pDst,dstSize))
    {
      ShowError("Failed depacking '%s', wrong LHA format or corrupted file?",sourceFilename);
    }
    free(pcBuffer);
    pcBuffer=pDst;
    cBufferSize=dstSize;
  }
  const char* sourceData=(const char*)pcBuffer;

  // Check if the file is compressed 
  length=cBufferSize-4;
  if (!strncmp(sourceData,"YM2!",4))        //  YM2 is ok 
  {
    sourceData+=4;
    // YM2!
    // First four bytes is the ASCII identifier "YM2!".
  }
  else
  if (!strncmp(sourceData,"YM3!",4))      //  YM3 is ok
  {
    sourceData+=4;
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
  if (!strncmp(sourceData,"YM3b",4))    //  YM3b is ok
  {
    sourceData+=4;
    // YM3b!
    // 
    // This format is nearly identical with YM3. It adds only the ability to use loops.
    // 
    // First four bytes is the ASCII identifier "YM3b".
    // The following bytes are the data block (see YM3 description).
    // Last four bytes is a DWORD (32bits integers) data and contains the frame number
    // at which the loop restart. That's all.
    sourceData+=4;    //  Skip restart for YM3b 
    length-=4;
  }
  else
  if (!strncmp(sourceData,"YM4!",4))    //  YM4 is not yet ok
  {
    sourceData+=4;
    // YM4!
    // (note, should be similar to YM5, without extra infos)
    printf("YM4! format is not yet supported.\n");
    exit(EXIT_FAILURE);
  }
  else
  if ( (!strncmp(sourceData,"YM5!",4)) || (!strncmp(sourceData,"YM6!",4)) ) //  YM5 is ok but needs a different loader    
  {
    sourceData+=4;
    // YM5!
    // This is the actual and most common used format and consist consists of additional information:
    // chip frequency, player frequency, title, author name, comment and specific Atari ST data (Digi-Drum and SID effects).

    // YM6!
    // This format is equivalent to YM5! but can use yet another special Atari effect.
    ym_new=1;
  }
  else
  {
    printf("Unknown file format '%s'.\n",sourceData);
    exit(EXIT_FAILURE);
  }

  if (ym_new)  //  New YM5 format loader     
  {
    sourceData+=8;                   //  Skip 'LeOnArD' checkstring     
    for (n=length=0;n<4;n++)         //  Number of VBL's  
    {
      length<<=8;
      length+=*sourceData++;
    }
    length*=REGS;

    sourceData+=3;            //  Skip first 3 bytes of info
    if (!((*sourceData++)&1))
    {
      printf("Only interleaved data supported.\n");
      return(EXIT_FAILURE);
    }

    if ((*sourceData++) || (*sourceData++))        //  Number of digidrums   
    {
      printf("Digidrums not supported.\n");
      return(EXIT_FAILURE);
    }

    sourceData+=4;            /*  Skip external freq      */
    sourceData+=2;            /*  Skip VBL freq           */
    sourceData+=4;            /*  Skip loop position      */
    sourceData+=2;            /*  Skip additional data    */

    while((*sourceData++))                 /*  Skip song name          */
      ;
    while((*sourceData++))                 /*  Skip author name        */
      ;
    while((*sourceData++))                 /*  Skip comments           */
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
    memcpy(data[n],sourceData,length/REGS);
    sourceData+=length/REGS;
  }

  if (retune_music)
  {
    unsigned int frame;
    if (flagVerbosity)
    {
      printf("Retuning the frequency.\n");
    }
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


  char* destinationBuffer=(char*)malloc(cBufferSize);
  char* ptrWrite=destinationBuffer;

  // Set current values to impossible 
  for (n=0;n<REGS;n++)
  {     
    current[n]=0xffff;
  }

  *ptrWrite++=length/REGS&0xff;  //  Write tune length 
  *ptrWrite++=(length/REGS>>8)&255;

  for (n=0;n<length/REGS;n+=FRAG)  //  Go through fragments...   
  {
    for (i=0;i<REGS;i++)         //  ... for each register    
    {
      for (row=change=0;row<FRAG;row++)
        if (data[i][n+row]!=current[i])
          change=1;

      if (!change) //  No changes in the whole fragment   
      {
        writebits(0,1,ptrWrite);
        continue;   //  Skip the next pass             
      }
      else
      {
        writebits(1,1,ptrWrite);
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
            writebits(2,2,ptrWrite);
            writebits((offi<<OFFNUM/2)+(biggest-1),OFFNUM,ptrWrite);
          }
          else    //  Nope, write raw bits   
          {
            writebits(3,2,ptrWrite);
            writebits(data[i][n+row],regbits[i],ptrWrite);
          }
        }
        else    //  Same as former value, write 0  
        {
          writebits(0,1,ptrWrite);
        }
      }
    }
  }

  writebits(0,0,ptrWrite);   // Pad to byte size

  size_t outputFileSize=(ptrWrite-destinationBuffer);

  if (maxSize && (outputFileSize>maxSize))
  {
    ShowError("File '%s' is too large (%d bytes instead of maximum %d)",sourceFilename,outputFileSize,maxSize);
  }

  FILE* f;
  if ((f=fopen(argumentParser.GetParameter(1),"wb"))==NULL)
  {
    printf("Cannot open destination file.\n");
    return(EXIT_FAILURE);
  }

  if (flag_header)
  {
    //
    // Write tape header
    //
    unsigned char Header[]=
    {
      0x16,	// 0 Synchro
      0x16,	// 1
      0x16,	// 2
      0x24,	// 3

      0x00,	// 4
      0x00,	// 5

      0x80,	// 6

      0x00,	// 7  $80=BASIC Autostart $C7=Assembly autostart

      0xbf,	// 8  End adress
      0x40,	// 9

      0xa0,	// 10 Start adress
      0x00,	// 11

      0x00	// 12 
    };

    int adress_end =adress_start+outputFileSize-1;

    Header[10]=(adress_start>>8);
    Header[11]=(adress_start&255);

    Header[8]=(adress_end>>8);
    Header[9]=(adress_end&255);

    //
    // Write header
    //
    fwrite(Header,sizeof(Header),1,f);
    fwrite(headerName.c_str(),headerName.size()+1,1,f); // Include the null terminator
  }
  fwrite(destinationBuffer,outputFileSize,1,f);

  fclose(f);

  free(pcBuffer);
  free(destinationBuffer);

  return EXIT_SUCCESS;
}

//  Writes bits to a file. If bits is 0, pads to byte size.
void writebits(unsigned data,int bits,char* &ptrWrite)
{
  static unsigned char    byte=0;

  static int  off=0;

  int n;

  if (!bits && off)
  {
    off=byte=0;
    *ptrWrite++=byte;
    return;
  }

  // Go through the bits and write a whole byte if needed
  for (n=0;n<bits;n++) 
  {
    if (data&(1<<bits-1-n))
      byte|=0x80>>off;

    if (++off==8)
    {
      *ptrWrite++=byte;
      off=byte=0;
    }
  }
}

