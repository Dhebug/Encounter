@ECHO OFF
TITLE OSDK

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg

set OSDKB=%OSDK%\bin
set OSDKNAME=TheHobbit
set OSDKDISK=%OSDKNAME%

:: Convert the graphical and audio data
%OSDKB%\pictconv -u1 -m0 -f6 -o4-TitlePicture data\title.png build\title_picture.s
%OSDKB%\pictconv -u1 -m0 -f1 -o4-CreditsPicture data\credits.png build\credits_picture.s
%OSDKB%\pictconv -u1 -m0 -f1 -o4-MapPicture data\map.png build\map_picture.s

:: Convert the medieval looking character set
%OSDKB%\pictconv -m0 -f0 -o1 data\font_6x8_oncial.png build\font_6x8.tap

:: Convert the music for the intro
%OSDK%\bin\ym2mym -h0 -m15872 data\music.ym build\music.mym
%OSDKB%\bin2txt -s1 -f2 build\music.mym build\music.s _Music

:: Build the main boot loader (BASIC)
%OSDKB%\Bas2Tap -b2t1 -color1 boot.bas build\boot.tap

:: Build the intro (assembler)
%OSDKB%\Xa -l build\symbols_intro -o build\intro.bin intro.s
%OSDKB%\header.exe -h1 -a1 build\intro.bin build\intro.tap $600

:: Build the patch (assembler), attach it to the end of the original Hobbit executable
%OSDKB%\Xa -l build\symbols_patch -o build\patch.bin patch.s
copy /b data\HOBBIT.COM+build\patch.bin build\patched_hobbit.bin

:: Merge the debugging symbols of the intro and patch
copy /b build\symbols_intro+build\symbols_patch %osdk%\oricutron\symbols

:: hobbit.com - 36176 bytes loads/runs at $4fe
%OSDKB%\header.exe -h1 -a1 build\patched_hobbit.bin build\hobbit.com $4fe

::ECHO ON
ECHO Building DSK file
pushd build

%OSDK%\bin\tap2dsk -iCLS:BOOT boot.tap hobbit.com intro.tap font_6x8.tap %OSDKDISK%.dsk
%OSDK%\bin\old2mfm %OSDKDISK%.dsk
popd 

GOTO End


::
:: Outputs an error message
::
:ErCfg
ECHO == ERROR ==
ECHO The Oric SDK was not configured properly
ECHO You should have a OSDK environment variable setted to the location of the SDK
IF "%OSDKBRIEF%"=="" PAUSE
GOTO End


:End
pause
