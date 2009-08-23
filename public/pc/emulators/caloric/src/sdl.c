/*
 *	sdl.c - SDL interface for Euphoric
 *	(c) 2007 Jean-Yves Lamoureux
 */

/*
  This file is copyright Jean-Yves Lamoureux 2007.

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
#if HAVE_SDL
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdarg.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <SDL/SDL.h>
#include <SDL/SDL_timer.h>
#include <SDL_ttf.h>

#include "caloric.h"
#include "hosttraps.h"
#include "stats.h"
#include "dsp.h"

extern volatile unsigned char Tick;
static long    palette[8]={0,0xFF0000,0x00FF00,0xFFFF00,0x0000FF,0xFF00FF,0x00FFFF,0xFFFFFF};
extern int zoom;
int zoomChange ;
char windowChanging = 0;
uint8_t scanlineEmulation = 0;
uint8_t oldEffect = 0;
uint8_t setfullScreen = 0, fullScreen = 0;
int count_frame=0;
time_t previoustime;


typedef struct {
    	int  red;
	int blue;

	int green;
} oriccolor;
oriccolor oriccolors[8];

SDL_Surface *screen;
   int border=20;

void display_frame (void);

int sdl_start()
{
    char title[1024];
    Uint32 flags = SDL_INIT_VIDEO|SDL_INIT_NOPARACHUTE|SDL_INIT_TIMER;
    Uint32 flags_video= SDL_HWPALETTE|SDL_HWACCEL|SDL_HWSURFACE|SDL_RLEACCEL; // Correcting full screen
    zoomChange = zoom;
    SDL_Rect **modes;
    int i;
    windowChanging=1;


    /* Init video blah */
    /*Get some infos from video card and resolution*/

 //zoom=2;
    if(fullScreen) {
    	flags |= SDL_FULLSCREEN;
    	flags_video ^= SDL_FULLSCREEN;
       // zoom=1; // We set zoom, we don't care zoom>1 if it's in full screen
        fprintf(stderr, "Full!\n");
    }
    if(audio_method == AM_SDL)
    	flags |= SDL_INIT_AUDIO;
    if (SDL_Init(flags) < 0) {
        fprintf(stderr, "Unable to init SDL: %s\n", SDL_GetError());
        return 0;
    }

const SDL_VideoInfo *pVideoInfo = SDL_GetVideoInfo();

if (!pVideoInfo) {
   printf("\n\t SDL_GetVideoInfo return NULL\n");
  }
#if HAVE_DEBUG_MODE
  else {


   printf("\thardware surfaces                   : %d\n", pVideoInfo->hw_available);
   printf("\twindow manager available            : %d\n", pVideoInfo->wm_available);
   printf("\thardware to hardware blits          : %d\n", pVideoInfo->blit_hw);
   printf("\thardware to hardware colorkey blits : %d\n", pVideoInfo->blit_hw_CC);
   printf("\thardware to hardware alpha blits    : %d\n", pVideoInfo->blit_hw_A);
   printf("\tsoftware to hardware blits          : %d\n", pVideoInfo->blit_sw);
   printf("\tsoftware to hardware colorkey blits : %d\n", pVideoInfo->blit_sw_CC);
   printf("\tsoftware to hardware alpha blits    : %d\n", pVideoInfo->blit_sw_A);
   printf("\tcolor fills accelerated             : %d\n", pVideoInfo->blit_fill);
   printf("\tTotal video memory Kilobytes        : %d\n", pVideoInfo->video_mem);
  }

#endif
modes=SDL_ListModes(NULL, SDL_FULLSCREEN|SDL_HWSURFACE|SDL_HWACCEL);

/* Check is there are any modes available */
if(modes == (SDL_Rect **)0){
  printf("No modes available!\n");
  exit(-1);
}

/* Check if or resolution is restricted */
#if HAVE_DEBUG_MODE

