

#include <assert.h>

#include <cstdio>

#include "svg_format.h"

#define NANOSVG_IMPLEMENTATION
#include "nanosvg.h"
#define NANOSVGRAST_IMPLEMENTATION
#include "nanosvgrast.h"


VectorGraphics::VectorGraphics()
  : m_X(0.0f)
  , m_Y(0.0f)
  , m_PointSize(1.0f)
  , m_CurrentColor(255,172,128)
  , m_PrimitiveType(type_Unknown)
  , m_Counter(0)
  , m_Canvas(nullptr)
{
}


void VectorGraphics::SetCanvas(ImageContainer* canvas)
{
  m_Canvas=canvas;
}


void VectorGraphics::AddPoint(float x,float y)
{
  if (!m_Counter)
  {
    m_StartX=x;
    m_StartY=y;
  }

  switch (m_PrimitiveType)
  {
  case type_Lines:
    break;

  case type_Points:
    m_Canvas->DrawPoint(m_CurrentColor,x,y);
    break;

  case type_LineStrips:
    if (m_Counter)
    {
      m_Canvas->DrawLine(m_CurrentColor,m_X,m_Y,x,y);
    }
    break;

  case type_LineLoops:
    if (m_Counter)
    {
      m_Canvas->DrawLine(m_CurrentColor,m_X,m_Y,x,y);
    }
    break;
  }
  m_X=x;
  m_Y=y;
  m_Counter++;
}



void VectorGraphics::SetColor(const RgbColor& color)
{
  m_CurrentColor=color;
}

void VectorGraphics::SetPointSize(float size)
{
  m_PointSize=size;
}

void VectorGraphics::Start(PrimitiveType primitiveType)
{
  m_PrimitiveType=primitiveType;
  m_Counter=0;
}

void VectorGraphics::End()
{
  switch (m_PrimitiveType)
  {
  case type_Lines:
    break;

  case type_Points:
    break;

  case type_LineStrips:
    break;

  case type_LineLoops:
    if (m_Counter)
    {
      m_Canvas->DrawLine(m_CurrentColor,m_X,m_Y,m_StartX,m_StartY);
    }
    break;
  }

  m_PrimitiveType=type_Unknown;
}

static VectorGraphics    g_VectorTest;
static RgbColor bgColor(205,202,200,255);
static RgbColor lineColor(0,160,192,255);






static float distPtSeg(float x, float y, float px, float py, float qx, float qy)
{
  float pqx, pqy, dx, dy, d, t;
  pqx = qx-px;
  pqy = qy-py;
  dx = x-px;
  dy = y-py;
  d = pqx*pqx + pqy*pqy;
  t = pqx*dx + pqy*dy;
  if (d > 0) t /= d;
  if (t < 0) t = 0;
  else if (t > 1) t = 1;
  dx = px + t*pqx - x;
  dy = py + t*pqy - y;
  return dx*dx + dy*dy;
}


static void cubicBez(float x1, float y1, float x2, float y2,
                     float x3, float y3, float x4, float y4,
                     float tol, int level)
{
  float x12,y12,x23,y23,x34,y34,x123,y123,x234,y234,x1234,y1234;
  float d;

  if (level > 12) return;

  x12 = (x1+x2)*0.5f;
  y12 = (y1+y2)*0.5f;
  x23 = (x2+x3)*0.5f;
  y23 = (y2+y3)*0.5f;
  x34 = (x3+x4)*0.5f;
  y34 = (y3+y4)*0.5f;
  x123 = (x12+x23)*0.5f;
  y123 = (y12+y23)*0.5f;
  x234 = (x23+x34)*0.5f;
  y234 = (y23+y34)*0.5f;
  x1234 = (x123+x234)*0.5f;
  y1234 = (y123+y234)*0.5f;

  d = distPtSeg(x1234, y1234, x1,y1, x4,y4);
  if (d > tol*tol) 
  {
    cubicBez(x1,y1, x12,y12, x123,y123, x1234,y1234, tol, level+1); 
    cubicBez(x1234,y1234, x234,y234, x34,y34, x4,y4, tol, level+1); 
  } 
  else 
  {
    g_VectorTest.AddPoint(x4,y4);
  }
}


