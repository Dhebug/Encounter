@ECHO OFF
::CMD /V:ON /C

:: CMD.EXE is REALLY REALLY screwed up
:: we want delayed expansion
:: BUT, doing so we can't use exclamation mark anymore in IF conditionals...
SET TEST=test
IF NOT "!TEST!" == "%TEST%" (
	ECHO "ERROR: MUST be run with CMD /v:on !"
	EXIT 1
)

SET SRCFILE=%OSDK%\make\makefile
SET MFILE=makefile

::
:: Check existing makefile
::

IF EXIST makefile (
	RENAME makefile makefile.old
	SET SRCFILE=makefile.old
	ECHO Editing existing makefile...
) ELSE IF EXIST osdk_config.bat (
	ECHO Found osdk_config.bat, using it for default values...
	call osdk_config.bat
	SET OSDKADDR=!OSDKADDR:$=!
)


::
:: Set the build paremeters
::
REM SET /P OSDKNAME=Binary name (no ext, no space) ? 
REM SET /P OSDKTYPE=Binary type (TAPE (default) or DISK) ? 
REM SET /P OSDKADDR=Load address (defaults to 600) ? 
REM SET /P OSDKFILE=Files to compile (no ext) ? 

DEL /F %MFILE% >NUL 2>NUL
SET STOP=0

FOR /F "tokens=* " %%l in (%SRCFILE%) do (
	::echo %%l
	SET LINE=%%l
	IF "!LINE:~0,5!" == "NAME=" (
		SET PREVIOUS=!LINE:~5!
		IF "!PREVIOUS!" == "" SET PREVIOUS=!OSDKNAME!
		SET /P OSDKNAME=Binary name {no ext, no space, previous: '!PREVIOUS!'} ? 
		IF NOT "!OSDKNAME!" == "" SET LINE=NAME=!OSDKNAME!
		IF "!OSDKNAME!" == "" SET LINE=NAME=!PREVIOUS!
	)
	IF "!LINE:~0,5!" == "TYPE=" (
		SET PREVIOUS=!LINE:~5!
		SET /P OSDKTYPE=Binary type {TAPE {default}, DISK, previous: '!PREVIOUS!'} ? 
		IF "!OSDKTYPE!" == "TAPE" SET LINE=TYPE=!OSDKTYPE!
		IF "!OSDKTYPE!" == "DISK" SET LINE=TYPE=!OSDKTYPE!
		IF "!OSDKTYPE!" == "" SET LINE=TYPE=!PREVIOUS!
	)
	IF "!LINE:~0,5!" == "ADDR=" (
		SET PREVIOUS=!LINE:~5!
		IF "!PREVIOUS!" == "" SET PREVIOUS=!OSDKADDR!
		SET /P OSDKADDR=Load address {defaults to 600, previous: '!PREVIOUS!'} ? 
		IF NOT "!OSDKADDR!" == "" (
			SET LINE=ADDR=!OSDKADDR!
		) ELSE IF NOT "!PREVIOUS!" == "" (
			SET LINE=ADDR=!PREVIOUS!
		) ELSE SET LINE=ADDR=600
	)
	IF "!LINE:~0,6!" == "FILES=" (
		SET PREVIOUS=!LINE:~6!
		IF "!PREVIOUS!" == "" SET PREVIOUS=!OSDKFILE!
		SET /P OSDKFILE=Files to compile {no ext, previous: '!PREVIOUS!'} ? 
		IF NOT "!OSDKFILE!" == "" (
			SET LINE=FILES=!OSDKFILE!
		) ELSE IF NOT "!PREVIOUS!" == "" (
			SET LINE=FILES=!PREVIOUS!
		) ELSE (
			ECHO Generating file list from current folder...
			FOR %%f in (*.c *.s *.asm) DO (
				SET FILE=%%f
				SET FILE=!FILE:.c=!
				SET FILE=!FILE:.s=!
				SET FILE=!FILE:.asm=!
				SET OSDKFILE=!OSDKFILE! !FILE!
			)
			SET LINE=FILES=!OSDKFILE!
		)
	)
	IF "!LINE:~0,8!" == "DEFINES=" (
		SET /P OSDKDEFS=Extra defines for the compiler {optional, previous: '!LINE:~8!'} ? 
		IF NOT "!OSDKDEFS!" == "" SET LINE=DEFINES=!OSDKDEFS!
	)
	IF "!LINE:~0,8!" == "# MAGIC:" SET STOP=1
	IF "!STOP!" == "0" ECHO !LINE!>> %MFILE%
)

:: CMD.EXE is REALLY REALLY SICK...
:: the FOR construct above fails to include the exclamation mark in the variable
:: so we must cut the rest to include it properly in the output...
FOR /F "usebackq delims=: " %%l in (`FINDSTR /N MAGIC: %SRCFILE%`) do (
	SET /A LN=%%l-1
	more +!LN! %SRCFILE% >> %MFILE%
)

IF EXIST makefile.old DEL makefile.old
