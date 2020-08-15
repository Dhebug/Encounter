
:: Create the folders we need
md build
pushd build
md files
popd

::
:: Build data for the demo, is that a Slide Disk, or a Music Show?
::

:: Pictures
SET PICTCONV=%OSDK%\Bin\PictConv -u1 -m0
SET TARGET=build\files

:: Character sets
%PICTCONV% -f0 -o2 data\font_6x8_mystery.png %TARGET%\font_6x8_mystery.fnt

:: Dungeon Master Intro Sequence
%PICTCONV% -u1 -m0 -f0 -o4_SwooshData% data\swoosh_data.png code\swoosh_data.s

:: Scroll with the credits
%PICTCONV% -u1 -m0 -f1 -o2 data\scroll_credits.png %TARGET%\scroll_credits.hir

::pause


