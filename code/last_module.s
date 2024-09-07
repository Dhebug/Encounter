
    .zero

; Used by both the intro and the game
_param0 .dsb 2
_param1 .dsb 2
_param2 .dsb 2

    .text

_EndText

#ifdef MODULE_INTRO
_ImageBuffer2   .dsb 40*200
_OOPS2          .dsb 16       ; TOD: Apparently there's a bug in the depacking code which sometimes depacks too much
#endif
#if DISPLAYINFO=1
#print Remaining space = ($9800 - *)  
#endif

_free_to_use_text = osdk_end+1 ; *+256

    .bss

#ifdef MODULE_INTRO
* = $9800             ; STD charset for HIRES mode: 1024 bytes
_STD_Charset
#else
* = $9800             ; STD charset for HIRES mode: 1024 bytes
; Width (in pixels) of each of the 95 characters in the 12x14 font
_gFont12x14Width      .dsb 95

; Contains all the combinations of 6 pixels patterns shifted by 0 to 5 pixels to the right.
; Each entry requires two bytes, and each need to be merged to the target buffer to rebuild
; the complete shifted graphics
_gShiftBuffer         .dsb 64*2*6           ; 768 bytes
_free_to_use_9b5f     .dsb 1024-768-95
#endif

* = $9C00             ; ALT charset for HIRES mode: 1024 bytes
_free_to_use_9c00     .dsb 1024

* = $A000             ; Top of the HIRES screen: 8000 bytes
_HIRES_MEMORY_START

* = $B400             ; STD charset for TEXT mode (the 256 first bytes are not displayable)
_Attribute_TEXT       .dsb 1        ; Contains the attribute to switch to TEXT mode
_free_to_use_b401     .dsb 255

* = $B800             ; ALT charset for TEXT mode (the 256 first bytes are not displayable)
; Contains all the combination of X*40 to access specific scanlines
_gTableMulBy40Low     .dsb 128
_gTableMulBy40High    .dsb 128
_maybe_free_to_use    ; Need to check

* = $BB80             ; Top of the TEXT screen: 1120 bytes
_TEXT_MEMORY_START
_Attribute_HIRES      .dsb 1        ; Contains the attribute to switch to HIRES mode
_TemporaryBuffer479   .dsb 479      ; Can be used as a temporary scratch pad for operations like clean update of the inventory display

* = $BB80+40*16
_TEXT_BOTTOM_VIEW__START

* = $BFE0                           ; The 32 bytes of RAM between the end of the screen and the start of the ROM
_32_Bytes_BufferStart
_gScore                 .dsb 2         ; Current highscore for the player
_gAchievements          .dsb 6         ; Enough for 6*8=48 achievements
_gAchievementsChanged   .dsb 1         ; Set to 1 to indicate the game that the achievements have changed and need to be resaved
_gGameOverCondition     .dsb 1         ; Used to store the way the player exited the game
_gUsePrinter            .dsb 1         ; Boolean flag (0/255) to indicate if the printer should be used to print information or not
_32_Bytes_BufferRemaining

* = $C000             ; Start of the ROM/Overlay ram

; Screeen is in $A000 = %10100000 00000000
; Buffer is in  $C000 = %11000000 00000000 -> Same address, +8192 bytes
#ifdef MODULE_GAME
_ImageBuffer          .dsb 40*128   ; 128 lines of HIRES
_ImageBufferEnd       .dsb 40*8     ; an extra 8 lines to make things more practical with the redefined characters
_SecondImageBuffer    .dsb 40*128   ; A second buffer that can store a full image
_free_to_use_e940
#endif

#ifdef MODULE_INTRO
_ImageBuffer                .dsb 40*200   ; 200 lines of HIRES
_OOPS                       .dsb 16       ; TOD: Apparently there's a bug in the depacking code which sometimes depacks too much
_CompressedOfficeImage      .dsb INTRO_PICTURE_PRIVATE_INVESTIGATOR_SIZE_COMPRESSED
_CompressedTypeWriterImage  .dsb INTRO_PICTURE_TYPEWRITER_COMPRESSED
_free_to_user_overlay
#endif

#ifdef MODULE_SPLASH
_ImageBuffer                .dsb 40*200   ; 200 lines of HIRES
#endif

#ifdef MODULE_OUTRO
_ImageBuffer                .dsb 40*200   ; 200 lines of HIRES
_SecondImageBuffer          .dsb 40*128   ; A second buffer that can store a full image
#endif

* = $fe00
_DiskLoader

