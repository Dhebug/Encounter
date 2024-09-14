//
// FloppyBuilder/Loader system
// Compatible with both C and Assembler modules
//
#include "../build/floppy_description.h"

#define LOADER_SYSTEM_TYPE_MICRODISC 0
#define LOADER_SYSTEM_TYPE_JASMIN    1

#ifdef ASSEMBLER    // 6502 Assembler API
#define LoadFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoadApiLoadFileFromDirectory
#define SaveFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoadApiSaveFileFromDirectory
#define InitializeFileAt(fileIndex,address)    lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoadApiInitializeFileFromDirectory

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

#define LoadFileAt(fileIndex,address)          LoaderApiEntryIndex=fileIndex;LoaderApiAddress=(void*)address;LoadApiLoadFileFromDirectory();
#define SaveFileAt(fileIndex,address)          LoaderApiEntryIndex=fileIndex;LoaderApiAddress=(void*)address;LoadApiSaveFileFromDirectory();
#define InitializeFileAt(fileIndex,address)    LoaderApiEntryIndex=fileIndex;LoaderApiAddress=(void*)address;LoadApiInitializeFileFromDirectory();

#define LoadFileUncompressedAt(fileIndex,address,compressedSize)  LoaderApiEntryIndex=fileIndex;LoadApiInitializeFileFromDirectory();LoaderApiAddress=(void*)address;LoaderApiFileSize=compressedSize;LoaderApiFileStartSector&=127;LoaderApiLoadFile();

#endif
