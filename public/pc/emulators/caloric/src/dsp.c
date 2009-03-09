/*
 *	dsp.c - OS-dependent part of the sound output
 *	FF sometime in 1994-1997
 */

/*
  Parts of this file copyright 1994-1997 Fabrice Francès.
  Parts of this file copyright 2000-2003 André Majorel.
  Preliminary ALSA support     (c) 2007 Jean-Yves Lamoureux

  This program is free software; you can redistribute it and/or modify it under
  the terms of version 2 of the GNU General Public License as published by the
  Free Software Foundation.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along with
  this program; if not, write to the Free Software Foundation, Inc., 59 Temple
  Place, Suite 330, Boston, MA 02111-1307, USA.
*/

#include "config.h"
#include <errno.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#ifdef HAVE_SYS_IOCTL_H
#include <sys/ioctl.h>
#endif
#ifdef HAVE_SYS_PARAM_H
#include <sys/param.h>
#endif

#if HAVE_OSS
#  include <linux/soundcard.h>
#endif
#if HAVE_ARTS
#  include CONFIGURE_ARTSC_H
#endif
#if HAVE_ALSA
#  include <alsa/asoundlib.h>
#endif
#if HAVE_SDL
#  include <SDL/SDL_audio.h>
#endif

#include "caloric.h"
#include "dsp.h"

#define SAMPLES 512


#if HAVE_SDL
int sdl_open (void);
int sdl_write (const char *buf, size_t bufsz);
int sdl_close (void);
#endif
#if HAVE_ARTS
int arts_open (void);
int arts_write_caloric (const char *buf, size_t bufsz);
int arts_close (void);
#endif
#if HAVE_OSS
int oss_open (void);
int oss_write (const char *buf, size_t bufsz);
int oss_close (void);
#endif
#if HAVE_ALSA
int alsa_open (void);
int alsa_write (const char *buf, size_t bufsz);
int alsa_close (void);
#endif

int audio_method = AM_SDL; /* let SDL choose the best by default */
const char *audio_device = "/dev/dsp";
char sound;
int (*sound_write) (const char *buf, size_t bufsz) = NULL;
int (*sound_close) (void) = NULL;


/*
 *	sound_open - open the audio interface
 *
 *	Return 0 on success, non-zero on failure. Can also exit(1) if
 *	the requested audio method is not compiled in.
 */
int sound_open (void)
{
    sound = 0;

    if (audio_method == AM_SDL)
    {
#if HAVE_SDL
        if (sdl_open () == 0)
        {
            sound_write = sdl_write;
            sound_close = sdl_close;
            return 0;
        }
        return 1;
#else
        err ("this Caloric binary was compiled without SDL support"); /* !? */
        exit (1);
#endif
    }

    if (audio_method == AM_ARTS)
    {
#if HAVE_ARTS
        if (arts_open () == 0)
        {
            sound_write = arts_write_caloric;
            sound_close = arts_close;
            return 0;
        }
        return 1;
#else
        err ("this Caloric binary was compiled without aRts support");
        exit (1);
#endif
    }

    else if (audio_method == AM_ARTS_OSS)
    {
#if HAVE_ARTS
        if (arts_open () == 0)
        {
            sound_write = arts_write_caloric;
            sound_close = arts_close;
            return 0;
        }
#endif
#if HAVE_OSS
        if (oss_open () == 0)
        {
            sound_write = oss_write;
            sound_close = oss_close;
            return 0;
        }
#endif
        return 1;
    }

    else if (audio_method == AM_OSS)
    {
#if HAVE_OSS
        if (oss_open () == 0)
        {
            sound_write = oss_write;
            sound_close = oss_close;
            return 0;
        }
        return 1;
#else
        err ("this Caloric binary was compiled without OSS support");
        exit (1);
#endif
    }
    else if (audio_method == AM_ALSA)
    {
#if HAVE_ALSA
        if (alsa_open () == 0)
        {
            sound_write = alsa_write;
            sound_close = alsa_close;
            return 0;
        }
        return 1;
#else
#if HAVE_OSS
        if (oss_open () == 0)
        {
            sound_write = oss_write;
            sound_close = oss_close;
            return 0;
        }
#endif
#endif
    }
    else
    {
        err ("unknown audio output method %d", audio_method);
        return 1;
    }
}


