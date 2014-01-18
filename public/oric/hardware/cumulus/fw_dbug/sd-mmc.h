/* Cumulus 18F46K20 Firmware
 * SD Card Access Routines.
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
 
#define CARD_TYPE_SD 0
#define CARD_TYPE_SDHC 1
 
extern uint8_t card_timeout; 
extern uint8_t card_type;

extern void spi_init(void);
extern uint8_t card_init(void);
extern uint8_t card_read(uint32_t sector, uint8_t* buffer);
extern uint8_t card_verify(uint32_t sector, uint8_t* buffer);
extern uint8_t card_read_sub(uint32_t sector, uint16_t offset, uint16_t length, uint8_t* buffer);
extern uint8_t card_read_multi(uint32_t sector, uint8_t* buffer, uint8_t count);
extern uint8_t card_write(uint32_t sector, uint8_t* buffer);
extern uint8_t card_write_multi(uint32_t sector, uint8_t* buffer, uint8_t count);
extern void card_clear_status(void);

extern void spi_read_block(uint8_t* buffer);

