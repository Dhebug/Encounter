//
// FloppyBuilder/Loader system
// Compatible with both C and Assembler modules
//
#include "../build/floppy_description.h"

#define LOADER_SYSTEM_TYPE_MICRODISC 0
#define LOADER_SYSTEM_TYPE_JASMIN    1

#ifdef ASSEMBLER    // 6502 Assembler API
#define LoadFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderEntryIndex:lda #<address:sta _LoaderAddressLow:lda #>address:sta _LoaderAddressHigh:jsr _LoadFileFromDirectory
#define SaveFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderEntryIndex:lda #<address:sta _LoaderAddressLow:lda #>address:sta _LoaderAddressHigh:jsr _SaveFileFromDirectory
#define InitializeFileAt(fileIndex,address)    lda #fileIndex:sta _LoaderEntryIndex:lda #<address:sta _LoaderAddressLow:lda #>address:sta _LoaderAddressHigh:jsr _InitializeFileFromDirectory

#else               // C Compiler API
extern unsigned char LoaderEntryIndex;
extern unsigned char LoaderAddressLow;
extern unsigned char LoaderAddressHigh;
extern void* LoaderAddress;

extern unsigned char LoaderFileSizeLow;
extern unsigned char LoaderFileSizeHigh;
extern unsigned int LoaderFileSize;

extern unsigned char LoaderFileStartSector;

extern char ModuleStartText;  // Assembly label — use &ModuleStartText for the address value

#define LoadFileAt(fileIndex,address)          LoaderEntryIndex=fileIndex;LoaderAddress=(void*)address;LoadFileFromDirectory();
#define SaveFileAt(fileIndex,address)          LoaderEntryIndex=fileIndex;LoaderAddress=(void*)address;SaveFileFromDirectory();
#define InitializeFileAt(fileIndex,address)    LoaderEntryIndex=fileIndex;LoaderAddress=(void*)address;InitializeFileFromDirectory();

#define LoadFileUncompressedAt(fileIndex,address,compressedSize)  LoaderEntryIndex=fileIndex;InitializeFileFromDirectory();LoaderAddress=(void*)address;LoaderFileSizeLow=(compressedSize&255);LoaderFileSizeHigh=((compressedSize>>8)&255);LoaderFileStartSector&=127;LoadData();

#endif
