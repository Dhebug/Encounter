;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Oricium
;;         Fast Scroll game
;; -----------------------------------
;;			(c) Chema 2013
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Tile map

#include "params.h"

/*
free_before_map

.dsb 256-(*&255)
*/

.bss
*=$9800-20*256

_start_rows

__Row0
.dsb 256,$20
__Row1
.dsb 256,$20
__Row2
.dsb 256,$20
__Row3
.dsb 256,$20
__Row4
.dsb 256,$20
__Row5
.dsb 256,$20
__Row6
.dsb 256,$20
__Row7
.dsb 256,$20
__Row8
.dsb 256,$20
__Row9
.dsb 256,$20
__Row10
.dsb 256,$20
__Row11
.dsb 256,$20
__Row12
.dsb 256,$20
__Row13
.dsb 256,$20
__Row14
.dsb 256,$20
__Row15
.dsb 256,$20
__Row16
.dsb 256,$20
__Row17
.dsb 256,$20
__Row18
.dsb 256,$20
__Row19
.dsb 256,$20

_end_rows





