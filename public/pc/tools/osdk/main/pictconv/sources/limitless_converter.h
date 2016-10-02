#ifndef LIMITLESS_CONVERTER_H
#define LIMITLESS_CONVERTER_H

#include "hires.h"

#include "FreeImage.h"
#include "image.h"

class RgbColor;


class LimitlessPictureConverter : public PictureConverter
{
  friend class PictureConverter;

public:

  enum FORMAT
  {
    FORMAT_DEFAULT,
    _FORMAT_MAX_
  };

protected:
  LimitlessPictureConverter();
  virtual ~LimitlessPictureConverter();

  virtual int GetFormat() const			                { return (int)m_format; }
  virtual bool SetFormat(int format);

  virtual int GetPaletteMode() const				{ return 0; }
  virtual bool SetPaletteMode(int)                              { return true;}

  virtual int GetTransparencyMode() const                       { return TRANSPARENCY_NONE; }
  virtual bool SetTransparencyMode(int)                         { return true; }

  virtual int GetSwapMode() const                               { return SWAPPING_DISABLED; }
  virtual bool SetSwapMode(int)                                 { return true; }


  virtual bool Convert(const ImageContainer& sourcePicture);
  virtual bool TakeSnapShot(ImageContainer& sourcePicture);
  virtual void SaveToFile(long,int)                             {}

  virtual unsigned char *GetBufferData(int)                     { return nullptr; }
  virtual unsigned int GetBufferSize()                          { return 0; }

private:
  FORMAT				m_format;
  ImageContainer                        m_Picture;
};


#endif
