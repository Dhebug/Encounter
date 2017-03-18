;// --------------------------------------
;// 3k FreeCell
;// --------------------------------------
;// (c) 2013 Mickael Pointier
;// This code is provided as-is.
;// I do not assume any responsability
;// concerning the fact this is a bug-free
;// software !!!
;// Except that, you can use this example
;// without any limitation !
;// If you manage to do something with that
;// please, contact me :)
;// --------------------------------------
;// For more information, please contact me
;// on internet:
;// e-mail: mike@defence-force.org
;// URL: http://www.defence-force.org
;// --------------------------------------
;// Note: This text was typed with a Win32
;// editor. So perhaps the text will not be
;// displayed correctly with other OS.

#define MAXPOS          16
#define MAXCOL          8       ; includes top row as column 0
#define EMPTYCARD       52

#define _rom_hires      $ec33
#define _rom_curset     $f0c8
#define _rom_char       $f12d

#define _rom_kbdclick2  $fb2a

    .zero

    *= $50

tmp0                    .dsb 2
tmp1                    .dsb 2
tmp2                    .dsb 2
tmp3                    .dsb 2
tmp4                    .dsb 2
tmp5                    .dsb 2
tmp6                    .dsb 2
tmp7                    .dsb 2

op1                     .dsb 2
op2                     .dsb 2

tmp                     .dsb 2

game_number             .dsb 2
card_left               .dsb 1
column                  .dsb 1
result                  .dsb 1
undo_index              .dsb 1
redo_index              .dsb 1

start_pos               .dsb 1
end_pos                 .dsb 1
randomize               .dsb 1
pressed_key             .dsb 1

old_pos                 .dsb 1
choice                  .dsb 1

random_seed_low         .dsb 2
random_seed_high        .dsb 2

pos_x                   .dsb 1
pos_y                   .dsb 1
fb                      .dsb 1
pattern                 .dsb 1
graph_offset            .dsb 1  ; Used by _DrawSymbol
card_offset             .dsb 1  ; Value from 0 to 52 (used by _DrawCardToHires)
color                   .dsb 1
card                    .dsb 1
suit                    .dsb 1
top_card                .dsb 1
size                    .dsb 1

card_ptr                .dsb 2  ; Points to _Cards, cards are always page aligned
other_ptr               .dsb 2

card_data_index         .dsb 1  ; Points to the current position in the _CardDataDescription table

pos_yy                  .dsb 1

offset                  .dsb 1
position                .dsb 1
counter                 .dsb 1
counter2                .dsb 1
counter3				.dsb 1

col                     .dsb 1
pos                     .dsb 1


countcard_columns       .dsb 8
countcard_cells         .dsb 4
countcard_foundations   .dsb 4

topcard_columns         .dsb 8
topcard_cells           .dsb 4
topcard_foundations     .dsb 4

card_deck               		; The deck of 52 cards (13x4), generally shuffled :)
cardbottom_low          .dsb 16 ; Here we keep the address where we draw cards on screen for each slot.
cardbottom_high         .dsb 16 ; Going to be used later by the code that draws the cursors on screen.
						
    .text


_Inits
.(
    ; Black background
    lda #16
    sta $26b

    ; Hires area: White/Red and Black/Cyan
    ; We achieve this with only one attribute placed on the left column, with a cyan attribute.
    ; Means we have to fill screen with inverted paper to get the white background
    jsr _rom_hires

    ; #define CURSOR        0x01  /* Cursor on        (ctrl-q) */
    ; #define SCREEN        0x02  /* Printout to screen on (ctrl-s) */
    ; #define NOKEYCLICK    0x08  /* Turn keyclick off    (ctrl-f) */
    ; #define PROTECT       0x20  /* Protect columns 0-1   (ctrl-]) */
    lda #2
    sta $26a    ; Disable the blinking cursor, while keeping the keyclick (has to be done after the HIRES switch)


    ;
    ; Generate few tables that are used later to generate the card graphics
    ;
initialize_table_6
    .(
    lda #32
    ldx #0
loop
    pha

    ;
    ; Here we try to mirror bits
    ;
    stx tmp
    txa
    sta _TableBit6NoMirror,x
    ldy #8
rotate
    ror
    rol _TableBit6Mirror,x
    dey
    bne rotate

div__
    lda #0
    sta _TableDiv6,x            ; Divide by 6 table

    pla
    sta _TableBit6Reverse,x     ; Reverse bitmask table

    lsr
    bne skip_reset
    inc div__+1
    lda #32
skip_reset

    inx
    bne loop
    .)



    ;
    ; The main loop in charge of generating the 52+1 cards
    ; At some point it would make sense to reverse the creation order to use decrements instead of load/compare,
    ; but that would require quite some many changes all over the palce.
    ;
initialize_generate_cards
    .(
    lda #>_Cards
    sta card_ptr+1

    ldx #0
    stx card_ptr+0
    stx card_data_index
loop_card
    stx card


    ldx #0
loop_color
    stx color
    lda ColorTable,x
    sta fb

    jsr _GenerateFrame

    jsr _GenerateCard
    iny
    sty tmp

    ;
    ; Invert the card based on the color we want
    ;
    ldy #0
loop_invert_color
    lda (card_ptr),y
    eor fb
    sta (card_ptr),y
    iny
    cpy #37*4
    bne loop_invert_color

    inc card_ptr+1

    ldx color
    inx
    cpx #4
    bne loop_color

    ldy tmp
    sty card_data_index

    ldx card
    inx
    cpx #13
    bne loop_card
    .)

    ; And the last card - Free Slot
    jsr _GenerateFrame
    .)


    .(
    ;
    ; Display the message
    ;
    ldy #50
    sty pos_y

    lda #<TwilighteMessage1-1
    sta tmp0+0
    lda #>TwilighteMessage1-1
    sta tmp0+1

    ldy #0
loop_lines    
    iny
    lda (tmp0),y
    beq end_text
    sta pos_x

loop_text
    iny
    sty tmp1
    lda (tmp0),y
    beq end_line

    pha
    jsr _rom_kbdclick2
    pla
    jsr _DrawCharacter

    ldy tmp1
    bne loop_text

end_line
    ldx #255 
    jsr _DelayLoop

    lda pos_y
    clc
    adc #10
    sta pos_y
    ldy tmp1
    bne loop_lines

end_text


    .(
    lda #0
    sta pos_y
loop_gradient

    ;
    ; Draw twilightes logo with animated gradient
    ;
    lda #<_TwilighteLogo-1
    sta tmp0+0
    lda #>_TwilighteLogo-1
    sta tmp0+1

    lda #<$a000+(40*90)+9
    sta tmp1+0
    lda #>$a000+(40*90)+9
    sta tmp1+1

    ldx #0
loop_y

    txa
    clc
    adc pos_y
    and #63
    tay

    lda GradientTable,y
    ldy #0
    sta (tmp1),y

loop_x    
    iny 
    lda (tmp0),y
    sta (tmp1),y
    cpy #21
    bne loop_x

    clc
    lda tmp0+0
    adc #21
    sta tmp0+0
    bcc skip
    inc tmp0+1
skip

    jsr _Tmp1Plus40

    inx
    cpx #34
    bne loop_y

    inc pos_y

    bne loop_gradient 
    .)   


    .)



