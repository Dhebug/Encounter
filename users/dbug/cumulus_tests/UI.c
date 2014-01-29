/* Cumulus 18F46K20 Firmware
 * User interface. 
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

#include "string.h"
#include "179X.h"
#include "6610.h"
#include "utility.h"
#include "sd-mmc.h"
#include "fat32.h"
#include "delays.h"
#include "UI.h"

#define SCR_WIDTH_6X8 21

typedef enum
{
  ui_state_emulation = 0,
  ui_state_main_menu,
  ui_state_image_select,
  ui_state_about,
  ui_state_io_error,
  ui_state_command_log,
  ui_state_reset_oric
} ui_state;

#define BUTTON_NONE    0
#define BUTTON_LEFT_TOP  1
#define BUTTON_LEFT_BOTTOM  2
#define BUTTON_RIGHT_BOTTOM 3
#define BUTTON_RIGHT_CENTER 4
#define BUTTON_RIGHT_TOP    5

#define DEBOUNCE_COUNT  5

typedef enum
{
  ui_main_style =0,
  ui_main_reset ,
  ui_main_command_log,
  ui_main_about,
  ui_main_count
} ui_main_item;

#define FILE_LIST_SIZE 12

#pragma romdata
far rom char str_cumulus[] = "Cumulus";
far rom char str_version[] = SETUP_VERSION_NUMBER;
#ifdef SETUP_VERSION_NAME
far rom char str_version_name[] = SETUP_VERSION_NAME;
#endif
far rom char str_about_1[] = "Oric Microdisc";
far rom char str_about_2[] = "compatible";
far rom char str_about_3[] = "SD Card Emulator";
far rom char str_by_retromaster[] = "by retromaster";
far rom char str_and_metadata[] = "and metadata";
far rom char str_empty[] = "-- Empty --";
far rom char str_about[] = "About";
far rom char str_change_style[] = "Change Style";
far rom char str_reset_oric[] = "Reset Oric";
far rom char str_continue[] = "Continue";
far rom char str_main[] = "Main";
far rom char str_mount_drive[] = "Mount (Drive  )";
far rom char str_refresh_content[] = "Refresh Content";
far rom char str_on[] = "On";
far rom char str_off[] = "On";
far rom char str_error[] = "Error";
far rom char str_card_io_error[] = "SD Card I/O Error!";
far rom char str_command_log[] = "Command Log";
far rom char str_dsk[] = "DSK";
far rom char str_yes[] = "Yes";
far rom char str_no[] = "No";
far rom char str_log_status[] = "Status";
far rom char* str_status[ui_status_count] = {
  (far rom char*) "OK.",
  (far rom char*) "SD Card IO Error!",
  (far rom char*) "Record Not Found!",
  (far rom char*) "CRC Error!",
  (far rom char*) "Disk Write-Protected!",
  (far rom char*) "Drive Not Ready!",
};
static rom char hex_lookup[16] = {
  '0', '1', '2', '3',
  '4', '5', '6', '7',
  '8', '9', 'A', 'B',
  'C', 'D', 'E', 'F'
};

#pragma udata ui_data_section
static uint8_t card_initialized;
static int8_t selection;
static int8_t file_count;
static uint16_t dir_page;
static fat32_dir_entry directory;
static ui_state state;
static uint8_t drive;
static uint8_t pressed_button;
static uint8_t debounce_button;
static uint8_t debounce_counter;
static uint8_t blink;
static uint32_t blink_cntr;
static uint8_t status;
static uint8_t log_line_cntr;
static uint8_t log_msg_cntr;
static const far rom char* log_msg;
static uint8_t log_val1;
static uint8_t log_val2;
static uint8_t log_val3;
static fat32_dir_entry file_list[FILE_LIST_SIZE];


#pragma code

void ui_update_track(drive_state* drive)
{
  uint8_t y;
  if (state != ui_state_emulation)
    return;

  n6610_set_font(FONT_8X14);
  if (selection == drive->number)
    n6610_use_color(element_menu_entry_selected); //n6610_set_color(0xF, 0xF, 0xF, 0x8, 0x0, 0x0);
  else
    n6610_use_color(element_menu_entry); //n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x8);
  /*
  if (selection == drive->number)
          n6610_set_color(0xF, 0xF, 0xF, 0x8, 0x0, 0x0);
  else
          n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x8);
   */
  y = drive->number * 26 + 14;
  n6610_draw_char(112, y, '0' + (drive->last_read_sector / 10));
  n6610_draw_char(120, y, '0' + (drive->last_read_sector % 10));

  n6610_draw_char(96, y, '0' + (drive->track / 10));
  n6610_draw_char(88, y, '0' + (drive->track % 10));

  n6610_draw_char(72, y, '0' + (drive->side % 10));
}

