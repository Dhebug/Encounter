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

AYC information: http://www.cpcwiki.eu/index.php/AYC

*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>

#include "infos.h"
#include "common.h"
#include "lzh.h"

#define REGS    14
#define FRAG    128  //  Number of rows to compress at a time
#define OFFNUM  14   //  Bits needed to store off+num of FRAG


enum DurationMode
{
  DurationModeKeepAll,
  DurationModeTruncateMode,
  DurationModeFade
};

enum ExportFormat
{
  ExportFormatMym,
  ExportFormatWav
};


  unsigned char*data[REGS];    //  The unpacked YM data
  unsigned current[REGS];

  char ym_new=0;

  long n,row;
  long i,change,pack,biggest=0,hits,oldrow,remain,offi;
  long regbits[REGS]={8,4,8,4, 8,4,5,8, 5,5,5,8, 8,8};                          // Bits per PSG reg
  long regand[REGS]={255,15,255,15, 255,15,31,255, 31,31,31,255, 255,255};      // AND values to mask out extra bits from register data


class MymExporter : public ArgumentParser
{
public:
  MymExporter(int argc,char *argv[])
    : ArgumentParser(argc,argv)
  {
    maxSize=0;
    duration=0;
    durationMode=DurationModeKeepAll;
    exportFormat=ExportFormatMym;
    retune_music=1;
    flagVerbosity=false;
    flag_header=false;
    interleavedFormat=true;
    adress_start=0;
    m_FrameCount=0;
    length=0;
    pcBuffer=nullptr;
    cBufferSize=0;
    sourceFilename=nullptr;
    m_FlagStereo=false;
  }

  int Main();

  bool ExportMym();
  bool ExportWav();

  void writebits(unsigned data,int bits,char* &ptrWrite);

private:
  MymExporter();  // N/A

private:
  int maxSize;
  int duration;
  DurationMode durationMode;
  ExportFormat exportFormat;
  int retune_music;
  bool flagVerbosity;
  bool flag_header;
  bool interleavedFormat;
  bool m_FlagStereo;

  unsigned long m_FrameCount;     // Number of frames
  unsigned long length;         // Song length (frameCount*14)

  void* pcBuffer;
  size_t cBufferSize;

  int adress_start;

  std::string headerName;

  const char* sourceFilename;
};




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
    " -fn   Format\r\n"
    "       -f0 => MYM format[default]\r\n"
    "       -f1 => WAV format\r\n"
    "\r\n"
    " -hn   Header\r\n"
    "       -h0 => No tape header [default]\r\n"
    "       -h1 => Use tape header (requires a start address and a name)\r\n"
    "\r\n"
    " -vn   Verbosity.\r\n"
    "       -v0 => Silent [default]\r\n"
    "       -v1 => Shows information about what Ym2Mym is doing\r\n"
    "\r\n"
    " -mn   Max size.\r\n"
    "       -m0 => No size limit [default]\r\n"
    "       -m1234 => Outputs an error if the exported size is too large\r\n"
    "\r\n"
    " -dxn  Duration mode.\r\n"
    "       -dt1234 => Truncate at frame 1234\r\n"
    "       -df1234 => Fade out at frame 1234\r\n"
    "\r\n"
    " -sn   Stereo/Mono (for WAV exporter).\r\n"
    "       -s0 => Mono output format [default]\r\n"
    "       -s1 => Stereo output format\r\n"
    "\r\n"
    );


  MymExporter mymExporter(argc,argv);
  return mymExporter.Main();
}


