extern void exit(int retval);

extern int getchar(void);
extern int putchar(char c);
extern int printf(const char *format,...);
#ifdef __NOFLOAT__
#define printf2 printf
#else
extern int printf2(const char *format,...);
#endif

extern int isalpha(char c);
extern int isupper(char c);
extern int islower(char c);
extern int isdigit(char c);
extern int isspace(char c);
extern int ispunct(char c);
extern int isprint(char c);
extern int iscntrl(char c);
extern int isascii(char c);
extern char toupper(char c);
extern char tolower(char c);
extern char toascii(char c);
extern char *itoa(int i);

extern char* sbrk();
extern char* brk();

extern char *strcpy(char *s1,char * s2);
extern int strcmp(char *s1,char * s2);
extern int strlen(char *s);

extern int memcpy(char *dst, char *src, int n);

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
