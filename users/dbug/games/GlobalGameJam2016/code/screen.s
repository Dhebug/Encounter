
#include "floppy_description.h"
#include "defines.h"

	.zero

_ShowingOsloMap		.dsb 1      ; For the screen UI, to decided between showing a location or the Oslo map
_OsloLocation		.dsb 1 		; This maps to the various locations for which we have pictures and descriptions
_NextLocation       .dsb 1      ; The location the player wants to move to (initialized to be _OsloLocation on the move screen)
_AvailableActions	.dsb 1 		; It's a bit mask, which define which of our 8 possible actions are available - used to draw them on screen
_GameOver           .dsb 1      ; Set to non null if a failure condition happens
_VisitedLocationCount .dsb 1    ; How many places were visited

_CurrentMenuAction  .dsb 1      ; Number between 0 and 7 indicating which option is currently selected by the player

_PlayerHasOsloPass  .dsb 1      ; The Oslo pass is expensive, but with it you don't need to pay anything after
_MoneyToSpend       .dsb 1      ; Write the value, and then call "SpendMoney"
_TimeToSpend        .dsb 1      ; Write the value, and then call "SpendTime"
_ScoreToAdd         .dsb 1      ; Value to add to the current score

_DateDay        	.dsb 1 		; Only two values: Saturday and Sunday (not used at the moment)
current_action      .dsb 1
action_shifter      .dsb 1

	.text

_VisitedLocations   .dsb LOADER_LOCATION_LAST-LOADER_LOCATION_FIRST;

_InitialiseGame
.(
	lda #0
	sta _ShowingOsloMap
	sta _PlayerHasOsloPass
	sta _VisitedLocationCount

	lda #GAMEOVER_STILL_OK
	sta _GameOver

	; Give the player 999 nok (to be balanced)
	ldx #"0"
	stx _MessageMoneyBalance+1;
	ldx #"9"
	stx _MessageMoneyBalance+2;
	stx _MessageMoneyBalance+3;
	stx _MessageMoneyBalance+4;

	; Set the score to zero
	;_MessageScoreValue      .byt 1,"00000",0          ; 5 digits score
	ldx #"0"
	stx _MessageScoreValue+1;
	stx _MessageScoreValue+2;
	stx _MessageScoreValue+3;
	stx _MessageScoreValue+4;
	stx _MessageScoreValue+5;

	ldx #LOADER_LOCATION_LAST-LOADER_LOCATION_FIRST;
loop	
	lda #0
	sta _VisitedLocations-1,x
	dex
	bne loop

	lda #LOADER_LOCATION_OSLOS
	sta _OsloLocation

	jsr _InitialiseDate

	rts
.)




_InitialiseFontColors
.(
	lda #0
	tax
loop_attribute	
	ldy #8
loop	
	sta $9800,x
	inx
	dey
	bne loop

	clc
	adc #1
	cmp #24
	bne loop_attribute

	rts
.)

_InitialiseDate
.(
	lda #0
	sta _DateDay        

	lda #"0"
	sta _MessageTime+1
	sta _MessageTime+2
	sta _MessageTime+4
	sta _MessageTime+5
	rts
.)	


_ShowScore
.(
	lda #<$bb80+40*26+4
	sta _PrintScreenPtr+0
	lda #>$bb80+40*26+4
	sta _PrintScreenPtr+1

	lda #<_MessageTotalScore
	sta _PrintMessagePtr+0
	lda #>_MessageTotalScore
	sta _PrintMessagePtr+1

	jsr _PrintSelectedText


	lda #<_MessageScoreValue
	sta _PrintMessagePtr+0
	lda #>_MessageScoreValue
	sta _PrintMessagePtr+1
	
	jsr _PrintSelectedText

	rts
.)


_WaitASecond
.(
	ldx #50
loop	
	jsr _VSync
	dex
	bne loop
	rts
.)

