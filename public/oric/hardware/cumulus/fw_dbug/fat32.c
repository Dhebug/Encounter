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

#include "global.h"

#include "fat32.h"
#include "6610.h"
#include "sd-mmc.h"

#pragma udata
uint32_t fpp_begin_lba;
uint32_t fat_begin_lba;
uint32_t sectors_per_fat;
uint32_t cluster_begin_lba;
uint8_t sectors_per_cluster;
uint8_t fat_count;
uint16_t root_dir_first_cluster;
uint16_t reserved_sector_count;
fat32_file* fat32_sector_buffer_owner;

#pragma udata fat32_sector_buffer_section
uint8_t fat32_sector_buffer[512];

#pragma code
uint8_t fat32_card_read(uint32_t sector)
{
	fat32_sector_buffer_owner = 0;
	return card_read(sector, fat32_sector_buffer);
}

uint8_t fat32_card_write(uint32_t sector)
{
	fat32_sector_buffer_owner = 0;
	return card_write(sector, fat32_sector_buffer);
}

/* Initializes FAT32 support */
uint8_t fat32_init(void)
{
	uint16_t bytes_per_sector;	

	/* Read sector 0 into the sector buffer */
	if (!fat32_card_read(0))
		return 0;

	/* Depending on whether SD Card controller firmware reports 
	 * itself as removable media or not, it may or may not have an
	 * MBR. If there is no MBR, sector 0 will be the boot sector, as
	 * in a floppy. If the first byte of sector 0 is 0xEB, we assume
	 * it's the boot sector (LBR).
	 */
	 		
	if (fat32_sector_buffer[0] != 0xEB)
	{
		/* Find out the starting sector of the first primary partition */ 
		fpp_begin_lba = LE32(fat32_sector_buffer, 454);		

		/* Read FAT32 Volume ID into the sector buffer */
		if (!fat32_card_read(fpp_begin_lba))
			return 0;
	}
	else
		fpp_begin_lba = 0; 			
	
	/* Sanity check */
	bytes_per_sector = LE16(fat32_sector_buffer, 11);
	if (bytes_per_sector != 512)
		return 0;		
	
	/* Compute important FAT locations */
	reserved_sector_count = LE16(fat32_sector_buffer, 14);
	fat_count = fat32_sector_buffer[16];
	sectors_per_fat = LE32(fat32_sector_buffer, 36);
	
	fat_begin_lba = fpp_begin_lba + reserved_sector_count;
	cluster_begin_lba = fpp_begin_lba + reserved_sector_count + (fat_count * sectors_per_fat);
	
	sectors_per_cluster = fat32_sector_buffer[13];

	if (sectors_per_cluster < 16)
		return 0;	
	
	root_dir_first_cluster = LE32(fat32_sector_buffer, 44);

	return 1;
}

/* Move on to the next directory entry in the sector buffer */
/* If necessary reads in new sectors. */
void next_dir_entry(fat32_dir* dir)
{
	uint32_t sector;

	dir->entry += 32;
	
	/* Do we need to read in a new sector */
	if (dir->entry >= fat32_sector_buffer + 512)
	{
		dir->sector ++;
		if (dir->sector >= sectors_per_cluster)
		{
			/* Need to find next cluster for the directory */
			
			/* Find out FAT32 sector number for current cluster */
			uint32_t fat_sector = fat_begin_lba + (dir->cluster / 128);

			/* Read FAT32 sector into the sector buffer */
			if (!fat32_card_read(fat_sector))
			{
				dir->error = 1;
				return;
			}
				
			/* Find out the next cluster */
			dir->cluster = LE32(fat32_sector_buffer, (dir->cluster % 128) * 4);
			
			/* No more clusters? */
			if (dir->cluster == 0xFFFFFFFF)
				return;
					
			dir->sector = 0;			
		}
		
		/* Read directory first sector into the sector buffer */
		sector = LBA(dir->cluster) + dir->sector;
		if (!fat32_card_read(sector))
		{
			dir->error = 1;
			return;
		}		
			
		/* Back to the beginning of the sector buffer */
		dir->entry = fat32_sector_buffer;
	}
}

/* Returns FAT32 root directory */
void fat32_root_dir(fat32_dir_entry* file)
{
	file->cluster = root_dir_first_cluster;
	file->dir = 1;
}

/* Begins reading from FAT32 directory */
void fat32_dir_begin(fat32_dir* dir, fat32_dir_entry* file)
{
	uint32_t dir_begin_lba;	

	if (file->cluster == 0)
		fat32_root_dir(file);
	
	dir_begin_lba = LBA(file->cluster);
	
	/* Read directory first sector into the sector buffer */
	if (!fat32_card_read(dir_begin_lba))
	{
		dir->error = 1;		
		return;	
	}
	
	/* Init */		
	dir->entry = fat32_sector_buffer;
	dir->sector = 0;	
	dir->cluster = file->cluster;
	dir->error = 0;
}

