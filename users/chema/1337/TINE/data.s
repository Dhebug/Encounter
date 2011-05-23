
#include "oobj3d/obj3d.h"
#include "tine.h"
#include "ships.h"


; Player workspace (for saving)

;unsigned char  name[32]="Jameson";      /* Commander's name */
;unsigned int   shipshold[lasttrade+1];  /* Contents of cargo bay */
;unsigned char  currentplanet;           /* Current planet */
;unsigned char  galaxynum=1;             /* Galaxy number (1-8) */
;unsigned char  cash[4]={0xd0,0x07,0,0}; /* four bytes for cash */
;unsigned char  fuel=70;                 /* Amount of fuel, can this be a byte? */    
;unsigned char  fluct;                   /* price fluctuation */
;unsigned int   holdspace=20;            /* Current space used? */
;unsigned char  legal_status=50;         /* Current legal status 0=Clean, <50=Offender, >50=Fugitive */
;unsigned int   score=60000;             /* Score. Can this be just two bytes? */
;unsigned char  mission=0;               /* Current mission */
;unsigned int   equip=0xfff;             /* Equipment flags */


; Default commander's data
_default_commander
				.asc "Jameson"          ; Commander's name
				.byt 00 
				.dsb 3 
				.dsb 17		            ; Contents of cargo bay
				.byt 7                  ; Current planet
				.byt 1                  ; Galaxy number (1-8)
				.byt $e8,$03            ; Four bytes for cash (100.0)
				.byt $00,$00
				.byt 70                 ; Amount of fuel
				.byt 0                  ; Price fluctuation
				.byt 20				    ; Current space left in cargo bay
				.byt 00                 ; Legal status 0=Clean, <50=Offender, >50=Fugitive
				.byt 00					; Score, remainder
				.word 00000             ; Current score
				.byt 0                  ; Current mission
				.word $0001             ; Equipment flags
			    .byt SHIP_COBRA3        ; Current player's ship
				.byt 3					; Number of missiles

; Stats for player's ship. Initially the basic for the ship, but may vary with equipment
				.byt 0
				.byt 0	
				.byt 0
				.byt 0
_default_commander_end


; Other player variables
_front_shield	.byt 22
_rear_shield	.byt 22
_missile_armed	.byt 0
_ptla			.byt 0
_ptsh			.byt 0


_dest_num		.byt 7	; So we start at LAVE 
_dest_dist		.word 0	; Distance to target planet
_current_screen	.byt 0 
_docked			.byt 255 
_planet_dist    .byt 255


.bss

*=(OBS-(15*MAXSHIPS)-15-MAX_RADAR_POINTS*4-MAXCOPS-(NSTARS+1)*4-104)


;Is ECM active?
_ecm_counter	.byt 0

;typedef struct
;{ char a,b,c,d;
;} fastseedtype;  /* four byte random number used for planet description */

;typedef struct
;{ int w0;
;  int w1;
;  int w2;
;} seedtype;  /* six byte random number used as seed for planets */

;typedef struct
;{	 
;   unsigned char x;
;   unsigned char y;       /* One byte unsigned */
;   unsigned char economy; /* These two are actually only 0-7  */
;   unsigned char govtype;   
;   unsigned char techlev; /* 0-16 i think */
;   unsigned char population;   /* One byte */
;   unsigned int productivity; /* Two byte */
;   unsigned int radius; /* Two byte (not used by game at all) */
;   fastseedtype	goatsoupseed;
;   char name[12];
;} plansys ;


; plansys cpl_system, hyp_system
_cpl_system		.dsb 26 
_hyp_system		.dsb 26 


;unsigned char quantities[lasttrade+1];
;unsigned int prices[lasttrade+1];

_prices			.dsb 34 
_quantities		.dsb 17 


; Variables to mantain for each space object
_rotx		.dsb MAXSHIPS
_roty		.dsb MAXSHIPS
_rotz		.dsb MAXSHIPS
_accel		.dsb MAXSHIPS
_speed		.dsb MAXSHIPS
_target		.dsb MAXSHIPS
_flags		.dsb MAXSHIPS
_ttl		.dsb MAXSHIPS
_energy		.dsb MAXSHIPS
_missiles	.dsb MAXSHIPS
_ai_state	.dsb MAXSHIPS
_vertexXLO	.dsb MAXSHIPS
_vertexXHI	.dsb MAXSHIPS
_vertexYLO	.dsb MAXSHIPS
_vertexYHI	.dsb MAXSHIPS


; Some more variables

fixed_objects		.byt 00
thargoid_counter	.byt 00
police_counter		.byt 00
asteroid_counter    .byt 00
worm_counter		.byt 00
missile_counter		.byt 00
hermit_counter		.byt 00

police_ids			.dsb MAXCOPS

; From tactics.s

;; Some variables to decouple firing and drawing the lasers
_numlasers .byt 00
_laser_source .dsb 4
_laser_target .dsb 4


;From radar.s
; To store objects for plotting the radar
radar_savX .dsb MAX_RADAR_POINTS*2
radar_savY .dsb MAX_RADAR_POINTS*2

; From stars.s

STARX    .dsb NSTARS+1
STARXREM .dsb NSTARS+1
STARY    .dsb NSTARS+1
STARYREM .dsb NSTARS+1


