:: Create the folders we need
md build
pushd disk_system
md demo
popd

:: Build the various parts of the demo
pushd part_hires_picture
call osdk_build.bat
popd

pushd part_motherboard_scroller
call osdk_build.bat
popd



cd disk_system

:: Call Makedisk once to create loader.cod
makedisk filetobuild.txt 

:: Call XA to rebuild the loader
%osdk%\bin\xa bootsector.asm -o demo\bootsector.o
%osdk%\bin\xa loader.asm -o demo\loader.o


:: Call Makedisk another time to build the final disk
makedisk filetobuild.txt default.dsk ..\build\BORN1983.dsk

cd ..


pause
