

#include <assert.h>
#include <stdio.h>
#include <fcntl.h>
#include <iostream>
#include <string.h>

#ifndef _WIN32
#include <unistd.h>
#endif

#include <sys/types.h>
#include <sys/stat.h>

#include "FreeImage.h"

#include "defines.h"
#include "getpixel.h"
#include "hires.h"
#include "oric_converter.h"
#include "dithering.h"

#include "common.h"

#include "image.h"

#include <cstdint>

#ifndef _WIN32
#define _int64 int64_t
#endif

void dither_riemersma_monochrom(ImageContainer& image,int width,int height);


void OricPictureConverter::convert_charmap(const ImageContainer& sourcePicture)
{
  ImageContainer convertedPicture(sourcePicture);

  //
  // Perform the global dithering, if required
  //
  switch (m_dither)
  {
  case DITHER_RIEMERSMA:
    dither_riemersma_monochrom(convertedPicture,m_Buffer.m_buffer_width,m_Buffer.m_buffer_height);
    m_dither=DITHER_NONE;
    break;
  }

  //
  // Perform the conversion to text mode.
  // The method is the following:
  // - The picture is cut in 6x8 blocks
  // - Each block is counted
  // - 6x8=48 bits, so we can use a 64 bit std::map to count the elements
  //
  int charWidth =m_Buffer.m_buffer_width/6;
  int charHeight=m_Buffer.m_buffer_height/8;

  printf("\r\n Size of the picture:%u x %u characters",charWidth,charHeight);

  // Generate two sets of text file
  m_Buffer.SetBufferSize(charWidth*6,charHeight);
  unsigned char *ptr_hires=m_Buffer.GetBufferData();

  unsigned int maxCharacters=96;

  m_SecondaryBuffer.SetBufferSize(6,maxCharacters*8);
  unsigned char *ptr_redef=m_SecondaryBuffer.GetBufferData();

  std::map<uint64_t,std::pair<unsigned int,unsigned int>>   characterMap;     // mask -> count, index

  unsigned int charIndex=0;
  for (int charY=0;charY<charHeight;++charY)
  {
    for (int charX=0;charX<charWidth;++charX)
    {
      unsigned char character[8];
      _int64 val=0;
      for (int line=0;line<8;++line)
      {
        unsigned char hiresByte=0;
        for (int bit=0;bit<6;++bit)
        {
          val<<=1;
          hiresByte<<=1;
          ORIC_COLOR color=convert_pixel_monochrom(convertedPicture,charX*6+bit,charY*8+line);
          if (color!=ORIC_COLOR_BLACK)
          {
            val|=1;
            hiresByte|=1;
          }
        }
        character[line]=hiresByte;
      }
      auto it=characterMap.find(val);
      if (it==characterMap.end())
      {
        // New characters
        characterMap[val].second=charIndex;
        charIndex++;

        if (charIndex<maxCharacters)
        {
          // Store the redefined data
          for (int line=0;line<8;++line)
          {
            *ptr_redef++=character[line];
          }
        }
      }
#if 0  // Breakpoint location for testing overflow or debug issues
      if (characterMap.size()>=107)
      {
        val=val;
      }
#endif
      ++characterMap[val].first;

      unsigned int asciiCode=characterMap[val].second;
      if (asciiCode<96)
      {
        *ptr_hires++=(unsigned char)32+asciiCode;
      }
      else
      {
        *ptr_hires++=32;
      }
    }
  }
  printf("\r\n Found %u different characters",characterMap.size());

#if 0
  // Generate PC picture
  m_Buffer.SetBufferSize(charWidth*6,charHeight*8);

  //
  // Then we rebuild the picture from the charmap
  //
  for (int charY=0;charY<charHeight;++charY)
  {
    for (int charX=0;charX<charWidth;++charX)
    {
      // Find the pattern
      _int64 val=0;
      for (int line=0;line<8;++line)
      {
        for (int bit=0;bit<6;++bit)
        {
          val<<=1;
          ORIC_COLOR color=convert_pixel_monochrom(convertedPicture,charX*6+bit,charY*8+line);
          if (color!=ORIC_COLOR_BLACK)
          {
            val|=1;
          }
        }
      }
      int count=characterMap[val].first;

      // Rebuild the pattern in the target picture
      unsigned char *ptr_hires=m_Buffer.m_buffer+charX+(charY*8)*charWidth;
      // First line is marked with a color depending of the stats
      if (count<5)
      {
        *ptr_hires=16+1;      // RED
      }
      else
      if (count<20)
      {
        *ptr_hires=16+3;      // YELLOW
      }
      else
      if (count<100)
      {
        *ptr_hires=16+2;      // GREEN
      }
      else
      {
        *ptr_hires=16+7;      // WHITE
      }

      // Then the rest is rebuilt in HIRES mode
      for (int line=1;line<8;++line)
      {
        unsigned char hiresByte=0;
        ptr_hires=m_Buffer.m_buffer+charX+(charY*8+line)*charWidth;
        for (int bit=0;bit<6;++bit)
        {
          hiresByte<<=1;
          ORIC_COLOR color=convert_pixel_monochrom(convertedPicture,charX*6+bit,charY*8+line);
          if (color!=ORIC_COLOR_BLACK)
          {
            hiresByte|=1;
          }
        }
        if (m_flag_setbit6)
        {
          // In some cases you don't want the bit 6 to be set at all
          hiresByte|=64;
        }
        if (count==1)
        {
          // If there's only one occurrence, put the byte in inverse video
          hiresByte|=128;
        }
        *ptr_hires=hiresByte;
      }
    }
  }
#endif

  return;
}


