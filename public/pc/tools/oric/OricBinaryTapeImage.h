#pragma once

#include "PulseWaveWriter.h"
#include "TapeWriter.h"

class COricBinaryTapeImage
{
	struct STapeHeader
	{
		unsigned char m_FirstZero;	// Should be zero
		unsigned char m_SecondZero;	// Should be zero

		unsigned char m_Type;		// 0x00 = basic, 0x80 = assembly

		unsigned char m_AutoStart;	// 0x00 = No Autostart, 0x80 = Basic Autostart or $C7 = Assembly Autostart

		unsigned char m_HighEnd;
		unsigned char m_LowEnd;

		unsigned char m_HighStart;
		unsigned char m_LowStart;

		unsigned char m_ThirdZero;
	};

public:
	COricBinaryTapeImage(void);
	~COricBinaryTapeImage(void);

	bool										LoadBinary( CString filename);
	bool										WriteWave( CPulseWaveWriter *wave_writer) const;
	bool										WriteTape( CTapeWriter *tape_writer) const;

	void										SetAutoStart( bool value) { m_Header.m_AutoStart = value ? 0xc7 : 0x00; }

private:
	void										WritePair( CPulseWaveWriter *wave_writer, bool long_pulse) const;
	void										WriteByte( CPulseWaveWriter *wave_writer, byte out_byte) const;
	void										WriteByte( CTapeWriter *tape_writer, byte out_byte) const;

	private:
	STapeHeader									m_Header;
	CString										m_OricFilename;
	byte									*	m_Buffer;
	DWORD										m_BufferLength;
};
