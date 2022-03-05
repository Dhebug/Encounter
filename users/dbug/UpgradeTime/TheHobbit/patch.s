;
; Improved Hobbit v1.5
; NOTE: Ideally I'd like to do more fixes, so please avoid distributing it all over the place.
; NOTE2: If this is not finished after one year, feel free to ignore the note above, it just means that "life happened" and this version is better than a non existing better one.
;
; Version historic:
; - 1.0 - 2015-04-13 [Silicebit] First DSK version of the Hobbit (see: https://forum.defence-force.org/viewtopic.php?f=20&t=1225)
;       Note that attempting to use the SAVE or LOAD commands will still try to use the original tape code.
; - 1.1 - 2015-04-14 [Silicebit] Same version, buyt with a INIST so the game autostarts
; - 1.2 - 2022-02-23 [Dbug] Added this code that patches the game to speed-up the drawing routines using some multiplication, divide and modulo tables
; - 1.3 - 2022-02-24 [Dbug] Replaced the system font by a fancy one ("oncial") to make the game feel a bit more atmospheric
; - 1.4 - 2022-02-25 [Dbug] Added an intro picture based on the original game manual artwork
; - 1.5 - 2022-02-26 [Dbug] The intro picture now appears with an unroll effect, and a music play in the background
;
; TODO list:
; - Modify the SAVE and LOAD code to use the floppy disk instead of tape
; - Add proper credits to the game
; - Add a way to show a manual directly on the game
;
; Information regarding the game:
; - HOBBIT.COM is 36176 bytes and loads/runs from $4fe
; - There is code at $91B2 which recreates the $400-$4FF area which interfered with the Sedoric code in page 4
; - $7422 contains the location of the routine that computes the screen address of a specific pixel
; - The $405-$414 area contains a JMP table on various ROM routines patched to different addresses depending if an Oric 1 or Atmos is detected  (See: https://forum.defence-force.org/viewtopic.php?p=26656#p26656)
; - The saving code is called multiple time for various areas, totally about 3623 bytes (see: https://forum.defence-force.org/viewtopic.php?p=26664#p26664)
;

	.zero

	*= $50

tmp0	.dsb 2

    .text

    *= $924E

StartPatch
;pause  jmp pause        ; Uncomment to stop auto-running
	sei              ; We need to disable the IRQ at least during the ROM to RAM copy

copy_rom_to_ram
    .(
    ; After some extensive digging in The Hobbit code, and some email discussion with Veronika Megler,
    ; the conclusion was reached that the game used pretty much all the conventional memory, so the only
    ; solution that seemed doable was to use the overlay memory.
    ;
    ; Since the game also use some of the ROM content (mostly the font, keyboard handling, load and save),
    ; we have to make sure that we preserve parts that the game require.
    ;
    ; The current solution is to copy the entire $C000 to $FFFF area from ROM to RAM, then to selectively 
    ; patch some areas to store whatever we need.
    lda #<$c000
    sta tmp0+0
    lda #>$c000
    sta tmp0+1

loop_external
    ldy #0
loop_page  
	ldx #%11111111   ; Map $C000-$FFFF to access the BASIC ROM
	stx $314
    lda (tmp0),y     ; Load from ROM
    
	ldx #%11111101   ; Map $C000-$FFFF to access the OVERLAY RAM (ISS suggested that all writes modify overlay, selected or not)
	stx $314
    sta (tmp0),y     ; Save to RAM

    iny 
    bne loop_page

    inc tmp0+1
    bne loop_external
    .)
    

generate_tables
    .(
    ; Generate the scanline table
    lda #<$a000+2  ; $00
    sta tmp0+0
    lda #>$a000+2  ; $A0
    sta tmp0+1

    ldx #127
loop_screen_address
    clc                          ; generate two bytes screen adress
    lda tmp0+0
    sta _HiresAddrLow,x
    adc #40
    sta tmp0+0
    lda tmp0+1
    sta _HiresAddrHigh,x
    adc #0
    sta tmp0+1

    dex
    bpl loop_screen_address

    ; Generate the mod6/div6 table
    lda #0      ; cur div
    tay         ; cur mod
    tax
loop_div_mod
    sta _Div6,x   ; $C855
    pha
    tya
    sta _Mod6,x   ; $C955
    pla
    iny
    cpy #6
    bne skip_mod
    ldy #0
    adc #0      ; carry = 1!
skip_mod

    inx
    bne loop_div_mod
    .)


patch_hobbit
    .(
    ; Replace the game routine that compute the screen memory address of a specific pixel by oa more efficient one.
    ; Note that this new routine requires the _Div6, _Mod6, _HiresAddrLow and _HiresAddrHigh to be patched in the overlay copy of the BASIC ROM
    ldx #SizeComputeScreenAddress
loop_patch        
    lda ComputeScreenAddress-1,x
    sta $7A22-1,x
    dex
    bne loop_patch
    .)
    
copy_ram_font_to_rom
    .(
    ; ROM Font is stored from $FC78 to $FF77 = 768 bytes = 3*256
    ; We recopy whatever is in the original RAM version of from (from $B400 to $B7FF) to the ROM area.
    ; The first 32 characters are skipped because they are not actually displayable.
    ldx #0
loop_patch        
    lda $B400+8*32+256*0,x
    sta $fc78+256*0-8,x
    lda $B400+8*32+256*1,x
    sta $fc78+256*1-8,x
    lda $B400+8*32+256*2,x
    sta $fc78+256*2-8,x
    dex
    bne loop_patch
    .)


start_game
    cli                  ; Enable the IRQ again
    jmp $91B2            ; What the original did in 04FE

ComputeScreenAddress
 .(
    * = $7A22           ; This routine is assembled at a different address than the rest of the program
 begin
    ; Mul 40
    ldx $31
    lda _HiresAddrLow,x
    sta $38
    lda _HiresAddrHigh,x
    sta $39

    ; Div 6
    ldx $30
    lda _Div6-14,x
    tay
    lda _Mod6-14,x    

    tax
    lda ($38),y
    rts
+SizeComputeScreenAddress=*-begin
	*=ComputeScreenAddress+SizeComputeScreenAddress      ; Restore the normal program counter 
.)


; And some final information string, so we can easily find which version people are swapping around
    .byt "Improved Hobbit v1.5 - Please report any issue to dbug@defence-force.org"

; Just so log code to check how large this patch data has become
EndPatch
#echo Patch size:
#print (EndPatch - StartPatch) 

    .bss

    *= $C855    ; Erase the FOR command
_Div6 			.dsb 256     ;  Values divided by 6
_Mod6 			.dsb 256     ;  Values modulo 6

    *= $F37F    ; Erase the CIRCLE command
_HiresAddrLow	.dsb 128     ;  Values multiplied by 40 + a000
_HiresAddrHigh	.dsb 128     ;  Values multiplied by 40 + a000

