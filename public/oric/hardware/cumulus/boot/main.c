/* Cumulus 18F46K20 Firmware
 * SD Card Bootloader.
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

#include "p18f46K20.h" 
#include "delays.h" 

#ifdef TEXT_SUPPORT
#define NOFONT8X16
#include "fonts.h" 
#endif

/* Config */
#pragma config FOSC = ECIO6
#pragma config FCMEN = OFF
#pragma config IESO = OFF
#pragma config PWRT = ON
#pragma config BOREN = OFF
#pragma config MCLRE = ON
#pragma config WDTEN = OFF
#pragma config LPT1OSC = OFF
#pragma config PBADEN = OFF
#pragma config STVREN = ON
#pragma config LVP = OFF 
#pragma config XINST = OFF
#pragma config DEBUG = OFF
#pragma config CP0 = OFF
#pragma config CP1 = OFF
#pragma config CP2 = OFF
#pragma config CP3 = OFF
#pragma config CPB = OFF
#pragma config CPD = OFF
#pragma config WRT0 = OFF
#pragma config WRT1 = OFF
#pragma config WRT2 = OFF
#pragma config WRT3 = OFF
#pragma config WRTB = OFF
#pragma config WRTC = OFF
#pragma config WRTD = OFF

typedef signed char int8_t;
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long uint32_t;
typedef long int32_t;

#pragma udata
uint32_t fpp_begin_lba;
uint32_t fat_begin_lba;
uint32_t sectors_per_fat;
uint32_t cluster_begin_lba;
uint8_t sectors_per_cluster;
uint8_t fat_count;
uint16_t root_dir_first_cluster;
uint16_t reserved_sector_count;

#pragma udata sector_buffer_section
uint8_t sector_buffer[512];

#define RM_RESET_VECTOR 			0x001000
#define RM_HIGH_INTERRUPT_VECTOR    0x001008 
#define RM_LOW_INTERRUPT_VECTOR     0x001018 

/* Vector remapping */
#pragma code _HIGH_INTERRUPT_VECTOR = 0x000008
void _high_ISR (void)
{
    _asm goto RM_HIGH_INTERRUPT_VECTOR _endasm
}

#pragma code _LOW_INTERRUPT_VECTOR = 0x000018
void _low_ISR (void)
{
    _asm goto RM_LOW_INTERRUPT_VECTOR _endasm
}

#pragma code
far rom char str_cumulus_bin[] = "CUMULUS BIN";

uint8_t erase_program_verify_page(uint16_t address, uint8_t* buf)
{
	uint8_t i;
	far rom uint8_t* rom_ptr;
    rom_ptr = (far rom uint8_t*) address;
 
	/* Dummy read, required for loading the table pointer */
	i = *rom_ptr;

	/* Erase */
    EECON1bits.EEPGD = 1;     
    EECON1bits.CFGS = 0;      
    EECON1bits.FREE = 1;      
    EECON1bits.WREN = 1;      
    INTCONbits.GIE = 0;     
    EECON2 = 0x55;          
    EECON2 = 0xAA; 
    EECON1bits.WR = 1;      
    INTCONbits.GIE = 1;                   

	/* Write 64 bytes */
    for (i = 0; i < 64; i++) 
        rom_ptr[i] = buf[i];    

    EECON1bits.EEPGD = 1;               
    EECON1bits.CFGS = 0;                
    EECON1bits.FREE = 0;                
    EECON1bits.WREN = 1;                
    INTCONbits.GIE = 0;     
    EECON2 = 0x55;          
    EECON2 = 0xAA; 
    EECON1bits.WR = 1;      
    INTCONbits.GIE = 1;     
    EECON1bits.WREN = 0;           

	/* Verify 64 bytes */
    for (i = 0; i < 64; i++) 
        if (rom_ptr[i] != buf[i])
			return 0;

	return 1;          
}

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

#if defined(PCF8833) || defined(S1D15G10)