/* Reads next entry in the FAT32 root directory */
uint8_t fat32_dir_next(fat32_dir* dir,  fat32_dir_entry* file, far rom char* ext)
{
	const uint8_t lfn_char_pos[] = { 1, 3, 5, 7, 9, 14, 16, 18, 20, 22, 24, 28, 30 };
	
	uint8_t i;
	char* c;
	
	/* Initial check */
	if (dir->error == 1 || dir->cluster == 0xFFFFFFFF)		
		return 0;
	
	/* Clear filename buffer, including end marker */
	for (i = 0; i <= FLN_MAX_SIZE; i ++)
		file->name[i] = 0;
	for (i = 0; i <= 3; i ++)
		file->ext[i] = 0;
		
	/* Go over dir entries in succession */		
	while (dir->entry[0] != 0x00)
	{
		/* Is this an LFN entry? */		
		if (dir->entry[11] == 0x0F)
		{
			/* Extract sequence number */
			uint8_t seq_number = dir->entry[0] & 0x3F;

			/* Compute sequence boundaries */
			char* fln_seq_end = file->name + 13 * seq_number;
			char* fln_seq_start = fln_seq_end - 13;
					
			/* Make sure that we do not overrun the filename buffer */
			if (fln_seq_end > file->name + FLN_MAX_SIZE)
				fln_seq_end = file->name + FLN_MAX_SIZE;
			
			for (c = fln_seq_start, i = 0; c < fln_seq_end; c ++, i ++)		
			{
				*c = dir->entry[lfn_char_pos[i]];
				if (*c == 0)
					break;
			}
		}
		else 
		{	
			/* Is it a deleted file or a volume label? */
			if ((dir->entry[0] != 0xE5) && (dir->entry[11] != 0x08))
			{
				uint8_t ext_fits = 0;
			
				if (ext && !(dir->entry[11] & 0x10))
				{
					far rom char* cur_ext = ext;
					uint8_t ext_id = 0;
					while (*cur_ext)
					{
						if (cur_ext[0] == dir->entry[8] && 					
							cur_ext[1] == dir->entry[9] &&  
							cur_ext[2] == dir->entry[10])
						{
							ext_fits = 1;
							file->ext[0] = cur_ext[0];
							file->ext[1] = cur_ext[1];
							file->ext[2] = cur_ext[2];
							break;
						}
						else
						{
							cur_ext += 3;
							ext_id ++;
						}
					}
				}
				else
					ext_fits = 1;		
			
				/* Check if the extension fits */
					
				if (ext_fits)
				{				
					/* Get the cluster number */
					file->cluster = ((uint32_t) dir->entry[26]) + 
									((uint32_t) dir->entry[27] << 8) + 
									((uint32_t) dir->entry[20] << 16) + 
									((uint32_t) dir->entry[21] << 24);	
					
					/* Get the size */
					file->size = LE32(dir->entry, 28);
					file->dir = (dir->entry[11] & 0x10);
												
					/* Maybe this is not a LFN entry */
					if (file->name[0] == 0)
					{
						for (i = 0; i < 8; i ++)
							file->name[i] = dir->entry[i];
					
						if (dir->entry[8] != 0x20)		
						{
							file->name[8] = '.';
							file->name[9] = dir->entry[8];
							file->name[10] = dir->entry[9];
							file->name[11] = dir->entry[10];				
						}
						else
						{
							file->name[8] = 0x20;
							file->name[9] = 0x20;
							file->name[10] = 0x20;
							file->name[11] = 0x20;
						}
					}
					
					/* Make sure to get the next entry before reporting success */
					next_dir_entry(dir);				
					return 1;				
				}
			}
			
			/* Try the next one */
			/* Clear filename buffer, including end marker */
			for (i = 0; i <= FLN_MAX_SIZE; i ++)
				file->name[i] = 0;
		}		
		
		/* Move on to next entry */
		next_dir_entry(dir);
		if (dir->error == 1 || dir->cluster == 0xFFFFFFFF)			
			return 0;			
	}
	
	/* End of directory, nothing read */
	return 0;
}

