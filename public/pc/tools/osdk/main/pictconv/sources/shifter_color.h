#ifndef SHIFTER_COLOR_H
#define SHIFTER_COLOR_H

class RgbColor;

class ShifterColor
{
public:
	ShifterColor();
	ShifterColor(int r,int g,int b);
	ShifterColor(RgbColor rgb);

	unsigned short GetValue()  const { return m_color; }
	unsigned short GetBigEndianValue()  const;
	RgbColor GetRgb() const;

	static unsigned char ValueToSte(unsigned char value);
	static unsigned char ValueFromSte(unsigned char value);

	int ComputeDifference(const ShifterColor& otherColor) const;

	bool operator< ( const ShifterColor& rhs ) const { return m_color < rhs.m_color; }
	bool operator== ( const ShifterColor& rhs ) const { return m_color == rhs.m_color; }

private:
	unsigned short	m_color;
};


#endif