/* Initialize EUSART module used for 9-bit SPI transmission. */
static void init_EUSART(void)
{
	/* Set baud rate */
	BAUDCONbits.CKTXP = 1;
	BAUDCONbits.BRG16 = 0;
	SPBRGH = 0;
	SPBRG = 1;

	/* Set TRIS bits */
	TRISCbits.TRISC6 = 1;
	TRISCbits.TRISC7 = 1;
	
	/* Synchronous Master mode */
	TXSTAbits.SYNC = 1;
	TXSTAbits.CSRC = 1;
	RCSTAbits.SPEN = 1;
	 
	/* Receive disabled, transmit enabled */
	RCSTAbits.SREN = 0;
	RCSTAbits.CREN = 0;
	TXSTAbits.TXEN = 1;
	
	/* 9-bit transmission */
	TXSTAbits.TX9 = 1;
}

/* Write given command byte to LCD */
static void n6610_write_command(uint8_t command)
{
	uint8_t value;

	/* Move highest bit into TX9D */
	if (command & 0x80)
		TXSTAbits.TX9D = 1;
	else 
		TXSTAbits.TX9D = 0;

	/* Command byte */
 	value = (command << 1);	

	/* Wait until EUSART transmitter is free */
	while (!TXSTAbits.TRMT);
	TXREG = value;	
}

/* Write given data byte to LCD */
static void n6610_write_data(uint8_t data)
{
	uint8_t value;

	/* Move highest bit into TX9D */
	if (data & 0x80)
		TXSTAbits.TX9D = 1;
	else 
		TXSTAbits.TX9D = 0;

	/* Data byte */
	value = (data << 1) | 1;

	/* Wait until EUSART transmitter is free */
	while (!TXSTAbits.TRMT);
	TXREG = value;		
}

static const rom uint8_t reverse_table[16] = {
0b0000,
0b1000,
0b0100,
0b1100,
0b0010,
0b1010,
0b0110,
0b1110,
0b0001,
0b1001,
0b0101,
0b1101,
0b0011,
0b1011,
0b0111,
0b1111
};

static uint8_t reverse_bits(uint8_t value)
{
	uint8_t rev;

	rev = reverse_table[value & 0x0F] << 4;
	rev |= reverse_table[(value & 0xF0) >> 4];

	return rev;
}

/* Draws given area with given color. Area width must be multiple of 2. */
static void n6610_fill_area(uint8_t x, uint8_t y, uint8_t w, uint8_t h, uint8_t v1, uint8_t v2, uint8_t v3)
{ 
	uint8_t i, j;

	x = (x & 0xFE);
	w = (w & 0xFE);

  	/* Page address set */
	n6610_write_command(CASET); 
	n6610_write_data(reverse_bits(x)); 
	n6610_write_data(reverse_bits(x + w - 1)); 

	/* Column address set */
	n6610_write_command(PASET); 
 	n6610_write_data(reverse_bits(y)); 
	n6610_write_data(reverse_bits(y + h - 1)); 
 
 	/* Fill memory */
 	n6610_write_command(RAMWR); 
	
	for (i = 0; i < w / 2; i ++)
 		for (j = 0; j < h; j ++)
		{
			n6610_write_data(v1);
			n6610_write_data(v2);
			n6610_write_data(v3);
		}
} 