_NewGame
    ;
    ; Ask the player to press keys to select the game variant
    ; Create the game based on this new random seed
    ;
    .(
    ;
    ; Erase the screen
    ;
    jsr _PaintBackground

    ;
    ; Print the title screen
    ; This simply shows all the cards of each of the 4 suits,
    ; presented in diagonal accross the screen.
    ;
    .(
    lda #0
    sta card_offset

    lda #11
    sta pos_x
    lda #4
    sta pos_y

    lda #13
    sta card
loop_card

    lda #4
    sta suit
loop_suit
	lda card_offset
    jsr _DrawCardToHires	; A=card to draw

    inc card_offset

    ; X-3
    dec pos_x
    dec pos_x
    dec pos_x

    ; Y+40
    clc
    lda pos_y
    adc #40
    sta pos_y

    dec suit
    bne loop_suit

    ; X-10
    clc
    lda pos_x
    adc #3*4+2
    sta pos_x

    ; Y-157
    sec
    lda pos_y
    sbc #157
    sta pos_y

    dec card
    bne loop_card
    .)


    ;
    ; Ask the player to press keys to select the game variant
    ;
    .(
    ; Moving this text in the randomize loop works, but this flickers like hell...
    ldx #textPresentation-_Messages
    jsr _PrintText

    lda #27
    sta randomize

loop_randomize
    jsr _rand32
    lda random_seed_low+0
    sta game_number+0
    lda random_seed_low+1
    sta game_number+1

loop
    jsr _PrintGameNumber

    jsr $23B            ; get key without waiting. If not available

    ; 'Enter' validates
    cmp #13
    beq _StartGame

    ; 'Escape' switches the randomize on and off
    cmp #27
    bne no_escape
    eor randomize
    sta randomize
    jmp check_random

no_escape

    ; Digits allows the user to enter values
    sec
    sbc #"0"
    cmp #10
    bcs check_random

    sta pressed_key

    ; randomize active ?
    lda randomize
    bne reset_game_number

    ; z_game_number>6552 ?
    lda #<6552
    cmp game_number+0
    lda #>6552
    sbc game_number+1
    bcs insert_digit

reset_game_number
    lda #0
    sta randomize
    sta game_number+0
    sta game_number+1

insert_digit
    ; unsigned 16bit multiply op1 x 10 -> tmp
    lda #0
    sta tmp
    sta tmp+1

    ldy #10
multiplyBy10
    clc
    lda tmp+0
    adc game_number+0
    sta tmp+0
    lda tmp+1
    adc game_number+1
    sta tmp+1
    dey
    bne multiplyBy10

    clc
    lda tmp+0
    adc pressed_key
    sta game_number+0
    lda tmp+1
    adc #0
    sta game_number+1

check_random
    lda randomize
    beq loop
    bne loop_randomize
    .)


    ;
    ; Create the game based on this new random seed
    ;
_StartGame
    .(
    ;
    ; Clear the game board
    ;
    lda #EMPTYCARD          ; Empty
    

    .(
    ldx #8+4+4
loop_clear
    sta topcard_columns-1,x
    dex
    bne loop_clear
    .)
    
    ; Reset the undo/redo
    lda #0
    sta undo_index
    sta redo_index
    sta start_pos
    sta end_pos

    ;
    ; Fill the deck with each of the 52 cards.
    ; We perform a conversion that allows us to be compatible with the other versions of the
    ; game while being internally '6502 friendly'. I wish Jim Horne had decided to alternate
    ; colors instead of black, red, red, black...
    ;
    .(
    ldx #51
loop_create_deck
    txa
    and #%11
    tay
    txa
    and #%11111100
    ora _SuitConverTable,y

    sta card_deck,x
    dex
    bpl loop_create_deck
    .)

    ;
    ; Initialize the random generator to 'z_game_number'
    ;
    lda game_number+0
    sta random_seed_low+0
    lda game_number+1
    sta random_seed_low+1
    lda #0
    sta random_seed_high+0
    sta random_seed_high+1
    sta column

    ; shuffle cards
    .(

    ; Clear slots
    .(
    ldx #16
loop_clear_counts
    sta countcard_columns-1,x
    dex
    bne loop_clear_counts
    .)

    ;
    ; Now we are going to put each of the 52 cards in our 8 columns of card.
    ; The columns are filled linearly from left to right and top to bottom, no special
    ; trick involved, the cards are picked up randomly in the remaining ones.
    ;
    lda #<_CardSlots
    sta card_ptr+0
    lda #>_CardSlots
    sta card_ptr+1

    lda #52
    sta card_left
loop_shuffle_cards
    ;
    ; Get a card randomly, picked up from the number of remaining ones (card_left)
    ;
    jsr _rand32

    lda random_seed_high+0
    sta op1
    lda random_seed_high+1
    and #$7f
    sta op1+1

    ;
    ; Compute card (8 bit) as random_seed_high (16 bit) modulo card_left (8 bit)
    ;
    .(
    lda #0
    sta card
    sta tmp+1

    ldx #16
    asl op1+0
    rol op1+1
udiv2
    rol card
    rol tmp+1
    sec
    lda card
    sbc card_left
    tay
    lda tmp+1
    sbc #0
    bcc udiv3
    sty card
    sta tmp+1
udiv3
    rol op1+0
    rol op1+1
    dex
    bne udiv2
    .)
    ; Now card contains the picked up card

    ;
    ; We put to the _CardSlots[..] gets the card picked up in the deck
    ;
    ldx card
    lda card_deck,x
    ldy #0
    sta (card_ptr),y

    ;
    ; We take the last card of the deck and move it where the card we just picked up was.
    ;
    ldy card_left
    lda card_deck-1,y
    sta card_deck,x

    ;
    ; Next column
    ;
    clc
    lda card_ptr+0
    adc #<MAXPOS
    sta card_ptr+0

    ldx column
    inc countcard_columns,x
    inx
    cpx #8
    bne no_reset_column

    ; Last column reached, rewind to the first column but on the next line
    ldx #0

    sec
    lda card_ptr+0
    sbc #<MAXPOS*MAXCOL-1
    sta card_ptr+0
no_reset_column
    stx column

    dec card_left
    bne loop_shuffle_cards
    .)
    .)

    jsr _PaintBackground
    .)



_MainGameLoop
    ;
    ; Show the game, plus starting messages
    ; Ask the player which card he wants to move
    ;
