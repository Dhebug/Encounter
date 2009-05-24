
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
extern SEGMENT_e segment;
extern int TablePcSegment[_eSEGMENT_MAX_];

extern int h_length(void);

extern void set_align(int align_value);

