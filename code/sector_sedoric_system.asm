;
; System sector for a SEDORIC-compatible floppy.
; Written at track 20 / sector 1 (i.e. sector $14 / $01).
;
; Not required for booting the disk via the FloppyBuilder Microdisc/Jasmin loader, but it IS read by SEDORIC whenever this disk is mounted as a
; secondary drive and the user types DIR, DNAME, INIST, DSYS, DTRACK, DNUM, or DKEY. 
; Populating it keeps the DIR header line from showing 21 bytes of random game data as the disk name.
;
; References:
;   - "SEDORIC 3.0 a nu", Andre Cheramy (1998), pp. 491-492 "Dump du secteur n.1 de la piste n.#14 (SECTEUR SYSTEME)"
;   - d:\Oric\sedoric\01_sedoric_disk_format.md  (Track 20 / sector 1 -- System sector)
;
; Field layout (see the doc above for detail):
;   +$00..$03   TABDRV           drive table (per-drive track/side config)
;   +$04        keyboard type    b7=AZERTY, b6=ACCENT SET
;   +$05..$06   RENUM start line (word, default 100)
;   +$07..$08   RENUM step       (word, default 10)
;   +$09..$1D   DNAME            21-char disk name, space-padded
;   +$1E..$59   INIST            60-char BASIC commands auto-run at boot
;   +$5A..$FF   unused, zero
;
; Offset on a DSK file: depends on geometry; at track 20 / sector 1.
;
StartSector
	.byt $AA,$AA,$AA,$AA  ; +$00..$03 -- TABDRV: 4 bytes, one per drive A/B/C/D.
	                      ;              Low 7 bits = tracks per side, bit 7 = double-sided flag.
	                      ;              $AA = 42 tracks, double-sided -- matches this disk's geometry.
	.byt $00              ; +$04 -- Keyboard type. b7=1 AZERTY, b6=1 accents enabled. $00 = QWERTY + accents off (safe cross-locale default).
	.word 100             ; +$05..$06 -- RENUM starting line number (LL, HH). Default 100.
	.word 10              ; +$07..$08 -- RENUM step (LL, HH). Default 10.
	
DNameStart                ; +$09..$1D -- DNAME (21 bytes, space-padded). Shown by DIR on the header line as "Drive X V3 (...) <this text>"
	.byt "ENCOUNTER"                
#ifdef LANGUAGE_FR     
	.byt "-FR"         
#elif defined(LANGUAGE_NO)
	.byt "-NO"
#else // LANGUAGE_EN
	.byt "-EN"
#endif
	.byt " v"          ; Auto-expands with the build VERSION and LANGUAGE macros.
	.byt str(VERSION)
DNameEnd
	.dsb 21-(DNameEnd-DNameStart), $20     ; pad to 21 bytes
	
	.dsb 60, $20       ; +$1E..$59 -- INIST (60 bytes). BASIC command string auto-run if SEDORIC ever boots from this disk. Space-fill = no-op. Do NOT use zeros here: a $00 would be interpreted as BRK at boot.	
	.dsb 166, $00      ; +$5A..$FF -- unused, zero-filled (166 bytes).
EndSector


; Basic sanity checking, in case I break the macros, or forget some bytes...
.asserteq EndSector-StartSector,256, "System sector should be 256 bytes"
#echo System sector successfully exported
