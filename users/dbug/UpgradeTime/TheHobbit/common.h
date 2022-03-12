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

;
; Communication between the intro and the game passes through the very last bytes of RAM before the ROM
;
#define FlagPlayImproved    $bffe   ; If zero, will play the non modified original version
#define FlagPlayMusic       $bfff   ; If zero, will not have any sound or music (only impact the intros so far)