#ifdef TEXT_SUPPORT
/* Draws given character in b/w using the 6x8 Font. */
void n6610_draw_char(uint8_t x, uint8_t y, char c)
{ 
	uint8_t i, j, v;
	rom unsigned char* char_base;

	c -= 31;

	x = (x & 0xFE) | 0x01;

  	/* Page address set */
	n6610_write_command(CASET); 
	n6610_write_data(reverse_bits(x + 1)); 
	n6610_write_data(reverse_bits(x + 6)); 

	/* Column address set */
	n6610_write_command(PASET); 
 	n6610_write_data(reverse_bits(y)); 
	n6610_write_data(reverse_bits(y + 7)); 
 
 	/* Fill memory */
 	n6610_write_command(RAMWR); 

	char_base = (rom unsigned char*) _FONT6X8 + ((uint16_t) c) * 8;
	for (i = 0; i < 8; i ++)
	{
		v = char_base[i];

		for (j = 0; j < 6 / 2; j ++)
		{				
			switch (v & 0xC0)
			{
			case 0x00:
				n6610_write_data(0x00);
				n6610_write_data(0x00);
				n6610_write_data(0x00);
				break;
			case 0x40:
				n6610_write_data(0x00);
				n6610_write_data(0xF0);
				n6610_write_data(0xFF);
				break;
			case 0x80: 
				n6610_write_data(0xFF);
				n6610_write_data(0x0F);
				n6610_write_data(0x00);
				break;
			case 0xC0:
				n6610_write_data(0xFF);
				n6610_write_data(0xFF);
				n6610_write_data(0xFF);
				break;
			}

			v = v << 2;
		}
	}
} 

/* Draws given string in b/w using the 6x8 font */
void n6610_draw_rom_str(uint8_t x, uint8_t y, const far rom char* c)
{
	while (*c)
	{
		n6610_draw_char(x, y, *c);
		c ++;
		x += 6;
	}
}

#pragma romdata
rom char hex_lookup[16] = 
{ 
	'0', '1', '2', '3', 
	'4', '5', '6', '7', 
	'8', '9', 'A', 'B', 
	'C', 'D', 'E', 'F' 
};

#pragma code
void n6610_debug_message_short(uint8_t y, const far rom char* msg, uint16_t val)
{
	uint8_t start;
	int8_t j;
	
	// Draw string.
	n6610_draw_rom_str(0, y, msg);

	/* Print out value in hex */
	for (j = 0; j < 4; j ++)
	{
		n6610_draw_char(120 - j * 6, y, hex_lookup[val & 0xF]);
		val = val >> 4;
	}
}
#endif
#endif

#ifdef PCF8833
/* Initialize LCD controller */
void n6610_init(void)
{
	/* Initialize EUSART module for 9-bit synchronous transmission */
	init_EUSART();

	/* Setup RST and CS pins */
	TRISCbits.TRISC0 = 0;
	TRISCbits.TRISC1 = 0;

	/* Reset */
	PORTCbits.RC1 = 0;
	Delay1KTCYx(1000);
	PORTCbits.RC1 = 1;
	Delay1KTCYx(1000);

	/* Chip Select */
	PORTCbits.RC0 = 0;
	
 	/* Sleep out  (command 0x11) */
 	n6610_write_command(SLEEPOUT); 

	/* Color Interface Pixel Format  (command 0x3A) */
 	n6610_write_command(COLMOD); 
 	n6610_write_data(0xC0);   /* 0x03 = 12 bits-per-pixel */

	/* Memory access controller  (command 0x36).   */
 	n6610_write_command(MADCTL); 
	n6610_write_data(0x06);   /* 0xE0 = mirror y, vertical, reverse rgb */

	/* Write contrast  (command 0x25) */
 	n6610_write_command(SETCON); 
	n6610_write_data(0x22);   /* contrast 0x40  */
	Delay1KTCYx(2); 

 	/* Display On  (command 0x29) */
  	n6610_write_command(DISPON);
}
#endif

