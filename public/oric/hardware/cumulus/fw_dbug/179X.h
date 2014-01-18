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

#ifndef _179X_H
#define _179X_H

#include "fat32.h"

// Image format types.
#define IMAGE_NONE		0 
#define IMAGE_DSK_OLD	1 
#define IMAGE_DSK_MFM	2

// Image geometry types.
#define IMAGE_GEO_TRACK_FIRST	1
#define IMAGE_GEO_SIDE_FIRST 	2

typedef struct _drive_state
{
	fat32_file image_file;		// DSK image file.
	uint8_t image_type;			// "OLD" or "MFM" format.
	uint8_t image_sides;		// Number of sides.
	uint8_t image_tracks;		// Number of tracks.
	uint8_t image_geometry;		// Geometry type.
	uint8_t number;				// Drive number (0 to 3).
	uint8_t side;				// Selected side.
	int8_t track;				// Head track location.
        uint8_t last_read_sector;       // Last read sector command
	uint16_t track_position;	// Track bytes.
	uint8_t type_I_status;
} drive_state;

extern drive_state wd179x_drive[4];

extern void wd179x_init(void);
extern uint8_t wd179x_mount_image(uint8_t drive, fat32_dir_entry* image);
extern void wd179X_handle_command_request(void);

#endif