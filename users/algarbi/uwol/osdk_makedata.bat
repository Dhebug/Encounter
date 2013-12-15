:: Create the folders we need
md build
pushd build
md files
popd

::
:: Build data for the demo, is that a Slide Disk, or a Music Show?
::
SET BIN2TXT=%osdk%\bin\bin2txt

SET PICTCONV=%OSDK%\Bin\PictConv
::SET PICTCONV=D:\svn\public\pc\tools\osdk\main\Osdk\_final_\Bin\PictConv
SET PARAMS=-f1 -d0 -o2 -t1
SET PARAMS=-f1 -d0 -o2 
::goto EndPictures
%PICTCONV% %PARAMS% data\UWOLORIC.BMP build\files\uwoloric.hir
:EndPictures

pause

