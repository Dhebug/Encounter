//
//
//
#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#ifdef _WIN32
#include <io.h>
#else
#include <limits.h>
#define _MAX_PATH PATH_MAX
#define _MAX_DRIVE 255
#define _MAX_DIR   255
#define _MAX_FNAME 255
#define _MAX_EXT   255
#endif
#include <string.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <stdlib.h>

#include "infos.h"

#include "common.h"


extern long LZ77_Compress(void *buf_src,void *buf_dest,long size_buf_src);
extern void LZ77_UnCompress(void *buf_src,void *buf_dest,long size);
extern long LZ77_ComputeDelta(unsigned char *buf_comp,long size_uncomp,long size_comp);

extern unsigned char gLZ77_XorMask;


#define NB_ARG	2



int main(int argc,char *argv[])
{
  //
  // Some initialization for the common library
  //
  SetApplicationParameters(
    "FilePack",
    TOOL_VERSION_MAJOR,
    TOOL_VERSION_MINOR,
    "{ApplicationName} - Version {ApplicationVersion} - This program is a part of the OSDK\r\n"
    "\r\n"
    "Author:\r\n"
    "  Pointier Mickael \r\n"
    "\r\n"
    "Purpose:\r\n"
    "  Compressing or decompressing data so they take less room.\r\n"
    "\r\n"
    "Usage for packing a data file:\r\n"
    "  {ApplicationName} -p[0|1] original_file packed_file\r\n"
    "\r\n"
    "Usage for unpacking a file:\r\n"
    "  {ApplicationName} -u packed_file destination_file\r\n"
    "\r\n"
    "Switches:\r\n"
    " -pn   Packing mode\r\n"
    "       -p0 => No header\r\n"
    "       -p1 => Save with short header [default]\r\n"
    "       -p2 => Save with long header\r\n"
    "\r\n"
    " -mn   Mask type\r\n"
    "       -m0 => 0=copy bytes / 1=new byte [default]\r\n"
    "       -m1 => 0=new byte   / 1=copy bytes\r\n"
    );

  int headerType=1;
  bool flag_pack=true;
  gLZ77_XorMask=0;

  ArgumentParser cArgumentParser(argc,argv);

  while (cArgumentParser.ProcessNextArgument())
  {
    if (cArgumentParser.IsSwitch("-u"))	// Unpack
    {
      flag_pack=false;
    }
    else
    if (cArgumentParser.IsSwitch("-p"))	// Pack data
    {
      flag_pack=true;
      headerType=cArgumentParser.GetIntegerValue(1);
    }
    else
    if (cArgumentParser.IsSwitch("-m"))	// Pack data
    {
      if (cArgumentParser.GetBooleanValue(true))
      {
        gLZ77_XorMask=255;	// Invert the bitmask
      }
      else
      {
        gLZ77_XorMask=0;
      }
    }
  }


  if (cArgumentParser.GetParameterCount()!=NB_ARG)
  {
    ShowError(0);
  }


  //
  // Copy last parameters
  //
  char	source_name[_MAX_PATH];
  strncpy(source_name	,cArgumentParser.GetParameter(0),sizeof(source_name));
  source_name[sizeof(source_name)-1]=0;

  char	dest_name[_MAX_PATH];
  strncpy(dest_name	,cArgumentParser.GetParameter(1),sizeof(dest_name));
  dest_name[sizeof(dest_name)-1]=0;


  char	SDrive[_MAX_DRIVE];
  char	SDir[_MAX_DIR];
  char	SName[_MAX_FNAME];
  char	SExt[_MAX_EXT];

  char	header_name[_MAX_PATH];

  SplitPath(dest_name,SDrive,SDir,SName,SExt);
  sprintf(header_name,"%s%s%s_fp.s",SDrive,SDir,SName);


  void *ptr_buffer_void;
  size_t size_buffer_src;

  if (!LoadFile(source_name,ptr_buffer_void,size_buffer_src))
  {
    printf("\nUnable to load file '%s'",source_name);
    printf("\n");
    exit(1);
  }
  unsigned char *ptr_buffer=(unsigned char*)ptr_buffer_void;

  unsigned char *ptr_buffer_dst;
  unsigned int size_buffer_dst;

  if (flag_pack)
  {
    //
    // Pack file
    //
    int data_offset;
    if (headerType)
    {
      if (headerType==1)
      {
        data_offset=4+2+2;
      }
      else
      if (headerType==2)
      {
        data_offset=4+4+4;
      }
    }
    else
    {
      data_offset=0;
    }
    ptr_buffer_dst=new unsigned char[size_buffer_src+data_offset];
    size_buffer_dst=LZ77_Compress(ptr_buffer,ptr_buffer_dst+data_offset,size_buffer_src);
    if ((size_buffer_dst+data_offset)>=size_buffer_src)
    {
      printf("\nUnable to pack file'%s'",source_name);
      printf("\n");
      exit(1);
    }

    // Compute delta
    //long LZ77_ComputeDelta(unsigned char *buf_comp,long size_uncomp,long size_comp)
    int delta=LZ77_ComputeDelta(ptr_buffer_dst,size_buffer_src,size_buffer_dst);
    printf("\nDelta value: %d",delta);


    //
    // Create file header
    //
    if (headerType)
    {
      if (headerType==1)
      {
        ptr_buffer_dst[0]='L';
        ptr_buffer_dst[1]='Z';
        ptr_buffer_dst[2]='7';
        ptr_buffer_dst[3]='7';

        ptr_buffer_dst[4]=(size_buffer_src&255);
        ptr_buffer_dst[5]=(size_buffer_src>>8)&255;

        ptr_buffer_dst[6]=(size_buffer_dst&255);
        ptr_buffer_dst[7]=(size_buffer_dst>>8)&255;

        size_buffer_dst+=8;
      }
      else
      if (headerType==2)
      {
        ptr_buffer_dst[0]='l';
        ptr_buffer_dst[1]='Z';
        ptr_buffer_dst[2]='7';
        ptr_buffer_dst[3]='7';

        ptr_buffer_dst[4]=(size_buffer_src&255);
        ptr_buffer_dst[5]=(size_buffer_src>>8)&255;
        ptr_buffer_dst[6]=(size_buffer_src>>16)&255;
        ptr_buffer_dst[7]=(size_buffer_src>>24)&255;

        ptr_buffer_dst[8]=(size_buffer_dst&255);
        ptr_buffer_dst[9]=(size_buffer_dst>>8)&255;
        ptr_buffer_dst[10]=(size_buffer_dst>>16)&255;
        ptr_buffer_dst[11]=(size_buffer_dst>>24)&255;

        size_buffer_dst+=12;
      }
    }
    else
    {
      FILE *dest_file=fopen(header_name,"w");
      if (!dest_file)
      {
        printf("Unable to open destination header file\n");
        exit(1);
      }

      fprintf(dest_file,"#define run_adress $%x 	; Come from original TAP executable \r\n",0x600);
      fprintf(dest_file,"#define unpacked_size $%x 	; Come from original TAP executable \r\n",(unsigned int)size_buffer_src);

      fclose(dest_file);
    }
  }
  else
  {
    //
    // Unpack file
    //
    unsigned int size_unpacked	=0;
    unsigned int size_packed	=0;
    unsigned int start_offset	=0;

    if ((ptr_buffer[0]=='L') && // upper case 'L'
      (ptr_buffer[1]=='Z') &&
      (ptr_buffer[2]=='7') &&
      (ptr_buffer[3]=='7'))
    {
      // File with short header
      size_unpacked	=ptr_buffer[4] | (ptr_buffer[5]<<8);
      size_packed		=ptr_buffer[6] | (ptr_buffer[7]<<8);
      start_offset	=4+2+2;
    }
    else
    if ((ptr_buffer[0]=='l') &&	// lower case 'l'
      (ptr_buffer[1]=='Z') &&
      (ptr_buffer[2]=='7') &&
      (ptr_buffer[3]=='7'))
      {
        // File with long header
        size_unpacked	=ptr_buffer[4] | (ptr_buffer[5]<<8) | (ptr_buffer[6]<<16) | (ptr_buffer[7]<<24);
        size_packed		=ptr_buffer[8] | (ptr_buffer[9]<<8) | (ptr_buffer[10]<<16) | (ptr_buffer[11]<<24);
        start_offset	=4+4+4;
      }
      else
      {
        // File without header
        size_unpacked	=size_buffer_src*3;	// random, have to be fixed somewhat...
        size_packed		=size_buffer_src;
        start_offset	=0;
        /*
        printf("\nNot a LZ77 packed file'%s'",source_name);
        printf("\n");
        exit(1);
        */
      }


      if ((size_packed+start_offset)!=size_buffer_src)
      {
        printf("\nInvalid size in packed file'%s'",source_name);
        printf("\n");
        exit(1);
      }

      size_buffer_dst=size_unpacked;

      if (size_buffer_dst>(size_buffer_src*100))
      {
        printf("\nInvalid depacked size in file'%s', possibly corrupted data",source_name);
        printf("\n");
        exit(1);
      }

      ptr_buffer_dst=new unsigned char[size_buffer_dst];
      LZ77_UnCompress(ptr_buffer+start_offset,ptr_buffer_dst,size_buffer_dst);
  }

  if (!SaveFile(dest_name,ptr_buffer_dst,size_buffer_dst))
  {
    printf("\nUnable to save file '%s'",source_name);
    printf("\n");
    exit(1);
  }



  //
  // Make some cleaning
  //
  free(ptr_buffer);
  delete[] ptr_buffer_dst;
}