.(
show_undo_redo_message
    ;
    ; Patch the text depending of the Undo/Redo possibilities
    ;
    lda #messageCRLF-_Tokens
    tax

    ldy undo_index
    beq no_undo
    lda #message_Undo-_Tokens
no_undo
    sta textUndo+0

    cpy redo_index
    beq no_redo
    ldx #message_Redo-_Tokens
no_redo
    stx textRedo+0

_DrawColumns
    ;
    ; Draw the main board game
    ;
    ldx #0
    stx counter2
loop_col
    stx col

    ; Set the base column address
    txa
    asl     ; x2
    asl     ; x4
    clc
    adc #4
    sta pos_x

    lda #60
    sta pos_y

    ldx counter2
    stx counter
    txa
    clc
    adc #MAXPOS
    sta counter2

    ldx col
    lda countcard_columns,x
    sta counter3
    beq draw_empty_slot
    
    ldx #0
loop_pos
    stx pos

    ;CardSlots[col][pos];
    ldy counter
    inc counter
    lda _CardSlots,y

    ldx col
    sta topcard_columns,x
    
    
    jsr _DrawCardToHires	; A=card to draw

    .(
    ldx col
    lda countcard_columns,x
    tax

    ; Add the vertical spacing
    clc
    lda pos_y
    adc _CardsSpacing,x
    sta pos_y
    .)

    ldx pos
    inx
    dec counter3
    bne loop_pos
    beq clear_end_card

draw_empty_slot    
    ; Draw an empty slot
    lda #52
    jsr _DrawCardToHires	; A=card to draw


clear_end_card
    ldx col
    lda tmp1+0
    sta cardbottom_low,x
    lda tmp1+1
    sta cardbottom_high,x

    lda #64+1+2+4+8+16+32

    .(
    ; Redraw some more lines at the end to clean up when moving cards around
    ; so we don't have to perform a full screen cleaning all the time.
    ; tmp1 contains the location of the last scanline after _DrawCardToHires has been called
    ldx #16
loop_clear

    eor #1+2+4+8+16+32+128
loop_x

    ldy #0
    sta (tmp1),y
    iny
    sta (tmp1),y
    iny
    sta (tmp1),y
    iny
    sta (tmp1),y

    pha
    jsr _Tmp1Plus40
    pla

    dex
    bne loop_clear
    .)


    ldx col
    inx
    cpx #MAXCOL
    bne loop_col

_DrawFreecellsAndFoundations
    .(
    ; X=3 for cells and 21 for foundations
    lda #3
    sta pos_x
    lda #10
    sta pos_y

    ldx #0
loop
    stx counter
    lda topcard_cells,x

    jsr _DrawCardToHires	; A=card to draw

    lda #4
    ldx counter
    cpx #3
    bne normal_update
    lda #6
normal_update
    clc
    adc pos_x
    sta pos_x

    lda tmp1+0
    sta cardbottom_low+8,x
    lda tmp1+1
    sta cardbottom_high+8,x

    inx
    cpx #8
    bne loop
    .)


_CheckIfVictorious
    ;
    ; Check if the player has won
    ; Victory is achieved when the final slots contain KING KING KING KING,
    ; or when no other card is present anywhere else
    ;
    .(
    ; By default, game is on
    ldx #textSelectCard-_Messages

    ; Test win
    ldy #4
loop_test_win
    lda topcard_foundations-1,y
    lsr
    lsr
    cmp #12             ; King
    bne display_message
    dey
    bne loop_test_win

    ; Winer !
    ldx #textWon-_Messages

display_message
    jsr _PrintText
    .)


_SelectCardToMove
    ;
    ; Ask the player which card he wants to move
    ;
    lda #16
    ldx start_pos
    jsr _ShowCursor

    lda #16
    ldx end_pos
    jsr _ShowCursor
    lda start_pos
    sta old_pos
    jsr _FindCard   ; A=position


loop
    jsr _RefreshOneCursor

    lda card
    cmp #EMPTYCARD
    bne read_keyboard

no_valid_card
    ; No valid card on the starting slot, we search the next valid one
    lda #9
    sta choice
    bne search_card

read_keyboard
    jsr $23B            ; Returns the ASCII code in A if any key is pressed
    bpl read_keyboard   ; loop until char available
    sta choice

    cmp #13         ; 'Enter' validates the choice
    beq end
    cmp #27
    beq escape
    cmp #"U"
    beq undo
    cmp #"R"
    beq redo

search_card
    lda start_pos
    jsr _HandleArrowKeys
    and #15
    sta start_pos

    jsr _FindCard   ; A=position
    lda card
    cmp #EMPTYCARD
    bne loop        ; We found a position with has card to move, back to the main loop

    ; while (z_start_pos!=z_old_pos);
    lda start_pos
    cmp old_pos
    bne search_card
    beq loop

end
    jmp validateStartPosition

undo
    ; Player wants to undo an operation
    ldx undo_index
    beq loop                ; Nothing to undo
    dex

    lda _UndoBufferFrom,x
    pha
    lda _UndoBufferTo,x
    pha

    jmp UndoRedo

redo
    ; Player wants to redo an operation
    ldx undo_index
    cpx redo_index
    bcs loop                ;(z_undo_index<z_redo_index)

    lda _UndoBufferTo,x
    pha
    lda _UndoBufferFrom,x
    pha

    inx

UndoRedo
    stx undo_index
    pla
    jsr _FindAndRemoveCard  ; Position in 'A'
    pla
    tax
    jmp _InsertCard         ; Position in 'X'



escape
    ; Player wants to quit
    ldx #textConfirmQuit-_Messages
    jsr _PrintText

get
    jsr $23B        ; Returns the ASCII code in A if any key is pressed
    cmp #13         ; 'Enter' quits the game
    beq quit_game
    cmp #27         ; 'Escape' a second time goes back to the game
    bne get
    jmp _CheckIfVictorious

quit_game
    jmp _NewGame

.)


validateStartPosition
    ;
    ; Ask the player to select the destination
    ;
    ldx #textSelectDestination-_Messages
    jsr _PrintText

    lda start_pos
    sta end_pos
    sta old_pos

    ;
    ; We try first to see if we can select an ideal target
    ;
search_best_default_target
    .(
    ; Is the selected card in the slots or cells?
    lda start_pos
    cmp #12
    bcs done

    ; z_card contains the currently selected card (in theory)
    jsr _FindCard   ; A=position

    ; Search a valid position in the 4 foundations
    ldx #11
loop_search
    inx
    cpx #16
    beq done
    stx position
    txa
    jsr _IsValidPosition    ; A=position
    ldx position
    lda result
    beq loop_search

    ; Select this as the position we want
    stx end_pos

done
    .)


_SelectCardDestination
    ;
    ; The player now can choose the location where to place the card
    ;
    .(
loop
    ;
    ; Display the two cursors:
    ; - Hollow one on the starting position
    ; - Solid one controlled by the player
    ;
    .(
    ; if old!=new, then delete old marker
    lda old_pos
    cmp end_pos
    beq skip

    ; Delete old cursor
    lda #16
    ldx old_pos
    jsr _ShowCursor

    lda end_pos
    sta old_pos
skip

    ; Start marker
    lda #8
    ldx start_pos
    jsr _ShowCursor

    ; End marker
    lda #0
    ldx end_pos
    jsr _ShowCursor
    .)

get
    jsr $23B        ; Returns the ASCII code in A if any key is pressed
    bpl get         ; loop until char available
    sta choice

    cmp #13         ; 'Enter' validates the choice
    beq end
    cmp #27         ; 'Escape' cancels the selection
    beq end_main_loop

inner_loop
    lda end_pos
    jsr _HandleArrowKeys
    and #15
    sta end_pos

    jsr _IsValidPosition    ; A=position
    lda result
    bne loop        ; We found a position with has card to move, back to the main loop

    ; while ( (z_end_pos!=z_old_pos) && (z_end_pos!=z_start_pos) );
    lda end_pos
    cmp start_pos
    bne inner_loop
    cmp old_pos
    bne inner_loop
    beq loop

end
    .)

    ;
    ; Finally move the card - if the user did not cancel the move
    ; If start and end are identical, it means the player cancelled the move
    ;
    lda start_pos
    cmp end_pos
    beq end_main_loop

    ; Remove the card from the start slot and insert in the end slot
    jsr _FindAndRemoveCard  ; Position in 'A'
    lda end_pos

    ; Record the move in the undo/redo stack
    ldx undo_index
    lda start_pos
    sta _UndoBufferFrom,x
    lda end_pos
    sta _UndoBufferTo,x
    inx
    stx undo_index
    stx redo_index

    ldx end_pos

