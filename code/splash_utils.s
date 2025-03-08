#include "params.h"

#ifdef LANGUAGE_FR
#pragma osdk replace_characters : é:{ è:} ê:| à:@ î:i ô:^
#endif

    .zero

_angle          .dsb 1
_angle2         .dsb 1
_angle3         .dsb 1
_angle4         .dsb 1
_y              .dsb 1
_position       .dsb 1
_stopMoving     .dsb 1

_height         .dsb 1
_startPosition  .dsb 1
_frameCount     .dsb 2

_ptrSrc          .dsb 2
_ptrDst          .dsb 2
_ptrDstBottom    .dsb 2

_offset                  .dsb 2
_sourceOffset            .dsb 2
_verticalSourceOffset    .dsb 2
_maxVerticalSourceOffset .dsb 2

    .text

IrqTasks50hz
.(
    ; Process keyboard
    jsr ReadKeyboard
    jsr _PlayMusicFrame
    jmp SoundUpdate50hz
.)


; No-op to avoid a linker bug
_PrintInformationMessageAsm
    rts


_Copy38Bytes
.(
    ldx #38-1
loop
+_Copy38Source = *+1
	lda $2211,x
+_Copy38Target = *+1
	sta $5544,x
	dex
	bpl loop
	rts
.)



_Erase38Bytes
.(
    lda #64
    ldx #38-1
loop
+_Erase38Target = *+1
	sta $5544,x
	dex
	bpl loop
	rts
.)


#ifdef ENABLE_MUSIC
_JingleMusic            ; All the three channels are used
#include "splash_music.s"
#endif


_CheckOptionMenuInput
.(
    ; Try to get the menu working during pre-calc
    jsr _ReadKeyNoBounce
    stx _gMenuKeyOption
    beq skip_menu
    jmp _HandleSettingsMenu    
skip_menu    
    rts
.)


#ifdef PRODUCT_TYPE_TEST_MODE    
//
// These bits are copy-pasted from the rest of the code and are only active when building the "Test" configuration
//
#include "crc32.s"
#include "profiler.s"
#include "score.s"

_InitializeGraphicMode
.(
    jsr _ClearTextWindow

    lda #ATTRIBUTE_HIRES|128
    sta $bb80+40*0  	   ; Switch to HIRES, using video inverse to keep the 6 pixels white

    lda #ATTRIBUTE_TEXT
	sta $a000+40*128       ; Switch to TEXT
    rts
.)


; Full Oric display is 240x224
; The top graphic window is 240x128
; Which leaves us with a 240x96 text area at the bottom (12 lines )
; 40*12 = 480
_ClearTextWindow  
.(
  lda #" "   ;lda #"x" ;+1+4
  ldx #0
loop
  sta $bb80+40*16+256*0,x
  sta $bfdf-255,x
  dex
  bne loop
  rts
.)


; _param0=paper color
_ClearMessageWindowAsm
.(
    ; Pointer to first line of the "window"
    lda #<$bb80+40*18
    sta tmp0+0
    lda #>$bb80+40*18
    sta tmp0+1

    ldx #1+23-18
loop_line
    ; Erase the 39 last characters of that line
    ldy #39
    lda #32
loop_column
    sta (tmp0),y
    dey
    bne loop_column

    ; Paper color at the start of the line
    lda _param0
    sta (tmp0),y

    ; Next line
    clc
    lda tmp0+0
    adc #40
    sta tmp0+0
    lda tmp0+1
    adc #0
    sta tmp0+1

    dex
    bne loop_line

    rts
.)

#endif



// Bonus texts
#ifdef LANGUAGE_FR
_Text_Loading_FirstTimeEver    
    .byt 6,"Nous espérons que ce jeu vous plaira!",TEXT_CRLF
    .byt 6,"La disquette doit rester déprotégée",TEXT_CRLF
    .byt 0
_Text_Loading_SecondTime    
    .byt "Vous devez échouer plusieurs fois",TEXT_CRLF
    .byt "afin de collecter tous les succès !",TEXT_CRLF
    .byt 0