static void prep_screen(void)
{
  /* Prepare the header and footer areas */
  n6610_use_color(element_header_footer); // n6610_set_color(0x0, 0x0, 0x0, 0xF, 0xF, 0xF);
  n6610_fill_area(0, 0, 132, 10);
  n6610_fill_area(0, 122, 132, 10);
  n6610_set_font(FONT_6X8);
  n6610_draw_rom_str(1, 2, str_cumulus);
  n6610_draw_rom_str(50, 2, str_version);

#ifdef SETUP_VERSION_NAME
  n6610_draw_rom_str(80, 2, str_version_name);
#endif



  /* Clear the background */
  n6610_use_color(element_background); // n6610_set_color(0xF, 0xF, 0xF, 0x1, 0x1, 0x1);
  n6610_fill_area(0, 10, 132, 112);
}

/* Draws a drive info item in emulation mode */
static void draw_emulation_drive_item(uint8_t drive, uint8_t selected)
{
  uint8_t len;
  uint8_t pos;
  uint8_t y;

  y = 14 + 26 * drive;

  /*
  if (selected)
          n6610_set_color(0xF, 0xF, 0xF, 0x8, 0x0, 0x0);
  else
          n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x8);
   */
  if (selected)
    n6610_use_color(element_menu_entry_selected); //n6610_set_color(0xF, 0xF, 0xF, 0x8, 0x0, 0x0);
  else
    n6610_use_color(element_menu_entry); //n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x8);

  n6610_fill_area(0, y, 132, 22);

  n6610_set_font(FONT_8X14);
  n6610_draw_char(112, y, '0' + (wd179x_drive[drive].last_read_sector / 10));
  n6610_draw_char(120, y, '0' + (wd179x_drive[drive].last_read_sector % 10));

  n6610_draw_char(96, y, '0' + (wd179x_drive[drive].track / 10));
  n6610_draw_char(88, y, '0' + (wd179x_drive[drive].track % 10));

  n6610_draw_char(72, y, '0' + (wd179x_drive[drive].side % 10));

  n6610_draw_char(56, y, ':');
  n6610_draw_char(48, y, 'A' + drive);

  n6610_set_font(FONT_6X8);
  if (wd179x_drive[drive].image_type == IMAGE_NONE)
    n6610_draw_rom_str(64, y + 14, str_empty);
  else
  {
    len = strlen_ram(wd179x_drive[drive].image_file.name);
    if (len <= SCR_WIDTH_6X8)
      pos = 128 - (len * 6);
    else
      pos = 2;

    n6610_draw_ram_str(pos, y + 14, wd179x_drive[drive].image_file.name);
  }

  if (wd179x_drive[drive].type_I_status & 0x40)
    n6610_draw_char(1, y + 6, 'P');
}

static void draw_status(void)
{
  /* Prepare the header and footer areas */
  if (status == 0)
    n6610_use_color(element_footer_ok); //n6610_set_color(0x0, 0x8, 0x0, 0xF, 0xF, 0xF);
  else
    n6610_use_color(element_footer_error); //n6610_set_color(0x8, 0x0, 0x0, 0xF, 0xF, 0xF);

  n6610_set_font(FONT_6X8);
  n6610_fill_area(0, 122, 132, 10);
  n6610_draw_rom_str(1, 123, str_status[status]);
}

/* Sets the status */
void ui_set_status(ui_status s)
{
  if (status != s)
  {
    status = s;
    if (state == ui_state_emulation)
      draw_status();
  }
}

/* Displays emulation screen. */
static void enter_emulation(void)
{
  uint8_t i;

  state = ui_state_emulation;
  prep_screen();

  selection = 0;
  draw_emulation_drive_item(0, 1);
  for (i = 1; i < 4; i++)
    draw_emulation_drive_item(i, 0);

  draw_status();
}

