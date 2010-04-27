//-------------------------------------------------------------------------------------------------
// CommandLine.h

#pragma once


//-------------------------------------------------------------------------------------------------
// >>>>> [ Includes ]

#include "Bin2Tap.h"


//-------------------------------------------------------------------------------------------------
// >>>>> [ Class ]

class CCommandLine
{
	public:
												CCommandLine(void);
												~CCommandLine(void);

	void										Usage( void);
	bool										Parse( int argc, TCHAR* argv[]);

	LPCTSTR										GetInputName( void) const { return m_InputName; }
	LPCTSTR										GetOutputName( void) const { return m_OutputName.IsEmpty() ? NULL : (LPCTSTR)m_OutputName; }

	EBitFormat									GetBitFormat( void) const { return m_BitFormat; }
	ESampleRate									GetSampleRate( void) const { return m_SampleRate; }

	bool										GetAutoRun( void) const { return m_AutoRun; }
	bool										GetTapeExport( void) const { return m_TapeExport; }

	// Variables
	private:
	CString										m_InputName;
	CString										m_OutputName;
	
	EBitFormat									m_BitFormat;
	ESampleRate									m_SampleRate;

	bool										m_AutoRun;
	bool										m_TapeExport;
};

//-------------------------------------------------------------------------------------------------
// >>>>> [ End ]
