;
; SEDORIC directory sector 1 listing the game "modules" as PROT files.
; Written at track 20 / sector 4.
;
; All entries point at the SAME shared empty descriptor at track 20 / sector 3 
; (see sector_sedoric_descriptor.asm -- which occupies the bitmap-2 slot we don't need on this 1428-sector disk). 
; If the user LOADs any of these entries the descriptor's self-referencing pair copies 256 bytes of descriptor bytes to $0500 and returns cleanly.
;
; References:
;   - "SEDORIC 3.0 a nu", Andre Cheramy (1998), pp. 495-496 "Dump du secteur n.4 de la piste n.#14 (DIRECTORY)" + "Un Secteur de Catalogue est structure ainsi"
;   - d:\Oric\sedoric\01_sedoric_disk_format.md  (Directory sector + entry format)
;
; Each entry is 16 bytes:
;   +$00..$08   9-char filename, space-padded
;   +$09..$0B   3-char extension
;   +$0C        track of descriptor
;   +$0D        sector of descriptor
;   +$0E        total size in sectors (here = 1, just the descriptor)
;   +$0F        attribute: b6=valid, b7=PROT -> $C0 for protected
;

StartSector
	; -- DIR sector header --
	.byt $00, $00                           ; +$00-01  no next DIR sector
	.byt $10 + (EntriesEnd - EntriesStart)  ; +$02     first free entry offset (auto-computed from entries below; wraps to $00 = "full" at 15 entries)
	.dsb 13, $00                            ; +$03-0F  unused

	; -- File entries (16 bytes each: name(9) + ext(3) + track + sec + size + attr) --
	; All entries point at the shared empty descriptor at track $14 / sector $03.
EntriesStart
	.byt "SPLASH   ", "COM", $14, $03, $01, $C0
	.byt "INTRO    ", "COM", $14, $03, $01, $C0
	.byt "GAME     ", "COM", $14, $03, $01, $C0
	.byt "OUTRO    ", "COM", $14, $03, $01, $C0
	.byt "MINIGAME ", "COM", $14, $03, $01, $C0
EntriesEnd

	; -- Remaining slots zero-filled (auto-computed from entry count above) --
	.dsb 256 - (EntriesEnd - StartSector), $00
EndSector


; Basic sanity checking, in case I break the macros, or forget some bytes...
.asserteq EndSector-StartSector,256, "DIR modules sector should be 256 bytes"
#echo DIR modules sector successfully exported
