#ifndef PICTURE_CONVERTER_H
#define PICTURE_CONVERTER_H

#include <map>

class TextFileGenerator;
class ImageContainer;

class PictureConverter
{
public:
	enum MACHINE
	{
		MACHINE_ORIC,
		MACHINE_ATARIST,
		_MACHINE_MAX_
	};

	enum DITHER
	{
		DITHER_NONE,
		DITHER_ALTERNATE,
		DITHER_ORDERED,
		DITHER_RIEMERSMA,
		DITHER_FLOYD,
		DITHER_ALTERNATE_INVERSED,
		_DITHER_MAX_
	};

public:
	static PictureConverter* GetConverter(MACHINE machine);
	static void DeleteConverter(PictureConverter* pConverter);

	MACHINE GetMachine() const			{ return m_machine; }
	void SetDebug(bool flag_debug)		{ m_flag_debug=flag_debug; }

	DITHER GetDither() const 			{ return m_dither; }
	void SetDither(DITHER dither);

	virtual int GetFormat() const=0;
	virtual bool SetFormat(int format)=0;

	virtual int GetPaletteMode() const=0;
	virtual bool SetPaletteMode(int paletteMode)=0;

	virtual bool Convert(const ImageContainer& sourcePicture)=0;
	virtual bool TakeSnapShot(ImageContainer& sourcePicture)=0;

	virtual bool Save(int output_format,const std::string& output_filename,TextFileGenerator& cTextFileGenerator);

	virtual void SaveToFile(long handle,int output_format)=0;

	virtual unsigned char *GetBufferData()=0;
	virtual unsigned int GetBufferSize()=0;

protected:
	PictureConverter(MACHINE machine);
	PictureConverter();		// N/A
	virtual ~PictureConverter();

protected:
	MACHINE			m_machine;
	DITHER			m_dither;
	bool			m_flag_debug;
};

#endif
