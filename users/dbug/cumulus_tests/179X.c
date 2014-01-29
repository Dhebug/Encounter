/* Cumulus 18F46K20 Firmware
 * WD179X Simulation. 
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

/* TODO:
 *
 * 1. Verify flag for type I commands.
 * 5. Motor step rate.
 * 6. Interrupt request. 
 * 7. Old type DSK image.
 * 8. Head load delay?
 * 9. FM mode.
 * 10. CRC Checks? 
 * 11. m Flag multiple operations check.
 * 13. Type III.
 */

#include "delays.h"

#include "global.h"

#include "179X.h"
#include "6610.h"
#include "sd-mmc.h"
#include "ui.h"

extern uint8_t fat32_sector_buffer[512];

#define WD179X_DEBUG
//#define WD179X_CRC_CHECK

#define WaitClockCycle	Nop(); Nop(); Nop(); Nop(); Nop(); Nop(); Nop();

#pragma romdata
// DSK Signatures.
static rom char str_ORICDISK[] = "ORICDISK";
static rom char str_MFM_DISK[] = "MFM_DISK";

// Sector header.
static rom uint8_t sector_header[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA1, 0xA1, 0xA1, 0xFB};

#include "CRC.h"

#pragma udata sector_buffer_section
static uint8_t sector_buffer[1024];

#pragma udata wd179x_data_section

static uint8_t command; // Command being currently executed.
static drive_state* drive; // Drive being currently accessed.
static uint8_t drive_changed; // Previous command was issued to another drive.

drive_state wd179x_drive[4];

#define CheckReadTrackEnd() if (drive->track_position == 6250)	if (!image_track_seek()) { sd_io_error(); return 0; }
#define CheckWriteTrackEnd() if (drive->track_position == 6250)	{ if (!fat32_file_flush(&drive->image_file)) { sd_io_error(); return 0; } if (!image_track_seek()) { sd_io_error(); return 0; } }
#define TrackReadByte(X) if (!fat32_file_get_byte(&drive->image_file, (X))) { sd_io_error(); return 0; }
#define TrackWriteByte(X) if (!fat32_file_put_byte(&drive->image_file, (X))) { sd_io_error(); return 0; }

#pragma code 

static void sd_io_error(void)
{
  ui_set_status(ui_status_sd_io_error);
}

static void clear_busy_flag(void)
{
  /*	TRISD = 0x00;		// MD output.
          PORTD = 0x00;
          PORTB = 0x06;		// MFS = 0, MWE high, MOE high.
          PORTB = 0x04;		// MFS = 0, MWE low, MOE high.
          WaitClockCycle;
          PORTB = 0x06; 		// MFS = 0, MWE high, MOE high.
          TRISD = 0xFF;		// MD back to input.*/
}

static void generate_interrupt_request(void)
{
  /*if (command == 0xD8)
          PORTEbits.RE2 = 1;*/

  PORTB = 0x16; // MFS = 2, MWE high, MOE high.
  PORTB = 0x14; // MFS = 2, MWE low, MOE high.
  WaitClockCycle;
  PORTB = 0x16; // MFS = 2, MWE high, MOE high.

  /*PORTEbits.RE2 = 0;*/
}

static void generate_data_request(void)
{
  PORTB = 0x0E; // MFS = 1, MWE high, MOE high.
  PORTB = 0x0C; // MFS = 1, MWE low, MOE high.
  WaitClockCycle;
  PORTB = 0x0E; // MFS = 1, MWE high, MOE high.
}

static void write_data_register(uint8_t data)
{
  TRISD = 0x00; // MD output.
  PORTD = data;
  PORTB = 0x1E; // MFS = 3, MWE high, MOE high.
  PORTB = 0x1C; // MFS = 3, MWE low, MOE high.
  WaitClockCycle;
  PORTB = 0x1E; // MFS = 3, MWE high, MOE high.
  TRISD = 0xFF; // MD back to input.
}

static uint8_t read_data_register(void)
{
  uint8_t data;

  PORTB = 0x1A; // MFS = 3, MWE high, MOE low.
  Nop();
  data = PORTD;
  PORTB = 0x1E; // MFS = 3, MWE high, MOE high.

  return data;
}

static int8_t read_track_register(void)
{
  int8_t track;

  PORTB = 0x0A; // MFS = 1, MWE high, MOE low.
  Nop();
  track = PORTD;
  PORTB = 0x0E; // MFS = 1, MWE high, MOE high.

  return track;
}

