;
; http://oric.free.fr/programming.html#disc
;
#define location_loader $fc00
#define wait_status_floppy 30

#define FDC_command_register	$0310
#define FDC_status_register		$0310
#define FDC_track_register		$0311
#define FDC_sector_register		$0312
#define FDC_data				$0313


;                                         ____________ bit 7: INTRQ state (only if bit 0 above has been set to 1) in negative logic so it's 0 if FDC requests an Interrupt.
;                                        |
; 										|x.......| Read
#define MICRODISC				$0314	
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

;                               $0318
;                                bit 7: DRQ state (active low)

#define CMD_Seek				$1F
#define CMD_ReadSector			$80

