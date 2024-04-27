
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
%PICTCONV% %PARAMS% data\font_6x8_mystery_fr.png %TARGET%\font_6x8_mystery_fr.fnt

%PICTCONV% %PARAMS% data\font_6x8_typewriter.png %TARGET%\font_6x8_typewriter.fnt
%PICTCONV% %PARAMS% data\font_6x8_typewriter_fr.png %TARGET%\font_6x8_typewriter_fr.fnt

:: 6x6 dither matrix
SET PARAMS=-u1 -m0 -f0 -o4_6x6DitherMatrix
%PICTCONV% %PARAMS% data\6x6_dither_matrix.png build\6x6_dither_matrix.s
%PICTCONV% %PARAMS% data\typewriter_dithering_pattern.png build\typewriter_dithering_pattern.s


:: The 12x14 font
:: palatino_linotype_italics_size_10_font.png
SET PARAMS=-u1 -m0 -f0 -o4Font12x14
%PICTCONV% %PARAMS% data\palatino_linotype_italics_size_10_font.png build\generated_12x14_font.s
%PICTCONV% %PARAMS% data\palatino_linotype_italics_size_10_font_fr.png build\generated_12x14_font_fr.s


:: Title picture
SET PARAMS=-u1 -m0 -f6 -o2
%PICTCONV% %PARAMS% data\title.png %TARGET%\title.hir

:: Intro graphics
SET PARAMS=-u1 -m0 -f0 -o2
%PICTCONV% %PARAMS% data\intro_private_investigator.png %TARGET%\intro_private_investigator.hir
%PICTCONV% %PARAMS% data\intro_typewriter.png %TARGET%\intro_typewriter.hir

:: Outro graphics
SET PARAMS=-u1 -m0 -f0 -o2
%PICTCONV% %PARAMS% data\outro_desk.png %TARGET%\outro_desk.hir


