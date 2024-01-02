@ECHO OFF

::
:: Initial check.
:: Verify if the SDK is correctly configurated
::
IF "%OSDK%"=="" GOTO ErCfg

::
:: Convert data here
::
MD BUILD
%OSDK%\bin\pictconv -u1 -m0 -f0 -o1 data\font_6x8_mystery.png build\font.tap

%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\title.png build\title.tap

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
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\no_picture.png build\NONE.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\deserted_market_square.png build\1.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\dark_seedy_alley.png build\2.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\long_road_stretch.png build\3.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\dark_damp_tunel.png build\4.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\main_street.png build\5.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\narrow_path.png build\6.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\fallen_deep_pit.png build\7.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\old_fashioned_well.png build\8.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\dark_forest.png build\9.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\wide_gravel_drive.png build\10.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\wide_area_tarmac.png build\11.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\beautiful_garden.png build\12.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\huge_area_lawn.png build\13.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\in_small_greenhouse.png build\14.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\lawn_tennis_court.png build\15.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\vegetable_plot.png build\16.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\fish_pond.png build\17.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\barred_window.png build\18.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\apple_orchard.png build\19.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\even_darker_room.png build\20.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\cold_damp_cellar.png build\21.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\gloomy_narrow_steps.png build\22.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\lounge.png build\23.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\imposing_entrance_hall.png build\24.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\imposing_entrance_hall_with_dog_growling.png build\241.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\imposing_entrance_hall_with_dog_dead.png build\240.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\library.png build\25.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\dinning_room.png build\26.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\sweeping_staircase.png build\27.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\games_room.png build\28.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\sun_lounge.png build\29.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\kitchen.png build\30.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\narrow_passage.png build\31.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\guest_bedroom.png build\32.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\child_bedroom.png build\33.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\master_bedroom.png build\34.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\tiled_shower_room.png build\35.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\tiny_toilet.png build\36.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\east_gallery.png build\37.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\small_box_room.png build\38.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\padlocked_steel_door.png build\39.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\ornate_bathroom.png build\40.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\west_gallery.png build\41.tap
%OSDK%\bin\pictconv -u1 -m0 -f6 -o1 data\main_landing.png build\42.tap

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
