

#include <assert.h>
#include <stdio.h>
#include <set>
#include <sstream>

#include "common.h"

#include "FreeImage.h"

#include "defines.h"
#include "getpixel.h"

#include "hires.h"
#include "image.h"
#include "svg_format.h"

#include "atari_converter.h"		// For 'AtariClut', but I need a good abstraction for that


unsigned char* FreeImage_GetBitsRowCol(FIBITMAP *dib,int x,int y)
{
  unsigned int dy=FreeImage_GetHeight(dib);
  unsigned char *ptr_byte=FreeImage_GetScanLine(dib,dy-y-1);
  ptr_byte+=x*4;
  return ptr_byte;
}


// ============================================================================
//
//		                             ImageContainer
//
// ============================================================================

ImageContainer::ImageContainer() :
  m_pBitmap(0)
{
}

ImageContainer::ImageContainer(const ImageContainer& otherImage) :
  m_pBitmap(0)
{
  if (otherImage.m_pBitmap && (&otherImage!=this))
  {
    m_pBitmap=FreeImage_Clone(otherImage.m_pBitmap);
  }	
}

ImageContainer::~ImageContainer()
{
  Clear();
}


void ImageContainer::Clear()
{
  if (m_pBitmap)
  {
    FreeImage_Unload(m_pBitmap);
  }
}

bool ImageContainer::Allocate(unsigned int width,unsigned int height,unsigned int bpp)
{
  // Free eventual data
  Clear();

  m_pBitmap=FreeImage_Allocate(width,height,bpp);
  if (m_pBitmap)
  {
    return true;
  }
  return false;
}



unsigned int ImageContainer::GetWidth() const
{
  if (m_pBitmap)
  {
    return FreeImage_GetWidth(m_pBitmap);
  }
  return 0;
}


unsigned int ImageContainer::GetHeight() const
{
  if (m_pBitmap)
  {
    return FreeImage_GetHeight(m_pBitmap);
  }
  return 0;
}

unsigned int ImageContainer::GetDpp() const
{
  if (m_pBitmap)
  {
    return FreeImage_GetBPP(m_pBitmap);
  }
  return 0;
}

unsigned int ImageContainer::GetPaletteSize() const
{
  if (m_pBitmap)
  {
    return FreeImage_GetColorsUsed(m_pBitmap);
  }
  return 0;
}


bool ImageContainer::LoadPicture(const std::string& fileName)
{
  // Free any previous existing picture - if any
  Clear();

  FIBITMAP *dib = NULL;

  // check the file signature and deduce its format
  // (the second argument is currently not used by FreeImage)
  FREE_IMAGE_FORMAT fif=FreeImage_GetFileType(fileName.c_str(),0);
  if (fif==FIF_UNKNOWN)
  {
    // no signature ?
    // try to guess the file format from the file extension
    fif=FreeImage_GetFIFFromFilename(fileName.c_str());
  }
  // check that the plugin has reading capabilities ...
  if ((fif != FIF_UNKNOWN) && FreeImage_FIFSupportsReading(fif))
  {
    // ok, let's load the file
    dib=FreeImage_Load(fif,fileName.c_str(),FIT_BITMAP);
    if (!dib)
    {
      printf("\r\n Unable to load specified picture.");
      //exit(1);
      return false;
    }

    FIBITMAP *converted_dib=FreeImage_ConvertTo32Bits(dib);
    FreeImage_Unload(dib);
    dib=converted_dib;
    if (!dib)
    {
      printf("\r\n Unable to convert the picture data to a suitable format.");
      //exit(1);
      return false;
    }
    m_pBitmap=dib;
  }
  else
  {
    PathSplitter pathSplitter(fileName);
    if (pathSplitter.HasExtension(".svg") && SVG_DrawPicture(this,fileName.c_str()))
    {
      // It's all good
    }
    else
    {
      printf("\r\n Unsupported load file format.");
      //exit(1);
      return false;
    }
  }
  return true;
}


bool ImageContainer::SavePicture(const std::string& fileName) const
{
  if (!m_pBitmap)
  {
    return false;
  }
  FREE_IMAGE_FORMAT fif=FreeImage_GetFIFFromFilename(fileName.c_str());
  if ((fif==FIF_UNKNOWN) || (!FreeImage_FIFSupportsWriting(fif)))
  {
    printf("\r\n Unsupported save file format.");
    //exit(1);
    return false;
  }

  BOOL bSuccess=FreeImage_Save(fif,m_pBitmap,fileName.c_str(),0);
  if (!bSuccess)
  {
    printf("\r\n Unable to save '%s'.",fileName.c_str());
    //exit(1);
    return false;
  }
  return true;
}