int MymExporter::Main()
{
  while (ProcessNextArgument())
  {
    if (IsSwitch("-t"))
    {
      //format: [-t]
      //	0 => No retune
      // 	1 => Double frequency [default]
      retune_music=GetIntegerValue(0);
    }
    else
    if (IsSwitch("-v"))
    {
      //testing: [-v]
      //	0 => silent
      //	1 => verbose
      flagVerbosity=GetBooleanValue(true);
    }
    else
    if (IsSwitch("-h"))
    {
      //format: [-h]
      //	0 => suppress header
      // 	1 => save header (default)
      flag_header=GetBooleanValue(true);
    }
    else
    if (IsSwitch("-m"))
    {
      //format: [-m]
      //	0 => no max size (default)
      // 	other => maximum size
      maxSize=GetIntegerValue(0);
    }
    else
    if (IsSwitch("-s"))
    {
      //format: [-s]
      //	0 => mono (default)
      // 	other => stereo
      m_FlagStereo=GetBooleanValue(false);
    }
    else
    if (IsSwitch("-f"))
    {
      //format: [-f]
      //	-f0 => MYM format[default]
      // 	-f1 => WAV format
      exportFormat=(ExportFormat)GetIntegerValue(0);
    }
    else
    if (IsSwitch("-dt"))
    {
      if (durationMode!=DurationModeKeepAll)
      {
        ShowError("Can't use -dt and -df at the same time");
      }
      durationMode=DurationModeTruncateMode;
      duration=GetIntegerValue(0);
    }
    else
    if (IsSwitch("-df"))
    {
      if (durationMode!=DurationModeKeepAll)
      {
        ShowError("Can't use -dt and -df at the same time");
      }
      durationMode=DurationModeFade;
      duration=GetIntegerValue(0);
    }
  }

  if (flag_header)
  {
    // Header mode: Four parameters
    if (GetParameterCount()!=4)
    {
      //
      // Wrong number of arguments
      //
      ShowError(0);
    }

    //
    // Check start address
    //
    adress_start=ConvertAdress(GetParameter(2));
    headerName=GetParameter(3);
  }
  else
  {
    // No header mode: Two parameters
    if (GetParameterCount()!=2)
    {
      ShowError(0);
    }
  }


  sourceFilename=GetParameter(0);
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
  const unsigned char* sourceData=(const unsigned char*)pcBuffer;

  // Check if the file is compressed
  length=cBufferSize-4;
  if (!strncmp((const char*)sourceData,"YM2!",4))        //  YM2 is ok
  {
    sourceData+=4;
    // YM2!
    // First four bytes is the ASCII identifier "YM2!".
  }
  else
  if (!strncmp((const char*)sourceData,"YM3!",4))      //  YM3 is ok
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
  if (!strncmp((const char*)sourceData,"YM3b",4))    //  YM3b is ok
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
  if (!strncmp((const char*)sourceData,"YM4!",4))    //  YM4 is not yet ok
  {
    sourceData+=4;
    // YM4!
    // (note, should be similar to YM5, without extra infos)
    printf("YM4! format is not yet supported.\n");
    exit(EXIT_FAILURE);
  }
  else
  if ( (!strncmp((const char*)sourceData,"YM5!",4)) || (!strncmp((const char*)sourceData,"YM6!",4)) ) //  YM5 is ok but needs a different loader
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
      interleavedFormat=false;
      //printf("Only interleaved data supported.\n");
      //return(EXIT_FAILURE);
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

    if (flagVerbosity)
    {
      printf("Song name: %s\n",sourceData);
    }
    while((*sourceData++))                 /*  Skip song name          */
      ;

    if (flagVerbosity)
    {
      printf("Author name: %s\n",sourceData);
    }
    while((*sourceData++))                 /*  Skip author name        */
      ;

    if (flagVerbosity)
    {
      printf("Comments: %s\n",sourceData);
    }
    while((*sourceData++))                 /*  Skip comments           */
      ;
  }

  //
  // Extract the register data to get them in an easier to access location
  //
  m_FrameCount=length/REGS;
  for (n=0;n<REGS;n++)     /*  Allocate memory & read data */
  {
    //  Allocate extra fragment to make packing easier
    if ((data[n]=(unsigned char*)malloc(m_FrameCount+FRAG))==NULL)
    {
      printf("Out of memory.\n");
      return(EXIT_FAILURE);
    }
    memset(data[n],0,m_FrameCount+FRAG);
    if (interleavedFormat)
    {
      // R0 R0 R0 R0 R0 R0 R0... | R1 R1 R1 R1 ... | R13 R13 R13 R13
      memcpy(data[n],sourceData,m_FrameCount);
      sourceData+=m_FrameCount;
    }
    else
    {
      // Data block contents now values for 16 registers (14 AY registers plus 2 virtual registers
      // for Atari special effects). 
      // If bit 0 of field Song Attributes is set, data block are stored in YM3-style order (interleaved). 
      // If this bit is reset, then data block consists first 16 bytes of first VBL, then next 16 bytes for second VBL and so on. 
      // In second case YM5 file is compressed more badly.

      // R0 R1 R2 R3 R4 ... R13 R14 R15 | R0 R1 R2 ... R13 R14 R15 |
      for (unsigned int i=0;i<m_FrameCount;i++)
      {
        data[n][i]=sourceData[i*16];
      }
      sourceData++;
    }
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
      for (row=0;row<(long)(length/REGS);row++)
      {
        data[n][row]&=regand[n];
      }
    }
  }

  //
  // Handle the music truncation/fade
  //
  if ( (durationMode!=DurationModeKeepAll) && (m_FrameCount>(unsigned long)duration) )
  {
    length=duration*REGS;

    if (durationMode==DurationModeFade)
    {
      int fadeDuration=50;
      if (fadeDuration>duration)
      {
        fadeDuration=duration;
      }

      int fadeStartPosition=duration-fadeDuration;
      for (n=8;n<10;n++)
      {
        for (row=fadeStartPosition;row<duration;row++)
        {
          unsigned char startVolume=data[n][fadeStartPosition];
          if (startVolume>15)
          {
            startVolume=15;
          }
          data[n][row]=(unsigned char)(startVolume-(startVolume*row)/duration);
        }
      }

    }

    // Make sure the last entry plays nothing
    data[7][duration-1]=255;    // Active sound channels registers
  }


  switch (exportFormat)
  {
  case ExportFormatMym:
    ExportMym();
    break;

  case ExportFormatWav:
    ExportWav();
    break;
  }
  free(pcBuffer);
  return EXIT_SUCCESS;
}



