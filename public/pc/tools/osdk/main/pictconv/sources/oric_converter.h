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

class OricPictureConverter : public PictureConverter
{
	friend class PictureConverter;

public:
	enum FORMAT
	{
		FORMAT_MONOCHROM,
		FORMAT_COLORED,
		FORMAT_RGB,
		FORMAT_TWILIGHTE_MASK,
		FORMAT_RB,
		FORMAT_TRUETEXT,
		_FORMAT_MAX_
	};

public:
	virtual int GetFormat() const					{ return (int)m_format; }
	virtual bool SetFormat(int format)				{ m_format=(FORMAT)format;return m_format<_FORMAT_MAX_; }

	virtual int GetPaletteMode() const				{ return 0; }
	virtual bool SetPaletteMode(int paletteMode)	{ return paletteMode==0; }

	virtual bool Convert(const ImageContainer& sourcePicture);
	virtual bool TakeSnapShot(ImageContainer& sourcePicture);

	virtual void SaveToFile(long handle,int output_format);

	bool get_bit6()						{ return m_flag_setbit6; }
	void set_bit6(bool flag_value)		{ m_flag_setbit6=flag_value; }

	void clear_screen();

	void convert_monochrom(const ImageContainer& sourcePicture);
	void convert_colored(const ImageContainer& sourcePicture);
	void convert_rgb(const ImageContainer& sourcePicture);
	void convert_rb(const ImageContainer& sourcePicture);
	void convert_twilighte_mask(const ImageContainer& sourcePicture);

	ORIC_COLOR convert_pixel_monochrom(const ImageContainer& sourcePicture,unsigned int x,unsigned int y);
	ORIC_COLOR convert_pixel_rgb(const ImageContainer& sourcePicture,unsigned int x,unsigned int y);
	ORIC_COLOR convert_pixel_rb(const ImageContainer& sourcePicture,unsigned int x,unsigned int y);

	void save_header(long handle,int adress_begin);

	virtual unsigned char *GetBufferData()	{ return m_buffer; }
	virtual unsigned int GetBufferSize()	{ return m_buffer_size; }

	unsigned int get_buffer_width()			{ return m_buffer_width; }
	unsigned int get_buffer_height()		{ return m_buffer_height; }

	void set_buffer_size(int width,int height);

protected:
	OricPictureConverter();
	virtual ~OricPictureConverter();

private:
	unsigned char	*m_buffer;
	FORMAT			m_format;

	bool			m_flag_setbit6;

	unsigned int	m_buffer_size;
	unsigned int	m_buffer_width;
	unsigned int	m_buffer_height;
	int				m_buffer_cols;
};

#endif
