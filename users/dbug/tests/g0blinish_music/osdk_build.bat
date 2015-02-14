@ECHO OFF


::
:: Convert musics
:: einstein.mym -> 19528 bytes
:: mymplayer.o  -> 658 bytes
::
:: TEXT last usable memory area is $B400, minus 19258 bytes for the music -> $67B8 as start address for the music, let's round to $6700
::
:: The depacking buffer for the music requires 256 bytes per register, so 256*14 bytes = $e00 / 3584 bytes
:: If we place the buffer just before the music file, it will start at the location $67B0-$e00 = $5900
::
:: And just before that we put the music player binary file, which will start by two JMP:
:: - (+0) JMP StartMusic
:: - (+3) JMP StopMusic
::
:: The music player itself is about 658 bytes. So, $B900 - 658 -> $6660, say $5600 for security
::
:: So:
:: - Music player in $5600
:: - Decompression buffers in $5900
:: - Music data in $6700
::


::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg


::
:: Set the build paremeters
::
CALL osdk_config.bat


::
:: Launch the compilation of files
::
CALL %OSDK%\bin\make.bat %OSDKFILE%

::
:: Assemble the music player
::
ECHO Assembling music player
%osdk%\bin\xa mymplayer.s -o build\mymplayer.o
%OSDK%\bin\header -h1 -a0 build\mymplayer.o build\mymplayer.tap $5600

echo %osdk%

SET YM2MYM=%osdk%\Bin\ym2mym.exe -h1

SET MUSIC="einstein.ym"
SET MUSIC="D:\_music_\ST_SOUND\ST_SOUND\Big Alec (Gunnar Gaubatz)\No Second Prize 1 - intro.ym"
SET MUSIC="D:\_music_\ST_SOUND\ST_SOUND\Count Zero (Nic Alderton)\Decade Boot.ym"
SET MUSIC="D:\_music_\ST_SOUND\ST_SOUND\Huelsbeck Chris\Jim Power  1.ym"
::SET MUSIC="D:\_music_\ST_SOUND\ST_SOUND\Jess (Jean-Sebastien Gerard)\For your Loader #1.ym"
::SET MUSIC="D:\_music_\ST_SOUND\ST_SOUND\Scavenger (Joris de Man)\DBA 6.ym"

%YM2MYM% %MUSIC% build\einstein.tap              $6700 "Music1"


::
:: Rename files so they have friendly names on the disk
::
%OSDK%\bin\taptap ren build\%OSDKNAME%.tap "Test" 0
%OSDK%\bin\taptap ren build\mymplayer.tap "mymplayer" 0


pause

ECHO Building DSK file
%OSDK%\bin\tap2dsk -iCLS:TEST build\%OSDKNAME%.TAP build\mymplayer.tap build\einstein.tap build\%OSDKNAME%.dsk
%OSDK%\bin\old2mfm build\%OSDKNAME%.dsk


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