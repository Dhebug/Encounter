@ECHO OFF
::
:: The idea is to run each of the OSDK tools to generate a particular set of data, 
:: and then check if the result matches a precomputed MD5.
::
:: If the result is the same, it means the version is correct (as far as the test suite is concerned).
:: If the results are different, it may mean:
:: - One of the tools is broken
:: - One of the tools generated data in an inconsistent way (it may not clean data correctly)
:: - One of the tools is inserting things that are run dependent (like a version number of time stamp)
:: - One of the tools may be generating more efficient things (like a more optimized compiler, or a better conversion algorithm for pictconv)
::
:: Whatever the result, it should be investigated before deploying a new version
::
:: In order to run this script, you have to make sure that the OSDK variable points to the set of tools you want to check
::

:: Clear variables
SET MD5CREATE=

:: Set the MD5 mode in check mode
::SET MD5CREATE=YES

:: Create the folders we need
md output >NUL
del /q /s output\*.* >NUL
pushd output 
md pictconv >NUL
popd

:: Pictconv testing
SET PICTCONV=%OSDK%\Bin\PictConv
SET PICTCONV_COLOR=%PICTCONV% -f1 -d0 -o2 -u1
SET PICTCONV_MONOCHROM=%PICTCONV% -f0 -f0 -o2
SET PICTCONV_MONOCHROM_SRC=%PICTCONV% -f0 -f0 -o2

%PICTCONV_COLOR% pictures\twilighte_im_title.png output\pictconv\twilighte_im_title.hir
%PICTCONV_COLOR% pictures\twilighte_whitehall.png output\pictconv\twilighte_whitehall.hir
%PICTCONV_COLOR% pictures\twilighte_im_sprites.png output\pictconv\twilighte_im_sprites.hir
%PICTCONV_COLOR% pictures\space_1999_sparks.png output\pictconv\space_1999_sparks.hir
%PICTCONV_COLOR% pictures\twilighte_otype_1.png output\pictconv\twilighte_otype_1.hir
%PICTCONV_COLOR% pictures\dbug_karhu.png output\pictconv\dbug_karhu.hir
%PICTCONV_COLOR% pictures\dbug_space1999_planets.png output\pictconv\dbug_space1999_planets.hir
%PICTCONV_COLOR% pictures\dbug_atmos_connectors.png output\pictconv\dbug_atmos_connectors.hir
%PICTCONV_COLOR% pictures\dbug_space1999.png output\pictconv\dbug_space1999.hir
%PICTCONV_COLOR% pictures\dbug_1337_logo.png output\pictconv\dbug_1337_logo.hir
%PICTCONV_COLOR% pictures\dbug_oric1.png output\pictconv\dbug_oric1.hir
%PICTCONV_COLOR% pictures\twilighte_tol_title.png output\pictconv\twilighte_tol_title.hir
%PICTCONV_COLOR% pictures\twilighte_tol_doors.png output\pictconv\twilighte_tol_doors.hir
%PICTCONV_COLOR% pictures\skooldaze.png output\pictconv\skooldaze.hir
%PICTCONV_COLOR% pictures\toxic_slime.png output\pictconv\toxic_slime.hir
%PICTCONV_COLOR% pictures\twilighte_ripped.png output\pictconv\twilighte_ripped.hir
%PICTCONV_COLOR% pictures\murder_on_the_atlantic.png output\pictconv\murder_on_the_atlantic.hir
%PICTCONV_COLOR% pictures\damsel.gif output\pictconv\damsel.hir
%PICTCONV_COLOR% pictures\dbug_windows95.gif output\pictconv\dbug_windows95.hir
%PICTCONV_COLOR% pictures\dbug_yessagician.gif output\pictconv\dbug_yessagician.hir
%PICTCONV_COLOR% pictures\diamond_2.gif output\pictconv\diamond_2.hir
%PICTCONV_COLOR% pictures\exocet_blueface.gif output\pictconv\exocet_blueface.hir
%PICTCONV_COLOR% pictures\exocet_fists.gif output\pictconv\exocet_fists.hir
%PICTCONV_COLOR% pictures\exocet_moonguy.gif output\pictconv\exocet_moonguy.hir
%PICTCONV_COLOR% pictures\karate_2.gif output\pictconv\karate_2.hir
%PICTCONV_COLOR% pictures\mooz_oric.gif output\pictconv\mooz_oric.hir
%PICTCONV_COLOR% pictures\mooz_supertomato.gif output\pictconv\mooz_supertomato.hir
%PICTCONV_COLOR% pictures\prez_story.gif output\pictconv\prez_story.hir
%PICTCONV_COLOR% pictures\tomb_1.gif output\pictconv\tomb_1.hir
%PICTCONV_COLOR% pictures\trois_mats.gif output\pictconv\trois_mats.hir
%PICTCONV_COLOR% pictures\twilighte_beast.gif output\pictconv\twilighte_beast.hir
%PICTCONV_COLOR% pictures\twilighte_dragons.gif output\pictconv\twilighte_dragons.hir
%PICTCONV_COLOR% pictures\twilighte_pegasus.gif output\pictconv\twilighte_pegasus.hir
%PICTCONV_COLOR% pictures\twilighte_sonix.gif output\pictconv\twilighte_sonix.hir
%PICTCONV_COLOR% pictures\mooz_barbitoric.gif output\pictconv\mooz_barbitoric.hir
%PICTCONV_COLOR% pictures\mondrian.png output\pictconv\mondrian.hir

