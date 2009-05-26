
#include "noise_defs.h" 

#echo
#echo This is NOISE (Novel Oric ISometric Engine).
#printdef  VERSION
#echo
#echo José María Enguita
#echo 2007
#echo

#define TINYNOISE
#define SCRBUFFSAVE
#define FASTMULT

;#define EIGTHSCANS
#ifdef EIGTHSCANS
#define SCANSINBUFF 8
#define SIZ_BUFF 320
#else
#define SCANSINBUFF 6
#define SIZ_BUFF 240
#endif

__noise_start

; Files that make up the engine: 
;; groutines isofuncs auxiliar clipping collision occlusions spritemov


;; Global data:
_num_chars			.byt 0
_chars_in_room 		.dsb MAX_CHARS
_bkg_collision_list .dsb 8*4,0
_num_bkg_collisions .byt 0
_obj_collision_list .dsb 8*4,0
_num_obj_collisions .byt 0
_layers 			.dsb NUM_LAYERS*2,0
_clip_rgn			.dsb 4,0

_sizes_i			.byt 6,6,4,6,3,5,4,10
_sizes_j			.byt 6,6,6,4,3,5,4,10
_sizes_k			.byt 4,6,4,4,3,4,12,12

_init_when_setting 	.byt $ff

; char_tiles_i|j|k are defined below, but they are global


;; Library functions (global labels)
;_put_sprite 
;_put_sprite2
;_recalc_clip
;_pixel_address 
;_clear_clip_rgn
;_ij2xy
;_dodiv6 
;_set_doublebuff
;_clear_buff
;_paint_buff
;_draw_room 
;_get_tile 
;_recalc_clip
;_collision_test 
;_move_sprite 
;_init_room 

;; Also some helpers that might be useful (called from ASM)
; ij2xy
; do_div6
; pixel_address


;#echo Linking with NOISE library 0.1
.(


; Local data




#ifdef SCRBUFFSAVE

#ifdef EIGTHSCANS
+scr_buffer = $9c00
buffer_occ = scr_buffer+SIZ_BUFF
sprite_loc = buffer_occ+SIZ_BUFF

aux_buff_i = sprite_loc + SIZE_GRID*SIZE_GRID
aux_buff_j = aux_buff_i + MAX_CHARS
aux_buff_k = aux_buff_j + MAX_CHARS

double_buff= aux_buff_k + MAX_CHARS

#else
.bss
*=$200
scr_buffer .dsb SIZ_BUFF,$40
double_buff .byte $00

*=$400
buffer_occ .dsb SIZ_BUFF,$40

.text
sprite_loc .dsb SIZE_GRID*SIZE_GRID, $00

aux_buff_i .dsb MAX_CHARS, $ff
aux_buff_j .dsb MAX_CHARS, $ff
aux_buff_k .dsb MAX_CHARS, $ff


#else
+scr_buffer .dsb SIZ_BUFF,$40

; .dsb 256-(*&255)
buffer_occ .dsb SIZ_BUFF,$40
sprite_loc .dsb SIZE_GRID*SIZE_GRID, $00

aux_buff_i .dsb MAX_CHARS, $ff
aux_buff_j .dsb MAX_CHARS, $ff
aux_buff_k .dsb MAX_CHARS, $ff


double_buff .byte $00

#endif

+_char_tiles_i = aux_buff_i
+_char_tiles_j = aux_buff_j
+_char_tiles_k = aux_buff_k
