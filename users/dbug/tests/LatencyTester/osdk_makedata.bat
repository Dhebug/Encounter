@ECHO OFF


::SampleTweaker.exe samples\nyan_loop_4kz_8bit.raw sample.raw
%OSDK%\bin\Bin2Txt -s1 -f2 samples\sample.raw sample.s _WelcomeSample
echo _WelcomeSampleEnd >> sample.s 

::%OSDK%\bin\Bin2Txt -s1 -f2 graphics\font\128x256.raw texture.s _Texture128x256

::%OSDK%\bin\FilePack -p graphics\font\128x256.raw graphics\font\128x256.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 graphics\font\128x256.pak texture.s _Texture128x256Packed


pause