; This function assumes that the operation is  valid.
; in: 'x' is the position
; in: card
_InsertCard
    .(
    jsr _GetLastFreeSlot
    ; Insert the card in one of the columns
    lda card
    sta _CardSlots,y
    sta topcard_columns,x
    inc countcard_columns,x
    .)
end_main_loop
    jmp _MainGameLoop




_rand32			; return( ((_holdrand = _holdrand * 214013 + 2531011) >> 16) & 0x7fff );    
.(
	; 214013
    lda #$FD
    sta tmp2+0
    lda #$43
    sta tmp2+1
    lda #$03
    sta tmp2+2
    lda #$00
    sta tmp2+3

    ; 32 bit multiply
    sta tmp4+4
    sta tmp4+5
    sta tmp4+6
    sta tmp4+7

    ldy #32
shift_r
    lsr random_seed_low+3
    ror random_seed_low+2
    ror random_seed_low+1
    ror random_seed_low+0
    bcc rotate_r
    
    clc
    lda tmp4+4
    adc tmp2+0
    sta tmp4+4
    
    lda tmp4+5
    adc tmp2+1
    sta tmp4+5
    
    lda tmp4+6
    adc tmp2+2
    sta tmp4+6
    
    lda tmp4+7
    adc tmp2+3
rotate_r
    ror
    sta tmp4+7
    
    ldx #7
loop_ror    
    ror tmp4-1,x
    dex
    bne loop_ror
    
    dey
    bne shift_r

    ; 2531011
    clc
    lda tmp4+0
    adc #$C3
    sta random_seed_low+0
    lda tmp4+1
    adc #$9E
    sta random_seed_low+1
    lda tmp4+2
    adc #$26
    sta random_seed_low+2
    lda tmp4+3
    adc #$00
    sta random_seed_low+3

    rts
.)



; In:  x -> selected slot
; Out: x -> selected slot
; Out: y -> index on the last free slot
_GetLastFreeSlot
.(
    txa
    asl             ; x2
    asl             ; x4
    asl             ; x8
    asl             ; 16
    clc
    adc countcard_columns,x
    tay

    rts
.)


; A=position
; card=card we want to insert
_IsValidPosition
.(
    ; Start by defining the position as invalid
    ldx #0
    stx result

    cmp #8
    bcs cells_or_foundations

cards
    tax
    lda countcard_columns,x
    beq is_valid    ; No card so far, any card is allowed

    ; unsigned char previous_card=previous_card=CardSlots[z_position][index-1];
    jsr _GetLastFreeSlot		; x=position

    lda _CardSlots-1,y
    sta top_card

    ; ((z_card&2)!=(previous_card&2))               // Alternating color
    lda card
    eor top_card
    and #%00000010
    beq is_invalid  ; Same color
    ; (VALUE(z_card)==VALUE(previous_card)-1) &&    // Decreasing value

    lda top_card
    and #%11111100
    sta top_card

    clc
    lda card
    and #%11111100
    adc #4
    cmp top_card
    beq is_valid
    rts             ; Not the next card in suit



cells_or_foundations
    and #%0111      ; -8 to freecell index
    cmp #4
    bcs foundations

cells
    tax
    lda countcard_cells,x
    beq is_valid
    rts             ; Cell is not free

foundations
    and #%0011      ; -4 to foundation index
    tax
    lda topcard_foundations,x
    sta top_card
    cmp #EMPTYCARD
    bne some_cards

no_cards
    ; Slot is free: We accept an ACE of any color
    ; if (VALUE(z_card)==0)
    ; #define VALUE(card)     ((card) >> 2)
    lda card
    and #%11111100
    beq is_valid
    rts             ; Not an ACE

some_cards
    ; There is already a card there: We accept the next card in the same suit
    ; if (SUIT(top_card)==SUIT(z_card) ) &&
    ;    (VALUE(z_card)==VALUE(top_card)+1)
    ; #define SUIT(card)      ((card) & 3)
    lda card
    eor top_card
    and #%00000011
    bne is_invalid  ; Different suit

    clc
    lda top_card
    adc #4
    cmp card
    bne is_invalid  ; Not the next card in suit

is_valid
    lda #1
    sta result
is_invalid
    rts
.)



; A=position
_FindCard
.(
	tax 
	lda topcard_columns,x
	sta card
	rts
.)


; Position in 'A',
; Found card returned in 'card'
_FindAndRemoveCard
.(
	tax
    ldy topcard_columns,x		; Top card become the new 'card'
    sty card

    dec countcard_columns,x		; One more card
	bne not_last
last_card	
    lda #EMPTYCARD
    sta topcard_columns,x
    rts
    
not_last
	        
    cpx #12
    bcc end_foundation
    
foundations
    lda card
    lsr
    lsr
    sta tmp1
    dec tmp1
    asl tmp1
    asl tmp1
    lda card
    and #%00000011
    ora tmp1
    sta topcard_foundations,x
    
end_foundation    
    rts
.)



_HandleArrowKeys
.(
    sec             ; Counts as +1 on all the 'adc'

    ldx choice
testleft
    cpx #8
    bne testright
    sbc #1
    rts

testright
    cpx #9
    bne testup
    adc #0          ; +1 from carry = 1
    rts

testup
    cpx #10
    bne testdown
    sbc #8
    ; Forces next choice to left
    ldy #8
    sty choice
    bne end

testdown
    cpx #11
    bne end
    adc #7          ; +1 from carry = 8
    ; Forces next choice to right
    ldy #9
    sty choice

end
    rts
.)



_Tmp1Plus40
.(
    clc
    lda tmp1+0
    adc #40
    sta tmp1+0
    bcc skip
    inc tmp1+1
skip
    rts
.)



_PaintBackground
.(
    lda #<$a000
    sta tmp1+0
    lda #>$a000
    sta tmp1+1

    lda #64+128
    sta tmp2

    ldx #200
loop_y

    ldy #0
    lda #6
    sta (tmp1),y

    lda tmp2
    eor #1+2+4+8+16+32+128
    sta tmp2

loop_x

    iny
    sta (tmp1),y
    cpy #39
    bne loop_x

    jsr _Tmp1Plus40

    dex
    bne loop_y

    rts
.)



