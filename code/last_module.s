
    .zero

; Used by both the intro and the game
_param0 .dsb 2
_param1 .dsb 2
_param2 .dsb 2

    .text

_EndText

#if DISPLAYINFO=1
#ifdef MODULE_GAME
#print Remaining space = ($9900 - *)  
#else
#print Remaining space = ($9800 - *)  
#endif
#endif

;_free_to_use_text = osdk_end+1 ; *+256

    .bss
* = _EndText           ; By default we make the BSS start immediately after the TEXT section
_StartBSS

#define OSDK_CUSTOM_STACK 
osdk_stack                  .dsb 256      ; We move the stack in overlay memory
osdk_endstack

#ifdef MODULE_SPLASH

; Severn Software logo: 215x51    -> 40*51=2040  *6=12240
; Defence Force logo: 216x74      -> 40*74=2960  *6=17760
_LabelPicture0	.dsb 2960
_LabelPicture1	.dsb 2960
_LabelPicture2	.dsb 2960
_LabelPicture3	.dsb 2960
_LabelPicture4	.dsb 2960
_LabelPicture5	.dsb 2960
#endif


#ifdef MODULE_OUTRO
_ThirdImageBuffer    .dsb 6000   ; A third buffer that can store a full image
#endif


#ifdef MODULE_GAME
* = $B400+8*48
_TextCharsetNumbers

* = $B400+8*65
_TextCharsetUpperCaseLetters

* = $B400+8*97
_TextCharsetLowerCaseLetters
#endif

#ifdef MODULE_INTRO
_ImageBuffer2           .dsb 40*200
_OOPS2                  .dsb 32       ; TOD: Apparently there's a bug in the depacking code which sometimes depacks too much (by about 18 bytes)
_CompressedTitleImage   .dsb LOADER_PICTURE_TITLE_SIZE_COMPRESSED
_UnCompressedGameTitle  .dsb LOADER_PICTURE_GAME_TITLE_SIZE_UNCOMPRESSED
_free

* = $9800             ; STD charset for HIRES mode: 1024 bytes
_STD_Charset
#else
* = $9800+256         ; STD charset for HIRES mode: 1024 bytes

; Contains all the combinations of 6 pixels patterns shifted by 0 to 5 pixels to the right.
; Each entry requires two bytes, and each need to be merged to the target buffer to rebuild
; the complete shifted graphics
_gShiftBuffer         .dsb 64*2*6           ; 768 bytes
#endif

* = $9C00             ; ALT charset for HIRES mode: 1024 bytes
_gTableModulo6        .dsb 256           ; Given a X value, returns the value modulo 6 (used to access the proper pixel in a graphical block)
_gTableDivBy6         .dsb 256           ; Given a X value, returns the value divide by 6 (used to locate the proper byte in a scanline)
_free_to_use_9e00

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
_gKeyboardLayout        .dsb 1         ; QWERTY / AZERTY / QWERTZ
_gMusicEnabled          .dsb 1         ; 0 or 255
_gSoundEnabled          .dsb 1         ; 0 or 255
_gJoystickType          .dsb 1         ; See enum in lib.h (0=JOYSTICK_INTERFACE_NOTHING, ijk/pase/telestrat/opel/dktronics)
_32_Bytes_BufferRemaining

* = $C000             ; Start of the ROM/Overlay ram

; Screeen is in $A000 = %10100000 00000000
; Buffer is in  $C000 = %11000000 00000000 -> Same address, +8192 bytes
#ifdef MODULE_GAME
_ImageBuffer          .dsb 40*128   ; 128 lines of HIRES
_ImageBufferEnd       .dsb 40*8     ; an extra 8 lines to make things more practical with the redefined characters
_SecondImageBuffer    .dsb 40*128   ; A second buffer that can store a full image
_ArkosMusic           .dsb MUSIC_OVERLAY_BUFFER_SIZE     ; 1700 bytes for the dynamic loading of musics (largest: 1587 bytes so far)
_gFont12x14           .dsb 2660     ; 95 characters (from space to tilde), each is two byte large and 14 lines tall = 2660 bytes
_gFont12x14Width      .dsb 95       ; Width (in pixels) of each of the 95 characters in the 12x14 font
_gInputBuffer         .dsb 40
#endif

#ifdef MODULE_INTRO
_ImageBuffer                .dsb 40*200   ; 200 lines of HIRES
_TypewriterMusic            .dsb LOADER_MUSIC_TYPEWRITER_SIZE   ; 921 bytes
_OOPS                       .dsb 32       ; TOD: Apparently there's a bug in the depacking code which sometimes depacks too much (about 18 bytes)
_CompressedOfficeImage      .dsb INTRO_PICTURE_PRIVATE_INVESTIGATOR_SIZE_COMPRESSED
_CompressedTypeWriterImage  .dsb INTRO_PICTURE_TYPEWRITER_COMPRESSED

#endif

#ifdef MODULE_SPLASH
_ImageBuffer                .dsb 40*200   ; 200 lines of HIRES
#endif

#ifdef MODULE_OUTRO
_ImageBuffer                .dsb 40*200   ; 200 lines of HIRES
_TypewriterMusic            .dsb LOADER_MUSIC_TYPEWRITER_SIZE   ; 921 bytes
_SecondImageBuffer          .dsb 40*128   ; A second buffer that can store a full image
_gInputBuffer               .dsb 40
#endif

// Commented out because this overwrites the loader
//#define OSDK_CUSTOM_STACK 
//osdk_stack                  .dsb 256      ; We move the stack in overlay memory
_free_to_use_overlay

;* = FLOPPY_LOADER_ADDRESS = $fb00
; _DiskLoader

// Some sanity checking
#ifdef MODULE_GAME
#if ( (LOADER_MUSIC_SUCCESS_SIZE > MUSIC_OVERLAY_BUFFER_SIZE) || (LOADER_MUSIC_VICTORY_SIZE > MUSIC_OVERLAY_BUFFER_SIZE) || (LOADER_MUSIC_GAME_OVER_SIZE > MUSIC_OVERLAY_BUFFER_SIZE) )
#error - Music file is larger than reserved buffer size
#else
#endif
