

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
#ifndef _WIN32
#define _int64 int64_t
#endif



void OricPictureConverter::convert_video(const ImageContainer& sourcePicture)
{
  ImageContainer convertedPicture(sourcePicture);

  //
  // The source picture can be any size, we need to squish it to 240x200 at a maximum, and possibly remove colors or grey scales
  //
  m_flag_setbit6=false;
  /*
  DITHER_NONE,
  DITHER_ALTERNATE,
  DITHER_ORDERED,
  DITHER_RIEMERSMA,
  DITHER_FLOYD,
  DITHER_ALTERNATE_INVERSED,
  */
  m_dither=DITHER_ALTERNATE;
  //convertedPicture.ConvertToBlackAndWhite(64);
  convertedPicture.Rescale(240,200);
  m_Buffer.SetBufferSize(240,200);	// Default size
  convert_monochrom(convertedPicture);

  // Encode the stuff in the screen encoder
  m_ScreenHistory.Encode(m_Buffer);
}


void OricPictureConverter::EncodeMovie()
{
  m_ScreenHistory.EncodeMovie();
  m_Buffer.ClearBuffer(true);
  m_ScreenHistory.DecodeMovie(this,"D:\\sources\\oric\\Demos\\VideoPlayer\\Video\\BadApple\\decoded_frames\\MyAniGIF.gif");
}



void ScreenHistory::EncodeMovie()
{
  printf("\r\n Encoding movie to by stream");
  m_FullVideoStream.clear();

  unsigned char depackCounter[8000];
  memset(depackCounter,0,8000);

  for (unsigned int frame=0;frame<m_FrameCount;++frame)
  {
    unsigned char* counterPtr=depackCounter;
    for (auto it(m_BytesHistory.begin());it!=m_BytesHistory.end();++it)
    {
      for (auto it2(it->begin());it2!=it->end();++it2)
      {
        unsigned char counter=*counterPtr;
        if (counter)
        {
          counter--;
        }
        else
        {
          counter=it2->EncodeByte(m_FullVideoStream);
        }
        *counterPtr++=counter;
      }
    }
  }
  printf("\r\n - %u frames encoded to %u bytes (avg to %u bytes per frame)",m_FrameCount,m_FullVideoStream.size(),m_FullVideoStream.size()/m_FrameCount);

  m_LZPackedVideoStream.resize(m_FullVideoStream.size());
  size_t compressedFileSize=LZ77_Compress(m_FullVideoStream.data(),m_LZPackedVideoStream.data(),m_FullVideoStream.size());
  printf("\r\n - stream compressed to %u bytes (avg to %u bytes per frame)",compressedFileSize,compressedFileSize/m_FrameCount);
}


#include <sstream>


void ScreenHistory::DecodeMovie(OricPictureConverter* convert,const char* path)
{
  unsigned char depackCounter[8000];
  memset(depackCounter,0,8000);

  unsigned char* buffer(convert->GetBufferData());


  TextFileGenerator textFileGenerator;
  textFileGenerator.SetLabel("_LabelPicture");
  textFileGenerator.SetDataSize(1);											// Byte format
  textFileGenerator.SetEndianness(TextFileGenerator::_eEndianness_Little);	// Little endian

  


  //
  // Save to GIF to test the result
  //
  // Create a new multipage image
  m_MultiBitmap = FreeImage_OpenMultiBitmap(FIF_GIF, path, 1, 0);

  ImageContainer currentFrame;

  const unsigned char* streamPtr=m_FullVideoStream.data();
  for (unsigned int frame=0;frame<m_FrameCount;++frame)
  {
    //
    // Need to recreate the next frame of the Oric picture from the compressed stream
    //
    unsigned char* counterPtr=depackCounter;
    for (int byte=0;byte<8000;byte++)
    {
      unsigned char counter=*counterPtr;
      if (counter)
      {
        counter--;
      }
      else
      {
        unsigned char value=*streamPtr++;
        unsigned char countMask=value>>6;
        value&=63;

        buffer[byte]=value|64;

        if (countMask<3)
        {
          counter=countMask;
        }
        else
        {
          counter=*streamPtr++;
        }
      }
      *counterPtr++=counter;
    }

    //
    // Then we snapshot it to be in the FreeImage format
    //
    convert->TakeSnapShot(currentFrame);


    std::stringstream finalPath;
    finalPath << path << "_frame" << frame << ".png";
    
    if (!convert->Save(DEVICE_FORMAT_PICTURE,finalPath.str(),textFileGenerator))
    {
      ShowError("Saving failed");
    }

    currentFrame.ConvertTo8Bit();

    // Append the animation metadata
    // Read topic 'FIMD_ANIMATION metadata model specification' on
    // page 109 in the PDF documentation.
    //FreeImage_AppendTag(currentFrame.GetBitmap(), FIMD_ANIMATION, &quot;FrameTime&quot;, FIDT_LONG, 128)
    //FreeImage_AppendTag(currentFrame.GetBitmap(), FIMD_ANIMATION, &quot;DisposalMethod&quot;, FIDT_BYTE, FIFD_GIF_DISPOSAL_LEAVE)

    // Loop the animation infinite. So, add this tag only to frame 0:
    if (!frame)
    {
      //FreeImage_AppendTag(currentFrame.GetBitmap(), FIMD_ANIMATION, &quot;Loop&quot;, FIDT_LONG, 0)
    }

    // Append the frame to the multipage GIF.
    FreeImage_AppendPage(m_MultiBitmap,currentFrame.GetBitmap());

  }
  // Save the multipage image
  FreeImage_CloseMultiBitmap(m_MultiBitmap);
}
