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

#include "sd-mmc.h"
#include "6610.h"
 

#define SPIDI	6	
#define SPIDO	5	
#define SPICLK	7	
#define SPICS	4	

uint8_t card_type;

/* SPI Send/Receive byte */
static uint8_t SPI(uint8_t d) 
{  
	char received = 0;
	
	SSPBUF = d;
	while (SSPSTATbits.BF != 1);		
	received = SSPBUF;
	
	return received;
}

//static inline void spi_read_block(uint8_t* buffer) 
void spi_read_block(uint8_t* buffer) 
{  
	char received = 0;
	uint8_t* buffer_end = buffer + 511;
	
	/* Get the first byte */
	SSPBUF = 0xFF;	
	while (SSPSTATbits.BF != 1);	
	received = SSPBUF;
	
	while (1)
	{		
		SSPBUF = 0xFF;	
		*buffer++ = received;
		if (buffer == buffer_end)
			break;
		while (SSPSTATbits.BF != 1);		
		received = SSPBUF;
	}
	
	while (SSPSTATbits.BF != 1);	
	*buffer = SSPBUF;
}

void spi_write_block(uint8_t* buffer) 
{  
	uint8_t dummy;
	uint16_t i = 512;
	
	while (1)
	{		
		SSPBUF = *buffer++;			
		i --;
		if (i <= 0)
			break;
		while (SSPSTATbits.BF != 1);	
		dummy = SSPBUF;
	}
	
	while (SSPSTATbits.BF != 1);	
	dummy = SSPBUF;
}

/* Send a command to SD/MMC */
uint8_t card_command(uint8_t cmd, uint16_t addrH, uint16_t addrL, uint8_t crc)
{	
	SPI(0xFF);
	SPI(cmd);
	SPI((uint8_t) (addrH >> 8));
	SPI((uint8_t) addrH);
	SPI((uint8_t) (addrL >> 8));
	SPI((uint8_t) addrL);
	SPI(crc);
	SPI(0xFF);	
	return SPI(0xFF);	// return the last received character
}

uint8_t card_set_block_length(uint16_t block_length) 
{
	uint16_t timeout_cntr = 0;

	/* Send CMD16 to set block length */ 	
	uint8_t result = card_command(0x50, 0, block_length, 0xFF);
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;	
		if (timeout_cntr > 2000)
			return 0;			
	}
		
	/* Done */	
	return 1;
}

/* Initalize SD/MMC Card */
uint8_t card_init(void) 
{ 
	uint8_t i;
	uint16_t timeout_cntr;	
	
	/* Slow clock during card identification */
	TRISCbits.TRISC3 = 0;	
	TRISCbits.TRISC5 = 0;	
	SSPCON1bits.SSPEN = 0;
	SSPCON1 = 0x12;			// CKP High, SPI Master, clock = Fosc/64
	SSPSTATbits.SMP = 0;
	//SSPSTATbits.SMP = 1;
	SSPSTATbits.CKE = 0;
	SSPCON1bits.SSPEN = 1;
	
	/* Raise Chip Select */
	TRISCbits.TRISC2 = 0;
	PORTCbits.RC2 = 1;	
	
	/* Switch card to SPI Mode */
	for(i = 0; i < 10; i ++) 
		SPI(0xFF); 
		
	/* Lower Chip Select */
	PORTCbits.RC2 = 0;

	/* Send CMD0 */
	if (card_command(0x40, 0x0000, 0x0000, 0x95) != 0x01) 
		return 0;

	card_type = CARD_TYPE_SD;	
	if ((card_command(0x48, 0x0000, 0x1AA, 0x87) & 4) == 0)	
	{
		SPI(0xFF);
		SPI(0xFF);		
		if ((SPI(0xFF) & 1) == 0)
			return 0;
		if (SPI(0xFF) != 0xAA)
			return 0;
			
		/* Send ACMD41 */ 	
		timeout_cntr = 0;
		while (1)
		{
			uint8_t result;

			card_command(0x77, 0x0000, 0x0000, 0xFF);
			result = card_command(0x69, 0x4000, 0x0000, 0xFF);
			if (result == 0x00)
				break;
		
			timeout_cntr ++;		
			if (timeout_cntr > 20000)		
				return 0;									
		}
	
		/* Send CMD58 */
		if (card_command(0x7A, 0x0000, 0x0000, 0xFF))
			return 0;			
		  
		if(SPI(0xFF) & 0x40)
			card_type = CARD_TYPE_SDHC;

		SPI(0xFF);
		SPI(0xFF);
		SPI(0xFF);							
	}							
	else
	{	
		/* Send CMD1 */ 	
		timeout_cntr = 0;
		while (card_command(0x41, 0x0000, 0x0000, 0xFF) != 0x00)
		{
			timeout_cntr ++;		
			if (timeout_cntr > 20000)
				return 0;		
		}
	}
		
	/* Set default block length of 512 */
	if (!card_set_block_length(512))
		return 0;	

	/* Raise Chip Select */
	PORTCbits.RC2 = 1;
	
	/* Speed up the clock */
	SSPCON1bits.SSPEN = 0;
	//SSPCON1 = 0x11;			// CKP High, SPI Master, clock = Fosc/16
	SSPCON1 = 0x10;			// CKP High, SPI Master, clock = Fosc/4
	SSPSTATbits.SMP = 0;
	//SSPSTATbits.SMP = 1;
	SSPSTATbits.CKE = 0;
	SSPCON1bits.SSPEN = 1;
	
	return 1;
}