static void write_track_register(uint8_t track)
{
  TRISD = 0x00; // MD output.
  PORTD = track;
  PORTB = 0x2E; // MFS = 5, MWE high, MOE high.
  PORTB = 0x2C; // MFS = 5, MWE low, MOE high.
  WaitClockCycle;
  PORTB = 0x2E; // MFS = 5, MWE high, MOE high.
  TRISD = 0xFF; // MD back to input.
}

static uint8_t read_sector_register(void)
{
  uint8_t sector;

  PORTB = 0x12; // MFS = 2, MWE high, MOE low.
  Nop();
  sector = PORTD;
  PORTB = 0x16; // MFS = 2, MWE high, MOE high.

  return sector;
}

static void write_sector_register(uint8_t sector)
{
  TRISD = 0x00; // MD output.
  PORTD = sector;
  PORTB = 0x06; // MFS = 0, MWE high, MOE high.
  PORTB = 0x04; // MFS = 0, MWE low, MOE high.
  WaitClockCycle;
  PORTB = 0x06; // MFS = 0, MWE high, MOE high.
  TRISD = 0xFF; // MD back to input.
}

static void write_status_register(uint8_t status)
{
#ifdef WD179X_DEBUG
  //n6610_debug((const far rom char*) "Status: ", status);
#endif

  TRISD = 0x00; // MD output.
  PORTD = status;
  PORTB = 0x26; // MFS = 4, MWE high, MOE high.
  PORTB = 0x24; // MFS = 4, MWE low, MOE high.
  WaitClockCycle;
  PORTB = 0x26; // MFS = 4, MWE high, MOE high.
  TRISD = 0xFF; // MD back to input.
}

static void wait_head_step(void)
{
  //IMPLEMENTME!
}

static void head_step_out(void)
{
  drive->track--;
  if (drive->track < 0)
    drive->track = 0;
  if (drive->track == 0)
    drive->type_I_status |= 0x04;

  // Update display.
  ui_update_track(drive);
}

static void head_step_in(void)
{
  drive->track++;
  if (drive->track > 83) // Hard stop.
    drive->track = 83;
  drive->type_I_status &= 0xFB;

  // Update display.
  ui_update_track(drive);
}

static void step_out(void)
{
  wait_head_step();
  head_step_out();
  write_status_register(drive->type_I_status);

  // Update track register if requested.
  if (command & 0x10)
  {
    int8_t track;

    track = read_track_register();
    track--;
    if (track < 0)
      track = 0;
    write_track_register(track);
  }
}

static void step_in(void)
{
  wait_head_step();
  head_step_in();
  write_status_register(drive->type_I_status);

  // Update track register if requested.
  if (command & 0x10)
  {
    int8_t track;

    track = read_track_register();
    track++; // No hard stop (?)
    write_track_register(track);
  }
}

static void restore(void)
{
  ui_log_command((const far rom char*) "Restore", 0, 0, 0);

  while (drive->track)
  {
    wait_head_step();
    head_step_out();
    write_status_register(drive->type_I_status);
  }

  write_track_register(0);
}

static void seek(void)
{
  int8_t track;
  int8_t data;

  track = read_track_register();
  data = read_data_register();

  ui_log_command((const far rom char*) "Seek", track, data, 0);

  do
  {
    wait_head_step();

    track = read_track_register();
    data = read_data_register();

    if (track < data)
    {
      track++;
      head_step_in();
    }
    else if (track > data)
    {
      track--;
      head_step_out();
    }
    write_track_register(track);
    write_status_register(drive->type_I_status);
  }
  while (track != data);
}

static void wait_for_next_byte(void)
{
  // Wait for ~32us.
  /*Delay10TCYx(3);
          Nop();
          Nop();*/

  Delay10TCYx(19);
}

static uint8_t sample_side(void)
{
  uint8_t side_match;
  side_match = 1;

  // Sample side input.
  if (PORTAbits.RA2 == 1)
  {
    if (drive->side == 0)
      side_match = 0;
    drive->side = 1;
  }
  else
  {
    if (drive->side == 1)
      side_match = 0;
    drive->side = 0;
  }

  return side_match;
}

static uint8_t needs_reseek(void)
{
  if (!sample_side())
    return 1;

  if (drive_changed)
    return 1;

  return (fat32_sector_buffer_owner != &(drive->image_file));
}

