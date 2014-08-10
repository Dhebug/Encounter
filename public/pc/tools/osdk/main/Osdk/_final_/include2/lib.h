
void exit(int retval);

int getchar(void);
int putchar(char c);
int printf(const char *format,...);
char *itoa(int n);

int isalpha(char c);
int isupper(char c);
int islower(char c);
int isdigit(char c);
int isspace(char c);
int ispunct(char c);
int isprint(char c);
int iscntrl(char c);
int isascii(char c);
char toupper(char c);
char tolower(char c);
char toascii(char c);

char* sbrk();
char* brk();

char *strcpy(char *s1,const char * s2);
int strcmp(const char *s1,const char * s2);
int strlen(const char *s);

int memcpy(void *dst, void *src, int n);

/* Oric specific routines, added by Vaggelis Blathras */

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
char key(void);
char is_overlay_enabled();


/* Stuff added by Alexios Chouchoulas */

void cls();
void lores0(void);
void lores1(void);
void gotoxy(int x, int y); /* move the cursor: broken for the moment */
int  get(void);			   /* get character without echoing */
void cwrite(char c);			  /* write a byte to 'tape' */
int  cread();				 /* read a byte from 'tape' */
void cwritehdr();		     /* write a file header to tape */
void call(int addr);		     /* call a machine code routine */

/* sedoric(): Please use the exclamation mark as well, e.g. sedoric("!DIR") */
/*	      Bear in mind that this might well be broken. I don't know     */
/*	      much about SEDORIC yet... No error handling! Anything wrong   */
/*	      happens, and you get an error, and go back to the 'Ready'     */
/*	      prompt. Can anyone fix things here? I declare my ignorance.   */

void sedoric(char *command);		/* invoke a sedoric command */

/* Disk drive API - Work in progress 
void init_disk()
int sect_read(int sector_number, char * buffer);
int sect_write(int sector_number, char * buffer);
void switch_to_rom();
void switch_to_ram();
*/


/* lprintf(): Like printf, but sends output to the printer. Maybe this and */
/*	      printf() should be merged, I don't know...                   */

int  lprintf(const char *format,...);


/* Stuff added by Mickael Pointier */

void file_unpack(void *ptr_dst,void *ptr_src);

#define peek(address)		( *((unsigned char*)address) )
#define poke(address,value)	( *((unsigned char*)address)=(unsigned char)value )

#define deek(address)		( *((unsigned int*)address) )
#define doke(address,value)	( *((unsigned int*)address)=(unsigned int)value )


/* System data */

#define TEXTVRAM    0xbb80
#define STDCHRTABLE 0xb400
#define ALTCHRTABLE 0xb800


#define GETPAPER    (peek(0x26b)-16)   /* return current paper colour */
#define GETINK	    peek(0x26c)        /* return current ink colour */


/* This returns which dead key is currently pressed */
/* Use the #defines below to check for the keys     */

#define getdeadkeys() peek(0x209)

#define NOKEY	    0x38
#define ALTGR	    0xa0   /* Euphoric only */
#define CTRL	    0xa2
#define LSHIFT	    0xa4
#define FUNC	    0xa5   /* Atmos only (and Euphoric, of course) */
#define RSHIFT	    0xa7


/* Serial Attributes, curses style :-| */

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


/* This gets and sets some system flags    */
/* Use the #defines below to set the flags */

#define getflags()  peek(0x26a)
#define setflags(x) poke(0x26a,x)

#define CURSOR	   0x01  /* Cursor on		  (ctrl-q) */
#define SCREEN	   0x02  /* Printout to screen on (ctrl-s) */
#define NOKEYCLICK 0x08  /* Turn keyclick off	  (ctrl-f) */
#define PROTECT    0x20  /* Protect columns 0-1   (ctrl-]) */


/* Get memory size */

#define getmemsize() peek(0x220)

#define ORIC16k      1
#define ORIC48k      0

//static char *textvram=(char*)48000; /* pointer to the video RAM */


/* This copies a 40x25 buffer onto the screen. Very fast. */

#define dumpscreen(scr) memcpy((char*)textvram,(char*)scr,1120)



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