if(modes == (SDL_Rect **)-1){
  printf("All resolutions available.\n");
}
else{
  /* Print valid modes */
  printf("Available Modes\n");
  for(i=0;modes[i];++i)
    printf("  %d x %d\n", modes[i]->w, modes[i]->h);

}

#endif

    // calculate the best full screen mode
    //zoom=modes[0]->h/VIDEO_HEIGHT;

    /* 320x240x32 */

    screen = SDL_SetVideoMode(VIDEO_WIDTH*zoom, VIDEO_HEIGHT*zoom+border, 8, flags_video); //
    if ( screen == NULL ) {
        fprintf(stderr, "Unable to set %dx%dx32 video: %s\n", VIDEO_WIDTH*zoom, VIDEO_HEIGHT*zoom, SDL_GetError());
        return 0;
    }

    sprintf(title, "Caloric %s", VERSION);
    SDL_WM_SetCaption(title, NULL);

    windowChanging=0;
    return 1;
}

void sdl_end()
{
    windowChanging=1;
    SDL_FreeSurface(screen);
    screen = NULL;
    SDL_QuitSubSystem(SDL_INIT_VIDEO);
    SDL_Quit();
    windowChanging=0;
}

void sdl_display (void)
{
    windowChanging=1;
    SDL_Flip(screen);
    windowChanging=0;
}



void Reset_Screen (void)
{

    //initialised=1;
    display_frame ();
}

#define GET_R(a) ((a&0x00FF0000)>>16)&0xFF
#define GET_G(a) ((a&0x0000FF00)>>8)&0xFF
#define GET_B(a) (a&0x000000FF)&0xFF
#define RGB(r, g, b) (r<<16) | (g<<8) | (b)

/********************************************************/
/* BEGIN Jede Method*/
/********************************************************/

void initSDL_display()
{



oriccolors[0].red=0;
oriccolors[0].green=0;
oriccolors[0].blue=0;


oriccolors[1].red=255;
oriccolors[1].green=0;
oriccolors[1].blue=0;


oriccolors[2].red=0;
oriccolors[2].green=255;
oriccolors[2].blue=0;

oriccolors[3].red=255;
oriccolors[3].green=255;
oriccolors[3].blue=0;

oriccolors[4].red=0;
oriccolors[4].green=0;
oriccolors[4].blue=255;

oriccolors[5].red=255;
oriccolors[5].green=0;
oriccolors[5].blue=255;

oriccolors[6].red=0;
oriccolors[6].green=255;
oriccolors[6].blue=255;

oriccolors[7].red=255;
oriccolors[7].green=255;
oriccolors[7].blue=255;
/*
if(TTF_Init() == -1)
{
    fprintf(stderr, "Erreur d'initialisation de TTF_Init : %s\n", TTF_GetError());
    exit(EXIT_FAILURE);
}
*/
}

void DrawRect(SDL_Surface *screen, int x, int y, Uint8 R, Uint8 G, Uint8 B, int zoom)
{
  Uint32 color = SDL_MapRGB(screen->format, R, G, B);
    SDL_Rect position;
//  gdImageFilledRectangle(screen,x,y,x+zoom-1,y+zoom-1,color);

        //Uint32 color=0;
        position.x = x;
        position.y = y;
        position.w = zoom;
        position.h = zoom;
        SDL_FillRect(screen,&position, color);


  /*
  switch (screen->format->BytesPerPixel)
  {
    case 1: // Assuming 8-bpp
      {
        Uint8 *bufp;
        bufp = (Uint8 *)screen->pixels + y*screen->pitch + x;
        *bufp = color;
      }
      break;
    case 2: // Probably 15-bpp or 16-bpp
      {
        Uint16 *bufp;
        bufp = (Uint16 *)screen->pixels + y*screen->pitch/2 + x;
        *bufp = color;
      }
      break;
    case 3: // Slow 24-bpp mode, usually not used
      {
        Uint8 *bufp;
        bufp = (Uint8 *)screen->pixels + y*screen->pitch + x * 3;
        if(SDL_BYTEORDER == SDL_LIL_ENDIAN)
        {
          bufp[0] = color;
          bufp[1] = color >> 8;
          bufp[2] = color >> 16;
        } else {
          bufp[2] = color;
          bufp[1] = color >> 8;
          bufp[0] = color >> 16;
        }
      }
      break;
    case 4: // Probably 32-bpp
      {
        Uint32 *bufp;
        bufp = (Uint32 *)screen->pixels + y*screen->pitch/4 + x;
        *bufp = color;
      }
      break;*/
  }




