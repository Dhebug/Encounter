/* Cumulus 18F46K20 Firmware
 * Nokia 6610 LCD Controller Driver
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
#include "6610.h"

#include "delays.h"
#include "string.h"

#include "fonts.h"

static const rom uint8_t reverse_table[16] = {
0b0000,
0b1000,
0b0100,
0b1100,
0b0010,
0b1010,
0b0110,
0b1110,
0b0001,
0b1001,
0b0101,
0b1101,
0b0011,
0b1011,
0b0111,
0b1111
};

#pragma udata
/* Debugging */
uint8_t debug_line_cntr;
uint8_t debug_msg_cntr;

/* Text attributes */
static uint8_t invert_mode;
static rom uint8_t* font;
static uint8_t font_width;
static uint8_t font_height;
static uint8_t font_draw_height;
static uint8_t fill_patterns[12];

#pragma code
/* Initialize EUSART module used for 9-bit SPI transmission. */
static void init_EUSART(void)
{
	/* Set baud rate */
	BAUDCONbits.CKTXP = 1;
	BAUDCONbits.BRG16 = 0;
	SPBRGH = 0;
	SPBRG = 1;

	/* Set TRIS bits */
	TRISCbits.TRISC6 = 1;
	TRISCbits.TRISC7 = 1;
	
	/* Synchronous Master mode */
	TXSTAbits.SYNC = 1;
	TXSTAbits.CSRC = 1;
	RCSTAbits.SPEN = 1;
	 
	/* Receive disabled, transmit enabled */
	RCSTAbits.SREN = 0;
	RCSTAbits.CREN = 0;
	TXSTAbits.TXEN = 1;
	
	/* 9-bit transmission */
	TXSTAbits.TX9 = 1;
}

/* Write given command byte to LCD */
static void n6610_write_command(uint8_t command)
{
	uint8_t value;

	/* Move highest bit into TX9D */
	if (command & 0x80)
		TXSTAbits.TX9D = 1;
	else 
		TXSTAbits.TX9D = 0;

	/* Command byte */
 	value = (command << 1);	

	/* Wait until EUSART transmitter is free */
	while (!TXSTAbits.TRMT);
	TXREG = value;	
}

/* Write given data byte to LCD */
static void n6610_write_data(uint8_t data)
{
	uint8_t value;

	/* Move highest bit into TX9D */
	if (data & 0x80)
		TXSTAbits.TX9D = 1;
	else 
		TXSTAbits.TX9D = 0;

	/* Data byte */
	value = (data << 1) | 1;

	/* Wait until EUSART transmitter is free */
	while (!TXSTAbits.TRMT);
	TXREG = value;		
}

#ifdef PCF8833
/* Initialize LCD controller */
void n6610_init(void)
{
	/* Initialize EUSART module for 9-bit synchronous transmission */
	init_EUSART();

	/* Setup RST and CS pins */
	TRISCbits.TRISC0 = 0;
	TRISCbits.TRISC1 = 0;

	/* Reset */
	PORTCbits.RC1 = 0;
	Delay1KTCYx(1000);
	PORTCbits.RC1 = 1;
	Delay1KTCYx(1000);

	/* Chip Select */
	PORTCbits.RC0 = 0;
	
 	/* Sleep out  (command 0x11) */
 	n6610_write_command(SLEEPOUT); 

	/* Color Interface Pixel Format  (command 0x3A) */
 	n6610_write_command(COLMOD); 
 	n6610_write_data(0xC0);   /* 0x03 = 12 bits-per-pixel */

	/* Memory access controller  (command 0x36).   */
 	n6610_write_command(MADCTL); 
	n6610_write_data(0x06);   /* 0xE0 = mirror y, vertical, reverse rgb */

	/* Write contrast  (command 0x25) */
 	n6610_write_command(SETCON); 
	n6610_write_data(0x22);   /* contrast 0x40  */
	Delay1KTCYx(2); 

 	/* Display On  (command 0x29) */
  	n6610_write_command(DISPON);

	/* Debugging */
	debug_line_cntr = 0;
	debug_msg_cntr = 0;

	/* Text attributes */
	n6610_set_invert_mode(0);
	n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x0);
	n6610_set_font(FONT_6X8);
}
#endif