#if HAVE_SDL
#define SDLBUFS 2
struct sdl_callback_data {
    Uint8 buffers[SDLBUFS][SAMPLES/* * sizeof(Uint8)*/];
    int head;
    int tail;
};

static struct sdl_callback_data sdl_data;

static void SDLCALL sdl_callback(void *userdata, Uint8 *stream, int len)
{
    struct sdl_callback_data *data;
    Uint8 *buffer;
    data = (struct sdl_callback_data *)userdata;
    if (data->head == data->tail) {
        memset(stream, 0, len);
        return;
    }
    buffer = data->buffers[data->head];
    data->head++;
    data->head %= SDLBUFS;
    memcpy(stream, buffer, len);
}

int sdl_open (void)
{
    int r;
    SDL_AudioSpec spec;

    /* 8-bit UNsigned PCM, 25600 Hz, mono */
    spec.freq = 50 * SAMPLES;
    spec.format = AUDIO_U8;
    spec.channels = 1;
    spec.silence = 0;
    spec.samples = SAMPLES;
    spec.padding = 0;
    spec.size = SAMPLES * sizeof(Uint8);
    spec.callback = &sdl_callback;
    spec.userdata = &sdl_data;

    r = SDL_OpenAudio(&spec, NULL/*&obtained*/);
    if (r != 0)
    {
        err ("sdl_init: can't obtain the requested format");
        return 1;
    }

    sound = 1;
    /* start playback */
    SDL_PauseAudio(0);
    return 0;
}


int sdl_write (const char *buf, size_t bufsz)
{
    int r = 1;

    /* mutex */
	SDL_LockAudio();
	
	/* if there is a buffer left */
	if (((sdl_data.tail + 1) % SDLBUFS) != sdl_data.head) {
	    Uint8 *buffer = sdl_data.buffers[sdl_data.tail];
	    if (bufsz > SAMPLES*sizeof(Uint8))
	    	bufsz = SAMPLES*sizeof(Uint8);
	    memcpy(buffer, buf, bufsz);
	    sdl_data.tail++;
	    sdl_data.tail %= SDLBUFS;
	    r = 0;
	} /* else drop */
	
	SDL_UnlockAudio();

    return r;
}


int sdl_close (void)
{
    if (sound)
    {
        SDL_CloseAudio();
    }
    return 0;
}
#endif


#if HAVE_ARTS
static arts_stream_t arts_stream;

int arts_open (void)
{
    int r;

    r = arts_init ();
    if (r != 0)
    {
        err ("arts_init: %s", arts_error_text (r));
        return 1;
    }

    sound = 1;
    /* 8-bit signed PCM, 25600 Hz, mono */
    arts_stream = arts_play_stream (50 * SAMPLES, 8, 1, "Caloric");
    /* Blocking sample length */
    arts_stream_set (arts_stream, ARTS_P_BUFFER_SIZE, SAMPLES);
    return 0;
}


int arts_write_caloric (const char *buf, size_t bufsz)
{
    int r;
    const char *p;
    const char *pmax;
    static char sbuf[SAMPLES];
    char *sp;

    /* Convert from unsigned to signed (JD says it "improves sound output") */
    p    = buf;
    pmax = buf + (bufsz > SAMPLES ? SAMPLES : bufsz);
    sp   = sbuf;
    while (p < pmax)
        *sp++ = *p++ - 128;

    r = arts_write (arts_stream, sbuf, bufsz);
    if (r != bufsz)
        return 1;
    return 0;
}


int arts_close (void)
{
    if (sound)
    {
        arts_close_stream (arts_stream);
        arts_free ();
    }
    return 0;
}
#endif



#if HAVE_OSS
int oss_fd = -1;

