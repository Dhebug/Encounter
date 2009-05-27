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
    .byt  <(COUGAR) 

ShipModelHi 
    .byt  >(MISSILE), >(ONEDOT), >(CAPSULE), >(PLATELET), >(BARREL), >(BOULDER), >(ASTEROID)
    .byt  >(SPLINTER), >(SHUTTLE), >(TRANSPORTER), >(VIPER), >(BOA), >(COBRA)
    .byt  >(PYTHON), >(ANACONDA), >(WORM), >(COBRAMK1), >(GECKO), >(KRAIT)
    .byt  >(MAMBA), >(SIDEWINDER), >(ADDER), >(MORAY), >(FERDELANCE), >(ASP)
    .byt  >(COBRA), >(PYTHON), >(BOA), >(THARGOID), >(THARGLET), >(CONSTRICTOR)
    .byt  >(COUGAR)    


ShipSize
    .word 1576, 25, 256, 100, 400, 900, 6400, 256, 2500, 2500, 5625, 4900, 9025
    .word 6400, 10000, 9801, 9801, 9801, 3600, 4900, 4225, 2500, 900, 1600
    .word 3600, 9025, 6400, 4900, 9801, 1600, 4225, 4900

ShipEnergy
    .byt 2, 2, 8, 8, 8, 16, 56, 16, 32, 32, 91, 164, 98, 125, 252, 32, 81, 65, 73
    .byt 80, 73, 72, 89, 83, 109, 106, 133, 164, 253, 33, 115, 115 


ShipMaxSpeed
    .byt 44, 16, 8, 16, 15, 30, 30, 10, 8, 10, 32, 24, 28, 20, 14, 23, 26, 30, 30
    .byt 30, 37, 24, 25, 30, 40, 28, 20, 24, 39, 30, 36, 40

ShipAmmo    ; bits 7-3 = Lasers, 0-2 # missiles
    .byt 0, 0,  0, 0, 0, 0, 0, 0, 0, 0, 41, 42, 36, 44, 79, 24, 34, 32, 32, 34, 32
    .byt 33, 42, 50, 73, 44, 52, 50, 56, 32, 71, 71

ShipCargo   ; In tons. High nibble Cargo when scooped, low nibble = cargo carrying (?)
    .byt 0, 0, 32, 128, 0, 0, 0, 176, 15, 0, 0, 5, 3, 5, 7, 0, 3, 0, 1, 1, 0, 0, 1
    .byt 0, 0, 3, 5, 5, 0, 240, 3, 3


ShipKillValue
    .word $00FB, $0000, $0076, $0070, $0070, $006C, $006E, $0070, $0076, $0077, $0080
    .word $013B, $0150, $0110, $0166, $0118, $013B, $013B, $013B, $0166, $013B
    .word $0140, $01A6, $0226, $01FB, $0220, $0210, $01CB, $0390, $0107, $063B
    .word $063B


__shiptables_end




#echo Size of ship data tables in bytes:
#print (__shiptables_end - __shiptables_start)
#echo