void drawPath(float* pts, int npts, char closed, float tol)
{
  g_VectorTest.Start(VectorGraphics::type_LineStrips);
  g_VectorTest.SetColor(lineColor);
  g_VectorTest.AddPoint(pts[0], pts[1]);
  for (int i = 0; i < npts-1; i += 3) 
  {
    float* p = &pts[i*2];
    cubicBez(p[0],p[1], p[2],p[3], p[4],p[5], p[6],p[7], tol, 0);
  }
  if (closed) 
  {
    g_VectorTest.AddPoint(pts[0], pts[1]);
  }
  g_VectorTest.End();
}


void drawControlPts(float* pts, int npts)
{
  // Control lines
  g_VectorTest.SetColor(lineColor);
  g_VectorTest.Start(VectorGraphics::type_Lines);
  for (int i = 0; i < npts-1; i += 3)
  {
    float* p = &pts[i*2];
    g_VectorTest.AddPoint(p[0],p[1]);
    g_VectorTest.AddPoint(p[2],p[3]);
    g_VectorTest.AddPoint(p[4],p[5]);
    g_VectorTest.AddPoint(p[6],p[7]);
  }
  g_VectorTest.End();

  // Points
  g_VectorTest.SetPointSize(6.0f);
  g_VectorTest.SetColor(lineColor);

  g_VectorTest.Start(VectorGraphics::type_Points);
  g_VectorTest.AddPoint(pts[0],pts[1]);
  for (int i = 0; i < npts-1; i += 3)
  {
    float* p = &pts[i*2];
    g_VectorTest.AddPoint(p[6],p[7]);
  }
  g_VectorTest.End();

  // Points
  g_VectorTest.SetPointSize(3.0f);

  g_VectorTest.Start(VectorGraphics::type_Points);
  g_VectorTest.SetColor(bgColor);
  g_VectorTest.AddPoint(pts[0],pts[1]);
  for (int i = 0; i < npts-1; i += 3)
  {
    float* p = &pts[i*2];
    g_VectorTest.SetColor(lineColor);
    g_VectorTest.AddPoint(p[2],p[3]);
    g_VectorTest.AddPoint(p[4],p[5]);
    g_VectorTest.SetColor(bgColor);
    g_VectorTest.AddPoint(p[6],p[7]);
  }
  g_VectorTest.End();
}


bool SVG_DrawPicture(ImageContainer* canvas,const char* fileName)
{
  NSVGimage* svgImage = nsvgParseFromFile(fileName, "px", 96.0f);
  if (svgImage == NULL) 
  {
    printf("Could not open SVG image.\n");
    return false;
  }

  int width = 0, height = 0;
  float view[4], cx, cy, hw, hh, aspect, px;
  NSVGshape* shape;
  NSVGpath* path;
 
  // Fit view to bounds
  cx = svgImage->width*0.5f;
  cy = svgImage->height*0.5f;
  hw = svgImage->width*0.5f;
  hh = svgImage->height*0.5f;

  width =svgImage->width;
  height=svgImage->height;
  canvas->Allocate(width,height,32);

  canvas->FillRectangle(RgbColor(255,128,128,64),0,0,width,height);

  g_VectorTest.SetCanvas(canvas);

  if (width/hw < height/hh) 
  {
    aspect = (float)height / (float)width;
    view[0] = cx - hw * 1.2f;
    view[2] = cx + hw * 1.2f;
    view[1] = cy - hw * 1.2f * aspect;
    view[3] = cy + hw * 1.2f * aspect;
  } 
  else 
  {
    aspect = (float)width / (float)height;
    view[0] = cx - hh * 1.2f * aspect;
    view[2] = cx + hh * 1.2f * aspect;
    view[1] = cy - hh * 1.2f;
    view[3] = cy + hh * 1.2f;
  }
  // Size of one pixel.
  px = (view[2] - view[1]) / (float)width;

  // Draw bounds
  g_VectorTest.SetColor(RgbColor(0,0,0,64));
  g_VectorTest.Start(VectorGraphics::type_LineLoops);
  g_VectorTest.AddPoint(0, 0);
  g_VectorTest.AddPoint(svgImage->width, 0);
  g_VectorTest.AddPoint(svgImage->width, svgImage->height);
  g_VectorTest.AddPoint(0, svgImage->height);
  g_VectorTest.End();

  for (shape = svgImage->shapes; shape != NULL; shape = shape->next)
  {
    for (path = shape->paths; path != NULL; path = path->next) 
    {
      drawPath(path->pts, path->npts, path->closed, px * 1.5f);
      drawControlPts(path->pts, path->npts);
    }
  }
  nsvgDelete(svgImage);
  return true;
}


