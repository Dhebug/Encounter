:: Convert the frames
c:\tools\bin2txt.exe -s1 -f2 c64_frames.rw frames.s _picture_frames


:: Convert chuck in RGB picture
c:\tools\PictConv.exe -f1 -d0 -o2 trainer.png trainer.raw
c:\tools\PictConv.exe -f1 -d0 -o1 trainer.png trainer.hir


:: Convert and pack fighters
c:\tools\PictConv.exe -f0 -d0 -o2 fight_1.png temp.hir
c:\tools\FilePack -p temp.hir temp_pack.hir
c:\tools\bin2txt.exe -s1 -f2 temp_pack.hir f1.s _picture_fight_1

c:\tools\PictConv.exe -f0 -d0 -o2 fight_2.png temp.hir
c:\tools\FilePack -p temp.hir temp_pack.hir
c:\tools\bin2txt.exe -s1 -f2 temp_pack.hir f2.s _picture_fight_2

c:\tools\PictConv.exe -f0 -d0 -o2 fight_3.png temp.hir
c:\tools\FilePack -p temp.hir temp_pack.hir
c:\tools\bin2txt.exe -s1 -f2 temp_pack.hir f3.s _picture_fight_3

c:\tools\PictConv.exe -f0 -d0 -o2 fight_4.png temp.hir
c:\tools\FilePack -p temp.hir temp_pack.hir
c:\tools\bin2txt.exe -s1 -f2 temp_pack.hir f4.s _picture_fight_4

c:\tools\PictConv.exe -f0 -d0 -o2 fight_5.png temp.hir
c:\tools\FilePack -p temp.hir temp_pack.hir
c:\tools\bin2txt.exe -s1 -f2 temp_pack.hir f5.s _picture_fight_5

copy /b f1.s+f2.s+f3.s+f4.s+f5.s fighters.s


pause