static void sample_DSEL(void)
{
  uint8_t drive_number;

  /* Sample DSEL lines */
  drive_number = 0;
  if (PORTAbits.RA0 == 1)
    drive_number++;
  if (PORTAbits.RA1 == 1)
    drive_number += 2;

  /* Find out if the drive has changed */
  if (drive != 0)
    drive_changed = (drive->number != drive_number);
  else
    drive_changed = 1;

  /* Set active drive */
  drive = &wd179x_drive[drive_number];
}

static uint8_t image_track_seek(void)
{
  uint16_t block;

  // Calculate starting block.
  if (drive->image_geometry == IMAGE_GEO_TRACK_FIRST)
    block = 1 + ((uint16_t) (drive->track + drive->side * drive->image_tracks)) * 25;
  else
    block = 1 + ((uint16_t) (drive->track * drive->image_sides + drive->side)) * 25;

  drive->track_position = 0;
  return fat32_file_seek(&drive->image_file, (((uint32_t) block) << 8));
}

static void handle_type_I(void)
{
  // Set status for a type I command.
  write_status_register(drive->type_I_status);

  // Further decode command.
  if (command & 0x40)
  {
    if (command & 0x02)
      // Step-out.
      step_out();
    else
      // Step-in.
      step_in();
  }
  else if (command & 0x10)
    seek();
  else
    restore();

  // These commands cannot fail ATM.
  ui_set_status(ui_status_ok);

  // Seek in image file.	//?
  image_track_seek();

  // IRQ.
  generate_interrupt_request();
}

static uint8_t handle_read_sector(void)
{
  uint8_t i;
  uint16_t crc;
  uint8_t* pos;
  uint16_t cnt;
  uint8_t* buf;
  uint8_t byte;
  uint8_t track;
  uint8_t sector;
  uint32_t lba;

  // Update status?
  //write_status_register(0x0);

  // Read track and sector registers for verification.
  track = read_track_register();
  sector = read_sector_register();

  drive->last_read_sector = sector;

  if (needs_reseek())
    if (!image_track_seek())
    {
      sd_io_error();
      return 0;
    }

  ui_log_command((const far rom char*) "Read Sector", drive->side, track, sector);

  // Update display.
  ui_update_track(drive);

  if (drive->image_type == IMAGE_DSK_OLD)
  {
    /* IMPLEMENTME! */
  }

  if (drive->image_type == IMAGE_DSK_MFM)
  {
    // Due to the structure of DSK images, we can deal in 256 byte blocks.
    uint8_t byte;
    uint8_t idf;
    uint8_t max_idf;
    uint8_t df;
    uint16_t length;
    uint16_t bytes_left;

    idf = 0;
    max_idf = 0;
    bytes_left = 6250;
    while (1)
    {
      //n6610_debug_message((const far rom char*) "Searching ID Field");

      idf = 0;
      while (bytes_left)
      {
        CheckReadTrackEnd();
        TrackReadByte(&byte);
        bytes_left--;
        drive->track_position++;

        if (idf > max_idf)
          max_idf = idf;

        if (idf < 3)
          if (byte == 0xA1)
            idf++;
          else
            idf = 0;
        else if (idf == 3)
          if (byte == 0xFE)
            idf++;
          else
            idf = 0;
        else if (idf == 4)
        {
          max_idf = byte;
          if (byte == track)
            idf++;
          else
            idf = 0;
        }
        else if (idf == 5)
        {
          if (command & 0x02)
          {
            if (((command >> 3) & 0x01) == drive->side)
              idf++;
            else
              idf = 0;
          }
          else
            idf++;
        }
        else if (idf == 6)
        {
          if (byte == sector)
            idf++;
          else
            idf = 0;
        }
        else if (idf == 7)
        {
          if (byte < 4)
          {
            length = ((uint16_t) 128) << byte;
            idf++;

            // We have a complete ID Field.
            break;
          }
          else
            idf = 0;
        }
        else
          idf = 0;
      }

      if (idf != 8)
      {
        ui_set_status(ui_status_rnf);
        ui_log_status(0x10);
        write_status_register(0x10);
        break;
      }

      df = 0;
      i = 43;
      while (bytes_left && i)
      {
        CheckReadTrackEnd();
        TrackReadByte(&byte);
        bytes_left--;
        drive->track_position++;

        if (df < 3)
          if (byte == 0xA1)
            df++;
          else
            df = 0;
        else if (df == 3)
          if (byte == 0xFB)
          {
            df++;

            // We have a complete Data Field Header.
            break;
          }
          else
            df = 0;
        else
          df = 0;
      }

      if (df != 4)
      {
        // Could not find a DAM within range, keep searching.
        continue;
      }

      // Stream the whole data field out of the data bus.
      pos = sector_buffer;
      cnt = length;
      crc = 0xE295; /* Initialize with A1A1A1FB */

      while (cnt)
      {
        // Read data byte.
        CheckReadTrackEnd();
        TrackReadByte(&byte);

        *pos = byte;
        crc = (crc << 8) ^ crc_table[(crc >> 8) ^ byte];

        pos++;
        cnt--;
        drive->track_position++;
      }

      pos = sector_buffer;
      cnt = length;
      while (cnt)
      {
        write_data_register(*pos);
        generate_data_request();
        wait_for_next_byte();
        cnt--;
        pos++;
      }

      // Check CRC.
      CheckReadTrackEnd();
      TrackReadByte(&byte);
      drive->track_position++;

#ifdef WD179X_CHECK_CRC
      if (byte != (crc >> 8))
      {
        ui_set_status(ui_status_crc_error);
        ui_log_status(0x08);
        write_status_register(0x08);
        break;
      }
#endif

      CheckReadTrackEnd();
      TrackReadByte(&byte);
      drive->track_position++;

#ifdef WD179X_CHECK_CRC
      if (byte != (crc & 0xFF))
      {
        ui_set_status(ui_status_crc_error);
        ui_log_status(0x08);
        write_status_register(0x08);
        break;
      }
#endif

      // Multiple sectors?
      if (command & 0x10)
      {
        sector++;
        // Update sector register?
      }
      else
      {
        ui_set_status(ui_status_ok);
        write_status_register(0x0);
        break;
      }

      bytes_left = 6250;
    }
  }

  return 1;
}