//

void DrawPixel(SDL_Surface *screen, int x, int y,
                                    Uint8 R, Uint8 G, Uint8 B)
{

  Uint32 color = SDL_MapRGB(screen->format, R, G, B);
  switch (screen->format->BytesPerPixel)
  {
    case 1: // Assuming 8-bpp
      {
        Uint8 *bufp;
        bufp = (Uint8 *)screen->pixels + y*screen->pitch + x;
        *bufp = color;
      }
      break;
    case 2: // Probably 15-bpp or 16-bpp
      {
        Uint16 *bufp;
        bufp = (Uint16 *)screen->pixels + y*screen->pitch/2 + x;
        *bufp = color;
      }
      break;
    case 3: // Slow 24-bpp mode, usually not used
      {
        Uint8 *bufp;
        bufp = (Uint8 *)screen->pixels + y*screen->pitch + x * 3;
        if(SDL_BYTEORDER == SDL_LIL_ENDIAN)
        {
          bufp[0] = color;
          bufp[1] = color >> 8;
          bufp[2] = color >> 16;
        } else {
          bufp[2] = color;
          bufp[1] = color >> 8;
          bufp[0] = color >> 16;
        }
      }
      break;
    case 4: // Probably 32-bpp
      {
        Uint32 *bufp;
        bufp = (Uint32 *)screen->pixels + y*screen->pitch/4 + x;
        *bufp = color;
      }
      break;
  }
}


void lockscreenSDL_Display(SDL_Surface *screen)
{
  if ( SDL_MUSTLOCK(screen) )
  {
    if ( SDL_LockSurface(screen) < 0 )
    {
      return;
    }
  }
}

void unlockscreenSDL_Display(SDL_Surface *screen)
{
  if ( SDL_MUSTLOCK(screen) )
  {
    SDL_UnlockSurface(screen);
  }
}

void displaySDL_stats()
    {
    SDL_Surface  *texte = NULL, *fond = NULL;
/*
    time_t timenow;
    time_t seconds;
    char mychar[30]="";
    SDL_Color couleurRouge = {255, 0, 0};
    SDL_Color couleurNoire = {0, 0, 0};
    TTF_Font *police = NULL;
    SDL_Rect position;
    Uint32 color=0;
        position.x = 0;
        position.y = 0;
        position.w = VIDEO_WIDTH*zoom;
        position.h = border;
        SDL_FillRect(screen,&position, color);


police = TTF_OpenFont("verdana.ttf", 8);

if (police==NULL)
    {
        fprintf(stderr,"Can't find the ttf!!!!\n");
        exit(12);
    }
    time (&timenow);
    seconds = timenow - previoustime;
    sprintf(&mychar, "%f /s\0",  (float) count_frame/ seconds);
    //fprintf(stderr,"%d\n",stats.frames);
    //printf(
    texte = TTF_RenderText_Solid(police, mychar , couleurRouge);
    SDL_BlitSurface(texte, NULL, screen, &position);*/

  //fprintf (fp, "seconds %lu", (unsigned long) seconds);

  //fprintf (fp, ", frames %lu", stats.frames);
  //if (seconds != 0)
    //fprintf (fp, " (%.1f/s)", (double) stats.frames / seconds);
/*
  fprintf (fp, ", scanlines %lu", stats.scanlines);
  if (stats.frames != 0)
    fprintf (fp, " (%.1f/f)", (double) stats.scanlines / stats.frames);

  fprintf (fp, ", polls %lu", stats.polls);
  if (seconds != 0)
    fprintf (fp, " (%.1f/s)", (double) stats.polls / seconds);

TTF_CloseFont(police);
previoustime=timenow;
*/
    }

