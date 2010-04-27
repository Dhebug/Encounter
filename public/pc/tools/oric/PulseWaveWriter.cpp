#include "StdAfx.h"
#include "PulseWaveWriter.h"
#include "mmsystem.h"

#define MAKEFOURCC(ch0, ch1, ch2, ch3)                              \
                ((DWORD)(BYTE)(ch0) | ((DWORD)(BYTE)(ch1) << 8) |   \
                ((DWORD)(BYTE)(ch2) << 16) | ((DWORD)(BYTE)(ch3) << 24 ))

CPulseWaveWriter::CPulseWaveWriter(EBitFormat format, ESampleRate rate)
{
	switch ( format)
	{
	case eBF_8Bit:
		m_BitDepth = 8;
		m_NegativeEdge = 0;
		m_NeuteralEdge = 128;
		m_PositiveEdge = 255;
		break;

	case eBF_16Bit:
		m_BitDepth = 16;
		m_NegativeEdge = -32768;
		m_NeuteralEdge = 0;
		m_PositiveEdge = 32767;
		break;
	}

	switch ( rate)
	{
	case eSR_4800:
		m_Rate = 4800;
		m_ShortPulseLength = 1;
		m_LongPulseLength = 2;
		break;

	case eSR_10000:
		m_Rate = 10000;
		m_ShortPulseLength = 2;
		m_LongPulseLength = 4;
		break;

	case eSR_44100:
		m_Rate = 44100;
		m_ShortPulseLength = 10;
		m_LongPulseLength = 20;
		break;

	case eSR_48000:
		m_Rate = 48000;
		m_ShortPulseLength = 10;
		m_LongPulseLength = 20;
		break;
	}

	m_OutputFile = NULL;
}

CPulseWaveWriter::~CPulseWaveWriter(void)
{
	delete m_OutputFile;
}

bool CPulseWaveWriter::Open( LPCTSTR filename)
{
	try
	{
		if ( filename != NULL)
		{
			m_OutputFile = new CFile();
			if ( !m_OutputFile->Open( filename, CFile::modeWrite | CFile::modeCreate))
			{
				return false;
			}
			m_ReallyClose = true;
		}
		else
		{
			m_OutputFile = new CMemFile();
			m_ReallyClose = false;
		}

		SWaveHeader header;
		header.m_FileHeader.m_ID = MAKEFOURCC('R', 'I', 'F', 'F');
		header.m_FileHeader.m_Length = 0;
		header.m_Format = MAKEFOURCC('W', 'A', 'V', 'E');

		m_OutputFile->Write( &header, sizeof(header));

		SWaveFormat format;
		format.m_FileHeader.m_ID = MAKEFOURCC('f', 'm', 't', ' ');
		format.m_FileHeader.m_Length = 16;
		format.m_AudioFormat = 1;
		format.m_NumChannels = 1;
		format.m_SampleRate = m_Rate;
		format.m_BlockAlign = (m_BitDepth / 8);
		format.m_ByteRate = m_Rate * format.m_BlockAlign;
		format.m_BitsPerSample = m_BitDepth;

		m_OutputFile->Write( &format, sizeof(format));

		SChunkHeader data_header;
		data_header.m_ID = MAKEFOURCC('d', 'a', 't', 'a');
		data_header.m_Length = 0;

		m_OutputFile->Write( &data_header, sizeof(data_header));
		m_DataLengthOffset = (int)m_OutputFile->GetPosition() - 4;

		m_PositivePulse = true;
	}
	catch ( CFileException /* e */)
	{
		return false;
	}

	return true;
}

void CPulseWaveWriter::Close( void)
{
	DWORD length = (DWORD)m_OutputFile->GetPosition();
	m_OutputFile->Seek( m_DataLengthOffset, CFile::begin);
	DWORD size = (length - m_DataLengthOffset) - 4;
	m_OutputFile->Write( &size, sizeof(size));

	m_OutputFile->Seek( 4, CFile::begin);
	size = length - 8;
	m_OutputFile->Write( &size, sizeof(size));

	if ( m_ReallyClose)
	{
		m_OutputFile->Close();
	}
	else
	{
		byte *buffer = new byte[(int)m_OutputFile->GetLength()];
		m_OutputFile->SeekToBegin();
		m_OutputFile->Read( buffer, (int)m_OutputFile->GetLength());
		PlaySound( (LPCWSTR)buffer, 0, SND_MEMORY | SND_SYNC);
		delete buffer;
	}
}

void CPulseWaveWriter::WritePulse( bool long_pulse)
{
	int length = long_pulse ? m_LongPulseLength : m_ShortPulseLength;

	if ( m_BitDepth == 8)
	{
		byte value = m_PositivePulse ? m_PositiveEdge : m_NegativeEdge;
		for ( int i = 0; i < length; i++)
		{
			m_OutputFile->Write( &value, sizeof(value));
		}
	}
	else
	{
		short value = m_PositivePulse ? m_PositiveEdge : m_NegativeEdge;
		for ( int i = 0; i < length; i++)
		{
			m_OutputFile->Write( &value, sizeof(value));
		}
	}

	m_PositivePulse = !m_PositivePulse;
}

void CPulseWaveWriter::WriteBlank( float time)
{
	int pulses = (int)((float)m_Rate * time);

	if ( m_BitDepth == 8)
	{
		byte value = m_NeuteralEdge;
		for ( int i = 0; i < pulses; i++)
		{
			m_OutputFile->Write( &value, sizeof(value));
		}
	}
	else
	{
		short value = m_NeuteralEdge;
		for ( int i = 0; i < pulses; i++)
		{
			m_OutputFile->Write( &value, sizeof(value));
		}
	}
}