_ComputeScore
.(
	;jsr _IncrementScore
	jsr _ShowScore

	jsr _WaitASecond
	jsr _WaitASecond

	; Add 200 points for each visited location
	lda #<$bb80+40*25+2
	sta _PrintScreenPtr+0
	lda #>$bb80+40*25+2
	sta _PrintScreenPtr+1

	lda #<_MessageVisitedPlaces
	sta _PrintMessagePtr+0
	lda #>_MessageVisitedPlaces
	sta _PrintMessagePtr+1

	jsr _PrintSelectedText

	jsr _WaitASecond
	.(
loop	
	lda _VisitedLocationCount
	beq done
	dec _VisitedLocationCount
	lda #200
	sta _ScoreToAdd
	jsr _AddToScore
	jmp loop
done
	lda #0
    .)	
	jsr _WaitASecond
	sta $bb80+40*25+2
	jsr _WaitASecond


	; Add the remaining money
	lda #<$bb80+40*25+2
	sta _PrintScreenPtr+0
	lda #>$bb80+40*25+2
	sta _PrintScreenPtr+1

	lda #<_MessageRemainingMoney
	sta _PrintMessagePtr+0
	lda #>_MessageRemainingMoney
	sta _PrintMessagePtr+1

	jsr _PrintSelectedText

	jsr _WaitASecond
	.(
	lda _GameOver
	cmp GAMEOVER_NO_MORE_MONEY
	beq done       ; The player was already out of money

	lda #0
	sta _GameOver  ; We reset the game over flag, so we can detect when we run out of money...
	
loop	
	jsr _DecrementMoneyNoDisplay
	lda _GameOver
	bne done
	jsr _IncrementScore
	jmp loop
done
	lda #0
    .)	
	jsr _WaitASecond
	sta $bb80+40*25+2
	jsr _WaitASecond


	rts
.)


_AddToScore
.(
loop	
	lda _ScoreToAdd
	beq done
	dec _ScoreToAdd
	jsr _IncrementScore
	jmp loop
done
	rts
.)


_IncrementScore
.(
	jsr _IncrementScoreNoDisplay
	rts
.)

_IncrementScoreNoDisplay
.(
	; Lower digit of score
	inc _MessageScoreValue+5
	lda _MessageScoreValue+5
	cmp #":"
	bne done
	lda #"0"
	sta _MessageScoreValue+5

	; Secod digit of score
	inc _MessageScoreValue+4
	lda _MessageScoreValue+4
	cmp #":"
	bne done
	lda #"0"
	sta _MessageScoreValue+4

	; Third digit of score
	inc _MessageScoreValue+3
	lda _MessageScoreValue+3
	cmp #":"
	bne done
	lda #"0"
	sta _MessageScoreValue+3

	; Fourth digit of score
	inc _MessageScoreValue+2
	lda _MessageScoreValue+2
	cmp #":"
	bne done
	lda #"0"
	sta _MessageScoreValue+2

	; Fifth digit of score
	inc _MessageScoreValue+1
	lda _MessageScoreValue+1
	cmp #":"
	bne done
	lda #"0"
	sta _MessageScoreValue+1

done	
	jsr _ShowScore

	rts	
.)

_IncrementTime
.(
	lda _GameOver
	bne skip_increment

	; Lower digit of minutes
	inc _MessageTime+5
	lda _MessageTime+5
	cmp #":"
	bne done
	lda #"0"
	sta _MessageTime+5

	; Higher digit of minutes
	inc _MessageTime+4
	lda _MessageTime+4
	cmp #"6"
	bne done
	lda #"0"
	sta _MessageTime+4

	; Lower digit of hours
	inc _MessageTime+2
	lda _MessageTime+2
	cmp #":"
	bne done
	lda #"0"
	sta _MessageTime+2

	; Higher digit of hours
	inc _MessageTime+1
	lda _MessageTime+1
	cmp #":"
	bne done
	lda #"0"
	sta _MessageTime+1

done	
	jsr _ShowTimeOfTheDay

	lda _MessageTime+1
	cmp #"4"
	bne skip_increment
	lda _MessageTime+2
	cmp #"8"
	bne skip_increment

	; The player has lost: He ran out of time
	lda #GAMEOVER_TIME_UP
	sta _GameOver


skip_increment	
	rts
.)