#ifdef S1D15G10
/* Initialize LCD controller */
void n6610_init(void)
{
	/* Initialize EUSART module for 9-bit synchronous transmission */
	init_EUSART();

	/* Setup RST and CS pins */
	TRISCbits.TRISC0 = 0;
	TRISCbits.TRISC1 = 0;

	/* Reset */
	PORTCbits.RC1 = 0;
	Delay1KTCYx(1000);
	PORTCbits.RC1 = 1;
	Delay1KTCYx(1000);

	/* Chip Select */
	PORTCbits.RC0 = 0;

	/* Display control */
 	n6610_write_command(DISCTL); 
 	n6610_write_data(0x00); // P1: 0x00 = 2 divisions, switching period=8 (default) 
	n6610_write_data(0x04); // P2: 0x20 = nlines/4 - 1 = 132/4 - 1 = 32) 
 	n6610_write_data(0x00); // P3: 0x00 = no inversely highlighted lines 
	
 	/* COM scan */
 	n6610_write_command(COMSCN); 
	n6610_write_data(0x80);  // P1: 0x01 = Scan 1->80, 160<-81 

	/* Internal oscilator ON */
 	n6610_write_command(OSCON); 
 
 	/* Sleep out */
 	n6610_write_command(SLPOUT); 

	/* Power control */
 	n6610_write_command(PWRCTR); 
	n6610_write_data(0xF0);   // reference voltage regulator on, circuit voltage follower on, BOOST ON 
 
 	/* Inverse display */
 	n6610_write_command(DISINV);

	/* Data control */
 	n6610_write_command(DATCTL); 
	n6610_write_data(0x60); // P1: 0x05 = page address normal, col address inverted, address scan in page direction 
	n6610_write_data(0x00); // P2: 0x00 = RGB sequence (default value) 
	n6610_write_data(0x40); // P3: 0x02 = Grayscale -> 16 (selects 12-bit color, type A) 

	/* Voltage control (contrast setting) */
 	n6610_write_command(VOLCTR); 
	n6610_write_data(0x24); // P1 = 32  volume value  (adjust this setting for your display  0 .. 63) 
	n6610_write_data(0xC0); // P2 = 3    resistance ratio  (determined by experiment) 
 
	/* allow power supply to stabilize */
 	Delay1KTCYx(100); 
 
 	/* turn on the display */
 	n6610_write_command(DISON); 

	/* Debugging */
	debug_line_cntr = 0;
	debug_msg_cntr = 0;

	/* Text attributes */
	n6610_set_invert_mode(0);
	n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x0);
	n6610_set_font(FONT_6X8);
}
#endif

static uint8_t reverse_bits(uint8_t value)
{
	uint8_t rev;

	rev = reverse_table[value & 0x0F] << 4;
	rev |= reverse_table[(value & 0xF0) >> 4];

	return rev;
}

/* Draws given area with given color. Area width must be multiple of 2. */
void n6610_fill_area(uint8_t x, uint8_t y, uint8_t w, uint8_t h)
{ 
	uint8_t i, j, v1, v2, v3;

	x = (x & 0xFE);
	w = (w & 0xFE);

  	/* Page address set */
	n6610_write_command(CASET); 
	n6610_write_data(reverse_bits(x)); 
	n6610_write_data(reverse_bits(x + w - 1)); 

	/* Column address set */
	n6610_write_command(PASET); 
 	n6610_write_data(reverse_bits(y)); 
	n6610_write_data(reverse_bits(y + h - 1)); 
 
 	/* Fill memory */
 	n6610_write_command(RAMWR); 
	
	for (i = 0; i < w / 2; i ++)
 		for (j = 0; j < h; j ++)
		{
			n6610_write_data(fill_patterns[0]);
			n6610_write_data(fill_patterns[1]);
			n6610_write_data(fill_patterns[2]);
		}
} 

/* Draws given character in b/w using the 6x8 Font. */
void n6610_draw_char(uint8_t x, uint8_t y, char c)
{ 
	uint8_t i, j, v;
	rom unsigned char* char_base;

	c -= 31;

	x = (x & 0xFE) | 0x01;

  	/* Page address set */
	n6610_write_command(CASET); 
	n6610_write_data(reverse_bits(x + 1)); 
	n6610_write_data(reverse_bits(x + font_width)); 

	/* Column address set */
	n6610_write_command(PASET); 
 	n6610_write_data(reverse_bits(y)); 
	n6610_write_data(reverse_bits(y + font_height - 1)); 
 
 	/* Fill memory */
 	n6610_write_command(RAMWR); 

	char_base = font + ((uint16_t) c) * font_height;
	for (i = 0; i < font_draw_height; i ++)
	{
		v = char_base[i];
		if (invert_mode)
			v = ~v;

		for (j = 0; j < font_width / 2; j ++)
		{				
			switch (v & 0xC0)
			{
			case 0x00:
				n6610_write_data(fill_patterns[0]);
				n6610_write_data(fill_patterns[1]);
				n6610_write_data(fill_patterns[2]);
				break;
			case 0x40:
				n6610_write_data(fill_patterns[3]);
				n6610_write_data(fill_patterns[4]);
				n6610_write_data(fill_patterns[5]);
				break;
			case 0x80: 
				n6610_write_data(fill_patterns[6]);
				n6610_write_data(fill_patterns[7]);
				n6610_write_data(fill_patterns[8]);
				break;
			case 0xC0:
				n6610_write_data(fill_patterns[9]);
				n6610_write_data(fill_patterns[10]);
				n6610_write_data(fill_patterns[11]);
				break;
			}

			v = v << 2;
		}
	}
} 