void ImageContainer::FillRectangle(const RgbColor& rgb,unsigned int x0,unsigned int y0,unsigned int width,unsigned int heigth)
{
  if (m_pBitmap)
  {
    unsigned int dx=FreeImage_GetWidth(m_pBitmap);
    unsigned int dy=FreeImage_GetHeight(m_pBitmap);

    if (x0>=dx)	return;
    if (y0>=dy)	return;

    unsigned int x1=(x0+width)-1;
    unsigned int y1=(y0+heigth)-1;

    if (x1>=dx)	return;
    if (y1>=dy)	return;

    for (unsigned int y=y0;y<=y1;y++)
    {
      for (unsigned int x=x0;x<=x1;x++)
      {
        BYTE *ptr_byte=FreeImage_GetBitsRowCol(m_pBitmap,x,y);

        *ptr_byte++=rgb.m_blue;
        *ptr_byte++=rgb.m_green;
        *ptr_byte++=rgb.m_red;
        *ptr_byte++=rgb.m_alpha;
      }
    }
  }
}


void ImageContainer::DrawPoint(const RgbColor& rgb,unsigned int x,unsigned int y)
{
  WriteColor(rgb,x,y);
}


void ImageContainer::DrawLine(const RgbColor& rgb,unsigned int x1,unsigned int y1,unsigned int x2,unsigned int y2)
{
  int x,y,dx,dy,dx1,dy1,px,py,xe,ye,i;
  dx=x2-x1;
  dy=y2-y1;
  dx1=abs(dx);
  dy1=abs(dy);
  px=2*dy1-dx1;
  py=2*dx1-dy1;
  if(dy1<=dx1)
  {
    if(dx>=0)
    {
      x=x1;
      y=y1;
      xe=x2;
    }
    else
    {
      x=x2;
      y=y2;
      xe=x1;
    }
    WriteColor(rgb,x,y);
    for(i=0;x<xe;i++)
    {
      x=x+1;
      if(px<0)
      {
        px=px+2*dy1;
      }
      else
      {
        if((dx<0 && dy<0) || (dx>0 && dy>0))
        {
          y=y+1;
        }
        else
        {
          y=y-1;
        }
        px=px+2*(dy1-dx1);
      }
      WriteColor(rgb,x,y);
    }
  }
  else
  {
    if(dy>=0)
    {
      x=x1;
      y=y1;
      ye=y2;
    }
    else
    {
      x=x2;
      y=y2;
      ye=y1;
    }
    WriteColor(rgb,x,y);
    for(i=0;y<ye;i++)
    {
      y=y+1;
      if(py<=0)
      {
        py=py+2*dx1;
      }
      else
      {
        if((dx<0 && dy<0) || (dx>0 && dy>0))
        {
          x=x+1;
        }
        else
        {
          x=x-1;
        }
        py=py+2*(dx1-dy1);
      }
      WriteColor(rgb,x,y);
    }
  }
}


void ImageContainer::WriteColor(const RgbColor& rgb,int x,int y)
{
  if (m_pBitmap)
  {
    if (x<0)	return;
    if (y<0)	return;

    int dx=FreeImage_GetWidth(m_pBitmap);
    int dy=FreeImage_GetHeight(m_pBitmap);

    if (x>=dx)	return;
    if (y>=dy)	return;

    BYTE *ptr_byte=FreeImage_GetBitsRowCol(m_pBitmap,x,y);

    *ptr_byte++=rgb.m_blue;
    *ptr_byte++=rgb.m_green;
    *ptr_byte++=rgb.m_red;
    *ptr_byte++=rgb.m_alpha;
  }
}

RgbColor ImageContainer::ReadColor(int x,int y)	const
{
  RgbColor rgb;
  if (m_pBitmap && (x>=0) && (y>=0))
  {
    int dx=FreeImage_GetWidth(m_pBitmap);
    int dy=FreeImage_GetHeight(m_pBitmap);

    if ( (x<dx)	&& (y<dy) )
    {
      BYTE *ptr_byte=FreeImage_GetBitsRowCol(m_pBitmap,x,y);

      rgb.m_blue	=*ptr_byte++;
      rgb.m_green	=*ptr_byte++;
      rgb.m_red	        =*ptr_byte++;
      rgb.m_alpha       =*ptr_byte++;
    }
  }
  return rgb;
}