/* Reads one sector of 512 bytes from the card */
uint8_t card_read(uint32_t sector, uint8_t* buffer) 
{
	uint16_t i;
	uint8_t result;
	uint16_t timeout_cntr;
	uint8_t card_response; 
	
	uint32_t address = (card_type == CARD_TYPE_SDHC) ? (sector) : (sector << 9);		
		
	/* Lower Chip Select */
	PORTCbits.RC2 = 0;

	/* Send CMD17 */
	timeout_cntr = 0;
	result = card_command(0x51, (uint16_t) (address >> 16), (uint16_t) address, 0xFF);	
				
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;
		if (timeout_cntr > 48000)
			return 0;			
	}
			
	/* Wait until 0xFE is received */
	timeout_cntr = 0;
	while ((card_response = SPI(0xFF)) == (uint8_t) 0xFF)
	{		
		timeout_cntr ++;
		if (timeout_cntr > 48000)
			return 0;					
	}
		
	if (card_response != 0xFE)	
		return 0;						
	
	/* Read data */
	for(i = 0; i < 512; i ++) 
		buffer[i] = SPI(0xFF);  
			
	/* Receive CRC */
	SPI(0xFF); 
	SPI(0xFF);
		
	/* Let the card finish */
	SPI(0xFF); 
			
	return 1;	
}

/* Verifies one sector of 512 bytes on the card */
uint8_t card_verify(uint32_t sector, uint8_t* buffer) 
{
	uint16_t i;
	uint8_t result;
	uint16_t timeout_cntr;
	uint8_t card_response; 
	uint8_t match;
	
	uint32_t address = (card_type == CARD_TYPE_SDHC) ? (sector) : (sector << 9);		
		
	/* Lower Chip Select */
	PORTCbits.RC2 = 0;

	/* Send CMD17 */
	timeout_cntr = 0;
	result = card_command(0x51, (uint16_t) (address >> 16), (uint16_t) address, 0xFF);	
				
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;
		if (timeout_cntr > 48000)
			return 0;			
	}
			
	/* Wait until 0xFE is received */
	timeout_cntr = 0;
	while ((card_response = SPI(0xFF)) == (uint8_t) 0xFF)
	{		
		timeout_cntr ++;
		if (timeout_cntr > 48000)
			return 0;					
	}
		
	if (card_response != 0xFE)	
		return 0;						
	
	/* Read data */
	match = 1;
	for(i = 0; i < 512; i ++) 
		if (buffer[i] != SPI(0xFF))
			match = 0;
			
	/* Receive CRC */
	SPI(0xFF); 
	SPI(0xFF);
		
	/* Let the card finish */
	SPI(0xFF); 
			
	return match;	
}

/* Reads part of one sector from the card */
uint8_t card_read_sub(uint32_t sector, uint16_t offset, uint16_t length, uint8_t* buffer) 
{
	uint16_t i;
	uint8_t dummy;
	uint8_t result;
	uint16_t timeout_cntr;
	uint8_t card_response; 
	
	uint32_t address = (card_type == CARD_TYPE_SDHC) ? (sector) : (sector << 9);		
		
	/* Send CMD17 */
	timeout_cntr = 0;
	result = card_command(0x51, (uint16_t) (address >> 16), (uint16_t) address, 0xFF);	
				
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;
		if (timeout_cntr > 48000)		
			return 0;			
	}
			
	/* Wait until 0xFE is received */
	timeout_cntr = 0;
	while ((card_response = SPI(0xFF)) == (uint8_t) 0xFF)
	{		
		timeout_cntr ++;
		if (timeout_cntr > 48000)
			return 0;					
	}
		
	if (card_response != 0xFE)	
		return 0;						
	
	/* Discard bytes until offset */
	for(i = 0; i < offset; i ++) 
		dummy = SPI(0xFF);  
		
	/* Read data */
	for(i = 0; i < length; i ++) 
		buffer[i] = SPI(0xFF);  

	/* Discard the rest */
	for(i = offset + length; i < 512; i ++) 
		dummy = SPI(0xFF);  
			
	/* Receive CRC */
	SPI(0xFF); 
	SPI(0xFF);
		
	/* Let the card finish */
	SPI(0xFF); 
			
	return 1;
}

