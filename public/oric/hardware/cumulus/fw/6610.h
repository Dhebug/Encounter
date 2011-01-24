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


#ifndef _6610_H
#define _6610_H

#define PCF8833
//#define EPSON

#ifdef PCF8833

/* LCD Controller Commands */
#define NOP    	   0x00  /* nop */
#define SWRESET    0x01  /* software reset */
#define BSTROFF    0x02  /* booster voltage OFF */
#define BSTRON     0x03  /* booster voltage ON */
#define RDDIDIF    0x04  /* read display identification */
#define RDDST      0x09  /* read display status */
#define SLEEPIN    0x10  /* sleep in */
//#define SLEEPOUT   0x11  /* sleep out */
#define SLEEPOUT   0x88  /* sleep out */
#define PTLON      0x12  /* partial display mode */
#define NORON      0x13  /* display normal mode */
#define INVOFF     0x20  /* inversion OFF */
//#define INVON      0x21  /* inversion ON */
#define INVON      0x84  /* inversion ON */
#define DALO       0x22  /* all pixel OFF */
#define DAL        0x23  /* all pixel ON */
//#define SETCON     0x25  /* write contrast */
#define SETCON     0xA4  /* write contrast */
#define DISPOFF    0x28  /* display OFF */
//#define DISPON     0x29  /* display ON */
#define DISPON     0x94  /* display ON */
//#define CASET      0x2A  /* column address set */
#define CASET      0x54 /* column address set */
//#define PASET      0x2B  /* page address set */
#define PASET      0xD4  /* page address set */
//#define RAMWR      0x2C  /* memory write */
#define RAMWR      0x34 /* memory write */
#define RGBSET     0x2D  /* colour set */
#define PTLAR      0x30  /* partial area */
#define VSCRDEF    0x33  /* vertical scrolling definition */
#define TEOFF      0x34  /* test mode */
#define TEON       0x35  /* test mode */
//#define MADCTL     0x36  /* memory access control */
#define MADCTL     0x6C  /* memory access control */
#define SEP        0x37  /* vertical scrolling start address */
#define IDMOFF     0x38  /* idle mode OFF */
#define IDMON      0x39  /* idle mode ON */
//#define COLMOD     0x3A  /* interface pixel format */
#define COLMOD     0x5C /* interface pixel format */
#define SETVOP     0xB0  /* set Vop  */
#define BRS        0xB4  /* bottom row swap */
#define TRS        0xB6  /* top row swap */
#define DISCTR     0xB9  /* display control */
#define DOR        0xBA  /* data order */
#define TCDFE      0xBD  /* enable/disable DF temperature compensation */
#define TCVOPE     0xBF  /* enable/disable Vop temp comp */
#define EC         0xC0  /* internal or external  oscillator */
#define SETMUL     0xC2  /* set multiplication factor */
#define TCVOPAB    0xC3  /* set TCVOP slopes A and B */
#define TCVOPCD    0xC4  /* set TCVOP slopes c and d */
#define TCDF       0xC5  /* set divider frequency */
#define DF8COLOR   0xC6  /* set divider frequency 8-color mode */
#define SETBS      0xC7  /* set bias system */
#define RDTEMP     0xC8  /* temperature read back */
#define NLI        0xC9  /* n-line inversion */
#define RDID1      0xDA  /* read ID1 */
#define RDID2      0xDB  /* read ID2 */
#define RDID3      0xDC  /* read ID3 */

#endif 

#ifdef EPSON

//#define DISON     0xAF      // Display on 
#define DISON     0xF5      // Display on 
#define DISOFF    0xAE      // Display off 
#define DISNOR    0xA6      // Normal display 
//#define DISINV    0xA7      // Inverse display 
#define DISINV    0xE5      // Inverse display 
//#define COMSCN    0xBB      // Common scan direction 
#define COMSCN    0xDD      // Common scan direction 
//#define DISCTL    0xCA      // Display control 
#define DISCTL    0x53      // Display control 
#define SLPIN     0x95      // Sleep in 
//#define SLPOUT    0x94      // Sleep out 
#define SLPOUT    0x29      // Sleep out 
//#define PASET     0x75      // Page address set 
#define PASET     0xAE      // Page address set 
//#define CASET     0x15      // Column address set 
#define CASET     0xA8      // Column address set 
//#define DATCTL    0xBC      // Data scan direction, etc. 
#define DATCTL    0x3D      // Data scan direction, etc. 
#define RGBSET8   0xCE      // 256-color position set 
//#define RAMWR     0x5C      // Writing to memory 
#define RAMWR     0x3A      // Writing to memory 
#define RAMRD     0x5D      // Reading from memory 
#define PTLIN     0xA8      // Partial display in 
#define PTLOUT    0xA9      // Partial display out 
#define RMWIN     0xE0      // Read and modify write 
#define RMWOUT    0xEE      // End 
#define ASCSET    0xAA      // Area scroll set 
#define SCSTART   0xAB      // Scroll start set 
//#define OSCON     0xD1      // Internal oscillation on 
#define OSCON     0x8B      // Internal oscillation on 
#define OSCOFF    0xD2      // Internal oscillation off 
//#define PWRCTR    0x20      // Power control 
#define PWRCTR    0x04      // Power control 
//#define VOLCTR    0x81      // Electronic volume control 
#define VOLCTR    0x81      // Electronic volume control 
#define VOLUP     0xD6      // Increment electronic control by 1 
#define VOLDOWN   0xD7      // Decrement electronic control by 1 
#define TMPGRD    0x82      // Temperature gradient set 
#define EPCTIN    0xCD      // Control EEPROM 
#define EPCOUT    0xCC      // Cancel EEPROM control 
#define EPMWR     0xFC      // Write into EEPROM 
#define EPMRD     0xFD      // Read from EEPROM 
#define EPSRRD1   0x7C      // Read register 1 
#define EPSRRD2   0x7D      // Read register 2 
#define NOP       0x25      // NOP instruction 
 
#endif

/* Font definitions */
#define FONT_6X8	0x01
#define FONT_8X14 	0x02
#define FONT_8X16 	0x03

extern void n6610_init(void);
extern void n6610_fill_area(uint8_t x, uint8_t y, uint8_t w, uint8_t h);
extern void n6610_draw_char(uint8_t x, uint8_t y, char c);
extern void n6610_draw_ram_str(uint8_t x, uint8_t y, const char* c);
extern void n6610_draw_rom_str(uint8_t x, uint8_t y, const far rom char* c);
extern void n6610_set_invert_mode(uint8_t mode);
extern void n6610_set_color(uint8_t fr, uint8_t fg, uint8_t fb, uint8_t br, uint8_t bg, uint8_t bb);
extern void n6610_set_font(uint8_t font_id);

extern void n6610_debug_message_ram(const char* msg);
extern void n6610_debug_message(const far rom char* msg);
extern void n6610_debug(const far rom char* msg, uint8_t byte);
extern void n6610_debug_long(uint32_t val);
extern void n6610_debug_message_short(const far rom char* msg, uint16_t word);

#endif