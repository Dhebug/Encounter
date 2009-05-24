
#pragma warning(disable : 4786)

#include <map>


struct FIBITMAP;


class CHires
{
public:
	typedef enum 
	{
		FORMAT_MONOCHROM,
		FORMAT_COLORED,
		FORMAT_RGB,
		FORMAT_TWILIGHTE_MASK,
		FORMAT_RB,
		FORMAT_TRUETEXT,
		FORMAT_SHIFTER,
		_FORMAT_MAX_
	}FORMAT;

	typedef enum
	{
		DITHER_NONE,
		DITHER_ALTERNATE,
		DITHER_ORDERED,
		DITHER_RIEMERSMA,
		DITHER_FLOYD,
		DITHER_ALTERNATE_INVERSED,
		_DITHER_MAX_
	}DITHER;

	typedef enum
	{
		MACHINE_ORIC,
		MACHINE_ATARIST,
		_MACHINE_MAX_
	}MACHINE;



public:
	CHires();
	~CHires();

	FORMAT get_format()					{ return m_format; }
	void set_format(FORMAT format)		{ m_format=format; }

	DITHER get_dither()					{ return m_dither; }
	void set_dither(DITHER dither)		{ m_dither=dither; }

	MACHINE get_machine()				{ return m_machine; }
	void set_machine(MACHINE machine)	{ m_machine=machine; }

	bool get_bit6()						{ return m_flag_setbit6; }
	void set_bit6(bool flag_value)		{ m_flag_setbit6=flag_value; }

	void clear_screen();

	void snapshot(FIBITMAP *dib);

	void convert(FIBITMAP *dib);
	void convert_monochrom(FIBITMAP *dib);
	void convert_colored(FIBITMAP *dib);
	void convert_rgb(FIBITMAP *dib);
	void convert_rb(FIBITMAP *dib);
	void convert_shifter(FIBITMAP *dib);
	void convert_twilighte_mask(FIBITMAP *dib);

	ORIC_COLOR	convert_pixel_monochrom(FIBITMAP *dib,int x,int y);
	ORIC_COLOR	convert_pixel_rgb(FIBITMAP *dib,int x,int y);
	ORIC_COLOR	convert_pixel_rb(FIBITMAP *dib,int x,int y);
	int			convert_pixel_shifter(FIBITMAP *dib,int x,int y);

	int get_shifter_color(int r,int g,int b);

	void write_pixel_rgb(FIBITMAP *dib,int x,int y,ORIC_COLOR color);

	void save(long handle);
	void save_header(long handle,int adress_begin);
	void save_clut(long handle);

	unsigned char *get_buffer_data()	{ return m_buffer; }
	unsigned int get_buffer_size()		{ return m_buffer_size; }

	int get_buffer_width()		{ return m_buffer_width; }
	int get_buffer_height()		{ return m_buffer_height; }

	void set_buffer_size(int width,int height);

	void set_debug(bool flag_debug)
		{m_flag_debug=flag_debug;}

private:
	unsigned char	*m_buffer;
	FORMAT			m_format;
	DITHER			m_dither;
	MACHINE			m_machine;

	bool			m_flag_debug;
	bool			m_flag_setbit6;

	int				m_buffer_size;
	int				m_buffer_width;
	int				m_buffer_height;
	int				m_buffer_cols;

	std::map<int,int>	m_clut;
};
