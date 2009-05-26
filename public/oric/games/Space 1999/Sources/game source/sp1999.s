#include "white_defs.h" 
#include "picdef.h"
#include "sound.h"

#define DBUG 	lda #0 : dbug :	beq dbug


; To load World Map data into overlay ram (see bss section at the end of file list--frame.s)

#define NUM_SECT_MAP 38
#define SAVEPOINT_SECTOR 100 
#define SAVEPOINT2_SECTOR 102

;#define GRAMMAR2PAGE4
#ifdef GRAMMAR2PAGE4


#define WORLD_MAP_SECT_INIT 105
#define GRAMMAR_SECTOR 104

#else

#define WORLD_MAP_SECT_INIT 104

#endif

#define MUSIC_DATA_SECT_INIT = WORLD_MAP_SECT_INIT+NUM_SECT_MAP+1
#define NUM_SECT_MUSIC_DATA = 11

;#define SAVE_IRQ

; Start room
#define STARTROOM 1
;#define STARTROOM 199

; Definitions of objects and characters

#define KOENIG      0
#define HELENA      1
#define ENERGY_BALL 2
#define ENERGY_BALL2 3
#define ENERGY_BALL3 4

#define LAST_CHAR 4

#define COMMLINK    LAST_CHAR+1 
#define HCOMMLINK   LAST_CHAR+2
#define MEDKIT      LAST_CHAR+3
#define NOTEPAD     LAST_CHAR+4
#define BATTERY     LAST_CHAR+5
#define PLANTJUICE  LAST_CHAR+6
#define COMPOUND    LAST_CHAR+7
#define DOORKEY     LAST_CHAR+8
#define RELAY       LAST_CHAR+9
#define RESISTOR    LAST_CHAR+10
#define CHIP        LAST_CHAR+11
#define FUSE        LAST_CHAR+12
#define INDUCTOR    LAST_CHAR+13
#define SCREWDRIVER LAST_CHAR+14
#define WIRE        LAST_CHAR+15
#define OIL         LAST_CHAR+16

#define LAST_OBJ 16

; Items before this
;#define PUSHCHAIR   LAST+1
#define ZX81_R      LAST_CHAR+LAST_OBJ+1


_actor          .byt $ff            ; Current object we are acting with (Object code, $fd: empty slot, $ff: collision)


; Block of data needed by the game. Once set up, it could be used to save game :)

__savegame_data_start

; A magic byte to detect saved games

__magic .byt %11000011

; Needs to fill this?

_hero           .byt 0              ; Current PC

; $fe cannot be used (marks end of list of char names)
; $ff means no special action (collision)
; $fd means empty object

#define NO_ACTING $ff
#define EMPTY_SLOT $fd

; Flags for character status

;+-+-+-+-+-+-+-+-+
;|c x x x l l l l|
;+-+-+-+-+-+-+-+-+
; | | | | | | | |
; | | | | | | | +---------> |
; | | | | | | +-----------> |
; | | | | | +-------------> > Life points (max 10)
; | | | | +---------------> | 
; | | | +----------------->
; | | +------------------->
; | +--------------------->
; +-----------------------> Character is carrying his commlink

PFlags
Koenig_Flags      .byt %00001010            ; Flags for Koenig
Helena_Flags      .byt %10001010            ; Flags for Helena  

_Kinventory       .byt $fd,$fd,$fd  ; Koenig's inventory
_Kinventory_qty   .byt 0            ; Koenig number of items
_Kinventory_item  .byt 0            ; Koenig's current inventory item selected    


_Hinventory       .byt HCOMMLINK,$fd,$fd  ; Helena's inventory
_Hinventory_qty   .byt 1            ; Helena's number of items 
_Hinventory_item  .byt 0            ; Helena's current inventory item selected    

_is_door_open   .byt 0              ; Is there a door open?
_door_open      .dsb 4,0            ; Door which is open

_Alpha_power    .byt  90            ; Alpha's power status
_Alpha_lifesup  .byt 100            ; Alpha's life support status

_Benes_life     .byt 30             ; 30 minutes before Benes dies if not cured.

_progress       .byt 0              ; Percentage of progress in game.

current_level   .byt 3              ; Level at alpha where we currently are. Initially Main Mission (=3)

Flags           .byt %00011000      ; Some game flags


;+-+-+-+-+-+-+-+-+
;|p s b c h e t k|
;+-+-+-+-+-+-+-+-+
; | | | | | | | |
; | | | | | | | +---------> 0 if last cycle there was no key pressed or user pressed a different key        
; | | | | | | +-----------> Used with bit 0 to control if text of an object has been printed when colliding. Set to zero when bit 0.  
; | | | | | +-------------> 1 if emergency lights on
; | | | | +---------------> 0 if we can toggle between characters 
; | | | +-----------------> 1 if there is a message in commlink
; | | +-------------------> 1 if Benes told her room's passcode
; | +---------------------> 1 if Helena and Koenig shared passcodes in comlink
; +-----------------------> 1 if Benes told Paul's passcode


Flags2          .byt %00000000      ; More game flags
;+-+-+-+-+-+-+-+-+
;|m t s p 3 2 1 d|
;+-+-+-+-+-+-+-+-+
; | | | | | | | |
; | | | | | | | +---------> 0 Door control activated        
; | | | | | | +-----------> 1 if item 1 of circuit (battery) placed
; | | | | | +-------------> 1 if item 2 of circuit (resistor) placed
; | | | | +---------------> 1 if item 3 of circuit (inductor) placed
; | | | +-----------------> 1 if alien plant has been taken
; | | +-------------------> 1 if life support systems are open (player took the chip)
; | +---------------------> 1 if player tampered with Life Support and it is back working
; +-----------------------> 1 if the medicine synthesizer is operative (fuse has been replaced)


Flags3          .byt %00000000      ; And even more!
;+-+-+-+-+-+-+-+-+
;|t e m a f p b o|
;+-+-+-+-+-+-+-+-+
; | | | | | | | |
; | | | | | | | +---------> 1 If oil has been put on jammed door
; | | | | | | +-----------> 1 If Benes has been cured.
; | | | | | +-------------> 1 If the circuit in Paul's computer has been examined
; | | | | +---------------> 
; | | | +-----------------> 1 If main alarm is sounding
; | | +-------------------> 1 if there is a soundtrack playing in the background (to avoid play environmental sfx)
; | +---------------------> 1 If comming from the elevator. It is set when taking the elevator and cleared in hook_roomshown for sfx purposes
; +-----------------------> 1 If 'toggling' between characters. It is set and reset in the corresponding routine

; Passcodes stored on comlock
;+-+-+-+-+-+-+-+-+
;|f d h r s p c b|
;+-+-+-+-+-+-+-+-+
; | | | | | | | |
; | | | | | | | +---------> Bergman's quarters (in Koenig's)
; | | | | | | +-----------> Crew quarters (in cleaning office nearby)
; | | | | | +-------------> Pool (in a crew room)
; | | | | +---------------> Storage area (in the kitchen)
; | | | +-----------------> Power room (in guard quarters)
; | | +-------------------> Hydroponics Quarantine (in Hydroponics recovery)
; | +---------------------> Door Control (in security MM)
; +-----------------------> 


PasscodesK          .byt %00000000      ; Passcodes stored on Koenig's commlock
PasscodesR          .byt %00000000      ; Passcodes stored on Russel's commlock


; Timers for game control

#define NUM_TIMERS 6

#define T_STANDSTILL 0  ; To make the char standstill if no user input
#define T_ERASETEXTAREA 1   ; Ereasing the text area
#define T_ALPHAPOWER 2  ; Checking & reducing alpha power, LS and lifepoints, if necessary
#define T_ALARMMSG 3    ; Alarms and commlock messages
#define T_DOOR  4       ; Security door opening time
#define T_MUSIC 5       ; Background music


; Values for timers. A value of 0 keeps timer disabled. Value is in seconds. Add 1.
#define T_STANDSTILL_VAL        4      
#define T_ERASETEXTAREA_VAL     6
#define T_ALPHAPOWER_VAL        61 
#define T_ALARMMSG_VAL          31
#define T_DOOR_VAL              4
#define T_MUSIC                 0


_timer          .byt 0,0,T_ALPHAPOWER_VAL,T_ALARMMSG_VAL,0,0


; Automatic messages
orig .word Helena_comlock
msg .word Helena_1


; Interactions with characters
interact_Helena
    jmp interact_Helena1
interact_Koenig
    jmp interact_Koenig1
interact_Benes
    jmp interact_Benes0


; If this keep 0 entries, it may be removed from savegame data.

_objects
; Now objects made up of background tiles
; We are filling an array such as
;   objects[0].room=48;
;	objects[0].id=1;
;	objects[0].i=0;
;	objects[0].j=4;
;	objects[0].k=0;

.byt 112, PASSCODE, 8,2,1
.byt 114, PASSCODE, 4,8,1
.byt 162, PASSCODE, 3,8,0
.byt 193, PASSCODE, 7,8,1
.byt 39,  PASSCODE, 4,1,1
.byt 120, PASSCODE, 7,7,1
.byt 4,   PASSCODE, 4,7,0

_num_objects .byt 7


;; Data about characters and objects in game
;; We are filling the moving_chars array
;; moving_chars[0].room=STARTROOM;
;; moving_chars[0].frame=0;
;; moving_chars[0].direction=EAST; // This is ignored in white_add_new_char but should be consistent!
;; moving_chars[0].automov=0;

_moving_chars
    .byt STARTROOM, 0,            EAST,0     ; Data for Koenig
    .byt 105,       0,            EAST,0   ; Data for Helena
    .byt 41,        0 | %00000000,EAST  | %10000000,%10100010 ; Data for energy ball
    .byt 57,        0 | %00000000,SOUTH | %10000000,%10110010 ; Data for energy ball2
    .byt 199,       0 | %00000000,EAST  | %10000000,%10110010 ; Data for energy ball2
    .byt 2,         0 | %10000000,EAST | %10000000,0 ; Data for Commlink
    .byt WAREHOUSE, 0 | %10000000,EAST | %10000000,0 ; Data for Commlink (Helena)
    .byt 144,       0 | %10000000,EAST | %10000000,0 ; Data for Medkit
    .byt 144,       0 | %10000000,EAST | %10000000,0 ; Data for Notepad
    .byt 153,       0 | %10000000,EAST | %10000000,0 ; Data for Battery
    .byt WAREHOUSE, 0 | %10000000,EAST | %10000000,0 ; Data for Plantjuice
    .byt WAREHOUSE, 0 | %10000000,EAST | %10000000,0 ; Data for Compound
    .byt 128,       0 | %10000000,EAST | %10000000,0 ; Data for Key
    .byt 213,       0 | %10000000,EAST | %10000000,0 ; Data for Relay
    .byt 183,       0 | %10000000,EAST | %10000000,0 ; Data for Resistor
    .byt WAREHOUSE, 0 | %10000000,EAST | %10000000,0 ; Data for Chip
    .byt 179,       0 | %10000000,EAST | %10000000,0 ; Data for Fuse
    .byt 244,       0 | %10000000,EAST | %10000000,0 ; Data for Inductor
    .byt 160,       0 | %10000000,EAST | %10000000,0 ; Data for Screwdriver
;    .byt STARTROOM,       0 | %10000000,EAST | %10000000,0 ; Data for Screwdriver
    .byt 65,        0 | %10000000,EAST | %10000000,0 ; Data for Wire
;    .byt STARTROOM,        0 | %10000000,EAST | %10000000,0 ; Data for Wire
    .byt 226,       0 | %10000000,EAST | %10000000,0 ; Data for Oil bottle
;    .byt STARTROOM,       0 | %10000000,EAST | %10000000,0 ; Data for Oil bottle
    

; Items before this
;    .byt WAREHOUSE,0 | %10000000,EAST | %10000000,0 ; Data for Chair
    .byt 152,0 | %10000000,SOUTH | %10000000,%01000000 ; Data for robot

; To make it not affected by gravity set %00000010 to the last field!    



_num_characters .byt 22

;; Now the location of characters, fine coordinates i,j,k and 
;; type (including size and flags) 

_characters
    ; The C equivalent code would be:
	;characters[0].fine_coord_i=11;
    ;characters[0].fine_coord_j=11; 
    ;characters[0].fine_coord_k=0;
    ;characters[0].type=SIZE_CHAR;

	.byt 11,31,0,SIZE_CHAR          ; Koenig
	.byt 47,20,0,SIZE_CHAR          ; Helena
    .byt 26,18,07,SIZE_SMALLCHAR    ; Energy ball
    .byt 56,30,07,SIZE_SMALLCHAR    ; Energy ball
    .byt 53,30,07,SIZE_SMALLCHAR    ; Energy ball
    .byt 43,12,8,SIZE_SMALLCHAR      ; Commlink
    .byt 43+2,43,8,SIZE_SMALLCHAR   ; Commlink (Helena)
    .byt 42,12,8,SIZE_SMALLCHAR     ; Medkit
    .byt 48,40,8,SIZE_SMALLCHAR     ; Notepad
    .byt 12,24,8,SIZE_SMALLCHAR     ; Battery
    .byt 0,0,0,SIZE_SMALLCHAR       ; Plantjuice
    .byt 18,51,0,SIZE_SMALLCHAR     ; Compound
    .byt 18,51,8,SIZE_SMALLCHAR     ; Key
    .byt 44+4,34,8,SIZE_SMALLCHAR     ; Relay
    .byt 12,12,8,SIZE_SMALLCHAR     ; Resistor
    .byt 44,34,8,SIZE_SMALLCHAR     ; Chip
    .byt 48,44,8,SIZE_SMALLCHAR     ; Fuse
    .byt 24+2,6,8, SIZE_SMALLCHAR   ; Inductor
    .byt 24+2,42,8, SIZE_SMALLCHAR  ; Screwdriver
    .byt 42,42,0, SIZE_SMALLCHAR    ; Wire
    .byt 18,16,8, SIZE_SMALLCHAR    ; Oil

; Items before this
;    .byt 50,48,0,SIZE_BLOCK         ; Pushable chair
    .byt 14,24,0,SIZE_BLOCK         ; ZX81 cleaning robot

;; All the sprite data


;; First, the graphics..., lines, scans and pointers to graphic and shadow
_char_pics
	;char_pics[0].lines=34;
    ;char_pics[0].scans=3;
    ;char_pics[0].image=Helena0+101; //(scans*lines)-1
    ;char_pics[0].mask=Helena0SH+101;

    ; Koenig's character
	.byt 34,3
	.word _Koenig+101,_KoenigMask+101

    ; Russel's character
	.byt 34,3
	.word _Helena0+101,_Helena0SH+101

   ; Energy ball
    .byt 17,3
    .word _ballfire+50,_ballfire_mask+50

    ; Energy ball2
    .byt 17,3
    .word _ballfire+50,_ballfire_mask+50

    ; Energy ball3
    .byt 17,3
    .word _ballfire+50,_ballfire_mask+50

__savegame_data_end



    ; Koenig's commlink
    .byt 15,3
    .word _commlink+44, _commlink_mask+44

    ; Helena's commlink
    .byt 15,3
    .word _commlink+44, _commlink_mask+44

    ; Medkit
    .byt 12,3
    .word _medkit+35, _medkit_mask+35

    ; Notepad
    .byt 11,3
    .word _notepad+32, _notepad_mask+32

    ; Battery
    .byt 13,3
    .word _battery+38, _battery_mask+38

    ; Plantjuice
    .byt 12,2
    .word _plantjuice+23,_plantjuice_mask+23
    
    ; Compound
    .byt 12,3
    .word _compound+35,_compound_mask+35

    ; Key
    .byt 11,3
    .word _key+32,_key_mask+32

    ; Relay
    .byt 12,3
    .word _relay+35,_relay_mask+35

    ; Resistor
    .byt 10,3
    .word _resistor+29, _resistor_mask+29

    ; Chip 
    .byt 11,3
    .word _chip+32,_chip_mask+32

    ; Fuse
    .byt 12,3
    .word _fuse+35, _fuse_mask+35

    ; Inductor
    .byt 13,3
    .word _inductor+38, _inductor_mask+38

    ; Screwdriver
    .byt 10,3
    .word _screwdriver+29, _screwdriver_mask+29

    ; Wire
    .byt 13,3
    .word _wire+38, _wire_mask+38

    ; Oil
    .byt 13,3
    .word _oil+38, _oil_mask+38


; Items before this

    ; Pushable chair
;    .byt 30,4
;    .word plasticchair+119, plasticchair_mask+119

    ; ZX81 cleaning robot
    .byt 24,4
    .word _zx81+95,_zx81_mask+95

 


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _main
; Entry point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_main
.(
    ; white_add_hook(hook_roomloaded,HOOK_ROOMLOADED);
    lda #<_hook_roomloaded
    ldy #0
    sta (sp),y
    iny
    lda #>_hook_roomloaded
    sta (sp),y
    iny
    lda #HOOK_ROOMLOADED
    sta (sp),y
    jsr _white_add_hook

    ; white_add_hook(hoom_roomshown,HOOK_ROOMSHOWN);

    lda #<hook_roomshown
    ldy #0
    sta (sp),y
    iny
    lda #>hook_roomshown
    sta (sp),y
    iny
    lda #HOOK_ROOMSHOWN
    sta (sp),y
    jsr _white_add_hook

#ifdef SAVE_IRQ
    lda $fffe
    sta sav_irq
    lda $ffff
    sta sav_irq+1
#endif


    jsr _switch_ovl ; Activate overlay ram

    jsr _init_disk

    ; Sector to read    
    lda #WORLD_MAP_SECT_INIT
    ldy #0
    sta (sp),y
    tya
    iny
    sta (sp),y

    ; Address of buffer
    iny
    lda #<World_map
    sta (sp),y
    lda #>World_map
    iny
    sta (sp),y

    lda #NUM_SECT_MAP+16
    sta tmp
loop
    jsr _sect_read
    
    ;; Increment address
    ;ldy #3
    ;lda (sp),y
    ;clc
    ;adc #1
    ;sta (sp),y

    ; Increment sector to read
    ;ldy #0
    ;lda (sp),y
    ;clc
    ;adc #1
    ;sta (sp),y
    ;iny
    ;lda (sp),y
    ;adc #0
    ;sta (sp),y
    

    jsr inc_disk_params

    dec tmp
    bne loop


#ifdef GRAMMAR2PAGE4
    jsr init_grammar
#endif

    jsr _init_irq_routine 
    ;jsr _switch_ovl

    ; Init printing
    jsr _init_print    

    ; Init WHITE layer
    jsr	_white_init

    ; Print key mapping
    lda #<keylist_msg
    ldx #>keylist_msg
    jsr printnl

    ; Print version
    jsr print_version

    lda #TRACK_0_ON
    jsr PlayAudioTrack

    jsr initscroll

    jsr _init_print ; Again to restore cursor

	jsr clr_textarea

    jsr restore_game
    beq restored

    jsr StopAudioTrack

    jsr _init_game
restored
    jmp _game_loop   

.)



