@ECHO OFF

::%OSDK%\bin\pictconv -m0 -f0 -d1 -o4_Mask pics\MaskSmallOric2.png mask.s
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o3_MaskC pics\MaskSmallOric2.png mask.c
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o0 pics\MaskSmallOric2.png maskf0d1.tap
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o0 pics\xmas-mask2.png xmas.tap

::%OSDK%\bin\PictConv -f1 -d0 -o2 ..\..\data\picture.png %OSDK%\tmp\picture.hir
::%OSDK%\bin\FilePack -p %OSDK%\tmp\picture.hir %OSDK%\tmp\picture.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 %OSDK%\tmp\picture.pak picture.s _LabelPicture

::%OSDK%\bin\pictconv -m0 -f0 -d1 -o2 pics\MaskSmallOric2.png mask.hir
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o2 pics\xmas-mask2.png mask.hir
::%OSDK%\bin\FilePack -p mask.hir mask.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 mask.pak mask.s _LabelPicture

:: MonoChrome
:: MAN ON MOON Mono
%osdk%\BIN\pictconv -m0 -f0 -d1 -O0 pics\MANONMOON\MANONMOON2.PNG manonmoon.tap
%osdk%\BIN\pictconv -m0 -f0 -d1 -O0 pics\MANONMOON\big-rock.png big-rock.tap
:: TYCHO MONO
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\TYCHO\tycho-central.PNG tycho-central.tap
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\TYCHO\tycho-central-ground.PNG tycho-central-ground.tap
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\TYCHO\tycho-grid.PNG tycho-grid.tap
%osdk%\BIN\pictconv -m0 -f0 -d3 pics\TYCHO\tycho-blue.PNG tycho-blue-mono.tap
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\TYCHO\tycho-distant.PNG tycho-distant.tap
:: SKYLON MONO
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\SKYLON\surface-tycho-skylon.PNG surface-tycho-skylon.tap
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\SKYLON\skylonhanger.PNG skylonhanger.tap
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\SKYLON\skylon-diag-1.PNG skylon-diag-1.tap
:: PEOPLE MONO
%osdk%\BIN\pictconv -m0 -f0 -d1 pics\PEOPLE\barnsey.PNG barnsey-mono.tap

:: Color
:: TYCHO COLOR
%osdk%\BIN\pictconv -f2 -d1 pics\TYCHO\tycho-cross-section.PNG tycho-cross.tap
%osdk%\BIN\pictconv -f2 -d1 pics\TYCHO\tycho-tri-color-2-oric.PNG tycho-tri-color-2.tap
%osdk%\BIN\pictconv -f2 -d1 pics\TYCHO\tycho-central-color.PNG tycho-central-color.tap
%osdk%\BIN\pictconv -f2 -d1 pics\TYCHO\tycho-false-color-2.PNG tycho-false-color-2.tap

%osdk%\BIN\pictconv -f2 -d1 pics\TYCHO\tycho-blue.PNG tycho-blue.tap

:: SKYLON COLOR
%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\skylon-dock-earth.PNG skylon-dock-earth.tap
%osdk%\BIN\pictconv -f2 -d0 pics\SKYLON\skylonhanger.PNG skylonhanger-color.tap
%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\skylon-take-off-earth.PNG skylon-take-off-earth.tap
%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\skylon-taxi-earth.PNG skylon-taxi-earth.tap
%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\station-skylon-orbit.PNG station-skylon-orbit.tap
%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\station-skylon-orbit2.PNG station-skylon-orbit2.tap

:: ROCKETS
%osdk%\BIN\pictconv -f2 -d0 pics\ROCKETS\lift-off.PNG lift-off.tap
%osdk%\BIN\pictconv -f2 -d0 pics\ROCKETS\lift-off-2.PNG lift-off-2.tap

:: PEOPLE
%osdk%\BIN\pictconv -f2 -d0 pics\PEOPLE\barnsey.PNG barnsey-color.tap
%osdk%\BIN\pictconv -f2 -d1 pics\PEOPLE\pilot.PNG pilot-color.tap
%osdk%\BIN\pictconv -f2 -d1 pics\PEOPLE\pilot-led.PNG pilot-led-color.tap
%osdk%\BIN\pictconv -f2 -d1 pics\PEOPLE\pilot-led-2.PNG pilot-led-2.tap
pause
