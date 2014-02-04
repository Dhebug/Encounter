@ECHO OFF

SET PIMP=%OSDK%\THEPIMP

:: MonoChrome
:: MAN ON MOON Mono
echo PIMPING MENONMOON

::%osdk%\BIN\pictconv -f6 pics\MANONMOON\MANONMOON2.PNG manonmoon.tap
::%osdk%\BIN\pictconv -f6 pics\MANONMOON\big-rock.png big-rock.tap

%PIMP%\bin\pipi.exe pics\MANONMOON\MANONMOON2.PNG -o manonmoon.tap
%PIMP%\bin\pipi.exe pics\MANONMOON\big-rock.png -o big-rock.tap

:: TYCHO MONO
::%osdk%\BIN\pictconv -m0 -f0 -d1 pics\TYCHO\tycho-central.PNG tycho-central.tap
::%osdk%\BIN\pictconv -m0 -f0 -d1 pics\TYCHO\tycho-central-ground.PNG tycho-central-ground.tap
::%osdk%\BIN\pictconv -m0 -f0 -d1 pics\TYCHO\tycho-grid.PNG tycho-grid.tap
::%osdk%\BIN\pictconv -m0 -f0 -d1 pics\TYCHO\tycho-distant.PNG tycho-distant.tap
echo PIMPING TYCHO MONO

::%PIMP%\bin\pipi.exe pics\TYCHO\tycho-central.PNG -o tycho-central.tap
::%PIMP%\bin\pipi.exe pics\TYCHO\tycho-central-ground.PNG -o tycho-central-ground.tap
::%PIMP%\bin\pipi.exe pics\TYCHO\tycho-grid.PNG -o tycho-grid.tap
::%PIMP%\bin\pipi.exe pics\TYCHO\tycho-distant.PNG -o tycho-distant.tap

:: SKYLON MONO

::%osdk%\BIN\pictconv -m0 -f0 -d1 pics\SKYLON\surface-tycho-skylon.PNG surface-tycho-skylon.tap
::%osdk%\BIN\pictconv -m0 -f0 -d1 pics\SKYLON\skylon-diag-1.PNG skylon-diag-1.tap
echo PIMPING SKYLON MONO
::%PIMP%\bin\pipi.exe pics\SKYLON\surface-tycho-skylon.PNG -o surface-tycho-skylon.tap
::%PIMP%\bin\pipi.exe pics\SKYLON\skylon-diag-1.PNG -o skylon-diag-1.tap


:: Color
:: TYCHO COLOR

::%osdk%\BIN\pictconv -f2 -d1 pics\TYCHO\tycho-cross-section.PNG tycho-cross.tap
::%osdk%\BIN\pictconv -f2 -d1 pics\TYCHO\tycho-tri-color-2-oric.PNG tycho-tri-color-2.tap
::%osdk%\BIN\pictconv -f2 -d1 pics\TYCHO\tycho-central-color.PNG tycho-central-color.tap
::%osdk%\BIN\pictconv -f2 -d1 pics\TYCHO\tycho-false-color-2.PNG tycho-false-color-2.tap
echo PIMPING TYCHO
::%PIMP%\bin\pipi.exe pics\TYCHO\tycho-cross-section.PNG -o tycho-cross.tap
::%PIMP%\bin\pipi.exe pics\TYCHO\tycho-tri-color-2-oric.PNG -o tycho-tri-color-2.tap
::%PIMP%\bin\pipi.exe pics\TYCHO\tycho-central-color.PNG -o tycho-central-color.tap
::%PIMP%\bin\pipi.exe pics\TYCHO\tycho-false-color-2.PNG -o tycho-false-color-2.tap
::%PIMP%\bin\pipi.exe pics\TYCHO\tycho-blue.PNG -o tycho-blue.tap

:: SKYLON COLOR