int oss_open (void)
{
    int dsp_fragsize  = 10;		/* log2 of fragment size in bytes */
    int dsp_fragcount = 10;		/* Number of fragments */
    int dsp_fragment  = (dsp_fragcount << 16) | dsp_fragsize;
    int dsp_fmt       = AFMT_U8;
    int dsp_stereo    = 0;
    int dsp_srate     = 50 * SAMPLES;

/*
  oss_fd=open("audio.out",O_WRONLY,0);
*/
    oss_fd = open(audio_device, O_WRONLY | O_NONBLOCK, 0);
    if (oss_fd == -1) {
        err("%s: %s", audio_device, strerror(errno));
        return 1;
    }
    sound=1;
    if (ioctl(oss_fd, SNDCTL_DSP_SETFMT, &dsp_fmt) == -1) {
        err("%s: can't set sample size (%s)", audio_device, strerror (errno));
        return 1;
    }
    if (ioctl(oss_fd, SNDCTL_DSP_STEREO, &dsp_stereo) == -1) {
        err("%s: can't set mono (%s)", audio_device, strerror (errno));
        return 1;
    }
    {
        int speed = dsp_srate;
        if (ioctl(oss_fd, SNDCTL_DSP_SPEED, &speed) == -1) {
            err("%s: can't set sample rate (%s)", audio_device, strerror (errno));
            return 1;
        }
        if (speed != dsp_srate) {
            err("%s: warning: sample rate set to %d Hz instead of %d Hz",
                audio_device, speed, dsp_srate);
        }
    }
    if (ioctl(oss_fd, SNDCTL_DSP_SETFRAGMENT, &dsp_fragment) == -1) {
        err("%s: can't set fragment (%s)", audio_device, strerror(errno));
        return 1;
    }

    /* Send 50 ms worth of silence so that the buffer never empties */
    {
        char buf[SAMPLES];

        memset (buf, 0, sizeof buf);
        write (oss_fd, buf, sizeof buf);
        write (oss_fd, buf, sizeof buf);
        write (oss_fd, buf, sizeof buf);
        write (oss_fd, buf, sizeof buf);
        write (oss_fd, buf, sizeof buf);
        write (oss_fd, buf, sizeof buf);
        write (oss_fd, buf, sizeof buf);
        write (oss_fd, buf, sizeof buf);
    }
    return 0;
}


int oss_write (const char *buf, size_t bufsz)
{
    if (! sound)
        return 0;

    if (write (oss_fd, buf, bufsz) == bufsz)
        return 0;
    return 1;
}


int oss_close (void)
{
    if (! sound)
        return 0;

    return close (oss_fd);
}
#endif
#if HAVE_ALSA
snd_pcm_t *playback_handle;

int alsa_open (void)
{
    int err;
    unsigned int rate = 25060, exact_rate;
    snd_pcm_hw_params_t *hwparams;

	if ((err = snd_pcm_open (&playback_handle, "default", SND_PCM_STREAM_PLAYBACK, 0)) < 0) {
        fprintf (stderr, "cannot open audio device %s (%s)\n",
				 "default",
				 snd_strerror (err));
        return 1;
    }
    snd_pcm_hw_params_alloca(&hwparams);
    if (snd_pcm_hw_params_any(playback_handle, hwparams) < 0) {
        fprintf(stderr, "Can not configure this PCM device.\n");
        return(-1);
    }
    if (snd_pcm_hw_params_set_access(playback_handle, hwparams, SND_PCM_ACCESS_RW_INTERLEAVED) < 0) {
        fprintf(stderr, "Error setting access.\n");
        return(-1);
    }
    if (snd_pcm_hw_params_set_format(playback_handle, hwparams, SND_PCM_FORMAT_U8) < 0) {
        fprintf(stderr, "Error setting format.\n");
        return(-1);
    }
    exact_rate = rate;
    if (snd_pcm_hw_params_set_rate_near(playback_handle, hwparams, &exact_rate, 0) < 0) {
        fprintf(stderr, "Error setting rate.\n");
        return(-1);
    }
    if (rate != exact_rate) {
        fprintf(stderr, "The rate %d Hz is not supported by your hardware.\n"
                " ==> Using %d Hz instead (sound may be crappy).\n", rate, exact_rate);
    }
    if ((err = snd_pcm_hw_params_set_channels(playback_handle, hwparams, 1)) < 0) {
        fprintf(stderr, "Error setting channels. %s\n", snd_strerror (err));
        return(-1);
    }
    if ((err = snd_pcm_hw_params(playback_handle, hwparams)) < 0) {
        fprintf(stderr, "Error setting HW params. %s\n", snd_strerror (err));
        return(-1);
    }

    snd_pcm_prepare (playback_handle);

    sound = 1;
    return 0;
}
int alsa_write (const char *buf, size_t bufsz)
{
    int err;

    if ((err = snd_pcm_writei (playback_handle, buf, bufsz)) != bufsz) {
        /* If it fails, do, erm, nothing but cleaning the mess */
        snd_pcm_prepare(playback_handle);
        return 0;
    }

    return bufsz;
}
int alsa_close (void)
{
    snd_pcm_close (playback_handle);
    return 1;
}
#endif
