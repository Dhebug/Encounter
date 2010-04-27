//-------------------------------------------------------------------------------------------------
// PulseWaveWriter.h

#pragma once

//-------------------------------------------------------------------------------------------------
// >>>>> [ Includes ]

#include "Bin2Tap.h"


class CPulseWaveWriter
{
	private:
	struct SChunkHeader
	{
		DWORD									m_ID;
		DWORD									m_Length;
	};

	struct SWaveHeader
	{
		SChunkHeader							m_FileHeader;
		DWORD									m_Format;
	};

	struct SWaveFormat
	{
		SChunkHeader							m_FileHeader;
		short									m_AudioFormat;
		short									m_NumChannels;
		DWORD									m_SampleRate;
		DWORD									m_ByteRate;
		short									m_BlockAlign;
		short									m_BitsPerSample;
	};

	public:
												CPulseWaveWriter( EBitFormat format, ESampleRate rate);
												~CPulseWaveWriter( void);

	bool										Open( LPCTSTR filename);
	void										Close( void);

	void										WritePulse( bool long_pulse);
	void										WriteBlank( float time);

	private:
	CFile									*	m_OutputFile;

	bool										m_ReallyClose;

	int											m_BitDepth;
	int											m_Rate;
	int											m_ShortPulseLength;
	int											m_LongPulseLength;
	int											m_NegativeEdge;
	int											m_NeuteralEdge;
	int											m_PositiveEdge;

	int											m_DataLengthOffset;

	bool										m_PositivePulse;
};