_ShowTimeOfTheDay
.(
	; Set some colors on the screen
	lda #<$a000+40*1
	sta tmp1+0
	lda #>$a000+40*1
	sta tmp1+1

	ldx #8
loop
	lda #16+4
	ldy #0
	sta (tmp1),y
	lda #6
	iny
	sta (tmp1),y
	jsr Add40Tmp1
	dex
	bne loop

	; Display the day
	lda #<$a000+40*1+2
	sta _PrintScreenPtr+0
	lda #>$a000+40*1+2
	sta _PrintScreenPtr+1

	;lda #<_MessageSaturday
	;sta _PrintMessagePtr+0
	;lda #>_MessageSaturday
	;sta _PrintMessagePtr+1

	;jsr _PrintHiresInternal

	; Display the time of the day
	
	;lda #<$a000+40*1+2
	;sta _PrintScreenPtr+0
	;lda #>$a000+40*1+2
	;sta _PrintScreenPtr+1

	lda #<_MessageTime
	sta _PrintMessagePtr+0
	lda #>_MessageTime
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal

	rts
.)


/*
_MessageMoney
	.byt "Money",0

_MessageMood
	.byt "Mood",0

_MessageEnergy
	.byt "Energy",0
*/

; 198 lines, starting at position 29
_ShowPlayerStatus
.(
    /*
	; Display the Mood
	lda #<$a000+40*2+30+1
	sta _PrintScreenPtr+0
	lda #>$a000+40*2+30+1
	sta _PrintScreenPtr+1

	lda #<_MessageMood
	sta _PrintMessagePtr+0
	lda #>_MessageMood
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal


	lda #<$a000+40*11+30+2
	sta _PrintScreenPtr+0
	lda #>$a000+40*11+30+2
	sta _PrintScreenPtr+1

	lda #<_MessageMoodHappy
	sta _PrintMessagePtr+0
	lda #>_MessageMoodHappy
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal


	; Display the Energy
	lda #<$a000+40*30+30+1
	sta _PrintScreenPtr+0
	lda #>$a000+40*30+30+1
	sta _PrintScreenPtr+1

	lda #<_MessageEnergy
	sta _PrintMessagePtr+0
	lda #>_MessageEnergy
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal

	lda #<$a000+40*39+30+3
	sta _PrintScreenPtr+0
	lda #>$a000+40*39+30+3
	sta _PrintScreenPtr+1

	lda #<_MessageEnergyTired
	sta _PrintMessagePtr+0
	lda #>_MessageEnergyTired
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal
	*/


	; Display the Money
	lda #<$a000+40*60+30+1
	sta _PrintScreenPtr+0
	lda #>$a000+40*60+30+1
	sta _PrintScreenPtr+1

	lda #<_MessageMoney
	sta _PrintMessagePtr+0
	lda #>_MessageMoney
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal

	jsr _ShowMoney

	rts
.)


_ShowMoney
.(
	lda #<$a000+40*69+30+1
	sta _PrintScreenPtr+0
	lda #>$a000+40*69+30+1
	sta _PrintScreenPtr+1

	lda #<_MessageMoneyBalance
	sta _PrintMessagePtr+0
	lda #>_MessageMoneyBalance
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal
	rts
.)


; _MessageMoneyBalance    .byt 2,"9999 nok",0

_DecrementMoney
.(
	lda _GameOver
	bne skip_decrement
	jsr _DecrementMoneyNoDisplay
	jsr _ShowMoney
skip_decrement	
	rts
.)

_DecrementMoneyNoDisplay
.(
	lda _GameOver
	bne skip
	; /0123456789

	; 4th digit
	ldx _MessageMoneyBalance+4;
	dex
	stx _MessageMoneyBalance+4;
	cpx #"/"
	bne skip
	ldx #"9"
	stx _MessageMoneyBalance+4;

	; 3rd digit
	ldx _MessageMoneyBalance+3;
	dex
	stx _MessageMoneyBalance+3;
	cpx #"/"
	bne skip
	ldx #"9"
	stx _MessageMoneyBalance+3;

	; 2nd digit
	ldx _MessageMoneyBalance+2;
	dex
	stx _MessageMoneyBalance+2;
	cpx #"/"
	bne skip
	ldx #"9"
	stx _MessageMoneyBalance+2;

	; 1st digit
	ldx _MessageMoneyBalance+1;
	dex
	stx _MessageMoneyBalance+1;
	cpx #"/"
	bne skip
	ldx #"0"
	stx _MessageMoneyBalance+1;

	; The player has lost: His money is depleted
	lda #GAMEOVER_NO_MORE_MONEY
	sta _GameOver

skip	
	rts
.)



