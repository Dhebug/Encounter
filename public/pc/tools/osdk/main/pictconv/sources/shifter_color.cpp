

#include <assert.h>
#include <cstdio>
#include <cstdlib>
#include <cmath>

#include "FreeImage.h"

#include "defines.h"
#include "getpixel.h"

#include "hires.h"
#include "shifter_color.h"

// ============================================================================
//
//		                             ShifterColor
//
// ============================================================================

ShifterColor::ShifterColor() :
	m_color(0)
{
}

ShifterColor::ShifterColor(int r,int g,int b)
{
	r=(r>>5)+((r>>1)&8);
	g=(g>>5)+((g>>1)&8);
	b=(b>>5)+((b>>1)&8);

	m_color=((r&15)<<8)|((g&15)<<4)|(b&15);
}

ShifterColor::ShifterColor(RgbColor rgb)
{
	unsigned char red  =(rgb.m_red*15)/255;
	unsigned char green=(rgb.m_green*15)/255;
	unsigned char blue =(rgb.m_blue*15)/255;

	m_color=(ValueToSte(red)<<8) | (ValueToSte(green)<<4) | (ValueToSte(blue)<<0);
}

unsigned short ShifterColor::GetBigEndianValue() const
{
	unsigned short color=((m_color&255)<<8) | ((m_color>>8)&255);
	return color;
}

RgbColor ShifterColor::GetRgb() const
{
	//unsigned short r=m_color
	RgbColor rgb;
	rgb.m_red  =(255*ValueFromSte((m_color>>8)&15))/15;
	rgb.m_green=(255*ValueFromSte((m_color>>4)&15))/15;
	rgb.m_blue =(255*ValueFromSte((m_color>>0)&15))/15;
	return rgb;
}

int ShifterColor::ComputeDifference(const ShifterColor& otherColor) const
{
	int delta_red  =std::abs(ValueFromSte((m_color>>8)&15)-ValueFromSte((otherColor.m_color>>8)&15));
	int delta_green=std::abs(ValueFromSte((m_color>>4)&15)-ValueFromSte((otherColor.m_color>>4)&15));
	int delta_blue =std::abs(ValueFromSte((m_color>>0)&15)-ValueFromSte((otherColor.m_color>>0)&15));
	return (delta_red*delta_red)+(delta_green*delta_green)+(delta_blue*delta_blue);
}


// static 
unsigned char ShifterColor::ValueToSte(unsigned char value)
{
	unsigned char dest=((value&15)>>1) | ((value&1)<<3);
	return dest;
}

// static 
unsigned char ShifterColor::ValueFromSte(unsigned char value)
{
	unsigned char dest=((value&7)<<1) | ((value&8)>>3);
	return dest;
}


