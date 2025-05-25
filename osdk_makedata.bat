
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
%XA% -DVERSION=%VERSION% -o %TARGET%\scores.bin data\scores.s
IF ERRORLEVEL 1 GOTO Error
%HEADER% -h1 %TARGET%\scores.bin %TARGET%\scores.tap $9c00

:: Character sets
SET PARAMS=-u1 -m0 -f0 -o2
SET TARGET_EXTENSION=.fnt
%CONVERT% font_6x8_mystery
%CONVERT% font_6x8_mystery_fr
%CONVERT% font_6x8_typewriter
%CONVERT% font_6x8_typewriter_fr

:: The 12x14 font
%CONVERT% font_palatino_linotype_italics_size_10        :: The font used to draw the speech bubble (without any special characters)
%CONVERT% font_palatino_linotype_italics_size_10_fr     :: The font used to draw the speech bubble (variant with French special characters)


:: These are converted to source code and included in the code directly
SET TARGET_EXTENSION=.s     

:: 6x6 dither matrix
SET PARAMS=-u1 -m0 -f0 -o4;Pattern
%CONVERT% pattern_6x6_dither_matrix                     :: The 6x6 dither matrix used to do the image cross fades in the game
%CONVERT% pattern_typewriter_dithering                  :: The dithering pattern used to make the paper out of the typewriter appear darker

:: Arrow block (Temp file that needs to be copied in the display.s file)
SET PARAMS=-u1 -m0 -f0 -o4;ArrowBlockMasks
%CONVERT% masks_arrow_block                             :: Contains two 36x28 pixels elements: The top half should be ANDed and the bottom half to be ORed with the image


SET TARGET_EXTENSION=.hir

:: Title picture (colored)
SET PARAMS=-u1 -m0 -f6 -o2
%CONVERT% intro_title_picture
%CONVERT% hires_monkey_king

:: Intro graphics (black and white)
SET PARAMS=-u1 -m0 -f0 -o2
%CONVERT% intro_private_investigator
%CONVERT% intro_typewriter
%CONVERT% intro_game_title
%CONVERT% intro_game_title_demo

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
%CONVERT% masked_car_parts
%CONVERT% masked_beep
%CONVERT% masked_panic_room_window
%CONVERT% masked_hole_with_knife
%CONVERT% masked_hole_with_rope
%CONVERT% masked_hole_with_cue
%CONVERT% masked_hole_with_girl_attached
%CONVERT% masked_hole_with_girl_free
%CONVERT% masked_hole_with_girl_free_fr
%CONVERT% masked_top_window
%CONVERT% masked_austin_parts
%CONVERT% masked_rough_map
%CONVERT% masked_rough_map_fr
%CONVERT% masked_alarm_panel


:: Here we have the list of 240x128 pictures for the various in-game locations
SET PARAMS=-u1 -m0 -f0 -o2
SET TARGET_EXTENSION=.hir

%CONVERT% no_picture

%CONVERT% loc_market_place
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
%CONVERT% loc_zen_garden
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
%CONVERT% loc_sun_lounge_demo
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
%CONVERT% loc_front_entrance
%CONVERT% loc_abandoned_car

%CONVERT% font_6x8_mystery

:: Scene variants
%CONVERT% loc_dark_room_sunlight
%CONVERT% loc_basement_window_cleared
%CONVERT% loc_steel_door_with_goggles

:: Other 240x128 full screen images which are not locations
%CONVERT% view_newspaper
%CONVERT% view_newspaper_fr
%CONVERT% view_handwritten_note
%CONVERT% view_handwritten_note_fr
%CONVERT% view_science_book
%CONVERT% view_chemistry_recipes
%CONVERT% view_chemistry_recipes_fr
%CONVERT% view_united_kingdom_map
%CONVERT% view_fridge_door
%CONVERT% view_medicine_cabinet
%CONVERT% view_medicine_cabinet_open
%CONVERT% view_alarm_panel
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
%CONVERT% view_mixtape
%CONVERT% view_rough_powder
%CONVERT% view_mortar_and_pestle
%CONVERT% view_safe_door
%CONVERT% view_safe_door_with_bomb
%CONVERT% view_safe_door_open
%CONVERT% view_explosion
%CONVERT% view_ready_to_blow
%CONVERT% view_sticky_bomb
%CONVERT% view_corrosive_liquid
%CONVERT% view_corrosive_liquid_fr
%CONVERT% view_watch
%CONVERT% view_protection_suit
%CONVERT% view_safety_gloves
%CONVERT% view_cue_with_rope
%CONVERT% view_panic_room_digicode
%CONVERT% view_panic_room_digicode_fr
%CONVERT% view_panic_room_clay
%CONVERT% view_panic_room_pouring_acid
%CONVERT% view_panic_room_acid_burning
%CONVERT% view_panic_room_hole
%CONVERT% view_panic_room_window
%CONVERT% view_top_window_closed
%CONVERT% view_austin_mini
%CONVERT% view_oric_computer
%CONVERT% view_news_saved
%CONVERT% view_news_saved_fr
%CONVERT% view_tombstone
%CONVERT% view_tombstone_fr
%CONVERT% view_colecovision_boot
%CONVERT% view_battery
%CONVERT% view_demo_message
%CONVERT% view_demo_message_fr

:: Special picture for the system information
%CONVERT% view_oric_motherboard

:: Severn Software and Defence Force logos
%CONVERT% intro_defence-force_logo


:: Music
SET CONVERT=CALL bin\_ArkosConv

:: These are exported as source code and compiled with the executable
%CONVERT% music_jingle splash_music
%CONVERT% music_intro intro_music

:: These are exported as binary files and loaded dynamicaly by the scripting system
:: The export address should be double checked with the map file
SET TARGET=build\files
SET TARGET_EXTENSION=.mus

SET EXPORT_ADDRESS=0xe940
%CONVERT% music_construction_complete success_music 2000
%CONVERT% music_game_over_good you_won_music 2000
%CONVERT% music_game_over_bad game_over_music 2000

SET EXPORT_ADDRESS=0xdf40
%CONVERT% music_typewriter intro_music_typewriter 2000



set OSDK_BUILD_END=%time%
call %OSDK%\bin\ComputeTime.bat
ECHO Assets conversion finished in %OSDK_BUILD_TIME%
goto End

:Error
ECHO.
ECHO %ESC%[41mAn Error has happened. Build stopped%ESC%[0m

:End



