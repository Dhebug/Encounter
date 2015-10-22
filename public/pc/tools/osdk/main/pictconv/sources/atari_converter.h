#ifndef ATARI_CONVERTER_H
#define ATARI_CONVERTER_H

#include "hires.h"

#include "FreeImage.h"

class RgbColor;
class ShifterColor;


class AtariClut
{
public:
  int convert_pixel_shifter(const RgbColor& rgb);
  int convert_pixel_shifter(const ShifterColor& color);

  void SetColor(const RgbColor& rgb,int index);
  void SetColor(const ShifterColor& color,int index);

  void SaveClut(long handle) const;
  void SaveClutAsText(std::string& text) const;

  void Reorder(AtariClut& baseClut);

  void GetColors(std::vector<RGBQUAD>& colors) const;

public:
  std::map<ShifterColor,int>	m_clut_color_to_index;
  std::map<int,ShifterColor>	m_clut_index_to_color;
};

class AtariPictureConverter : public PictureConverter
{
  friend class PictureConverter;

public:
  enum FORMAT
  {
    FORMAT_SINGLE_PALETTE,
    FORMAT_MULTIPLE_PALETTE,
    _FORMAT_MAX_
  };

  enum PALETTE_MODE
  {
    PALETTE_AUTOMATIC,
    PALETTE_FROM_LAST_LINE,
    PALETTE_FROM_LAST_PIXELS,
    _PALETTE_MAX_
  };

protected:
  AtariPictureConverter();
  virtual ~AtariPictureConverter();

  virtual int GetFormat() const			{ return (int)m_format; }
  virtual bool SetFormat(int format)		{ m_format=(FORMAT)format;return m_format<_FORMAT_MAX_; }

  virtual int GetPaletteMode() const				{ return m_palette_mode; }
  virtual bool SetPaletteMode(int paletteMode)	                { m_palette_mode=(PALETTE_MODE)paletteMode;return m_palette_mode<_PALETTE_MAX_; }

  virtual int GetTransparencyMode() const                         { return m_transparency; }
  virtual bool SetTransparencyMode(int transparencyMode)          { m_transparency=(TRANSPARENCY)transparencyMode;return m_transparency<_TRANSPARENCY_MAX_; }

  virtual bool Convert(const ImageContainer& sourcePicture);
  virtual bool TakeSnapShot(ImageContainer& sourcePicture);

  virtual void SaveToFile(long handle,int output_format);

private:
  //int	convert_pixel_shifter(const RgbColor& rgb);
  void convert_shifter(const ImageContainer& sourcePicture);

  void clear_screen();

  unsigned char* GetBufferData()	{ return m_buffer; }
  unsigned int GetBufferSize()		{ return m_buffer_size; }

  unsigned int get_buffer_width()	{ return m_buffer_width; }
  unsigned int get_buffer_height()	{ return m_buffer_height; }

  void set_buffer_size(int width,int height);

  AtariClut& GetClut(unsigned int scanline);

private:
  FORMAT				m_format;
  PALETTE_MODE				m_palette_mode;
  unsigned char*			m_buffer;
  unsigned int				m_buffer_size;
  unsigned int				m_buffer_width;
  unsigned int				m_buffer_height;
  int					m_buffer_cols;
  bool					m_flagPalettePerScanline;

  std::map<int,AtariClut>		m_cluts;		// Scanline/associated clut
};


#endif