; Prints the value of  game_number (16 bits) at the bottom right of the screen (5 digits)
_PrintGameNumber
.(
    lda game_number+0
    sta op2
    lda game_number+1
    sta op2+1

    ; uitoa
    .(
    ldy #0
itoaloop
    ; udiv10 op2= op2 / 10 and A= tmp2 % 10
    lda #0
    ldx #16
    clc
udiv10lp
    rol op2+0
    rol op2+1
    rol
    cmp #10
    bcc contdiv
    sbc #10
contdiv
    dex
    bne udiv10lp
    rol op2+0
    rol op2+1

    pha
    iny
    lda op2+0
    ora op2+1
    bne itoaloop
    .)


    sty tmp
    sec
    lda #39-10
    sbc tmp
    tay

    ldx #0
write_game_message
    lda messageGameNumber,x
    sta $bfe0-39,y
    iny
    inx
    cpx #10
    bne write_game_message

    ldx tmp

write_number
    pla
    clc
    adc #$30
    sta $bfe0-39,y
    iny
    dex
    bne write_number

    rts
.)



; x=text index
_PrintText
.(
    ; Erase the 3 lines of text
    .(
    ldy #40*3
    lda #32
loop
    sta $bb80+25*40-1,y
    dey
    bne loop
    .)

    ; Draw the message
    ldy #0
    sty position
loop_token_list
    lda _Messages,x
    cmp #255
    beq end_token_list
    cmp #254
    beq print_game_number
    inx
    stx tmp

    ; a=token index
    tax
loop_characters
    inx
    lda _Tokens-1,x
    beq end_token
    cmp #13
    beq new_line

    sta $bb80+25*40,y
    iny
    bne loop_characters
end_token
    ldx tmp
    bne loop_token_list

print_game_number
    jsr _PrintGameNumber
end_token_list
    rts


new_line
    clc
    lda position
    adc #40
    sta position
    tay
    jmp end_token
.)




_RefreshOneCursor
    .(
    ; if old!=new, then delete old marker
    lda old_pos
    cmp start_pos
    beq skip

    ; Delete old cursor
    lda #16
    ldx old_pos
    jsr _ShowCursor

    lda start_pos
    sta old_pos
skip

    ; Make sure new cursor position is visible
    lda #0
    ldx start_pos
    .)
; x: Column/Slot where we want to draw the cursor
; a: Which cursor to draw
_ShowCursor
.(
    ldy cardbottom_low,x
    sty other_ptr+0
    ldy cardbottom_high,x
    sty other_ptr+1

    ldy #4
    sty pos_yy

    tax
    ldy #1
loop
    lda _CursorBase,x
    sta (other_ptr),y
    inx
    iny

    lda _CursorBase,x
    sta (other_ptr),y
    inx

    clc
    tya
    adc #39
    tay

    dec pos_yy
    bne loop
    rts
.)



; All data is now accessed as indexed from _GrafixStart_
; - graph_offset -> points on the graphics
; - X           = x position
; - Y           = y position
; - size
_DrawSymbol
.(
    stx pos_x

    lda graph_offset
    sta tmp1+0

    lda size
    sta pos_yy
loop_y
    sty card_ptr+0

    ; Load the next 8 pixels
    ldx tmp1+0
    lda _GrafixStart_,x
    tax
+MirrorPatchAddr
    lda _TableBit6NoMirror,x        ; Optionally apply a mirroring effect
    sta pattern
    inc tmp1+0

    ldx pos_x
loop_x
    lsr pattern
    bcc no_pixel    

    ; Draw the pixel
    ldy _TableDiv6,x                ; Max value of X is about 24
    lda _TableBit6Reverse,x
    ora (card_ptr),y
    sta (card_ptr),y
no_pixel

    inx

    lda pattern
    bne loop_x
    
    ldy card_ptr+0
    iny
    iny
    iny
    iny
    
    dec pos_yy
    bne loop_y

    lda #0
    sta card_ptr+0
    rts
.)




; Copy a card from the memory buffer, and draw it on the HIRES screen
; A: Card to display
; Coordinates in pos_x and pos_y
; At the end tmp1 contains the next scanline on screen
_DrawCardToHires
.(
    clc
    adc #>_Cards
    sta tmp0+1

    lda #<_Cards
    sta tmp0+0
    
    ; Initialize screen to $a0xx
    lda pos_x
    sta tmp1+0
    lda #$a0
    sta tmp1+1

    ; Then add the Y coordinate
    .(
    ldy pos_y
    beq end_loop_add
loop_add
    jsr _Tmp1Plus40
    dey
    bne loop_add
end_loop_add
    .)


    ldx #37
loop
    ldy #0
inner
    lda (tmp0),y
    sta (tmp1),y
    iny
    cpy #4
    bne inner

    clc
    lda tmp0+0
    adc #4
    sta tmp0+0

    jsr _Tmp1Plus40

    dex
    bne loop

    rts
.)



; Initialize the frame of the card
_GenerateFrame
.(
    ldy #0

    ; Top part
    jsr draw_horizontal_line

    ; Middle part
    ldx #35
loop
    lda #64+32
    sta (card_ptr),y
    iny

    lda #64
    sta (card_ptr),y
    iny
    sta (card_ptr),y
    iny

    lda #64+1
    sta (card_ptr),y
    iny

    dex
    bne loop

    ; Bottom part
draw_horizontal_line
    lda #64+1+2+4+8+16+32
    sta (card_ptr),y
    iny
    sta (card_ptr),y
    iny
    sta (card_ptr),y
    iny
    sta (card_ptr),y
    iny

    rts
.)



; Draw a card in the hires screen (or buffer, or whatever, will change that later)
;       if (z_color&2)  mask=0;
;       else            mask=128;
;
_GenerateCard
.(
    lda #>_TableBit6NoMirror
    sta MirrorPatchAddr+2

    ; Draw the small numbers in the corners
    lda card
    rol                         ; x2
    rol                         ; x4
    clc
    adc card                    ; x5
    sta graph_offset            ; _SmallNumbers

    lda #5
    sta size

    ldx #2
    ldy #2*4
    jsr _DrawSymbol

    ; Draw the small color symbol under the corner for Aces, Jacks, Queen and Kings
    ldx card
    dex
    cpx #9
    bcc end_small_symbols

draw_small_symbols
    ldx color
    lda Offset5Table,x
    sta graph_offset            ; symbols_5x5

    ldx #2
    ldy #8*4
    jsr _DrawSymbol

end_small_symbols

    ; Draw the symbols on the cards
    ldy card_data_index

    lda _CardDataDescription,y          ; Size of the graphics data (should be in the symbol itself :p)
    iny
    sta size

    lda _CardDataDescription,y          ; Offset of the symbol graphics data
    iny

    ; we need to find the correct offset for the color of the card in order to point on the right graphics
    ; This is not valid for heads because the graphics is the same for all the families.
    ldx card
    cpx #10
    bcs no_color_offset

    ldx color
    beq no_color_offset

loop_add
    clc
    adc size
    dex
    bne loop_add

no_color_offset
    sta graph_offset


loop_draw_symbols
    lda _CardDataDescription,y      ; X position

    beq end_loop                    ; 0 is the end marker
    bmi mirrorCard
back_to_draw
    tax
    iny

    lda _CardDataDescription,y      ; Y position
    iny
    sty tmp  
    tay

    jsr _DrawSymbol

    ldy tmp

    bne loop_draw_symbols

end_loop
    rts

drawMirror
    ldx #>_TableBit6Mirror
    stx MirrorPatchAddr+2
    and #%01111111
    bne back_to_draw


mirrorCard
    cmp #255
    bne drawMirror
    iny
    sty tmp

    ldy #0
loop_push_bytes
    lda (card_ptr),y
    iny
    pha
    cpy #74
    bne loop_push_bytes

loop_pop_bytes
    pla
    tax
    lda _TableBit6Mirror,x
    ror
    ror
    ora #64
    sta (card_ptr),y
    iny
    cpy #148
    bne loop_pop_bytes

    ldy tmp
    bne loop_draw_symbols
.)