_SpendMoney
.(
loop	
	lda _MoneyToSpend
	beq done
	dec _MoneyToSpend
	jsr _DecrementMoney
	jmp loop
done
	rts
.)


_SpendTime
.(
loop	
	lda _TimeToSpend
	beq done
	dec _TimeToSpend
	jsr _IncrementTime
	jmp loop
done
	rts
.)


; 198 lines, starting at position 29
; Shows the "What Do We Do Now?" message, plus the various options
_ShowActionMenu
.(
	lda #<$a000+40*94+30+0
	sta _PrintScreenPtr+0
	lda #>$a000+40*94+30+0
	sta _PrintScreenPtr+1

	lda #<_MessageWhatDoWeDoNow1
	sta _PrintMessagePtr+0
	lda #>_MessageWhatDoWeDoNow1
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal

	lda #<$a000+40*102+30+0
	sta _PrintScreenPtr+0
	lda #>$a000+40*102+30+0
	sta _PrintScreenPtr+1

	lda #<_MessageWhatDoWeDoNow2
	sta _PrintMessagePtr+0
	lda #>_MessageWhatDoWeDoNow2
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal

	lda #<$a000+40*110+30+0
	sta _PrintScreenPtr+0
	lda #>$a000+40*110+30+0
	sta _PrintScreenPtr+1

	lda #<_MessageWhatDoWeDoNow3
	sta _PrintMessagePtr+0
	lda #>_MessageWhatDoWeDoNow3
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal

	lda #<$a000+40*118+30+0
	sta _PrintScreenPtr+0
	lda #>$a000+40*118+30+0
	sta _PrintScreenPtr+1

	lda #<_MessageWhatDoWeDoNow4
	sta _PrintMessagePtr+0
	lda #>_MessageWhatDoWeDoNow4
	sta _PrintMessagePtr+1

	jsr _PrintHiresInternal



	; Force enabling all the options
	;lda #1+128
	;sta _AvailableActions

	lda _AvailableActions
	sta action_shifter

	lda #0
	sta current_action

	lda #<$a000+40*127+30+0
	sta tmp3+0
	lda #>$a000+40*127+30+0
	sta tmp3+1

loop
	lsr action_shifter
	bcc skip_entry

	clc
	lda tmp3+0
	sta _PrintScreenPtr+0
	adc #<40*9
	sta tmp3+0

	lda tmp3+1
	sta _PrintScreenPtr+1
	adc #>40*9
	sta tmp3+1

	ldy current_action	
	lda _ActionList_Low,y
	sta _PrintMessagePtr+0
	lda _ActionList_High,y
	sta _PrintMessagePtr+1

	; Highlight the current menu entry
	ldy #0
	lda (_PrintMessagePtr),y
	sta __auto_color_patch+1
	lda _PrintMessagePtr+0
	sta __auto_addr_patch+1
	lda _PrintMessagePtr+1
	sta __auto_addr_patch+2

	.(
	lda _CurrentMenuAction
	cmp current_action
	bne skip_highlight
	lda #(16+2)
	sta (_PrintMessagePtr),y
skip_highlight	
	.)

	jsr _PrintHiresInternal

	; Restore the previous message color
	ldy #0
__auto_color_patch	
	lda #$12
__auto_addr_patch		
	sta $1234


skip_entry
	inc current_action
	lda action_shifter
	bne loop

done

	rts
.)