print_version
.(

    lda Cursor_origin_x
    sta save_x+1
    lda Cursor_origin_y
    sta save_y+1

    ldx #72
    ldy #159
    jsr relocate_cursor
    
    lda #<(version_name)
    ldx #>(version_name)
found
    jsr printnl 
save_x
    ldx #0
save_y
    ldy #0

    jmp relocate_cursor ; This is jsr/rts
    
.)



#ifdef GRAMMAR2PAGE4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Init grammar area with data from disk
; loads initial game state
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

init_grammar
.(

    ; Sector to read/write    
    lda #GRAMMAR_SECTOR
    ldy #0
    sta (sp),y
    tya
    iny
    sta (sp),y

    ; Address of buffer
    iny
    lda #<$400
    sta (sp),y
    lda #>$400
    iny
    sta (sp),y
    
    jsr _init_disk
    jsr _sect_read
    
    rts
.)
#endif




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Perform game initializations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_init_game
.(
    jsr init_timers

    ; Init inventories and their images. Also the current hero.
    lda _hero
    pha
    lda #HELENA
    sta _hero
    jsr update_image_inventory
    lda #KOENIG
    sta _hero
    jsr update_image_inventory
    pla
    sta _hero

    ; Init lifepoints
    jsr update_lifepoints

    ; It is as if toggling characters
    lda Flags3
    ora #%10000000
    sta Flags3

    ; Set starting room
    lda _hero
    asl
    asl
    tax
    lda _moving_chars,x    
    ldy #0
    sta (sp),y
	jsr _white_load_room		
    
    ; Tell WHITE who is the current player-controlled character
    lda _hero
    ldy #0
    sta (sp),y
	jsr _white_setPC

    lda Flags3
    and #%01111111
    sta Flags3

    ; Sets initial alarm message
    lda _timer+2    ; Get power timer
    beq no_pwr_msg
    lda #<alarm_pwr_msg
    ldx #>alarm_pwr_msg
    jsr printnl
no_pwr_msg

   
    rts
.)


; Updates lifepoints for both characters