object_records		.dsb MAXOBJS*ObjSize

nmi_vect	.dsb 2
reset_vect  .dsb 2
irq_vect	.dsb 2

.text



; Digrams

_pairs0 .asc "ABOUSEITILETSTONLONUTHNO"
_pairs  .asc "..LEXEGEZACEBISO"
        .asc "USESARMAINDIREA."
        .asc "ERATENBERALAVETI"
        .asc "EDORQUANTEISRION" 


; Goat soup dictionary

; Call entry string
gs_init_str
        .byt $0f
        .asc " is "
        .byt $17
        .asc "."
        .byt 0


ian_str
    .asc "ian"
    .byt 0


gs_jump_lo .byt <gs_planet_name,<gs_planet_nameian,<gs_random_name
gs_jump_hi .byt >gs_planet_name,>gs_planet_nameian,>gs_random_name


#define USEPAGE4
#ifdef USEPAGE4
.bss
*=$400
#endif


__commander_data_start
_name			.asc "Jameson"          ; Commander's name (10 chars plus ending 0)
				.byt 00 
				.dsb 3 
_shipshold		.dsb 17		            ; Contents of cargo bay
_currentplanet	.byt 7                  ; Current planet
_galaxynum		.byt 1                  ; Galaxy number (1-8)
_cash			.byt $e8,$03            ; Four bytes for cash
				.byt $00,$00
_fuel			.byt 70                 ; Amount of fuel
_fluct			.byt 0                  ; Price fluctuation
_holdspace		.byt 20				    ; Current space left in cargo bay
_legal_status	.byt 00                 ; Legal status 0=Clean, <50=Offender, >50=Fugitive
_score_rem		.byt 00					; Score, remainder
_score			.word 0000              ; Current score
_mission		.byt 0                  ; Current mission
_equip			.word $0001             ; Equipment flags
_ship_type      .byt SHIP_COBRA3        ; Current player's ship
_missiles_left	.byt 3					; Number of missiles

; Stats for player's ship. Initially the basic for the ship, but may vary with equipment
_p_maxspeed		.byt 0
_p_maxenergy	.byt 0	
_p_maxmissiles	.byt 0
_p_laserdamage	.byt 0
__commander_data_end


; From galaxy.s

; Some vars for loops, etc...
count2 .byt 0 ; used in genmarket & displaymarket
num .byt 0   ; used in infoplanet
index .byt 00   ; These two usedin gs_randomname
lowcase .byt 00

; For plotting charts

scroll .byt 0   ; Are we scrolling?

names .dsb 24
col .byt 00
row .byt 00
plotX .byt 00
plotY .byt 00


; Buffer for strings, so they can be centered or justified. Main use is goatsup texts.
; The speccy version has room for 4 lines of 30 character (120 in total), AND
; performs justification of texts (which adds more spaces). I guess that is 
; a good limit for the buffer. As we print 38 characters per line we'd need 152
; bytes, but I guess 120 should be enough. 
; Also used for inflight messages.

str_buffer .dsb 120


; For naming planets
; Uses a temporal seed
temp_seed .dsb 6
; Use temporal buffer for name
temp_name .dsb 9


; For market
; Current selection
_cur_sel .byt $ff

; These are filled when accessing the equip list screen

equip_items .byt 0 ; Number of possible items (for selection)
equip_flags .word 00   ; Flags with 1's when an item is available


;From tinefuncs.s
;; Some Global Variables
;; that can be used from C

;; General coordinate variables
_VX .byt 0
_VY .byt 0
_VZ .byt 0

;; A vector definition Should be contiguous!
_VectX .byt 0,0
_VectY .byt 0,0
_VectZ .byt 0,0

;; Position of a ship Should be contiguous!
_PosX  .byt 0,0
_PosY  .byt 0,0
_PosZ  .byt 0,0


; From tactics.s
; fly_to_ship
A1   .word 0
oX   .word 0
oY   .word 0
oZ   .word 0

; AIMain
AIShipID    .byt 00 ; Current ship's ID
AIShipType  .byt 00 ; Current ship's type
AITarget    .byt 00 ; Current ship's target
AIIsAngry   .byt 00 ; Angry status (with target)

; TineLoop
frame_number		.byt 0
player_in_control	.byt 0
escape_pod_launched .byt 0
attr_changed		.byt 0
game_over			.byt 0
righton				.byt 0	

#ifdef USEPAGE4
.text
#endif



; For displaying the market
mkstrslo
    .byt <(str_mktunit)
    .byt <(str_mktquant)
    .byt <(str_mktin)
    .byt <(str_mktlist)
    .byt <(str_mktunit)
    .byt <(str_mktprice)
    .byt <(str_mktsale)
    .byt <(str_mktcargo) 
mkstrshi  
    .byt >(str_mktunit)
    .byt >(str_mktquant)
    .byt >(str_mktin)
    .byt >(str_mktlist)
    .byt >(str_mktunit)
    .byt >(str_mktprice)
    .byt >(str_mktsale)
    .byt >(str_mktcargo) 

positionsX  
    .byt 20*6, 26*6, 35*6, 2*6, 14*6, 20*6, 26*6, 35*6


#echo Commander's data:
#print (__commander_data_end - __commander_data_start)







