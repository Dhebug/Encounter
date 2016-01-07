#ifndef ORIC_CONVERTER_H
#define ORIC_CONVERTER_H

#include "hires.h"

// This utility macro is used to define the set of all binary operations on an enum.
// This makes it possible to do type-safe boolean operations without having to duplicate
// the ugly syntax everywhere.
//-->> BINARYENUM
#ifndef BINARYENUM
#define BINARYENUM(T)                                                           \
  inline T& operator++(T& e1)                 {e1 = (T)((int)(e1)+1);return e1;} \
  inline T operator++(T& e1,int)              {T old(e1);e1 = (T)((int)(e1)+1);return old;} \
  inline T operator~(const T e1)              {return (T)(~(int)e1);}           \
  inline T operator|(const T e1,const T e2)   {return (T)((int)e1|(int)e2);}    \
  inline T operator&( const T e1, const T e2 ){return (T)((int)e1&(int)e2);}    \
  inline T operator^( const T e1, const T e2 ){return (T)((int)e1^(int)e2);}    \
  inline T operator-( const T e1, const T e2 ){return (T)((int)e1-(int)e2);}    \
  inline T operator+( const T e1, const T e2 ){return (T)((int)e1+(int)e2);}    \
  inline T& operator |= (T& lhs,T rhs)        {lhs=lhs|rhs;return lhs;}         \
  inline T& operator &= (T& lhs,T rhs)        {lhs=lhs&rhs;return lhs;}         \
  inline T& operator ^= (T& lhs,T rhs)        {lhs=lhs^rhs;return lhs;}          
#endif
// <<-- BINARYENUM


enum ORIC_COLOR
{			// BGR
  ORIC_COLOR_BLACK,	// 000
  ORIC_COLOR_RED,	// 001
  ORIC_COLOR_GREEN,	// 010
  ORIC_COLOR_YELLOW,	// 011
  ORIC_COLOR_BLUE,	// 100
  ORIC_COLOR_MAGENTA,	// 101
  ORIC_COLOR_CYAN,	// 110
  ORIC_COLOR_WHITE,	// 111
  _ORIC_COLOR_LAST_,
  ORIC_COLOR_OPAQUE     =0,
  ORIC_COLOR_TRANSPARENT=8
};

BINARYENUM(ORIC_COLOR)


class BlocOf6
{
public:
  BlocOf6()
  {
    Clear();
  }

  void Clear()
  {
    color_count=0;
    colors[0]=ORIC_COLOR_BLACK;
    colors[1]=ORIC_COLOR_BLACK;
    value=0;
  }

  bool AddColor(ORIC_COLOR color)
  {
    bool error_in_bloc=false;

    value<<=1;

    // Check if it's already present in the color map
    switch (color_count)
    {
    case 0:
      color_count++;
      colors[0]=color;
      colors[1]=color;	// To avoid later tests
      break;

    case 1:
      if (colors[0]!=color)
      {
        // one more color
        color_count++;
        colors[1]=color;
        value|=1;
      }
      break;

    case 2:
      if (colors[0]!=color)
      {
        if (colors[1]==color)
        {
          // second color
          value|=1;
        }
        else
        {
          // color overflow !!!
          color_count++;

          error_in_bloc=true;
        }
      }
      break;
    }
    return error_in_bloc;
  }

  bool UsePalette(ORIC_COLOR paperColor,ORIC_COLOR inkColor)
  {
    switch (color_count)
    {
    case 1: // Only one color is used in this block      
      if (colors[0]==paperColor)
      {
        // We already have the right paper color, nothing to do
        return true;
      }
      if (colors[0]==inkColor)
      {
        // This block uses the ink color, need to invert the bit mask
        value^=1+2+4+8+16+32;
        return true;
      }
      if (colors[0]==(paperColor^7))
      {
        // This block uses the inverted paper color, need to invert video it
        value|=128;
        return true;
      }
      if (colors[0]==(inkColor^7))
      {
        // This block uses the ink color, need to invert both the bit mask and the invert video bit
        value^=1+2+4+8+16+32;
        value|=128;
        return true;
      }
      break;

    case 2: // Two colors are used in this block
      if ( (colors[0]==paperColor) && (colors[1]==inkColor) )
      {
        // We already have the right paper and ink colors, nothing to do
        return true;
      }
      if ( (colors[0]==inkColor) && (colors[1]==paperColor) )
      {
        // The paper and ink values are inverted, we need to invert the bit mask
        value^=1+2+4+8+16+32;
        return true;
      }
      if ( (colors[0]==(paperColor^7)) && (colors[1]==(inkColor^7)) )
      {
        // This block uses the inverted paper color, need to invert video it
        value|=128;
        return true;
      }
      if ( (colors[0]==(inkColor^7)) && (colors[1]==(paperColor^7)) )
      {
        // This block uses the ink color, need to invert both the bit mask and the invert video bit
        value^=1+2+4+8+16+32;
        value|=128;
        return true;
      }
      break;

    default:
      // Not the right number of colors, can't do anything about it
      return false;
    }

    return true;
  }

public:
  unsigned char	color_count;    ///< Number of colors in the block (1, 2 or invalid)
  ORIC_COLOR	colors[2];      ///< The two first color found by order of appearance
  unsigned char	value;          ///< The bitmap that associate each color to each bit, and possibly the inverse video flag if enabled
};



