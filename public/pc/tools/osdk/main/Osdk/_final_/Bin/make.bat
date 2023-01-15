@ECHO OFF
::ECHO ON
::
:: List of environment variables used by the system
::
:: Set by the user:
:: - OSDK - Points to the root folder of where the OSDK is installed, you can change it to point to other versions when doing testing
:: - OSDKNAME - Name of the program (defaults to "OSDK" if not defined)
:: - OSDKADDR - Start address of the program (defaults to $600 if not defined)
:: - OSDKCOMP - Can be used to override compiler flags such as optimization level (default to "-O2" if not defined)
:: - OSDKCPPFLAGS - To pass additional data to the C preprocessor (Currently LCC65)
:: - OSDKXAPARAMS - To pass additional data to the 6502 assembler (Currently XA and defaults to "-C -W" if not defined)
:: - OSDKTAPNAME - Name of the TAP file (defaults to "OSDK" if not defined)
:: - OSDKDISK - Name of the DSK file, if undefined, the DSK generation is skipped
:: - OSDKINIST - Sedoric initialization string ran on floppy boot
::
:: Derived from the above, or used internally
:: - OSDKVERSION - Used to show the version of the OSDK used to build a project (eg: "1.18")
:: - OSDKLIB - Set to OSDK\lib, which contains the libraries linked to the projects (used by Pinforic to point to custom libraries)
:: - OSDKB - Set to OSDK\BIN, which contains all the OSDK binary executables
:: - OSDKT - Set to OSDK\TMP, which is where the temporary build artificats are stored when building a project
:: - OSDKLINKLIST - Contains the list of all the modules the Linker will have to process during the Link phase
:: - OCC - Can't remember, possibly some very old stuff? Like "Oric C Compiler"
:: - TMP - Set to the same location as OSDKT to get any temporary written to the same location
:: - TEMP - Set to the same location as OSDKT to get any temporary written to the same location
:: - LCC65 - Set to the same location as OSDK (possibly not used anymore)
:: - LCC65DIR - Set to the same location as OSDK (possibly not used anymore)
::

::
:: Initial checks to verify that everything is fine.
::
IF "%OSDK%"=="" GOTO ErCfg
IF "%1"=="" GOTO ErNoFile

::
:: Set the default name for the final executable
:: if no name has been specified
::
IF NOT "%OSDKNAME%"=="" GOTO Name
SET OSDKNAME=OSDK
:Name

::
:: Set the default tape name for the final executable
:: if no name has been specified
::
IF NOT "%OSDKTAPNAME%"=="" GOTO TapName
SET OSDKTAPNAME=OSDK
:TapName

::
:: Set the default assembly adress
:: if no adress has been specified
::
IF NOT "%OSDKADDR%"=="" GOTO Adress
SET OSDKADDR=$600
:Adress

::
:: Set the optimize level to 2
:: if no level has been specified
::
IF NOT "%OSDKCOMP%"=="" GOTO Comp
SET OSDKCOMP=-O2
:Comp

::
:: Set XA to disable 65C02 and 65816 instructions by default
:: if the user did not specify anything else
::
IF NOT "%OSDKXAPARAMS%"=="" GOTO EndXaParams
SET OSDKXAPARAMS=-W -C
:EndXaParams


::
:: Set the default path to the Oric Libraries
:: if no user defined OSDKLIB was found
::
IF NOT "%OSDKLIB%"=="" GOTO Lib
SET OSDKLIB=%OSDK%\lib/
:Lib

SET OSDKB=%OSDK%\BIN
SET OSDKT=%OSDK%\TMP
SET OSDKLINKLIST=
SET TMP=%OSDKT%
SET TEMP=%OSDKT%
SET OCC=%OSDK%
SET LCC65=%OSDK%
SET LCC65DIR=%OSDK%
SET OSDKVERSION=1.20

