//
// Floppy layout generated by FloppyBuilder 1.2
//

#ifdef ASSEMBLER
//
// Information for the Assembler
//
#ifdef LOADER
FileStartSector .byt 134,137,141,144,135,138,130,137,131,140,131,142,130,138,135,133,143,141,133,133,129,142,133,139,131,135,141,144,135,143,134,141,134,140,129,136,142,131,139,129,137,141,132,136,141,129,136,145,137,130,136,142
FileStartTrack .byt 0,0,0,0,2,2,3,3,4,4,5,5,6,6,7,8,8,9,10,11,12,12,13,13,14,14,14,14,15,15,16,16,17,17,18,18,18,19,19,20,20,20,21,21,21,22,22,22,23,24,24,24
FileSizeLow .byt <845,<1436,<768,<8000,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120,<5120
FileSizeHigh .byt >845,>1436,>768,>8000,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120,>5120
#undef LOADER
#endif // LOADER
#undef ASSEMBLER
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

#define FLOPPY_LOADER_TRACK 0   // Track where the loader is stored
#define FLOPPY_LOADER_SECTOR 4   // Sector where the loader is stored
#define FLOPPY_LOADER_ADDRESS 65024   // Address where the loader is loaded on boot ($fe00)

//
// List of files written to the floppy
//
// Entry #0 '..\build\files\IntroProgram.o'
// - Starts on  track 0 sector 6 and is 3 sectors long (535 compressed bytes: 63% of 845 bytes).
// Entry #1 '..\build\files\GameProgram.o'
// - Starts on  track 0 sector 9 and is 4 sectors long (1023 compressed bytes: 71% of 1436 bytes).
// Entry #2 '..\build\files\font_6x8_mystery.fnt'
// - Starts on  track 0 sector 13 and is 3 sectors long (546 compressed bytes: 71% of 768 bytes).
// Entry #3 '..\build\files\title.hir'
// - Starts on  track 0 sector 16 and is 25 sectors long (6308 compressed bytes: 78% of 8000 bytes).
// Entry #4 '..\build\files\NONE.hir'
// - Starts on  track 2 sector 7 and is 3 sectors long (607 compressed bytes: 11% of 5120 bytes).
// Entry #5 '..\build\files\1.hir'
// - Starts on  track 2 sector 10 and is 9 sectors long (2113 compressed bytes: 41% of 5120 bytes).
// Entry #6 '..\build\files\2.hir'
// - Starts on  track 3 sector 2 and is 7 sectors long (1792 compressed bytes: 35% of 5120 bytes).
// Entry #7 '..\build\files\3.hir'
// - Starts on  track 3 sector 9 and is 11 sectors long (2569 compressed bytes: 50% of 5120 bytes).
// Entry #8 '..\build\files\4.hir'
// - Starts on  track 4 sector 3 and is 9 sectors long (2275 compressed bytes: 44% of 5120 bytes).
// Entry #9 '..\build\files\5.hir'
// - Starts on  track 4 sector 12 and is 8 sectors long (1999 compressed bytes: 39% of 5120 bytes).
// Entry #10 '..\build\files\6.hir'
// - Starts on  track 5 sector 3 and is 11 sectors long (2662 compressed bytes: 51% of 5120 bytes).
// Entry #11 '..\build\files\7.hir'
// - Starts on  track 5 sector 14 and is 5 sectors long (1175 compressed bytes: 22% of 5120 bytes).
// Entry #12 '..\build\files\8.hir'
// - Starts on  track 6 sector 2 and is 8 sectors long (1870 compressed bytes: 36% of 5120 bytes).
// Entry #13 '..\build\files\9.hir'
// - Starts on  track 6 sector 10 and is 14 sectors long (3391 compressed bytes: 66% of 5120 bytes).
// Entry #14 '..\build\files\10.hir'
// - Starts on  track 7 sector 7 and is 15 sectors long (3796 compressed bytes: 74% of 5120 bytes).
// Entry #15 '..\build\files\11.hir'
// - Starts on  track 8 sector 5 and is 10 sectors long (2538 compressed bytes: 49% of 5120 bytes).
// Entry #16 '..\build\files\12.hir'
// - Starts on  track 8 sector 15 and is 15 sectors long (3639 compressed bytes: 71% of 5120 bytes).
// Entry #17 '..\build\files\13.hir'
// - Starts on  track 9 sector 13 and is 9 sectors long (2193 compressed bytes: 42% of 5120 bytes).
// Entry #18 '..\build\files\14.hir'
// - Starts on  track 10 sector 5 and is 17 sectors long (4305 compressed bytes: 84% of 5120 bytes).
// Entry #19 '..\build\files\15.hir'
// - Starts on  track 11 sector 5 and is 13 sectors long (3324 compressed bytes: 64% of 5120 bytes).
// Entry #20 '..\build\files\16.hir'
// - Starts on  track 12 sector 1 and is 13 sectors long (3263 compressed bytes: 63% of 5120 bytes).
// Entry #21 '..\build\files\17.hir'
// - Starts on  track 12 sector 14 and is 8 sectors long (1843 compressed bytes: 35% of 5120 bytes).
// Entry #22 '..\build\files\18.hir'
// - Starts on  track 13 sector 5 and is 6 sectors long (1344 compressed bytes: 26% of 5120 bytes).
// Entry #23 '..\build\files\19.hir'
// - Starts on  track 13 sector 11 and is 9 sectors long (2270 compressed bytes: 44% of 5120 bytes).
// Entry #24 '..\build\files\20.hir'
// - Starts on  track 14 sector 3 and is 4 sectors long (820 compressed bytes: 16% of 5120 bytes).
// Entry #25 '..\build\files\21.hir'
// - Starts on  track 14 sector 7 and is 6 sectors long (1283 compressed bytes: 25% of 5120 bytes).
// Entry #26 '..\build\files\22.hir'
// - Starts on  track 14 sector 13 and is 3 sectors long (751 compressed bytes: 14% of 5120 bytes).
// Entry #27 '..\build\files\23.hir'
// - Starts on  track 14 sector 16 and is 8 sectors long (1893 compressed bytes: 36% of 5120 bytes).
// Entry #28 '..\build\files\24.hir'
// - Starts on  track 15 sector 7 and is 8 sectors long (1968 compressed bytes: 38% of 5120 bytes).
// Entry #29 '..\build\files\25.hir'
// - Starts on  track 15 sector 15 and is 8 sectors long (1899 compressed bytes: 37% of 5120 bytes).
// Entry #30 '..\build\files\26.hir'
// - Starts on  track 16 sector 6 and is 7 sectors long (1723 compressed bytes: 33% of 5120 bytes).
// Entry #31 '..\build\files\27.hir'
// - Starts on  track 16 sector 13 and is 10 sectors long (2365 compressed bytes: 46% of 5120 bytes).
// Entry #32 '..\build\files\28.hir'
// - Starts on  track 17 sector 6 and is 6 sectors long (1468 compressed bytes: 28% of 5120 bytes).
// Entry #33 '..\build\files\29.hir'
// - Starts on  track 17 sector 12 and is 6 sectors long (1519 compressed bytes: 29% of 5120 bytes).
// Entry #34 '..\build\files\30.hir'
// - Starts on  track 18 sector 1 and is 7 sectors long (1583 compressed bytes: 30% of 5120 bytes).
// Entry #35 '..\build\files\31.hir'
// - Starts on  track 18 sector 8 and is 6 sectors long (1399 compressed bytes: 27% of 5120 bytes).
// Entry #36 '..\build\files\32.hir'
// - Starts on  track 18 sector 14 and is 6 sectors long (1503 compressed bytes: 29% of 5120 bytes).
// Entry #37 '..\build\files\33.hir'
// - Starts on  track 19 sector 3 and is 8 sectors long (1824 compressed bytes: 35% of 5120 bytes).
// Entry #38 '..\build\files\35.hir'
// - Starts on  track 19 sector 11 and is 7 sectors long (1570 compressed bytes: 30% of 5120 bytes).
// Entry #39 '..\build\files\36.hir'
// - Starts on  track 20 sector 1 and is 8 sectors long (1929 compressed bytes: 37% of 5120 bytes).
// Entry #40 '..\build\files\37.hir'
// - Starts on  track 20 sector 9 and is 4 sectors long (957 compressed bytes: 18% of 5120 bytes).
// Entry #41 '..\build\files\38.hir'
// - Starts on  track 20 sector 13 and is 8 sectors long (1812 compressed bytes: 35% of 5120 bytes).
// Entry #42 '..\build\files\39.hir'
// - Starts on  track 21 sector 4 and is 4 sectors long (947 compressed bytes: 18% of 5120 bytes).
// Entry #43 '..\build\files\40.hir'
// - Starts on  track 21 sector 8 and is 5 sectors long (1224 compressed bytes: 23% of 5120 bytes).
// Entry #44 '..\build\files\41.hir'
// - Starts on  track 21 sector 13 and is 5 sectors long (1254 compressed bytes: 24% of 5120 bytes).
// Entry #45 '..\build\files\42.hir'
// - Starts on  track 22 sector 1 and is 7 sectors long (1657 compressed bytes: 32% of 5120 bytes).
// Entry #46 '..\build\files\240.hir'
// - Starts on  track 22 sector 8 and is 9 sectors long (2122 compressed bytes: 41% of 5120 bytes).
// Entry #47 '..\build\files\241.hir'
// - Starts on  track 22 sector 17 and is 9 sectors long (2146 compressed bytes: 41% of 5120 bytes).
// Entry #48 '..\build\files\242.hir'
// - Starts on  track 23 sector 9 and is 10 sectors long (2483 compressed bytes: 48% of 5120 bytes).
// Entry #49 '..\build\files\340.hir'
// - Starts on  track 24 sector 2 and is 6 sectors long (1470 compressed bytes: 28% of 5120 bytes).
// Entry #50 '..\build\files\341.hir'
// - Starts on  track 24 sector 8 and is 6 sectors long (1467 compressed bytes: 28% of 5120 bytes).
// Entry #51 '..\build\files\342.hir'
// - Starts on  track 24 sector 14 and is 7 sectors long (1725 compressed bytes: 33% of 5120 bytes).
//
// 428 sectors used, out of 1428. (29% of the total disk size used)
//
#define LOADER_SECTOR_BUFFER $200
#define LOADER_BASE_ZERO_PAGE $F2
#define LOADER_INTRO_PROGRAM 0
#define LOADER_INTRO_PROGRAM_ADDRESS $400
#define LOADER_INTRO_PROGRAM_TRACK 0
#define LOADER_INTRO_PROGRAM_SECTOR 134
#define LOADER_INTRO_PROGRAM_SIZE 845
#define LOADER_INTRO_PROGRAM_SIZE_COMPRESSED 535
#define LOADER_PROGRAM_SECOND 1
#define LOADER_PROGRAM_SECOND_SIZE 1436
#define LOADER_PROGRAM_SECOND_SIZE_COMPRESSED 1023
#define LOADER_FONT_6x8 2
#define LOADER_PICTURE_TITLE 3
#define LOADER_PICTURE_LOCATIONS_START 4
#define LOADER_PICTURE_LOCATIONS_END 51

//
// Metadata
//
#ifdef METADATA_STORAGE

#endif // METADATA_STORAGE
