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
//#define S1D15G10

#ifdef PCF8833

/* LCD Controller Commands */
#define SLEEPOUT   0x88  /* sleep out */
#define INVON      0x84  /* inversion ON */
#define SETCON     0xA4  /* write contrast */
#define DISPON     0x94  /* display ON */
#define CASET      0x54 /* column address set */
#define PASET      0xD4  /* page address set */
#define RAMWR      0x34 /* memory write */
#define MADCTL     0x6C  /* memory access control */
#define COLMOD     0x5C /* interface pixel format */

#endif 

#ifdef S1D15G10

#define DISON     0xF5      // Display on 
#define DISINV    0xE5      // Inverse display 
#define COMSCN    0xDD      // Common scan direction 
#define DISCTL    0x53      // Display control 
#define SLPOUT    0x29      // Sleep out 
//#define PASET     0xAE      // Page address set 
#define PASET     0xA8      // Page address set 
//#define CASET     0xA8      // Column address set 
#define CASET     0xAE      // Column address set 
#define DATCTL    0x3D      // Data scan direction, etc. 
#define RAMWR     0x3A      // Writing to memory 
#define OSCON     0x8B      // Internal oscillation on 
#define PWRCTR    0x04      // Power control 
#define VOLCTR    0x81      // Electronic volume control 
 
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

// Experimental stuff added by dbug
typedef enum
{
    element_background,
    element_header_footer,
    element_text,
    element_title,
    element_footer_ok,
    element_footer_error,
    element_menu_entry,
    element_menu_entry_selected,
    _element_count
} ui_element;

typedef enum
{
    ui_style_retromaster,
    ui_style_defenceforce,
    _ui_style_count
} ui_style;

typedef struct
{
  uint8_t red;
  uint8_t green;
  uint8_t blue;
} rgb;

typedef struct
{
  rgb   foreground;
  rgb   background;
} color_set;

extern void n6610_use_color(ui_element element);


#endif