bool MymExporter::ExportMym()
{
  char* destinationBuffer=(char*)malloc(cBufferSize);
  char* ptrWrite=destinationBuffer;

  // Set current values to impossible
  for (n=0;n<REGS;n++)
  {
    current[n]=0xffff;
  }

  *ptrWrite++=length/REGS&0xff;  //  Write tune length
  *ptrWrite++=(length/REGS>>8)&255;

  for (n=0;n<(long)(length/REGS);n+=FRAG)  //  Go through fragments...
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

  ptrdiff_t outputFileSize=(ptrWrite-destinationBuffer);

  if (maxSize && (outputFileSize>maxSize))
  {
    ShowError("File '%s' is too large (%d bytes instead of maximum %d)",sourceFilename,outputFileSize,maxSize);
  }

  FILE* f;
  if ((f=fopen(GetParameter(1),"wb"))==NULL)
  {
    ShowError("Cannot open destination file '%s')",GetParameter(1));
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

      0xbf,	// 8  End address
      0x40,	// 9

      0xa0,	// 10 Start address
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

  free(destinationBuffer);

  return EXIT_SUCCESS;
}





#define FOURCC(a,b,c,d) ( (unsigned int) (((d)<<24) | ((c)<<16) | ((b)<<8) | (a)) )

class WavHeader
{
public:
  WavHeader()    
  {
    memset(this,0,sizeof(*this));
    riff_4cc=FOURCC('R','I','F','F');
    wave_4cc=FOURCC('W','A','V','E');
    fmt_4cc =FOURCC('f','m','t',' ');
    data_4cc=FOURCC('d','a','t','a');
    fmt_size=16;
    format_tag=1;  // WAVE_FORMAT_PCM
  }

public:
  unsigned int    riff_4cc;             // 'RIFF'
  unsigned int    riff_size;
  unsigned int    wave_4cc;             // 'WAVE'
  unsigned int    fmt_4cc;              // 'fmt '
  unsigned int    fmt_size;             // Chunk size: 16, 18 or 40
  unsigned short  format_tag;           // Format code
  unsigned short  channels;             // Number of interleaved channels: 1 for mono, 2 for stereo
  unsigned int    samples_per_second;   // Sampling rate
  unsigned int    bytes_per_second;     // Data rate
  unsigned short  byte_per_sample;      // Data block size (bytes): 1 for mono, 2 for stereo
  unsigned short  bits_per_sample;      // Bits per sample
  unsigned int    data_4cc;             // 'data'
  unsigned int    datalength;           // Length
};


unsigned int ymVolumeTable[16] =
{	
  //62,161,265,377,580,774,1155,1575,2260,3088,4570,6233,9330,13187,21220,32767
  0, 513/4, 828/4, 1239/4, 1923/4, 3238/4, 4926/4, 9110/4, 10344/4, 17876/4, 24682/4, 30442/4, 38844/4, 47270/4, 56402/4, 65535/4
};


// Envelope shape descriptions
// Bit 7 set = go to step defined in bits 0-6
//                           0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
unsigned char eshape0[] = { 15,14,13,12,11,10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 128+15 };
unsigned char eshape4[] = {  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 0, 128+16 };
unsigned char eshape8[] = { 15,14,13,12,11,10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 128+0 };
unsigned char eshapeA[] = { 15,14,13,12,11,10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 128+0 };
unsigned char eshapeB[] = { 15,14,13,12,11,10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 15, 128+16 };
unsigned char eshapeC[] = {  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 128+0 };
unsigned char eshapeD[] = {  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15, 128+15 };
unsigned char eshapeE[] = {  0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,15,14,13,12,11,10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 128+0 };

unsigned char *eshapes[] = 
{ 
  eshape0, // 0000
  eshape0, // 0001
  eshape0, // 0010
  eshape0, // 0011
  eshape4, // 0100
  eshape4, // 0101
  eshape4, // 0110
  eshape4, // 0111
  eshape8, // 1000
  eshape0, // 1001
  eshapeA, // 1010
  eshapeB, // 1011
  eshapeC, // 1100
  eshapeD, // 1101
  eshapeE, // 1110
  eshape4  // 1111
};


/*
** RNG for the AY noise generator
*/
unsigned int  m_noise_generator=1;

unsigned int GetRandomBit()
{
  unsigned int rbit = (m_noise_generator&1) ^ ((m_noise_generator>>2)&1);
  m_noise_generator = (m_noise_generator>>1)|(rbit<<16);
  return rbit&1;
}


bool MymExporter::ExportWav()
{
  // http://www-mmsp.ece.mcgill.ca/Documents/AudioFormats/WAVE/WAVE.html
  //
  // Wav format:
  // U32 RIFF
  // U32 Lenght
  // U32 WAVE
  WavHeader wavHeader;
  wavHeader.channels=1;
  wavHeader.byte_per_sample=1;
  wavHeader.bits_per_sample=8;
  wavHeader.samples_per_second=25033;
  wavHeader.bytes_per_second=wavHeader.samples_per_second*wavHeader.byte_per_sample;

  if (m_FlagStereo)
  {
    wavHeader.channels=2;
    wavHeader.byte_per_sample=2;
  }

  unsigned int soundchipClock  =2000000;                            // The YM in the ST is at 2mhz
  //unsigned int bytesPerSample  =1;                                  // Should be 1 for 8bit mono, 2 for 8bit stereo
  unsigned int framePerSecond  =50;                                 // Should be 50, 60 or 71 
  unsigned int samplesPerSecond=25033;                              // 25khz on the ATARI STE
  unsigned int samplesPerFrame =samplesPerSecond/framePerSecond;    // About 500 samples per frame at 25khz/50hz
  unsigned int cyclesPerSample =soundchipClock/samplesPerSecond;    // About 80 sound-chip cycles between two values



  unsigned int sampleLenght=m_FrameCount*samplesPerFrame;

  wavHeader.datalength=sampleLenght*wavHeader.byte_per_sample;
  wavHeader.riff_size =wavHeader.datalength+8+wavHeader.fmt_size+12;

  char* destinationBuffer=(char*)malloc(wavHeader.datalength);
  if (!destinationBuffer)
  {
    printf("Out of memory.\n");
    return EXIT_FAILURE;
  }
  memset(destinationBuffer,0x80,sampleLenght);
  char* ptrWrite=destinationBuffer;

#if 0
  // Generate some funny sample in it
  for (int i=0;i<sampleLenght;i++)
  {
    char value=128+127*sinf((float)i*0.025f);
    *ptrWrite++=value;
  }
#else
  // Actual YM decoding

  // We are going to use an alternate method.
  // Instead of simulating per row, it's going to be per register.
  // At 2mhz, we get 80 cycles between each value
  {
    ptrWrite=destinationBuffer;

    unsigned int frame=0;
    unsigned int reloadCounter=1;
    unsigned int control=0;
    unsigned int noisePeriode=1;
    unsigned int enveloppePeriode=1;
    unsigned int enveloppeShape=0;
    unsigned int enveloppeCycles=0;
    unsigned int noiseCycles=0;
    
    unsigned int noiseValue=0;

    // Fixed point arithmetic 8:24
    unsigned int volume[3]={0,0,0};
    unsigned int channelActive[3]={0,0,0};
    unsigned int noiseActive[3]={0,0,0};;
    unsigned int cycleSumCounter[3]={0,0,0};
    unsigned int cycleSumIncrement[3]={0,0,0};

    for (unsigned int i=0;i<sampleLenght;i++)
    {
      reloadCounter--;
      if (!reloadCounter)
      {
        reloadCounter=samplesPerFrame;
        
        cycleSumIncrement[0]=3*(0xFFFFFFFF/((((data[1][frame]&15)<<8) | data[0][frame])));       // Delay in cycles before changes, the shorter, the faster it goes
        cycleSumIncrement[1]=3*(0xFFFFFFFF/((((data[3][frame]&15)<<8) | data[2][frame])));       // Delay in cycles before changes, the shorter, the faster it goes
        cycleSumIncrement[2]=3*(0xFFFFFFFF/((((data[5][frame]&15)<<8) | data[4][frame])));       // Delay in cycles before changes, the shorter, the faster it goes
        control=data[7][frame];
        volume[0] =data[8][frame];
        volume[1] =data[9][frame];
        volume[2] =data[10][frame];

        noisePeriode=2*16*(data[6][frame]&31);
        enveloppePeriode=16*((data[12][frame]<<8) | data[11][frame]);
        enveloppeShape =data[9][frame];

        channelActive[0]=!(control&1);
        channelActive[1]=!(control&2);
        channelActive[2]=!(control&4);

        noiseActive[0]=!(control&8);
        noiseActive[1]=!(control&16);
        noiseActive[2]=!(control&32);

        ++frame;
      }

      int controlTest=control;
      int channelOutputValue[3]={0,0,0};
      for (int channel=0;channel<3;channel++)
      {
        if ( (controlTest & (1+8)) != (1+8) )  // Test if there's either tone or noise on this channel
        {
          int output=0;

          if (!(controlTest & 1))             // Tone
          {
            output|=cycleSumCounter[channel]&(1<<31);
          }

          if (!(controlTest & 8))             // Noise
          {
            output|=noiseValue;
          }

          int value;
          if (volume[channel]>15)
          {
            int enveloppeVolume=15;
            value=(ymVolumeTable[enveloppeVolume]*255)/(65535/4);
          }
          else
          {
            value=(ymVolumeTable[volume[channel]]*255)/(65535/4);
          }
          if (!output)
          {
            value=-value;
          }
          channelOutputValue[channel]=value;
        }
        controlTest>>=1;
        cycleSumCounter[channel]+=cycleSumIncrement[channel];   // Fixed point increment
      }
      if (m_FlagStereo)
      {
        // Stereo
        *ptrWrite+=(unsigned char) ( (channelOutputValue[0]+(channelOutputValue[1]/2)+(channelOutputValue[2]/3) )/4 );
        ptrWrite++;
        *ptrWrite+=(unsigned char) ( (channelOutputValue[2]+(channelOutputValue[1]/2)+(channelOutputValue[0]/3) )/4 );
        ptrWrite++;
      }
      else
      {
        // Mono
        int mixerValue=0;
        mixerValue+=channelOutputValue[0];
        mixerValue+=channelOutputValue[1];
        mixerValue+=channelOutputValue[2];

        mixerValue/=8;
        *ptrWrite+=(unsigned char)(mixerValue);
        ptrWrite++;
      }

      if (noiseActive[0]|noiseActive[1]|noiseActive[2])
      {
        if (noisePeriode>cyclesPerSample)
        {
          noiseCycles+=cyclesPerSample;
          while (noiseCycles>noisePeriode)
          {
            noiseCycles-=noisePeriode;
            noiseValue=GetRandomBit();
          }
        }
      }
    }
    //break;
  }
#endif



  FILE* f;
  if ((f=fopen(GetParameter(1),"wb"))==NULL)
  {
    ShowError("Cannot open destination WAV file '%s')",GetParameter(1));
  }


  fwrite(&wavHeader,sizeof(wavHeader),1,f);                     // Header
  fwrite(destinationBuffer,wavHeader.datalength,1,f);           // Data
  free(destinationBuffer);

  fclose(f);

  return EXIT_SUCCESS;
}


//  Writes bits to a file. If bits is 0, pads to byte size.
void MymExporter::writebits(unsigned data,int bits,char* &ptrWrite)
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
    if (data&(1<<((bits-1)-n)))
      byte|=0x80>>off;

    if (++off==8)
    {
      *ptrWrite++=byte;
      off=byte=0;
    }
  }
}