/* Prints a main menu item */
static void draw_main_menu_item(ui_main_item item, uint8_t selected)
{
  if (selected)
    n6610_use_color(element_menu_entry_selected);
  else
    n6610_use_color(element_menu_entry);

  switch (item)
  {
  case ui_main_style:
    n6610_fill_area(0, 16, 130, 8);
    n6610_draw_rom_str(0, 16, str_change_style);
    break;

  case ui_main_reset:
    n6610_fill_area(0, 24, 130, 8);
    n6610_draw_rom_str(0, 24, str_reset_oric);
    break;
  case ui_main_command_log:
    n6610_fill_area(0, 32, 130, 8);
    n6610_draw_rom_str(0, 32, str_command_log);
    break;
  case ui_main_about:
    n6610_fill_area(0, 48, 130, 8);
    n6610_draw_rom_str(0, 48, str_about);
    break;
  }
}

/* Displays and enters the main menu. */
static void enter_main_menu(void)
{
  uint8_t i;

  prep_screen();

  draw_main_menu_item(0, 1);
  for (i = 1; i < ui_main_count; i++)
    draw_main_menu_item(i, 0);

  n6610_use_color(element_header_footer);
  n6610_draw_rom_str(1, 123, str_main);

  selection = 0;
  state = ui_state_main_menu;
}

/* Draws yes or no. */
static void draw_reset_oric_items(void)
{
  if (selection == 0)
    n6610_use_color(element_menu_entry_selected);
  else
    n6610_use_color(element_menu_entry);

  n6610_fill_area(0, 16, 130, 8);
  n6610_draw_rom_str(0, 16, str_yes);

  if (selection == 1)
    n6610_use_color(element_menu_entry_selected);
  else
    n6610_use_color(element_menu_entry);

  n6610_fill_area(0, 24, 130, 8);
  n6610_draw_rom_str(0, 24, str_no);
}

/* Displays and enters the main menu. */
static void enter_reset_oric(void)
{
  uint8_t i;

  prep_screen();

  n6610_use_color(element_header_footer); //n6610_set_color(0x0, 0x0, 0x0, 0xF, 0xF, 0xF);
  n6610_draw_rom_str(1, 123, str_reset_oric);
  n6610_draw_char(61, 123, '?');

  selection = 0;
  draw_reset_oric_items();
  state = ui_state_reset_oric;
}

/* Displays About screen. */
static void enter_about(void)
{
  prep_screen();

  n6610_use_color(element_header_footer); //n6610_set_color(0x0, 0x0, 0x0, 0xF, 0xF, 0xF);
  n6610_draw_rom_str(1, 123, str_about);

  n6610_use_color(element_title); //n6610_set_color(0xF, 0xF, 0x0, 0x0, 0x0, 0x8);
  n6610_set_font(FONT_8X16);
  n6610_draw_rom_str(16, 24, str_cumulus);

  n6610_use_color(element_text); //n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x8);
  n6610_set_font(FONT_6X8);
  n6610_draw_rom_str(80, 30, str_version);
  n6610_draw_rom_str(16, 44, str_about_1);
  n6610_draw_rom_str(16, 52, str_about_2);
  n6610_draw_rom_str(16, 60, str_about_3);
  n6610_draw_rom_str(16, 76, str_by_retromaster);
  n6610_draw_rom_str(16, 84, str_and_metadata);

  state = ui_state_about;
}

/* Displays and enters the main menu. */
static void enter_command_log(void)
{
  prep_screen();

  n6610_set_color(0x0, 0x0, 0x0, 0xF, 0xF, 0xF);
  n6610_draw_rom_str(1, 123, str_command_log);

  log_msg_cntr = 0;
  log_line_cntr = 0;
  state = ui_state_command_log;

  if (log_msg)
  {
    ui_log_command(log_msg, log_val1, log_val2, log_val3);
    log_msg = 0;
    log_val1 = log_val2 = log_val3 = 0;
  }
}

static uint8_t change_card(void)
{
  if (!card_init())
    return 0;
  else if (!fat32_init())
    return 0;

  selection = 0;
  dir_page = 0;
  fat32_root_dir(&directory);

  card_initialized = 1;
  return 1;
}

static void io_error(void)
{
  card_initialized = 0;

  prep_screen();
  n6610_use_color(element_footer_error);
  n6610_draw_rom_str(1, 123, str_error);

  n6610_use_color(element_text);
  n6610_draw_rom_str(8, 16, str_card_io_error);

  state = ui_state_io_error;
}

