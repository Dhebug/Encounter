;; Routines for loading a room from a map.

#include "picdef.h"
#include "white_defs.h"

; Address of World Map data
#define WORLDMAP_BASE $c000



__mapload_start


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; mapload
; Loads room ID at current_room from worldmap.
; User can modify this function so it fits
; his own map format.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mapload
.(

    ;jsr _switch_ovl
    lda #0
    sta needs_blink

	jsr search_room

	ldy #2		; Point to room type byte
		
	lda (tmp4),y
	and #%00000111	; Get ink colour
	sta _ink_colour

	lda (tmp4),y
    lsr
    lsr
    lsr
	and #%00000111	; Get ink2 colour
	sta _ink_colour2

	iny		; Point to north wall base tile
	lda (tmp4),y
	jsr set_north_wall

	iny		; Point to south wall base tile
	lda (tmp4),y
	jsr set_south_wall

    iny		; Point to west wall base tile
	lda (tmp4),y
	jsr set_west_wall

    iny		; Point to east wall base tile
	lda (tmp4),y
	jsr set_east_wall

	iny
	lda (tmp4),y

    beq no_wall_objs
        
    ldx #1
    stx tmp5+1
	jsr set_bkg_objs

no_wall_objs
	iny
	lda (tmp4),y

	beq no_bkg_objs

    ldx #0
    stx tmp5+1
	jsr set_bkg_objs

no_bkg_objs

    ; Load free objects bound to the room

	;iny
	;lda (tmp4),y
	;beq no_free_objs
no_free_objs


    ;jsr _switch_ovl


    rts ; We're done

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Search for a room in the map data
; until finds ID which is equal to current_room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

search_room
.(
	;; Start searching for the room
    lda #<WORLDMAP_BASE
	sta tmp4
    lda #>WORLDMAP_BASE
	sta tmp4+1

loop_rooms
	ldy #0
	lda (tmp4),y	; Get room ID from map
	cmp _current_room
	beq	found

	iny
	lda (tmp4),y	; Get bytes up to next entry
	clc
	adc tmp4
	sta tmp4
	bcc no_inc
	inc tmp4+1
no_inc
	jmp loop_rooms

found	
	rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the north wall, depending on the code passed on A reg.
; The panel of one block is in tmp5. Preserves reg Y.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_north_wall
.(
    tax
	tya
	pha ; Save Y reg

    txa
    ldy #6
    sta (sp),y  ; fourth param (ID) = reg A

	lda #0	
    ldy #0
    sta (sp),y  ; first param (i) = 0
	ldy #2	
    lda #0
	sta (sp),y ; second param (j) = 0 
	ldy #4		
	sta (sp),y ; third param (k) = 0

    lda #10
    sta tmp2    ; tmp2 is the loop index
loop
    jsr _set_tile
    
    ldy #0
    jsr incparam ; increment first param (i)

    dec tmp2
    bne loop

    pla
    tay
    rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the south wall, depending on the code passed on A reg.
; The panel of one block is in tmp5. Preserves reg Y.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_south_wall
.(
    tax
	tya
	pha ; Save Y reg

    txa
    ldy #6
    sta (sp),y  ; fourth param (ID) = reg A

	lda #1	
    ldy #0
    sta (sp),y  ; first param (i) = 1
    lda #9
	ldy #2	
	sta (sp),y ; second param (j) = 9 
    lda #0
	ldy #4		
	sta (sp),y ; third param (k) = 0

    lda #8
    sta tmp2    ; tmp2 is the loop index
loop
    jsr _set_tile
    
    ldy #0
    jsr incparam ; increment first param (i)

    dec tmp2
    bne loop

    pla
    tay
    rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the west wall, depending on the code passed on A reg.
; The panel of one block is in tmp5. Preserves reg Y.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_west_wall
.(
    tax
	tya
	pha ; Save Y reg

    txa
    ldy #6
    sta (sp),y  ; fourth param (ID) = reg A

	lda #0	
    ldy #0
    sta (sp),y  ; first param (i) = 0
	ldy #2	
    lda #1
	sta (sp),y ; second param (j) = 1 
	ldy #4
    lda #0		
	sta (sp),y ; third param (k) = 0

    lda #9
    sta tmp2    ; tmp2 is the loop index
loop
    jsr _set_tile
    
    ldy #2
    jsr incparam ; increment second param (j)

    dec tmp2
    bne loop

    pla
    tay
    rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set the east wall, depending on the code passed on A reg.
; The panel of one block is in tmp5. Preserves reg Y.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_east_wall
.(
    tax
	tya
	pha ; Save Y reg

    txa
    ldy #6
    sta (sp),y  ; fourth param (ID) = reg A

	lda #9	
    ldy #0
    sta (sp),y  ; first param (i) = 9
	ldy #2	
    lda #1
	sta (sp),y ; second param (j) = 1 
    lda #0
	ldy #4		
	sta (sp),y ; third param (k) = 0

    lda #8
    sta tmp2    ; tmp2 is the loop index
loop
    jsr _set_tile
    
    ldy #2
    jsr incparam ; increment second param (j)

    dec tmp2
    bne loop

    pla
    tay
    rts

.)



incparam
.(
	lda (sp),y	
	clc
	adc #1
	sta (sp),y	; i=i+1;
	rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; set_bkg_objs, sets objects
; in the background. Keeps Y pointing to next
; byte to be read.
; uses tmp5+1:
; if zero, considers them objects in the inner 8x8 lattice
; else objects in walls
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
set_bkg_objs
.(
	sta tmp2
	sty tmp5

loop1
	; Get an object ID
	inc tmp5
	ldy tmp5

	lda (tmp4),y
	ldy #6
	sta (sp),y

	; Get repetitions
	inc tmp5
	ldy tmp5
	lda (tmp4),y	
	sta tmp2+1
	
loop2
	inc tmp5
	ldy tmp5
	
    lda tmp5+1
    bne walls
	jsr get_coordsbkg
    jmp donecoord
walls
    jsr get_coordswall

donecoord

    ldy #0
    lda tmp3
    sta (sp),y
    ldy #2
    lda tmp3+1
    sta (sp),y
    ldy #4
    lda tmp+1
    sta (sp),y

    jsr _set_tile

    ; Report some SPECIAL objects to make them blink!
    ldy #6
    lda (sp),y
    cmp #128
    bmi nothing
    jsr report_blink 
nothing
    

	dec tmp2+1
	bne loop2
	
	dec tmp2
	bne loop1

	ldy tmp5


	rts
.)

get_coordsbkg
.(

    lda (tmp4),y ; Get coordinates
	sta tmp
	
    and #%00000011 ; k
	sta tmp+1
	lda tmp
	and #%00011100 ;j
	lsr
	lsr
	clc
	adc #1
    sta tmp3+1
	lda tmp
	and #%11100000 ; i
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc #1
	sta tmp3

    rts
.)


get_coordswall
.(
    lda (tmp4),y
    sta tmp

    and #%00000011 ; k
	sta tmp+1
	lda tmp
	and #%00111100 ;j
	lsr
	lsr
    sta tmp6
    
	lda tmp
	and #%11000000
	lsr
	lsr
	lsr
	lsr
	lsr
    lsr

    cmp #NORTH
    bne no_north
    lda #0
    sta tmp3+1
    lda tmp6
    sta tmp3
    jmp end    
no_north

    cmp #SOUTH
    bne no_south
    lda #9
    sta tmp3+1
    lda tmp6
    sta tmp3
    jmp end    
no_south

    cmp #EAST
    bne no_east
    lda #9
    sta tmp3
    lda tmp6
    sta tmp3+1
    jmp end    
no_east

    ; Should be WEST
    lda #0
    sta tmp3
    lda tmp6
    sta tmp3+1
end
    rts

.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; place_objects
; Places objects in the world
; that might be in any room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
place_objects
.(
    lda _num_objects
    beq end

	lda #0
	sta tmp2
	tax
loop
	lda _objects,x	; room
	cmp _current_room
	bne next_obj1

	; It is in this room!
	ldy #6
	inx
	lda _objects,x	; ID
	ora #SPECIAL    ; Flag as special
	sta (sp),y

	lda #3
	sta tmp2+1
	ldy #0

loop2	
	inx
	lda _objects,x ;  coordinates
	sta (sp),y
	iny
	iny

	dec tmp2+1
	bne loop2	

	jsr _set_tile

	jmp next_obj2

next_obj1
	txa
	clc
	adc #5
	tax
next_obj2

	inc tmp2
	lda tmp2
	cmp _num_objects
	bne loop
end
	rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; place_chars
; places the characters in the word
; which are in current room
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
count .byte $00

place_chars
.(

	ldx _num_characters
	beq end
	dex
	stx count

loop
	lda count
	asl
	asl
	tax
	
	lda _moving_chars,x	; Room
	cmp _current_room
	bne next
	
	; Add this character
	
	lda count	
	ldx _num_chars
	sta _chars_in_room,x
	inx
	stx _num_chars
	ldy #0
	sta (sp),y
	jsr _wh_updatechar
	
	
next
	dec count
	bpl loop

end
	rts

.)

needs_blink .byt 0
blink .byt 0,0,0 ; i,j,k positions of object to blink

report_blink
.(
    ; Some exceptions...

    and #%00111111
    beq end
    cmp #INFO
    beq end
    cmp #COR_DOOR
    beq end
    cmp #SURGERY_DOOR
    beq end
    cmp #LIFT
    beq end
    cmp #BENES
    beq end


    ldx #2
    ldy #4
loop
    lda (sp),y
    sta blink,x
    dey
    dey
    dex
    bpl loop
    
    lda #1
    sta needs_blink
end    
    rts
.)

__mapload_end

#echo Size of MAPLOAD in bytes:
#print (__mapload_end - __mapload_start)
#echo





