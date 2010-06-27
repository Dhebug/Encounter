#include "ships.h"

; Tables with ship stats and collections 

__shiptables_start

;; Pointer to 3D model

ShipModelLo 
    .byt  <(MISSILE), <(ONEDOT), <(CAPSULE), <(PLATELET), <(BARREL), <(BOULDER), <(ASTEROID)
    .byt  <(SPLINTER), <(SHUTTLE), <(TRANSPORTER), <(VIPER), <(BOA), <(COBRA)
    .byt  <(PYTHON), <(ANACONDA), <(WORM), <(COBRAMK1), <(GECKO), <(KRAIT)
    .byt  <(MAMBA), <(SIDEWINDER), <(ADDER), <(MORAY), <(FERDELANCE), <(ASP)
    .byt  <(COBRA), <(PYTHON), <(BOA), <(THARGOID), <(THARGLET), <(CONSTRICTOR)
    .byt  <(COUGAR),<(ASTEROID) 

ShipModelHi 
    .byt  >(MISSILE), >(ONEDOT), >(CAPSULE), >(PLATELET), >(BARREL), >(BOULDER), >(ASTEROID)
    .byt  >(SPLINTER), >(SHUTTLE), >(TRANSPORTER), >(VIPER), >(BOA), >(COBRA)
    .byt  >(PYTHON), >(ANACONDA), >(WORM), >(COBRAMK1), >(GECKO), >(KRAIT)
    .byt  >(MAMBA), >(SIDEWINDER), >(ADDER), >(MORAY), >(FERDELANCE), >(ASP)
    .byt  >(COBRA), >(PYTHON), >(BOA), >(THARGOID), >(THARGLET), >(CONSTRICTOR)
    .byt  >(COUGAR), >(ASTEROID)    

#define SCALED
ShipSize
#ifdef SCALED
	.word 200, 25, 256, 100*4, 400, 900, 6400, 256, 2500, 2500, 3000, 3725, 4513
	.word 1151, 1398, 1400, 9801, 9801, 2073, 4900, 4225, 2500, 900, 1217
	.word 3600, 9025, 6400, 4900, 3217, 1600, 4225, 4900, 6400
#else
    .word 1576, 25, 256, 100*4, 400, 900, 6400, 256, 2500, 2500, 5625, 4273, 6382
    .word 2714, 3740, 9801, 9801, 9801, 2732, 4900, 4225, 2500, 900, 1396
    .word 3600, 9025, 6400, 4900, 5616, 1600, 4225, 4900, 6400

#endif

ShipEnergy
    .byt 2, 2, 8, 8, 8, 16, 56, 16, 32, 32, 91, 164, 98, 125, 252, 32, 81, 65, 73
    .byt 80, 73, 72, 89, 83, 109, 106, 133, 164, 253, 33, 115+140, 115, 56 

ShipMaxSpeed
    .byt 44, 20, 8, 20, 20, 30, 30, 10, 8, 10, 32, 24, 28, 20, 14, 23, 26, 30, 30
    .byt 30, 37, 24, 25, 30, 40, 28, 20, 24, 39, 30, 36, 40, 30

#define EX_DAM 3
//#define EX_DAM 0

ShipAmmo    ; bits 7-3 = Lasers, 0-2 # missiles
    .byt 0, 0,  0, 0, 0, 0, 0, 0, 0, 0
	.byt 41+(EX_DAM*8), 42+(EX_DAM*8), 36+(EX_DAM*8), 44+(EX_DAM*8)
	.byt 79+(EX_DAM*8), 24+(EX_DAM*8), 34+(EX_DAM*8), 32+(EX_DAM*8), 32+(EX_DAM*8)
	.byt 34+(EX_DAM*8), 32+(EX_DAM*8)
    .byt 33+(EX_DAM*8), 42+(EX_DAM*8), 50+(EX_DAM*8), 73+(EX_DAM*8)
	.byt 44+(EX_DAM*8), 52+(EX_DAM*8), 50+(EX_DAM*8), 56+16+(EX_DAM*8)
	.byt 32+(EX_DAM*8), 71+16+(EX_DAM*8), 71+(EX_DAM*8),0

ShipCargo   ; In tons. High nibble Cargo when scooped, low nibble = cargo carrying (?)
    .byt 0, 0, 32, 128, 0, 0, 0, 176, 15, 0, 0, 5, 3, 5, 7, 0, 3, 0, 1, 1, 0, 0, 1
    .byt 0, 0, 3, 5, 5, 0, 240, 3, 3,0


ShipKillValue
    .word $00FB, $0000, $0076, $0070, $0070, $006C, $006E, $0070, $0076, $0077, $0080
    .word $013B, $0150, $0110, $0166, $0118, $013B, $013B, $013B, $0166, $013B
    .word $0140, $01A6, $0226, $01FB, $0220, $0210, $01CB, $0390, $0107, $063B
    .word $063B, $006E

ShipLaserVertex
/*    .byt  $00, $00, $00, $00, $00, $00, $00
    .byt  $00, $00, $0c, $00, $00, $15
    .byt  $00, $0c, $00, $0a, $00, $00
    .byt  $00, $00, $00, $00, $00, $08
    .byt  $15, $00, $00, $0f, $00, $00
    .byt  $00
*/
; Missile
.byt 0
; Dot
.byt 0
; Capsule
.byt 0
; Platelet
.byt 0
; Barrel
.byt 0
; Boulder
.byt 0
; Asteroid
.byt 0
; Splinter
.byt 0
; Shuttle
.byt 0
; Transporter
.byt $0c
; Viper
.byt 0
; Boa
.byt 0
; Cobra
.byt 21
; Python
.byt 0
; Anaconda
.byt $0c
; Worm
.byt 0
; Cobra I
.byt 8 ;$0a
; Gecko
.byt 0
; Krait
.byt 0
; Mamba
.byt 0
; SideWinder
.byt 0
; Adder
.byt 0
; Moray
.byt 0
; Fer-de-Lance
.byt 0
; Asp
.byt $08
; Cobra
.byt 21
; Python
.byt 0
; Boa
.byt 0
; Thargoid
.byt $0f
; Tharglet
.byt 0
; Constrictor
.byt 0
; Cougar
.byt 0
; Hermit
.byt 0


ShipBountyLo
	.byt 0, 0, 0, 1, 1, 1, 15, 1, 0, 0, 0, 250, 200, 44, 84, 0, 75, 55, 100, 150, 100
	.byt 40, 50, 250, 194, 144, 244, 94, 244, 50, 0, 0, 15

ShipBountyHi
	.byt 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0 


__shiptables_end
    



#echo Size of ship data tables in bytes:
#print (__shiptables_end - __shiptables_start)
#echo




