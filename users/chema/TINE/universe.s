;;;;; Functions to create objects and initialize universe.



OCEN     .word 0000            ;X-coord
         .word 0000            ;Y-coord
         .word 1300            ;Z-coord

OCEN2    .word -1000            ;X-coord
         .word 1000            ;Y-coord
         .word 1300            ;Z-coord


; Creates the environment, based on the data from cpl_system, so
; should be called after _jump on galaxy.s

CreateEnvironment
.(
    ; Make sure Obj3D is empty
    jsr _EmptyObj3D
    ; Create the radar object (number 0)
    jsr CreateRadar
    ; Add our ship, which is  object number 1 at initial position (fixed)
    ; This is different depending on whether we are launched from planet,
    ; or exit hyperspace. This depends on the _docked variable

    lda _docked
    beq hyper

    ; Create at planet's position
    jsr planetpos
    ; With Z a bit closer
    lda _PosZ+1
    sec
    sbc #7
    sta _PosZ+1
    jmp createship

hyper   
    lda #0
    sta _PosX
    sta _PosX+1
    sta _PosY
    sta _PosY+1
    lda #<(-16384+6000)
    sta _PosZ
    lda #>(-16384+6000)
    sta _PosZ+1

createship    
    lda #<_PosX
    sta tmp0
    lda #>_PosX   
    sta tmp0+1
    lda _ship_type
    jsr AddSpaceObject
	
	; Set our ship as view object
    stx VOB          

    lda _docked
    beq norot
    
    ; Rotate it 180 deg
    jsr SetCurOb
    lda #0
    tay           ; z and y angles 0 deg of rotation
    ldx #50;     ; rotate 180 deg
    jsr SetMat

norot
    ldy _ship_type
    lda ShipMaxSpeed-1,y
    lsr
    sta _speed+1
 
   	; And initialize all the stuff (equipment...)
	jsr InitPlayerShip

    jsr planetpos
    lda #<ONEPLANET
    ldy #>ONEPLANET
    jsr addmoonplanet
    
    ; Now create some moons (between 0 and 3)      
    lda _cpl_system+SEED+1
    and #%00000011
    beq moonsdone
    sta tmp1
    
    lda _PosX+1
    sta savpX+1
    lda _PosY+1
    sta savpY+1
    lda _PosZ+1
    sta savpZ+1


loop
    lda _cpl_system+SEED
    sta tmp
    jsr moonpos
    lda _PosX+1
    sec
    sbc tmp
    sta _PosX+1

    lda _cpl_system+SEED+2
    sta tmp
    jsr moonpos
    lda _PosY+1
    sec
    sbc tmp
    sta _PosY+1

    lda _cpl_system+SEED+3
    sta tmp
    jsr moonpos
    lda _PosZ+1
    sec
    sbc tmp
    sta _PosZ+1

    lda #<ONEMOON
    ldy #>ONEMOON
    jsr addmoonplanet


savpX 
    lda #0
    sta _PosX+1
savpY 
    lda #0
    sta _PosY+1
savpZ 
    lda #0
    sta _PosZ+1


    dec tmp1
    bne loop

moonsdone
    ; Create ships and others... for now, just testing
    jsr _InitTestCode
    rts


.)


planetpos
.(

    ; Now create the position of the planet (adapted from Elite TNK, but with small variations)
    lda #0
    sta _PosZ
    sta _PosX
    sta _PosY
    lda _cpl_system+SEED+1   
    and #%00110000
    clc
    adc #%00010000      ; result number between $10 and $40
    sta _PosZ+1
    lsr
    tax
    lda _cpl_system+SEED+1
    and #1
    beq noinvert
    txa
    eor #%11110000
    tax
noinvert
    stx _PosX+1
    stx _PosY+1
    rts
.)

addmoonplanet
.(

    ldx #<_PosX
    stx tmp0
    ldx #>_PosX   
    stx tmp0+1

    ldx #$80   ; Non-moving object
    jsr AddSpaceObjectDirect
    lda #255
    sta _energy,x    
    rts
.)

moonpos
.(
    lda tmp
    ldx tmp1
loop
    lsr
    lsr
    dex
    bne loop
    php
    and #%00000011
    clc
    adc #%00000001              ; Result between $1 and $4
    ;asl
    ;asl                     
    ;tax
    ;lda tmp
    plp
    ;and #1
    ;beq noinvert2
    bcc noinvert2
    ;txa
    eor #$ff
    ;tax
noinvert2    
    ;stx tmp
    sta tmp
    rts
.)


;;;;;;;;;;;;;;; TEST CODE

_InitTestCode 
.(
         ; Add some ships

         lda #<OCEN
         sta tmp0
         lda #>OCEN
         sta tmp0+1   
         lda #SHIP_ADDER
		 ;lda #SHIP_ANACONDA
		 ;lda #SHIP_COUGAR
         jsr AddSpaceObject   
         stx savid+1   
         lda _ai_state,x
         ;ora #(IS_AICONTROLLED | FLG_BOUNTYHUNTER)   
		 ;ora #(IS_AICONTROLLED | FLG_POLICE)   
		 ora #(IS_AICONTROLLED)   
         sta _ai_state,x

		 ;lda #2 ; Planet
		 ;sta _target,x
         ;lda _flags,x
		 ;ora #FLG_FLY_TO_PLANET
		 ;sta _flags,x
		
		 lda #(HAS_ESCAPEPOD)
		 jsr SetShipEquip

         lda #<OCEN2
         sta tmp0
         lda #>OCEN2
         sta tmp0+1   
         lda #SHIP_ASP
		 ;lda #SHIP_ANACONDA
		 ;lda #SHIP_COUGAR
         jsr AddSpaceObject   

        ; This one will pursue the other :)
savid   lda #0  ;SMC

        ; make it angry
        ora #IS_ANGRY
        ;sta _target,x        
        lda _ai_state,x
        ora #IS_AICONTROLLED   
        sta _ai_state,x

  		 lda #(HAS_ESCAPEPOD)
		 jsr SetShipEquip


        ;ldx VOB
        ;sta _target,x

        rts
.)

