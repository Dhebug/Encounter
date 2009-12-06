#ifndef _CONF_H
#define _CONF_H
// C Header File
// Created 19/08/2007; 15:58:29


//#define DEBUG_MUSIC 1



//#ifdef ATMOS
#include <lib.h>
//#endif

// disable gray display
#define NOGRAY 1

// disable double buffered gray display
//#define NODBGRAY 1

// turn on asserts
#define DEBUG 1

// disable fixed point math (use float instead; SLOW!)
//#define NOFPMATH 1

// use 8.8 fixed point instead of 16.16
#define FPMATH_8_8 1

// use M.F 16 bit fixed point instead of 16.16

//#define FPMATH_CUSTOM_16 1
/*#  define _FPM 10
#  define _FPF 6*/
//#  define _FPM 8
//#  define _FPF 8



/*---------------------------------------------------------------------------*/
/* speedy pixel access routines                                              */
/*---------------------------------------------------------------------------*/
// TI92: wid: 240 pix: 30 bytes, 8pix/byte
/*
#define PIXOFFSET(x,y)  ((y<<5)-(y<<1)+(x>>3))
#define PIXADDR(p,x,y)  (((unsigned char*)(p))+PIXOFFSET(x,y))
#define PIXMASK(x)      ((unsigned char)(0x80 >> ((x)&7)))
*/
// ORIC: wid: 240 pix: 40 bytes, 6pix/byte
//                       y * (32+8) + x / (4+2)
#define PIXOFFSET(x,y)  ((y<<5)+(y<<3)+(x/6))
#define PIXADDR(p,x,y)  (((unsigned char*)(p))+PIXOFFSET(x,y))
#define PIXMASK(x)      ((unsigned char)(0x20 >> ((x)%6)))

#define GETPIX(p,x,y)   (!(!(*PIXADDR(p,x,y) & PIXMASK(x))))
#define SETPIX(p,x,y)   (*PIXADDR(p,x,y) |=  PIXMASK(x))
#define CLRPIX(p,x,y)   (*PIXADDR(p,x,y) &= ~PIXMASK(x))
#define XORPIX(p,x,y)   (*PIXADDR(p,x,y) ^=  PIXMASK(x))
//#define SAFESETPIX(p,x,y)   ({ uint8 v = *PIXADDR(p,x,y); if (v & 0x40) { *PIXADDR(p,x,y) = v | PIXMASK(x); } })
//#define SAFECLRPIX(p,x,y)   ({ uint8 v = *PIXADDR(p,x,y); if (v & 0x40) { *PIXADDR(p,x,y) = v & ~PIXMASK(x); } })
#define SAFESETPIX(p,x,y)   (*PIXADDR(p,x,y) = (*PIXADDR(p,x,y) & 0x40) ? (*PIXADDR(p,x,y) | PIXMASK(x)) : *PIXADDR(p,x,y))
#define SAFECLRPIX(p,x,y)   (*PIXADDR(p,x,y) = (*PIXADDR(p,x,y) & 0x40) ? (*PIXADDR(p,x,y) & ~PIXMASK(x)) : *PIXADDR(p,x,y))


#define GR_BASE ((unsigned char *)0xa000)

/* OR with this to draw in hires (else you get attributes) */
#define GR_DM 0x40

#define GR_WIDTH  240
#define GR_HEIGHT 200
#define GR_BYTESIZE (240*200/6)
#define GR_STRIDE (240/6)

typedef signed long int myint;

typedef signed char int8;
typedef signed /*long*/ int int16;
typedef signed long int32;
//typedef signed long long int64;

typedef unsigned char uint8;
typedef unsigned int uint16;
typedef unsigned long uint32;
//typedef unsigned long long uint64;

extern uint8 * volatile p0;
extern uint8 * volatile p1;

extern void mymemset(void *p, myint to, int len);

#ifdef NOGRAY
#define NODBGRAY
#endif