update_lifepoints
.(
    ldx #1
    lda Koenig_Flags
    and #%00001111
    jsr PlotLifeBar 

    ldx #2
    lda Helena_Flags
    and #%00001111
    jsr PlotLifeBar 

    rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _game_loop
; General loop for game
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_game_loop
.(
    ; Update timers
    jsr do_timers

    ; Get player's action
    jsr player_action

    ; White's internal loop
    jsr _white_loop

    ; Check for open doors
    jsr check_doors
    
    ; Something to push?
;    jsr check_pushes

    ; Check main logic
    jsr main_logic
    beq cont
endgame

    ; Play sfx of dying
    jsr SilenceAll

    lda #DYING
    jsr PlayAudio

    ; Wait until it finishes
    ldx #2
wait
   	ldy EffectNumber,x
	bpl wait

    lda #LO(gameover_msg)
    ldx #HI(gameover_msg)
    jsr printnl

    lda #TRACK_3_ON
    jsr PlayAudioTrack

    jsr unrep_key
    
    ;jsr _switch_ovl  ; Put back ROM... 
    ;rts ; Should end up, and start again.

    jsr SilenceAll

    jmp reboot_oric

    
cont
    
end
    jmp _game_loop
.)


timed_actions
.(
    ; Check Timer0->PC standstill
    lda _timer
    cmp #1
    bne check1
    lda _hero
    ldy #0
    sta (sp),y
    jsr _white_standstill
    lda #0
    sta _timer

check1
    ; Check Timer1->Deleting text area
    lda _timer+1
    cmp #1
    bne check2
 ;   lda _hero
 ;   ldy #0
 ;   sta (sp),y
    jsr clr_textarea
    lda #0
    sta _timer+1

check2
    ; Check Timer2->Reducing Alpha power
    lda _timer+2
    cmp #1
    bne check3
    lda #T_ALPHAPOWER_VAL
    sta _timer+2
    lda _Alpha_power
    beq nodec
    dec _Alpha_power
nodec
    ; Using this timer also for Benes critical status
    lda Flags3
    and #%00000010  ; Has Benes been stabilized?
    bne nodec2
    lda _Benes_life
    beq nodec2
    dec _Benes_life
nodec2


check3    
    ; Check Timer3->Alarm messages
    lda _timer+3
    cmp #1
    bne check4
    lda #T_ALARMMSG_VAL
    sta _timer+3

    lda _Alpha_power
    cmp #25
    bcs nopower

    lda #LO(lowpower_msg)
    ldx #HI(lowpower_msg)
    jsr printnl

nopower
  
    lda _Alpha_lifesup
    cmp #25
    bcs nols

    lda #LO(lowlifesup_msg)
    ldx #HI(lowlifesup_msg)
    jsr printnl

nols

    ; Messages from Helena
    lda Koenig_Flags
    bpl nomsg
    lda Flags
    and #%10000
    beq nomsg

    lda #NEWMSG
    jsr PlayAudio

    jsr printmsg
nomsg

check4
    ; Check Timer4->Door control
    lda _timer+4
    cmp #1
    bne check5
    
    jsr lock_door

check5

    ; Check Timer5->Music control
    lda _timer+5
    cmp #1
    bne nomore
    lda #STOP_TRACK
    jsr PlayAudio
    ; Reflect that tune stopped sounding
    lda Flags3
    and #%11011111
    sta Flags3

nomore
    ; Actions that have to be performed
    ; on a timed basis
    jsr time_limit_events
    
    rts
.)

power_fail
.(
#ifdef BLINK
    ; Lights off
    lda #A_FWBLACK
    ldy #0
    sta (sp),y
    iny
    iny
    sta (sp),y
    jsr _white_show_screen

    lda _ink_colour
    ldy #0
    sta (sp),y
    iny
    iny
    lda _ink_colour2
    sta (sp),y
    jsr _white_show_screen

    lda #A_FWBLACK
    ldy #0
    sta (sp),y
    iny
    iny
    sta (sp),y
    jsr _white_show_screen
#endif
    ; Emergency lights

    lda #A_FWBLUE
    ldy #0
    sta (sp),y
    iny
    iny
    sta (sp),y
    jsr _white_show_screen
    
    lda Flags
    ora #%100
    sta Flags

end
    rts
.)

time_limit_events
.(
    ; If power < 15 emergency lights
    lda _Alpha_power
    cmp #15
    bcs other
    lda Flags
    and #%100
    bne other ; Already set
    jsr power_fail

other
    ; If power < 10 life support starts suffering
    lda _Alpha_power
    cmp #10
    bcs no_lifesup_dec

    ; Set general alarm on
    lda Flags3
    and #%10000
    bne already_set
    
    lda Flags3
    ora #%10000
    sta Flags3
    
    lda #ALARMPWR
    jsr PlayAudio    

already_set
    lda _Alpha_lifesup
    beq no_lifesup_dec
    dec _Alpha_lifesup
no_lifesup_dec
       
    lda _Alpha_lifesup
    cmp #10
    bcs no_lifepoints_dec

    dec Koenig_Flags
    dec Helena_Flags
    jsr update_lifepoints

no_lifepoints_dec

end
    rts
.)


init_timers
.(
    lda #100
    sta TimerCounter  
    rts
.)


do_timers
.(
    lda TimerCounter
    bpl no_tick
    clc
    adc #100
    sta TimerCounter
    
    ldx #NUM_TIMERS-1
loop 
    lda _timer,x
    beq nodec   
    dec _timer,x
nodec
    dex
    bpl loop
    
     ; Timed actions 
    jsr timed_actions


no_tick
    rts
.)


; Prints messages over commlink
printmsg
.(
;+orig
;    lda #<Helena_comlock
;    ldx #>Helena_comlock
    lda orig
    ldx orig+1
    jsr printnl
;+msg
;    lda #<Helena_1
;    ldx #>Helena_1
    lda msg
    ldx msg+1
    jsr printnl    
    
    rts
.)

print_can_switch
.(

    lda #<(can_toggle_msg)
    ldx #>(can_toggle_msg)
    jmp printnl ; This is jsr/rts
.)

print_cant_switch
.(

    lda #<(cant_toggle_msg) 
    ldx #>(cant_toggle_msg)
    jmp printnl ; This is jsr/rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Performs main logic of the game
; if it is possible to continue, 
; returns Z=1, else returns Z=0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
main_logic
.(
    ; If any of the characters die, then end game
    lda Koenig_Flags
    and #%00001111
    bne koenig_lives
    lda #<koenigdead_msg
    ldx #>koenigdead_msg
    jsr printnl
    jmp retnotzeroflag
koenig_lives

    lda Helena_Flags
    and #%00001111
    bne helena_lives
    lda #<helenadead_msg
    ldx #>helenadead_msg
    jsr printnl
    jmp retnotzeroflag
helena_lives

    lda _Benes_life
    bne benes_lives
    lda #<benesdead_msg
    ldx #>benesdead_msg
    jsr printnl
    jmp retnotzeroflag
benes_lives 

retzeroflag
    lda #0
    rts
retnotzeroflag
    ldx #$ff
    rts

.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Response to player actions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

reset_flags
    lda Flags
    and #%11111100 ; Reset
    sta Flags
    rts

avoid_rep
    lda Flags
    and #%00000001
    rts


oldKey .byt $00
player_action
.(

; Get key, if any
    ldx KeyCode
    bne treatkey
    jmp reset_flags ; This is jsr/rts
    

; Get jmp address and modify jump destination
treatkey
    cpx oldKey
    beq cont
    jsr reset_flags
    stx oldKey
cont
    dex
    lda action_tblL,x
    sta jmp_dst+1
    lda action_tblH,x
    sta jmp_dst+2


; Jump to response function for key pressed
jmp_dst
    jsr $1234

; Do whatever shall be done when user has pressed a key

    lda Flags
    ora #%00000001 ; Set bit 0 
    sta Flags

    lda #T_STANDSTILL_VAL
    sta _timer

    rts
.)

action_tblH .byt >(turn_anticlockwise), >(turn_clockwise), >(step_forward)
            .byt >(step_backwards), >(toggle_player), >(back_item)
            .byt >(adv_item), >(action), >(drop)
action_tblL .byt <(turn_anticlockwise), <(turn_clockwise), <(step_forward)
            .byt <(step_backwards), <(toggle_player), <(back_item)
            .byt <(adv_item), <(action), <(drop)


; Step forward (M key)
step_forward
.(
    lda _hero
    ldy #0
    sta (sp),y
    jsr _white_step
    beq cant
    jsr ticosound
cant
    rts
.)
    
; Turn Clockwise (X key)
turn_clockwise
.(
    jsr avoid_rep
    beq cont
    rts
cont
.)
    ;jsr _kbdclick1
    lda #CLOCKWISE
    jmp turn ; This is jsr/rts
 
; Turn anticlockwise (Z key)
turn_anticlockwise
.(
    jsr avoid_rep
    beq cont
    rts
cont
.)
    ;jsr _kbdclick2
    lda #ANTICLOCKWISE
    ;jmp turn ; This is jsr/rts
turn
    ldy #2
    sta (sp),y
    lda _hero
    ldy #0
    sta (sp),y
    jmp _white_turn ; This is jsr/rts


; Step backwards (B Key)

step_backwards
.(
    lda #1
    sta _ignore_collisions
    
    ; Get direction field
    lda _hero
    asl
    asl
    tax
    inx
    inx
    lda _moving_chars,x
    ora #%10000000
    sta _moving_chars,x

    ; Save index to direction field
    txa 
    pha
    
    jsr twoturns
    
    lda _hero
    ldy #0
    sta (sp),y
    jsr _white_step
    jsr ticosound

    pla
    pha
    tax
    lda _moving_chars,x
    ora #%10000000
    sta _moving_chars,x

    
    jsr twoturns

    pla
    tax
    lda _moving_chars,x
    and #%01111111
    sta _moving_chars,x
    
    lda #0
    sta _ignore_collisions
    rts
.)


; Toggle between Koenig and Russel (T key)
toggle_player
.(
    jsr avoid_rep
    beq cont
    rts
cont
    lda Flags
    and #%1000
    beq can1

    ; Can't switch now
    ;lda #<(cant_toggle_msg)
    ;ldx #>(cant_toggle_msg)
    ;jsr printnl
    ; rts
    jmp print_cant_switch ; This is jsr/rts
    
can1
    ; Toggle between Helena and Koenig
    ; Don't if there is a door open
    lda _is_door_open
    beq toggle

cant
    ; Can't switch now
    lda #<(cant_toggle_msg2)
    ldx #>(cant_toggle_msg2)
    jsr printnl
    
    rts

toggle

    ; Play sfx
    lda #TOGGLE
    jsr PlayAudio

    ; Set flag to indicate we are toggling
    lda Flags3
    ora #%10000000
    sta Flags3

    lda _hero
    beq wasKoenig
    lda #0
    beq assign_PC
wasKoenig
    lda #1
assign_PC
    sta _hero
    
    ldy #0
    sta (sp),y
    jsr _white_setPC 

    ; Clear flag

    lda Flags3
    and #%01111111
    sta Flags3


    lda #<(toggle_msg)
    ldx #>(toggle_msg)
    jsr print

    lda _hero
    sta tmp
    jsr print_char_name
    jmp perform_CRLF  ; This is jsr/rts

.)    


; Action function (CTRL key)
action
.(
    jsr norep_print    
    beq end

    ldy #0
    lda _hero
    sta (sp),y

    ;cmp #KOENIG
    bne isHelena
    ldx _Kinventory_item
    lda _Kinventory,x
    jmp invdone
isHelena
    ldx _Hinventory_item
    lda _Hinventory,x 
invdone
    sta _actor
    jsr _white_interact
    lda #$ff
    sta _actor

end    
    rts
.)


; Menu function (ESC key)
; NOW MEANS DROP (SEE BELOW FOR IMPLEMENTATION)
; INVENTORY SECTION


; Inventory advance (- and = keys)
adv_item
    ldy #1 
    jmp goadv
back_item
    ldy #0
goadv
.(
    jsr avoid_rep
    beq cont
    rts
cont
    lda _hero
    ;cmp #KOENIG
    bne isHelena
    ldx _Kinventory_item
    lda _Kinventory_qty
    sta tmp
    jsr adv_sel
    stx _Kinventory_item
    lda _Kinventory,x
    jmp invdone
isHelena
    ldx _Hinventory_item
    lda _Hinventory_qty
    sta tmp
    jsr adv_sel
    stx _Hinventory_item
    lda _Hinventory,x 
invdone

    jsr print_sel
    jsr mark_selected_item

    ; Play sfx
    lda #MENUCHG
    jsr PlayAudio

    rts

.)

adv_sel
.(
    bne go
    rts
go
    tya
    beq back
    inx
    cpx tmp
    bne end
    ldx #0
    jmp end
back
    dex
    cpx #$ff
    bne end
    ldx tmp
    dex
end 
    rts
.)

print_sel
.(
    sta tmp
    jsr print_char_name 
    jmp perform_CRLF    ; This is jsr/rts
.)




;;;;;;;;;;;;;;;; Inventory Management ;;;;;;;;;;;;;;;;;


;;;;;;;;;;;; Dropping objects ;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Drops selected object from 
; inventory from current hero
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
tries .byt 0
savX .byt 0
savID .byt 0
drop
.(
    jsr avoid_rep
    beq cont1
    rts
cont1
    lda _hero
    ;cmp #KOENIG
    bne wasHelena
    ldx _Kinventory_item
    lda _Kinventory,x
    jmp cont
wasHelena
    ldx _Hinventory_item
    lda _Hinventory,x
cont
    ; Is it *really* an object?
    cmp #$fd
    bne doit
    ; State we don't have an object selected
    lda #<(No_name)
    ldx #>(No_name)
    jmp printnl ; This is jsr/rts
    ; rts
doit
    ; If a door is open, state we can't drop it here
    ldy _is_door_open
    bne cantmsg

    ; Create the object. Start saving ID
    sta savID

        
    ; Move it to room and correct position
    ; Start by putting it where the hero is... will modify
    ; it later, depending on hero's direction
    asl
    asl
    tax
    stx savX

    lda #1
    sta tries
loop    
    ldx savX
    lda _hero
    asl
    asl
    tay ; Index for hero
    
    lda _current_room
    sta _moving_chars,x

    lda _characters,y
    sta _characters,x
    inx
    iny
    lda _characters,y
    sta _characters,x
    inx
    iny
    lda _characters,y
    clc
    adc tries  ; Don't put it directly on the floor
    sta _characters,x    
   
    jsr check_space
    beq dropit

    jsr check_surface
    bne cantdrop

    lda tries
    clc
    adc #8
    sta tries
    cmp #17
    bne loop
    
    jmp cantdrop

dropit
    jsr _white_add_new_char    
    
    ; Remove item from inventory

    jsr fix_inventory

    ; play sfx
    lda #DROP
    jsr PlayAudio

    ; Somethihg special to be done?
    
    lda savID
    cmp #COMMLINK
    beq commlink
    cmp #HCOMMLINK
    bne nocommlink
commlink
    jsr un_mark_commlink
nocommlink
    rts

cantdrop
    ; Put it back into inventory
    ldx savX
    lda #WAREHOUSE
    sta _moving_chars,x

cantmsg
    jsr norep_print
    beq end
    lda #<cantdrop_msg
    ldx #>cantdrop_msg
    jsr printnl
end    
    rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; checks if a surface is appropriate
; to drop objects over it.
; returns Z=1 on success.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

surface_tbl .byt GLASS_TILE, SHELF, TRESSLE_SHELVES
            .byt SOLIDBRICK, FOLDED_TOWEL, CHAIR_SE
            .byt BATHSW,DESK_LEFT,DESK_RIGHT,SOFA_SW,TERMINAL
surface_tbl_entries .byt 10

check_surface
.(

    ldx _num_bkg_collisions
    beq can

    dex
    txa
    asl
    asl
    tax
loop
    ldy surface_tbl_entries
    lda _bkg_collision_list,x
    and #%00111111
loop2
    cmp surface_tbl-1,y
    beq found
    dey
    bne loop2
    ; Was not found
    jmp cannot    
found    
    dex
    dex
    dex
    dex
    bpl loop
can 
    lda #0
    rts
cannot
    lda #1
    rts
.)


; Checks if there is enough space to drop an object here
; returns Z=1 on sucess.

check_space
.(
    ; Gets hero direction
    lda _hero
    asl
    asl
    tax
    inx
    inx
    lda _moving_chars,x
   	and #%01111111 ; Remove flag

    ldx savX

    cmp #NORTH
    bne nonorth
    inx
    lda _characters,x
    sec
    sbc #4      ; Width j for character
    sta _characters,x
    jmp cont2
nonorth
    cmp #SOUTH
    bne nosouth
    inx
    lda _characters,x
    clc
    adc #5      ; Width j for objects
    sta _characters,x
    jmp cont2
nosouth
    cmp #EAST
    bne noeast
    lda _characters,x
    clc
    adc #5      ; Width i for objects
    sta _characters,x
    jmp cont2
noeast
    lda _characters,x
    sec
    sbc #4      ; Width i for character
    sta _characters,x
cont2

    ; Now check collisions to see if there is space

    lda savID
   	ldy #0
	sta (sp),y  

    ldy #2
    lda #DOWN
    sta (sp),y 
    jsr _collision_test
    
    stx tmp
    ora tmp
    rts

.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Removes selected item from inventory
; and relocates all elements
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fix_inventory
.(
    
    lda _hero

    ;cmp #KOENIG
    bne wasHelena
    ldx _Kinventory_item
    lda #EMPTY_SLOT ; Empty item
    sta _Kinventory,x
    ldx #0
    stx _Kinventory_item
    lda #<(_Kinventory) 
    sta tmp0
    lda #>(_Kinventory)
    sta tmp0+1
    dec _Kinventory_qty
    ldy _Kinventory_qty
    jmp cont
wasHelena
    ldx _Hinventory_item
    lda #$fd ; Empty item
    sta _Hinventory,x
    ldx #0
    stx _Hinventory_item
    lda #<(_Hinventory) 
    sta tmp0
    lda #>(_Hinventory)
    sta tmp0+1
    dec _Hinventory_qty
    ldy _Hinventory_qty
 cont   
    sty tmp

    ldy #0
loop
    lda (tmp0),y
    cmp #$fd
    beq next
    pha
next
    iny
    cpy #3
    bne loop
    
    ldy #0
loop2
    dec tmp
    bpl add
    lda #$fd    
    sta (tmp0),y
    jmp next2
add
    pla
    sta(tmp0),y
next2
    iny
    cpy #3
    bne loop2

    jmp update_image_inventory ; This is jsr/rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Updates the inventory images
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
index   .byt 00
update_image_inventory
.(

    ldx #0
    stx index
    lda #$b6
    sta tmp0+1

    lda _hero
    bne isHelena
    lda #$09+40+40
    bne done1
isHelena
    lda #$25+40+40
done1    
    sta tmp0


loop
    lda _hero
    bne isHelena2
    lda _Kinventory,x
    jmp add_pic
isHelena2
    lda _Hinventory,x
   
add_pic
    
; Now draw the pic
    cmp #EMPTY_SLOT
    beq clear
    
    ; Get object entry (start in id=4)
    sec
    sbc #LAST_CHAR+1

    ; Multiply x 42 (3*14)
    sta tmp
    ldy #0
    sty tmp+1
    asl
    asl  ; (x4)
    pha
    adc tmp ;(x5)
    sta tmp
    pla
    asl
    rol tmp+1
    asl
    rol tmp+1 ; (x16)
    adc tmp ; (x16+x5)=(x21)
    sta tmp
    lda #0
    adc tmp+1    
    sta tmp+1
    lda tmp
    asl
    rol tmp+1
    sta tmp  ; (x2)=(x42)!


    lda #LO(commlink_inv)
    clc
    adc tmp
    sta tmp1
    lda #HI(commlink_inv)
    adc tmp+1
    sta tmp1+1

    jsr put_block
    jmp continue

clear
    jsr clear_block

continue
    lda tmp0
    clc
    adc #$3
    sta tmp0

    inc index
    ldx index
    cpx #3
    bne loop

    jsr mark_selected_item

    rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draws a block of 3x14
; Gets pointer to dest in tmp0
; and pointer to source in tmp1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
put_block
.(
    lda tmp1
    sta src+1
    lda tmp1+1
    sta src+2
    lda tmp0
    sta dst+1
    lda tmp0+1
    sta dst+2
    
    ldx #14
loop_rows

    ldy #2

loop_scans
src
    lda 1234,y
    ;lda #%01111111
dst
    sta 1234,y
    dey
    bpl loop_scans
    
    ; Increment source 
    lda src+1
    clc
    adc #3
    bcc no_inc1
    inc src+2
no_inc1
    sta src+1

    ; Increment destination
    lda dst+1
    clc
    adc #40
    bcc no_inc2
    inc dst+2
no_inc2
    sta dst+1
    
    dex
    bne loop_rows

    rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clears a block of 3x14
; Gets pointer to dest in tmp0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear_block
.(
    lda tmp0
    sta dst+1
    lda tmp0+1
    sta dst+2
    
    ldx #14
loop_rows

    ldy #2
    lda #%01000000
loop_scans
dst
    sta 1234,y
    dey
    bpl loop_scans
    
    ; Increment destination
    lda dst+1
    clc
    adc #40
    bcc no_inc2
    inc dst+2
no_inc2
    sta dst+1
    
    dex
    bne loop_rows

    rts
.)

selbar .byt  $EA,$D5 ;$ED,$D2,$ED
noselbar .byt $40,$40 ;,$40

mark_selected_item
.(
    lda #$b6;b5
    sta tmp0+1
    
    ldx #0
    lda _hero
    ;cmp #KOENIG
    bne isHelena
    lda #$0a;e2
    ldx _Kinventory_qty
    ldy _Kinventory_item
    jmp add_mark
isHelena
    lda #$26;fe
    ldx _Hinventory_qty
    ldy _Hinventory_item

add_mark
    sta tmp0

    dex
    bpl something
    ldy #$ff
something
    sty tmp5

    lda tmp0
    clc
    adc #<720-40
    sta tmp1
    lda tmp0+1
    adc #>720-40
    sta tmp1+1

    ldx #0
loop1
    ldy #1            
loop
    cpx tmp5
    bne nosel
    lda selbar,y
    bne cont
nosel
    lda noselbar,y
cont
    sta (tmp0),y
    sta (tmp1),y
    dey
    bpl loop

    lda tmp0
    clc
    adc #3
    sta tmp0
    bcc nocarry
    inc tmp0+1
nocarry

    lda tmp1
    clc
    adc #3
    sta tmp1
    bcc nocarry2
    inc tmp1+1
nocarry2

    inx
    cpx #3
    bne loop1
    
    rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Checks if an item is in a hero's
; inventory. A=hero ID, X=Item code
; Returns Z=1 on success and X=position
; in inventory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
is_in_invent
.(
    stx item+1

    lda _hero
    ;cmp #KOENIG
    bne isHelena
    ldx _Kinventory_qty
    lda #<(_Kinventory)
    ldy #>(_Kinventory)
    jmp cont
isHelena
    ldx _Hinventory_qty
    lda #<(_Hinventory)
    ldy #>(_Hinventory)

cont
    dex
    bmi end_fail
    stx qty+1
    sta inv_addr+1
    sty inv_addr+2


qty
    ldx #0
loop
inv_addr
    lda $1234,x
item
    cmp #0
    beq end_success    
    dex
    bpl loop

end_fail
    lda #1
    rts
end_success
    lda #0
    rts
.)


;;;;;;;;;;;;Auxiliar functions ;;;;;;;;;;;;;;;;;;;


; Make the character turn twice
twoturns
.(
    ldx #2
loop
    lda _hero
    ldy #0
    sta (sp),y
    lda #CLOCKWISE
    ldy #2
    sta (sp),y
    txa
    pha
    jsr _white_turn
    pla
    tax
    dex
    bne loop

    rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Performs 'tico tico' sound for
; stepping
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
countertico .byt 0
ticosound
.(
;    lda counter
;    and #1
;    beq co_sound
;    ;jsr _kbdclick1 ; 'ti' sound
;    jmp ticodone
;co_sound
;    ;jsr _kbdclick2 ; 'co' sound
;ticodone
;    inc counter
;    rts

    ; Prevent sounding if channel used
    ldx #2
   	ldy EffectNumber,x
	bpl end

    lda countertico
    inc countertico
    and #1
    beq doit
    rts
    
doit

    lda _hero
    beq ticoKoenig

    lda #STEPH
    bne play    ; Jumps allways...
ticoKoenig
    lda #STEPK
    
play
    jsr PlayAudio   

end
    rts

.)

   



;;;;;;;;;; Stuff to manage doors ;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Open a door if player is carrying the commlink
; and some conditions are satisfied ONLY COR_DOORS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
door_cond_tbl

; Room ID, Pos i, Flags1, Passcode    
.byt 161,   0, %00100000, %00000000  ; Benes' quarters
.byt 145,   0, %01000000, %00000000  ; Helena's quarters
.byt 177,   0, %10000000, %00000000  ; Paul's quarters
.byt 129, 255, %00000000, %00000001  ; Bergman's quarters
.byt 67,  255, %00000000, %00000100  ; Pool
.byt 25,    4, %00000000, %00010000  ; Power room
.byt 135, 255, %00000000, %00100000  ; Hydroponics A (quarantine area) 

#define NUM_COND 6      ; Marks the end (num entries -1)

; Check door conditions and return
; Z=1 if cannot open or Z=0 if can open
check_conditions
.(
    ldy #NUM_COND
    
loop
    tya
    ;sta tmp
    ;asl
    ;clc
    ;adc tmp
    asl
    asl

    tax
    lda door_cond_tbl,x
    cmp _current_room
    beq found
    
    dey    
    bpl loop
    
end_notfound
    lda #1
    rts

found
    ldy #4
    lda door_cond_tbl+1,x
    bmi dontcompare
    cmp (sp),y ; compare with i position of block (should be COR_DOOR)
    bne end_notfound
dontcompare

    ; Now check flags
    lda door_cond_tbl+2,x
    beq flags2
    and Flags
    rts
flags2
    lda door_cond_tbl+3,x
    ;and Flags2
    jsr check_passwd
    rts
.)

_open_door_c
.(
    ldx _hero
    lda PFlags,x
    ;bmi _open_door
    bpl dontopen

    jsr check_conditions
    ;bne _open_door
    beq dontopen
    jmp _open_door
.)
dontopen
.(
    jsr norep_print
    beq end

    lda#<(cantopendoor)
    ldx#>(cantopendoor)
    jsr printnl   
end
    rts
.)


; Open surgery door with some conditions
_open_door_sc
.(
    lda _current_room
    cmp #244
    beq bergman
    cmp #183
    beq hisec
    cmp #225
    beq storage
    cmp #162
    beq crew
    cmp #146
    beq crew
    cmp #130
    beq crew
    cmp #4
    beq armory

    jmp _open_door

bergman
    jsr norep_print
    beq end

    lda#<(bergmandoor_msg)
    ldx#>(bergmandoor_msg)

    jsr printnl
    jmp dontopen   
    
hisec
    ; Check Flags2
    lda Flags2
    and #%00000001 ;Is door control activated?
    bne _open_door

    ; Check if it is the inner door
    ldy #4
    lda (sp),y
    cmp #4
    bne _open_door

    jsr norep_print
    beq end
    jmp dontopen


storage
    ; Check passcode
    lda #%00001000
    bne check ; This is a jmp

armory
    ; This is slightly different
    lda Flags3
    and #%00000001
    bne _open_door

    jsr norep_print
    beq end
    lda#<(door_jammed)
    ldx#>(door_jammed)
    jmp printnl   ; This is jsr/rts


crew
    ; Check passcode
    lda #%00000010
check
    jsr check_passwd
    ;bne _open_door
    ;jmp dontopen
    beq dontopen
    jmp _open_door

end
    rts
.)


; Check if the player carries a given password in a commlock
; Params a=bitmask of passwd
; Returns Z=0 if present, else Z=1

check_passwd
.(
    sta bitmask

    ; Check commlock
    lda _hero
    ldx #COMMLINK
    jsr is_in_invent
    bne other
    lda PasscodesK
    and bitmask
    beq other    
    rts ; Success!

other
    lda _hero
    ldx #HCOMMLINK
    jsr is_in_invent
    beq check
    lda #0
    rts     ; Failure
check
    lda PasscodesR
    and bitmask
    rts

bitmask .byt 0
.)



; Player tries to open Bergman's closet in Astrophysics
; with the Key
bergman_door
.(
    lda _current_room
    cmp #244
    beq doopen

    jsr norep_print
    beq end

    lda#<(keynofits_msg)
    ldx#>(keynofits_msg)
    jsr printnl   

    jmp dontopen
end
    rts

doopen
    lda#<(keyfits_msg)
    ldx#>(keyfits_msg)
    jsr printnl

    jmp _open_door

.)



;;;;;;;;;;;;;;;;;;;;;;
; _open_door
; Function that opens a door with 
; one frame animation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_open_door
.(
    ;; Open a door

    ; Play sfx
    lda #DOOR
    jsr PlayAudio

    ;; Set flag that indicates that a door is open
    lda #1
    sta _is_door_open
    
    ;; Fill in the door structure
    ;; Uses the params passed to white_collided_with_bkg, which
    ;; are (in order): who, against, i, j, k.
    ;; In the meantime, we start filling parameters for calling
    ;; white_change_block(i,j,k,newID)
   
    ldy #2
    lda (sp),y
    ldx #3
    sta _door_open,x  ; open_door.id=against
   
    ldy #4
    lda (sp),y
    ldx #0
    sta _door_open,x  ; open_door.i=i
    ldy #0
    sta (sp),y        ; set 1st param (i) for later function call
  
    ldy #6
    lda (sp),y
    inx
    sta _door_open,x  ; open_door.j=j
    ldy #2
    sta (sp),y        ; set 2nd param (j) for later function call
  
    ldy #8
    lda (sp),y
    inx
    sta _door_open,x  ; open_door.k=k
    ldy #4
    sta (sp),y        ; set 3rd param (k) for later function call
     
    ; Animate opening: load frame of animation (tilecode=against+1)
    inx
    lda _door_open,x
    clc
    adc #1
    ldy #6
    sta (sp),y
        
    jsr _white_change_block

    ;jsr _white_loop
    
    ; Now proceed to open: change for tile 0
    ; Have to set all parameters again (else does not work)

    ldx #0
    lda _door_open,x
    ldy #0
    sta (sp),y    

    inx
    lda _door_open,x
    ldy #2
    sta (sp),y    

    inx
    lda _door_open,x
    ldy #4
    sta (sp),y    

    lda #0
    ldy #6
    sta (sp),y
        
    jmp _white_change_block ; This is jsr/rts
     
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _close_door
; Function that closes a door with 
; one frame animation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_close_door
.(

    ; Play sfx
    lda #DOOR
    jsr PlayAudio

    ; Animate closing: load frame of animation (tilecode=against+1)
    ldx #0
    lda _door_open,x
    ldy #0
    sta (sp),y    

    inx
    lda _door_open,x
    ldy #2
    sta (sp),y    

    inx
    lda _door_open,x
    ldy #4
    sta (sp),y    

    inx
    lda _door_open,x
    clc
    adc #1
    ldy #6
    sta (sp),y
        
    jsr _white_change_block
    ;jsr _white_loop

    ; Now proceed to close: change for tile saved in _door_open.type (4th field)
    ; Have to set all parameters again (else does not work)

    ldx #0
    lda _door_open,x
    ldy #0
    sta (sp),y    

    inx
    lda _door_open,x
    ldy #2
    sta (sp),y    

    inx
    lda _door_open,x
    ldy #4
    sta (sp),y    

    inx
    lda _door_open,x
    ldy #6
    sta (sp),y
        
    jsr _white_change_block

    ; Clear the flag that indicates a door is open.    
    lda #0
    sta _is_door_open

    rts
.)

; Player puts oil on jammed door
lubricate_door
.(

    jsr norep_print
    beq end

    lda #<lubricate_door_msg
    ldx #>lubricate_door_msg
    jsr printnl
end
    lda _current_room
    cmp #4
    bne end2

    lda Flags3
    ora #%00000001
    sta Flags3
end2    
    rts

.)


tablXdoor
    .byt 1,1,0,0

tablAdoor
    .byt 8,0,8,0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; _hook_roomloaded
; Hook for once a room is loaded
; serves for keeping a door open
; or chaniging colors
; when changing rooms
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_hook_roomloaded
.(
      
    ; Are we coming from a lift?
    lda Flags3
    and #%01000000
    beq nolift

    jsr key2cont

    ;lda Flags3
    ;and #%10111111
    ;sta Flags3

    ; sfx for make it stop
    lda #LIFT_STOP
    jsr PlayAudio
    
    ; wait till effect ends
    ldx #2
wait
   	ldy EffectNumber,x
	bpl wait

nolift
    ; Print room name
    jsr print_room_name


    ; Check power
    lda Flags
    and #%100
    beq next
    
    lda #A_FWBLUE 
    sta _ink_colour
    sta _ink_colour2

    ; Check doors
next
    lda _is_door_open
    beq end

    ; Are we coming from a lift?
    lda Flags3
    and #%01000000
    beq nolift2    
    lda #SOUTH
    jmp skip

nolift2    
    lda _hero       ; Get ID of current Player-Controlled character
    asl
    asl             ; Multiply by four
    tax
;    inx
;    inx             ; Get third field (direction)
    lda _moving_chars+2,x
    and #%01111111

skip   
    tay
    ldx tablXdoor,y
    lda tablAdoor,y
    sta _door_open,x

    ; Substitute door for tile 0
    ldx #0
    lda _door_open,x
    ldy #0
    sta (sp),y    

    ;inx
    lda _door_open+1,x
    ldy #2
    sta (sp),y    

    ;inx
    lda _door_open+2,x
    ldy #4
    sta (sp),y    

    lda #0
    ldy #6
    sta (sp),y
        
    jsr _white_change_block
end
    rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Open a door from a lift... needs
; to activate a hook
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_open_lift_door
.(
    jsr norep_print
    bne cont
    rts
cont

    lda _Alpha_power
    bne openit
    lda #<(liftno_msg)
    ldx #>(liftno_msg)
    jsr printnl
    rts

openit

    ; Open the door
    jsr _open_door

    ; white_add_hook(hook_lifts,HOOK_PRELOAD);
    ldy #0
    lda #<(_hook_lifts)
    sta (sp),y
    iny
    lda #>(_hook_lifts)
    sta (sp),y
    lda #HOOK_PRELOAD
    iny
    sta (sp),y
    lda #0
    iny
    sta (sp),y
    
    jmp _white_add_hook ; This is jsr/rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; check_doors
; Function that checks when a door has to close
; automatically´
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

check_doors
.(
    lda _is_door_open
    beq end
        
    lda _door_open      ; Load i pos of door
    clc                 ; calculate (i+1)*6+2
    adc #1
    asl
    sta tmp
    asl
    adc tmp
    adc #2
    ldy #0
    sta (sp),y

    lda _door_open+1    ; Load j pos of door
    clc                 ; calculate (j+1)*6+2
    adc #1
    asl
    sta tmp
    asl
    adc tmp
    adc #2
    ldy #2
    sta (sp),y
    
    lda _door_open+2    ; Load k pos of door
    asl                 ; calculate k*8
    asl
    asl
    ldy #4
    sta (sp),y

    lda #SIZE_AREA
    ldy #6
    sta (sp),y

    jsr _detect_pressence ; look if there is someone near the door
    bne end         ; is there someone? Then don't close it.
    jsr _close_door       ; else close it.
 
            
    ; Remove the hook for lifts
    lda #HOOK_PRELOAD
    ldy #0
    sta (sp),y
    jsr _white_remove_hook
    
end
    rts
.)



; Hook that is called when a room is shown
hook_roomshown

; Prepare ambient sound
    jsr room_ambient

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; do_blink
; Makes special tiles blink
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

do_blink
.(
    lda needs_blink
    beq endblink

    lda #0
    sta needs_blink

    ; Make it blink!

    jsr blink_tile
    jsr blink_tile
    jsr blink_tile

endblink

; Basically check if we are overlapping Helena and Koenig
; If so we are in trouble... But do this only if not changing characters
; with TOGGLE key...
  
    lda Flags3
    bmi end


; Same if coming from a lift

    ; Are we coming from a lift?
    lda Flags3
    and #%01000000
    beq nolift

    lda Flags3
    and #%10111111
    sta Flags3

    jmp end

nolift    

    lda _hero
    ldy #0
    sta (sp),y
    jsr _white_step
    bne end    ; No problem, proceed

    lda #1
    sta _ignore_collision_test
    jsr step_backwards
    jsr step_backwards
    lda #0
    sta _ignore_collision_test

end

    rts


.)

prepare_params_blink
.(
    ; Prepare params to get_tile
    ldx #2
    ldy #4
loop
    lda blink,x
    sta (sp),y
    dey
    dey
    dex
    bpl loop
   
    rts
.)

blink_tile
.(
    jsr prepare_params_blink
    jsr _get_tile
    stx tile+1
  
    ldy #6
    lda #0
    sta (sp),y
    jsr _white_change_block

    jsr prepare_params_blink
tile
    lda #0
    ldy #6
    sta (sp),y
    jsr _white_change_block
    
    rts
.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Auxiliar functions for in-game matters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; waitkey
; Waits for a keypress and returns it in reg x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;waitkey
;.(
;    ldx #0
;    stx KeyCode
;loop
;    ldx KeyCode
;    beq loop
;    rts
;.)


; Function to check if something has been pushed by the player
;check_pushes
;.(
;    lda push_me+1
;    beq end
;    ldy #2
;    sta (sp),y
;    lda push_me
;    ldy #0
;    sta (sp),y
;    jsr push
;    lda #0
;    sta push_me+1
;end
;    rts
;.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Collision callbacks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Action table: Over Background objects ONLY.
actions_bkg
    .byt COR_DOOR
    .byt NO_ACTING
    .word _open_door_c
    .byt SURGERY_DOOR
    .byt NO_ACTING
    .word _open_door_sc
    .byt LIFT
    .byt NO_ACTING
    .word _open_lift_door
    .byt TERMINAL
    .byt PLANTJUICE
    .word prepare_medicine
    .byt TERMINAL
    .byt FUSE
    .word repair_synthesizer
    .byt SURGERY_DOOR
    .byt DOORKEY
    .word bergman_door
    .byt SURGERY_DOOR
    .byt OIL
    .word lubricate_door
    .byt BENES
    .byt COMPOUND
    .word cure_benes
    .byt WALL_CHIP
    .byt BATTERY
    .word place_bat 
    .byt WALL_CHIP
    .byt RESISTOR
    .word place_res 
    .byt WALL_CHIP
    .byt INDUCTOR
    .word place_ind
    .byt WALL_CHIP
    .byt SCREWDRIVER
    .word get_chip
    .byt WALL_CHIP
    .byt WIRE
    .word tamper_lifesupport
    .byt WALL_CHIP
    .byt CHIP
    .word place_chip
actions_bkg_end
#define SIZ_BKG_TABLE 14


simple_ctrl
    .byt INFO
    .word infopost_menu
    .byt ROOT
    .word get_plant
    .byt BENES
    .word interact_Benes
    .byt CONTROL_UNIT
    .word door_control
    .byt WALL_CHIP
    .word main_circuit_check
    .byt MONITOR_FRONT
    .word pauls_list
    .byt TERMINAL
    .word no_fix
    .byt PASSCODE
    .word get_pass
simple_ctrl_end
#define SIZE_CTRL_TABLE 8

object_names
    .byt INFO
    .word infopost
    .byt ROOT
    .word alien_plant
    .byt TERMINAL
    .word meds_lab
    .byt BENES
    .word benes_name
    .byt CONTROL_UNIT
    .word control_name
    .byt WALL_CHIP
    .word circuit_name
    .byt MONITOR_FRONT
    .word monitor_name
    .byt PASSCODE
    .word passcode_name
    .byt 0  ;End

#define SIZE_PASS_TABLE 7
passcode_locs
    .byt 112
    .byt 114
    .byt 162
    .byt 193
    .byt 39
    .byt 120
    .byt 4
passcode_names_hi
    .byt >Berg_pass
    .byt >Crew_pass
    .byt >Pool_pass
    .byt >Storage_pass
    .byt >Power_pass
    .byt >Hyd_pass
    .byt >Door_ctrl_pass
passcode_names_lo
    .byt <Berg_pass
    .byt <Crew_pass
    .byt <Pool_pass
    .byt <Storage_pass
    .byt <Power_pass
    .byt <Hyd_pass
    .byt <Door_ctrl_pass
passcode_bitmasks
    .byt %00000001
    .byt %00000010
    .byt %00000100
    .byt %00001000
    .byt %00010000
    .byt %00100000
    .byt %01000000



; Gets a passcode in player's commlock
get_pass
.(
    lda #0
    sta end+1

    lda _hero
    ldx #COMMLINK
    jsr is_in_invent
    bne next
    jsr get_passmask
    ora PasscodesK
    sta PasscodesK
    sta end+1

next
    lda _hero
    ldx #HCOMMLINK
    jsr is_in_invent
    bne end

    jsr get_passmask
    ora PasscodesR
    sta PasscodesR
    sta end+1

end
    lda #$0 ; This is self-modifying code
    bne correct

    ; Can't get a passcode without commlock
    lda #<no_commlock_pass        
    ldx #>no_commlock_pass
    jmp printnl

correct
    ; Remove passcode object
    jsr remove_passobj

    ; play sfx
    lda #BEEPGRL
    jsr PlayAudio
    
    ; Tell the player
    lda #<newpass_msg
    ldx #>newpass_msg
    jmp printnl
.)


get_passmask
.(
    ; Search for passcode
    ldx #SIZE_PASS_TABLE
loop
    lda passcode_locs-1,x
    cmp _current_room
    bne not_this
    
    ; Room found!

    lda passcode_bitmasks-1,x
    rts

not_this
    dex
    bne loop     

.)


; Remove the passcode object. Just change the objects array
; Moving the proper one to the WAREHOUSE.
; This is a modified version of _white_to_warehouse

remove_passobj
.(

    ; Search for the entry
    lda _num_objects
    sec
    sbc #1
    
    ; x5
    sta tmp
    asl
    asl
    adc tmp
    tax
loop    
    lda _objects,x
    cmp _current_room
    bne next

    ; Found! Change room to warehouse
    lda #WAREHOUSE
    sta _objects,x

    ; Remove obj: call white_change_block
    ; Prepare params
    ldy #4
    lda (sp),y
    ldy #0
    sta (sp),y

    ldy #6
    lda (sp),y
    ldy #2
    sta (sp),y

    ldy #8
    lda (sp),y
    ldy #4
    sta (sp),y

    ldy #6
    lda #0
    sta (sp),y

    jmp _white_change_block ; This is jsr/rts

next
    dex
    dex
    dex
    dex
    dex

    bpl loop

    rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char white_collided_with_bkg(char who, char against, char i, char j, char k)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
_white_collided_with_bkg
.(
    ; Search for against and actor in the action table
    ldx #((SIZ_BKG_TABLE-1)*4) ; index to the last element
    ldy #2
    lda (sp),y ; get against
    and #%00111111 ; Remove special and invert bits
    sta tmp
loop
    lda actions_bkg,x   ; get element
    cmp tmp
    bne notfound
    lda actions_bkg+1,x ; get actor
    cmp _actor
    bne notfound

    ; found: call routine and end
    lda actions_bkg+2,x ; get address and modify code so we jsr to it
    sta jump+1
    lda actions_bkg+3,x
    sta jump+2
jump
    jsr $1234
    jmp end
notfound    
    dex 
    dex
    dex
    dex
    bpl loop

default
    lda _actor
    cmp #NO_ACTING
    bne default2

    ; Default for normal collision
    ; Prints the object name in the text area
    jsr norep_print
    beq end 
    jsr print_obj_name
    jsr perform_CRLF
    jmp end

default2
    ; Acting CTRL over an object
     jsr simple_ctrl_check

end    
    ; Continue reporting, return 1
    lda #0
    ldx #1
    rts
.)

simple_ctrl_check
.(
    
    ldx #((SIZE_CTRL_TABLE-1)*3) ; index to the last element

loop
    lda simple_ctrl,x   ; get element
    cmp tmp
    bne notfound

    ; found: call routine and end
    lda simple_ctrl+1,x ; get address and modify code so we jsr to it
    sta jump+1
    lda simple_ctrl+2,x
    sta jump+2
jump
    jsr $1234
    jmp end
notfound    
    dex 
    dex
    dex
    bpl loop
end
    rts  

.)


print_obj_name
.(

    ; Check if it is a passcode
    lda #PASSCODE
    cmp tmp
    bne not_passcode
    jmp print_passcode

not_passcode
   ldx #0
loop
    lda object_names,x
    beq end
    
    cmp tmp
    beq printname
    
    inx
    inx
    inx
    jmp loop

printname
    lda object_names+1,x
    tay
    lda object_names+2,x
    tax
    tya

    jmp print ; This is jsr/rts
end
    rts

.)


print_passcode
.(

    ldx #>passcode_name
    lda #<passcode_name
    jsr print
    
    ; Search for passcode
    ldx #SIZE_PASS_TABLE
loop
    lda passcode_locs-1,x
    cmp _current_room
    bne not_this
    
    ; Room found!

    lda passcode_names_lo-1,x
    tay
    lda passcode_names_hi-1,x
    tax
    tya
    jmp print ; This is jsr/rts

not_this
    dex
    bne loop     
    
; Not found!
    rts

.)


; Pickups management

; List of objects that the character may take

#define NUM_PICKUPS 16
pickup_lst .byt COMMLINK, HCOMMLINK, MEDKIT, NOTEPAD
           .byt BATTERY, PLANTJUICE, COMPOUND, DOORKEY
           .byt RELAY, RESISTOR, CHIP, FUSE 
           .byt INDUCTOR, SCREWDRIVER, WIRE, OIL



; Action table: For (free) objects ONLY
actions_char
;     .byt PUSHCHAIR ; Pushable chair
;     .byt NO_ACTING
;     .word addpush
     .byt ZX81_R
     .byt BATTERY
     .word repair
     .byt HELENA   
     .byt PLANTJUICE
     .word give_plant_helena
     .byt KOENIG
     .byt MEDKIT
     .word cure_koenig
     .byt HELENA
     .byt MEDKIT
     .word cure_helena
#define SIZ_CHAR_TABLE 4

char_names
    .byt KOENIG
    .word Koenig_name
    .byt HELENA
    .word Helena_name
    .byt COMMLINK 
    .word Commlink_name
    .byt HCOMMLINK
    .word CommlinkH_name
    .byt MEDKIT 
    .word Medkit_name
    .byt NOTEPAD 
    .word Notepad_name
    .byt BATTERY
    .word Battery_name
;    .byt PUSHCHAIR
;    .word Chair_name
    .byt ZX81_R
    .word zx81_name
    .byt PLANTJUICE
    .word plantjuice_name
    .byt COMPOUND
    .word compound_name
    .byt DOORKEY
    .word key_name
    .byt RELAY
    .word relay_name
    .byt RESISTOR
    .word resistor_name
    .byt CHIP
    .word chip_name
    .byt FUSE
    .word fuse_name
    .byt INDUCTOR
    .word inductor_name
    .byt SCREWDRIVER
    .word screwdriver_name
    .byt WIRE
    .word wire_name
    .byt OIL
    .word oil_name
    .byt EMPTY_SLOT        ; No object
    .word No_name
    .byt $fe        ; End list


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Process collision with game objects, depending
; on the above list
; returns Z=0 if no action found (run default)
; in tmp there is the against parameter
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
process_col
.(
    ; Search for against and actor in the action table
    ldx #((SIZ_CHAR_TABLE-1)*4) ; index to the last element
   ; ldy #2
   ; lda (sp),y ; get against
   ; sta tmp
   ; lda tmp
loop
    lda actions_char,x   ; get element
    cmp tmp
    bne notfound
    lda actions_char+1,x ; get actor
    cmp _actor
    bne notfound

    ; found: call routine and end
    lda actions_char+2,x ; get address and modify code so we jsr to it
    sta jump+1
    lda actions_char+3,x
    sta jump+2
    lda tmp
jump
    jsr $1234
    ldx #0    
    rts

notfound    
    dex 
    dex
    dex
    dex
    bpl loop
    
    lda tmp
    ldx #1
    rts
.)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; char white_collided_with_char(char who, char against)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
index_object .byt 0
_white_collided_with_char
.(
    ldy #2
    lda (sp),y ; Get against
    sta tmp    ; save it 

    ; Special cases, like chair to be pushed
;    cmp #PUSHCHAIR
;    beq complex_action

    jsr check_enemies
    beq continue
    jmp end            

continue
    lda _actor
    cmp #NO_ACTING
    bne complex_action
  
default ; When not acting with CTRL
    ldy #0
    lda (sp),y  ; Get who
    cmp _hero
    bne end ; Is not the current hero... ignore
    
    jsr norep_print
    beq end 
    jsr print_char_name
    jsr perform_CRLF

    lda Flags
    ora #%00000010
    sta Flags

    jmp end

complex_action
    ; Actions to perform
    jsr process_col
    beq end ; Success

    ; Default with CTRL key, just take the object
    ; If it is the robot, then try to get the battery back
    lda tmp
    cmp #ZX81_R
    bne get

    asl
    asl
    tax
    stx index_object
    lda _moving_chars+3,x
    and #%10000000
    beq get3

    lda #BATTERY
    sta tmp
    jsr get_object
    bne end
    ldx index_object
    lda _moving_chars+3,x
    and #%01111111
    sta _moving_chars+3,x
    jmp end
get
    cmp #HELENA
    bne get2
    jsr interact_Helena
    jmp end
get2
    cmp #KOENIG
    bne get3
    jsr interact_Koenig
    jmp end

get3
    jsr get_object    
    lda #0
    tax
    rts

end
    ; Continue reporting, return 1
    lda #0
    ldx #1
    rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if someone collided with an enemy
; and act accordingly
; Return z=0 if this did not happen
; Register A contains the against param
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
check_enemies
.(
    ldy #0
    cmp #ENERGY_BALL
    beq enemy
    cmp #ENERGY_BALL2
    beq enemy
    cmp #ENERGY_BALL3
    bne skip1

enemy
    lda (sp),y
hit
    jsr remove_lifepoints

    lda #BUMP
    jsr PlayAudio

    lda #1
    rts

skip1    
    cmp #HELENA
    beq wasHelena
    cmp #KOENIG
    beq wasKoenig
    bne end

wasKoenig
wasHelena
    tax
    lda (sp),y
    cmp #ENERGY_BALL
    beq enemy2
    cmp #ENERGY_BALL2
    beq enemy2
    cmp #ENERGY_BALL3
    bne end
enemy2
    txa
    jmp hit
end
    lda #0
    rts

.)


remove_lifepoints
.(
    tax
    dec PFlags,x

    lda PFlags,x
    and #%00001111
    inx
    jsr PlotLifeBar 

    ;jsr _explode
    rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print_char_name
; Prints the name of character ID in tmp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

print_char_name
.(

   ldx #0
loop
    lda char_names,x
    cmp #$fe
    beq end
    
    cmp tmp
    beq printname
    
    inx
    inx
    inx
    jmp loop

printname
    lda tmp
    pha
    lda char_names+1,x
    tay
    lda char_names+2,x
    tax
    tya
    jsr print
    pla

    ; Special things...
    cmp #ZX81_R
    bne end
    
    ; Robot: print if powered or unpowered
    asl
    asl
    tax
    lda _moving_chars+3,x
    and #%10000000
    beq unpowered
    
    lda #<(powered_msg)
    ldx #>(powered_msg)
    jmp ppower
unpowered
    lda #<(unpowered_msg)
    ldx #>(unpowered_msg)

ppower
    jsr print
 
end
    rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Gets the object in tmp
; Returns z=0 if not possible
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
get_object
.(
    ldx #NUM_PICKUPS-1
loop
    lda pickup_lst,x
    cmp tmp
    beq found
    dex
    bpl loop

    jsr norep_print
    beq end     

    ;lda tmp
    ;pha
    lda #<(cannottake_msg)
    ldx #>(cannottake_msg)
    jsr printnl
    ;pla
    ;sta tmp
    ;jsr print_char_name
    ;jsr perform_CRLF
end 
    ldx #1   
    rts ; Not found

found
    ; Can we take it?
    ldx _hero
    cpx #KOENIG
    bne isHelena
    ldx _Kinventory_qty 
    jmp check
isHelena
    ldx _Hinventory_qty
check
    cpx #3
    bne getit
    
    lda #<(no_space_inv)
    ldx #>(no_space_inv)
    jsr printnl
    ldx #1
    rts

getit
    ; Get object

    lda #PICKUP
    jsr PlayAudio

    ; First make it dissappear
    lda tmp
    pha
    
    ldy #0
    sta (sp),y
    jsr _white_remove_char

    ; Now move it to warehouse
    pla
    tay ; Saves a for later
    asl
    asl
    tax
    lda #WAREHOUSE
    sta _moving_chars,x ; get room

    ; And add it to inventory
    tya
    
    ldx _hero
    cpx #KOENIG
    bne isHelena2
    ldx _Kinventory_qty 
    sta _Kinventory,x
    inc _Kinventory_qty
    jmp more

isHelena2
    ldx _Hinventory_qty
    sta _Hinventory,x
    inc _Hinventory_qty
   
more
    ; Check if something else has to be done

    cmp #COMMLINK
    beq commlink
    cmp #HCOMMLINK
    bne nocommlink
commlink
    jsr mark_commlink
nocommlink
   

add_pic
    ; Update inventory image
    jsr update_image_inventory 
    ldx #0
    rts

.)


; Mark that current hero does have the commlink

mark_commlink
.(
    ldx _hero
    lda PFlags,x
    ora #%10000000
    sta PFlags,x
    rts
.)


un_mark_commlink
.(
    ldx _hero
    lda PFlags,x
    and #%01111111
    sta PFlags,x
    rts
.)

#ifdef 0
push_me .dsb 2,0
push
.(
    lda #1
    sta _ignore_collisions

    ldy #0
    lda (sp),y

    asl
    asl
    tax
    inx
    inx
    lda _moving_chars,x
    pha

    ldy #2
    lda (sp),y
    asl
    asl
    tax
    inx
    inx
    pla
    sta _moving_chars,x

    dex
    ; Check if we are in a dangerous area:
	cmp #NORTH
	bne no_north
	lda _characters,x ; Get j coordinate
	cmp #11
	bne no_border
	jmp aftercollision
no_north
	cmp #SOUTH
	bne no_south
	lda _characters,x ; Get j coordinate
	cmp #48
	bne no_border
	jmp aftercollision
no_south
	cmp  #EAST
	bne no_east
	dex
	lda _characters,x ; Get i coordinate
	cmp #48
	bne no_border
	jmp aftercollision
no_east
   	cmp  #WEST
	bne no_west
	;dex
	lda _characters,x ; Get i coordinate
	cmp #11
	bne no_border
	;jmp aftercollision 
no_west
    ; No feasible direction
    jmp aftercollision
    
no_border
    ldy #2
    lda (sp),y
    ldy #0
    sta (sp),y
    jsr _white_step

aftercollision
    lda #0
    sta _ignore_collisions

    
    rts
.)

#endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Lifepoints bar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Update Life Levels 
;Both Koenig(0) and Helena(1) have life bars of the same size and byte allignment 

;110101010101010101010100 
;110101010101010101010100 
;110101010101010101010100 
;110101010101010101010100 
;000000111111000000111111 

;Life points will change colour as follows 
;7-10 Green 
;5-6  Yellow 
;3-4  Magenta 
;0-2  Red 
;A==Life Points (0(Dead)-10(Healthy)) 
;X==Player1(1) or Player2(2) 
;All Registers corrupted 
PlotLifeBar 
   ; 
   ldy LifeBarScreenOffset-1,x 
   tax 
   lda LifeBarColour,x 
   sta $A000+40*127,y 
   sta $A000+40*128,y 
   sta $A000+40*129,y 
   sta $A000+40*130,y 
   lda LifeBarImage0,x 
   sta $A000+1+40*127,y 
   sta $A000+1+40*128,y 
   sta $A000+1+40*129,y 
   sta $A000+1+40*130,y 
   lda LifeBarImage1,x 
   sta $A000+2+40*127,y 
   sta $A000+2+40*128,y 
   sta $A000+2+40*129,y 
   sta $A000+2+40*130,y 
   lda LifeBarImage2,x 
   sta $A000+3+40*127,y 
   sta $A000+3+40*128,y 
   sta $A000+3+40*129,y 
   sta $A000+3+40*130,y 
   lda LifeBarImage3,x 
   sta $A000+4+40*127,y 
   sta $A000+4+40*128,y 
   sta $A000+4+40*129,y 
   sta $A000+4+40*130,y 
   rts 

LifeBarScreenOffset 
 .byt 0 
 .byt 34 
LifeBarColour 
 .byt 1+128,1+128,1+128,5+128,5+128,3+128,3+128,2+128,2+128,2+128,2+128 
LifeBarImage0 
 .byt %01110000   ;0  - Red 
 .byt %01110100   ;1  - Red 
 .byt %01110101   ;2  - Red 
 .byt %01110101   ;3  - Magenta 
 .byt %01110101   ;4  - Magenta 
 .byt %01110101   ;5  - Yellow 
 .byt %01110101   ;6  - Yellow 
 .byt %01110101   ;7  - Green 
 .byt %01110101   ;8  - Green 
 .byt %01110101   ;9  - Green 
 .byt %01110101   ;10 - Green 
LifeBarImage1 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01010000 
 .byt %01010100 
 .byt %01010101 
 .byt %01010101 
 .byt %01010101 
 .byt %01010101 
 .byt %01010101 
 .byt %01010101 
LifeBarImage2 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01010000 
 .byt %01010100 
 .byt %01010101 
 .byt %01010101 
 .byt %01010101 
LifeBarImage3 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01000000 
 .byt %01010000 
 .byt %01010100





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Text functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


_init_print
.(

  ldx #6
  ldy #168
  jsr relocate_cursor
  rts  

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Auxiliar routine to avoid repeated printing when
; user keeps key pressed.
; Uses Flags t and k for that purpose
; and returns Z=0 if we are not repeating
; and Z=1 if we are.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

norep_print
.(
        ; Check if we are just repeating the message
    lda Flags
    and #%00000011 
    cmp #%11
    bne printme
    jmp end
printme
    lda Flags
    ora #%00000010
    sta Flags
    lda #1
end
    rts    
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ask for keypress
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

key2cont
.(
    lda #<(key)
    ldx #>(key)
    jsr print
    jsr unrep_key

    ; If not in a lift, make sfx
    lda Flags3
    and #%01000000
    bne cont
    
    lda #MENUCHG
    jsr PlayAudio    
cont
    jsr clr_textarea
    rts

.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; prints a long speech from a character
; needs pointer to speech text in regs a and x
; and number of lines in reg y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pline .word $0000
lcount .byt $00
numlines .byt $00
print_speech
.(

    sta pline
    stx pline+1
    sty numlines

    ; Play speech music
    lda #TRACK_2_ON
    jsr PlayAudioTrack

    jsr clr_textarea
    ldy #0
    sty lcount
loop
    ;lda #A_FWBLUE
    lda #A_FWGREEN
    jsr put_code
    
    lda pline
    ldx pline+1
    jsr printnl
    
    txa
    sec
    adc pline
    sta pline
    bcc nocarry
    inc pline+1
nocarry    
    
    ldy lcount
    cpy #3
    bne nokey
    jsr key2cont
    ldy lcount
nokey
    iny
    sty lcount
    cpy numlines
    bne loop

    jsr key2cont

end    
    
    ; Stop speech music
    jsr StopAudioTrack

    rts

.)



    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; printnl
; prints a string in text area ADDING a newline
; String pointer passed in (sp)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printnl
.(
    jsr print
    jmp perform_CRLF ; This is jsr/rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; print
; prints a string in text area
; String pointer passed in a (low) and x (high)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print
.(
    ; Get pointer to text string
    sta text+1
    stx text+2

    ; Start printing char by char
  	ldx #0
loop
;text
	;lda 1234,x		; Get Next letter
    ;beq end         ; if 0, we are finished
    ;jsr put_code
    
    lda Cursor_origin_y
    cmp #198
    bne cont
    ; Perform scrolling
    txa
    pha

    ldy #6
loop1
    jsr SmoothScrollHiresTextWindow 
    dey
    bne loop1

    lda Cursor_origin_y
    sec
    sbc #6
    tay
    ldx Cursor_origin_x
    jsr relocate_cursor
    pla
    tax
cont
text
    lda 1234,x		; Get Next letter
    beq end         ; if 0, we are finished
    jsr decomp
    inx
    jmp loop

end

    ; Start text timer
    lda #T_ERASETEXTAREA_VAL
    sta _timer+1

    rts
.)


#ifdef GRAMMAR2PAGE4
.bss
*=$400

Grammar .dsb 256

.text

#endif

;;;;;;;;;; Decompression routine ;;;;;;;;;;;;;;;;;;
;__comp_start
decomp
.(
    tay
    ; Prepare the stack for the decompression routine
    lda #0
    pha
    tya
    pha

loop
    pla
    ; If it is 0, we are done
    beq end
    ; If it is a token, expand it, else print and continue
    bpl printit

    and #%01111111 ; Get table entry
    asl
    tay
    lda Grammar+1,y
    pha
    lda Grammar,y
    pha
    jmp loop
printit
    jsr put_code
    jmp loop
end
    rts
.)

;__comp_end

;#echo Size of decomp routine in bytes:
;#print (__comp_end - __comp_start)
;#echo



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; clr_textarea
; Clears text area
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

clr_textarea
.(

    lda #LO($a000+168*40+1)
    sta tmp1
    lda #HI($a000+168*40+1)
    sta tmp1+1

looprows
    ldy #39-1-1
    lda #$40
loopcols
    sta (tmp1),y
    dey
    bpl loopcols

    lda tmp1
    clc
    adc #40
    sta tmp1
    bcc nocarry
    inc tmp1+1
nocarry
    
    lda tmp1
    cmp #LO($a000+198*40+1)
    bne next
    lda tmp1+1
    cmp #HI($a000+198*40+1)
    bne next
    jmp end

next
    jmp looprows
end
    jsr _init_print

    rts
.)



SmoothScrollHiresTextWindow 
.(
        ;Using Dbug method (31 rows to scroll) 
        ldx #37 
loop1   lda $a001+40*168,x 
        sta $a001+40*167,x 
        lda $a001+40*169,x 
        sta $a001+40*168,x 
        lda $a001+40*170,x 
        sta $a001+40*169,x 
        lda $a001+40*171,x 
        sta $a001+40*170,x 
        lda $a001+40*172,x 
        sta $a001+40*171,x 
        lda $a001+40*173,x 
        sta $a001+40*172,x 
        lda $a001+40*174,x 
        sta $a001+40*173,x 
        lda $a001+40*175,x 
        sta $a001+40*174,x 
        lda $a001+40*176,x 
        sta $a001+40*175,x 
        lda $a001+40*177,x 
        sta $a001+40*176,x 
        lda $a001+40*178,x 
        sta $a001+40*177,x 
        lda $a001+40*179,x 
        sta $a001+40*178,x 
        lda $a001+40*180,x 
        sta $a001+40*179,x 
        lda $a001+40*181,x 
        sta $a001+40*180,x 
        lda $a001+40*182,x 
        sta $a001+40*181,x 
        lda $a001+40*183,x 
        sta $a001+40*182,x 
        lda $a001+40*184,x 
        sta $a001+40*183,x 
        lda $a001+40*185,x 
        sta $a001+40*184,x 
        lda $a001+40*186,x 
        sta $a001+40*185,x 
        lda $a001+40*187,x 
        sta $a001+40*186,x 
        lda $a001+40*188,x 
        sta $a001+40*187,x 
        lda $a001+40*189,x 
        sta $a001+40*188,x 
        lda $a001+40*190,x 
        sta $a001+40*189,x 
        lda $a001+40*191,x 
        sta $a001+40*190,x 
        lda $a001+40*192,x 
        sta $a001+40*191,x 
        lda $a001+40*193,x 
        sta $a001+40*192,x 
        lda $a001+40*194,x 
        sta $a001+40*193,x 
        lda $a001+40*195,x 
        sta $a001+40*194,x 
        lda $a001+40*196,x 
        sta $a001+40*195,x 
        lda $a001+40*197,x 
        sta $a001+40*196,x 
        lda #$40 
        sta $a001+40*197,x 
        dex 
        bmi skip1 
        jmp loop1 
skip1   rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Twilighte's code for printing texts...
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.zero
screen  .word 00
.text
Cursor_origin_x .dsb 1 
Cursor_origin_y .dsb 1 

#define res_x tmp4
#define res_y tmp4+1

ascii2code 
        cmp #97 
.( 
        bcs skip1 
        cmp #65 
        bcs skip2 
        sbc #32 
        stx tmp 
        tax 
        lda punctuation_ascii,x ;31 Bytes 
        ldx tmp 
        rts 
skip1   sbc #97 
        rts 
skip2   sbc #39 
.) 
        rts 
punctuation_ascii 
 .byt 64,64,64,65,64,62,73,66,67,75,64,69,74,68,64,61 
 ;    !  "  #  $  %  &  '  (  )  *  +  ,  -  .  /  0 
 .byt 52,53,54,55,56,57,58,59,60,71,70,64,76,64,63 
 ;    1  2  3  4  5  6  7  8  9  :  ;  <  =  >  ? 


;Perform $CRLF 
perform_CRLF 
        stx res_x 
        sty res_y
        lda Cursor_origin_y 
        clc 
        adc #06 ;Vertical character spacing 
        tay 
        ldx Cursor_origin_x 
        jsr relocate_cursor 
        ldx res_x 
        ldy res_y
        rts 


;Relocate Cursor 
;Pass: 
;X X position on screen (Byte alligned 0 to 39) 
;Y Y position on screen (Row alligned 0 to 195) 
relocate_cursor 
        pha 
        ;Calculate screen loc 
        stx Cursor_origin_x 
        sty Cursor_origin_y 
        
        stx op1
        sty op2

        lda #0
        tay
        sta (sp),y
        jsr _set_doublebuff
            
        jsr pixel_address
        lda tmp0
        sta screen
        lda tmp0+1
        sta screen+1

        lda #1
        ldy #0
        sta (sp),y
        jsr _set_doublebuff
        
        pla
        rts

put_colcombo 
        pha 
        and #7 
        sta colour_0 
        pla 
        lsr 
        lsr 
        lsr 
        lsr 
        and #7 
        sta colour_1 
        jmp put_colour_combo 

;Print character, colour or Carriage return at next cursor position 
;A Character Code 
put_code 
        cmp #128 
        bcs put_colcombo 
        cmp #13 
        beq perform_CRLF 
        bcc put_colour 


;Print character at next cursor position 
;A Character Code 
put_char 
        stx res_x 
        sty res_y
        cmp #32 
        beq put_space 
        jsr ascii2code 
        jsr put_char_direct 
increment_cursor 
.(
        inc screen 
        bne skip1 
        inc screen+1 
skip1   
        ldx res_x 
        ldy res_y
     
        rts 
.)


put_space 
        lda #64 
;Places the colour in A at the current cursor position and increments the 
;cursor. 
;Pass: 
;A Colour(0-7) 
put_colour 
        sta colour_0 
        sta colour_1 

;Places the colour combination of colour_0 and colour_1 at the current cursor 
;position and increments the cursor. 
;Pass: 
;colour_0 The first colour (Repeated thrice) 
;colour_1 The second colour (Repeated twice) 
put_colour_combo 
        stx res_x 
        sty res_y 
        lda colour_0 
        ldx colour_1 
        ldy #00 
        sta (screen),y 
        txa 
        ldy #40 
        sta (screen),y 
        lda colour_0 
        ldy #80 
        sta (screen),y 
        txa 
        ldy #120 
        sta (screen),y 
        lda colour_0 
        ldy #160 
        sta (screen),y 
        jmp increment_cursor 


;Relocate cursor and Print character 
;Pass: 
;X X position on screen (Byte alligned 0 to 39) 
;Y Y position on screen (Row alligned 0 to 195) 
;A Character Code (ASCII) 
place_char 
        jsr relocate_cursor 
        jsr ascii2code 
put_char_direct 
        tax     ;char_number 
        lda character_bitmap_row0,x 
        ldy #00 
        sta (screen),y 
        lda character_bitmap_row1,x 
        ldy #40 
        sta (screen),y 
        lda character_bitmap_row2,x 
        ldy #80 
        sta (screen),y 
        lda character_bitmap_row3,x 
        ldy #120 
        sta (screen),y 
        lda character_bitmap_row4,x 
        ldy #160 
        sta (screen),y 
        rts 

;73 Characters + 7 for special chars (Not defined yet) [CHEMA: 73=', 74=-, 75=ç (put *), 76==]
;80 Characters == 400($190) Bytes 

; old version
;character_bitmap_row0   ;80 Bytes 
;    .byt  $40,$70,$40,$46,$40,$5c,$7e,$70,$58,$4c,$58,$58,$40,$40,$40,$40 
;    .byt  $40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$7e,$7e,$7e,$7e,$7e,$7e 
;    .byt  $7e,$72,$5c,$5c,$72,$5c,$7e,$7e,$7e,$7e,$7e,$7e,$7e,$7e,$72,$72 
;    .byt  $6a,$72,$72,$7e,$7c,$7c,$7e,$7c,$7e,$7e,$7e,$7e,$7e,$7e,$58,$7e 
;    .byt  $5c,$7e,$5c,$5c,$40,$40,$40,$40,$5f,$4c,$40,$5e,$40,$40,$40,$40 
;character_bitmap_row1   ;80 Bytes 
;    .byt  $5e,$7e,$5e,$7e,$5e,$50,$72,$7e,$40,$40,$5a,$58,$76,$7e,$5e,$7e 
;    .byt  $7e,$7e,$5e,$7e,$72,$72,$6a,$72,$72,$7e,$66,$72,$66,$66,$70,$70 
;    .byt  $60,$72,$5c,$5c,$72,$5c,$7e,$66,$72,$72,$72,$72,$70,$5c,$72,$72 
;    .byt  $6a,$72,$72,$74,$5c,$66,$66,$6c,$60,$60,$66,$72,$72,$72,$72,$72 
;    .byt  $5c,$68,$58,$4c,$40,$40,$4c,$4c,$53,$46,$40,$66,$40,$40,$40,$40 
;character_bitmap_row2   ;80 Bytes 
;    .byt  $66,$66,$66,$66,$66,$7e,$7e,$66,$58,$4c,$5c,$58,$7e,$66,$72,$72 
;    .byt  $72,$70,$78,$5c,$72,$72,$6a,$5e,$72,$6c,$7e,$7e,$60,$66,$7e,$7e 
;    .byt  $6e,$7e,$5c,$5c,$7c,$5c,$6a,$66,$72,$72,$72,$7c,$7e,$5c,$72,$72 
;    .byt  $6a,$5c,$7e,$48,$5c,$5c,$5e,$6c,$7e,$7e,$4c,$7e,$7e,$72,$5e,$4e 
;    .byt  $48,$7e,$58,$4c,$40,$40,$40,$40,$7c,$40,$7e,$60,$40,$40,$40,$40 
;character_bitmap_row3   ;80 Bytes 
;    .byt  $66,$66,$60,$66,$78,$5c,$46,$66,$58,$4c,$56,$58,$6a,$66,$72,$7e 
;    .byt  $7e,$70,$4e,$5c,$72,$5c,$7e,$7c,$7e,$5a,$66,$72,$66,$66,$70,$70 
;    .byt  $66,$72,$5c,$5c,$66,$5c,$6a,$66,$72,$7e,$72,$66,$46,$5c,$72,$5c 
;    .byt  $7e,$66,$5c,$56,$5c,$72,$66,$7e,$46,$66,$4c,$66,$46,$72,$72,$40 
;    .byt  $40,$4a,$58,$4c,$4c,$4c,$4c,$4c,$53,$40,$40,$7e,$40,$40,$40,$40 
;character_bitmap_row4   ;80 Bytes 
;    .byt  $7f,$7e,$7e,$7e,$7e,$5c,$7e,$66,$58,$5c,$56,$58,$6a,$66,$7e,$70 
;    .byt  $46,$70,$7c,$5c,$7e,$48,$5c,$66,$46,$7e,$66,$7e,$7e,$7e,$7e,$70 
;    .byt  $7e,$72,$5c,$7c,$66,$5e,$6a,$66,$7e,$70,$7f,$66,$7e,$5c,$7e,$48 
;    .byt  $5c,$66,$5c,$7e,$5c,$5e,$7e,$4c,$7e,$7e,$58,$7e,$7e,$7e,$7e,$4c 
;    .byt  $48,$7e,$5c,$5c,$4c,$46,$46,$40,$5f,$40,$40,$44,$40,$40,$40,$40 

; NEW version
character_bitmap_row0   ;80 Bytes 
    .byt $40,$70,$40,$46,$40,$5c,$7e,$70,$58,$4c,$58,$58,$40,$40,$40,$40 
    .byt $40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$7e,$7e,$7e,$7e,$7e,$7e 
    .byt $7e,$72,$5c,$5c,$72,$5c,$7e,$7e,$7e,$7e,$7e,$7e,$7e,$7e,$72,$72 
    .byt $6a,$72,$72,$7e,$7c,%01111110   ;$7c 
    .byt $7e,$7c,$7e,$7e,$7e,$7e,$7e,$7e,$58,$7e 
    .byt $5c,$7e,$5c,$5c,$40,$40,$40,$40,$5f,$4c,$40,$5e,$40,$40,$40,$40 
character_bitmap_row1   ;80 Bytes 
    .byt $5e,$7e,$5e,$7e,$5e,$50,$72,$7e,$40,$40,$5a,$58,$76,$7e,$5e,$7e 
    .byt $7e,$7e,$5e,$7e,$72,$72,$6a,$72,$72,$7e,$66,$72,$66,$66,$70,$70 
    .byt $60,$72,$5c,$5c,$72,$5c,$7e,$66,$72,$72,$72,$72,$70,$5c,$72,$72 
    .byt $6a,$72,$72,$74,$5c,%01000010   ;$66 
    .byt $66,$6c,$60,$60,$66,$72,$72,$72,$72,$72 
    .byt  $5c,$68,$58,$4c,$40,$40,$4c,$4c,$53,$46,$40,$66,$7e,$40,$40,$40 
character_bitmap_row2   ;80 Bytes 
    .byt $66,$66,$66,$66,$66,$7e,$7e,$66,$58,$4c,$5c,$58,$7e,$66,$72,$72 
    .byt $72,$70,$78,$5c,$72,$72,$6a,$5e,$72,$6c,$7e,$7e,$60,$66,$7e,$7e 
    .byt $6e,$7e,$5c,$5c,$7c,$5c,$6a,$66,$72,$72,$72,$7c,$7e,$5c,$72,$72 
    .byt $6a,$5c,$7e,$48,$5c,%01111110   ;$5c 
    .byt $5e,$6c,$7e,$7e,$4c,$7e,$7e,$72,$5e,$4e 
    .byt $48,$7e,$58,$4c,$40,$40,$40,$40,$7c,$40,$7e,$60,$40,$40,$40,$40 
character_bitmap_row3   ;80 Bytes 
    .byt $66,$66,$60,$66,$78,$5c,$46,$66,$58,$4c,$56,$58,$6a,$66,$72,$7e 
    .byt $7e,$70,$4e,$5c,$72,$5c,$7e,$7c,$7e,$5a,$66,$72,$66,$66,$70,$70 
    .byt $66,$72,$5c,$5c,$66,$5c,$6a,$66,$72,$7e,$72,$66,$46,$5c,$72,$5c 
    .byt $7e,$66,$5c,$56,$5c,%01110000   ;$72 
    .byt $66,$7e,$46,$66,$4c,$66,$46,$72,$72,$40 
    .byt $40,$4a,$58,$4c,$4c,$4c,$4c,$4c,$53,$40,$40,$7e,$7e,$40,$40,$40 
character_bitmap_row4   ;80 Bytes 
    .byt $7f,$7e,$7e,$7e,$7e,$5c,$7e,$66,$58,$5c,$56,$58,$6a,$66,$7e,$70 
    .byt $46,$70,$7c,$5c,$7e,$48,$5c,$66,$46,$7e,$66,$7e,$7e,$7e,$7e,$70 
    .byt $7e,$72,$5c,$7c,$66,$5e,$6a,$66,$7e,$70,$7f,$66,$7e,$5c,$7e,$48 
    .byt $5c,$66,$5c,$7e,$5c,%01111110   ;$5e 
    .byt $7e,$4c,$7e,$7e,$58,$7e,$7e,$7e,$7e,$4c 
    .byt $48,$7e,$5c,$5c,$4c,$46,$46,$40,$5f,$40,$40,$44,$40,$40,$40,$40


colour_0 
 .byt 0 
colour_1 
 .byt 0 




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Twilighte's IRQ routine!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; key read and timer irq 
#define        via_portb                $0300 
#define        via_t1cl                $0304 
#define        via_t1ch                $0305 
#define        via_t1ll                $0306 
#define        via_t1lh                $0307 
#define        via_t2ll                $0308 
#define        via_t2ch                $0309 
#define        via_sr                  $030A 
#define        via_acr                 $030b 
#define        via_pcr                 $030c 
#define        via_ifr                 $030D 
#define        via_ier                 $030E 
#define        via_porta               $030f 


.zero
irq_A               .byt 0
irq_X               .byt 0
irq_Y               .byt 0
TimerCounter        .byt 40        ;Slows key read to 25Hz 
KeyCode             .dsb 1        ;The keycode 
.text 

_init_irq_routine 
        ;Since we are starting from when the standard irq has already been 
        ;setup, we need not worry about ensuring one irq event and/or right 
        ;timer period, only redirecting irq vector to our own irq handler. 
        sei
        lda #<irq_routine 
        ;sta $0245        ;When we disable rom, we should change this to $fffe 
        sta $fffe
        lda #>irq_routine 
        ;sta $0246        ;When we disable rom, we should change this to $ffff 
        sta $ffff

        ;Turn off music and sfx
    	lda #128
    	sta MusicStatus
    	sta EffectNumber
    	sta EffectNumber+1
    	sta EffectNumber+2

        cli 
        rts 

;The IRQ routine will run (Like Oric) at 100Hz. 
irq_routine 

        ;Preserve registers 
      	sta irq_A
    	stx irq_X
    	sty irq_Y

        ;Protect against Decimal mode 
        cld 

        ;Clear IRQ event 
        lda via_t1cl 

    	;Process Music
    	jsr ProcMusic
    	;Process Effects
    	jsr ProcEffect

        ;Process timer event 
        dec TimerCounter 
.( 
        lda TimerCounter 
        and #3        ;Essentially, every 4th irq, call key read 
        bne skip1 
        ;Process keyboard 
        jsr proc_keyboard 

skip1        ;Process controller (Joysticks) 
.) 
;        jsr proc_controller 


        ;Send Sound Bank 
;        jsr send_ay 

        ;Restore Registers 
        lda irq_A
    	ldx irq_X
    	ldy irq_Y

        ;End of IRQ 
        rti 

proc_keyboard 
        ;Setup ay to point to column register 
        ;Note that the write to the column register cannot simply be permanent 
        ;(Which would reduce amount of code) because some orics freeze(crash). 
        lda #$0E        ;AY Column register 
        sta via_porta 
        lda #$FF 
        sta via_pcr 
        ldy #$dd 
        sty via_pcr 

        ;Scan for 9 Keys (0-8) 
        ldx #08 
.( 
loop1 
        lda KeyColumn,x 
        sta via_porta 
        lda #$fd 
        sta via_pcr 
        sty via_pcr 

        lda via_portb
	    and #%11111000
    	ora KeyRow,x
        sta via_portb

        ;Whilst not needed on Euphoric, this time delay is required for 
        ;some Real Orics otherwise no key will be returned! 
        ;We should use this time for something else if given an oppertunity 
        nop 
        nop 
        nop 
        nop 
        ;jsr tempo
        lda via_portb 
        and #08 
        bne skip1 
        dex 
        bpl loop1 
        lda #00 
        sta KeyCode 
        rts 
skip1   inx 
.) 
        stx KeyCode 
        rts 

;tempo	jsr tempo1
;tempo1 rts

;Row and column tables for Z,X,M,B,T,-,=,CTRL and ESC 
KeyRow 
 .byt 2,0,2,2,1,3,7,2,1 
KeyColumn 
 .byt $df,$bf,$fe,$fb,$fd,$f7,$7f,$ef,$df

oldkey .byt 0
; Gets key, no repeating
unrep_key
.(
    ldx KeyCode
    stx oldkey
loop
    ldx KeyCode
    bne cont
    stx oldkey
    beq loop
cont
    cpx oldkey
    beq loop
   
    stx oldkey
    rts
.)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Lift management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;lift_destinations .byt 13,67,48,54,76
lift_destinations .byt 194,97,26,3
cur_sel .byt 0
get_destination
.(
    lda #LO(lift_speech)
    ldx #HI(lift_speech)
    jsr printnl
    ;lda #0
    lda current_level
    sta cur_sel
    ;lda KeyCode
    ;sta oldkey
    jsr print_fsel

loop    
    jsr unrep_key

    cpx #3
    bne not_up
    lda cur_sel
    cmp #3 ;#4
    ;beq loop
    bne up
    ; Roll back
    lda #0
    sta cur_sel
    jsr print_fsel
    jmp loop
up
    inc cur_sel
    jsr print_fsel
    jmp loop    
not_up
    cpx #4
    bne not_down
    lda cur_sel
    ;beq loop
    bne down
    ; Roll back
    lda #3
    sta cur_sel
    jsr print_fsel
    jmp loop
down
    dec cur_sel
    jsr print_fsel
    jmp loop    
not_down
    cpx #8
    bne loop

    ; Get to the destination room
    jsr perform_CRLF
    ldx cur_sel
    stx current_level
    lda lift_destinations,x
    rts
exit
    lda _current_room
    rts
.)

;print_fsel
;.(
;    lda cur_sel
;    clc
;    adc #49
;    jsr ascii2code
;    jsr put_char_direct
;    rts
;.)


floor_tblHI .byt >(levelH_name),>(levelG_name),>(levelCTRL_name),>(levelMM_name)
floor_tblLO .byt <(levelH_name),<(levelG_name),<(levelCTRL_name),<(levelMM_name)

print_fsel
.(
    lda #MENUCHG
    jsr PlayAudio  

    lda Cursor_origin_y
    sta resY+1
    lda Cursor_origin_x
    sta resX+1

    ldy cur_sel
    ldx floor_tblHI,y
    lda floor_tblLO,y
    jsr print

resY
    ldy #00
resX
    ldx #00
    jmp relocate_cursor ; This is JSR/RTS
.)

_hook_lifts
.(
    lda _hero
    asl
    asl
    tax
    ;inx
    lda #5+1
    sta _characters+1,x


    ; Get to the destination room
    jsr get_destination
    sta _current_room
    lda _hero
    asl
    asl
    tax
    lda _current_room
    sta _moving_chars,x

; Gets hero direction

    lda _moving_chars+2,x
   	;and #%01111111 ; Remove flag
    ;cmp #NORTH

    ; If direction is not zero, then we are
    ; stepping backwards and probably have bit7 set
    ; and direction==NORTH!
    bne dontturn
    
    jsr twoturns 

dontturn
    ; sfx for lift
    lda #LIFT_START
    jsr PlayAudio

    ; Note down sfx is playing
    lda Flags3
    ora #%01000000
    sta Flags3

    rts
.)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Code for infopost texts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

menu_sel .byt $00
infopost_menu
.(
    jsr clr_textarea

    jsr infopost_title

    lda #TRACK_1_ON
    jsr PlayAudioTrack

    lda #<(infopost_menu_msg)
    ldx #>(infopost_menu_msg)
    jsr print

    lda #0
    sta menu_sel
    ;lda KeyCode
    ;sta oldkey
    jsr highlight_menu_option

loop
    jsr unrep_key

    cpx #3
    bne not_up
    lda menu_sel
    cmp #7
    beq loop
    
    lda #MENUCHG
    jsr PlayAudio    

    inc menu_sel
    jsr highlight_menu_option
    jmp loop    
not_up
    cpx #4
    bne not_down
    lda menu_sel
    beq loop


    lda #MENUCHG
    jsr PlayAudio    

    dec menu_sel
    jsr highlight_menu_option
    jmp loop    
not_down
    cpx #8
    bne loop

    lda #MENUSEL
    jsr PlayAudio    

    ; Wait untill effect stops

    ldx #2
wait
   	ldy EffectNumber,x
	bpl wait

    jsr clr_textarea
    
    ; Perform menu action        

    jmp perform_menu_action

.)


perform_menu_action
.(
    ldx menu_sel
    lda tab_action_lo,x
    sta dest+1
    lda tab_action_hi,x
    sta dest+2
dest
    jsr $dead

    jmp StopAudioTrack ; This is jsr/rts
.)


sound_sel .byt 3
sound_values .byt 15, 10, 5, 0
sound_menu
.(
    lda #LO(sound_menu_txt)
    ldx #HI(sound_menu_txt)
    jsr printnl
    
;    lda MaximumVolume
;    ldx #3
;loop1
;    cmp sound_values,x    
;    beq found
;    dex
;    bpl loop1
;    
;    ldx #0
;found
;    stx sound_sel    
    jsr print_ssel

loop    
    jsr unrep_key

    cpx #3
    bne not_up
    lda sound_sel
    cmp #3 ;#4
    ;beq loop
    bne up
    ; Roll back
    lda #0
    sta sound_sel
    jsr print_ssel
    jmp loop
up
    inc sound_sel
    jsr print_ssel
    jmp loop    
not_up
    cpx #4
    bne not_down
    lda sound_sel
    ;beq loop
    bne down
    ; Roll back
    lda #3
    sta sound_sel
    jsr print_ssel
    jmp loop
down
    dec sound_sel
    jsr print_ssel
    jmp loop    
not_down
    cpx #8
    bne loop

    ; Set volume
    jsr perform_CRLF

    ;lda #MENUSEL
    ;jsr PlayAudio  

    ldx sound_sel
    lda sound_values,x
    sta MaximumVolume

    ; Back to menu    
    jmp infopost_menu
.)


volume_tblHI .byt >(sound_off_name),>(sound_low_name),>(sound_med_name),>(sound_high_name)
volume_tblLO .byt <(sound_off_name),<(sound_low_name),<(sound_med_name),<(sound_high_name)

print_ssel
.(
    lda #MENUCHG
    jsr PlayAudio  

    lda Cursor_origin_y
    sta resY+1
    lda Cursor_origin_x
    sta resX+1

    ldy sound_sel
    ldx volume_tblHI,y
    lda volume_tblLO,y
    jsr print

resY
    ldy #00
resX
    ldx #00
    jmp relocate_cursor ; This is JSR/RTS
.)




exit
    jsr StopAudioTrack
    rts

; Infpost menu actions table

tab_action_lo 
    .byt <(save_game), <(restore_game), <(alpha_status), <(print_cinema), <(print_passcodes), <(sound_menu), <print_progress, <exit
tab_action_hi 
    .byt >save_game, >restore_game, >alpha_status, >print_cinema, >print_passcodes, >sound_menu, >print_progress, >exit


tab_attr_posl .byt $09,$f9,$e9,$d9, $1d,$0d,$fd,$ed
tab_attr_posh .byt $bb,$bb,$bc,$bd, $bb,$bc,$bc,$bd

#define A_BGBLACK       16
#define A_BGRED         17
#define A_BGGREEN       18
#define A_BGYELLOW      19
#define A_BGBLUE        20
#define A_BGMAGENTA     21
#define A_BGCYAN        22
#define A_BGWHITE       23

highlight_menu_option
.(
    ldx #7
   
loop

    lda tab_attr_posl,x
    sta dest+1

    lda tab_attr_posh,x
    sta dest+2 
   
    cpx menu_sel
    beq highlight

    txa
    and #%11
    cmp #%11
    bne normal
    ldy #240
    bne cont
normal
    ldy #200
cont
    lda #A_BGBLACK

    bne putit
highlight
    lda #A_BGBLUE
    ldy #240
putit
    
loop_attr
dest
    sta $1234,y   
    pha 
    tya
    sec
    sbc #40
    tay
    pla
    bcs loop_attr

    dex
    bpl loop

    rts
.)


#ifdef SAVE_IRQ
sav_irq .word $0000
#endif

reboot_oric
.(
    ;jsr _switch_ovl

    lda $0314
    and #%01111101
    sta $0314
    
#ifdef SAVE_IRQ
    lda sav_irq
    lda $fffe
    lda sav_irq+1
    sta $ffff
#endif      
    ;jmp ($fffc)
    jmp $eb7e 

.)

save_game
.(
    lda #<(sure_to_save_msg)
    ldx #>(sure_to_save_msg)
    jsr printnl
    lda #<(anykey_msg)
    ldx #>(anykey_msg)
    jsr printnl

    jsr unrep_key
    cpx #8
    bne abort

    jsr StopAudioTrack

    ;jsr _switch_ovl
    ;jsr prepare_params
    ;jsr _init_disk
    ;jsr _sect_write
    jsr write2sects
    

    jsr _init_irq_routine 
    ;jsr _switch_ovl
    
    lda #<(gamesaved_msg)
    ldx #>(gamesaved_msg)
    jsr printnl
    jmp unrep_key
    
.)


abort
.(
    lda #<(abort_msg)
    ldx #>(abort_msg)
    jsr printnl
    
    ;jsr StopAudioTrack

    lda #0
    sta KeyCode

    lda #1
    rts

.)

restore_game
.(
    lda #<(sure_to_restore_msg)
    ldx #>(sure_to_restore_msg)
    jsr printnl
    lda #<(anykey_msg)
    ldx #>(anykey_msg)
    jsr printnl

    jsr unrep_key
    cpx #8
    bne abort

    jsr StopAudioTrack

    ;jsr _switch_ovl

    ; Prepare a copy in savepoint2
    lda #SAVEPOINT2_SECTOR
    sta prepare_params+1
    ;jsr prepare_params
    ;jsr _init_disk
    ;jsr _sect_write
    jsr write2sects
  
    lda #SAVEPOINT_SECTOR
    sta prepare_params+1

    ; Now load savepoint1
    ;jsr prepare_params
    ;jsr _init_disk
    ;jsr _sect_read
    jsr read2sects

    ; Test if savepoint is valid
    lda __magic 
    cmp #%11000011
    bne not_valid
    
    jsr post_restore
    
    lda #<(gamerestored_msg)
    ldx #>(gamerestored_msg)
    ;jmp getback
    jsr printnl
    jsr unrep_key
    lda #0
    rts

not_valid
    
    lda #SAVEPOINT2_SECTOR
    sta prepare_params+1
    ;jsr prepare_params
    ;jsr _init_disk
    ;jsr _sect_read
    jsr read2sects

    lda #SAVEPOINT_SECTOR
    sta prepare_params+1

    jsr post_restore

    lda #<(invalidsave_msg)
    ldx #>(invalidsave_msg)
;getback
    jsr printnl
    jsr unrep_key
    lda #1
    rts


.)


; Routine to increment disk reading/writting parameters
inc_disk_params
.(

    ; Increment address in 256 bytes
    ldy #3
    lda (sp),y
    clc
    adc #1
    sta (sp),y

    ; Increment sector to read
    ldy #0
    lda (sp),y
    clc
    adc #1
    sta (sp),y
    iny
    lda (sp),y
    adc #0
    sta (sp),y

    rts

.)



read2sects
.(
    jsr prepare_params
    jsr _init_disk
    jsr _sect_read
    jsr inc_disk_params
    jmp _sect_read ; This is jsr/rts

.)

write2sects
.(
    jsr prepare_params
    jsr _init_disk
    jsr _sect_write
    jsr inc_disk_params
    jmp _sect_write ; This is jsr/rts
.)

post_restore
.(
    ;jsr _switch_ovl
    jsr _init_irq_routine 
    jsr _init_game
    jmp clr_textarea 
.)

prepare_params
.(
    ; Sector to read/write    
    lda #SAVEPOINT_SECTOR
    ldy #0
    sta (sp),y
    tya
    iny
    sta (sp),y

    ; Address of buffer
    iny
    lda #<(__savegame_data_start)
    sta (sp),y
    lda #>(__savegame_data_start)
    iny
    sta (sp),y
    
    rts
.)


infopost_title
.(
    lda #<(infopost_start)
    ldx #>(infopost_start)
    jmp printnl ; This is jsr/rts

.)

cinema_tbl
    .word tv_1_msg
    .word tv_2_msg
    .word tv_3_msg
    .word tv_4_msg

print_cinema
.(

    jsr infopost_title

    lda #<(info_tv_intro)
    ldx #>(info_tv_intro)
    jsr printnl

    jsr getrand ; This function is defined in WHITE if OWNRAND label is #defined
    and #%00000011

    asl ; word entries
    tay
    lda cinema_tbl,y
    ldx cinema_tbl+1,y
    jmp printnl
 
.)

print_passcodes
.(
    ;jsr infopost_title

    lda #1
    sta countlines


    lda _hero
    ldx #COMMLINK
    jsr is_in_invent
    bne skip1

    lda #<Commlink_name
    ldx #>Commlink_name
    jsr printnl


    ; If Helena and Koenig shared passcodes...
    lda #%01000000
    and Flags
    beq notshared

    lda #<h_general
    ldx #>h_general
    jsr printnl
    inc countlines

notshared    
    lda PasscodesK
    jsr pr_pass

skip1

    lda _hero
    ldx #HCOMMLINK
    jsr is_in_invent
    bne skip2

    jsr key2cont

    lda #1
    sta countlines

    lda #<CommlinkH_name
    ldx #>CommlinkH_name
    jsr printnl

    ; If Helena and Koenig shared passcodes...
    lda #%01000000
    and Flags
    beq notshared2

    lda #<k_general
    ldx #>k_general
    jsr printnl
    inc countlines

notshared2    

    lda PasscodesR
    jsr pr_pass

skip2
    rts
.)


pr_pass
.(
    ; Save pascodes mask
    sta loop+1
 
    ; Passcodes not in passcode byte
    lda #%10000000
    and Flags
    beq notPaul
    lda #<morrow_qtr
    ldx #>morrow_qtr
    jsr printnl
    inc countlines
 
notPaul
    lda #%00100000
    and Flags
    beq notBenes
    lda #<benes_qtr
    ldx #>benes_qtr
    jsr printnl
    inc countlines

    lda countlines
    cmp #4
    bne notBenes

    lda #0
    sta countlines
    jsr key2cont


notBenes

    ; Search for passcode
    ldx #SIZE_PASS_TABLE
loop
    lda #$00 ; Self-modifiying code
    and passcode_bitmasks-1,x
    beq not_this
    
    ; Passcode found!
    txa
    pha

    lda passcode_names_lo-1,x
    tay
    lda passcode_names_hi-1,x
    tax
    tya
    jsr printnl 

    inc countlines

    lda countlines
    cmp #4
    bne notclr

    lda #0
    sta countlines
    jsr key2cont

notclr
    pla
    tax


not_this

    dex
    bne loop     

    rts

.)

countlines
   .byt 0


alpha_status
.(

    jsr infopost_title

    jsr printAlphaPower
    jsr printAlphaLS

    rts
.)


; Prints num in reg A (00-99)
printnum
.(
    ldx #0
    sec
loop
    inx
    sbc #10
    bcs loop
    dex

    adc #(10+48)
    pha
    txa
    clc
    adc #48   
    jsr put_char
    pla
    jsr put_char
    rts
    
.)

; Prints Alpha power status
printAlphaPower
.(
    lda #<(infopower_msg)
    ldx #>(infopower_msg)

    jsr print

    lda _Alpha_power
    jsr printpercent

    jsr perform_CRLF

    rts
.)

; Prints Alpha power status
printAlphaLS
.(
    lda #<(infols_msg)
    ldx #>(infols_msg)

    jsr print

    lda _Alpha_lifesup
    jsr printpercent

    jsr perform_CRLF

    rts
.)


printpercent
.(
    cmp #100
    beq print100
    
    jsr printnum
    jmp printend
print100
    lda #<(hundred_msg)
    ldx #>(hundred_msg)
    jsr print
printend    
    lda #<(percent_msg)
    ldx #>(percent_msg)
    jsr print
    
    rts
.)


print_progress
.(
    lda #<(infoprogress_msg)
    ldx #>(infoprogress_msg)

    jsr print

    lda _progress
    
    ; Multiply by 10
    asl ; 2a
    sta twotimes+1
    asl ; 4a
    asl ; 8a
    clc
twotimes
    adc #0  ; Self modifying code 8a + 2a = 10a
        
    jsr printpercent
    jsr perform_CRLF
    rts

.)



;;;;;;;;;;;;;;; Printing room names ;;;;;;;;;;;;;;;
; Prints room name of current room
print_room_name
.(

    lda Cursor_origin_x
    sta save_x+1
    lda Cursor_origin_y
    sta save_y+1

    ldx #72
    ldy #159
    jsr relocate_cursor
    
    jsr search_room_name
    beq found
    lda #<(corridor_name)
    ldx #>(corridor_name)
found
    jsr printnl 
save_x
    ldx #0
save_y
    ldy #0

    jmp relocate_cursor ; This is jsr/rts
    
.)

search_room_name
.(
  	;; Start searching for the room
    lda #<room_names
	sta tmp0
    lda #>room_names
	sta tmp0+1


loop_names
	ldy #0
	lda (tmp0),y	; Get size of entry
    cmp #0          ; A zero entry marks end
    beq not_found
    sta tmp

    ; Get string pointer
    iny
    lda (tmp0),y
    sta tmp1
    iny
    lda (tmp0),y
    sta tmp1+1
    iny
    
loop_rooms
    lda (tmp0),y
room_id
    cmp _current_room
	beq	found
    bcs next ; Can't be here, as entries are ordered

    iny
    cpy tmp
    bne loop_rooms

next
    ; Not found in this entry
	lda tmp	; Get bytes up to next entry
	clc
	adc tmp0
	sta tmp0
	bcc no_inc
	inc tmp0+1
no_inc
	jmp loop_names

found	
    lda tmp1
    ldx tmp1+1
    ldy #0
    rts
not_found
    lda #1
	rts


.)

room_names
.byt 4 ; Size
.word main_mission_name
.byt 1

.byt 4 
.word command_room_name
.byt 2
 
.byt 4
.word koenig_quart_name
.byt 112

.byt 4
.word russel_quart_name
.byt 144

.byt 4
.word benes_quart_name
.byt 160

.byt 4
.word bergman_quart_name
.byt 128

.byt 4
.word morrow_quart_name
.byt 176

.byt 4
.word hisec_name
.byt 183

.byt 5
.word life_support_name
.byt 40,56

.byt 5
.word meds_lab_name
.byt 197,198

.byt 5
.word astro_name
.byt 243,244

.byt 5
.word power_name
.byt 41,57

.byt 6
.word security_name
.byt 4,20,42

.byt 6
.word computer_name
.byt 12,27,28

.byt 6
.word storage_name
.byt 224,225,226

.byt 7
.word chem_lab_name
.byt 179,180,181,182

.byt 7
.word research_name
.byt 212,213,214,215

.byt 8
.word meds_name
.byt 101,102,104,105,121

.byt 8
.word dining_name
.byt 192,193,208,209,210

.byt 9
.word quarters_name
.byt 23,39,114,130,146,162

.byt 11
.word lounge_name
.byt 0,18,32,80,100,119,120,178

.byt 16
.word leisure_name
.byt 36,37,48,39,50,52,53,64,65,66,83,84,85

.byt 16
.word hydroponics_name
.byt 116,117,118,131,132,133,135,147,148,149,151,152,153

.byt 0 ; End




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; GAME LOGIC CODE ;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reactions to CTRL over SPECIAL tiles
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Interactions with objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Tiles

door_control
.(

    ;lda Flags
    ;and #%00001000  ; Can we toggle chars? (0 if we can)
    ;beq useit

    ;lda #<notnow_msg
    ;ldx #>notnow_msg

    ;jmp printnl ; this is jsr/rts

    ; Check if you have the passcode

    lda #%01000000
    jsr check_passwd
    bne useit
    
    lda #<need_pass
    ldx #>need_pass
    jmp printnl ; This is jsr/rts

useit
    lda Flags2
    and #%00000001 ; Get door control bit
    beq openit ; Is  not already open
    rts
 
openit   
    ; Mark as open
    lda Flags2
    ora #%00000001
    sta Flags2

    ; Play sfx
    lda #ALARM
    jsr PlayAudio

    ; Start timer
    lda #T_DOOR_VAL
    sta _timer+4
    
    ; Tell the player   
    lda #< door_ctrlo_msg
    ldx #> door_ctrlo_msg
    jmp printnl ; This is jsr/rts

.)



lock_door
.(
    ; Time expired, lock door
    lda Flags2
    and #%11111110
    sta Flags2

    ; Stop sfx
    lda #ALARM_OFF
    jsr PlayAudio


    ;If in correct room, tell the player
    lda _current_room
    cmp #183    ; Hi-sec room
    bne end

    lda #< door_ctrlc_msg
    ldx #> door_ctrlc_msg
    jsr printnl


end
    rts
.)


pauls_list
.(
    ; Note down we have seen the circuit
    lda Flags3
    ora #%00000100
    sta Flags3
    
    lda #< pauls_list_msg
    ldx #> pauls_list_msg
    jsr printnl
    
    ;jsr partial_success

    jmp key2cont ; This is jsr/rts
.)

; Free objects (characters)
;addpush
;.(
;    sta push_me+1
;    ldy #0
;    lda (sp),y
;    sta push_me
;    rts
;.)


cure_koenig
.(
    ; Helena cures Koenig with medkit
    lda Koenig_Flags
    and #%11110000
    ora #%00001010
    sta Koenig_Flags

    ldx #1
    lda #10
    jsr PlotLifeBar 
    
    lda #<(cure_koenig_msg)
    ldx #>(cure_koenig_msg)
    jmp printnl ; This is jsr/rts
.)

cure_helena
.(
    ; Koenig does not know how to use medkit
    lda #<(dont_know_msg)
    ldx #>(dont_know_msg)
    jmp printnl ; This is jsr/rts


.)


; Helper that makes a tune sound for some seconds after
; a partial problem solved
partial_success
.(
    ; Another 10% 
    inc _progress

    ; Make tune sound
    lda #TRACK_4_ON
    jsr PlayAudioTrack

    ; Reflect that tune is sounding
    lda Flags3
    ora #%00100000
    sta Flags3
    
    ; Start a timer so it stops music after 16 secs
    lda #16+1
    sta _timer+5
    rts

.)


; Control of music tracks


SilenceAll 
.(
    lda #128 
    sta MusicStatus 
    lda #00 
    sta AY_Volume 
    sta AY_Volume+1 
    sta AY_Volume+2 
    jmp SendAY ; This is jsr/rts
.)


PlayAudioTrack
.(
    pha
    
    ; Stop ambient on channel A
    lda #%00000001
    jsr PlayAudio

    ; Wait until it finishes
    ldx #0
wait
   	ldy EffectNumber,x
	bpl wait

    ; Stop ambient on channel B (Alarms)
    lda #%00000010
    jsr PlayAudio

    ; Wait until it finishes
    ldx #1
wait2
   	ldy EffectNumber,x
	bpl wait2

    pla
    jmp PlayAudio ; This is jsr/rts
.)


; Table for ambients. Entries are <roomID,sfx_code>
#define AMBIENT_ENTRIES 14
table_ambients
    .byt 1, BEEPS2
    .byt 2, BEEPS2
    .byt 105, BEEPS2    
    .byt 121, BEEPS2
    .byt 197, BEEPS2
    .byt 198, BEEPS2
    .byt 243, BEEPS2
    .byt 12, BEEPS1
    .byt 28, BEEPS1
    .byt 27, BEEPS1
    .byt 40, BEEPS1
    .byt 41, BEEPS1
    .byt 56, BEEPS1
    .byt 57, BEEPS1

StopAudioTrack
.(
    jsr SilenceAll
    ;jmp room_ambient ; This is jsr/rts

.)

; Things for ambient sounds in rooms
; Keep these two together, or uncomment the jmp above

; Set the room ambient
room_ambient
.(
    ; Is there a soundtrack playing?
    lda Flags3
    and #%00100000
    bne end

    ; If there is a general alarm, keep it
    lda Flags3
    and #%10000
    beq no_alarm


    ; If there is something on channel A (alarms & music)
    ; skip
    ldx #0
    lda EffectNumber,x
    bpl already_playing
    
    lda #ALARMPWR
    jsr PlayAudio    

already_playing
    
    ;jmp end

no_alarm

    ; Search in the table
    ldx #(AMBIENT_ENTRIES*2-1)
loop
    lda table_ambients,x
    cmp _current_room
    bne notfound

    lda table_ambients+1,x
    jmp PlayAudio ; This is jsr/rts

notfound
    dex
    bpl loop

    ; Stop effect
    lda #%00000010
    jsr PlayAudio

end
    rts
.)



; Code dependant of level

;;;;;;;;;;;;;; Interactions with tiles

__level_code_start

; Getting plantjuice
get_plant
.(
    lda Flags2
    and #%00010000
    beq takeit
    lda #<(plant_taken_msg)
    ldx #>(plant_taken_msg)
    jmp printnl ; This is jsr/rts

takeit
    lda Flags2
    ora #%00010000
    sta Flags2
    
    lda #PLANTJUICE
    sta tmp
    jsr get_object

    jsr partial_success
    
    lda #<(plant_taking_msg)
    ldx #>(plant_taking_msg)
    jmp printnl ; This is jsr/rts
.)


repair_synthesizer
.(
    lda #<(put_fuse_msg)
    ldx #>(put_fuse_msg)
    jsr printnl

    lda Flags2
    ora #%10000000
    sta Flags2

    jsr partial_success

    jmp fix_inventory   ; This is jsr/rts
.)


no_fix
.(

;    lda Flags2
;    and #%10000000
;    bne is_fixed

;    lda #<(not_fuse_msg)
;    ldx #>(not_fuse_msg)
;    jmp printnl     ; This is jsr/rts

;is_fixed
    lda #<(no_medicine_msg)
    ldx #>(no_medicine_msg)
    jmp printnl ; This is jsr/rts
    

.)

prepare_medicine
.(
    ; Helena prepares the medicine to cure Benes
    ; From the alien plant juice
    
    ; for now KISS

    lda Flags2
    and #%10000000
    bne repaired

    lda #<(not_fuse_msg)
    ldx #>(not_fuse_msg)
    jmp printnl ; This is jsr/rts

repaired
    
    ; If it is not Helena, can't do it
    lda _hero
    cmp #HELENA
    beq doit

    lda #<(dont_know_msg)
    ldx #>(dont_know_msg)    
    jmp printnl ; This is jsr/rts
doit
    ; Is she carrying the notepad
    lda #HELENA
    ldx #NOTEPAD
    jsr is_in_invent
    beq doit2 
    lda #<(missing_notepad_msg)
    ldx #>(missing_notepad_msg)    
    jmp printnl ; This is jsr/rts

doit2
    ; Remove plantjuice
    jsr fix_inventory
    
    lda #COMPOUND
    sta tmp
    jsr get_object

    jsr partial_success

    lda #<(create_medicine_msg)
    ldx #>(create_medicine_msg)    
    jmp printnl ; This is jsr/rts

.)


cure_benes
.(
   ; Helena cures Benes with the medicine
    lda _hero
    cmp #HELENA
    beq doit

    lda #<(dont_know_msg)
    ldx #>(dont_know_msg)    
    jmp printnl ; This is jsr/rts
doit
    ; Remove compound
    jsr fix_inventory

    ; Change the way we interact with Benes
    lda #<(interact_Benes1)
    sta interact_Benes+1
    lda #>(interact_Benes1)
    sta interact_Benes+2

    jsr interact_Benes1

    ; Change the way we interact with Helena or Koenig
    lda #<(interact_restore_power)
    sta interact_Helena+1
    sta interact_Koenig+1
    lda #>(interact_restore_power)
    sta interact_Helena+2
    sta interact_Koenig+2

    ; Report the player new passcode in Commlock
    ; play sfx
    lda #BEEPGRL
    jsr PlayAudio

    lda #<(newpass_msg)
    ldx #>(newpass_msg)
    jsr printnl

    jsr key2cont


    ; Note that Benes told Paul's passcode
    lda Flags
    ora #%10000000
    sta Flags

    ; Note that Benes has been stabilized. Same as flag as Paul's passcode?
    lda Flags3
    ora #%00000010
    sta Flags3

    jsr partial_success

    rts

.)




place_item
.(
    jsr fix_inventory   ; remove item  

    lda #<place_item_msg
    ldx #>place_item_msg
    jsr printnl

    jsr partial_success

    lda Flags2
    and #%1110
    cmp #%1110
    bne end
    
    lda #<power_repaired_msg
    ldx #>power_repaired_msg
    jsr printnl

    jsr key2cont

    ; Remove fireballs

    ;lda #0
    ;sta _timer+2
    ;lda #100
    ;sta _Alpha_power

    lda #ENERGY_BALL
    jsr remove_ball

    lda #ENERGY_BALL2
    jsr remove_ball

    lda #ENERGY_BALL3
    jsr remove_ball

    ; Change speeches

    lda #<(interact_Benes2)
    sta interact_Benes+1
    lda #>(interact_Benes2)
    sta interact_Benes+2

    lda #<(Benes_awake)
    ldx #>(Benes_awake)
    jsr printnl

    jsr key2cont

end
    rts
.)

remove_ball
.(
    sta item+1 ; Save id
    
    ldy #0
    sta (sp),y
    jsr _white_remove_char

item
    lda #0  ; get id back (smc)
    asl
    asl
    tax
    lda #WAREHOUSE
    sta _moving_chars,x
    
    rts
.)

    
; Places a part of the power circuit
; needs a mask for the bit in Flags2
; passed in reg A.
place_part
.(
    sta Flag+1 ; Store flag

    ; Is it the correct panel?
    lda _current_room
    cmp #57
    beq cont
    lda #<wrong_panel_msg
    ldx #>wrong_panel_msg
    jmp printnl     ; This is jsr/rts
cont
    ; Have we seen the circuit at Paul's computer?
    lda Flags3
    and #%00000100
    bne can

    lda #<needcircuit_msg
    ldx #>needcircuit_msg
    jmp printnl     ; This is jsr/rts
can
    ; Ok, let's place it.
    ; First note the correspondant bit
    lda Flags2
Flag    
    ora #0 ; Self modifying code
    sta Flags2
    
    ; Now place item
    jmp place_item  ; This is jsr/rts
.)


place_ind
.(
    lda #%1000
    jmp place_part
.)

place_res
.(
    lda #%0100
    jmp place_part
.)


place_bat
.(
    lda #%0010
    jmp place_part
.)



main_circuit_check
.(

    ; Maybe tryting to fix power?
    lda _current_room
    cmp #57
    bne no_power
    
    ; CHECK IF THIS IS NOT ALREADY FIXED
    lda Flags2
    and #%1110
    cmp #%1110
    bne wrong_object
    lda #<already_fixed_msg
    ldx #>already_fixed_msg
    jmp printnl ; This is jsr/rts
wrong_object    
    ; But not the right object
    lda #<wrong_item_msg
    ldx #>wrong_item_msg
    jmp printnl ; This is jsr/rts

no_power    

    ; Trying to get chip from life support?
    cmp #56
    bne no_ls

    ; Circuit has been tampered?
    lda Flags2
    and #%01000000
    beq not_tamp
    lda #<already_fixed_msg
    ldx #>already_fixed_msg
    jmp printnl ; This is jsr/rts

not_tamp
    ; Chip not present and not tampered?
    lda Flags2
    and #%00100000
    beq chip_present
    lda #<wrong_item_msg
    ldx #>wrong_item_msg
    jmp printnl ; This is jsr/rts

chip_present
    ; CHECK IF THIS IS NOT ALREADY FIXED
    ; But not with the screwdriver
    lda #<no_screwdriver_msg
    ldx #>no_screwdriver_msg
    jmp printnl ; This is jsr/rts

no_ls

    ; Doing something with the computer chip panel
    ; CHECK IF THIS IS NOT ALREADY FIXED
    ; but not installing the chip
    lda #<burntout_chip_msg
    ldx #>burntout_chip_msg
    jmp printnl ; This is jsr/rts

end
    rts

.)

get_chip
.(
    ; Player uses the SCREWDRIVER onto the WALL CHIP panel
    lda _current_room
    cmp #56
    beq cont
    lda #<wrong_panel_msg
    ldx #>wrong_panel_msg
    jmp printnl; This is jsr/rts
   
cont
    
    ; Everything is correct... get chip
    lda #CHIP
    sta tmp
    jsr get_object
    bne end
   
    ; Success... Open life support main circuit

    lda #0
    sta _Alpha_lifesup

    lda Flags2
    ora #%100000
    sta Flags2

    ; Activate alarm!
    lda #ALARMLSA
    jsr PlayAudio

    lda #<ls_fail_msg
    ldx #>ls_fail_msg
    jmp printnl ; This is jsr/rts
 
end
    rts
.)

tamper_lifesupport
.(

    lda _current_room
    cmp #56
    beq cont
    
    lda #<wrong_panel_msg
    ldx #>wrong_panel_msg
    jmp printnl; This is jsr/rts
cont

    lda Flags2
    and #%100000
    bne next
    rts
next

    jsr fix_inventory

    lda Flags2
    ora #%1000000
    sta Flags2

    ; De-activate alarm
    lda #ALARMLSB
    jsr PlayAudio

    lda #100
    sta _Alpha_lifesup
    lda #<ls_bypassed_msg
    ldx #>ls_bypassed_msg
    jsr printnl 
    jsr key2cont 

    ; This corresponds to 20% of progress, so need to add 10% here
    inc _progress

    jmp partial_success ; This is jsr/rts

.)

place_chip
.(
    ; Player uses the CHIP onto a WALL CHIP panel
    lda _current_room
    cmp #28
    beq cont

    cmp #56
    bne badpanel

    ; Just putting it back on LS panel.

    lda Flags2
    and #%1000000
    beq nottampered
    rts

nottampered
    lda #100
    sta _Alpha_lifesup  

    jsr fix_inventory

    ; De-activate alarm
    lda #ALARMLSB
    jsr PlayAudio

    lda #<ls_back_msg
    ldx #>ls_back_msg
    jmp printnl ; This is jsr/rts
   

badpanel
    lda #<wrong_panel_msg
    ldx #>wrong_panel_msg
    jmp printnl; This is jsr/rts
    rts
cont

    ; Everything is correct... place chip and restore power!

    jsr fix_inventory

    lda #<place_chip_msg
    ldx #>place_chip_msg
    jsr printnl 

;    lda #0
;    sta _timer+2
;    lda #100
;    sta _Alpha_power

;    rts

    ; END GAME with success!!

    jsr SilenceAll

   ; Remove emergency lights if on
    lda Flags
    and #%00000100
    beq noton

    lda #A_FWWHITE
    ldy #0
    sta (sp),y
    iny
    iny
    sta (sp),y
    jsr _white_show_screen
    
noton

.)

end_sequence
.(

    ; Set Koenig and Helena at Main Mission
    ldx #0
    lda #1 ; Room ID for Main Mission
    sta _moving_chars,x ; Sets room
    
    ; Now set position in room
    lda #36+6
    sta _characters,x
    inx
    lda #30+6
    sta _characters,x
    inx
    lda #0
    sta _characters,x
    
    inx
    inx

    lda #1
    sta _moving_chars,x

    lda #30+6
    sta _characters,x
    inx
    lda #12
    sta _characters,x
    inx
    lda #0
    sta _characters,x
        
    lda #0
    tay
    sta (sp),y
    jsr _white_setPC

    ; Put them in standstill
    lda #0
    tay
    sta (sp),y
    jsr _white_standstill

    lda #1
    ldy #0
    sta (sp),y
    jsr _white_standstill

    ; Set direction for Koenig to NORTH
loop
    lda #NORTH
    ldx #2
    cmp _moving_chars,x
    beq endloop
    lda #CLOCKWISE
    ldy #2
    sta (sp),y
    lda #0
    ldy #0
    sta (sp),y
    jsr _white_turn 
    jmp loop
endloop    

    ; Set direction for Helena to SOUTH
loop2
    lda #SOUTH
    ldx #6
    cmp _moving_chars,x
    beq endloop2
    lda #CLOCKWISE
    ldy #2
    sta (sp),y
    lda #1
    ldy #0
    sta (sp),y
    jsr _white_turn 
    jmp loop2
endloop2    

    lda #<end_speech1_msg
    ldx #>end_speech1_msg
    jsr printnl

    jsr key2cont
    

    lda #<end_speech2_msg
    ldx #>end_speech2_msg
    jsr printnl

    jsr key2cont


    lda #0
    tay
    sta (sp),y
    lda #ANTICLOCKWISE
    iny
    iny
    sta (sp),y
    jsr _white_turn

    ;lda #0
    ;tay
    ;sta (sp),y
    ;jsr _white_step

    lda #<end_speech3_msg
    ldx #>end_speech3_msg
    jsr printnl

    jsr key2cont

    lda #TRACK_4_ON
    jsr PlayAudioTrack

    inc _progress
    jsr print_progress

    lda #147    ; Combo!
    ;lda #A_FWWHITE
    jsr put_code

    lda #LO(gamefinished_msg)
    ldx #HI(gamefinished_msg)
    jsr printnl
    
    jsr unrep_key
    
    jsr SilenceAll

    jmp reboot_oric


.)

;;;;; Interaction with free objects

repair
.(
    asl
    asl
    tax
    lda _moving_chars+3,x
    ora #%10000000
    sta _moving_chars+3,x

    jmp fix_inventory ; This is jsr/rts
    
.)


give_plant_helena
.(
    ; Have they talked previously?
    lda Flags
    and #%1000000
    bne cont    
    ; No, then do as if this is simply a CTRL and NOT giving the plantjuice to Helena
    jmp interact_Helena1 ; This is jsr/rts

cont
    ; Now we can toggle between chars
    ; No more commlock messages for now
    lda Flags
    and #%11100111
    sta Flags

    ; Share passcodes
    lda PasscodesK
    ora PasscodesR
    sta PasscodesK
    sta PasscodesR

    ; Change the way we interact with Helena
    lda #<interact_Helena2
    sta interact_Helena+1
    lda #>interact_Helena2
    sta interact_Helena+2

    ; Remove plantjuice from Koenig
    jsr fix_inventory
    
    ; Add it to Helena
    lda #HELENA
    sta _hero
    lda #PLANTJUICE
    sta tmp
    jsr get_object
    lda #KOENIG
    sta _hero

    jsr interact_Helena2 

    jsr  print_can_switch
    jmp key2cont    ; This is jsr/rts


    ;rts
.)


interact_Helena1
.(
    lda #<(Helena_spch_1+1)
    ldx #>(Helena_spch_1+1)
    ldy Helena_spch_1

    jsr print_speech
    
    lda Flags
    and #%1000000
    bne end
    
    lda #<(Helena_2)
    ldx #>(Helena_2)
    jsr printnl

    lda Koenig_Flags
    bpl end

    jsr key2cont

    ; play sfx
    lda #BEEPGRL
    jsr PlayAudio

    jsr perform_CRLF
    lda #<(newpass_msg)
    ldx #>(newpass_msg)
    jsr printnl

    jsr key2cont

    lda Flags
    ;eor #%01010000
    ora #%01000000
    sta Flags

    lda #<(Helena_3)
    sta msg
    lda #>(Helena_3)
    sta msg+1

end
    rts

.)


interact_Helena2
.(
    lda #<(Helena_spch_2+1)
    ldx #>(Helena_spch_2+1)
    ldy Helena_spch_2

    jmp print_speech  ; This is jsr/rts
    ;rts
    
.)


interact_Helena3
interact_Koenig1
.(
    lda #<(Koenig_spch_1+1)
    ldx #>(Koenig_spch_1+1)
    ldy Koenig_spch_1

    jmp print_speech ; This is jsr/rts
.)


interact_restore_power
.(

    lda #<(restore_power_msg+1)
    ldx #>(restore_power_msg+1)
    ldy restore_power_msg

    jmp print_speech ; This is jsr/rts

.)

interact_restore_comp
.(

    lda #<(restore_comp_msg+1)
    ldx #>(restore_comp_msg+1)
    ldy restore_comp_msg

    jmp print_speech ; This is jsr/rts

.)


interact_Benes0
.(
    lda #<(Benes_uncon)
    ldx #>(Benes_uncon)
    jmp printnl ; This is jsr/rts

.)


interact_Benes1
.(
    lda #<(Benes_intro)
    ldx #>(Benes_intro)
    jsr printnl

    jsr key2cont    

    lda #<(Benes_spch_1a+1)
    ldx #>(Benes_spch_1a+1)
    ldy Benes_spch_1a
    jsr print_speech 


    lda #<(Benes_end)
    ldx #>(Benes_end)
    jmp printnl ; This is jsr/rts

.)

interact_Benes2
.(
    lda #<(Benes_intro)
    ldx #>(Benes_intro)
    jsr printnl

    jsr key2cont    

    lda #<(Benes_spch_2+1)
    ldx #>(Benes_spch_2+1)
    ldy Benes_spch_2
    jsr print_speech 


    lda #<(Benes_end)
    ldx #>(Benes_end)
    jsr printnl 

    lda Flags
    and #%00100000
    bne end

    ; Note down we have Sandra's passcode

    lda Flags
    ora #%00100000
    sta Flags

    ; play sfx
    lda #BEEPGRL
    jsr PlayAudio


    lda #<(newpass_msg)
    ldx #>(newpass_msg)
    jsr printnl

    jsr key2cont

    ; Change the way we interact with other characters...

    lda #<(interact_restore_comp)
    sta interact_Helena+1
    sta interact_Koenig+1
    lda #>(interact_restore_comp)
    sta interact_Helena+2
    sta interact_Koenig+2

end
    rts

.)

__level_code_end


stopit .byt 0

; Scroller for init window
; 22 characters per line
; 13 lines x 5 scans per line = 65 lines
; Starting point 54,54

initscroll
.(

    lda #0
    sta KeyCode

    ldx #48-6
    ldy #54+13*5
    jsr relocate_cursor
    lda #A_FWBLACK
    jsr put_code

    ; Put codes for scroll fading
    lda #A_FWBLUE 
    sta $a000+7+(54+13*5)*40

    lda #A_FWCYAN 
    sta $a000+7+(54+13*5)*40-40

    lda #A_FWBLUE 
    sta $a000+7+60*40

    lda #A_FWCYAN 
    sta $a000+7+61*40


;    ldx #48
;    ldy #54+13*5
;    jsr relocate_cursor

text

    ldy #1
    sty lcount
    
    lda #<scroll_text+1
    sta pline
    lda #>scroll_text+1
    sta pline+1

    lda scroll_text
    sta numlines
  
    
loop
    ;lda #A_FWGREEN
    ;jsr put_code
    
    lda pline
    ldx pline+1
    jsr printnl

    txa
    sec
    adc pline
    sta pline
    bcc nocarry
    inc pline+1
nocarry    

    ldx #6
loop2
    stx savx+1
    jsr perform_scroll

    ldy #80
waitloop2
    ldx #$cf
    ;ldx #$8f
waitloop
    dex
    bne waitloop
    dey
    bne waitloop2
savx
    ldx #0
    dex
    bpl loop2
    

    ldx #48
    ldy #54+13*5
    jsr relocate_cursor

    lda stopit
    bne end

    ldy lcount
    iny
    sty lcount
    cpy numlines
    bne loop
    
    jmp text

end    
    lda #0
    sta KeyCode
    rts
.)

;pat .byt $ff

perform_scroll
.(
    lda #<$a000+60*40+8
    sta pd+1
    lda #>$a000+60*40+8
    sta pd+2

    lda #<$a000+61*40+8
    sta po+1
    lda #>$a000+61*40+8
    sta po+2

    ldy #65
looplines
    ldx #22
loopscans
;    cpy #63
;    bcc noisless
;    jsr getrand
;    ora #%11000000 
;    jmp continue
;noisless
;    lda #$ff
;continue
;    sta pat   

po
    lda $dead,x
;    and pat
pd
    sta $dead,x
    dex
    bpl loopscans

    lda KeyCode
    beq nokey
    sta stopit
nokey
    lda pd+1
    clc
    adc #40
    bcc nocarry1
    inc pd+2
nocarry1
    sta pd+1    
    
    lda po+1
    clc
    adc #40
    bcc nocarry2
    inc po+2
nocarry2
    sta po+1

    dey
    bpl looplines

    rts
.)

#echo Size of savegame data :
#print (__savegame_data_end - __savegame_data_start)
#echo


#echo Size of level code :
#print (__level_code_end - __level_code_start)
#echo



