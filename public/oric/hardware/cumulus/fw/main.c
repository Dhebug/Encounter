/* Cumulus 18F46K20 Firmware
 * Main.
 * Copyright 2010 Retromaster.
 * 
 *  This file is part of Cumulus Firmware.
 * 
 *  Cumulus Firmware is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License,
 *  or any later version. 
 *
 *  Cumulus Firmware is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Cumulus Firmware.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "global.h"
#include "sd-mmc.h"
#include "fat32.h"
#include "6610.h"
#include "179X.h"
#include "UI.h"
 
/* Config */
#pragma config FOSC = ECIO6
#pragma config FCMEN = OFF
#pragma config IESO = OFF
#pragma config PWRT = ON
#pragma config BOREN = OFF
#pragma config MCLRE = ON
#pragma config WDTEN = OFF
#pragma config LPT1OSC = OFF
#pragma config PBADEN = OFF
#pragma config STVREN = ON
#pragma config LVP = OFF 
#pragma config XINST = OFF
#pragma config DEBUG = OFF
#pragma config CP0 = OFF
#pragma config CP1 = OFF
#pragma config CP2 = OFF
#pragma config CP3 = OFF
#pragma config CPB = OFF
#pragma config CPD = OFF
#pragma config WRT0 = OFF
#pragma config WRT1 = OFF
#pragma config WRT2 = OFF
#pragma config WRT3 = OFF
#pragma config WRTB = OFF
#pragma config WRTC = OFF
#pragma config WRTD = OFF

#pragma udata
fat32_dir dir;
fat32_dir_entry root_dir;
fat32_dir_entry image_file;

/* Vector Remapping */
extern void _startup(void);        
#pragma code _RESET_INTERRUPT_VECTOR = 0x001000
void _reset (void)
{
    _asm goto _startup _endasm
}

#pragma code
void main(void) 
{
	uint8_t i, j, file_cnt;	

    OSCCON = 0x60;          // IRCFx = 110 (8 MHz)
    OSCTUNEbits.PLLEN = 1;  // x4 PLL enabled = 32MHz

	/* No Analog Pins */		
	ANSELH = 0x00;
	ANSEL = 0x00;

	// RESET low.
	PORTAbits.RA6 = 0;
	TRISAbits.TRISA6 = 0;

	// Initialize WD1793 emulation.
	wd179x_init();

	// Initialize User Interface.
	ui_init();

	// Initialize SD Card.
	card_init();
	fat32_init();

	/* Release RESET */
	PORTAbits.RA6 = 1;

	while (1)
	{
		/* See if a command request has arrived */
		if (PORTBbits.RB0 == 0)
		{
			/* So handle it */
			ui_wd1793_command_active();
			wd179X_handle_command_request();
			ui_wd1793_command_done();
		}
		else 
		{
			/* Do UI Stuff */
			ui_run();
		}
	}
} 