#ifdef S1D15G10
/* Initialize LCD controller */
void n6610_init(void)
{
	/* Initialize EUSART module for 9-bit synchronous transmission */
	init_EUSART();

	/* Setup RST and CS pins */
	TRISCbits.TRISC0 = 0;
	TRISCbits.TRISC1 = 0;

	/* Reset */
	PORTCbits.RC1 = 0;
	Delay1KTCYx(1000);
	PORTCbits.RC1 = 1;
	Delay1KTCYx(1000);

	/* Chip Select */
	PORTCbits.RC0 = 0;

	/* Display control */
 	n6610_write_command(DISCTL); 
 	n6610_write_data(0x00); // P1: 0x00 = 2 divisions, switching period=8 (default) 
	n6610_write_data(0x04); // P2: 0x20 = nlines/4 - 1 = 132/4 - 1 = 32) 
 	n6610_write_data(0x00); // P3: 0x00 = no inversely highlighted lines 
	
 	/* COM scan */
 	n6610_write_command(COMSCN); 
	n6610_write_data(0x80);  // P1: 0x01 = Scan 1->80, 160<-81 

	/* Internal oscilator ON */
 	n6610_write_command(OSCON); 
 
 	/* Sleep out */
 	n6610_write_command(SLPOUT); 

	/* Power control */
 	n6610_write_command(PWRCTR); 
	n6610_write_data(0xF0);   // reference voltage regulator on, circuit voltage follower on, BOOST ON 
 
 	/* Inverse display */
 	n6610_write_command(DISINV);

	/* Data control */
 	n6610_write_command(DATCTL); 
	n6610_write_data(0x60); // P1: 0x05 = page address normal, col address inverted, address scan in page direction 
	n6610_write_data(0x00); // P2: 0x00 = RGB sequence (default value) 
	n6610_write_data(0x40); // P3: 0x02 = Grayscale -> 16 (selects 12-bit color, type A) 

	/* Voltage control (contrast setting) */
 	n6610_write_command(VOLCTR); 
	n6610_write_data(0x24); // P1 = 32  volume value  (adjust this setting for your display  0 .. 63) 
	n6610_write_data(0xC0); // P2 = 3    resistance ratio  (determined by experiment) 
 
	/* allow power supply to stabilize */
 	Delay1KTCYx(100); 
 
 	/* turn on the display */
 	n6610_write_command(DISON); 
}
#endif

#define CARD_TYPE_SD 0
#define CARD_TYPE_SDHC 1

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

/* Initalize SD/MMC Card */
uint8_t card_init(void) 
{ 
	uint8_t i;
	
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
		while (1)
		{
			uint8_t result;

			card_command(0x77, 0x0000, 0x0000, 0xFF);
			result = card_command(0x69, 0x4000, 0x0000, 0xFF);
			if (result == 0x00)
				break;								
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
		while (card_command(0x41, 0x0000, 0x0000, 0xFF) != 0x00);
	}

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
	uint8_t card_response; 
	
	uint32_t address = (card_type == CARD_TYPE_SDHC) ? (sector) : (sector << 9);		
		
	/* Lower Chip Select */
	PORTCbits.RC2 = 0;

	/* Send CMD17 */
	result = card_command(0x51, (uint16_t) (address >> 16), (uint16_t) address, 0xFF);	
				
	while (result != 0)
		result = SPI(0xFF);
			
	/* Wait until 0xFE is received */
	while ((card_response = SPI(0xFF)) == (uint8_t) 0xFF);
		
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

#define LE16(card_sector, X)	(((uint16_t) card_sector[(X)]) + 			\
							    (((uint16_t) card_sector[(X) + 1]) << 8)) 	
				 
#define LE32(card_sector, X)	(((uint32_t) card_sector[(X)]) + 			\
								(((uint32_t) card_sector[(X) + 1]) << 8) +  	\
								(((uint32_t) card_sector[(X) + 2]) << 16) + 	\
								(((uint32_t) card_sector[(X) + 3]) << 24))		
				 
#define LBA(X) (cluster_begin_lba + ((X) - 2) * sectors_per_cluster)

/* Initializes FAT32 support */
uint8_t fat32_init(void)
{
	uint16_t bytes_per_sector;	

	/* Read sector 0 into the sector buffer */
	if (!card_read(0, sector_buffer))
		return 0;

	/* Depending on whether SD Card controller firmware reports 
	 * itself as removable media or not, it may or may not have an
	 * MBR. If there is no MBR, sector 0 will be the boot sector, as
	 * in a floppy. If the first byte of sector 0 is 0xEB, we assume
	 * it's the boot sector (LBR).
	 */
	 		
	if (sector_buffer[0] != 0xEB)
	{
		/* Find out the starting sector of the first primary partition */ 
		fpp_begin_lba = LE32(sector_buffer, 454);		

		/* Read FAT32 Volume ID into the sector buffer */
		if (!card_read(fpp_begin_lba, sector_buffer))
			return 0;
	}
	else
		fpp_begin_lba = 0; 				
	
	/* Compute important FAT locations */
	reserved_sector_count = LE16(sector_buffer, 14);
	fat_count = sector_buffer[16];
	sectors_per_fat = LE32(sector_buffer, 36);
	
	fat_begin_lba = fpp_begin_lba + reserved_sector_count;
	cluster_begin_lba = fpp_begin_lba + reserved_sector_count + (fat_count * sectors_per_fat);
	
	sectors_per_cluster = sector_buffer[13];	
	root_dir_first_cluster = LE32(sector_buffer, 44);

	return 1;
}

