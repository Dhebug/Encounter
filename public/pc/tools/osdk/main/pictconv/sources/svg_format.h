#ifndef SVG_FORMAT_H
#define SVG_FORMAT_H

#include "getpixel.h"
#include "image.h"

class VectorGraphics
{
public:
  enum PrimitiveType
  {
    type_Unknown,
    type_Lines,
    type_Points,
    type_LineStrips,
    type_LineLoops,
  };

public:
  VectorGraphics();

  void SetCanvas(ImageContainer* canvas);

  void SetColor(const RgbColor& color);
  void SetPointSize(float size);

  void Start(PrimitiveType primitiveType);
  void End();

  void AddPoint(float x,float y);

private:
  float         m_X;
  float         m_Y;
  float         m_StartX;
  float         m_StartY;
  float         m_PointSize;
  PrimitiveType m_PrimitiveType;
  int           m_Counter;

  RgbColor        m_CurrentColor;
  ImageContainer* m_Canvas;
};



bool SVG_DrawPicture(ImageContainer* canvas,const char* fileName);


#endif