/* Draws given string in b/w using the 6x8 font */
void n6610_draw_rom_str(uint8_t x, uint8_t y, const far rom char* c)
{
	while (*c)
	{
		n6610_draw_char(x, y, *c);
		c ++;
		x += font_width;
	}
}

/* Draws given string in b/w using the 6x8 font */
void n6610_draw_ram_str(uint8_t x, uint8_t y, const char* c)
{
	while (*c)
	{
		n6610_draw_char(x, y, *c);
		c ++;
		x += font_width;
	}
}

/* Hex conversion lookup */
#pragma romdata
rom char hex_lookup[16] = 
{ 
	'0', '1', '2', '3', 
	'4', '5', '6', '7', 
	'8', '9', 'A', 'B', 
	'C', 'D', 'E', 'F' 
};

#pragma code
/* Puts a debugging message on video output */
void n6610_debug_message_ram(const char* msg)
{
	int8_t j;
	uint8_t val;

	n6610_draw_ram_str(16, debug_line_cntr * 8 + 2, msg);
		
	/* Print out value in hex */
	val = debug_msg_cntr;
	for (j = 1; j >= 0; j --)
	{
		n6610_draw_char(j * 6 + 2, debug_line_cntr * 8 + 2, hex_lookup[val & 0xF]);
		val = val >> 4;
	}

	/* Next line */
	debug_msg_cntr ++;
	debug_line_cntr ++;
	if (debug_line_cntr >= 16)
		debug_line_cntr = 0;
		//debug_line_cntr = 15;
}

/* Puts a debugging message on video output */
void n6610_debug_message(const far rom char* msg)
{
	int8_t j;
	uint8_t val;

	n6610_draw_rom_str(16, debug_line_cntr * 8 + 2, msg);
		
	/* Print out value in hex */
	val = debug_msg_cntr;
	for (j = 1; j >= 0; j --)
	{
		n6610_draw_char(j * 6 + 2, debug_line_cntr * 8 + 2, hex_lookup[val & 0xF]);
		//n6610_draw_char(j * 6, debug_line_cntr * 8, '0');
		val = val >> 4;
	}

	/* Next line */
	debug_msg_cntr ++;
	debug_line_cntr ++;
	if (debug_line_cntr >= 16)
		debug_line_cntr = 0;
		//debug_line_cntr = 15;
}

/* Puts a debugging message on video output */
void n6610_debug_long(uint32_t val)
{
	uint8_t j;
	
	/* Print out value in hex */
	for (j = 0; j < 8; j ++)
	{
		n6610_draw_char((7 - j) * 6 + 2, debug_line_cntr * 8 + 2, hex_lookup[val & 0xF]);
		//n6610_draw_char((7 - j) * 6, debug_line_cntr * 8, '0');
		val = val >> 4;
	}
	
	/* Next line */
	debug_line_cntr ++;
	if (debug_line_cntr >= 16)
		debug_line_cntr = 0;
}

/* Puts a debugging message on video output */
void n6610_debug(const far rom char* msg, uint8_t val)
{
 	uint8_t start;
	int8_t j;
	
	// Draw string.
	n6610_draw_rom_str(16, debug_line_cntr * 8 + 2, msg);

	// Determine length of message.
	start = strlenpgm(msg) * 6 + 16;

	/* Print out value in hex */
	for (j = 1; j >= 0; j --)
	{
		n6610_draw_char(j * 6 + start, debug_line_cntr * 8 + 2, hex_lookup[val & 0xF]);
		//n6610_draw_char(j * 6, debug_line_cntr * 8, '0');
		val = val >> 4;
	}
	
	/* Print out value in hex */
	val = debug_msg_cntr;
	for (j = 1; j >= 0; j --)
	{
		n6610_draw_char(j * 6 + 2, debug_line_cntr * 8 + 2, hex_lookup[val & 0xF]);
		//n6610_draw_char(j * 6, debug_line_cntr * 8, '0');
		val = val >> 4;
	}

	/* Next line */
	debug_msg_cntr ++;
	debug_line_cntr ++;
	if (debug_line_cntr >= 16)
		debug_line_cntr = 0;
}