class GeneratedBuffer
{
public:
  GeneratedBuffer() :
    m_buffer(0),
    m_buffer_size(0),
    m_buffer_width(0),
    m_buffer_height(0),
    m_buffer_cols(0)
  {
  }

  ~GeneratedBuffer()
  {
    delete[] m_buffer;
  }


  void SetBufferSize(int width,int height)
  {
    m_buffer_width	=width;
    m_buffer_height	=height;
    m_buffer_cols	=(width+5)/6;
    m_buffer_size	=m_buffer_height*m_buffer_cols;

    delete[] m_buffer;
    m_buffer=new unsigned char[m_buffer_size];
  }



  void ClearBuffer(bool setBit6)
  {
    //
    // Fill the screen with a neutral value (64=white space for hires)
    //
    unsigned char fillValue;
    if (setBit6)
    {
      fillValue=64;
    }
    else
    {
      fillValue=0;
    }
    for (unsigned int i=0;i<m_buffer_size;i++)
    {
      m_buffer[i]=fillValue;
    }
  }

  virtual unsigned char *GetBufferData()	{ return m_buffer; }
  virtual unsigned int GetBufferSize()	        { return m_buffer_size; }

  unsigned int get_buffer_width() const		{ return m_buffer_width; }
  unsigned int get_buffer_height() const	{ return m_buffer_height; }

  void SetName(const std::string& name)         { m_Name=name; }
  const std::string& GetName() const            { return m_Name; }

public:
  std::string         m_Name;
  unsigned char*      m_buffer;
  unsigned int	      m_buffer_size;
  unsigned int	      m_buffer_width;
  unsigned int	      m_buffer_height;
  int		      m_buffer_cols;
};


class OricPictureConverter : public PictureConverter
{
  friend class PictureConverter;

public:
  enum FORMAT
  {
    FORMAT_MONOCHROM,       // -f0 / -f0z
    FORMAT_COLORED,         // -f1
    FORMAT_RGB,             // -f2
    FORMAT_TWILIGHTE_MASK,  // -f3
    FORMAT_RB,              // -f4
    FORMAT_CHARMAP,         // -f5
    FORMAT_SAM_HOCEVAR,     // -f6
    FORMAT_AIC,             // -f7
    _FORMAT_MAX_
  };

public:
  virtual int GetFormat() const			{ return (int)m_format; }
  virtual bool SetFormat(int format)		{ m_format=(FORMAT)format;return m_format<_FORMAT_MAX_; }

  virtual int GetPaletteMode() const		{ return 0; }
  virtual bool SetPaletteMode(int paletteMode)	{ return paletteMode==0; }

  virtual int GetTransparencyMode() const                         { return m_transparency; }
  virtual bool SetTransparencyMode(int transparencyMode)          { m_transparency=(TRANSPARENCY)transparencyMode;return m_transparency<_TRANSPARENCY_MAX_; }

  virtual int GetSwapMode() const                                 { return m_swapping; }
  virtual bool SetSwapMode(int swapMode)                          { m_swapping=(SWAPPING)swapMode;return m_transparency<_SWAPPING_MAX_; }

  virtual bool Convert(const ImageContainer& sourcePicture);
  virtual bool TakeSnapShot(ImageContainer& sourcePicture);

  virtual void SaveToFile(long handle,int output_format);

  bool get_bit6()				{ return m_flag_setbit6; }
  void set_bit6(bool flag_value)		{ m_flag_setbit6=flag_value; }

  void convert_monochrom(const ImageContainer& sourcePicture);
  void convert_colored(const ImageContainer& sourcePicture);
  void convert_rgb(const ImageContainer& sourcePicture);
  void convert_rb(const ImageContainer& sourcePicture);
  void convert_twilighte_mask(const ImageContainer& sourcePicture);
  void convert_charmap(const ImageContainer& sourcePicture);
  void convert_sam_hocevar(const ImageContainer& sourcePicture);
  void convert_aic(const ImageContainer& sourcePicture);
  
  ORIC_COLOR convert_pixel_monochrom(const ImageContainer& sourcePicture,unsigned int x,unsigned int y);
  ORIC_COLOR convert_pixel_rgb(const ImageContainer& sourcePicture,unsigned int x,unsigned int y);
  ORIC_COLOR convert_pixel_rb(const ImageContainer& sourcePicture,unsigned int x,unsigned int y);

  void save_header(long handle,int adress_begin);

  virtual unsigned char *GetBufferData(int buffer=0)	  { (void)buffer; return m_Buffer.GetBufferData(); }
  virtual unsigned int GetBufferSize()	          		{ return m_Buffer.GetBufferSize(); }

  virtual unsigned char *GetSecondaryBufferData() { return m_SecondaryBuffer.GetBufferData(); }
  virtual unsigned int GetSecondaryBufferSize()	  { return m_SecondaryBuffer.GetBufferSize(); }

  unsigned int get_buffer_width()		{ return m_Buffer.get_buffer_width(); }
  unsigned int get_buffer_height()		{ return m_Buffer.get_buffer_height(); }

protected:
  OricPictureConverter();
  virtual ~OricPictureConverter();

private:
  GeneratedBuffer m_Buffer;
  GeneratedBuffer m_SecondaryBuffer;

  FORMAT	  m_format;
  ORIC_COLOR      m_PaletteAIC[2][2];         ///< [even/odd scanline[paper/ink color]

  bool		  m_flag_setbit6;
};

#endif