:: Arrow block (Temp file that needs to be copied in the display.s file)
SET PARAMS=-u1 -m0 -f0 -o4_ArrowBlockMasks
%PICTCONV% %PARAMS% data\arrow_block_masks.png build\mask.s


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
:: 1 - You are in a deserted market square
:: 2 - You are in a dark, seedy alley.
:: 3 - A long road stretches ahead of you.
:: 4 - You are in a dark, damp tunnel.
:: 5 - You are on the main street.
:: 6 - You are on a narrow path.
:: 7 - You have fallen into a deep pit
:: 8 - You are near to an old-fashioned well.
:: 9 - You are in a wooded avenue.
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
:: 43 - Outside a deep pit
SET PARAMS=-u1 -m0 -f0 -o2
%PICTCONV% %PARAMS% data\no_picture.png %TARGET%\NONE.hir
%PICTCONV% %PARAMS% data\loc_market_square.png %TARGET%\1.hir
%PICTCONV% %PARAMS% data\loc_seedy_alley.png %TARGET%\2.hir
%PICTCONV% %PARAMS% data\loc_road_stretch.png %TARGET%\3.hir
%PICTCONV% %PARAMS% data\loc_tunel.png %TARGET%\4.hir
%PICTCONV% %PARAMS% data\loc_main_street.png %TARGET%\5.hir
%PICTCONV% %PARAMS% data\loc_east_road.png %TARGET%\6.hir
%PICTCONV% %PARAMS% data\loc_inside_pit.png %TARGET%\7.hir
%PICTCONV% %PARAMS% data\loc_well.png %TARGET%\8.hir
%PICTCONV% %PARAMS% data\loc_wooded_avenue.png %TARGET%\9.hir
%PICTCONV% %PARAMS% data\loc_gravel_drive.png %TARGET%\10.hir
%PICTCONV% %PARAMS% data\loc_parking.png %TARGET%\11.hir
%PICTCONV% %PARAMS% data\loc_garden.png %TARGET%\12.hir
%PICTCONV% %PARAMS% data\loc_lawn.png %TARGET%\13.hir
%PICTCONV% %PARAMS% data\loc_greenhouse.png %TARGET%\14.hir
%PICTCONV% %PARAMS% data\loc_tennis_court.png %TARGET%\15.hir
%PICTCONV% %PARAMS% data\loc_vegetable_plot.png %TARGET%\16.hir
%PICTCONV% %PARAMS% data\loc_fish_pond.png %TARGET%\17.hir
%PICTCONV% %PARAMS% data\loc_rear_entrance.png %TARGET%\18.hir
%PICTCONV% %PARAMS% data\loc_orchard.png %TARGET%\19.hir
%PICTCONV% %PARAMS% data\loc_dark_room.png %TARGET%\20.hir
%PICTCONV% %PARAMS% data\loc_cellar.png %TARGET%\21.hir
%PICTCONV% %PARAMS% data\loc_narrow_steps.png %TARGET%\22.hir
%PICTCONV% %PARAMS% data\loc_lounge.png %TARGET%\23.hir
%PICTCONV% %PARAMS% data\loc_entrance_hall.png %TARGET%\24.hir
%PICTCONV% %PARAMS% data\loc_library.png %TARGET%\25.hir
%PICTCONV% %PARAMS% data\loc_dinning_room.png %TARGET%\26.hir
%PICTCONV% %PARAMS% data\loc_staircase.png %TARGET%\27.hir
%PICTCONV% %PARAMS% data\loc_games_room.png %TARGET%\28.hir
%PICTCONV% %PARAMS% data\loc_sun_lounge.png %TARGET%\29.hir
%PICTCONV% %PARAMS% data\loc_kitchen.png %TARGET%\30.hir
%PICTCONV% %PARAMS% data\loc_narrow_passage.png %TARGET%\31.hir
%PICTCONV% %PARAMS% data\loc_guest_bedroom.png %TARGET%\32.hir
%PICTCONV% %PARAMS% data\loc_child_bedroom.png %TARGET%\33.hir
%PICTCONV% %PARAMS% data\loc_master_bedroom.png %TARGET%\34.hir
%PICTCONV% %PARAMS% data\loc_shower_room.png %TARGET%\35.hir
%PICTCONV% %PARAMS% data\loc_toilet.png %TARGET%\36.hir
%PICTCONV% %PARAMS% data\loc_east_gallery.png %TARGET%\37.hir
%PICTCONV% %PARAMS% data\loc_box_room.png %TARGET%\38.hir
%PICTCONV% %PARAMS% data\loc_steel_door.png %TARGET%\39.hir
%PICTCONV% %PARAMS% data\loc_bathroom.png %TARGET%\40.hir
%PICTCONV% %PARAMS% data\loc_west_gallery.png %TARGET%\41.hir
%PICTCONV% %PARAMS% data\loc_landing.png %TARGET%\42.hir
%PICTCONV% %PARAMS% data\loc_outside_pit.png %TARGET%\43.hir

:: Other 240x128 full screen images which are not locations
%PICTCONV% %PARAMS% data\newspaper.png %TARGET%\newspaper.hir
%PICTCONV% %PARAMS% data\newspaper_fr.png %TARGET%\newspaper_fr.hir

%PICTCONV% %PARAMS% data\handwritten_note.png %TARGET%\handwritten_note.hir
%PICTCONV% %PARAMS% data\handwritten_note_fr.png %TARGET%\handwritten_note_fr.hir

%PICTCONV% %PARAMS% data\science_book.png %TARGET%\science_book.hir
%PICTCONV% %PARAMS% data\chemistry_recipes.png %TARGET%\chemistry_recipes.hir
%PICTCONV% %PARAMS% data\united_kingdom_map.png %TARGET%\united_kingdom_map.hir
%PICTCONV% %PARAMS% data\fridge_door.png %TARGET%\fridge_door.hir
%PICTCONV% %PARAMS% data\medicine_cabinet.png %TARGET%\medicine_cabinet.hir
%PICTCONV% %PARAMS% data\medicine_cabinet_open.png %TARGET%\medicine_cabinet_open.hir

%PICTCONV% %PARAMS% data\donkey_kong_top.png %TARGET%\donkey_kong_top.hir
%PICTCONV% %PARAMS% data\donkey_kong_playing.png %TARGET%\donkey_kong_playing.hir

%PICTCONV% %PARAMS% data\dog_eating_meat.png %TARGET%\dog_eating_meat.hir
%PICTCONV% %PARAMS% data\dove_eating_breadcrumbs.png %TARGET%\dove_eating_breadcrumbs.hir


:: Severn Software and Defence Force logos
%PICTCONV% %PARAMS% data\defence-force_logo.png %TARGET%\logos.hir

::pause