void n6610_debug_message_short(const far rom char* msg, uint16_t val)
{
	uint8_t start;
	int8_t j;
	
	// Draw string.
	n6610_draw_rom_str(16, debug_line_cntr * 8 + 2, msg);

	// Determine length of message.
	start = strlenpgm(msg) * 6 + 16;

	/* Print out value in hex */
	for (j = 3; j >= 0; j --)
	{
		n6610_draw_char(j * 6 + start, debug_line_cntr * 8 + 2, hex_lookup[val & 0xF]);
		//n6610_draw_char(j * 6, debug_line_cntr * 8, '0');
		val = val >> 4;
	}
	
	/* Print out value in hex */
	val = debug_msg_cntr;
	for (j = 1; j >= 0; j --)
	{
		n6610_draw_char(j * 6 + 2, debug_line_cntr * 8 + 2, hex_lookup[val & 0xF]);
		//n6610_draw_char(j * 6, debug_line_cntr * 8, '0');
		val = val >> 4;
	}

	/* Next line */
	debug_msg_cntr ++;
	debug_line_cntr ++;
	if (debug_line_cntr >= 16)
		debug_line_cntr = 0;
}

void n6610_set_invert_mode(uint8_t mode)
{
	invert_mode = mode;
}

void n6610_set_font(uint8_t font_id)
{
	if (font_id == FONT_8X14)
	{
		font = (rom uint8_t*) _FONT8X16;
		font_height = 16;
		font_draw_height = 14;
		font_width = 8;
	}
	else if (font_id == FONT_8X16)
	{
		font = (rom uint8_t*) _FONT8X16;
		font_height = 16;
		font_draw_height = 16;
		font_width = 8;
	}
	else
	{
		font = (rom uint8_t*) _FONT6X8;
		font_height = 8;
		font_draw_height = 8;
		font_width = 6;
	}		
}

void n6610_set_color(uint8_t fr, uint8_t fg, uint8_t fb,uint8_t br, uint8_t bg, uint8_t bb)
{
	br = reverse_table[br & 0x0F];
	bg = reverse_table[bg & 0x0F];
	bb = reverse_table[bb & 0x0F];
	fr = reverse_table[fr & 0x0F];
	fg = reverse_table[fg & 0x0F];
	fb = reverse_table[fb & 0x0F];
	
	fill_patterns[0] = (bg << 4) + br;
	fill_patterns[1] = (br << 4) + bb;
	fill_patterns[2] = (bb << 4) + bg;

	fill_patterns[3] = (bg << 4) + br;
	fill_patterns[4] = (fr << 4) + bb;
	fill_patterns[5] = (fb << 4) + fg;

	fill_patterns[6] = (fg << 4) + fr;
	fill_patterns[7] = (br << 4) + fb;
	fill_patterns[8] = (bb << 4) + bg;

	fill_patterns[9] = (fg << 4) + fr;
	fill_patterns[10] = (fr << 4) + fb;
	fill_patterns[11] = (fb << 4) + fg;
}

void n6610_use_color(ui_element element)
{
    switch (element)
    {
    case element_background:
        //n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x8);
        n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x0);
        break;

    case element_header_footer:
        //n6610_set_color(0x0, 0x0, 0x0, 0xF, 0xF, 0xF);
        n6610_set_color(0x0, 0x0, 0x0, 0x7, 0x7, 0x7);
        break;

    case element_text:
        //n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x08);
        n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x0);
        break;

    case element_title:
        //n6610_set_color(0xF, 0xF, 0x0, 0x0, 0x0, 0x8);
        n6610_set_color(0xF, 0xF, 0x0, 0x0, 0x0, 0x0);
        break;

    case element_footer_ok:
        //n6610_set_color(0x0, 0x8, 0x0, 0xF, 0xF, 0xF);
        n6610_set_color(0x0, 0x8, 0x0, 0x7, 0x7, 0x7);
        break;

    case element_footer_error:
        //n6610_set_color(0x8, 0x0, 0x0, 0xF, 0xF, 0xF);
        n6610_set_color(0x8, 0x0, 0x0, 0x7, 0x7, 0x7);
        break;

    case element_menu_entry:
        //n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x8);
        n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x0);
        break;

    case element_menu_entry_selected:
        //n6610_set_color(0xF, 0xF, 0xF, 0x8, 0x0, 0x0);
        n6610_set_color(0xF, 0x7, 0x0, 0x1, 0x1, 0x1);
        break;

     default:
        break;
    }
}