#ifdef NOGRAY
#define GSAFESETPIX(x,y) SAFESETPIX(p0,x,y)
#define GSAFECLRPIX(x,y) SAFECLRPIX(p0,x,y)
#define GSETPIX(x,y) SETPIX(p0,x,y)
#define GCLRPIX(x,y) CLRPIX(p0,x,y)
#define GCLRSCR()	mymemset(p0,0x40,GR_BYTESIZE)
#define GWAITSYNC()
#else
#define GSETPIX(x,y) SETPIX(p0,x,y); SETPIX(p1,x,y)
#define GCLRPIX(x,y) CLRPIX(p0,x,y); CLRPIX(p1,x,y)
#define GCLRSCR()	memset(p0,0x00,LCD_SIZE); memset(p1,0x00,LCD_SIZE)
#define GWAITSYNC() GrayWaitNSwitches(1)
#endif

#define ngetchx getchar
#ifdef DEBUG
#define ASSERT(cond) if (!(cond)) { printf("ASSERT:%s\n", #cond); ngetchx(); exit(0); }
#define ASSERTF(cond,fmt,args) if (!(cond)) { printf("ASSERT:%s:" fmt "\n", #cond, args); ngetchx(); exit(1); }
#else
#define ASSERT(cond)
#define ASSERTF(cond,fmt,args)
#endif

#define STATICINLINE static


#define DO_HIRES() {hires(); is_hires=1;}
#define DO_TEXT() {text(); is_hires=0;}




#define VIA_T1CL 0x3e4
#define VIA_T1CH 0x3e5
#define VIA_T1LL 0x3e6
#define VIA_T1LH 0x3e7

#define VIA_T2CL 0x3e8
#define VIA_T2CH 0x3e9

#define VIA_ACR 0x3eb
#define VIA_PCR 0x3ec

/* misc.c */
extern int is_hires;
extern void spin(myint t);
void LZ77_UnCompress(unsigned char *buf_src,unsigned char *buf_dest);

/* Timer.s */
extern void StopInterrupt(void);
extern void RestoreInterrupt(void);


/* bmpfast.c */
extern void FastBitmapPutAligned(short x, short y, void *plane, const void *mask, const void *data);

/* sierp.c */
extern void do_sierp(void);
extern void do_roto_sierp(void);

/* alchimi7.c */
extern void do_splash(void);
extern void do_alchimie7(const char *text);
extern void do_alchimie7_1(void);
extern void do_alchimie7_2(void);
extern void do_alchimie7_3(void);
extern void do_alchimie7_4(void);

/* hexagones.c */
extern void do_hexagones(void);

/* sincos.c */
extern void do_sincos(void);

/* dos.c */
extern void do_dos(void);

/* win31.c */
extern void do_win31(void);

/* vxd.c */
extern void do_vxd(void);

/* credits.c */
extern void do_credits(void);

/* dash.c */
extern void dash_load_progress(char progress);
extern void dash_cpu(int cpu);
extern void dash_music_early(void);
extern void dash_music_slice(char pat, char line);

/* generiqu.c */
extern void do_generique(void);

extern unsigned char SsPicture[];
extern unsigned char VipPicture[];

/* fakess.c */
extern void fake_ss_start(void);
extern void fake_ss_end(void);
extern void fake_ss_tag_do(void);

/* music.c */
extern void music_start(void);
extern void music_end(void);
extern void music_till_once(void);
extern void music_till_end(void);
extern void music_till_end_pat(void);
extern int music_is_end(void);
extern int music_is_end_pat(void);
extern void music_set_1(void);
extern void music_set_2(void);


/* hrscroll.c */
extern void hires_scroll_text_set(const char *str, char color);
extern void hires_scroll_text_slice(char domusic);
extern char hires_scroll_text_is_once(void);

/* viptv.c */
extern void viptv_start(void);
extern void viptv_raster_slice(void);

/* equalizer.c */
extern void eq_init(void);
extern void eq_fini(void);
extern void eq_update(void);

extern void raster_start();
extern void raster_stop();
extern void raster_slice();

#endif
