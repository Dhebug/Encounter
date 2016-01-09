//
// FloppyBuilder/Loader system
// Compatible with both C and Assembler modules
//
#include "floppy_description.h"

#ifdef ASSEMBLER    // 6502 Assembler API
#define SetFileAddress(fileIndex,address)      ldx #fileIndex:lda #<address:ldy #>address:jsr $fff4
#define LoadFile(fileIndex)                    ldx #fileIndex:jsr $fff7
#define LoadFileAt(fileIndex,address)          ldx #fileIndex:lda #<address:ldy #>address:jsr $fff4:jsr $fff7

#else               // C Compiler API
extern unsigned char LoaderApiEntryIndex;
extern unsigned char LoaderApiAddressLow;
extern unsigned char LoaderApiAddressHigh;
extern char* LoaderApiAddress;

extern void SetLoadAddress();
extern void LoadFile();

#define SetFileAddress(fileIndex,address)      LoaderApiEntryIndex=fileIndex;LoaderApiAddress=address;LoaderApiSetLoadAddress();
#define LoadFile(fileIndex)                    LoaderApiEntryIndex=fileIndex;LoaderApiLoadFile();
#define LoadFileAt(fileIndex,address)          LoaderApiEntryIndex=fileIndex;LoaderApiAddress=address;LoaderApiSetLoadAddress();LoaderApiLoadFile();

#endif
