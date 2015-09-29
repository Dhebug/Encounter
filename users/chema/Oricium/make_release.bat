md RELEASE
copy /b BUILD\oricium.dsk RELEASE\Oricium12.dsk
copy /b loader.tap+screen.tap+BUILD\oricium.tap RELEASE\Oricium12.tap
%osdk%/bin/tap2cd -c BUILD\Oricium.tap RELEASE\Oricium12.wav