::
:: Create a build directory if it does not exist
:: Mike: Seems to fail creating the folder under Wine, resulting in a failed build
:: Mike: What about testing for BUILD\. instead ?
:: 
IF EXIST BUILD\NUL GOTO NoBuild
MD BUILD
:NoBuild


::
:: Make sure that temp folder is entirelly empty before attempting a new build
:: Will guarantee we do not have side effects between builds
::
::ECHO ON
RMDIR /s /q %OSDKT%\ >NUL
MD %OSDKT% >NUL
::IF EXIST %OSDKT%\NUL GOTO NoTmp
::MD %OSDKT%
:NoTmp
::ECHO OFF


::
:: Display a compilation message
:: Note: Should find a way to disable the adress display for BASIC programs... kind of lame
::
ECHO Building the program %OSDKNAME% at adress %OSDKADDR% [OSDK %OSDKVERSION%]


::
:: Delete old files.
:: This way we are sure nothing remains if the build fails
::
IF NOT EXIST BUILD\symbols GOTO NoSymbol
DEL BUILD\symbols >NUL
:NoSymbol

IF NOT EXIST BUILD\final.out GOTO NoFinal
DEL BUILD\final.out >NUL
:NoFinal

IF NOT EXIST BUILD\xaerr.txt GOTO NoError
DEL BUILD\xaerr.txt >NUL
:NoError

IF NOT EXIST BUILD\%OSDKNAME%.tap GOTO NoTape
DEL BUILD\%OSDKNAME%.tap >NUL
:NoTape

:: Delete the eventual composite BASIC file
IF NOT EXIST %OSDKT%\%OSDKNAME%.bas GOTO NoBas
DEL %OSDKT%\%OSDKNAME%.bas >NUL
:NoBas

:: Delete eventual compressed files
IF NOT EXIST BUILD\*.pak GOTO NoPak
DEL BUILD\*.pak >NUL
:NoPak

IF NOT EXIST BUILD\%OSDKPACK%.* GOTO NoPakFiles
DEL BUILD\%OSDKPACK%.* >NUL
:NoPakFiles


::
:: Create a BATCH file that will be used
:: to later link all the part of the program
::
::ECHO *=%OSDKADDR% >%OSDKT%\adress.tmp
::ECHO %OSDKB%\link65.exe %OSDKLINK% -d %OSDK%\lib/ -o %OSDKT%\linked.s -s %OSDKT%\ -f -q %1 %2 %3 %4 %5 %6 %7 %8 %9 >%OSDKT%\link.bat
::ECHO %OSDKB%\link65.exe %OSDKLINK% -d %OSDK%\lib/ -o %OSDKT%\linked.ss -s %OSDKT%\ -f -q %OSDKFILE% >%OSDKT%\link.bat
::ECHO %OSDKB%\link65.exe %OSDKLINK% -d %OSDK%\lib/ -o %OSDKT%\linked.s -s %OSDKT%\ -f -q %OSDKFILE% >%OSDKT%\link.bat


::
:: Compile/Assemble files 
:: depending of their type
::
:FileLoop
IF "%1"=="" GOTO DoneProcessingFileList

::ECHO %1 >%OSDKT%\linktemp.txt
::COPY /b %OSDKT%\link.bat+%OSDKT%\linktemp.txt %OSDKT%\link.bat
::ECHO %1 >>%OSDKT%\link.bat
 
IF EXIST "%1.C" GOTO Compile
IF EXIST "%1.S" GOTO Assemble
IF EXIST "%1.ASM" GOTO Assemble
IF EXIST "%1.BAS" GOTO Basic

::
:: Outputs a "file not found" error message
:: if the file is not a C or S file
::
ECHO == ERROR --
ECHO The file "%1" is not a C, assembly code or BASIC file (.C/.S/.BAS suffix)
ECHO You should specify the name of the files without any extension. The files have
ECHO to be all in the same level directory and should not have the same names.
ECHO -- ERROR ==
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End