/* Looks for Cumulus.BIN in the SD Card */
void update_firmware(void)
{
	uint8_t i;
	uint8_t s;
	uint8_t* dir_entry;
	uint32_t cluster;
	uint32_t size;
	uint16_t address;
	int32_t bytes_left;
	uint32_t sector;

	if (!card_init())
		goto error;			
	if (!fat32_init())
		goto error;			

	/* Read directory first sector into the sector buffer */
	if (!card_read(LBA(root_dir_first_cluster), sector_buffer))
		goto error;			

	size = 0;
	dir_entry = sector_buffer;
	
	while (dir_entry[0])
	{
		for (i = 0; i < 11; i ++)
			if (dir_entry[i] != str_cumulus_bin[i])
				break;
		
		if (i == 11)
		{
			/* Get the cluster number */
			cluster = ((uint32_t) dir_entry[26]) + 
					  ((uint32_t) dir_entry[27] << 8) + 
					  ((uint32_t) dir_entry[20] << 16) + 
					  ((uint32_t) dir_entry[21] << 24);	
							
			/* Get the size */
			size = LE32(dir_entry, 28);

			break;
		}

		dir_entry += 0x20;
	}
												
	if (size && size < 65536)
	{
#ifdef TEXT_SUPPORT
		n6610_draw_rom_str(2, 48, (const far rom char*) "Updating firmware");
#endif

		s = 0;
		address = 0;
		bytes_left = size;
		sector = LBA(cluster);
		
		while (bytes_left > 0)
		{		
			if (!card_read(sector, sector_buffer))
				return;
		
			for (i = 0; i < 8; i ++)
			{
				if (bytes_left <= 0)		
					break;
		
				if (address >= 0x1000)
				{
					//n6610_debug_message_short(18 + i * 8, (const far rom char*) "Writing Block", address);
					if (!erase_program_verify_page(address, sector_buffer + ((uint16_t) i) * 64))
						goto error;
				}

				address += 64;
				bytes_left -= 64;
		
				//Delay10KTCYx(20);
			}

			n6610_fill_area(s, 56, 2, 16, 0xF0, 0x00, 0x0F);
		
			s += 1;
			sector ++;
		}
	}	
	else
		goto error;

	n6610_fill_area(0, 0, 132, 132, 0xF0, 0x00, 0x0F);
	return;

error:

	/* Turn screen to red */
	n6610_fill_area(0, 0, 132, 132, 0x0F, 0xF0, 0x00);

#ifdef TEXT_SUPPORT
		n6610_draw_rom_str(2, 48, (const far rom char*) "Update failed!");			
#endif
}
	
void main(void) 
{
	OSCCON = 0x60;          // IRCFx = 110 (8 MHz)
    OSCTUNEbits.PLLEN = 1;  // x4 PLL enabled = 32MHz

	/* No Analog Pins */		
	ANSELH = 0x00;
	ANSEL = 0x00;
	
	/* Update firmware? */
	if (PORTEbits.RE2 == 0 && PORTEbits.RE1 == 0)
	{
		n6610_init();
		n6610_fill_area(0, 0, 132, 132, 0x00, 0x0F, 0xF0);

		update_firmware();		

		/* Halt */
		while (1);
	}

	_asm goto RM_RESET_VECTOR _endasm
} 