//
// FloppyBuilder/Loader system
// Compatible with both C and Assembler modules
//
#include "../build/floppy_description.h"

#define LOADER_SYSTEM_TYPE_MICRODISC 0
#define LOADER_SYSTEM_TYPE_JASMIN    1

#ifdef ASSEMBLER    // 6502 Assembler API
#define LoadFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoaderApiLoadFileFromDirectory
#define SaveFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoaderApiSaveFileFromDirectory
#define InitializeFileAt(fileIndex,address)    lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoaderApiInitializeFileFromDirectory

#else               // C Compiler API
extern unsigned char LoaderApiSystemType;  //  0=Microdisc, 1=Jasmin

extern unsigned char LoaderApiEntryIndex;
extern unsigned char LoaderApiAddressLow;
extern unsigned char LoaderApiAddressHigh;
extern void* LoaderApiAddress;

extern unsigned char LoaderApiFileSizeLow;
extern unsigned char LoaderApiFileSizeHigh;
extern unsigned int LoaderApiFileSize;

extern unsigned char LoaderApiFileStartSector;

extern char ModuleStartText;  // Assembly label — use &ModuleStartText for the address value

#define LoadFileAt(fileIndex,address)          LoaderApiEntryIndex=fileIndex;LoaderApiAddress=(void*)address;LoaderApiLoadFileFromDirectory();
#define SaveFileAt(fileIndex,address)          LoaderApiEntryIndex=fileIndex;LoaderApiAddress=(void*)address;LoaderApiSaveFileFromDirectory();
#define InitializeFileAt(fileIndex,address)    LoaderApiEntryIndex=fileIndex;LoaderApiAddress=(void*)address;LoaderApiInitializeFileFromDirectory();

#define LoadFileUncompressedAt(fileIndex,address,compressedSize)  LoaderApiEntryIndex=fileIndex;LoaderApiInitializeFileFromDirectory();LoaderApiAddress=(void*)address;LoaderApiFileSize=compressedSize;LoaderApiFileStartSector&=127;LoaderApiLoadFile();

#endif