::%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\skylon-dock-earth.PNG skylon-dock-earth.tap
::%osdk%\BIN\pictconv -f2 -d0 pics\SKYLON\skylonhanger.PNG skylonhanger-color.tap
::%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\skylon-take-off-earth.PNG skylon-take-off-earth.tap
::%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\skylon-taxi-earth.PNG skylon-taxi-earth.tap
::%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\station-skylon-orbit.PNG station-skylon-orbit.tap
::%osdk%\BIN\pictconv -f2 -d1 pics\SKYLON\station-skylon-orbit2.PNG station-skylon-orbit2.tap
echo PIMPING SKYLON
::%PIMP%\bin\pipi.exe pics\SKYLON\skylon-dock-earth.PNG -o skylon-dock-earth.tap
::%PIMP%\bin\pipi.exe pics\SKYLON\skylonhanger.PNG -o skylonhanger-color.tap
::%PIMP%\bin\pipi.exe pics\SKYLON\skylon-take-off-earth.PNG -o skylon-take-off-earth.tap
::%PIMP%\bin\pipi.exe pics\SKYLON\skylon-taxi-earth.PNG -o skylon-taxi-earth.tap
::%PIMP%\bin\pipi.exe pics\SKYLON\station-skylon-orbit.PNG -o station-skylon-orbit.tap
::%PIMP%\bin\pipi.exe pics\SKYLON\station-skylon-orbit2.PNG -o station-skylon-orbit2.tap
::%PIMP%\bin\pipi.exe pics\SKYLON\surface-tycho-skylon.PNG -o surface-tycho-skylon.tap

:: ROCKETS
echo PIMPING ROCKETS
::%osdk%\BIN\pictconv -f2 -d0 pics\ROCKETS\lift-off.PNG lift-off.tap
::%osdk%\BIN\pictconv -f2 -d0 pics\ROCKETS\lift-off-2.PNG lift-off-2.tap

::%PIMP%\bin\pipi.exe pics\ROCKETS\lift-off.PNG -o lift-off.tap
::%PIMP%\bin\pipi.exe pics\ROCKETS\lift-off-2.PNG -o lift-off-2.tap

:: PEOPLE
::%OSDK%\BIN\pictconv -f2 -d1 pics\PEOPLE\barnsey.PNG barnsey-color.tap
::%OSDK%\BIN\pictconv -f2 -d0 pics\PEOPLE\barnsey.PNG barnsey-nodither.tap
echo PIMPING PEOPLE

::%PIMP%\bin\pipi.exe pics\PEOPLE\barnsey.PNG -o barnsey-mono.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\barnsey.PNG --blur 3 -o barnsey-blur.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\pilot.PNG -o pilot-color.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\pilot-led.PNG -o pilot-led-color.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\pilot-led-1B.PNG -o pilot-led-1B.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\pilot-led-2.PNG -o pilot-led-2.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\pilot-led-2B.PNG -o pilot-led-2B.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\pilot-led-4.PNG -o pilot-led-4.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\pilot-led-5.PNG -o pilot-led-5.tap

::%PIMP%\bin\pipi.exe pics\PEOPLE\chick1-jetpac.PNG -o chick1-jetpac.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\chick-with-gun.PNG -o chick-with-gun.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\barbarella1.PNG -o barbarella1.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\barbarella2.PNG -o barbarella2.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\barbarella3.PNG -o barbarella3.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\barbarella4.PNG -o barbarella4.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\barbarella5.PNG -o barbarella5.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\barbarella6.PNG -o barbarella6.tap
::%PIMP%\bin\pipi.exe pics\PEOPLE\SpaceGirl.PNG -o SpaceGirl.tap

echo PIMPING VIDEO
::VIDEO
::%PIMP%\bin\pipi.exe VIDEO\you-wanker.png -o you-wanker.tap
::%OSDK%\bin\pictconv -f6 -u VIDEO\you-wanker.png you-wanker.tap
%OSDK%\bin\pictconv -u -f6 -o4_BlahBlah VIDEO\blahblah.png BlahBlah.s

echo PIMPING OBJECTS
::OBJECTS
::%PIMP%\bin\pipi.exe pics\OBJECTS\watch.png -o watch.tap

pause

