
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

SET CONVERT=CALL bin\_PictConv

:: Hi-Score table
%XA% -o %TARGET%\scores.bin data\scores.s
%HEADER% -h1 %TARGET%\scores.bin %TARGET%\scores.tap $9c00

:: Character sets
SET PARAMS=-u1 -m0 -f0 -o2
SET TARGET_EXTENSION=.fnt
%CONVERT% font_6x8_mystery
%CONVERT% font_6x8_mystery_fr
%CONVERT% font_6x8_typewriter
%CONVERT% font_6x8_typewriter_fr


:: These are converted to source code and included in the code directly
SET TARGET_EXTENSION=.s     

:: 6x6 dither matrix
SET PARAMS=-u1 -m0 -f0 -o4;Pattern
%CONVERT% pattern_6x6_dither_matrix                     :: The 6x6 dither matrix used to do the image cross fades in the game
%CONVERT% pattern_typewriter_dithering                  :: The dithering pattern used to make the paper out of the typewriter appear darker

:: The 12x14 font
SET PARAMS=-u1 -m0 -f0 -o4;Font
%CONVERT% font_palatino_linotype_italics_size_10        :: The font used to draw the speech bubble (without any special characters)
%CONVERT% font_palatino_linotype_italics_size_10_fr     :: The font used to draw the speech bubble (variant with French special characters)

:: Arrow block (Temp file that needs to be copied in the display.s file)
SET PARAMS=-u1 -m0 -f0 -o4;ArrowBlockMasks
%CONVERT% masks_arrow_block                             :: Contains two 36x28 pixels elements: The top half should be ANDed and the bottom half to be ORed with the image


SET TARGET_EXTENSION=.hir

:: Title picture (colored)
SET PARAMS=-u1 -m0 -f6 -o2
%CONVERT% intro_title_picture

:: Intro graphics (black and white)
SET PARAMS=-u1 -m0 -f0 -o2
%CONVERT% intro_private_investigator
%CONVERT% intro_typewriter

:: Outro graphics (black and white)
SET PARAMS=-u1 -m0 -f0 -o2
%CONVERT% outro_desk



:: Masked out sprites
SET TARGET_EXTENSION=.msk
SET PARAMS=-u1 -m0 -f3 -o2
%CONVERT% masked_the_end
%CONVERT% masked_the_end_fr
%CONVERT% masked_dog
%CONVERT% masked_items
%CONVERT% masked_thug
%CONVERT% masked_safe_room
%CONVERT% masked_element_outro
%CONVERT% masked_element_outro_photos
%CONVERT% masked_element_outro_photos_fr


:: Here we have the list of 240x128 pictures for the various in-game locations
SET PARAMS=-u1 -m0 -f0 -o2
SET TARGET_EXTENSION=.hir

%CONVERT% no_picture

%CONVERT% loc_market_square
%CONVERT% loc_seedy_alley
%CONVERT% loc_road_stretch
%CONVERT% loc_tunel
%CONVERT% loc_main_street
%CONVERT% loc_east_road
%CONVERT% loc_inside_pit
%CONVERT% loc_well
%CONVERT% loc_wooded_avenue
%CONVERT% loc_gravel_drive
%CONVERT% loc_parking
%CONVERT% loc_garden
%CONVERT% loc_lawn
%CONVERT% loc_greenhouse
%CONVERT% loc_tennis_court
%CONVERT% loc_vegetable_plot
%CONVERT% loc_fish_pond
%CONVERT% loc_rear_entrance
%CONVERT% loc_orchard
%CONVERT% loc_dark_room
%CONVERT% loc_cellar
%CONVERT% loc_narrow_steps
%CONVERT% loc_lounge
%CONVERT% loc_entrance_hall
%CONVERT% loc_library
%CONVERT% loc_dinning_room
%CONVERT% loc_staircase
%CONVERT% loc_games_room
%CONVERT% loc_sun_lounge
%CONVERT% loc_kitchen
%CONVERT% loc_narrow_passage
%CONVERT% loc_guest_bedroom
%CONVERT% loc_child_bedroom
%CONVERT% loc_master_bedroom
%CONVERT% loc_shower_room
%CONVERT% loc_toilet
%CONVERT% loc_east_gallery
%CONVERT% loc_box_room
%CONVERT% loc_steel_door
%CONVERT% loc_bathroom
%CONVERT% loc_west_gallery
%CONVERT% loc_landing
%CONVERT% loc_outside_pit
%CONVERT% loc_study_room
%CONVERT% loc_basement_window_darkened

%CONVERT% font_6x8_mystery

:: Scene variants
%CONVERT% loc_dark_room_sunlight
%CONVERT% loc_basement_window_cleared

:: Other 240x128 full screen images which are not locations
%CONVERT% view_newspaper
%CONVERT% view_newspaper_fr
%CONVERT% view_handwritten_note
%CONVERT% view_handwritten_note_fr
%CONVERT% view_science_book
%CONVERT% view_chemistry_recipes
%CONVERT% view_united_kingdom_map
%CONVERT% view_fridge_door
%CONVERT% view_medicine_cabinet
%CONVERT% view_medicine_cabinet_open
%CONVERT% view_alarm_panel
%CONVERT% view_alarm_panel_open
%CONVERT% view_donkey_kong_top
%CONVERT% view_donkey_kong_playing
%CONVERT% view_dog_eating_meat
%CONVERT% view_dove_eating_breadcrumbs
%CONVERT% view_dog_chasing_dove
%CONVERT% view_drawer_gun_cabinet
%CONVERT% view_shooting_dart
%CONVERT% view_basement_window
%CONVERT% view_basement_window_darkened
%CONVERT% view_alarm_triggered

:: Severn Software and Defence Force logos
%CONVERT% intro_defence-force_logo


:: Music
bin\SongToAky --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\music_intro.aks code\intro_music.s
bin\SongToAky --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\music_typewriter.aks code\intro_music_typewriter.s

bin\SongToEvents --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\music_intro.aks code\intro_music_events.s
bin\SongToEvents --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\music_typewriter.aks code\intro_music_typewriter_events.s

set OSDK_BUILD_END=%time%
call %OSDK%\bin\ComputeTime.bat
ECHO Assets conversion finished in %OSDK_BUILD_TIME%

::pause


