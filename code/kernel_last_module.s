
    .zero

_KernelZeroPageEnd  ; Modules use this to skip past kernel ZP

    .text

_KernelEndText
_ModuleStartText   ; where modules load (module's perspective)
ModuleStartText    ; alias without underscore for -t / assembly use

#if DISPLAYINFO=1
#print Kernel code size = (_KernelEndText - $0400)
#endif


; ============================================
; Fixed memory layout (shared with all modules)
; These are at fixed addresses in the 32 bytes
; of RAM between the screen and the ROM.
; ============================================

    .bss
* = $BFE0
_32_Bytes_BufferStart
_gScore                 .dsb 2         ; Current highscore for the player
_gAchievements          .dsb 7         ; Enough for 7*8=56 achievements
_gAchievementsChanged   .dsb 1         ; Set to 1 to indicate the game that the achievements have changed and need to be resaved
_gGameOverCondition     .dsb 1         ; Used to store the way the player exited the game
_gKeyboardLayout        .dsb 1         ; QWERTY / AZERTY / QWERTZ
_gMusicEnabled          .dsb 1         ; 0 or 255
_gSoundEnabled          .dsb 1         ; 0 or 255
_gJoystickType          .dsb 1         ; See enum in lib.h (0=JOYSTICK_INTERFACE_NOTHING, ijk/pase/telestrat/opel/dktronics)

; Note: These need to stay in this order
_gMonkeyKingSlowBestScoreBCD    .dsb 2
_gMonkeyKingFastBestScoreBCD    .dsb 2
_gMonkeyKingSlowSessionBest     .dsb 2
_gMonkeyKingFastSessionBest     .dsb 2
_32_Bytes_BufferRemaining