_Text_Loading_ThirdTime    
    .byt "Parfois il y a plusieurs solutions",TEXT_CRLF
    .byt "soyez créatif et expérimentez !",TEXT_CRLF
    .byt 0
_Text_Loading_FourthTime
    .byt "Le temps compte: le temps restant sera",TEXT_CRLF
    .byt "ajouté au score. Prêt pour un speedrun ?",TEXT_CRLF
    .byt 0
#else
_Text_Loading_FirstTimeEver    
    .byt 6,"We hope you will enjoy this game!",TEXT_CRLF
    .byt 6,"Remember to keep the floppy writable.",TEXT_CRLF
    .byt 0
_Text_Loading_SecondTime    
    .byt "You are expected to fail a couple times",TEXT_CRLF
    .byt "in order to collect all achievements!",TEXT_CRLF
    .byt 0
_Text_Loading_ThirdTime    
    .byt "Some objectives have multiple solutions",TEXT_CRLF
    .byt "be creative and try something different!",TEXT_CRLF
    .byt 0
_Text_Loading_FourthTime
    .byt "Time matters: The remaining time will be",TEXT_CRLF
    .byt "added to your score. Ready to speedrun?",TEXT_CRLF
    .byt 0
#endif



_gLoadingMessagesArray
  .word _Text_Loading_FirstTimeEver
  .word _Text_Loading_SecondTime
  .word _Text_Loading_ThirdTime
  .word _Text_Loading_FourthTime


;
; High score storage for the message of the day
;
_gSaveGameFile            .dsb 8       ; SAVESTRT
_gSaveGameFileVersion     .dsb 5       ; 1.2.3
_gHighScores              .dsb 512-8-5 ; 456 bytes of actual score data, padded to 512 bytes for the saving system




#ifdef LANGUAGE_FR
_Text_OptionKeyboard    .byt "Choix du clavier:",0
_Text_Azerty            .byt "AZERTY (Francais)",0
_Text_Qwerty            .byt "QWERTY           ",0
_Text_Qwertz            .byt "QWERTZ (Allemand)",0

_Text_OptionJoystick    .byt "Joystick interface:",0
_Text_JoystickNone      .byt "Aucune             ",0

_Text_OptionAudio       .byt "Audio:",0

_Text_AudioSilent          .byt "Silencieux        ",0
_Text_AudioEffects         .byt "Effects seulement ",0
_Text_AudioMusic           .byt "Musique seulement ",0
_Text_AudioEffetsAndMusic  .byt "Musique et effets ",0
#else
_Text_OptionKeyboard    .byt "Keyboard layout:",0
_Text_Azerty            .byt "AZERTY (French)",0
_Text_Qwerty            .byt "QWERTY         ",0
_Text_Qwertz            .byt "QWERTZ (German)",0

_Text_OptionJoystick    .byt "Joystick interface:",0
_Text_JoystickNone      .byt "NONE              ",0

_Text_OptionAudio       .byt "Audio:",0

_Text_AudioSilent          .byt "Silent           ",0
_Text_AudioEffects         .byt "Effects Only     ",0
_Text_AudioMusic           .byt "Music Only       ",0
_Text_AudioEffetsAndMusic  .byt "Music and Effects",0
#endif

_Text_JoystickIjk       .byt "IJK/Stingy/Egoist ",0
_Text_JoysticPase       .byt "PASE/Altai/Mageco ",0
_Text_JoysticTelestrat  .byt "Telestrat/Twilighte",0
_Text_JoysticOpel       .byt "OPEL               ",0
_Text_JoysticDkTronics  .byt "Dk'Tronics         ",0

_gJoystickOptionsArray
  .word _Text_JoystickNone
  .word _Text_JoystickIjk
  .word _Text_JoysticPase
  .word _Text_JoysticTelestrat
  .word _Text_JoysticOpel
  .word _Text_JoysticDkTronics

_gAudioOptionsArray
  .word _Text_AudioSilent
  .word _Text_AudioEffects
  .word _Text_AudioMusic
  .word _Text_AudioEffetsAndMusic

