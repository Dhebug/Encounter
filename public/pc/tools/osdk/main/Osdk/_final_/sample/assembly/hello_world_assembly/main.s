

;
; X_POS and Y_POS are used to define 
; the position of the message to display
; on the screen.
; This shows you that XA understand defines.
;
#define X_POS	2
#define Y_POS	1


;
; Using the TEXT screen adress, and the two
; values defined above, we compute the adress
; of the first byte that will be accessed when
; writing the message
;
#define DISPLAY_ADRESS ($BB80+X_POS+Y_POS*40)


;
; This is the entry point of the program.
;
_main
  ; Initialise message adress
  ; this uses self-modifying code
  ; (the $0123 is replaced by message adress)
  lda #<message
  sta read+1
  lda #>message
  sta read+2

  ; Initialise display adress
  ; this uses self-modifying code
  ; (the $0123 is replaced by display adress)
  lda #<DISPLAY_ADRESS
  sta write+1
  lda #>DISPLAY_ADRESS
  sta write+2

  ; Start at the first character
  ldx #0
loop_char

  ; Read the character, exit if it's a 0
read
  lda $0123,x
  beq end_loop_char

  ; Write the character on screen
write
  sta $0123,x

  ; Next character, and loop
  inx
  jmp loop_char  

  ; Finished !
end_loop_char
  rts

message
  .asc "Hello World !",0