; pos_x = x position
; pos_y = y position
; a=ascii code
_DrawCharacter
.(
    tax
    jsr _DelayLoop

    pha
    ;stx 

    lda #0
    sta $2e0       ; Zero error indicator.
    sta $2e2
    sta $2e4
    sta $2e6

    lda pos_x
    sta $2e1
    clc
    adc #6
    sta pos_x

    lda pos_y
    sta $2e3
    lda #3
    sta $2e5
    jsr _rom_curset

    lda #0
    sta $2e0       ; Zero error indicator.

    pla
    sta $2e1
    lda #0
    sta $2e3
    lda #1
    sta $2e5
    jsr _rom_char

    rts
.)

; x = main delay
; (uses Y)
_DelayLoop
.(
delay_loop
    ldy #200
delay_inner_loop
    nop
    dey    
    bne delay_inner_loop
    dex
    bne delay_loop
    rts
.)




TwilighteMessage1
    .byt 20,"There's always room for a friend",0
    .byt 50,"Even in a 2.5k minigame",0
    .byt 20,0
    .byt 20,0
    .byt 20,0
    .byt 20,0
    .byt 20,0
    .byt 20,0
    .byt 20,0
    .byt 80,"Rest In Peace",0
    .byt 20,0
    .byt 50,"Jonathan Colin Bristow",0
    .byt 40,"3 August 1968 - 28 May 2013",0
    .byt 0

GradientTable
    .byt 0,0,0,0,1,0,0,1,1,0,1,1,1,1,3,1,1,3,3,1,3,3,3,3,2,3,3,2,2,3,2,2,2,2,6,2,2,6,6,2,6,6,6,6,4,6,6,4,4,6,4,4,4,4,1,4,4,1,1,4,1,1,0,1


Offset5Table
    .byt symbols_5x5-_GrafixStart_+5*0
    .byt symbols_5x5-_GrafixStart_+5*1
    .byt symbols_5x5-_GrafixStart_+5*2
    .byt symbols_5x5-_GrafixStart_+5*3


ColorTable
    .byt 128
    .byt 128
    .byt 1+2+4+8+16+32
    .byt 1+2+4+8+16+32


; We unfortunately need to convert the suit order, because for some reason the original author decided that the default order was practical.
; Well, if instead he had first the two red cards, then the two black cards, it would just be a matter of masking and xoring to detect the various conditions.
_SuitConverTable
    .byt %11
    .byt %01
    .byt %00
    .byt %10


_GrafixStart_

;
; The name/number of the card, small font, 5 pixels high
;
_SmallNumbers
    ; 1
    .byt %00001
    .byt %00001
    .byt %00001
    .byt %00001
    .byt %00001
    ; 2
    .byt %00111
    .byt %00100
    .byt %00111
    .byt %00001
    .byt %00111
    ; 3
    .byt %00111
    .byt %00100
    .byt %00110
    .byt %00100
    .byt %00111
    ; 4
    .byt %00101
    .byt %00101
    .byt %00111
    .byt %00100
    .byt %00100
    ; 5
    .byt %00111
    .byt %00001
    .byt %00111
    .byt %00100
    .byt %00111
    ; 6
    .byt %00111
    .byt %00001
    .byt %00111
    .byt %00101
    .byt %00111
    ; 7
    .byt %00111
    .byt %00100
    .byt %00100
    .byt %00100
    .byt %00100
    ; 8
    .byt %00111
    .byt %00101
    .byt %00111
    .byt %00101
    .byt %00111
    ; 9
    .byt %00111
    .byt %00101
    .byt %00111
    .byt %00100
    .byt %00111

    ; 10
    .byt %11101
    .byt %10101
    .byt %10101
    .byt %10101
    .byt %11101

    ; J
    .byt %00100
    .byt %00100
    .byt %00100
    .byt %00101
    .byt %00111
    ; Q
    .byt %00110
    .byt %01001
    .byt %01001
    .byt %00101
    .byt %01010
    ; K
    .byt %01001
    .byt %00101
    .byt %00011
    .byt %00101
    .byt %01001


_Symbols

;
; Small symbols as displayed under the card names
;
symbols_5x5
    ; Heart
    .byt %01010
    .byt %11111
    .byt %11111
    .byt %01110
    .byt %00100

    ; Diamond
    .byt %00100
    .byt %01110
    .byt %11111
    .byt %01110
    .byt %00100

    ; Spade
    .byt %00100
    .byt %01110
    .byt %11111
    .byt %11111
    .byt %01110

    ; Club
    .byt %01110
    .byt %10101
    .byt %11111
    .byt %10101
    .byt %01110


symbols_7x7
    ; Heart
    .byt %0110110
    .byt %1111111
    .byt %1111111
    .byt %1111111
    .byt %0111110
    .byt %0011100
    .byt %0001000

    ; Diamond
    .byt %0001000
    .byt %0011100
    .byt %0111110
    .byt %1111111
    .byt %0111110
    .byt %0011100
    .byt %0001000

    ; Spade
    .byt %0001000
    .byt %0011100
    .byt %0111110
    .byt %1111111
    .byt %1111111
    .byt %1001001
    .byt %0011100

    ; Club
    .byt %0011100
    .byt %0011100
    .byt %1101011
    .byt %1111111
    .byt %1101011
    .byt %0001000
    .byt %0011100


; 13x16 pictures
_Heads
heads_Jack
    .byt %1111100
    .byt %1111110
    .byt %1111111
    .byt %1111111
    .byt %1100011
    .byt %1000001
    .byt %0011101
    .byt %0000001
    .byt %1011001
    .byt %1010001
    .byt %1000001
    .byt %0000001
    .byt %1100010
    .byt %0000100
    .byt %0001000
    .byt %1110000

heads_Queen
    .byt %1000010
    .byt %1100110
    .byt %1111110
    .byt %1111111
    .byt %1110111
    .byt %1000011
    .byt %0011001
    .byt %0000101
    .byt %0011001
    .byt %1010001
    .byt %1000010
    .byt %0000010
    .byt %1100100
    .byt %1001000
    .byt %0010000
    .byt %1100000

heads_King
    .byt %0010001
    .byt %0111011
    .byt %1111111
    .byt %1111111
    .byt %0000001
    .byt %0000011
    .byt %0011101
    .byt %0100001
    .byt %0011001
    .byt %1010001
    .byt %1000011
    .byt %0000011
    .byt %1100110
    .byt %0010100
    .byt %1111000
    .byt %1110000


