
: Demo Inside
pictconv -f0 -d0 -o2 pics\demoins.bmp demoins.bin
filepack demoins.bin demoins.t
bin2txt -s1 -f2 -n8 demoins.t demoins.s _DemoInsidePicture
del demoins.t
: pause
: uAlchimie2
: pictconv -f1 -d0 -o0 pics\ualch2.bmp ualch2.tap
: pictconv -f1 -d0 -n40 -o3 pics\ualch2.bmp ualch2.s
: pictconv -f1 -d0 -n40 -o4 pics\ualch2.bmp ualch2.c
pause
pictconv -f1 -d0 -o2 pics\ualch2.bmp ualch2.bin
filepack ualch2.bin ualch2.t
bin2txt -s1 -f2 -n8 ualch2.t ualch2.s _uAlchimie2Picture
del ualch2.t