static uint8_t handle_write_sector(void)
{
  uint8_t i;
  uint16_t crc;
  uint8_t* pos;
  uint16_t cnt;
  uint8_t* buf;
  uint8_t byte;
  uint8_t track;
  uint8_t sector;
  uint32_t lba;

  /* Check for write protect */
  if (drive->type_I_status & 0x40)
  {
    ui_set_status(ui_status_write_protect);
    /* FIXME! */
    ui_log_status(0x60);
    write_status_register(0x60);
    return 1;
  }

  // Read track and sector registers for verification.
  track = read_track_register();
  sector = read_sector_register();

  if (needs_reseek())
    if (!image_track_seek())
    {
      sd_io_error();
      return 0;
    }

  ui_log_command((const far rom char*) "Write Sector", drive->side, track, sector);

  if (drive->image_type == IMAGE_DSK_OLD)
  {

  }

  if (drive->image_type == IMAGE_DSK_MFM)
  {
    // Due to the structure of DSK images, we can deal in 256 byte blocks.
    uint8_t byte;
    uint8_t idf;
    uint8_t max_idf;
    uint8_t df;
    uint16_t length;
    uint16_t bytes_left;

    idf = 0;
    max_idf = 0;
    bytes_left = 6250;
    while (1)
    {
      //n6610_debug_message((const far rom char*) "Searching ID Field");

      idf = 0;
      while (bytes_left)
      {
        CheckReadTrackEnd();
        TrackReadByte(&byte);
        bytes_left--;
        drive->track_position++;

        if (idf > max_idf)
          max_idf = idf;

        if (idf < 3)
          if (byte == 0xA1)
            idf++;
          else
            idf = 0;
        else if (idf == 3)
          if (byte == 0xFE)
            idf++;
          else
            idf = 0;
        else if (idf == 4)
        {
          max_idf = byte;
          if (byte == track)
            idf++;
          else
            idf = 0;
        }
        else if (idf == 5)
        {
          if (command & 0x02)
          {
            if (((command >> 3) & 0x01) == drive->side)
              idf++;
            else
              idf = 0;
          }
          else
            idf++;
        }
        else if (idf == 6)
        {
          if (byte == sector)
            idf++;
          else
            idf = 0;
        }
        else if (idf == 7)
        {
          if (byte < 4)
          {
            length = ((uint16_t) 128) << byte;
            idf++;

            // We have a complete ID Field.
            break;
          }
          else
            idf = 0;
        }
        else
          idf = 0;
      }

      if (idf != 8)
      {
        ui_set_status(ui_status_rnf);
        ui_log_status(0x10);
        write_status_register(0x10);
        break;
      }

      n6610_set_font(FONT_6X8);

      // Generate DRQ.
      generate_data_request();

      // Count off 22 bytes.
      for (i = 0; i < 22; i++)
      {
        // Advance.
        CheckReadTrackEnd();
        TrackReadByte(&byte);
        drive->track_position++;

        wait_for_next_byte();
      }

      /* TODO: Check if DRQ's have been serviced */
      // Buffer the data from the CPU and calculate CRC.
      pos = sector_buffer;
      cnt = length;
      crc = 0xE295;
      while (cnt)
      {
        *pos = byte = read_data_register();
        crc = (crc << 8) ^ crc_table[(crc >> 8) ^ byte];
        generate_data_request();
        wait_for_next_byte();
        cnt--;
        pos++;
      }

      /* At this point, we can actually signal end of command to the CPU.
       * The actual write to SD Card may be deferred.
       */

      /* Write sector header to SD Card.
       * 6 zero bytes followed by DAM.
       */
      for (i = 0; i < 10; i++)
      {
        // Write
        CheckWriteTrackEnd();
        TrackWriteByte(sector_header[i]);
        drive->track_position++;
      }

      /* Now write data bytes to SD Card */
      cnt = length;
      pos = sector_buffer;
      while (cnt)
      {
        // Write data byte.
        CheckWriteTrackEnd();
        TrackWriteByte(*pos);
        pos++;
        cnt--;
        drive->track_position++;
      }

      // Write CRC bytes.
      CheckWriteTrackEnd();
      TrackWriteByte(crc >> 8);
      drive->track_position++;

      CheckWriteTrackEnd();
      TrackWriteByte(crc & 0xFF);
      drive->track_position++;

      fat32_file_flush(&drive->image_file);

      // Multiple sectors?
      if (command & 0x10)
      {
        sector++;
        // Update sector register?
      }
      else
      {
        ui_set_status(ui_status_ok);
        write_status_register(0x0);
        break;
      }

      bytes_left = 6250;
    }
  }

  return 1;
}

