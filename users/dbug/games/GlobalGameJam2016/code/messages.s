
	.zero

_PrintScreenPtr		.dsb 2 		; Location of the place where we print the text
_PrintMessagePtr	.dsb 2      ; The address of the message to display

	.text

_MessagePressFireToStart
	.byt 14,3,"Press Fire To Start",0

_MessageTodayBestScores
	.byt 5,"Today's best scores",0

_MessageGameStory
	.byt 5,"The game story",0

_MessageGameMenu
	.byt 5,"Game Menu",0

_MessageCopyright       .byt 2,96, " 1985 Mickael Pointier and Friends",0

_MessageCurrentLocation	.byt 3,"Currently at:",6,0
_MessageNextLocation	.byt 3,"Now, go to:",6,0
_MessageAlreadyVisited  .byt " (Done)",0

_MessageVisitedPlaces   .byt 2,"+200 per visited location",0
_MessageRemainingMoney  .byt 2,"+amount of money remaining",0

_MessageTime			.byt " 00:00",0

_MessageMoney			.byt "Money",0
_MessageMoneyBalance    .byt 2,"9999 nok",0

_MessageMood 			.byt "Mood",0
_MessageMoodHappy 		.byt 2,"Happy",0
_MessageMoodBored 		.byt 3,"Bored",0
_MessageMoodAnnoyed		.byt 1,"Annoyed",0

_MessageEnergy			.byt "Energy",0
_MessageEnergyFresh		.byt 2,"Fresh",0
_MessageEnergyTired		.byt 3,"Tired",0
_MessageEnergyHungry	.byt 3,"Hungry",0
_MessageEnergyThirsty	.byt 3,"Thirsty",0

_MessageWhatDoWeDoNow1	.byt 3,"What Do",0
_MessageWhatDoWeDoNow2	.byt 3," We Do",0
_MessageWhatDoWeDoNow3	.byt 3,"  Now",0
_MessageWhatDoWeDoNow4	.byt 3,"   ?",0

_MessageActionLeave		.byt 5,"Leave",0
_MessageActionDiscover	.byt 5,"Visit",0
_MessageActionEat		.byt 5,"Eat",0
_MessageActionDrink		.byt 5,"Drink",0
_MessageActionRest		.byt 5,"Rest",0
_MessageActionBuyPass	.byt 5,"Buy Pass",0
_MessageActionGoAirport	.byt 5,"Airport",0      ; Not yet decided
_MessageActionGiveUp	.byt 1,"Give Up",0

_MessageTotalScore      .byt 2,"Your final Score is:",0
_MessageScoreValue      .byt 1,"00000",0          ; 5 digits score

_ActionList_Low .byt <_MessageActionLeave,<_MessageActionDiscover,<_MessageActionEat,<_MessageActionDrink,<_MessageActionRest,<_MessageActionBuyPass,<_MessageActionGoAirport,<_MessageActionGiveUp
_ActionList_High .byt >_MessageActionLeave,>_MessageActionDiscover,>_MessageActionEat,>_MessageActionDrink,>_MessageActionRest,>_MessageActionBuyPass,>_MessageActionGoAirport,>_MessageActionGiveUp



#define METADATA_STORAGE
#include "floppy_description.h"
#undef METADATA_STORAGE


; Initialise the file number with _LoaderApiEntryIndex
; Initialise the location where to print in _PrintScreenPtr

_PrintLocationText
.(
	; Start by creating the description in the buffer
	ldy _LoaderApiEntryIndex	
	lda _MetaData_name_Low,y
	sta _PrintMessagePtr+0
	lda _MetaData_name_High,y
	sta _PrintMessagePtr+1
	jmp _PrintSelectedText
.)

_PrintText
.(
	; Start by creating the description in the buffer
	ldy _LoaderApiEntryIndex	
	lda _MetaData_description_Low,y
	sta _PrintMessagePtr+0
	lda _MetaData_description_High,y
	sta _PrintMessagePtr+1
.)
_PrintSelectedText
.(
	ldy #0
	ldx #0
loop_name
	lda (_PrintMessagePtr),y
	beq end_name
	sta (_PrintScreenPtr),y
	;iny

	.(
	inc _PrintMessagePtr+0
	bne skip
	inc _PrintMessagePtr+1
skip	
	.)

	clc
	lda _PrintScreenPtr+0
	adc #1
	sta _PrintScreenPtr+0
	lda _PrintScreenPtr+1
	adc #0
	sta _PrintScreenPtr+1

	inx
	bne loop_name	
end_name
	rts
.)

; Same thing, but in HIRES mode instead of TEXT
_PrintHires
.(
	; Start by creating the description in the buffer
	ldy _LoaderApiEntryIndex	
	lda _MetaData_name_Low,y
	sta _PrintMessagePtr+0
	lda _MetaData_name_High,y
	sta _PrintMessagePtr+1

+_PrintHiresInternal
	ldx #0
loop_name
	ldy #0
	lda (_PrintMessagePtr),y
	beq end_name

	sta tmp1+0
	lda #0
	sta tmp1+1

	asl tmp1+0 	; x2
	rol tmp1+1 

	asl tmp1+0 	; x4
	rol tmp1+1 

	asl tmp1+0 	; x8
	rol tmp1+1 

	clc
	lda tmp1+0
	adc #<$9800
	sta tmp1+0

	lda tmp1+1
	adc #>$9800
	sta tmp1+1

	clc
	lda _PrintScreenPtr+0
	sta tmp2+0
	adc #1
	sta _PrintScreenPtr+0
	lda _PrintScreenPtr+1
	sta tmp2+1
	adc #0
	sta _PrintScreenPtr+1

	ldx #8
	ldy #0
loop	
	lda (tmp1),y
	sta (tmp2),y

	.(
	inc tmp1+0
	bne skip
	inc tmp1+1
skip	
	.)

	.(
	clc
	lda tmp2+0
	adc #40
	sta tmp2+0
	bcc skip
	inc tmp2+1
skip	
	.)

	dex
	bne loop
	
	.(
	inc _PrintMessagePtr+0
	bne skip
	inc _PrintMessagePtr+1
skip	
	.)

	jmp loop_name	
end_name
	rts
.)