void displaySDL_run(void)
    {
    int x=0;
    int y=0;
    int calcul=0;
    int move_x=0;
    int move_y=0;
    render_frame ();
	if (frametouched) // if frame is modified let's go !
	{
    lockscreenSDL_Display(screen);
    if (zoom==1)
        {
        for (y=0;y<VIDEO_HEIGHT;y++)
            {
                if (buf[y * (VIDEO_WIDTH + 1) + VIDEO_WIDTH]==1)
                for (x=0;x<VIDEO_WIDTH;x++)
                    {
                    DrawPixel(screen, x, y+border,oriccolors[buf[calcul+x]].red, oriccolors[buf[calcul+x]].green, oriccolors[buf[calcul+x]].blue);
                    }
                calcul+=VIDEO_WIDTH+1;
            }
        }
    else
        {
        for (y=0;y<VIDEO_HEIGHT;y++)
            {
                if (buf[y * (VIDEO_WIDTH + 1) + VIDEO_WIDTH]==1)
                    {
                    for (x=0;x<VIDEO_WIDTH;x++)
                        {
                        DrawRect(screen, move_x, move_y+border,oriccolors[buf[calcul+x]].red, oriccolors[buf[calcul+x]].green, oriccolors[buf[calcul+x]].blue,zoom);
                        move_x+=zoom;
                        }
                    }
                move_x=0;
                calcul+=VIDEO_WIDTH+1;
                move_y+=zoom;
            }
        }
	unlockscreenSDL_Display(screen);
	count_frame++;
	displaySDL_stats();
	SDL_Flip(screen);


	}

	SDL_Delay(20);
//usleep(20000);
return;
}


/********************************************************/
/* END Jede Method*/
/********************************************************/

