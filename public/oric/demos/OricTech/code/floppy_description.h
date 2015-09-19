//
// Floppy layout generated by FloppyBuilder 0.17
//

#ifdef ASSEMBLER
//
// Information for the Assembler
//
#ifdef LOADER
FileStartSector .byt 4,7,3,17,3,5,15,2,3,1,11,17,2,6,4,7,9,14,4,13,3,1,10
FileStartTrack .byt 0,0,1,1,2,2,2,3,3,4,4,4,5,5,6,6,6,6,7,7,8,9,9
FileStoredSizeLow .byt <768,<3196,<3526,<556,<447,<2550,<920,<42,<3607,<2516,<1435,<463,<780,<3661,<697,<380,<1052,<1618,<2253,<1557,<3713,<2076,<1984
FileStoredSizeHigh .byt >768,>3196,>3526,>556,>447,>2550,>920,>42,>3607,>2516,>1435,>463,>780,>3661,>697,>380,>1052,>1618,>2253,>1557,>3713,>2076,>1984
FileSizeLow .byt <768,<12578,<14789,<760,<576,<8000,<3432,<50,<12173,<8000,<6144,<1733,<5376,<8812,<2002,<1585,<1543,<2643,<4556,<4397,<8978,<5267,<2680
FileSizeHigh .byt >768,>12578,>14789,>760,>576,>8000,>3432,>50,>12173,>8000,>6144,>1733,>5376,>8812,>2002,>1585,>1543,>2643,>4556,>4397,>8978,>5267,>2680
FileLoadAdressLow .byt <64768,<49152,<49152,<39168,<40960,<39168,<39168,<39168,<39168,<39168,<38912,<38912,<38912,<1024,<1024,<1024,<1024,<1024,<1024,<1024,<1024,<1024,<1024
FileLoadAdressHigh .byt >64768,>49152,>49152,>39168,>40960,>39168,>39168,>39168,>39168,>39168,>38912,>38912,>38912,>1024,>1024,>1024,>1024,>1024,>1024,>1024,>1024,>1024,>1024
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
// Entry #1 '..\build\files\intro.o'
// - Loads at address 49152 starts on track 0 sector 7 and is 13 sectors long (3196 compressed bytes: 25% of 12578 bytes).
// Entry #2 '..\build\files\techtech.o'
// - Loads at address 49152 starts on track 1 sector 3 and is 14 sectors long (3526 compressed bytes: 23% of 14789 bytes).
// Entry #3 '..\build\files\Font6x8.hir'
// - Loads at address 39168 starts on track 1 sector 17 and is 3 sectors long (556 compressed bytes: 73% of 760 bytes).
// Entry #4 '..\build\files\Font6x6.hir'
// - Loads at address 40960 starts on track 2 sector 3 and is 2 sectors long (447 compressed bytes: 77% of 576 bytes).
// Entry #5 '..\build\files\vip_rasters.hir'
// - Loads at address 39168 starts on track 2 sector 5 and is 10 sectors long (2550 compressed bytes: 31% of 8000 bytes).
// Entry #6 '..\build\files\cloud.hir'
// - Loads at address 39168 starts on track 2 sector 15 and is 4 sectors long (920 compressed bytes: 26% of 3432 bytes).
// Entry #7 '..\build\files\rain_drop.hir'
// - Loads at address 39168 starts on track 3 sector 2 and is 1 sectors long (42 compressed bytes: 84% of 50 bytes).
// Entry #8 '..\build\files\long_scroller.hir'
// - Loads at address 39168 starts on track 3 sector 3 and is 15 sectors long (3607 compressed bytes: 29% of 12173 bytes).
// Entry #9 '..\build\files\SoundWarning.hir'
// - Loads at address 39168 starts on track 4 sector 1 and is 10 sectors long (2516 compressed bytes: 31% of 8000 bytes).
// Entry #10 '..\build\files\VIPScroll.hir'
// - Loads at address 38912 starts on track 4 sector 11 and is 6 sectors long (1435 compressed bytes: 23% of 6144 bytes).
// Entry #11 '..\build\files\font_30x40.hir'
// - Loads at address 38912 starts on track 4 sector 17 and is 2 sectors long (463 compressed bytes: 26% of 1733 bytes).
// Entry #12 '..\build\files\overlay.hir'
// - Loads at address 38912 starts on track 5 sector 2 and is 4 sectors long (780 compressed bytes: 14% of 5376 bytes).
// Entry #13 '..\build\files\BoomTschak.raw'
// - Loads at address 1024 starts on track 5 sector 6 and is 15 sectors long (3661 compressed bytes: 41% of 8812 bytes).
// Entry #14 '..\build\files\SampleDefence.raw'
// - Loads at address 1024 starts on track 6 sector 4 and is 3 sectors long (697 compressed bytes: 34% of 2002 bytes).
// Entry #15 '..\build\files\SampleForce.raw'
// - Loads at address 1024 starts on track 6 sector 7 and is 2 sectors long (380 compressed bytes: 23% of 1585 bytes).
// Entry #16 '..\build\files\SampleHa.raw'
// - Loads at address 1024 starts on track 6 sector 9 and is 5 sectors long (1052 compressed bytes: 68% of 1543 bytes).
// Entry #17 '..\build\files\SampleYeah.raw'
// - Loads at address 1024 starts on track 6 sector 14 and is 7 sectors long (1618 compressed bytes: 61% of 2643 bytes).
// Entry #18 '..\build\files\SampleChimeLoopStart.raw'
// - Loads at address 1024 starts on track 7 sector 4 and is 9 sectors long (2253 compressed bytes: 49% of 4556 bytes).
// Entry #19 '..\build\files\SampleChimeLoopEnd.raw'
// - Loads at address 1024 starts on track 7 sector 13 and is 7 sectors long (1557 compressed bytes: 35% of 4397 bytes).
// Entry #20 '..\build\files\SampleMusicNonStop.raw'
// - Loads at address 1024 starts on track 8 sector 3 and is 15 sectors long (3713 compressed bytes: 41% of 8978 bytes).
// Entry #21 '..\build\files\SampleTechnoPop.raw'
// - Loads at address 1024 starts on track 9 sector 1 and is 9 sectors long (2076 compressed bytes: 39% of 5267 bytes).
// Entry #22 '..\build\files\ThalionIntro.mym'
// - Loads at address 1024 starts on track 9 sector 10 and is 8 sectors long (1984 compressed bytes: 74% of 2680 bytes).
//
// 170 sectors used, out of 1428. (11% of the total disk size used)
//
#define LOADER_INTRO 1
#define LOADER_TECHTECH 2
#define LOADER_FONT_6x8 3
#define LOADER_FONT_6x6 4
#define LOADER_VIP_LOGO 5
#define LOADER_VIP_LOGO_SIZE 8000
#define LOADER_CLOUD 6
#define LOADER_CLOUD_SIZE 3432
#define LOADER_RAINDROP 7
#define LOADER_RAINDROP_SIZE 50
#define LOADER_LONG_SCROLLER 8
#define LOADER_LONG_SCROLLER_SIZE 12173
#define LOADER_SOUND_WARNING 9
#define LOADER_SOUND_WARNING_SIZE 8000
#define LOADER_VIP_SCROLL 10
#define LOADER_VIP_SCROLL_SIZE 6144
#define LOADER_FONT_30x40 11
#define LOADER_FONT_30x40_SIZE 1733
#define LOADER_OVERLAY 12
#define LOADER_OVERLAY_SIZE 5376
#define LOADER_SAMPLE_BOOMTSCHACK 13
#define LOADER_SAMPLE_BOOMTSCHACK_SIZE 8812
#define LOADER_SAMPLE_DEFENCE 14
#define LOADER_SAMPLE_DEFENCE_SIZE 2002
#define LOADER_SAMPLE_FORCE 15
#define LOADER_SAMPLE_FORCE_SIZE 1585
#define LOADER_SAMPLE_HA 16
#define LOADER_SAMPLE_HA_SIZE 1543
#define LOADER_SAMPLE_YEAH 17
#define LOADER_SAMPLE_YEAH_SIZE 2643
#define LOADER_SAMPLE_CHIME_START 18
#define LOADER_SAMPLE_CHIME_START_SIZE 4556
#define LOADER_SAMPLE_CHIME_END 19
#define LOADER_SAMPLE_CHIME_END_SIZE 4397
#define LOADER_SAMPLE_MUSIC_NON_STOP 20
#define LOADER_SAMPLE_MUSIC_NON_STOP_SIZE 8978
#define LOADER_SAMPLE_TECHNO_POP 21
#define LOADER_SAMPLE_TECHNO_POP_SIZE 5267
#define LOADER_INTRO_MUSIC 22
#define LOADER_INTRO_MUSIC_SIZE 2680

//
// Metadata
//
#ifdef METADATA_STORAGE

#endif // METADATA_STORAGE
