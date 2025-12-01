;
; This is the third sector of the bootable sequence
; 
; forum.defence-force.org/viewtopic.php?p=33309#p33309
;
; Offset on a DSK file: +1128 / 0x468
/*
by Ray030471 » 02 Oct 2025, 21:01

When I edit this, the message is nicely formatted but Preview and Post seems to strip many of the spaces. 
Therefore I have attached a PDF file of list below to make it easier to understand the information.

The "SEDORIC A NU" document might help with much of the details but here is a bit of help on the structure of sectors 2 & 3 of track $14 
(all values in hexadecimal below where each XX represents a value between 00 & FF inclusively).

The DIR (list of files with location information) is in sectors 04, 07, 0A, 0D, 10 of track 14 and then any free sector which is allocated dynamically to the DIR as required by SEDORIC. However, it looks like you don't need to consider this aspect. You probably don't need to concern yourself with sector 3 on track 14 either.
*/


StartSector
	.byt $FF        ; 00 - FF to indicate a SEDORIC-formatted disk
	.byt $00        ; 01 - 00 unused but usually 00
	.word 0         ; 02 - XXXX number of free sectors on disk
	.word 0         ; 04 - XXXX number of files on disk
	.byt 42         ; 06 - XX number of tracks per side, eg 50
	.byt 18         ; 07 - XX number of sectors per track, eg 11
	.byt 1          ; 08 - XX number of sectors making up DIR, at least 01
	.byt %10000000  ; 09 - XX bit 7 is 0 for single-sided disk, 1 for double-sided disk, eg D0 which usually (but not necessarily) derives from the number of tracks per side
	.byt $FF        ; 0A - XX disk format type, eg 00 for Master, FF for slave - others are user-defined
	.byt $00        ; 0B - 00 unused but usually 00
	.byt $00        ; 0C - 00 unused but usually 00
	.byt $00        ; 0D - 00 unused but usually 00
	.byt $00        ; 0E - 00 unused but usually 00
	.byt $00        ; 0F - 00 unused but usually 00
					; 10 - FF XX disk bitmap (FAT), each byte here represents a unique set of 8 individual sectors - 
					; 00 means that all 8 sectors are allocated whereas,at the other extreme, 
					; FF means that all 8 sectors are free
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
#if ((EndSector-StartSector)<>256)
#echo Sector bitmap should be 256 bytes long, but it is:
#print (EndSector-StartSector) 
 nop Please fix sector bitmap size
#else
#echo Sector bitmap successfully exported
#endif
