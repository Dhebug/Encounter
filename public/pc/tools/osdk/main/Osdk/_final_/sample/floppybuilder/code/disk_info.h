;
; http://oric.free.fr/programming.html#disc
;
#define location_loader 		$fd00		; Need to match the information set in loader.asm
#define loader_track_position 	0			; Location of the loader on the disk (track number)
#define loader_sector_position 	4			; Location of the loader on the disk (sector number)
#define loader_zp_start         $80         ; Location of the first zero page address used during the loading
#define loader_sector_buffer    $200        ; Location of the 256 bytes buffer used to load the sectors
#define loader_hires                        ; If commented out, will stay in TEXT mode
#define loader_debugging                    ; When enabled, will show diagnostic information useful for loader debugging
;#define loader_

#define wait_status_floppy            30

#define fdc_flags_mask                %10000100

#define fdc_base                      $310
#define fdc_command_register          fdc_base+0
#define fdc_status_register           fdc_base+0
#define fdc_track_register            fdc_base+1
#define fdc_sector_register           fdc_base+2
#define fdc_data                      fdc_base+3
#define fdc_flags                     fdc_base+4
#define fdc_drq                       fdc_base+8

#define location_fdc_offset           location_loader+3
#define location_cmd_writesector      location_loader+4
#define location_cmd_readsector       location_loader+5
#define location_cmd_seek             location_loader+6
#define location_cmd_forceinterrupt   location_loader+7
#define location_fdc_flag_discside    location_loader+8

