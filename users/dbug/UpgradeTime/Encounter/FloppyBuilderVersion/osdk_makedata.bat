
:: Create the folders we need
md build
pushd build
md files
popd

::
:: Build data for the demo, is that a Slide Disk, or a Music Show?
::

:: Pictures
SET PICTCONV=%OSDK%\Bin\PictConv
SET HEADER=%OSDK%\Bin\header
SET XA=%OSDK%\Bin\Xa
SET TARGET=build\files

:: Hi-Score table
%XA% -o %TARGET%\scores.bin data\scores.s
%HEADER% -h1 %TARGET%\scores.bin %TARGET%\scores.tap $9c00

:: Character sets
SET PARAMS=-u1 -m0 -f0 -o2
%PICTCONV% %PARAMS% data\font_6x8_mystery.png %TARGET%\font_6x8_mystery.fnt

:: Title picture
SET PARAMS=-u1 -m0 -f6 -o2
%PICTCONV% %PARAMS% data\title.png %TARGET%\title.hir

:: Here we have the list of 240x128 pictures
::
:: 1 - You are in a deserted market square
:: 2 - You are in a dark, seedy alley.
:: 3 - A long road stretches ahead of you.
:: 4 - You are in a dark, damp tunnel.
:: 5 - You are on the main street.
:: 6 - You are on a narrow path.
:: 7 - You have fallen into a deep pit
:: 8 - You are near to an old-fashioned well.
:: 9 - You are in a dark forest.
:: 10 - You are on a wide gravel drive
:: 11 - You are in an open area of tarmac
:: 12 - You are in a beautiful garden
:: 13 - You are on a huge area of lawn
:: 14 - You are in a small greenhouse
:: 15 - You are on a lawn tennis court.
:: 16 - You are in a vegetable plot.
:: 17 - You are standing by a fish pond.
:: 18 - You are on a tiled patio and above it is a barred window 
:: 19 - You are in an apple orchard.
:: 20 - This room is even darker than the last
:: 21 - This is a cold, damp cellar + heavy safe
:: 22 - You are on some gloomy, narrow steps.
:: 23 - You are in the lounge.
:: 24 - You are in an imposing entrance hall
:: 25 - This looks like a library. 
:: 26 - A dining room, or so it appears 
:: 27 - You are on a sweeping staircase
:: 28 - This looks like a games room.
:: 29 - You find yourself in a sun-lounge.
:: 30 - This is obviously the kitchen.
:: 31 - You are in a narrow passage
:: 32 - This seems to bea quest bedroom
:: 33 - This is a child's bedroom
:: 34 - This must be the master bedroom
:: 35 - You are in a tiled shower-room
:: 36 - This is a tiny toilet
:: 37 - You have found the east gallery
:: 38 - This is a small box-room
:: 39 - You have reached a steel-plated door. It is padlocked.
:: 40 - You are in an ornate bathroom
:: 41 - This is the west gallery
:: 42 - You are on the main landing
SET PARAMS=-u1 -m0 -f0 -o2
%PICTCONV% %PARAMS% data\no_picture.png %TARGET%\NONE.hir
%PICTCONV% %PARAMS% data\deserted_market_square.png %TARGET%\1.hir
%PICTCONV% %PARAMS% data\dark_seedy_alley.png %TARGET%\2.hir
%PICTCONV% %PARAMS% data\long_road_stretch.png %TARGET%\3.hir
%PICTCONV% %PARAMS% data\dark_damp_tunel.png %TARGET%\4.hir
%PICTCONV% %PARAMS% data\main_street.png %TARGET%\5.hir
%PICTCONV% %PARAMS% data\narrow_path.png %TARGET%\6.hir
%PICTCONV% %PARAMS% data\fallen_deep_pit.png %TARGET%\7.hir
%PICTCONV% %PARAMS% data\old_fashioned_well.png %TARGET%\8.hir
%PICTCONV% %PARAMS% data\dark_forest.png %TARGET%\9.hir
%PICTCONV% %PARAMS% data\wide_gravel_drive.png %TARGET%\10.hir
%PICTCONV% %PARAMS% data\wide_area_tarmac.png %TARGET%\11.hir
%PICTCONV% %PARAMS% data\beautiful_garden.png %TARGET%\12.hir
%PICTCONV% %PARAMS% data\huge_area_lawn.png %TARGET%\13.hir
%PICTCONV% %PARAMS% data\in_small_greenhouse.png %TARGET%\14.hir
%PICTCONV% %PARAMS% data\lawn_tennis_court.png %TARGET%\15.hir
%PICTCONV% %PARAMS% data\vegetable_plot.png %TARGET%\16.hir
%PICTCONV% %PARAMS% data\fish_pond.png %TARGET%\17.hir
%PICTCONV% %PARAMS% data\barred_window.png %TARGET%\18.hir
%PICTCONV% %PARAMS% data\apple_orchard.png %TARGET%\19.hir
%PICTCONV% %PARAMS% data\even_darker_room.png %TARGET%\20.hir
%PICTCONV% %PARAMS% data\cold_damp_cellar.png %TARGET%\21.hir
%PICTCONV% %PARAMS% data\gloomy_narrow_steps.png %TARGET%\22.hir
%PICTCONV% %PARAMS% data\lounge.png %TARGET%\23.hir
%PICTCONV% %PARAMS% data\imposing_entrance_hall.png %TARGET%\24.hir
%PICTCONV% %PARAMS% data\imposing_entrance_hall_with_dog_growling.png %TARGET%\241.hir
%PICTCONV% %PARAMS% data\imposing_entrance_hall_with_dog_dead.png %TARGET%\240.hir
%PICTCONV% %PARAMS% data\imposing_entrance_hall_dog_attacking.png %TARGET%\242.hir
%PICTCONV% %PARAMS% data\library.png %TARGET%\25.hir
%PICTCONV% %PARAMS% data\dinning_room.png %TARGET%\26.hir
%PICTCONV% %PARAMS% data\sweeping_staircase.png %TARGET%\27.hir
%PICTCONV% %PARAMS% data\games_room.png %TARGET%\28.hir
%PICTCONV% %PARAMS% data\sun_lounge.png %TARGET%\29.hir
%PICTCONV% %PARAMS% data\kitchen.png %TARGET%\30.hir
%PICTCONV% %PARAMS% data\narrow_passage.png %TARGET%\31.hir
%PICTCONV% %PARAMS% data\guest_bedroom.png %TARGET%\32.hir
%PICTCONV% %PARAMS% data\child_bedroom.png %TARGET%\33.hir
%PICTCONV% %PARAMS% data\master_bedroom_dead_man.png %TARGET%\340.hir
%PICTCONV% %PARAMS% data\master_bedroom.png %TARGET%\341.hir
%PICTCONV% %PARAMS% data\master_bedroom_player_dead.png %TARGET%\342.hir
%PICTCONV% %PARAMS% data\tiled_shower_room.png %TARGET%\35.hir
%PICTCONV% %PARAMS% data\tiny_toilet.png %TARGET%\36.hir
%PICTCONV% %PARAMS% data\east_gallery.png %TARGET%\37.hir
%PICTCONV% %PARAMS% data\small_box_room.png %TARGET%\38.hir
%PICTCONV% %PARAMS% data\padlocked_steel_door.png %TARGET%\39.hir
%PICTCONV% %PARAMS% data\ornate_bathroom.png %TARGET%\40.hir
%PICTCONV% %PARAMS% data\west_gallery.png %TARGET%\41.hir
%PICTCONV% %PARAMS% data\main_landing.png %TARGET%\42.hir


::pause


