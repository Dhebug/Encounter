/* Oric specific routines, added by Vaggelis Blathras */

extern void hires(void);
extern void text(void);
extern void ping(void);
extern void shoot(void);
extern void zap(void);
extern void explode(void);
extern void kbdclick1(void);
extern void kbdclick2(void);
extern int ink(int color);
extern int paper(int color);
extern int curset(int x,int y,int mode);
extern int curmov(int dx,int dy,int mode);
extern int draw(int dx,int dy,int mode);
extern int circle(int radius,int mode);
extern int hchar(char c,int charset,int mode);
extern int fill(int height,int width,char c);
extern int point(int x,int y);
extern int pattern(char style);
extern int play(int soundchanels,int noisechanels,int envelop,int volume);
extern int music(int chanel,int octave,int key,int volume);
extern int sound(int chanel,int period,int volume);
extern char key(void);

/* Stuff added by Alexios Chouchoulas */

extern void cls();
extern void lores0(void);
extern void lores1(void);
extern int  peek(int address);
extern int  deek(int address);
extern void poke(int address, int value); /*  8 bit values */
extern void doke(int address, int value); /* 16 bit values */
extern void gotoxy(int x, int y); /* move the cursor: broken for the moment */
extern int  get(void);                     /* get character without echoing */
extern void cwrite(char c);                       /* write a byte to 'tape' */
extern int  cread();                             /* read a byte from 'tape' */
extern void cwritehdr();                     /* write a file header to tape */
extern void creadsync();           /* read synchro bytes (0x16) from 'tape' */
extern void call(int addr);                  /* call a machine code routine */

/* sedoric(): Please use the exclamation mark as well, e.g. sedoric("!DIR") */
/*            Bear in mind that this might well be broken. I don't know     */
/*            much about SEDORIC yet... No error handling! Anything wrong   */
/*            happens, and you get an error, and go back to the 'Ready'     */
/*            prompt. Can anyone fix things here? I declare my ignorance.   */

extern void sedoric(char *command);             /* invoke a sedoric command */


/* lprintf(): Like printf, but sends output to the printer. Maybe this and */
/*            printf() should be merged, I don't know...                   */

extern int  lprintf(const char *format,...);


#define TEXTVRAM    0xbb80
#define STDCHRTABLE 0xb400
#define ALTCHRTABLE 0xb800


#define GETPAPER    (peek(0x26b)-16)   /* return current paper colour */
#define GETINK      peek(0x26c)        /* return current ink colour */


/* This returns which dead key is currently pressed */
/* Use the #defines below to check for the keys     */

#define getdeadkeys() peek(0x209)

#define NOKEY       0x38
#define ALTGR       0xa0   /* Euphoric only */
#define CTRL        0xa2
#define LSHIFT      0xa4
#define FUNC        0xa5   /* Atmos only (and Euphoric, of course) */
#define RSHIFT      0xa7


/* Serial Attributes, curses style :-| */

#define A_FWBLACK        0
#define A_FWRED          1
#define A_FWGREEN        2
#define A_FWYELLOW       3
#define A_FWBLUE         4
#define A_FWMAGENTA      5
#define A_FWCYAN         6
#define A_FWWHITE        7
#define A_BGBLACK       16
#define A_BGRED         17
#define A_BGGREEN       18
#define A_BGYELLOW      19
#define A_BGBLUE        20
#define A_BGMAGENTA     21
#define A_BGCYAN        22
#define A_BGWHITE       23
#define A_STD            8
#define A_ALT            9
#define A_STD2H         10
#define A_ALT2H         11
#define A_STDFL         12
#define A_ALTFL         13
#define A_STD2HFL       14
#define A_ALT2HFL       15
#define A_TEXT60        24
#define A_TEXT50        26
#define A_HIRES60       28
#define A_HIRES50       30


/* This gets and sets some system flags    */
/* Use the #defines below to set the flags */

#define getflags()  peek(0x26a)
#define setflags(x) poke(0x26a,x)

#define CURSOR     0x01  /* Cursor on             (ctrl-q) */
#define SCREEN     0x02  /* Printout to screen on (ctrl-s) */
#define NOKEYCLICK 0x08  /* Turn keyclick off     (ctrl-f) */
#define PROTECT    0x20  /* Protect columns 0-1   (ctrl-]) */


/* Get memory size */

#define getmemsize() peek(0x220)

#define ORIC16k      1
#define ORIC48k      0


/* This copies a 40x25 buffer onto the screen. Very fast. */

#define dumpscreen(scr) memcpy((char*)textvram,(char*)scr,1120)