/* Displays image selection menu item */
static void draw_image_select_menu_item(uint8_t item, uint8_t selected)
{
  if (selected)
    n6610_use_color(element_menu_entry_selected);
  else
    n6610_use_color(element_menu_entry);


  if (item < file_count)
  {
    int y = 13 + item * 8;
    n6610_fill_area(0, y, 130, 8);
    if (file_list[item].dir)
    {
      n6610_draw_char(0, y, '/');
      n6610_draw_ram_str(8, y, file_list[item].name);
    }
    else
    {
      n6610_draw_ram_str(0, y, file_list[item].name);
    }
  }
  else if (item == FILE_LIST_SIZE)
  {
    n6610_fill_area(0, 110, 130, 8);
    n6610_draw_rom_str(0, 110, str_refresh_content);
  }
}

/* Displays image selection menu */
static void draw_image_select_menu(void)
{
  uint8_t item;

  prep_screen();
  n6610_use_color(element_header_footer); //n6610_set_color(0x0, 0x0, 0x0, 0xF, 0xF, 0xF);
  n6610_draw_rom_str(1, 123, str_mount_drive);
  n6610_draw_char(79, 123, 'A' + drive);

  for (item = 0; item < file_count; item++)
  {
    draw_image_select_menu_item(item, (selection == item));
  }
  draw_image_select_menu_item(FILE_LIST_SIZE, (selection == FILE_LIST_SIZE));
}

static void enter_image_select(void)
{
  fat32_dir dir;
  uint8_t i, j;

  state = ui_state_image_select;
  if (!card_initialized)
    if (!change_card())
    {
      io_error();
      return;
    }

  /* Go up to the current directory page */
  fat32_dir_begin(&dir, &directory);
  for (i = 0; i < dir_page; i++)
  {
    for (j = 0; j < FILE_LIST_SIZE; j++)
      if (!fat32_dir_next(&dir, &(file_list[0]), str_dsk))
      {
        if (dir.error)
        {
          io_error();
          return;
        }
        else
          break;
      }

    if (j != FILE_LIST_SIZE)
    {
      /* Seems like we didn't get that far, just go back to the beginning */
      dir_page = 0;
      selection = 0;

      fat32_dir_begin(&dir, &directory);
      break;
    }
  }

  /* Fill file list */
  file_count = 0;
  for (j = 0; j < FILE_LIST_SIZE; j++)
  {
    if (!fat32_dir_next(&dir, &(file_list[j]), str_dsk))
    {
      /* This is the last page in the directory */
      if (dir.error)
      {
        io_error();
        return;
      }

      break;
    }

    file_count++;
  }

  draw_image_select_menu();
}

/* Puts a log message on the Command Log */
void ui_log_command(const far rom char* msg, uint8_t val1, uint8_t val2, uint8_t val3)
{
  uint8_t y;
  int8_t j;

  if (state != ui_state_command_log)
  {
    log_msg = msg;
    log_val1 = val1;
    log_val2 = val2;
    log_val3 = val3;
    return;
  }

  // Draw string.
  y = log_line_cntr * 8 + 12;
  n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x8);
  n6610_fill_area(8, y, 82, 8);
  n6610_draw_rom_str(8, y, msg);

  /* Print out value in hex */
  for (j = 1; j >= 0; j--)
  {
    n6610_draw_char(j * 6 + 90, y, hex_lookup[val1 & 0xF]);
    val1 = val1 >> 4;
  }

  /* Print out value in hex */
  for (j = 1; j >= 0; j--)
  {
    n6610_draw_char(j * 6 + 104, y, hex_lookup[val2 & 0xF]);
    val2 = val2 >> 4;
  }

  /* Print out value in hex */
  for (j = 1; j >= 0; j--)
  {
    n6610_draw_char(j * 6 + 118, y, hex_lookup[val3 & 0xF]);
    val3 = val3 >> 4;
  }

  /* Print out value in hex */
  n6610_draw_char(0, y, hex_lookup[log_msg_cntr & 0xF]);

  /* Next line */
  log_msg_cntr++;
  log_line_cntr++;
  if (log_line_cntr >= 13)
    log_line_cntr = 0;
}