_CardDataDescription
cardData1
    .byt 7,symbols_7x7-_GrafixStart_
    .byt 255    ; Mirror
    .byt 8,14*4
    .byt 0

cardData2
    .byt 7,symbols_7x7-_GrafixStart_
    .byt 10,5*4
    .byt 255    ; Mirror
    .byt 0

cardData3
    .byt 7,symbols_7x7-_GrafixStart_
    .byt 10,5*4
    .byt 255    ; Mirror
    .byt 8,15*4
    .byt 0

cardData4
    .byt 7,symbols_7x7-_GrafixStart_
    .byt 7,5*4
    .byt 15,5*4
    .byt 255    ; Mirror
    .byt 0

cardData5
    .byt 7,symbols_7x7-_GrafixStart_
    .byt 7,5*4
    .byt 15,5*4
    .byt 255    ; Mirror
    .byt 8,15*4
    .byt 0

cardData6
    .byt 7,symbols_7x7-_GrafixStart_
    .byt 7,5*4
    .byt 15,5*4
    .byt 255    ; Mirror
    .byt 5,15*4
    .byt 13,15*4
    .byt 0

cardData7
    .byt 5,symbols_5x5-_GrafixStart_
    .byt 7,4*4
    .byt 15,4*4
    .byt 255    ; Mirror
    .byt 10,10*4
    .byt 5,16*4
    .byt 13,16*4
    .byt 0

cardData8
    .byt 5,symbols_5x5-_GrafixStart_
    .byt 7,4*4
    .byt 15,4*4
    .byt 10,10*4
    .byt 255    ; Mirror
    .byt 5,16*4
    .byt 13,16*4
    .byt 0

cardData9
    .byt 5,symbols_5x5-_GrafixStart_
    .byt 7,4*4
    .byt 15,4*4
    .byt 6,10*4
    .byt 14,10*4
    .byt 255    ; Mirror
    .byt 10,16*4
    .byt 0

cardData10
    .byt 5,symbols_5x5-_GrafixStart_
    .byt 8,3*4
    .byt 16,3*4
    .byt 11,8*4
    .byt 6,12*4
    .byt 14,12*4
    .byt 255    ; Mirror
    .byt 0

cardDataJack
    .byt 16,heads_Jack-_GrafixStart_
    .byt 9,2*4
    .byt 128|14,2*4
    .byt 255    ; Mirror
    .byt 0

cardDataQueen
    .byt 16,heads_Queen-_GrafixStart_
    .byt 9,2*4
    .byt 128|14,2*4
    .byt 255    ; Mirror
    .byt 0

cardDataKing
    .byt 16,heads_King-_GrafixStart_
    .byt 9,2*4
    .byt 128|14,2*4
    .byt 255    ; Mirror
    .byt 0


_CursorBase
cursorFilled
    .byt 64|128|%000001,%100000|64|128
    .byt 64|128|%000011,%110000|64|128
    .byt 64|128|%000111,%111000|64|128
    .byt 64|128|%001111,%111100|64|128

cursorHollow
    .byt 64|128|%000001,%100000|64|128
    .byt 64|128|%000010,%010000|64|128
    .byt 64|128|%000100,%001000|64|128
    .byt 64|128|%001111,%111100|64|128

cursorDelete
    .byt 64|128|%000000,%000000|64|128
    .byt 64|    %111111,%111111|64
    .byt 64|128|%000000,%000000|64|128
    .byt 64|    %111111,%111111|64



; 9 cards fit with 12
_CardsSpacing
    .byt 12
    .byt 12
    .byt 12
    .byt 12
    .byt 12
    .byt 12
    .byt 12
    .byt 12
    .byt 10
    .byt 10
    .byt 8
    .byt 8
    .byt 8
    .byt 6
    .byt 6
    .byt 6


messageGameNumber       .byt 32,32,32,1,"Game",3,"#12345",0

_Tokens
messageTo               .byt 7,"to ",0
messageEnter            .byt 3,"Enter",0
messageEscape           .byt 3,"Escape",0
messageArrows           .byt 3,"Arrows",0
messageNumbers          .byt 3,"Numbers",0
messageCongratulation   .byt 14,16+2,5,"   Congratulations, you've won!",13

messageSelect           .byt "select ",0
messageTheCard          .byt "the card",0
messageValidate         .byt "validate",0
messageQuitTheGame      .byt "quit the game",13
messageConfirmQuit      .byt "confirm quitting",13
messageGoBack           .byt "go back to game",13
messageTypeAGame        .byt "type a game",3,"ESC",7,"to randomize",13
messageDestination      .byt "destination",13

message_Undo            .byt 3,"U",7,"to Undo",13
message_Redo            .byt 3,"R",7,"to Redo"
messageCRLF             .byt 13
messageSpace5           .byt 32
messageSpace4           .byt 32
messageSpace3           .byt 32
messageSpace2           .byt 32
messageSpace1           .byt 32
                        .byt 0
messageCopyright        .byt 12,16+4,2,"FreeCellOric - ",96," Defence-Force 2013",13


_Messages
textPresentation
    .byt messageCopyright-_Tokens			;.byt 12,16+4,2,"FreeCellOric - ",96," Defence-Force 2013",13
    .byt messageNumbers-_Tokens				;.byt 3,"Numbers",7,"to type a game",3,"ESC",7,"to randomize",13
    .byt messageTo-_Tokens
    .byt messageTypeAGame-_Tokens
    .byt messageEnter-_Tokens				;.byt 3,"Enter",7,"to validate"
    .byt messageTo-_Tokens
    .byt messageValidate-_Tokens
    .byt 255

textWon
    .byt messageCopyright-_Tokens			;.byt 16,16+4,2,"FreeCellOric - ",96," Defence-Force 2013",13
    .byt messageCongratulation-_Tokens		;.byt 14,16+2,5,"   Congratulations, you've won!",13
    .byt messageCongratulation-_Tokens		;.byt 14,16+2,5,"   Congratulations, you've won!",13
    .byt 255

textSelectCard
    .byt messageArrows-_Tokens				;.byt 3,"Arrow keys",7,"to select the card"
    .byt messageTo-_Tokens
    .byt messageSelect-_Tokens
    .byt messageTheCard-_Tokens
    .byt messageSpace4-_Tokens
textUndo
    .byt messageCRLF-_Tokens				;.byt 3,"U",7,"to Undo",13
    .byt messageEnter-_Tokens				;.byt 3,"Enter",7,"or",3,"Space",7,"to validate   "
    .byt messageTo-_Tokens
    .byt messageValidate-_Tokens
    .byt messageSpace5-_Tokens
    .byt messageSpace5-_Tokens
textRedo
    .byt messageCRLF-_Tokens				;.byt 3,"R",7,"to Redo",13
    .byt messageEscape-_Tokens				;.byt 3,"Escape",7,"to quit the game"
    .byt messageTo-_Tokens
    .byt messageQuitTheGame-_Tokens
    .byt 254

