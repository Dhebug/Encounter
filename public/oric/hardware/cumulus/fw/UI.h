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

#ifndef _UI_H_
#define _UI_H_

#include "179X.H"

typedef enum 
{
	ui_status_ok = 0,
	ui_status_sd_io_error,
	ui_status_rnf,
	ui_status_crc_error,
	ui_status_write_protect,
	ui_status_not_ready,
	ui_status_count
} ui_status;

extern void ui_init(void);
extern void ui_update_track(drive_state* drive);
extern void ui_run(void);
extern void ui_wd1793_command_active(void);
extern void ui_wd1793_command_done(void);
extern void ui_set_status(ui_status s);
extern void ui_log_status(uint8_t val);
extern void ui_log_command(const far rom char* msg, uint8_t val1, uint8_t val2, uint8_t val3);

#endif