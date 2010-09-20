
#pragma warning( disable : 4996)   // #define _CRT_SECURE_NO_WARNINGS

extern void errout(int er);
extern void logout(char *s);

extern int gFlag_ncmos;
extern int gFlag_cmosfl;
extern int gFlag_w65816;
extern int gFlag_n65816;

extern int gFlagMasmCompatibilityMode;
extern int nolink;
extern int noglob;
extern int gFlag_ShowBlocks;
extern int relmode;

extern int SectionTextLenght;
extern int SectionTextBase;
extern int SectionBssLenght;
extern int SectionBssBase;
extern int SectionDataLenght;
extern int SectionDataBase;
extern int SectionZeroLenght;
extern int SectionZeroBase;

extern int romable;
extern int romadr;

extern int memode;
extern int xmode;
extern SEGMENT_e gCurrentSegment;
extern int TablePcSegment[_eSEGMENT_MAX_];

extern void set_align(int align_value);
extern int b_test(int n);

#define hashcode(n,l)  (n[0]&0x0f)|(((l-1)?(n[1]&0x0f):0)<<4)