%PICTCONV_COLOR% pictures\output-buffy.png  output\pictconv\output-buffy.hir
%PICTCONV_COLOR% pictures\output-homer.png  output\pictconv\output-homer.hir
%PICTCONV_COLOR% pictures\output-lena.png  output\pictconv\output-lena.hir
%PICTCONV_COLOR% pictures\Flowers.bmp output\pictconv\flowers_gloky.hir
%PICTCONV_COLOR% pictures\pinky-indecence.bmp output\pictconv\pinky-indecence.hir
%PICTCONV_COLOR% pictures\pinky-breast.bmp output\pictconv\pinky-breast.hir
%PICTCONV_COLOR% pictures\einstein.png output\pictconv\einstein.hir
%PICTCONV_COLOR% pictures\eastwood.bmp output\pictconv\eastwood.hir

%PICTCONV_COLOR% pictures\output-mire.png  output\pictconv\output-mire.hir

%PICTCONV_MONOCHROM% pictures\title_picture.png output\pictconv\title_picture.hir
%PICTCONV_MONOCHROM% pictures\title_picture_2.png output\pictconv\title_picture_2.hir
%PICTCONV_MONOCHROM% pictures\british_board_censors.png output\pictconv\british_board_censors.hir
%PICTCONV_MONOCHROM% pictures\Font6x8_ArtDeco.png output\pictconv\Font6x8_ArtDeco.hir
%PICTCONV_MONOCHROM% pictures\Font12x16_ArtDeco.png output\pictconv\Font12x16_ArtDeco.hir

%PICTCONV_MONOCHROM_SRC% pictures\loading_data.png output\pictconv\loading_data.s

::
:: Generates/checks the md5list
::
call:CheckTool pictconv

goto EndOk


:CheckTool
IF "%MD5CREATE%"=="YES" GOTO CreateMD5 

:CheckMD5
ECHO Checking MD5 list for %1
pushd output\%1
..\..\md5sum.exe --check ../../%1_md5list.txt >../md5checkoutput.txt
popd
IF ERRORLEVEL 1 GOTO Error
GOTO:EOF

:CreateMD5
ECHO Creating MD5 list for %1
pushd output\%1
md5sum *.* > ../../%1_md5list.txt
popd
IF ERRORLEVEL 1 GOTO Error
GOTO:EOF



:Error
ECHO.
ECHO !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR 
ECHO !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR 
ECHO !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR 
ECHO.
ECHO                One or more tool has returned an error code
ECHO --------------------------------------------------------------------------------
find "FAILED" output\md5checkoutput.txt
ECHO --------------------------------------------------------------------------------
ECHO.
ECHO !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR 
ECHO !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR 
ECHO !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR !! ERROR 
ECHO.
goto End


:EndOk
ECHO.
ECHO No error found
ECHO.
goto End


:End
pause
