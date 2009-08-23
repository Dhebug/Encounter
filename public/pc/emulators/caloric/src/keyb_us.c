/*
 *	keyb_us.c - keyboard input for Xeuphoric
 *	AYM 2002-01-22
 *  SDL modifications (c) 2007 Jean-Yves Lamoureux
 */

/*
  This file is copyright André Majorel 2002.

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


#include <limits.h>
#include <stdio.h>
#include <stdint.h>

#include <SDL/SDL.h>

#include "caloric.h"
#include "keyb_us.h"
#include "screenshot.h"

extern short Sys_Request;
extern long  cycles;
extern long  initial_cycles;

char env_screen;
char hard_screen;
char exit_menu;
unsigned char Kbd_Matrix[65];		/* FIXME should be 8 */
extern uint8_t setfullScreen, fullScreen;

static signed char keycode_to_oric[512];
extern char atmos;
extern char telestrat;
extern int current_machine;
extern int zoom_changed;
/*
 *	keyboard_map_init - initialise keycode_to_oric;
 */
void keyboard_map_init (void)
{
    {
        int n;

        for (n = 0; n < sizeof keycode_to_oric / sizeof *keycode_to_oric; n++)
            keycode_to_oric[n] = -1;
    }

    keycode_to_oric[SDLK_1]   = OK1;
    keycode_to_oric[SDLK_2]   = OK2;
    keycode_to_oric[SDLK_3]   = OK3;
    keycode_to_oric[SDLK_4]   = OK4;
    keycode_to_oric[SDLK_5]   = OK5;
    keycode_to_oric[SDLK_6]   = OK6;
    keycode_to_oric[SDLK_7]   = OK7;
    keycode_to_oric[SDLK_8]   = OK8;
    keycode_to_oric[SDLK_9]   = OK9;
    keycode_to_oric[SDLK_0]   = OK0;
    keycode_to_oric[SDLK_MINUS] = OKMI;
    keycode_to_oric[SDLK_EQUALS]  = OKEQ;
    keycode_to_oric[SDLK_BACKSLASH] = OKBA;	/* On many keyboards it's 2 rows down */

    keycode_to_oric[SDLK_ESCAPE] = OKES;
    keycode_to_oric[SDLK_TAB] = OKES;
    keycode_to_oric[SDLK_q]   = OKQ;
    keycode_to_oric[SDLK_w]   = OKW;
    keycode_to_oric[SDLK_e]   = OKE;
    keycode_to_oric[SDLK_r]   = OKR;
    keycode_to_oric[SDLK_t]   = OKT;
    keycode_to_oric[SDLK_y]   = OKY;
    keycode_to_oric[SDLK_u]   = OKU;
    keycode_to_oric[SDLK_i]   = OKI;
    keycode_to_oric[SDLK_o]   = OKO;
    keycode_to_oric[SDLK_p]   = OKP;
    keycode_to_oric[SDLK_LEFTBRACKET] = OKBL;
    keycode_to_oric[SDLK_RIGHTBRACKET] = OKBR;
    keycode_to_oric[SDLK_BACKSPACE]  = OKDE;

    keycode_to_oric[SDLK_CAPSLOCK] = OKCT;
    keycode_to_oric[SDLK_a]   = OKA;
    keycode_to_oric[SDLK_s]   = OKS;
    keycode_to_oric[SDLK_d]   = OKD;
    keycode_to_oric[SDLK_f]   = OKF;
    keycode_to_oric[SDLK_g]   = OKG;
    keycode_to_oric[SDLK_h]   = OKH;
    keycode_to_oric[SDLK_j]   = OKJ;
    keycode_to_oric[SDLK_k]   = OKK;
    keycode_to_oric[SDLK_l]   = OKL;
    keycode_to_oric[SDLK_SEMICOLON] = OKSE;
    keycode_to_oric[SDLK_QUOTE] = OKAP;
    keycode_to_oric[SDLK_RETURN] = OKRE;

    keycode_to_oric[SDLK_LSHIFT] = OKLS;
    keycode_to_oric[SDLK_LESS] = OKLS;	/* Not on all keyboards */
    keycode_to_oric[SDLK_z]   = OKZ;
    keycode_to_oric[SDLK_x]   = OKX;
    keycode_to_oric[SDLK_c]   = OKC;
    keycode_to_oric[SDLK_v]   = OKV;
    keycode_to_oric[SDLK_b]   = OKB;
    keycode_to_oric[SDLK_n]   = OKN;
    keycode_to_oric[SDLK_m]   = OKM;
    keycode_to_oric[SDLK_COMMA] = OKCO;
    keycode_to_oric[SDLK_PERIOD] = OKFS;
    keycode_to_oric[SDLK_SLASH] = OKSL;
    keycode_to_oric[SDLK_RSHIFT] = OKRS;

#if 0 /* same physical position but not usable at all */
    /* FIXME suited to 102-key keyboards (i.e. no windows keys) */
    keycode_to_oric[SDLK_LCTRL] = OKLE;
    keycode_to_oric[SDLK_LALT] = OKDO;
    keycode_to_oric[SDLK_SPACE] = OKSP;
    keycode_to_oric[SDLK_RALT] = OKUP;
    keycode_to_oric[SDLK_RCTRL] = OKRI;
#endif
    keycode_to_oric[SDLK_LCTRL] = OKCT;
    keycode_to_oric[SDLK_LALT] = OKFU;
    keycode_to_oric[SDLK_SPACE] = OKSP;
    keycode_to_oric[SDLK_RALT] = OKFU;
    keycode_to_oric[SDLK_RCTRL] = OKCR;

    /* Also map the PC cursor keys */
    keycode_to_oric[SDLK_UP]  = OKUP;
    keycode_to_oric[SDLK_LEFT] = OKLE;
    keycode_to_oric[SDLK_DOWN] = OKDO;
    keycode_to_oric[SDLK_RIGHT] = OKRI;

    /* PC function key */
    keycode_to_oric[SDLK_F1]  = -2;
    keycode_to_oric[SDLK_F2]  = -2;
    keycode_to_oric[SDLK_F3]  = -2;
    keycode_to_oric[SDLK_F4]  = -2;
    keycode_to_oric[SDLK_F5]  = -2;
    keycode_to_oric[SDLK_F6]  = -2;
    keycode_to_oric[SDLK_F7]  = -2;
    keycode_to_oric[SDLK_F8]  = -2;
    keycode_to_oric[SDLK_F9]  = -2;
    keycode_to_oric[SDLK_F10] = -2;
    keycode_to_oric[SDLK_F11] = -2;
    keycode_to_oric[SDLK_F12] = -2;

    /* FIXME no PC key maps to Oric func */
}