/* Puts a log status message on the Command Log */
void ui_log_status(uint8_t val)
{
  uint8_t y;
  int8_t j;

  if (state != ui_state_command_log)
  {
    log_msg = (const far rom char*) str_log_status;
    log_val1 = val;
    log_val2 = 0;
    log_val3 = 0;
    return;
  }

  // Draw string.
  y = log_line_cntr * 8 + 12;
  n6610_set_color(0x8, 0x0, 0x0, 0x0, 0x0, 0x8);
  n6610_fill_area(8, y, 82, 8);
  n6610_draw_rom_str(8, y, str_log_status);

  n6610_set_color(0xF, 0xF, 0xF, 0x0, 0x0, 0x8);
  /* Print out value in hex */
  for (j = 1; j >= 0; j--)
  {
    n6610_draw_char(j * 6 + 90, y, hex_lookup[val & 0xF]);
    val = val >> 4;
  }

  /* Print out value in hex */
  n6610_draw_char(0, y, hex_lookup[log_msg_cntr & 0xF]);

  /* Next line */
  log_msg_cntr++;
  log_line_cntr++;
  if (log_line_cntr >= 13)
    log_line_cntr = 0;
}

/* Initializes the user interface. */
void ui_init(void)
{
  /* Initialize the LCD */
  n6610_init();

  /* Initialize IF lines */
  TRISEbits.TRISE0 = 1;
  TRISEbits.TRISE1 = 1;
  TRISEbits.TRISE2 = 1;
  TRISAbits.TRISA4 = 1;
  TRISAbits.TRISA5 = 1;
  pressed_button = BUTTON_NONE;
  debounce_button = BUTTON_NONE;
  debounce_counter = 0;

  /* More initialization */
  ui_wd1793_command_done();
  card_initialized = 0;
  ui_set_status(ui_status_ok);

  log_msg = 0;
  log_val1 = log_val2 = log_val3 = 0;

  /* Go to the main menu */
  enter_emulation();
}

static uint8_t check_buttons(void)
{
  if (PORTEbits.RE0 == 0)
    return BUTTON_RIGHT_BOTTOM;
  else if (PORTAbits.RA5 == 0)
    return BUTTON_RIGHT_CENTER;
  else if (PORTAbits.RA4 == 0)
    return BUTTON_RIGHT_TOP;
  else if (PORTEbits.RE2 == 0)
    return BUTTON_LEFT_TOP;
  else if (PORTEbits.RE1 == 0)
    return BUTTON_LEFT_BOTTOM;
  else
    return BUTTON_NONE;
}

static void handle_emulation(void)
{
  if (pressed_button == BUTTON_LEFT_TOP)
  {
    draw_emulation_drive_item(selection, 0);
    selection--;
    if (selection < 0)
      selection = 3;
    draw_emulation_drive_item(selection, 1);
  }
  if (pressed_button == BUTTON_LEFT_BOTTOM)
  {
    draw_emulation_drive_item(selection, 0);
    selection++;
    if (selection >= 4)
      selection = 0;
    draw_emulation_drive_item(selection, 1);
  }
  if (pressed_button == BUTTON_RIGHT_TOP)
  {
    drive = selection;
    enter_image_select();
  }
  if (pressed_button == BUTTON_RIGHT_BOTTOM)
  {
    // This used to be to switch the write protection, but I don't really care.
    // So the new behavior is going to be 'Reload the currently mounted floppy and reboot the Oric'
    int8_t old_selection = selection;
    uint16_t old_dir_page = dir_page;
    if (!change_card())
    {
      if (!change_card())
      {
        io_error();
      }
    }
    selection = old_selection;
    dir_page = old_dir_page;

    enter_reset_oric();
  }
  if (pressed_button == BUTTON_RIGHT_CENTER)
    enter_main_menu();
}

static void handle_main_menu(void)
{
  switch (pressed_button)
  {
  case BUTTON_LEFT_TOP:
    draw_main_menu_item(selection, 0);
    selection--;
    if (selection < 0)
      selection = ui_main_count - 1;
    draw_main_menu_item(selection, 1);
    break;

  case BUTTON_LEFT_BOTTOM:
    draw_main_menu_item(selection, 0);
    selection++;
    if (selection >= ui_main_count)
      selection = 0;
    draw_main_menu_item(selection, 1);
    break;

  case BUTTON_RIGHT_TOP:
    /* Go somewhere else */
    switch (selection)
    {
    case ui_main_style:
      n6610_cycle_style();
      enter_main_menu();
      break;
    case ui_main_command_log:
      enter_command_log();
      break;
    case ui_main_reset:
      enter_reset_oric();
      break;
    case ui_main_about:
      enter_about();
      break;
    }
    break;

  case BUTTON_RIGHT_BOTTOM:
    // Back to the main page
    enter_emulation();
    break;
  }
}

