//
// FloppyBuilder/Loader system
// Compatible with both C and Assembler modules
//
#include "../build/floppy_description.h"

#ifdef ASSEMBLER    // 6502 Assembler API
#define LoadFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoadApiLoadFileFromDirectory
#define SaveFileAt(fileIndex,address)          lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoadApiSaveFileFromDirectory
#define InitializeFileAt(fileIndex,address)    lda #fileIndex:sta _LoaderApiEntryIndex:lda #<address:sta _LoaderApiAddressLow:lda #>address:sta _LoaderApiAddressHigh:jsr _LoadApiInitializeFileFromDirectory

#else               // C Compiler API
extern unsigned char LoaderApiEntryIndex;
extern unsigned char LoaderApiAddressLow;
extern unsigned char LoaderApiAddressHigh;
extern void* LoaderApiAddress;

#define LoadFileAt(fileIndex,address)          LoaderApiEntryIndex=fileIndex;LoaderApiAddress=(void*)address;LoadApiLoadFileFromDirectory();
#define SaveFileAt(fileIndex,address)          LoaderApiEntryIndex=fileIndex;LoaderApiAddress=(void*)address;LoadApiSaveFileFromDirectory();
#define InitializeFileAt(fileIndex,address)    LoaderApiEntryIndex=fileIndex;LoaderApiAddress=(void*)address;LoadApiInitializeFileFromDirectory();

#endif
