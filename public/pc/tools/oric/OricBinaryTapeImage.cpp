#include "StdAfx.h"
#include "OricBinaryTapeImage.h"

COricBinaryTapeImage::COricBinaryTapeImage(void)
{
	m_Buffer = NULL;

	// Create the header
	memset( &m_Header, 0, sizeof(m_Header));
	m_Header.m_Type = 0x80;
	m_Header.m_AutoStart = 0x00;

	m_OricFilename = "MCODE";
}

COricBinaryTapeImage::~COricBinaryTapeImage(void)
{
	delete [] m_Buffer;
}

bool COricBinaryTapeImage::LoadBinary( CString filename)
{
	CFile binary_file;

	if ( !binary_file.Open( filename, CFile::modeRead))
	{
		return false;
	}

	// Calculate the buffer length
	m_BufferLength = (int)binary_file.GetLength() - 2;
	m_Buffer = new byte[m_BufferLength];

	// Get the load and end addresses
	unsigned short org_address;
	binary_file.Read( &org_address, 2);
	int end = (org_address + m_BufferLength) - 1;

	// Create the header
	m_Header.m_LowStart = org_address & 0xff;
	m_Header.m_HighStart = org_address >> 8;
	m_Header.m_LowEnd = end & 0xff;
	m_Header.m_HighEnd = end >> 8;

	binary_file.Read( m_Buffer, m_BufferLength);

	binary_file.Close();

	return true;
}

bool COricBinaryTapeImage::WriteWave( CPulseWaveWriter *wave_writer) const
{
	int i;

	wave_writer->WriteBlank( 0.5f);

	for ( i = 0; i < 16; i++)
	{
		WriteByte( wave_writer, 0x16);
	}
	WriteByte( wave_writer, 0x24);

	byte *out_pointer = (byte *)&m_Header;
	for ( i = 0; i < sizeof(m_Header); i++)
	{
		WriteByte( wave_writer, *(out_pointer++));
	}

	int l = m_OricFilename.GetLength();
	char* ascii = new char[l + 1];
	wcstombs_s(NULL, ascii, l + 1, (LPCTSTR)m_OricFilename, l );

	out_pointer = (byte *)ascii;
	for ( i = 0; i <= m_OricFilename.GetLength(); i++)
	{
		WriteByte( wave_writer, *(out_pointer++));
	}

	delete [] ascii;

	for ( int i = 0; i < 10; i++)
	{
		wave_writer->WritePulse( false);
	}

	out_pointer = (byte *)m_Buffer;
	for ( i = 0; i < (int)m_BufferLength; i++)
	{
		WriteByte( wave_writer, *(out_pointer++));
	}

	wave_writer->WriteBlank( 0.5f);

	return true;
}

bool COricBinaryTapeImage::WriteTape( CTapeWriter *tape_writer) const
{
	int i;

	WriteByte( tape_writer, 0x16);
	WriteByte( tape_writer, 0x24);

	byte *out_pointer = (byte *)&m_Header;
	for ( i = 0; i < sizeof(m_Header); i++)
	{
		WriteByte( tape_writer, *(out_pointer++));
	}

	int l = m_OricFilename.GetLength();
	char* ascii = new char[l + 1];
	wcstombs_s(NULL, ascii, l + 1, (LPCTSTR)m_OricFilename, l );

	out_pointer = (byte *)ascii;
	for ( i = 0; i <= m_OricFilename.GetLength(); i++)
	{
		WriteByte( tape_writer, *(out_pointer++));
	}

	delete [] ascii;

	out_pointer = (byte *)m_Buffer;
	for ( i = 0; i < (int)m_BufferLength; i++)
	{
		WriteByte( tape_writer, *(out_pointer++));
	}

	return true;
}

void COricBinaryTapeImage::WritePair( CPulseWaveWriter *wave_writer, bool long_pulse) const
{
	wave_writer->WritePulse( false);
	wave_writer->WritePulse( long_pulse);
}

void COricBinaryTapeImage::WriteByte( CPulseWaveWriter *wave_writer, byte out_byte) const
{
	// Push the start bit
	WritePair( wave_writer, true);

	unsigned char crc = 1;
	for ( int i = 0; i < 8; i++)
	{
		unsigned char bit = out_byte & 1;
		out_byte >>= 1;
		WritePair( wave_writer, bit == 0);
		crc ^= bit;
	}

	WritePair( wave_writer, crc == 0);

	for ( int i = 0; i < 7; i++)
	{
		wave_writer->WritePulse( false);
	}
}

void COricBinaryTapeImage::WriteByte( CTapeWriter *tape_writer, byte out_byte) const
{
	tape_writer->WriteByte( out_byte);
}