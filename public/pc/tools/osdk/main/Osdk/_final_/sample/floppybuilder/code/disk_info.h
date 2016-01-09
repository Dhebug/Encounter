;
; http://oric.free.fr/programming.html#disc
;
#define location_loader 		$fd00		; Need to match the information set in loader.asm
#define loader_track_position 	0			; Location of the loader on the disk (track number)
#define loader_sector_position 	4			; Location of the loader on the disk (sector number)
#define loader_zp_start         $80         ; Location of the first zero page address used during the loading
#define loader_sector_buffer    $200        ; Location of the 256 bytes buffer used to load the sectors

#define wait_status_floppy 30

; Jasmin registers are equivalent to microdisc + $e4 / 228
#define FDC_OFFSET_MICRODISC $00
#define FDC_OFFSET_JASMIN    $E4 

#ifdef MICRODISC_LOADER

#define FDC_command_register	$0310
#define FDC_status_register		$0310
#define FDC_track_register		$0311
#define FDC_sector_register		$0312
#define FDC_data				$0313
#define FDC_flags				$0314
#define FDC_drq                 $0318	

#define FDC_Flag_DiscSide       %00010000

#define CMD_ReadSector			$80
#define CMD_Seek				$1F

#else
#ifdef JASMIN_LOADER
#define FDC_command_register	$03f4
#define FDC_status_register		$03f4
#define FDC_track_register		$03f5
#define FDC_sector_register		$03f6
#define FDC_data				$03f7
#define FDC_flags				$03f8
#define FDC_drq                 $03FC	

#define FDC_Flag_DiscSide       %00000001

#define CMD_ReadSector			$8c
#define CMD_Seek				$1F

#endif
#endif


;                                         ____________ bit 7: INTRQ state (only if bit 0 above has been set to 1) in negative logic so it's 0 if FDC requests an Interrupt.
;                                        |
; 										|x.......| Read
;#define FDC_flags				$0314	
; 										|xxxxxxxx| Write
;                                        ||||||||
;                                        ||||||||_____bit 0: enable FDC INTRQ to appear on read location $0314 and to drive cpu IRQ
;                                        |||||||_____ bit 1: ROMDIS (active low). When 0, internal Basic rom is disabled. 
;                                        ||||||______ bit 2: along with bit 3, selects the data separator clock divisor            (1: double density, 0: single-density) 
;                                        |||||_______ bit 3: double density enable (0: double density, 1: single density) 
;                                        ||||________ bit 4: side select 
;                                        |||_________ bits 56: drive select (0 to 3) 
;                                        |___________ bit 7: Eprom select (active low) 
;
;                                        %10000101 -> Eprom deselected, double density, ROM disabled, irq enabled
;                                        %10000001 -> 
;
;                               $0318
;                                bit 7: DRQ state (active low)


