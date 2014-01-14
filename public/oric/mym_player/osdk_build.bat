@ECHO OFF


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
%OSDK%\bin\header -h1 -a0 build\mymplayer.o build\mymplayer.tap $6500


::
:: Convert musics
:: ym1.mym -> 8699 bytes
:: ym2.mym -> 7293 bytes
:: ym3.mym -> 7956 bytes
::
:: HIRES last usable memory area is $9800 / 38912
:: - 8657 -> $762f / 30255
:: Round to -> $7600 / 30208 this gives us $2200 / 8704 bytes for the music
::
:: TEXT last usable memory area is $B400 / 46080
:: $B400-$7600  gives us $3E00 / 15872 bytes for the music
::
:: So we make each music load in $7600
::
:: The depacking buffer for the music requires 256 bytes per register, so 256*14 bytes = $e00 / 3584 bytes
:: If we place the buffer just before the music file, it will start at the location $7600-$e00 = $6800 / 26624
::
:: And just before that we put the music player binary file, which will start by two JMP:
:: - (+0) JMP StartMusic
:: - (+3) JMP StopMusic
::
:: The music player itself is less than 512 bytes without counting the IRQ installation and what nots so could start in $6600, say $6500 for security
::
echo %osdk%

SET YM2MYM=%osdk%\Bin\ym2mym.exe -h1 -m15872

%YM2MYM% "data\Bubble Bobble 1.ym" build\BubbleBobble.tap              $7600 "Music1"
%YM2MYM% "data\Great Giana Sisters 1 - title.ym" build\Giana-Title.tap $7600 "Music2"
%YM2MYM% "data\Rainbow Island  1.ym" build\RainbowIsland.tap           $7600 "Music3"
%YM2MYM% "data\Pacmania 1.ym" build\PacMania-1.tap                     $7600 "Music4"
%YM2MYM% "data\Tetris title.ym" build\Tetris.tap                       $7600 "Music5"
%YM2MYM% "data\Speedball 1.ym" build\SpeedBall.tap                     $7600 "Music6"
%YM2MYM% "data\Nebulus.ym" build\Nebulus.tap                           $7600 "Music7"
%YM2MYM% "data\Outrun 1.ym" build\Outrun.tap                           $7600 "Music8"
%YM2MYM% "data\Commando.ym" build\Commando.tap                         $7600 "Music9"
%YM2MYM% "data\The Real Ghostbusters 1.ym" build\Ghostbusters.tap      $7600 "Music0"
%YM2MYM% "data\Supercars 1.ym" build\Supercars.tap                     $7600 "MusicA"


::
:: Rename files so they have friendly names on the disk
::
%OSDK%\bin\taptap ren build\%OSDKNAME%.tap "Test" 0
%OSDK%\bin\taptap ren build\mymplayer.tap "mymplayer" 0


pause

ECHO Building DSK file
%OSDK%\bin\tap2dsk -iCLS:TEST build\%OSDKNAME%.TAP build\mymplayer.tap build\BubbleBobble.tap build\Giana-Title.tap build\RainbowIsland.tap build\PacMania-1.tap build\Tetris.tap build\SpeedBall.tap build\Nebulus.tap build\Outrun.tap build\Commando.tap build\Ghostbusters.tap build\Supercars.tap build\%OSDKNAME%.dsk
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