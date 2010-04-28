#include "StdAfx.h"
#include "CommandLine.h"

CCommandLine::CCommandLine(void)
{
	m_BitFormat = eBF_8Bit;
	m_SampleRate = eSR_10000;
	m_AutoRun = false;
	m_TapeExport = false;
}

CCommandLine::~CCommandLine(void)
{
}

void CCommandLine::Usage( void)
{
	_tprintf(_T("Bin2Wav V1.0a by Paul Carpenter (Vampire^TZT)\n"));
	_tprintf(_T("Usage:\n"));
	_tprintf(_T("  Bin2Wav [-a] [-w] [-8bit|-16bit] [-4k|-9K|-44k|-48k] [-o <outname>] <o68file>\n\n"));
	_tprintf(_T("  -a                 - Enable binary autorun\n\n"));
	_tprintf(_T("  -w                 - Output a .WAV (8bit,10k)\n\n"));
	_tprintf(_T("  -8bit|-16bit       - Select a bit depth (implies -w)\n\n"));
	_tprintf(_T("  -4k|-10K|-44k|-48k - Select a wave frequency (implies -w)\n\n"));
	_tprintf(_T("  -o <filename>      - Specify an output filename\n\n"));
}

bool CCommandLine::Parse( int argc, TCHAR* argv[])
{
	CStringArray args;

	bool args_good = true;

	// We default to tape now unless a wave switch is added
	m_TapeExport = true;

	for ( int i = 1; i < argc; i++)
	{
		if ( argv[i][0] == '-' ||
			 argv[i][0] == '/')
		{
			if ( CString(argv[i]).CompareNoCase( _T("-a")) == 0)
			{
				m_AutoRun = true;
			}
			else if ( CString(argv[i]).CompareNoCase( _T("-w")) == 0)
			{
				m_TapeExport = false;
			}
			else if ( CString(argv[i]).CompareNoCase( _T("-8bit")) == 0)
			{
				m_BitFormat = eBF_8Bit;
				m_TapeExport = false;
			}
			else if ( CString(argv[i]).CompareNoCase( _T("-16bit")) == 0)
			{
				m_BitFormat = eBF_16Bit;
				m_TapeExport = false;
			}
			else if ( CString(argv[i]).CompareNoCase( _T("-4k")) == 0)
			{
				m_SampleRate = eSR_4800;
				m_TapeExport = false;
			}
			else if ( CString(argv[i]).CompareNoCase( _T("-10k")) == 0)
			{
				m_SampleRate = eSR_10000;
				m_TapeExport = false;
			}
			else if ( CString(argv[i]).CompareNoCase( _T("-44k")) == 0)
			{
				m_SampleRate = eSR_44100;
				m_TapeExport = false;
			}
			else if ( CString(argv[i]).CompareNoCase( _T("-48k")) == 0)
			{
				m_SampleRate = eSR_48000;
				m_TapeExport = false;
			}
			else if ( CString(argv[i]).CompareNoCase( _T("-o")) == 0)
			{
				i++;
				if ( i == argc)
				{
					args_good = false;
					break;
				}
				m_OutputName = argv[i];
			}
			else
			{
				args_good = false;
				break;
			}
		}
		else
		{
			args.Add( argv[i]);
		}
	}

	if ( args.GetCount() != 1 || !args_good)
	{
		Usage();

		return false;
	}

	m_InputName = args[0];

	return true;
}

