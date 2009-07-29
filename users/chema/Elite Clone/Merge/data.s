
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


_name			.asc "Jameson"          ; Commander's name
				.byt 00 
				.dsb 24 
_shipshold		.dsb 34                 ; Contents of cargo bay
_currentplanet	.byt 7                  ; Current planet
_galaxynum		.byt 1                  ; Galaxy number (1-8)
_cash			.byt $d0,$07            ; Four bytes for cash
				.byt $00,$00
_fuel			.byt 50                 ; Amount of fuel
_fluct			.byt 0                  ; Price fluctuation
_holdspace		.word 20                ; Current space left in cargo bay
_legal_status	.byt 50                 ; Legal status 0=Clean, <50=Offender, >50=Fugitive
_score			.word 60000             ; Current score
_mission		.byt 0                  ; Current mission
_equip			.word $ffff             ; Equipment flags
_ship_type      .byt SHIP_COBRA3        ; Current player's ship


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


_dest_num		.byt 7	; So we start at LAVE 
_current_screen	.byt 0 
_docked			.byt 255 


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


; From galaxy.s

; These are filled when accessing the equip list screen

equip_items .byt 0 ; Number of possible items (for selection)
equip_flags .word 00   ; Flags with 1's when an item is available


; Some vars for loops, etc...
count2 .byt 0 ; used in genmarket & displaymarket
num .byt 0   ; used in infoplanet
index .byt 00   ; These two usedin gs_randomname
lowcase .byt 00

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


; For plotting charts

scroll .byt 0   ; Are we scrolling?

names .dsb 24
col .byt 00
row .byt 00
plotX .byt 00
plotY .byt 00


; For naming planets
; Uses a temporal seed
temp_seed .dsb 6
; Use temporal buffer for name
temp_name .dsb 9

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


; Current selection
_cur_sel .byt $ff



