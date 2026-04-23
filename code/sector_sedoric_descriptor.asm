;
; Shared empty SEDORIC file descriptor.
; Written at track 20 / sector 3 (reusing the bitmap-2 slot, which is unused on disks with fewer than 1920 sectors -- our disk is 1428).
;
; Pointed to by every entry in sector_sedoric_directory.asm. 
; Declares 1 data sector pointing at itself, so LOAD reads 256 bytes of descriptor bytes into $0500..$05FF and returns cleanly with no error. 
; (Setting the sector-count to zero is NOT safe -- SEDORIC still evaluates the pair list and trips DISK I/O ERROR on a (0,0) pair.)
;
; References:
;   - "SEDORIC 3.0 a nu", Andre Cheramy (1998), pp. 496-498 "Exemples de descripteurs" + "Le premier secteur de descripteur ..."
;   - d:\Oric\sedoric\01_sedoric_disk_format.md  (Primary descriptor layout)
;
; Descriptor layout (primary):
;   $00..$01   coords of next descriptor (00 00 if only one -- this case)
;   $02        $FF  -- primary-descriptor marker (SEDORIC scans from $02)
;   $03        FTYPE  (status byte)
;   $04..$05   start address (LL, HH)
;   $06..$07   end address   (LL, HH)
;   $08..$09   execution address (0 if not AUTO)
;   $0A..$0B   number of data sectors to load
;   $0C..$FF   list of (track, sector) pairs -- up to 122 pairs
;
StartSector
	.byt $00, $00            ; +$00-01  no next descriptor
	.byt $FF                 ; +$02     primary-descriptor marker
	.byt $40                 ; +$03     FTYPE: data block, not BASIC, not AUTO
	.word $0500              ; +$04-05  start address = $0500
	.word $05FF              ; +$06-07  end address   = $05FF (one sector)
	.word $0000              ; +$08-09  exec address (not AUTO)
	.word $0001              ; +$0A-0B  1 data sector to load
	.byt $14, $03            ; +$0C-0D  pair: track $14 / sector $03 (this sector)
	.dsb 242, $00            ; +$0E-FF  no more pairs
EndSector

; Basic sanity checking, in case I break the macros, or forget some bytes...
.asserteq EndSector-StartSector,256, "Descriptor sector should be 256 bytes"
#echo Empty descriptor sector successfully exported
