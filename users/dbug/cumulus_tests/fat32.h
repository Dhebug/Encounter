/* Cumulus 18F46K20 Firmware
 * FAT32 Routines.
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

#ifndef _FAT32_H_
#define _FAT32_H_

#include "global.h"

#define LE16(card_sector, X)	(((uint16_t) card_sector[(X)]) + 			\
							    (((uint16_t) card_sector[(X) + 1]) << 8)) 	
				 
#define LE32(card_sector, X)	(((uint32_t) card_sector[(X)]) + 			\
								(((uint32_t) card_sector[(X) + 1]) << 8) +  	\
								(((uint32_t) card_sector[(X) + 2]) << 16) + 	\
								(((uint32_t) card_sector[(X) + 3]) << 24))		
				 
#define LBA(X) (cluster_begin_lba + ((X) - 2) * sectors_per_cluster)
//#define LBA(X) (cluster_begin_lba + (((X) - 2) << 3))


extern uint32_t cluster_begin_lba;
extern uint8_t sectors_per_cluster;
extern uint32_t fpp_begin_lba;
extern uint32_t fat_begin_lba;
extern uint32_t sectors_per_fat;
extern uint32_t cluster_begin_lba;
extern uint8_t sectors_per_cluster;
extern uint8_t fat_count;
extern uint16_t root_dir_first_cluster;
extern uint16_t reserved_sector_count;

typedef struct _fat32_cluster_range
{
	uint16_t start;
	uint16_t end;
	uint32_t cluster;
} fat32_cluster_range;

typedef struct _fat32_dir
{
	uint8_t* entry;
	uint32_t sector;
	uint32_t cluster;	
	uint8_t error;
} fat32_dir;

#define FLN_MAX_SIZE 21
#define MAX_RANGES 8 

typedef struct _fat32_file
{
	char name[FLN_MAX_SIZE + 1];
	char ext[4];
	uint8_t dir;						/* Is it a directory? */					
	uint32_t size;
	fat32_cluster_range ranges[MAX_RANGES];	/* Cluster ranges */
	uint32_t pos;						/* Position indicator for byte routines */
	uint8_t sector_valid;				/* Is sector buffer valid? */
	uint8_t sector_dirty;				/* Is sector buffer dirty? */
} fat32_file;

typedef struct _fat32_dir_entry
{
	char name[FLN_MAX_SIZE + 1];
	char ext[4];					
	uint8_t dir;					/* Is it a directory? */
	uint32_t size;
	uint32_t cluster;				/* Starting cluster */
} fat32_dir_entry;

extern uint8_t fat32_init(void);
extern uint8_t fat32_card_read(uint32_t sector);
extern uint8_t fat32_card_write(uint32_t sector);
extern void fat32_root_dir(fat32_dir_entry* file);
extern void fat32_dir_begin(fat32_dir* dir, fat32_dir_entry* file);
extern uint8_t fat32_dir_next(fat32_dir* dir, fat32_dir_entry* file, far rom char* ext);
extern uint32_t fat32_file_get_lba(fat32_file* file, uint32_t sector);
extern uint8_t fat32_file_read(fat32_file* file, uint32_t offset, uint32_t length, uint8_t* buffer);
extern uint8_t fat32_file_seek(fat32_file* file, uint32_t position);
extern uint8_t fat32_file_get_byte(fat32_file* file, uint8_t *byte);
extern uint8_t fat32_file_put_byte(fat32_file* file, uint8_t byte);
extern uint8_t fat32_file_flush(fat32_file* file);
extern uint8_t fat32_file_from_dir_entry(fat32_file* file, fat32_dir_entry* dir_entry);

extern uint8_t fat32_sector_buffer[512];
extern fat32_file* fat32_sector_buffer_owner;


#endif