/* Reads multiple sectors of 512 bytes from the card */
uint8_t card_read_multi(uint32_t sector, uint8_t* buffer, uint8_t count) 
{
	uint8_t result;
	uint16_t timeout_cntr;
	uint8_t card_response; 
	
	uint32_t address = (card_type == CARD_TYPE_SDHC) ? (sector) : (sector << 9);
		
	/* Send CMD18 */
	timeout_cntr = 0;
	result = card_command(0x52, (uint16_t) (address >> 16), (uint16_t) address, 0xFF);	
				
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;
		if (timeout_cntr > 48000)		
			return 0;		
	}
	
	while (count)
	{		
		/* Wait until 0xFE is received */
		timeout_cntr = 0;
		while ((card_response = SPI(0xFF)) == (uint8_t) 0xFF)
		{		
			timeout_cntr ++;
			if (timeout_cntr > 48000)
				return 0;		
		}		
			
		if (card_response != 0xFE)	
			return 0;					
		
		/* Read data */
		/*for(uint8_t i = 0; i < 512; i ++) 
			buffer[i] = SPI(0xFF);  */
		spi_read_block(buffer);				
				
		/* Receive CRC */
		SPI(0xFF); 
		SPI(0xFF);
			
		/* Let the card finish */
		SPI(0xFF); 
		
		buffer += 512;
		count --;
	}
	
	/* Send CMD12 */
	result = card_command(0x4C, 0, 0, 0xFF);
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;
		if (timeout_cntr > 48000)		
			return 0;		
	}	
	
	/* Wait until the MMC is no longer busy */
	while(SPI(0xFF) != 0xFF);	
		
	return 1;	
}

/* Writes one sector of 512 bytes to the card */
uint8_t card_write(uint32_t sector, uint8_t* buffer) 
{
	uint16_t i;
	uint8_t result;
	uint16_t timeout_cntr;
	uint8_t card_response; 
	
	uint32_t address = (card_type == CARD_TYPE_SDHC) ? (sector) : (sector << 9);
	
	/* Send CMD24 */
	timeout_cntr = 0;	
	result = card_command(0x58, (uint16_t) (address >> 16), (uint16_t) address, 0xFF);
	
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;
		if (timeout_cntr > 48000)		
			return 0;		
	}
	
	SPI(0xFF);
	SPI(0xFF);
	SPI(0xFE);
	
	/* Send data */
	for (i = 0; i < 512; i ++) 
		SPI(buffer[i]);
	
	/* Send 2 dummy bytes */
	SPI(0xFF);
	SPI(0xFF);

	card_response = SPI(0xFF);
	card_response &= 0x1F; 	
	if (card_response != 0x05) 
	{ 
		/* Write error */
		return 0;
	}
	
	/* Wait until the MMC is no longer busy */
	while(SPI(0xFF) != 0xFF);
	
	return 1;
}

/* Writes multiple sectors of 512 bytes to the card */
uint8_t card_write_multi(uint32_t sector, uint8_t* buffer, uint8_t count) 
{
	uint8_t result;
	uint16_t timeout_cntr;
	uint8_t card_response; 
	
	uint32_t address = (card_type == CARD_TYPE_SDHC) ? (sector) : (sector << 9);
	
	/* Send CMD25 */
	timeout_cntr = 0;	
	result = card_command(0x59, (uint16_t) (address >> 16), (uint16_t) address, 0xFF);
	
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;
		if (timeout_cntr > 48000)		
			return 0;		
	}
	
	while (count)
	{	
		/* Start of block */		
		SPI(0xFC);
		
		/* Send data */
		/*for (i = 0; i < 512; i ++) 
			SPI(buffer[i]);*/
		spi_write_block(buffer);
			
		/* Send 2 dummy bytes */
		SPI(0xFF);
		SPI(0xFF);

		card_response = SPI(0xFF);
		card_response &= 0x1F; 	
		if (card_response != 0x05) 
		{ 
			/* Write error */
			return 0;
		}
		
		/* Wait until the MMC is no longer busy */
		while(SPI(0xFF) != 0xFF);
		
		/* Extra 8 bits */
		SPI(0xFF);		
		count --;
		buffer += 512;
	}	
	
	/* Send CMD12 */
	result = card_command(0x4C, 0, 0, 0xFF);
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;
		if (timeout_cntr > 48000)		
			return 0;		
	}	
	
	/* Wait until the MMC is no longer busy */
	while(SPI(0xFF) != 0xFF);	

	/* Send CMD13 */
	result = card_command(0x4D, 0, 0, 0xFF);
	while (result != 0)
	{
		result = SPI(0xFF);
		timeout_cntr ++;
		if (timeout_cntr > 48000)		
			return 0;		
	}	
	SPI(0xFF);	// Second byte.
	SPI(0xFF);
	
	return 1;

}

