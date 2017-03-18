@ECHO OFF
::%OSDK%\bin\Bin2Txt -s1 -f2 graphics\font\8X8_ANSI.raw font.s _Font8x8
::%OSDK%\bin\Bin2Txt -s1 -f2 graphics\font\128x256.raw texture.s _Texture128x256

::%OSDK%\bin\FilePack -p graphics\font\128x256.raw graphics\font\128x256.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 graphics\font\128x256.pak texture.s _Texture128x256Packed


%OSDK%\bin\PictConv -o4_Twilighte126x34 pics\twilighte-126x34.png twilighte-logo.s
::%OSDK%\bin\FilePack -p %OSDK%\tmp\twilighte-126x34.raw %OSDK%\tmp\twilighte-126x34.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\twilighte-126x34.raw twilighte-logo.s _Twilighte126x34Packed


pause