bool ImageContainer::ConvertToGrayScale(int maxValues)
{
  int dx=FreeImage_GetWidth(m_pBitmap);
  int dy=FreeImage_GetHeight(m_pBitmap);

  for (int y=0;y<dy;y++)
  {
    for (int x=0;x<dx;x++)
    {
      RgbColor rgb=ReadColor(x,y);
      rgb.m_red  =(rgb.m_red+rgb.m_green+rgb.m_blue)/3;
      rgb.m_green=rgb.m_red;
      rgb.m_blue =rgb.m_red;
      WriteColor(rgb,x,y);
    }
  }
  if (maxValues<256)
  {
    if (GetDpp()!=24)
    {
      FIBITMAP* dib24 = FreeImage_ConvertTo24Bits(m_pBitmap);
      if (dib24)
      {
        FreeImage_Unload(m_pBitmap);
        m_pBitmap=dib24;
      }
    }
    FIBITMAP *dib8  = FreeImage_ColorQuantizeEx(m_pBitmap,FIQ_NNQUANT,maxValues);
    FIBITMAP *dib32 = FreeImage_ConvertTo32Bits(dib8);
    FreeImage_Unload(dib8);
    FreeImage_Unload(m_pBitmap);
    m_pBitmap=dib32;
  }
  return true;
}


#include "shifter_color.h"

bool ImageContainer::ReduceColorDepth(const AtariClut* pClut)
{
  int dx=FreeImage_GetWidth(m_pBitmap);
  int dy=FreeImage_GetHeight(m_pBitmap);

  for (int y=0;y<dy;y++)
  {
    for (int x=0;x<dx;x++)
    {
      RgbColor rgb=ReadColor(x,y);
      ShifterColor shifterColor(rgb);
      rgb=shifterColor.GetRgb();
      WriteColor(rgb,x,y);
    }
  }

  // Then convert to 16 colors
  RGBQUAD* pReservedPalette=0;
  std::vector<RGBQUAD> reservedPalette;
  if (pClut)
  {
    pClut->GetColors(reservedPalette);
    if (!reservedPalette.empty())
    {
      pReservedPalette=&reservedPalette[0];
    }
  }

  if (FreeImage_GetBPP(m_pBitmap) != 24) 
  {
    FIBITMAP *dib24 = FreeImage_ConvertTo24Bits(m_pBitmap);
    FreeImage_Unload(m_pBitmap);
    m_pBitmap=dib24;
  }

  FIBITMAP *dib8  = FreeImage_ColorQuantizeEx(m_pBitmap,FIQ_NNQUANT,16,reservedPalette.size(),pReservedPalette);
  FIBITMAP *dib32 = FreeImage_ConvertTo32Bits(dib8);
  FreeImage_Unload(dib8);
  FreeImage_Unload(m_pBitmap);
  m_pBitmap=dib32;
  return true;
}


bool ImageContainer::ReduceColorDepthPerScanline(const std::map<int,AtariClut>* pCluts)
{
  unsigned int dx=FreeImage_GetWidth(m_pBitmap);
  unsigned int dy=FreeImage_GetHeight(m_pBitmap);

  for (unsigned int y=0;y<dy;y++)
  {
    //_BREAK_IF_(y==8);   // Debugging facility: Uncomment to break in the code at a particular line

    // Convert the current line
    for (unsigned int x=0;x<dx;x++)
    {
      RgbColor rgb=ReadColor(x,y);
      ShifterColor shifterColor(rgb);
      rgb=shifterColor.GetRgb();
      WriteColor(rgb,x,y);
    }

    // Then convert to 16 colors
    RGBQUAD* pReservedPalette=0;
    std::vector<RGBQUAD> reservedPalette;
    if (pCluts)
    {
      std::map<int,AtariClut>::const_iterator it=pCluts->find(y);
      if (it!=pCluts->end())
      {
        const AtariClut& clut=it->second;

        clut.GetColors(reservedPalette);
        if (!reservedPalette.empty())
        {
          pReservedPalette=&reservedPalette[0];
        }
      }
    }

    // Quantize the current line to 16 colors (Atari multi-palette image)
    FIBITMAP *lineCopy = FreeImage_Copy(m_pBitmap,0,y,dx,y+1);
    assert(FreeImage_GetWidth(lineCopy)==dx);
    assert(FreeImage_GetHeight(lineCopy)==1);

    // Then convert to 16 colors
    FREE_IMAGE_QUANTIZE quantize;
    if (pReservedPalette)	quantize=FIQ_NNQUANT;	// FIQ_WUQUANT is better than FIQ_NNQUANT in this particular setup... but it fails handling correctly the reserved palettes...
    else			quantize=FIQ_WUQUANT;	// FIQ_WUQUANT is better than FIQ_NNQUANT in this particular setup...

    if (FreeImage_GetBPP(lineCopy) != 24)
    {
      // Fix for when we reached this place with 32 bit and 8 bit images.
      FIBITMAP *dib24 = FreeImage_ConvertTo24Bits(lineCopy);
      FreeImage_Unload(lineCopy);
      lineCopy = dib24;
    }

    FIBITMAP *dib8  = FreeImage_ColorQuantizeEx(lineCopy,quantize,16,reservedPalette.size(),pReservedPalette);	
    FIBITMAP *dib32 = FreeImage_ConvertTo32Bits(dib8);
    {
      // Check that we have 16 colors max... starting to doubt it
      std::set<RgbColor>	colorMap;
      for (unsigned int x=0;x<dx;x++)
      {
        RgbColor rgb;
        BYTE *ptr_byte=FreeImage_GetBitsRowCol(dib32,x,0);
        rgb.m_blue	=*ptr_byte++;
        rgb.m_green	=*ptr_byte++;
        rgb.m_red	=*ptr_byte++;
        rgb.m_alpha     =*ptr_byte++;
        colorMap.insert(rgb);
      }
      //_BREAK_IF_(colorMap.size()>16);
    }
    FreeImage_Paste(m_pBitmap,dib32,0,y,256);	// Combine mode
    FreeImage_Unload(dib8);
    FreeImage_Unload(dib32);
    FreeImage_Unload(lineCopy);
  }
  return true;
}