static uint8_t handle_type_II(void)
{
  uint8_t result;

  if (command & 0x20)
  {
    // Ready?
    if (drive->type_I_status & 0x80)
    {
      ui_set_status(ui_status_not_ready);
      ui_log_status(0x80);
      write_status_register(0x80);
      result = 1;
    }
    else if (!handle_write_sector())
      result = 0;
    else
      result = 1;
  }
  else
  {
    // Ready?
    if (drive->type_I_status & 0x80)
    {
      ui_set_status(ui_status_not_ready);
      ui_log_status(0x80);
      write_status_register(0x80);
      result = 1;
    }
    else if (!handle_read_sector())
      result = 0;
    else
      result = 1;
  }

  // IRQ.
  generate_interrupt_request();
  return result;
}

static uint8_t handle_read_address(void)
{
  uint8_t i;
  uint8_t byte;
  uint8_t track;
  uint32_t lba;

  // Update status?
  // write_status_register(0x0);
  ui_log_command((const far rom char*) "Read Address", 0, 0, 0);

  if (drive->image_type == IMAGE_DSK_OLD)
  {

  }

  if (drive->image_type == IMAGE_DSK_MFM)
  {
    // Due to the structure of DSK images, we can deal in 256 byte blocks.
    uint8_t byte;
    uint8_t idf;
    uint16_t length;
    uint16_t side;
    uint16_t block;
    uint16_t bytes_left;

    if (needs_reseek())
      if (!image_track_seek())
      {
        sd_io_error();
        return 0;
      }

    idf = 0;
    bytes_left = 6250;
    while (bytes_left)
    {

      CheckReadTrackEnd();
      TrackReadByte(&byte);
      bytes_left--;
      drive->track_position++;

      if (idf < 3)
        if (byte == 0xA1)
          idf++;
        else
          idf = 0;
      else if (idf == 3)
        if (byte == 0xFE)
        {
          idf++;

          // We have a complete IDAM.
          break;
        }
        else
          idf = 0;
    }

    if (idf != 4)
    {
      ui_set_status(ui_status_rnf);
      ui_log_status(0x10);
      write_status_register(0x10);
      return 1;
    }

    // Stream the address field out of the data bus.
    length = 6;
    while (bytes_left && length)
    {
      // Read data byte.
      CheckReadTrackEnd();
      TrackReadByte(&byte);
      bytes_left--;
      length--;
      drive->track_position++;

      if (length == 5)
        track = byte;

      write_data_register(byte);
      generate_data_request();
      wait_for_next_byte();
    }

    //n6610_debug_message((const far rom char*) "Streaming Done");
    ui_log_command((const far rom char*) "Track", track, 0, 0);

    ui_set_status(ui_status_ok);
    write_sector_register(track);
    write_status_register(0x0);
  }

  return 1;
}

