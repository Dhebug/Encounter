#ifndef ORIC_CONVERTER_H
#define ORIC_CONVERTER_H

#include "hires.h"

enum ORIC_COLOR
{						// BGR
  ORIC_COLOR_BLACK,	// 000
  ORIC_COLOR_RED,		// 001
  ORIC_COLOR_GREEN,	// 010
  ORIC_COLOR_YELLOW,	// 011
  ORIC_COLOR_BLUE,	// 100
  ORIC_COLOR_MAGENTA,	// 101
  ORIC_COLOR_CYAN,	// 110
  ORIC_COLOR_WHITE,	// 111
  _ORIC_COLOR_LAST_
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
    _FORMAT_MAX_
  };

public:
  virtual int GetFormat() const			{ return (int)m_format; }
  virtual bool SetFormat(int format)		{ m_format=(FORMAT)format;return m_format<_FORMAT_MAX_; }

  virtual int GetPaletteMode() const		{ return 0; }
  virtual bool SetPaletteMode(int paletteMode)	{ return paletteMode==0; }

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
  
  ORIC_COLOR convert_pixel_monochrom(const ImageContainer& sourcePicture,unsigned int x,unsigned int y);
  ORIC_COLOR convert_pixel_rgb(const ImageContainer& sourcePicture,unsigned int x,unsigned int y);
  ORIC_COLOR convert_pixel_rb(const ImageContainer& sourcePicture,unsigned int x,unsigned int y);

  void save_header(long handle,int adress_begin);

  virtual unsigned char *GetBufferData()	  { return m_Buffer.GetBufferData(); }
  virtual unsigned int GetBufferSize()	          { return m_Buffer.GetBufferSize(); }

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

  bool		  m_flag_setbit6;
};

#endif