_LocationPosX
	.byt 60				; LOADER_LOCATION_VIGELAND
	.byt 112			; LOADER_LOCATION_OPERA
	.byt 29				; LOADER_LOCATION_HOLMENKOLEN
	.byt 113			; LOADER_LOCATION_OSLOS
	.byt 80				; LOADER_LOCATION_AKERBRYGGE
	.byt 82				; LOADER_LOCATION_KINGCASTLE
	.byt 86				; LOADER_LOCATION_SOGNSVANN
	.byt 48				; LOADER_LOCATION_VIKINGSHIP
	.byt 135			; LOADER_LOCATION_MUNCHMUSEUM
	.byt 79				; LOADER_LOCATION_IBSENMUSEUM
	.byt 35				; LOADER_LOCATION_NORWEGIANFOLK
	.byt 52				; LOADER_LOCATION_KONTIKI
	.byt 93				; LOADER_LOCATION_AKERSHUS
	.byt 100			; LOADER_LOCATION_NATIONALGALLERY
	.byt 131			; LOADER_LOCATION_NATURALHISTORY

_LocationPosY
	.byt 111			; LOADER_LOCATION_VIGELAND
	.byt 145			; LOADER_LOCATION_OPERA
	.byt 30				; LOADER_LOCATION_HOLMENKOLEN
	.byt 139			; LOADER_LOCATION_OSLOS
	.byt 140			; LOADER_LOCATION_AKERBRYGGE
	.byt 124			; LOADER_LOCATION_KINGCASTLE
	.byt 10				; LOADER_LOCATION_SOGNSVANN
	.byt 154			; LOADER_LOCATION_VIKINGSHIP
	.byt 126			; LOADER_LOCATION_MUNCHMUSEUM
	.byt 128			; LOADER_LOCATION_IBSENMUSEUM
	.byt 152			; LOADER_LOCATION_NORWEGIANFOLK
	.byt 155			; LOADER_LOCATION_KONTIKI
	.byt 146			; LOADER_LOCATION_AKERSHUS
	.byt 129			; LOADER_LOCATION_NATIONALGALLERY
	.byt 118			; LOADER_LOCATION_NATURALHISTORY


_TableBitPos
	.byt %100000
	.byt %010000
	.byt %001000
	.byt %000100
	.byt %000010
	.byt %000001

; This will use the _NextLocation variable to show two EORed crossed lines to show where the next location will be
_ShowLocationTarget
.(
	; The picture is 174x180 and displayed from the column zero, starting from the line 10
	sec
	lda _NextLocation
	sbc #LOADER_LOCATION_FIRST
	pha
	tay

	; Draw the horizontal line
	clc
	lda _LocationPosY,y
	adc #10
	tay

	lda _ScreenAddrLow,y
	sta tmp0+0
	lda _ScreenAddrHigh,y
	sta tmp0+1

	ldy #0
loop_x
	lda (tmp0),y
	eor #1+2+4+8+16+32
	sta (tmp0),y
	iny
	cpy #29
	bne loop_x	

	; Draw the vertical line
	pla
	tay
	lda _LocationPosX,y
	pha
	tay

	lda _TableModulo6,y
	tay
	lda _TableBitPos,y
	sta __auto_eor_patch+1

	pla
	tay
	clc
	lda #<$a000+40*10
	adc _TableDivBy6,y
	sta tmp1+0
	lda #>$a000+40*10
	adc #0
	sta tmp1+1

	ldy #0
	ldx #180
loop_y
	lda (tmp1),y
__auto_eor_patch
	eor #1+2+4+8+16+32
	sta (tmp1),y
	jsr Add40Tmp1
	dex
	bne loop_y

	;_TableModulo6
	rts
.)




/*
#define ACTION_LEAVE    0
#define ACTION_DISCOVER 1
#define ACTION_EAT      2
#define ACTION_DRINK    3
#define ACTION_REST     4
#define ACTION_BUY_PASS 5
#define ACTION_AIRPORT 6		; ???
#define ACTION_GIVE_UP  7		; End the game
*/
_GetPossibleActionsForLocation
.(
	; _OsloLocation
	; In all locations we can LEAVE/DISCOVER/GIVEUP
	lda #(1<<ACTION_LEAVE)|(1<<ACTION_DISCOVER)|(1<<ACTION_GIVE_UP)

	.(
	; At Oslo S we can buy an Oslo Pass, but only if we do not have it yet
	ldx _OsloLocation
	cpx #LOADER_LOCATION_OSLOS
	bne skip

	; The option to go to the aiport is a victory condition
	ora #(1<<ACTION_AIRPORT)

	ldx _PlayerHasOsloPass
	bne skip
	ora #(1<<ACTION_BUY_PASS)
skip
	.)

	sta _AvailableActions
	rts
.)


