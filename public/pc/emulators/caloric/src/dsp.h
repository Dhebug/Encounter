/*
 *	dsp.h
 *	AYM 2002-07-10
 */


#ifndef DSP_H
#define DSP_H


/* Sound output method */
enum
{
  AM_SDL,			/* let SDL select the best first (and native) */
  AM_ALSA,			/* ALSA or nothing */
  AM_ARTS,			/* libarts or nothing */
  AM_ARTS_OSS,			/* Try libarts first, fall back on OSS */
  AM_OSS			/* OSS or nothing */
};


extern int         audio_method;
extern int (*sound_write) (const char *buf, size_t bufsz);
extern int (*sound_close) (void);
extern char        sound;
extern const char *audio_device;


int sound_open (void);


#endif
