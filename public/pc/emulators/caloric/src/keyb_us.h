/*
 *	keyb_us.h
 *	AYM 2003-03-01
 */

/*
This file is copyright André Majorel 2002-2003.

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


/* Oric keyboard keys in (more or less) human-readable form. The
   value of each symbol is 00cccrrr. Abbreviations :
     AP = apostrophe
     BA = backslash
     BL = left square bracket
     BR = right square bracket
     CO = comma
     CR = ctrl (right, as in Euphoric)
     CT = ctrl
     DE = del
     DO = down arrow
     EQ = equal
     ES = escape
     FS = full stop
     FU = func
     LS = left shift
     MI = minus
     RE = return
     RI = right arrow
     RS = right shift
     SE = semicolon
     SL = slash
     SP = space
     UP = up arrow */
typedef enum
{
  OK3 =070, OKX =060, OK1 =050,OKCR=040, OKV=030, OK5 =020, OKN =010, OK7 =000,
  OKD =071, OKQ =061, OKES=051,          OKF=031, OKR =021, OKT =011, OKJ =001,
  OKC =072, OK2 =062, OKZ =052,OKCT=042, OK4=032, OKB =022, OK6 =012, OKM =002,
  OKAP=073, OKBA=063,                   OKMI=033, OKSE=023, OK9 =013, OKK =003,
  OKRI=074, OKDO=064, OKLE=054,OKLS=044,OKUP=034, OKFS=024, OKCO=014, OKSP=004,
  OKBL=075, OKBR=065, OKDE=055,OKFU=045, OKP=035, OKO =025, OKI =015, OKU =005,
  OKW =076, OKS =066, OKA =056,          OKE=036, OKG =026, OKH =016, OKY =006,
  OKEQ=077,           OKRE=057,OKRS=047,OKSL=037, OK0 =027, OKL =017, OK8 =007,
} oric_rc_t;

void keyboard_dump (void);
void disable_keypad (void);
void enable_keypad (void);