_BuyOsloPass
.(
	; The Oslo Pass costs 470 nok for two days (255+215)
	lda #255
	sta _MoneyToSpend
	jsr _SpendMoney
	lda #215
	sta _MoneyToSpend
	jsr _SpendMoney

	; The playe now has the Oslo pass
	lda #1
	sta _PlayerHasOsloPass
	rts
.)



_VisitLocation
.(
	; Mark this location as visited one more time
	ldx _OsloLocation
	inc _VisitedLocations-LOADER_LOCATION_FIRST,x

	lda _VisitedLocations-LOADER_LOCATION_FIRST,x
	cmp #1
	bne already_visited
	inc _VisitedLocationCount
already_visited

	; We spend one hour visiting a particular location
	lda #60
	sta _TimeToSpend
	jsr _SpendTime

	; If we have the Oslo pass we pay nothing, else we pay a mandatory 120 nok 
	ldx _PlayerHasOsloPass
	bne skip
	lda #129
	sta _MoneyToSpend
	jsr _SpendMoney
skip

	rts
.)


_MoveToNewLocation
.(
	; Spend 30 nok for a metro ticket, except if we have an Oslo pass
	ldx _PlayerHasOsloPass
	bne skip
	lda #30
	sta _MoneyToSpend
	jsr _SpendMoney
skip

	; Amount of time to travel is based on the distance between the two places
	; _NextLocation
	; _OsloLocation

	sec
	lda _OsloLocation
	sbc #LOADER_LOCATION_FIRST
	tay
	lda _LocationPosX,y
	lsr
	sta tmp0+0
	lda _LocationPosY,y
	lsr
	sta tmp0+1

	sec
	lda _NextLocation
	sbc #LOADER_LOCATION_FIRST
	tay
	lda _LocationPosX,y
	lsr
	sta tmp1+0
	lda _LocationPosY,y
	lsr
	sta tmp1+1

	; At this point we have tmp0 with X/Y for the first location, and tmp1 for the X/Y for the second location (divided by two so it fits in 8 bit without overflows)
	/*
	sec
	lda tmp0+0
	sbc tmp1+0
	bmi neg_dx


neg_dx
	*/
	lda #45
	sta _TimeToSpend
	jsr _SpendTime





	; Move to the new location
	lda _NextLocation
	sta _OsloLocation

	rts
.)

/*
Prices:

https://ruter.no/billetter/prisendring/
Ruter single ticket:  30 nok
Ruter day ticket:     90 nok
Ticket control cost: 950 nok

Oslo pass one day:   320 nok
Oslo pass two days:  470 nok

Taxis:
Start from taxi stop: 43 nok
Start from call:      66 nok
Price per kilometer:  13 nok
Price per minute:      6.5 nok
Minimum price:       109 nok

Museums:
(29,30)  - LOADER_LOCATION_HOLMENKOLEN
(86,10)  - Sognsvann
(35,152) -
Fram-Museum:         100 nok (from 10 to 16) - Polar explorers, northwest passage
Munch museum:        100 nok (from 10 to 16) - Also has Van Gogh
Ibsem museum:         85 nok (from 11 to 18) - Henrik Ibsen home in Oslo - Henrik Ibsen, Norwegian  playwright and poet, was born 1828 in Skien and died 1906 in Arbins gate 1, Oslo.  He is recognized as the founder of the modern drama, and alongside William Shakespeare, he is the most performed playwright in the world.
Vigeland museum:      60 nok (from 11 to 16) 
AKERSHUS FESTNING:    50 nok (from 10 to 17)
*/