void display_frame (void)
{
    int x, y;
    int i = 0;
    int j = 0;
    uint8_t *src;
    uint32_t *dst;
    static uint32_t *tmp = NULL;
    static uint32_t *tmpback;
    uint8_t *bs;

/*
    if(zoomChange != zoom) {
        sdl_end();
        zoom = zoomChange;
        sdl_start();
    }
    */
    if(setfullScreen != fullScreen) {
        fullScreen = setfullScreen;

        sdl_end();

        sdl_start();
    render_frame_init();


    }
 // comment this 3 lines to use jylam method and uncoment from render_frame() to SDL_Delay(20); included
    displaySDL_run();
     poll_keyboard();
    return;




    /* Xeuphoric uses 1 byte at the end of each line,
       indicating a state change.
       We don't need that anymore */
       /*
    render_frame ();
    if(scanlineEmulation == 0) {
        src = (uint8_t *)buf;
        dst = (uint32_t *)screen->pixels;


        oldEffect = 0;
        if(zoom == 1) {
            for(y=0; y<VIDEO_HEIGHT; y++) {
                for(x=0; x<VIDEO_WIDTH; x++) {
                    *dst = palette[*src];
                    dst++;
                    src++;
                }
                src++;
            }
        } else {

            for(y=0; y<VIDEO_HEIGHT; y++) {
                for(i = 0; i < zoom; i++) {
                    bs = src;
                    for(x=0; x<VIDEO_WIDTH; x++) {
                        for(j = 0; j < zoom; j++) {
                            *dst = palette[*src];
                            dst++;
                        }
                        src++;
                    }
                    src = bs;
                }
                src+=(VIDEO_WIDTH+1);
            }
        }
    } else {
        // Scanline emulation
        if(oldEffect == 0) {
            if(tmp != NULL) {
                free(tmp);
            }
            sdl_end();
            zoom = 2;
            sdl_start();
            oldEffect = 1;
            if(tmp == NULL) {
                tmp = (uint32_t*)malloc((VIDEO_HEIGHT*2)*(VIDEO_WIDTH*2) * 4);
                tmpback = tmp;
            }
        } else {
        }

        src = (uint8_t *)buf;
        dst = (uint32_t *)screen->pixels;


        // Double the screen, making 1 scanline of 2 black
        for(y=0; y<VIDEO_HEIGHT; y++) {
            for(x=0; x<VIDEO_WIDTH; x++) {
                for(j = 0; j < zoom; j++) {
                    *dst = palette[*src];
                    dst++;
                }
                src++;
            }
            dst+=(VIDEO_WIDTH*2);
            src++;
        }

        // Blur midline
        dst = (uint32_t *)screen->pixels;
        dst+=VIDEO_WIDTH*2;
        for(y=1; y < (VIDEO_HEIGHT*2)-1; y+=2) {
            for(x=0; x<VIDEO_WIDTH*2; x++) {
                uint8_t r1 = GET_R(*(dst-(VIDEO_WIDTH*2)));
                uint8_t g1 = GET_G(*(dst-(VIDEO_WIDTH*2)));
                uint8_t b1 = GET_B(*(dst-(VIDEO_WIDTH*2)));
                uint8_t r2 = GET_R(*(dst+(VIDEO_WIDTH*2)));
                uint8_t g2 = GET_G(*(dst+(VIDEO_WIDTH*2)));
                uint8_t b2 = GET_B(*(dst+(VIDEO_WIDTH*2)));
                uint8_t r = (r1+r2)/3;
                uint8_t g = (g1+g2)/3;
                uint8_t b = (b1+b2)/3;

                *dst = RGB(r, g, b);
                dst++;
            }
            dst+=(VIDEO_WIDTH*2);
        }

        // Blend at right
        dst = (uint32_t *)screen->pixels;
        memcpy(tmp, dst, (VIDEO_HEIGHT*2)*(VIDEO_WIDTH*2)*4);
        for(y=VIDEO_WIDTH*2; y < ((VIDEO_HEIGHT*2) * (VIDEO_WIDTH*2))- (VIDEO_WIDTH*2); y++) {
            uint8_t r1 = GET_R(tmp[y]);
            uint8_t g1 = GET_G(tmp[y]);
            uint8_t b1 = GET_B(tmp[y]);
            uint8_t r2 = GET_R(tmp[y+1]);
            uint8_t g2 = GET_G(tmp[y+1]);
            uint8_t b2 = GET_B(tmp[y+1]);
            uint8_t r = (r1+r2)/2;
            uint8_t g = (g1+g2)/2;
            uint8_t b = (b1+b2)/2;
            tmp[y] = RGB(r, g, b);
        }


        dst++;
        tmp++;
        for(y=1; y < (VIDEO_HEIGHT*2); y++) {
            uint8_t decal = rand()%3;
            for(x=decal; x<(VIDEO_WIDTH*2);  x++) {
                uint8_t r1 = GET_R(*(dst));
                uint8_t g1 = GET_G(*(dst));
                uint8_t b1 = GET_B(*(dst));
                uint32_t v1 = (r1+g1)/2;
                uint8_t r2 = GET_R(*(tmp-decal));
                uint8_t g2 = GET_G(*(tmp-decal));
                uint8_t b2 = GET_B(*(tmp-decal));
                uint32_t v2 = (r2+g2)/2;
                uint8_t r;
                uint8_t g;
                uint8_t b;

                if(v2>v1) {
                    r = (r1+r2)/2;
                    g = (g1+g2)/2;
                    b = (b1+b2)/2;
                } else {
                    r = r1;
                    g = g1;
                    b = b1;
                }
                *tmp = RGB(r, g, b);
                dst+=1;
                tmp+=1;
            }
        }
        tmp = tmpback;
        memcpy(screen->pixels, tmp, (VIDEO_HEIGHT*2)*(VIDEO_WIDTH*2)*4);

    }
    sdl_display();
    poll_keyboard();
    SDL_Delay(20);    // max(1/50 Hz, 1/60 Hz) = 20 ms
    */
}
#else
#error You must have SDL to compile Xeuphoric
#endif