static void handle_image_select(void)
{
  switch (pressed_button)
  {
  case BUTTON_LEFT_TOP:
    draw_image_select_menu_item(selection, 0);
    selection--;
    if ((selection >= file_count) && (selection < FILE_LIST_SIZE))
      selection = file_count - 1;
    else if (selection < 0)
      selection = FILE_LIST_SIZE;
    draw_image_select_menu_item(selection, 1);
    break;

  case BUTTON_LEFT_BOTTOM:
    draw_image_select_menu_item(selection, 0);
    selection++;
    if (selection > FILE_LIST_SIZE)
      selection = 0;
    else if ((selection >= file_count) && (selection < FILE_LIST_SIZE))
      selection = FILE_LIST_SIZE;
    draw_image_select_menu_item(selection, 1);
    break;

  case BUTTON_RIGHT_BOTTOM:
    // Back to the main page
    enter_emulation();
    break;

  case BUTTON_RIGHT_CENTER:
    dir_page++;
    enter_image_select(); /* This will automatically handle end of directory */
    break;

  case BUTTON_RIGHT_TOP:
    if (selection == FILE_LIST_SIZE)
    {
      // Refresh directory content
      card_initialized = 0;
      enter_image_select();
    }
    else
    {
      if (file_list[selection].dir)
      {
        /* Go into the directory */
        directory = file_list[selection];
        dir_page = 0;
        selection = 0;
        enter_image_select();
      }
      else
      {
        wd179x_mount_image(drive, &file_list[selection]);
        enter_emulation();
      }
    }
    break;
  }
}

static void handle_reset_oric(void)
{
  int i;

  if (pressed_button == BUTTON_LEFT_TOP || pressed_button == BUTTON_LEFT_BOTTOM)
  {
    if (selection == 1)
      selection = 0;
    else
      selection = 1;
    draw_reset_oric_items();
  }
  if (pressed_button == BUTTON_RIGHT_TOP)
  {
    if (selection == 0)
    {
      /* Reset low */
      PORTAbits.RA6 = 0;

      /* Wait */
      for (i = 0; i < 5; i++)
        Delay10KTCYx(200);

      /* Do something for the WD179X? */

      /* UI */
      enter_emulation();
      //state = ui_state_reset_oric;
      //enter_command_log();


      /* Reset high */
      PORTAbits.RA6 = 1;
    }
    else
    {
      /* Do nothing */
      enter_main_menu();
    }
  }
}

static void handle_button_press(void)
{
  if (state == ui_state_emulation)
    handle_emulation();
  else if (state == ui_state_io_error || state == ui_state_command_log || state == ui_state_about)
    enter_emulation();
  else if (state == ui_state_main_menu)
    handle_main_menu();
  else if (state == ui_state_image_select)
    handle_image_select();
  else if (state == ui_state_reset_oric)
    handle_reset_oric();
}

/* Handles user input */
static void handle_user_input(void)
{
  uint8_t button;
  button = check_buttons();

  if (button == debounce_button)
  {
    debounce_counter++;
    if (debounce_counter > DEBOUNCE_COUNT)
    {
      /* Key debounced */
      if (pressed_button != BUTTON_NONE)
      {
        /* Waiting for release */
        if (debounce_button != pressed_button)
        {
          /* Button released */
          handle_button_press();
        }
      }

      pressed_button = debounce_button;
      debounce_counter = 0;
    }
  }
  else
  {
    debounce_button = button;
    debounce_counter = 0;
  }
}

/* A WD1793 command is now active */
void ui_wd1793_command_active(void)
{
  n6610_set_color(0x0, 0x0, 0x0, 0xF, 0x0, 0x0);
  n6610_fill_area(124, 4, 4, 4);
  blink = 2;
}

/* A WD1793 command is now active */
void ui_wd1793_command_done(void)
{
  blink_cntr = 0;
  blink = 0;
}

/* Blinks activity light */
static void blink_activity_light(void)
{
  if (blink > 1)
    return;

  if (blink_cntr == 0)
  {
    if (blink)
    {
      n6610_set_color(0x0, 0x0, 0x0, 0x0, 0xF, 0x0);
      n6610_fill_area(124, 4, 4, 4);
      blink = 0;
    }
    else
    {
      n6610_set_color(0x0, 0x0, 0x0, 0x0, 0x0, 0x0);
      n6610_fill_area(124, 4, 4, 4);
      blink = 1;
    }

    blink_cntr = 150000;
  }
  else
    blink_cntr--;
}

/* Handles UI related-stuff in between command executions */
void ui_run(void)
{
  handle_user_input();
  blink_activity_light();
}

