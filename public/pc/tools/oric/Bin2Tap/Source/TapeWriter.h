//-------------------------------------------------------------------------------------------------
// TapeWriter.h

#pragma once

//-------------------------------------------------------------------------------------------------
// >>>>> [ Includes ]

#include "Bin2Tap.h"


class CTapeWriter
{
	private:
	public:
												CTapeWriter( void);
												~CTapeWriter( void);

	bool										Open( LPCTSTR filename);
	void										Close( void);

	void										WriteByte( byte value);

	private:
	CFile									*	m_OutputFile;
};
