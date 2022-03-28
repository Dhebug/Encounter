;
; These elements are shared between the intro and the game itself
;
#define PLAY_MUSIC          // What the name says: When commented out, the music will not start until you press [S]

;
; Hardware registers
;
#define VIA_1				$30f
#define VIA_2				$30c

;
; System/ROM relevant addresses
;
#define BASIC_KEY           $2df   ; Latest key from keyboard, bit 7 set if valid

#define BASIC_FOR                   $C855  ; Location of the FOR instruction in ROM (overwritten by _Div6 and _Mod6)
#define BASIC_CIRCLE                $F37F  ; Location of the CIRCLE instruction in ROM (overwritten by _HiresAddrLow and _HiresAddrHigh)

;
; Communication between the intro and the game passes through the very last bytes of RAM before the ROM
;
#define FlagCharsetStyle    $bffd   ; If zero, will use the original charset of the game (the one in the Oric ROM)
#define FlagPlayImproved    $bffe   ; If zero, will play the non modified original version
#define FlagPlayMusic       $bfff   ; If zero, will not have any sound or music (only impact the intros so far)

;
; The Hobbit memory locations of interest
;
#define Hobbit_ComputeScreenAddress   $7A22

