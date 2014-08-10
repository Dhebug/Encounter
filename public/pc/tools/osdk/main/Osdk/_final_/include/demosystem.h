//
// This is the Demo System equivalent of <lib.h>
//
// The main difference is that the Demo System does not allow the usage of functions 
// that uses the ROM of the Oric, in order to guarantee that the demo would work on
// any model of Oric, and also to make sure that we can have full access to the 
// overlay memory.
//
// Also all the memory hungry functions have been disabled, if you forward declare 
// them they will be linked correctly, but this is highly not recommended!
//

//
// String functions
//
char *strcpy(char *s1,const char * s2);
int strcmp(const char *s1,const char * s2);
int strlen(const char *s);

//
// Memory manipulation
//
int memcpy(void *dst, void *src, int n);

//
// Depacking
//
void file_unpack(void *ptr_dst,void *ptr_src);


#define hires norom_hires


// Oric specific routines, added by Vaggelis Blathras
/*
void cls();
void hires(void);
void text(void);
void ping(void);
void shoot(void);
void zap(void);
void explode(void);
void kbdclick1(void);
void kbdclick2(void);
int ink(int color);
int paper(int color);
int curset(int x,int y,int mode);
int curmov(int dx,int dy,int mode);
int draw(int dx,int dy,int mode);
int circle(int radius,int mode);
int hchar(char c,int charset,int mode);
int fill(int height,int width,char c);
int point(int x,int y);
int pattern(char style);
int play(int soundchanels,int noisechanels,int envelop,int volume);
int music(int chanel,int octave,int key,int volume);
int sound(int chanel,int period,int volume);
void w8912(unsigned char reg,unsigned char value);
*/


// System data 
#define TEXTVRAM    0xbb80
#define STDCHRTABLE 0xb400
#define ALTCHRTABLE 0xb800

// Serial Attributes, curses style :-|
#define A_FWBLACK	 0
#define A_FWRED 	 1
#define A_FWGREEN	 2
#define A_FWYELLOW	 3
#define A_FWBLUE	 4
#define A_FWMAGENTA	 5
#define A_FWCYAN	 6
#define A_FWWHITE	 7
#define A_BGBLACK	16
#define A_BGRED 	17
#define A_BGGREEN	18
#define A_BGYELLOW	19
#define A_BGBLUE	20
#define A_BGMAGENTA	21
#define A_BGCYAN	22
#define A_BGWHITE	23
#define A_STD		 8
#define A_ALT		 9
#define A_STD2H 	10
#define A_ALT2H 	11
#define A_STDFL 	12
#define A_ALTFL 	13
#define A_STD2HFL	14
#define A_ALT2HFL	15
#define A_TEXT60	24
#define A_TEXT50	26
#define A_HIRES60	28
#define A_HIRES50	30


extern unsigned char OsdkTableMod6[];
extern unsigned char OsdkTableDiv6[];


//
// Some 'pseudo standard' library stuff
//
extern unsigned int randseedLow;
extern unsigned int randseedTop;
extern unsigned int pcrand();

#define srand(seed) if (0) {} else {randseedLow=(seed);randseedTop=0;}
#define rand() 		(rand32()?(randseedTop & 0x7fff):(randseedTop & 0x7fff))
