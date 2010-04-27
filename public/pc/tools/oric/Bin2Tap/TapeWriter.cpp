#include "StdAfx.h"
#include "TapeWriter.h"
#include "mmsystem.h"

#define MAKEFOURCC(ch0, ch1, ch2, ch3)                              \
                ((DWORD)(BYTE)(ch0) | ((DWORD)(BYTE)(ch1) << 8) |   \
                ((DWORD)(BYTE)(ch2) << 16) | ((DWORD)(BYTE)(ch3) << 24 ))

CTapeWriter::CTapeWriter( void)
{
	m_OutputFile = NULL;
}

CTapeWriter::~CTapeWriter(void)
{
	delete m_OutputFile;
}

bool CTapeWriter::Open( LPCTSTR filename)
{
	try
	{
		m_OutputFile = new CFile();
		if ( !m_OutputFile->Open( filename, CFile::modeWrite | CFile::modeCreate))
		{
			return false;
		}
	}
	catch ( CFileException /* e */)
	{
		return false;
	}

	return true;
}

void CTapeWriter::Close( void)
{
	m_OutputFile->Close();
	delete m_OutputFile;
	m_OutputFile = NULL;
}

void CTapeWriter::WriteByte( byte value)
{
	m_OutputFile->Write( &value, sizeof(value));
}