void keyboard_dump (void)
{
    int n;

    for (n = 0; n < sizeof keycode_to_oric / sizeof *keycode_to_oric; n++)
    {
        if (keycode_to_oric[n] < 0)
            continue;
        printf ("0x%02x %03o\n", n, keycode_to_oric[n]);
    }
}


void quit_handler (SDL_Event *ev)
{
    Sys_Request |= 0x2000;
    if (env_screen == 1)
        exit_menu = 1;
}


/*
 *	keyboard_handler - convert X11 keycode to Oric scan code
 */
void keyboard_handler (SDL_Event *ev)
{
    signed char oric_row_column;
    unsigned keycode = ev->key.keysym.sym;
fprintf(stderr, "SDL_KEY%s sym %d \n", (ev->type ==  SDL_KEYDOWN)?"DOWN":"UP", keycode);
    if (ev->type ==  SDL_KEYDOWN && keycode == 0x125)  /* F12 - screenshot */
    {
        fprintf(stderr, "Screenshot ...\n");
        screenshot ();
        return;
    }
    oric_row_column = keycode_to_oric[keycode];
    if (oric_row_column == -2) /* Function key */
        if (ev->type == SDL_KEYDOWN)
        switch (keycode)
        {
        case 0x11a :				/* F1 - setup screen */
            Sys_Request |= 0x8000;
            if (env_screen == 1)
                {
                    if (zoom!=zoom_changed)
                        {
                        zoom=zoom_changed;
                    // initSDL_display();
                        sdl_end();
                        sdl_start();
                        }
                if (current_machine==1 && atmos==0 && telestrat==0)
                    {
                    Init_Hard();
                    Load_ROM(Oric_Mem+0x10000);
                    Sys_Request |= 0x400;
                    }
                if (current_machine==1 && atmos==0 && telestrat==1)
                    {
                    Init_Hard();
                    Load_Banks();
                    Load_EPROM();
                    Restart();
                    Sys_Request |= 0x400;
                    }
                    //Restart();
                //current_machine
                exit_menu = 1;
                }
            return;
            break;
        case 0x11b :				/* F2 - sound switch */
            /* toggle_sound (); */
            if (hard_screen == 1)
                exit_menu = 1;
            return;
            break;
        case 0x11c :				/* F3 - keyboard toggle */
            /* toggle_keyboard (); */
            return;
            break;
        case 0x11d :				/* F4 - double clock */
            if (cycles < initial_cycles)
                cycles = initial_cycles;
            else if (cycles < LONG_MAX / 2)
                cycles *= 2;
            return;
            break;
        case 0x11e :				/* F5 - halve clock */
            if (cycles > initial_cycles)
                cycles = initial_cycles;
            else if (2 * (cycles / 2) == cycles)
                cycles /= 2;
            return;
            break;
        case 0x11f :				/* F6 - Jasmin boot */
            Sys_Request |= 0x200;
            if (env_screen == 1)
                exit_menu = 1;
            return;
            break;
        case 0x120 :				/* F7 - NMI */
            Sys_Request |= 0x400;
            if (env_screen == 1)
                exit_menu = 1;
            return;
            break;
        case 0x121 :				/* F8 - power on reset */
            Sys_Request |= 0x800;
            if (env_screen == 1)
                exit_menu = 1;
            return;
            break;
        case 0x122 :				/* F9 - dump */
            Sys_Request |= 0x1000;
            if (env_screen == 1)
                exit_menu = 1;
            return;
            break;
        case 0x123 :				/* F10 - quit */
            Sys_Request |= 0x2000;
            if (env_screen == 1)
                exit_menu = 1;
            return;
            break;
        case 0x124 :				/* F11 - toggle fullscreen */
            setfullScreen = !fullScreen;
            return;
            break;
        default :				/* Can't happen */
            err ("bad fn keycode %d\n", (int) keycode);
        }


    if (keycode < 0 || keycode > sizeof keycode_to_oric / sizeof *keycode_to_oric)
    {
        fprintf(stderr, "bad keycode %02x\n", (int) keycode);
        return;
    }

    else if (oric_row_column == -1)
    {
         return;
    }
    else
    {
        if (ev->type == SDL_KEYDOWN)
            Kbd_Matrix[oric_row_column & 7] |= 1 << (oric_row_column >> 3);
        else if (ev->type == SDL_KEYUP)
            Kbd_Matrix[oric_row_column & 7] &= ~ (1 << (oric_row_column >> 3));
        return;
    }
}


void disable_keypad (void)
{
    ;					/* FIXME */
}

void enable_keypad (void)
{
    ;					/* FIXME */
}


void Read_Joystick_on_printer_port (void)
{
    ;					/* FIXME */
}


void Read_Joystick_on_VIA2 (void)
{
    ;					/* FIXME */
}

