
#include "params.h"

#include "loader_api.h"

// Irq
extern void System_InstallIRQ_SimpleVbl();
extern void System_RestoreIRQ_SimpleVbl();
extern void WaitIRQ();


// Keyboard
extern char WaitKey();
extern char ReadKey();
extern char ReadKeyNoBounce();

extern unsigned char KeyBank[8]; // .dsb 8   ; The virtual Key Matrix


// Display
extern unsigned char ImageBuffer[40*200];

extern char Text_CopyrightSevernSoftware[];
extern char Text_CopyrightDefenceForce[];
extern char Text_FirstLine[];
extern char Text_HowToPlay[];
extern char Text_MovementVerbs[];
extern char Text_Notes[];


// Audio
extern void PlaySound(const char* registerList);

extern char PsgNeedUpdate;
extern char PsgVirtualRegisters[];
extern char ExplodeData[];
extern char ShootData[];
extern char PingData[];
extern char ZapData[];
extern char KeyClickHData[];
extern char KeyClickLData[];


// Common
extern void SetLineAddress(char* address);
extern void PrintLine(const char* message);
extern void Text(char paperColor,char inkColor);
extern void Hires(char paperColor,char inkColor);
extern void WaitFrames(int frames);

extern char gIsHires;
extern char* gPrintAddress;


