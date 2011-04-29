./floppybuilder


./xa bootsector.asm
cp a.o65 bootsector.o
./xa loader.asm
cp a.o65 loader.o


./floppybuilder
./euphoric -d 1vip4.dsk