bool ImageContainer::CreateFromImage(const ImageContainer& otherImage,unsigned int x,unsigned int y,unsigned int width,unsigned int height)
{
  if (!otherImage.m_pBitmap)
  {
    assert(otherImage.m_pBitmap);
    return false;
  }

  FIBITMAP* pBitmap=FreeImage_Copy(otherImage.m_pBitmap,x,y,x+width,y+height);
  if (!pBitmap)
  {
    return false;
  }
  Clear();
  m_pBitmap=pBitmap;
  return true;
}



int ImageContainer::FindBlocks(std::string& block_data) const
{
  //
  // Phase one: Find a pixel that is not of the color of the background
  //
  ImageContainer image_copy(*this);

  std::stringstream out_x0;
  std::stringstream out_y0;
  std::stringstream out_width;
  std::stringstream out_height;

  out_x0 << "_FontTableX0";
  out_y0 << "_FontTableY0";
  out_width << "_FontTableWidth";
  out_height << "_FontTableHeight";

  RgbColor backgroundColor=image_copy.ReadColor(0,0);

  unsigned int picture_width=GetWidth();
  unsigned int picture_heigth=GetHeight();

  unsigned int first_x,first_y;
  unsigned int sprite_id=0;

  for (first_y=0;first_y<200;first_y++)
  {
    for (first_x=0;first_x<240;first_x++)
    {
      RgbColor pixelColor=image_copy.ReadColor(first_x,first_y);

      if (pixelColor!=backgroundColor)
      {
        //
        // We've got one !!!
        //
        //printf("Found sprite %d at (%d,%d)\n",sprite_id,first_x,first_y);

        unsigned int min_x=first_x;
        unsigned int min_y=first_y;
        unsigned int max_x=first_x;
        unsigned int max_y=first_y;

        // Find the width
        while (((max_x+1)<picture_width) && (image_copy.ReadColor(max_x+1,min_y)!=backgroundColor))
        {
          max_x++;
        }

        // Find the heigth
        while (((max_y+1)<picture_heigth) && (image_copy.ReadColor(min_x,max_y+1)!=backgroundColor))
        {
          max_y++;
        }

        unsigned int width =(max_x-min_x)+1;
        unsigned int heigth=(max_y-min_y)+1;

        // Erase the block
        image_copy.FillRectangle(backgroundColor,min_x,min_y,width,heigth);

        if ((sprite_id&15)==0)
        {
          // Every 16 characters, back to the start with a new .byt line
          out_x0 << "\r\n\t.byt ";
          out_y0 << "\r\n\t.byt ";
          out_width << "\r\n\t.byt ";
          out_height << "\r\n\t.byt ";
        }
        else
        {
          out_x0 << ",";
          out_y0 << ",";
          out_width << ",";
          out_height << ",";
        }

        out_x0 << min_x;
        out_y0 << min_y;
        out_width << width;
        out_height << heigth;

        //printf("\tBounding box: (%d,%d)-(%d,%d)\n",min_x,min_y,max_x,max_y);

        //getch();

        // Increment sprite ID
        sprite_id++;
      }
    }
  }
  block_data+=out_x0.str();
  block_data+="\r\n";
  block_data+=out_y0.str();
  block_data+="\r\n";
  block_data+=out_width.str();
  block_data+="\r\n";
  block_data+=out_height.str();
  block_data+="\r\n";
  return true;			
}


