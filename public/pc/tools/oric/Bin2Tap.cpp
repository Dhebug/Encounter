// o65ToWav.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "Bin2Tap.h"
#include "CommandLine.h"
#include "OricBinaryTapeImage.h"
#include "PulseWaveWriter.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#endif


// The one and only application object

CWinApp theApp;

using namespace std;

int _tmain(int argc, TCHAR* argv[], TCHAR* envp[])
{
	int nRetCode = 0;

	// initialize MFC and print and error on failure
	if (!AfxWinInit(::GetModuleHandle(NULL), NULL, ::GetCommandLine(), 0))
	{
		// TODO: change error code to suit your needs
		_tprintf(_T("Fatal Error: MFC initialization failed\n"));
		nRetCode = 1;
	}
	else
	{
		CCommandLine cmd_line;
		if ( cmd_line.Parse( argc, argv))
		{
			COricBinaryTapeImage oric_tape;

			if ( !oric_tape.LoadBinary( cmd_line.GetInputName()))
			{
				_tprintf(_T("Unable to open input binary file\n"));
				return 1;
			}

			oric_tape.SetAutoStart( cmd_line.GetAutoRun());

			if ( cmd_line.GetTapeExport())
			{
				CTapeWriter p;

				if ( !p.Open( cmd_line.GetOutputName()))
				{
					_tprintf(_T("Unable to open output wav file\n"));
					return 1;
				}

				oric_tape.WriteTape( &p);

				p.Close();
			}
			else
			{
				CPulseWaveWriter p( cmd_line.GetBitFormat(), cmd_line.GetSampleRate());

				if ( !p.Open( cmd_line.GetOutputName()))
				{
					_tprintf(_T("Unable to open output wav file\n"));
					return 1;
				}

				oric_tape.WriteWave( &p);

				p.Close();
			}
		}
	}

	return nRetCode;
}
