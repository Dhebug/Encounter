
:: Create the folders we need
if not exist "build" md build
pushd build
if not exist "files" md files
popd

:: Create a ESC environment variable containing the escape character
:: See: https://gist.github.com/mlocati/fdabcaeb8071d5c75a2d51712db24011#file-win10colors-cmd
for /F %%a in ('"prompt $E$S & echo on & for %%b in (1) do rem"') do set "ESC=%%a"

echo.
echo %ESC%[93m============ Converting assets ============%ESC%[0m
echo.

::
:: Build data for the game
::
set OSDK_BUILD_START=%time%

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
%PICTCONV% %PARAMS% data\font_6x8_mystery_fr.png %TARGET%\font_6x8_mystery_fr.fnt

%PICTCONV% %PARAMS% data\font_6x8_typewriter.png %TARGET%\font_6x8_typewriter.fnt
%PICTCONV% %PARAMS% data\font_6x8_typewriter_fr.png %TARGET%\font_6x8_typewriter_fr.fnt

:: 6x6 dither matrix
SET PARAMS=-u1 -m0 -f0 -o4_6x6DitherMatrix
%PICTCONV% %PARAMS% data\pattern_6x6_dither_matrix.png build\6x6_dither_matrix.s
%PICTCONV% %PARAMS% data\pattern_typewriter_dithering.png build\typewriter_dithering_pattern.s


:: The 12x14 font
:: palatino_linotype_italics_size_10_font.png
SET PARAMS=-u1 -m0 -f0 -o4Font12x14
%PICTCONV% %PARAMS% data\font_palatino_linotype_italics_size_10.png build\generated_12x14_font.s
%PICTCONV% %PARAMS% data\font_palatino_linotype_italics_size_10_fr.png build\generated_12x14_font_fr.s



:: Title picture
SET PARAMS=-u1 -m0 -f6 -o2
%PICTCONV% %PARAMS% data\intro_title_picture.png %TARGET%\title.hir

:: Intro graphics
SET PARAMS=-u1 -m0 -f0 -o2
%PICTCONV% %PARAMS% data\intro_private_investigator.png %TARGET%\intro_private_investigator.hir
%PICTCONV% %PARAMS% data\intro_typewriter.png %TARGET%\intro_typewriter.hir

:: Outro graphics
SET PARAMS=-u1 -m0 -f0 -o2
%PICTCONV% %PARAMS% data\outro_desk.png %TARGET%\outro_desk.hir


:: Arrow block (Temp file that needs to be copied in the display.s file)
SET PARAMS=-u1 -m0 -f0 -o4_ArrowBlockMasks
%PICTCONV% %PARAMS% data\masks_arrow_block.png build\mask.s


:: Masked out sprites
SET PARAMS=-u1 -m0 -f3 -o2
%PICTCONV% %PARAMS% data\masked_the_end.png %TARGET%\the_end.msk
%PICTCONV% %PARAMS% data\masked_the_end_fr.png %TARGET%\the_end_fr.msk
%PICTCONV% %PARAMS% data\masked_dog.png %TARGET%\dog.msk
%PICTCONV% %PARAMS% data\masked_items.png %TARGET%\items.msk
%PICTCONV% %PARAMS% data\masked_thug.png %TARGET%\thug.msk
%PICTCONV% %PARAMS% data\masked_safe_room.png %TARGET%\safe_room.msk
%PICTCONV% %PARAMS% data\masked_element_outro.png %TARGET%\masked_element_outro.msk
%PICTCONV% %PARAMS% data\masked_element_outro_photos.png %TARGET%\masked_element_outro_photos.msk
%PICTCONV% %PARAMS% data\masked_element_outro_photos_fr.png %TARGET%\masked_element_outro_photos_fr.msk

:: Here we have the list of 240x128 pictures
::
:: 0 - You are in a deserted market square
:: 1 - You are in a dark, seedy alley.
:: 2 - A long road stretches ahead of you.
:: 3 - You are in a dark, damp tunnel.
:: 4 - You are on the main street.
:: 5 - You are on a narrow path.
:: 6 - You have fallen into a deep pit
:: 7 - You are near to an old-fashioned well.
:: 8 - You are in a wooded avenue.
:: 9  - You are on a wide gravel drive
:: 10 - You are in an open area of tarmac
:: 11 - You are in a beautiful garden
:: 12 - You are on a huge area of lawn
:: 13 - You are in a small greenhouse
:: 14 - You are on a lawn tennis court.
:: 15 - You are in a vegetable plot.
:: 16 - You are standing by a fish pond.
:: 17 - You are on a tiled patio and above it is a barred window 
:: 18 - You are in an apple orchard.
:: 19 - This room is even darker than the last
:: 20 - This is a cold, damp cellar + heavy safe
:: 21 - You are on some gloomy, narrow steps.
:: 22 - You are in the lounge.
:: 23 - You are in an imposing entrance hall
:: 24 - This looks like a library. 
:: 25 - A dining room, or so it appears 
:: 26 - You are on a sweeping staircase
:: 27 - This looks like a games room.
:: 28 - You find yourself in a sun-lounge.
:: 29 - This is obviously the kitchen.
:: 30 - You are in a narrow passage
:: 31 - This seems to bea quest bedroom
:: 32 - This is a child's bedroom
:: 33 - This must be the master bedroom
:: 34 - You are in a tiled shower-room
:: 35 - This is a tiny toilet
:: 36 - You have found the east gallery
:: 37 - This is a small box-room
:: 38 - You have reached a steel-plated door. It is padlocked.
:: 39 - You are in an ornate bathroom
:: 40 - This is the west gallery
:: 41 - You are on the main landing
:: 42 - Outside a deep pit
:: 43 - A study room
:: 44 - A bright cellar room
SET PARAMS=-u1 -m0 -f0 -o2
%PICTCONV% %PARAMS% data\no_picture.png %TARGET%\NONE.hir

%PICTCONV% %PARAMS% data\loc_market_square.png %TARGET%\0.hir
%PICTCONV% %PARAMS% data\loc_seedy_alley.png %TARGET%\1.hir
%PICTCONV% %PARAMS% data\loc_road_stretch.png %TARGET%\2.hir
%PICTCONV% %PARAMS% data\loc_tunel.png %TARGET%\3.hir
%PICTCONV% %PARAMS% data\loc_main_street.png %TARGET%\4.hir
%PICTCONV% %PARAMS% data\loc_east_road.png %TARGET%\5.hir
%PICTCONV% %PARAMS% data\loc_inside_pit.png %TARGET%\6.hir
%PICTCONV% %PARAMS% data\loc_well.png %TARGET%\7.hir
%PICTCONV% %PARAMS% data\loc_wooded_avenue.png %TARGET%\8.hir
%PICTCONV% %PARAMS% data\loc_gravel_drive.png %TARGET%\9.hir
%PICTCONV% %PARAMS% data\loc_parking.png %TARGET%\10.hir
%PICTCONV% %PARAMS% data\loc_garden.png %TARGET%\11.hir
%PICTCONV% %PARAMS% data\loc_lawn.png %TARGET%\12.hir
%PICTCONV% %PARAMS% data\loc_greenhouse.png %TARGET%\13.hir
%PICTCONV% %PARAMS% data\loc_tennis_court.png %TARGET%\14.hir
%PICTCONV% %PARAMS% data\loc_vegetable_plot.png %TARGET%\15.hir
%PICTCONV% %PARAMS% data\loc_fish_pond.png %TARGET%\16.hir
%PICTCONV% %PARAMS% data\loc_rear_entrance.png %TARGET%\17.hir
%PICTCONV% %PARAMS% data\loc_orchard.png %TARGET%\18.hir
%PICTCONV% %PARAMS% data\loc_dark_room.png %TARGET%\19.hir
%PICTCONV% %PARAMS% data\loc_cellar.png %TARGET%\20.hir
%PICTCONV% %PARAMS% data\loc_narrow_steps.png %TARGET%\21.hir
%PICTCONV% %PARAMS% data\loc_lounge.png %TARGET%\22.hir
%PICTCONV% %PARAMS% data\loc_entrance_hall.png %TARGET%\23.hir
%PICTCONV% %PARAMS% data\loc_library.png %TARGET%\24.hir
%PICTCONV% %PARAMS% data\loc_dinning_room.png %TARGET%\25.hir
%PICTCONV% %PARAMS% data\loc_staircase.png %TARGET%\26.hir
%PICTCONV% %PARAMS% data\loc_games_room.png %TARGET%\27.hir
%PICTCONV% %PARAMS% data\loc_sun_lounge.png %TARGET%\28.hir
%PICTCONV% %PARAMS% data\loc_kitchen.png %TARGET%\29.hir
%PICTCONV% %PARAMS% data\loc_narrow_passage.png %TARGET%\30.hir
%PICTCONV% %PARAMS% data\loc_guest_bedroom.png %TARGET%\31.hir
%PICTCONV% %PARAMS% data\loc_child_bedroom.png %TARGET%\32.hir
%PICTCONV% %PARAMS% data\loc_master_bedroom.png %TARGET%\33.hir
%PICTCONV% %PARAMS% data\loc_shower_room.png %TARGET%\34.hir
%PICTCONV% %PARAMS% data\loc_toilet.png %TARGET%\35.hir
%PICTCONV% %PARAMS% data\loc_east_gallery.png %TARGET%\36.hir
%PICTCONV% %PARAMS% data\loc_box_room.png %TARGET%\37.hir
%PICTCONV% %PARAMS% data\loc_steel_door.png %TARGET%\38.hir
%PICTCONV% %PARAMS% data\loc_bathroom.png %TARGET%\39.hir
%PICTCONV% %PARAMS% data\loc_west_gallery.png %TARGET%\40.hir
%PICTCONV% %PARAMS% data\loc_landing.png %TARGET%\41.hir
%PICTCONV% %PARAMS% data\loc_outside_pit.png %TARGET%\42.hir
%PICTCONV% %PARAMS% data\loc_study_room.png %TARGET%\43.hir
%PICTCONV% %PARAMS% data\loc_basement_window_darkened.png %TARGET%\44.hir

:: Scene variants
%PICTCONV% %PARAMS% data\loc_dark_room_sunlight.png %TARGET%\loc_cellar_bright.hir
%PICTCONV% %PARAMS% data\loc_basement_window_cleared.png %TARGET%\loc_basement_window_cleared.hir


:: Other 240x128 full screen images which are not locations
%PICTCONV% %PARAMS% data\view_newspaper.png %TARGET%\newspaper.hir
%PICTCONV% %PARAMS% data\view_newspaper_fr.png %TARGET%\newspaper_fr.hir

%PICTCONV% %PARAMS% data\view_handwritten_note.png %TARGET%\handwritten_note.hir
%PICTCONV% %PARAMS% data\view_handwritten_note_fr.png %TARGET%\handwritten_note_fr.hir

%PICTCONV% %PARAMS% data\view_science_book.png %TARGET%\science_book.hir
%PICTCONV% %PARAMS% data\view_chemistry_recipes.png %TARGET%\chemistry_recipes.hir
%PICTCONV% %PARAMS% data\view_united_kingdom_map.png %TARGET%\united_kingdom_map.hir
%PICTCONV% %PARAMS% data\view_fridge_door.png %TARGET%\fridge_door.hir
%PICTCONV% %PARAMS% data\view_medicine_cabinet.png %TARGET%\medicine_cabinet.hir
%PICTCONV% %PARAMS% data\view_medicine_cabinet_open.png %TARGET%\medicine_cabinet_open.hir

%PICTCONV% %PARAMS% data\view_donkey_kong_top.png %TARGET%\donkey_kong_top.hir
%PICTCONV% %PARAMS% data\view_donkey_kong_playing.png %TARGET%\donkey_kong_playing.hir

%PICTCONV% %PARAMS% data\view_dog_eating_meat.png %TARGET%\dog_eating_meat.hir
%PICTCONV% %PARAMS% data\view_dove_eating_breadcrumbs.png %TARGET%\dove_eating_breadcrumbs.hir
%PICTCONV% %PARAMS% data\view_dog_chasing_dove.png %TARGET%\dog_chasing_dove.hir

%PICTCONV% %PARAMS% data\view_drawer_gun_cabinet.png %TARGET%\drawer_gun_cabinet.hir
%PICTCONV% %PARAMS% data\view_shooting_dart.png %TARGET%\shooting_dart.hir

%PICTCONV% %PARAMS% data\view_basement_window.png %TARGET%\basement_window.hir
%PICTCONV% %PARAMS% data\view_basement_window_darkened.png %TARGET%\basement_window_darkened.hir

%PICTCONV% %PARAMS% data\view_alarm_triggered.png %TARGET%\view_alarm_triggered.hir

:: Severn Software and Defence Force logos
%PICTCONV% %PARAMS% data\intro_defence-force_logo.png %TARGET%\logos.hir


:: Music
bin\SongToAky --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\music_intro.aks code\intro_music.s
bin\SongToAky --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\music_typewriter.aks code\intro_music_typewriter.s

bin\SongToEvents --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\music_intro.aks code\intro_music_events.s
bin\SongToEvents --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\music_typewriter.aks code\intro_music_typewriter_events.s

set OSDK_BUILD_END=%time%
call %OSDK%\bin\ComputeTime.bat
ECHO Assets conversion finished in %OSDK_BUILD_TIME%

::pause