/*
FREEIMAGE_LIB;
1>------ Build started: Project: PictConv, Configuration: Debug Win32 ------
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_GetScanLine referenced in function "unsigned char * __cdecl FreeImage_GetBitsRowCol(struct FIBITMAP *,int,int)" (?FreeImage_GetBitsRowCol@@YAPAEPAUFIBITMAP@@HH@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_GetHeight referenced in function "unsigned char * __cdecl FreeImage_GetBitsRowCol(struct FIBITMAP *,int,int)" (?FreeImage_GetBitsRowCol@@YAPAEPAUFIBITMAP@@HH@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_Clone referenced in function "public: __thiscall ImageContainer::ImageContainer(class ImageContainer const &)" (??0ImageContainer@@QAE@ABV0@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_Unload referenced in function "public: void __thiscall ImageContainer::Clear(void)" (?Clear@ImageContainer@@QAEXXZ)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_Allocate referenced in function "public: bool __thiscall ImageContainer::Allocate(unsigned int,unsigned int,unsigned int)" (?Allocate@ImageContainer@@QAE_NIII@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_GetWidth referenced in function "public: unsigned int __thiscall ImageContainer::GetWidth(void)const " (?GetWidth@ImageContainer@@QBEIXZ)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_GetBPP referenced in function "public: unsigned int __thiscall ImageContainer::GetDpp(void)const " (?GetDpp@ImageContainer@@QBEIXZ)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_GetColorsUsed referenced in function "public: unsigned int __thiscall ImageContainer::GetPaletteSize(void)const " (?GetPaletteSize@ImageContainer@@QBEIXZ)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_ConvertTo24Bits referenced in function "public: bool __thiscall ImageContainer::LoadPicture(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &)" (?LoadPicture@ImageContainer@@QAE_NABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_Load referenced in function "public: bool __thiscall ImageContainer::LoadPicture(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &)" (?LoadPicture@ImageContainer@@QAE_NABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_FIFSupportsReading referenced in function "public: bool __thiscall ImageContainer::LoadPicture(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &)" (?LoadPicture@ImageContainer@@QAE_NABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_GetFIFFromFilename referenced in function "public: bool __thiscall ImageContainer::LoadPicture(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &)" (?LoadPicture@ImageContainer@@QAE_NABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_GetFileType referenced in function "public: bool __thiscall ImageContainer::LoadPicture(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &)" (?LoadPicture@ImageContainer@@QAE_NABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_Save referenced in function "public: bool __thiscall ImageContainer::SavePicture(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &)const " (?SavePicture@ImageContainer@@QBE_NABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_FIFSupportsWriting referenced in function "public: bool __thiscall ImageContainer::SavePicture(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &)const " (?SavePicture@ImageContainer@@QBE_NABV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_ColorQuantizeEx referenced in function "public: bool __thiscall ImageContainer::ReduceColorDepth(class AtariClut const *)" (?ReduceColorDepth@ImageContainer@@QAE_NPBVAtariClut@@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_Paste referenced in function "public: bool __thiscall ImageContainer::ReduceColorDepthPerScanline(class std::map<int,class AtariClut,struct std::less<int>,class std::allocator<struct std::pair<int const ,class AtariClut> > > const *)" (?ReduceColorDepthPerScanline@ImageContainer@@QAE_NPBV?$map@HVAtariClut@@U?$less@H@std@@V?$allocator@U?$pair@$$CBHVAtariClut@@@std@@@3@@std@@@Z)
1>image.obj : error LNK2019: unresolved external symbol _FreeImage_Copy referenced in function "public: bool __thiscall ImageContainer::ReduceColorDepthPerScanline(class std::map<int,class AtariClut,struct std::less<int>,class std::allocator<struct std::pair<int const ,class AtariClut> > > const *)" (?ReduceColorDepthPerScanline@ImageContainer@@QAE_NPBV?$map@HVAtariClut@@U?$less@H@std@@V?$allocator@U?$pair@$$CBHVAtariClut@@@std@@@3@@std@@@Z)
1>pictconv.obj : error LNK2019: unresolved external symbol _FreeImage_DeInitialise referenced in function _main
1>pictconv.obj : error LNK2019: unresolved external symbol _FreeImage_Initialise referenced in function _main
*/