:Compile
IF "%OSDKBRIEF%"=="" ECHO Compiling %1.C

IF "%OSDKBRIEF%"=="" ECHO   - preprocess
:: the -DATMOS is for Contiki
%OSDKB%\cpp.exe -lang-c++ -I %OSDK%\include %OSDKCPPFLAGS% -D__16BIT__ -D__NOFLOAT__ -DATMOS -DOSDKNAME_%OSDKNAME% -DOSDKVER=\"%OSDKVERSION%\" -nostdinc %1.c %OSDKT%\%1.c

IF "%OSDKBRIEF%"=="" ECHO   - compile
%OSDKB%\compiler.exe -N%1 %OSDKCOMP% %OSDKT%\%1.c >%OSDKT%\%1.c2
IF ERRORLEVEL 1 GOTO ErFailure

IF "%OSDKBRIEF%"=="" ECHO   - convert C to assembly code
%OSDKB%\cpp.exe -lang-c++ -imacros %OSDK%\macro\macros.h  -DXA -traditional -P %OSDKT%\%1.c2 %OSDKT%\%1.s

IF "%OSDKBRIEF%"=="" ECHO   - cleanup output
::%OSDKB%\tr < %OSDKT%\%1.s > %OSDKT%\%1
%OSDKB%\macrosplitter.exe %OSDKT%\%1.s %OSDKT%\%1
SET OSDKLINKLIST=%OSDKLINKLIST% %OSDKT%\%1
SHIFT
GOTO FileLoop


::
:: This is the sequence of instructions necessary to build an assembly code file.
:: Assembler files are just copied over in the temp folder since there is no particular
:: modifications to do. Anyway we need to make sure that the directory structure is kept
:: at the correct place.
::
:Assemble
IF "%OSDKBRIEF%"=="" ECHO Assembling %1.S

:: Create the directory structure
XCOPY /Y /T %1.S %OSDKT%\

:: Copy the file
COPY %1.S %OSDKT%\%1.s /Y >NUL
SET OSDKLINKLIST=%OSDKLINKLIST% %1.s
SHIFT
GOTO FileLoop

:Basic
IF "%OSDKBRIEF%"=="" ECHO Converting BASIC program %1.BAS

ECHO #file %1.BAS >> %OSDKT%\%OSDKNAME%.bas
TYPE %1.BAS >> %OSDKT%\%OSDKNAME%.bas

SHIFT
GOTO FileLoop



::
:: Perform final linking and binary conversion
:: of compiled files
::
:DoneProcessingFileList

:: Do we have some actual binary content
if "%OSDKLINKLIST%"=="" GOTO BasicLoader

:Link
::
:: Create a BATCH file that will be used
:: to later link all the part of the program
::
ECHO Linking
::ECHO %OSDKLINKLIST%
cd 
::ECHO ON
ECHO %OSDKB%\link65.exe %OSDKLINK% -d %OSDKLIB% -o %OSDKT%\linked.s -f -q %OSDKLINKLIST% >%OSDKT%\link.bat
::ECHO %OSDKB%\link65.exe %OSDKLINK% -d %OSDK%\lib/ -o %OSDKT%\linked.s -s %OSDKT%\ -f -q %OSDKFILE% >%OSDKT%\link.bat
::pause
CALL %OSDKT%\link.bat
IF ERRORLEVEL 1 GOTO ErFailure
::ECHO Optimising size
::%OSDKB%\opt65.exe %OSDKT%\linked.s > %OSDKT%\linked_optimised.s


::
:: Assemble the big file
:: (-W -C are meant to disallow the 65816 and 65c02 instructions)
::%OSDKB%\xa.exe %OSDKT%\linked.s -o final.out -e xaerr.txt -l xalbl.txt
ECHO Assembling
%OSDKB%\xa.exe %OSDKT%\linked.s -o build\final.out -e build\xaerr.txt -l build\symbols -bt %OSDKADDR% -DASSEMBLER=XA %OSDKXAPARAMS% -DOSDKNAME_%OSDKNAME%
IF NOT EXIST "build\final.out" GOTO ErFailure


