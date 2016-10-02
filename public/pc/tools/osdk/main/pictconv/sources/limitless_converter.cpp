
#define _CRT_SECURE_NO_WARNINGS

#include <assert.h>
#include <string.h>
#include <stdio.h>

#include <iostream>

#include "common.h"

#include "defines.h"
#include "getpixel.h"

#include "limitless_converter.h"
#include "shifter_color.h"

#include "image.h"

#include "FreeImage.h"



// ============================================================================
//
//		             LimitlessPictureConverter
//
// ============================================================================

LimitlessPictureConverter::LimitlessPictureConverter() 
  : PictureConverter(MACHINE_LIMITLESS)
{
  m_Picture.Allocate(320,200,32);  // Default size
}

LimitlessPictureConverter::~LimitlessPictureConverter()
{
}


bool LimitlessPictureConverter::SetFormat(int format)		                
{ 
  m_format=(FORMAT)format;
  return m_format<_FORMAT_MAX_; 
}


bool LimitlessPictureConverter::Convert(const ImageContainer& sourcePicture)
{
  m_Picture=sourcePicture;
  return true;
}



bool LimitlessPictureConverter::TakeSnapShot(ImageContainer& sourcePicture)
{
  sourcePicture=m_Picture;
  return true;
}