/* Fills the cluster table for the file */
uint8_t fat32_file_from_dir_entry(fat32_file* file, fat32_dir_entry* dir_entry)
{
	uint8_t i;
	uint8_t range;
	uint32_t cluster, next_cluster;
	uint32_t cluster_count;
	uint32_t fat_sector_index = 0xFFFFFFFF;
	
	/* Copy everything over */
 	for (i = 0; i < sizeof(fat32_dir_entry); i ++)
		((uint8_t*)file)[i] = ((uint8_t*)dir_entry)[i];

	/* More init */
	file->pos = 0;
	file->sector_valid = 0;
	file->sector_dirty = 0;

	/* TODO!: Check for overflow (MAX Size 500MB) */

	for (i = 0; i < MAX_RANGES; i ++)
	{
		file->ranges[i].start = 0;
		file->ranges[i].end = 0;
		file->ranges[i].cluster = 0;
	}

	cluster = dir_entry->cluster;
	range = 0;
	file->ranges[0].cluster = cluster;

	while(1)
	{
		file->ranges[range].end ++;

		if (cluster >> 7 != fat_sector_index)
		{
			/* Read FAT32 sector into the sector buffer */
			fat_sector_index = cluster >> 7;
			if (!fat32_card_read(fat_sector_index + fat_begin_lba))
				return 0;
		}

		next_cluster = LE32(fat32_sector_buffer, (cluster & 0x7F) << 2); 
		if (next_cluster >= 0x0FFFFFF8)
			break;

		if (next_cluster != cluster + 1)
		{
			/* Discontinuity, create new range */
			range ++;
			if (range >= MAX_RANGES)
				return 0;
	
			file->ranges[range].start = file->ranges[range - 1].end;		 
			file->ranges[range].end = file->ranges[range].start + 1;
			file->ranges[range].cluster = next_cluster;
		}

		cluster = next_cluster;
	}
}

/* Looks up the cluster table for the given sector */
extern uint32_t fat32_file_get_lba(fat32_file* file, uint32_t sector)
{
	uint8_t i;
	uint32_t cluster = sector / sectors_per_cluster;
	uint32_t offset = sector % sectors_per_cluster;

	/* Search the ranges */
	for (i = 0; i < MAX_RANGES; i ++)
	{
		if (file->ranges[i].start == file->ranges[i].end)
			return 0;		/* Error, sector not found in ranges */
		
		if (cluster >= file->ranges[i].start && cluster < file->ranges[i].end)
			return LBA(cluster - file->ranges[i].start + file->ranges[i].cluster) + offset; 
	}
	
	return 0; /* Error, sector not found in ranges */
}

/* Reads bytes into buffer from file. */
extern uint8_t fat32_file_read(fat32_file* file, uint32_t offset, uint32_t length, uint8_t* buffer)
{
	uint32_t lba;

	while (length)
	{
		uint32_t sector = offset / 512;
		uint16_t offset_s = (offset % 512);
		uint16_t length_s = 512 - offset_s;
		if (length_s > length)
			length_s = length;

		lba = fat32_file_get_lba(file, sector);
		fat32_sector_buffer_owner = 0;
		if (!card_read_sub(lba, offset_s, length_s, buffer))
			return 0;

		buffer += length_s;
		offset += length_s;
		length -= length_s;
	}

}

uint8_t fat32_file_seek(fat32_file* file, uint32_t position)
{
	file->pos = position;
	file->sector_valid = 0;

	return 1;
}

uint8_t fat32_file_get_byte(fat32_file* file, uint8_t *byte)
{
	uint32_t lba;
	uint16_t sector_pos;

	if (!file->sector_valid)
	{
		lba = fat32_file_get_lba(file, (file->pos >> 9));
		if (!fat32_card_read(lba))
			return 0;		
		file->sector_valid = 1;
		fat32_sector_buffer_owner = file;
	}
		
	sector_pos = file->pos & 0x1FF;
	if (sector_pos == 0x1FF)
	{
		file->sector_valid = 0;
		if (file->sector_dirty)
		{
			lba = fat32_file_get_lba(file, (file->pos >> 9));
			if (!fat32_card_write(lba))
				return 0;		
			file->sector_dirty = 0;
		}
	}
		
	*byte = fat32_sector_buffer[sector_pos];
	file->pos ++;
	return 1;
}

uint8_t fat32_file_put_byte(fat32_file* file, uint8_t byte)
{
	uint32_t lba;
	uint16_t sector_pos;

	if (!file->sector_valid)
	{
		lba = fat32_file_get_lba(file, (file->pos >> 9));
		if (!fat32_card_read(lba))
			return 0;		
		file->sector_valid = 1;
		fat32_sector_buffer_owner = file;
	}
		
	sector_pos = file->pos & 0x1FF;
	fat32_sector_buffer[sector_pos] = byte;
	file->sector_dirty = 1;
	if (sector_pos == 0x1FF)
	{
		file->sector_valid = 0;	
		if (file->sector_dirty)
		{
			lba = fat32_file_get_lba(file, (file->pos >> 9));
			if (!fat32_card_write(lba))
				return 0;		
			file->sector_dirty = 0;
		}
	}
		
	file->pos ++;
	return 1;
}

uint8_t fat32_file_flush(fat32_file* file)
{
	uint32_t lba;

	if (file->sector_dirty && file->sector_valid)
	{
		lba = fat32_file_get_lba(file, (file->pos >> 9));
		if (!fat32_card_write(lba))
			return 0;		
		file->sector_dirty = 0;
	}

	return 1;
}