::
:: Executable compression test
::
IF "%OSDKPACKADDR%"=="" GOTO EndPack

IF "%OSDKBRIEF%"=="" ECHO Compressing
%OSDK%\bin\FilePack -p0 build\final.out  %OSDKT%\final.pak

IF "%OSDKBRIEF%"=="" ECHO   - Converting binary to text format
%OSDK%\bin\bin2txt -s1 -f2  %OSDKT%\final.pak  %OSDKT%\final_pak.s _PackedStart >NUL

IF "%OSDKBRIEF%"=="" ECHO   - Appending depacking code
COPY %OSDKT%\final_fp.s+%OSDKB%\unpack.s+%OSDKT%\final_pak.s %OSDKT%\pak_linked.s >NUL

IF "%OSDKBRIEF%"=="" ECHO   - Assembling
%OSDKB%\xa.exe  %OSDKT%\pak_linked.s -o build\final.out -e %OSDKT%\xaerr.txt -l %OSDKT%\symbols -bt %OSDKPACKADDR%
IF NOT EXIST "build\final.out" GOTO ErFailure

:: The new start address is the packed executable load address
set OSDKADDR=%OSDKPACKADDR%

:EndPack


::
:: Append the tape header
::
ECHO Creating TAPE image %OSDKNAME%.TAP
%OSDKB%\header.exe %OSDKHEAD% build\final.out build\%OSDKNAME%.tap %OSDKADDR%
%OSDKB%\taptap.exe ren build\%OSDKNAME%.tap %OSDKTAPNAME% 0

:BuildOk
ECHO Build of %OSDKNAME%.tap finished

:BasicLoader
:: Do we have a BASIC program ?
IF NOT EXIST %OSDKT%\%OSDKNAME%.bas GOTO EndBasicLoader

::ECHO ON
if "%OSDKLINKLIST%"=="" GOTO NoRenamePayload
ECHO Preparing payload for the BASIC program
del build\payload.tap
ren build\%OSDKNAME%.tap payload.tap
:NoRenamePayload

ECHO Generating TAPE file from BASIC source code
%OSDKB%\Bas2Tap -b2t1 -color1 %OSDKT%\%OSDKNAME%.bas build\%OSDKNAME%.tap

IF NOT EXIST build\payload.tap GOTO NoPayload
copy /b build\%OSDKNAME%.tap+build\payload.tap build\%OSDKNAME%.tap > NUL
:NoPayload

IF ERRORLEVEL 1 GOTO ErFailure
::GOTO End

:EndBasicLoader

::
:: Generate the DSK file. If OSDKFILE is empty we assume (hm hmmm) that the caller is packaging itself with floppybuilder. (WIP)
::
IF "%OSDKDISK%"=="" GOTO EndBuildDisk
IF "%OSDKFILE%"=="" GOTO EndBuildDisk

%OSDK%\bin\tap2dsk.exe -n%OSDKNAME% -i%OSDKINIST% %OSDKDISK% build\%OSDKNAME%.tap build\%OSDKNAME%.dsk
%OSDK%\bin\old2mfm.exe build\%OSDKNAME%.DSK

:EndBuildDisk

::
:: End of build
::
GOTO End


::
:: Outputs a "Unable to create program" error message
::
:ErFailure
ECHO ERROR : Build failed.
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End



::
:: Outputs a "no files" error message
::
:ErNoFile
ECHO == ERROR --
ECHO This batch file is supposed to compile files.
ECHO You should specify one or more files to compile.
ECHO -- ERROR ==
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End


::
:: Outputs a "configuration" error message
::
:ErCfg
ECHO == ERROR --
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
ECHO -- ERROR ==
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End





:End
Pause
