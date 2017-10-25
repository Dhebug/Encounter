/*;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ------------------------------------------
;;                 OASIS
;; Oric Adventure Script Interpreting System
;; ------------------------------------------
;;	       (c) Chema 2015
;;            enguita@gmail.com
;; ------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;*/

/*
 Walk boxes and walk matix stuff

 A walk box is a structure with
 five bytes, with the corner and
 size information as follows:
 col-min, col-max, row-min, row-max
 and an additional byte with the zplane
 information and some flags:
 More than 8 zplanes are improbable, so the
 3 lsb will store this information and
 the 5 msb will be flags.
 fffffzzz
 Check if using two bytes is more efficient in the end.
 Flags indicate special boxes, as in the C64 version of
 scumm. For instance boxes at the side of the rooms, which
 are not really squared (one bitflag for each side).
 I think another flag is used to indicate that a given box
 is not walkable temporary (has disappeared)

 Walkbox bitflag: 		76543210
			   	|||||\_/
			   	||||| |
			   	||||| +- z-plane
			   	|||||
			   	||||+- free
			   	|||+- free
			   	||+- left corner
			   	|+- right corner
				+- walkable
*/

#define BOX_WALKABLE 	(1<<7)
#define BOX_RCORNER  	(1<<6)
#define BOX_LCORNER	(1<<5)

