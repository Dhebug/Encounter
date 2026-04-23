;
; Bitmap 1 (sector 2 of track 20) for a SEDORIC-compatible floppy.
; Holds the SEDORIC-identity signature, the disk geometry fields read by DIR / BACKUP / INIT, and the sector-allocation bitmap proper.
;
; References:
;   - "SEDORIC 3.0 a nu", Andre Cheramy (1998), pp. 492-494 "Dump des secteurs n.2 et n.3 de la piste n.#14 (BITMAP)"
;   - forum.defence-force.org/viewtopic.php?t=2750  (Ray McLaughlin, 2025)
;   - d:\Oric\sedoric\01_sedoric_disk_format.md  (Track 20 / sector 2 -- Bitmap 1)
;
; Offset on a DSK file: +1128 / 0x468
;
; EntriesStart / EntriesEnd are exported by sector_sedoric_directory.asm via xa -E (see _build_pass.bat) 
; and re-imported here as equates so the file-count field at $04..$05 tracks the actual DIR entry list with no manual sync.

#include "../build/files/sector_sedoric_directory.equ"

StartSector
	.byt $FF        ; +00 - FF to indicate a SEDORIC-formatted disk
	.byt $00        ; +01 - 00 unused but usually 00
	.word 0         ; +02 - XXXX number of free sectors on disk
	.word (EntriesEnd - EntriesStart) / 16  ; +04 - file count, auto-derived from sector_sedoric_directory.asm (EntriesStart / EntriesEnd labels imported via xa -S)
	.byt 42         ; +06 - XX number of tracks per side, eg 50
	.byt 18         ; +07 - XX number of sectors per track, eg 11
	.byt 1          ; +08 - XX number of sectors making up DIR, at least 01
	.byt %10000000  ; +09 - XX bit 7 is 0 for single-sided disk, 1 for double-sided disk, eg D0 which usually (but not necessarily) derives from the number of tracks per side
	.byt $47        ; +0A - XX disk format type: 00=Master, 01=Slave, 47='G'=Games (this disk), others user-defined
	.byt $00        ; +0B - 00 unused but usually 00
	.byt $00        ; +0C - 00 unused but usually 00
	.byt $00        ; +0D - 00 unused but usually 00
	.byt $00        ; +0E - 00 unused but usually 00
	.byt $00        ; +0F - 00 unused but usually 00
					; +10 - FF XX disk bitmap (FAT), each byte here represents a unique set of 8 individual sectors - 
					;       00 means that all 8 sectors are allocated whereas,at the other extreme, 
					;       FF means that all 8 sectors are free
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
	.byt $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00  ; ................
EndSector


; Basic sanity checking, in case I break the macros, or forget some bytes...
.asserteq EndSector-StartSector,256, "Bitmap sector should be 256 bytes"
#echo Bitmap sector successfully exported
