//
// Floppy layout generated by FloppyBuilder 0.18
//

#ifdef ASSEMBLER
//
// Information for the Assembler
//
#ifdef LOADER
FileStartSector .byt 4,7,9,10,13,2,9
FileStartTrack .byt 0,0,0,0,0,1,1
FileStoredSizeLow .byt <768,<262,<38,<556,<1536,<1602,<1619
FileStoredSizeHigh .byt >768,>262,>38,>556,>1536,>1602,>1619
FileSizeLow .byt <768,<485,<38,<760,<1536,<8000,<8000
FileSizeHigh .byt >768,>485,>38,>760,>1536,>8000,>8000
FileLoadAdressLow .byt <64768,<49152,<49152,<39168,<0,<40960,<40960
FileLoadAdressHigh .byt >64768,>49152,>49152,>39168,>0,>40960,>40960
#endif // LOADER
#else
//
// Information for the Compiler
//
#endif

//
// Summary for this floppy building session:
//
#define FLOPPY_SIDE_NUMBER 2    // Number of sides
#define FLOPPY_TRACK_NUMBER 42    // Number of tracks
#define FLOPPY_SECTOR_PER_TRACK 17   // Number of sectors per track

//
// List of files written to the floppy
//
// Entry #0 '..\build\files\loader.o'
// - Loads at address 64768 starts on track 0 sector 4 and is 3 sectors long (768 bytes).
// Entry #1 '..\build\files\FirstProgram.o'
// - Loads at address 49152 starts on track 0 sector 7 and is 2 sectors long (262 compressed bytes: 54% of 485 bytes).
// Entry #2 '..\build\files\SecondProgram.o'
// - Loads at address 49152 starts on track 0 sector 9 and is 1 sectors long (38 bytes).
// Entry #3 '..\build\files\Font6x8.hir'
// - Loads at address 39168 starts on track 0 sector 10 and is 3 sectors long (556 compressed bytes: 73% of 760 bytes).
// Entry #4 'Reserved sectors'
// - Loads at address 0 starts on track 0 sector 13 and is 6 sectors long (1536 bytes).
// Entry #5 '..\build\files\FirstProgram.hir'
// - Loads at address 40960 starts on track 1 sector 2 and is 7 sectors long (1602 compressed bytes: 20% of 8000 bytes).
// Entry #6 '..\build\files\SecondProgram.hir'
// - Loads at address 40960 starts on track 1 sector 9 and is 7 sectors long (1619 compressed bytes: 20% of 8000 bytes).
//
// 32 sectors used, out of 1428. (2% of the total disk size used)
//
#define LOADER_PROGRAM_FIRST 1
#define LOADER_PROGRAM_SECOND 2
#define LOADER_FONT_6x8 3
#define LOADER_PICTURE_FIRSTPROGRAM 5
#define LOADER_PICTURE_FIRSTPROGRAM_SIZE 8000
#define LOADER_PICTURE_SECONDPROGRAM 6
#define LOADER_PICTURE_SECONDPROGRAM_SIZE 8000

//
// Metadata
//
#ifdef METADATA_STORAGE

#endif // METADATA_STORAGE