static uint8_t handle_type_III(void)
{
  uint8_t result;

  if ((command & 0x30) == 0x00)
  {
    // Read Address.

    // Ready?
    if (drive->type_I_status & 0x80)
    {
      ui_set_status(ui_status_not_ready);
      ui_log_status(0x80);
      write_status_register(0x80);
      result = 1;
    }
    else if (!handle_read_address())
    {
      // An SD Card error has occurred.
      // How to setup errors?
      result = 0;
    }
    else
      result = 1;
  }

  // IRQ.
  generate_interrupt_request();
  return result;
}

static void handle_type_IV(void)
{
  //n6610_debug_message((const far rom char*) "Type IV");
}

void wd179X_handle_command_request(void)
{
  // Read the command register.
  PORTB = 0x02; // MFS = 0, MWE high, MOE low.
  Nop();
  command = PORTD;
  PORTB = 0x06; // MFS = 0, MWE high, MOE high.

  // Clear command request.
  PORTB = 0x34; // MFS = 6, MWE low, MOE high.
  WaitClockCycle;
  PORTB = 0x36; // MFS = 6, MWE high, MOE high.

  // Sample DSEL.
  sample_DSEL();

  // Decode command type.
  if (command & 0x80)
    if (command & 0x40)
      if ((command & 0x30) == 0x10)
        handle_type_IV();
      else
        handle_type_III();
    else
      handle_type_II();
  else
    handle_type_I();

  clear_busy_flag();
}

uint8_t wd179x_mount_image(uint8_t d, fat32_dir_entry* image)
{
  uint8_t i;
  uint32_t header_lba;

  fat32_file_from_dir_entry(&wd179x_drive[d].image_file, image);
  header_lba = fat32_file_get_lba(&wd179x_drive[d].image_file, 0);

  /* Read header sector into the sector buffer */
  if (!fat32_card_read(header_lba))
  {
#ifdef WD179X_DEBUG
    n6610_debug_message((const far rom char*) "SD Card Read Error");
#endif

    return 0;
  }

  /* Find out what kind of image it is */
  wd179x_drive[d].image_type = IMAGE_NONE;
  for (i = 0; i < 8; i++)
    if (fat32_sector_buffer[i] != str_ORICDISK[i])
      break;
  if (i == 8)
    wd179x_drive[d].image_type = IMAGE_DSK_OLD;

  for (i = 0; i < 8; i++)
    if (fat32_sector_buffer[i] != str_MFM_DISK[i])
      break;
  if (i == 8)
    wd179x_drive[d].image_type = IMAGE_DSK_MFM;

  if (wd179x_drive[d].image_type == IMAGE_NONE)
    return 0;

  if (wd179x_drive[d].image_type == IMAGE_DSK_OLD)
  {
    // IMPLEMENTME!
    return 0;
  }

  if (wd179x_drive[d].image_type == IMAGE_DSK_MFM)
  {
    wd179x_drive[d].image_sides = fat32_sector_buffer[8];
    wd179x_drive[d].image_tracks = fat32_sector_buffer[12];
    wd179x_drive[d].image_geometry = fat32_sector_buffer[16];

    /* Sanity checks */
    if (wd179x_drive[d].image_sides > 2)
      return 0;
    if (wd179x_drive[d].image_geometry != 1 && wd179x_drive[d].image_geometry != 2)
      return 0;
  }

  return 1;
}

void wd179x_init(void)
{
  uint8_t i;

  // PORTD (MD) Input.
  TRISEbits.PSPMODE = 0; // PSP off.
  TRISD = 0xFF;

  // nMCRQ Input, nMOE, nMWE, MFS Output (high)
  PORTB = 0xFF;
  TRISB = 0x01;

  // DSEL, SSEL Input.
  TRISAbits.TRISA0 = 1;
  TRISAbits.TRISA1 = 1;
  TRISAbits.TRISA2 = 1;

  // Init drive state.
  for (i = 0; i < 4; i++)
  {
    wd179x_drive[i].number = i;
    wd179x_drive[i].image_type = IMAGE_NONE;
    wd179x_drive[i].track = 0;
    wd179x_drive[i].last_read_sector = 0;
    wd179x_drive[i].side = 0;
    wd179x_drive[i].type_I_status = 0x64; // No errors, ready, protected, head loaded, track 0.
  }
  drive = 0;
  drive_changed = 1;
}