textSelectDestination
    .byt messageArrows-_Tokens				;.byt 3,"Arrow keys",7,"to select the destination",13
    .byt messageTo-_Tokens
    .byt messageSelect-_Tokens
    .byt messageDestination-_Tokens
    .byt messageEnter-_Tokens				;.byt 3,"Enter",7,"or",3,"Space",7,"to validate",13
    .byt messageTo-_Tokens
    .byt messageValidate-_Tokens
    .byt messageCRLF-_Tokens
    .byt messageEscape-_Tokens				;.byt 3,"Escape",7,"to cancel"
    .byt messageTo-_Tokens
    .byt messageQuitTheGame-_Tokens
    .byt 254

textConfirmQuit
    .byt messageEnter-_Tokens				;.byt 3,"Enter",7,"to confirm quitting",13
    .byt messageTo-_Tokens
    .byt messageConfirmQuit-_Tokens
    .byt messageEscape-_Tokens				;.byt 3,"Escape",7,"to go back to game"
    .byt messageTo-_Tokens
    .byt messageGoBack-_Tokens
    .byt 254

_TextEnd_

_TwilighteLogo
    .byt $40,$40,$4f,$40,$40,$40,$40,$40,$40,$41,$40,$40,$40,$40,$40,$40
    .byt $70,$40,$40,$40,$40,$40,$43,$7f,$7e,$40,$40,$40,$40,$40,$47,$60
    .byt $40,$40,$40,$40,$43,$78,$40,$40,$40,$40,$40,$4f,$7f,$7c,$40,$40
    .byt $40,$40,$40,$4c,$60,$40,$40,$40,$40,$47,$48,$40,$40,$40,$40,$40
    .byt $5c,$40,$78,$40,$40,$40,$40,$40,$5c,$60,$40,$40,$40,$40,$4e,$48
    .byt $40,$40,$40,$40,$40,$70,$40,$40,$40,$40,$40,$41,$78,$78,$60,$7c
    .byt $40,$40,$40,$5e,$48,$40,$40,$40,$40,$41,$60,$41,$40,$40,$40,$40
    .byt $43,$70,$78,$61,$78,$40,$40,$40,$7c,$50,$40,$78,$40,$40,$41,$40
    .byt $46,$40,$40,$40,$40,$43,$61,$71,$41,$70,$40,$40,$40,$7c,$50,$41
    .byt $70,$40,$40,$43,$40,$4c,$40,$40,$40,$40,$40,$41,$71,$40,$40,$40
    .byt $40,$41,$78,$60,$41,$70,$40,$40,$43,$40,$5c,$40,$40,$40,$40,$40
    .byt $41,$72,$40,$40,$40,$40,$41,$78,$60,$43,$70,$40,$40,$47,$40,$5c
    .byt $40,$40,$40,$40,$40,$43,$62,$40,$40,$40,$40,$43,$71,$40,$43,$63
    .byt $40,$40,$47,$60,$5c,$40,$40,$40,$48,$40,$43,$64,$40,$40,$43,$60
    .byt $43,$72,$4c,$43,$7e,$41,$78,$43,$60,$7c,$47,$43,$70,$5c,$4e,$43
    .byt $64,$47,$40,$4c,$5c,$43,$72,$7c,$47,$78,$46,$5c,$41,$40,$7c,$4f
    .byt $43,$70,$7c,$4e,$47,$68,$47,$40,$58,$4e,$47,$67,$7e,$4f,$70,$4c
    .byt $5e,$40,$40,$7c,$4e,$43,$60,$78,$4e,$47,$48,$47,$40,$70,$4f,$47
    .byt $6c,$5c,$7f,$40,$5c,$5e,$40,$40,$7c,$5e,$47,$61,$78,$5e,$47,$70
    .byt $4f,$41,$70,$4e,$47,$78,$5c,$47,$40,$58,$5e,$40,$40,$78,$5e,$47
    .byt $61,$78,$5c,$47,$60,$4e,$43,$60,$5e,$47,$60,$7c,$4f,$40,$78,$7c
    .byt $40,$40,$78,$5e,$47,$41,$78,$5c,$47,$40,$4e,$43,$60,$5e,$47,$60
    .byt $78,$4e,$40,$78,$78,$40,$40,$78,$5c,$47,$41,$70,$5c,$4f,$40,$4e
    .byt $43,$60,$5c,$47,$41,$78,$4e,$40,$79,$60,$40,$40,$78,$5c,$47,$40
    .byt $70,$5c,$4f,$40,$4e,$47,$60,$7c,$4f,$41,$78,$4e,$41,$7e,$40,$48
    .byt $40,$70,$7c,$4f,$40,$60,$7c,$4f,$40,$5e,$47,$60,$7c,$4f,$41,$70
    .byt $5e,$41,$78,$40,$58,$41,$70,$7c,$4f,$40,$73,$7c,$5f,$40,$7e,$4f
    .byt $61,$7c,$5f,$41,$70,$7e,$43,$7c,$41,$78,$41,$60,$7c,$4f,$41,$4c
    .byt $7c,$67,$43,$5e,$57,$72,$7c,$6f,$43,$71,$5e,$44,$7c,$46,$5c,$43
    .byt $40,$5e,$57,$62,$40,$7f,$47,$7e,$5f,$63,$7c,$7b,$4f,$43,$7e,$4f
    .byt $78,$7f,$7c,$4e,$44,$40,$5f,$63,$7c,$40,$5e,$47,$78,$4f,$43,$78
    .byt $7c,$4f,$41,$7c,$4f,$70,$5f,$70,$43,$78,$40,$46,$41,$70,$40,$4c
    .byt $41,$60,$44,$41,$61,$78,$40,$40,$70,$46,$40,$47,$40,$40,$40,$40
    .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$47,$70,$40,$40,$40,$40,$40
    .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$59,$70
    .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt $40,$40,$40,$61,$70,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt $40,$40,$40,$40,$40,$40,$40,$41,$43,$60,$40,$40,$40,$40,$40,$40
    .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$42,$43,$60,$40
    .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt $40,$42,$43,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt $40,$40,$40,$40,$40,$40,$42,$46,$40,$40,$40,$40,$40,$40,$40,$40
    .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$41,$4c,$40,$40,$40
    .byt $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt $40,$70,$40,$40,$40,$40,$40,$40,$40,$40



    .bss
    .dsb 256-(*&255)        ; Allign the content of BSS section to a byte boudary

_BssStart_

_TableDiv6                  .dsb 256
_TableBit6Reverse           .dsb 256
_TableBit6NoMirror          .dsb 256            ; Stupid table that does not do anything, it's a perfect neutral lookup
_TableBit6Mirror            .dsb 256            ; Table that contains the 6 lower bits mirrored.

_Cards                      .dsb 256*53         	; 13568 bytes (53 cards, the last one is the empty cell graphics). We use only 148 bytes (4*37) per card, but for performance/alignment reasons we just decided to cheat :)

_CardSlots                  .dsb MAXCOL*MAXPOS*2	; 256 bytes actually, only the first 128 matter, the 128 copy is just here to help handling the cells and foundations in the same way.
_UndoBufferFrom             .dsb 256
_UndoBufferTo               .dsb 256

_BssEnd_

