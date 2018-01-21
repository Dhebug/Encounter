
;#include "loader_api.h"

	.zero

selected_option		.dsb 1
selected_offset     .dsb 1   ; 0, 40 or 80

day_of_the_week     .dsb 2
	
	.text

#define SET_DAY(message)			lda #<message:sta day_of_the_week+0:lda #>message:sta day_of_the_week+1

#define PRINT_HIRES(message)		lda #0:sta _PrintHiresX:lda #<message:sta _PrintMessagePtr+0:lda #>message:sta _PrintMessagePtr+1:jsr _PrintTextHires
#define PRINT_TEXT(message)			lda #0:sta _PrintScreenX:lda #<message:sta _PrintMessagePtr+0:lda #>message:sta _PrintMessagePtr+1:jsr _PrintSelectedText



_WaitOneSecond
.(
	pha
	txa 
	pha
	ldx #50
loop
	jsr _VSync
	dex
	bne loop

	pla
	tax
	pla
	rts
.)

_WaitThreeSeconds
	rts  ; ----------- comment out in final version
	jsr _WaitOneSecond
	jsr _WaitOneSecond
	jsr _WaitOneSecond
	rts


_GameStart
.(
	;jmp sunday

monday	
	SET_DAY(_MessageMonday)
	jsr _OfficeDay

tuesday
	SET_DAY(_MessageTuesday)
	jsr _HomeOfficeDay

wednesday
	SET_DAY(_MessageWednesday)
	jsr _OfficeDay

thursday
	SET_DAY(_MessageThursday)
	jsr _HomeOfficeDay

friday
	SET_DAY(_MessageFriday)
	jsr _OfficeDay

saturday
	SET_DAY(_MessageSaturday)
	jsr _Saturday

sunday
	SET_DAY(_MessageSunday)
	jsr _Sunday

	jmp _GameStart
.)

_DayIntroSequence
	jsr _WaitThreeSeconds
	jsr _LoadTitleScreen

	lda #0
	sta _PrintHiresX
	lda day_of_the_week+0
	sta _PrintMessagePtr+0
	lda day_of_the_week+1
	sta _PrintMessagePtr+1
	jsr _PrintTextHires

	jsr _WaitOneSecond
	rts

_DayEndSequence
	PRINT_HIRES(_MessageBedTime)
	jsr _WaitThreeSeconds

	ldx #32
loop_scrollout	
	jsr _ScrollUpHires
	dex
	bne loop_scrollout
	rts	

_BadChoiceSequence
	PRINT_HIRES(_MessageBadChoice)
	jsr _WaitOneSecond
	jsr _WaitOneSecond
	jsr _WaitOneSecond
	rts


_Saturday
	jsr _DayIntroSequence
	PRINT_HIRES(_MessageSaturdaySummary)
	jsr _WaitOneSecond
	jsr _WaitOneSecond
	jsr _WaitOneSecond

	jsr _DayEndSequence
	rts

_Sunday 
	jsr _DayIntroSequence
	PRINT_HIRES(_MessageSundaySummary)
	jsr _WaitOneSecond
	jsr _WaitOneSecond
	jsr _WaitOneSecond
	jsr _DayEndSequence
	rts	

; --------------------------------------------------------------------------
; ------------------------------------- Home Office Day
; --------------------------------------------------------------------------
_HomeOfficeDay
.(
	;jmp choice_morning_computer_switch
	jsr _DayIntroSequence

wake_up
.(
	PRINT_HIRES(_MessageNewDayStarts)
	jsr _WaitOneSecond
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageSnooze)
	PRINT_TEXT(_MessageLeaveTheBed)
	PRINT_TEXT(_MessageCallSick)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageSnoozeError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
bad_choice_2
	PRINT_HIRES(_MessageCallSickError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
good_choice
.)
; -------------------------------------------
choice_leave_bed
.(
	PRINT_HIRES(_MessageWokenUp)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageSwitchOnComputer)
	PRINT_TEXT(_MessageHaveBreakfast)
	PRINT_TEXT(_MessageTakeShower)
	jsr _SelectOption
	lda selected_option
	cmp #1
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageHomeBreakfastError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
bad_choice_2
	PRINT_HIRES(_MessageShowerError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
good_choice
.)

; -------------------------------------------
#if 0
choice_morning_computer_switch
.(
	PRINT_HIRES(_MessageHomeOfficeDone)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageSwitchOnComputer)
	PRINT_TEXT(_MessageHaveBreakfast)
	PRINT_TEXT(_MessageTakeShower)
	jsr _SelectOption
	lda selected_option
	cmp #1
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageShowerError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
bad_choice_2
	PRINT_HIRES(_MessageHomeBreakfastError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
good_choice	
.)
#endif
; -------------------------------------------
choice_work_all_day
; -------------------------------------------
at_home
.(
	PRINT_HIRES(_MessageHomeOfficeDone)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessagePizza)
	PRINT_TEXT(_MessageNapTime)
	PRINT_TEXT(_MessageComputerTime)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessagePizzaErrors)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
bad_choice_2
	PRINT_HIRES(_MessageComputerTimeError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
good_choice	
.)

; -------------------------------------------
after_dinner
.(
	PRINT_HIRES(_MessageFeelingBetter)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageTvDinner)
	PRINT_TEXT(_MessageInstagram)
	PRINT_TEXT(_MessageCallMyParents)
	jsr _SelectOption
	lda selected_option
	cmp #1
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageInstagramError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
bad_choice_2
	PRINT_HIRES(_MessageCallMyParentsErrors)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
good_choice	
.)

; -------------------------------------------------
evening_rituals
.(
	PRINT_HIRES(_MessageEveningRituals)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageComputerMMO)
	PRINT_TEXT(_MessageComputerSocial)
	PRINT_TEXT(_MessageComputerDefenceForce)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #1
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageComputerMMOError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
bad_choice_2
	PRINT_HIRES(_MessageComputerSocialError)
	jsr _BadChoiceSequence
	jmp _HomeOfficeDay
good_choice	
.)


	jsr _DayEndSequence
	rts
.)


; --------------------------------------------------------------------------
; ------------------------------------- A new day in the office
; --------------------------------------------------------------------------
_OfficeDay
.(
	;jmp wake_up
	;jmp choise_leave_bed
	;jmp choice_take_shower
    ;jmp take_the_metro
    ;jmp take_the_bus
    ;jmp at_the_office
    ;jmp after_the_office
    ;jmp at_home
    ;jmp after_dinner
    ;jmp evening_rituals

	jsr _DayIntroSequence

wake_up
.(
	PRINT_HIRES(_MessageNewDayStarts)
	jsr _WaitOneSecond
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageSnooze)
	PRINT_TEXT(_MessageLeaveTheBed)
	PRINT_TEXT(_MessageCallSick)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageSnoozeError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessageCallSickError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)

; -------------------------------------------
choise_leave_bed	
.(
	PRINT_HIRES(_MessageWokenUp)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageSwitchOnComputer)
	PRINT_TEXT(_MessageHaveBreakfast)
	PRINT_TEXT(_MessageTakeShower)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #1
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageSwitchOnComputerError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessageHaveBreakfastError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)

; -------------------------------------------
choice_take_shower
.(
	PRINT_HIRES(_MessageClean)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageTakeTheMetro)
	PRINT_TEXT(_MessageWalkToTheOffice)
	PRINT_TEXT(_MessageTakeTheCar)
	jsr _SelectOption
	lda selected_option
	cmp #1
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageWalkToTheOfficeError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessageTakeTheCarError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)

; -------------------------------------------
take_the_metro
.(
	PRINT_HIRES(_MessageMetroSitting)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageSitFront)
	PRINT_TEXT(_MessageSitMiddle)
	PRINT_TEXT(_MessageSitBack)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #1
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageSitError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessageSitError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)

; -------------------------------------------
take_the_bus
.(
	PRINT_HIRES(_MessageWhichBus)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageTramway)
	PRINT_TEXT(_MessageBus31)
	PRINT_TEXT(_MessageBus36)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageTramwayError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessageBus36Error)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)

; -------------------------------------------
at_the_office
.(
	PRINT_HIRES(_MessageOffice)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageMailAndBreakfast)
	PRINT_TEXT(_MessageBreakTheBuild)
	PRINT_TEXT(_MessagePranks)
	jsr _SelectOption
	lda selected_option
	cmp #1
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageBreakTheBuildErrors)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessagePranksErrors)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)

; -------------------------------------------
after_the_office
.(
	PRINT_HIRES(_MessageOfficeDone)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessagePartyTime)
	PRINT_TEXT(_MessageGoHome)
	PRINT_TEXT(_MessageOvertime)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessagePartyTimeErrors)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessageOvertimeErrors)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)

; -------------------------------------------
at_home
.(
	PRINT_HIRES(_MessageAtHome)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessagePizza)
	PRINT_TEXT(_MessageNapTime)
	PRINT_TEXT(_MessageComputerTime)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessagePizzaErrors)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessageComputerTimeError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)

; -------------------------------------------
after_dinner
.(
	PRINT_HIRES(_MessageFeelingBetter)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageTvDinner)
	PRINT_TEXT(_MessageInstagram)
	PRINT_TEXT(_MessageCallMyParents)
	jsr _SelectOption
	lda selected_option
	cmp #1
	beq bad_choice_1
	cmp #2
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageInstagramError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessageCallMyParentsErrors)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)

; -------------------------------------------------
evening_rituals
.(
	PRINT_HIRES(_MessageEveningRituals)
	jsr _WhatWouldMickaeldo
	PRINT_TEXT(_MessageComputerMMO)
	PRINT_TEXT(_MessageComputerSocial)
	PRINT_TEXT(_MessageComputerDefenceForce)
	jsr _SelectOption
	lda selected_option
	cmp #0
	beq bad_choice_1
	cmp #1
	beq bad_choice_2
	jmp good_choice
bad_choice_1
	PRINT_HIRES(_MessageComputerMMOError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
bad_choice_2
	PRINT_HIRES(_MessageComputerSocialError)
	jsr _BadChoiceSequence
	jmp _OfficeDay
good_choice	
.)


	jsr _DayEndSequence
	rts
.)

_WhatWouldMickaeldo
	jsr _WaitThreeSeconds
	PRINT_HIRES(_MessagePlayerChoice)
	jsr _WaitThreeSeconds
	rts

_SelectOption
.(
	lda #0
	sta selected_option
loop	
	; Select based on choice
	ldx selected_option
	beq selectFirst
	dex
	beq selectSecond
	bne selectThird

display
	sta $bb80+40*25
	stx $bb80+40*26
	sty $bb80+40*27

	; Hack to get a null terminator...
	lda #0
	sta $bb80+40*25+39
	sta $bb80+40*26+39
	sta $bb80+40*27+39

_ReadKeyboard
	jsr _WaitNoKeyPressed
waitKey	
	lda _KeyboardStateMemorized
	beq waitKey
	lsr
	lsr
	lsr
	bcs up
	lsr
	bcs down
	lsr
	bcs select
	jmp loop

selectFirst
    lda #0
    sta selected_offset
	lda #16+1
	ldx #16+0
	ldy #16+0
	jmp display

selectSecond
    lda #40
    sta selected_offset
	lda #16+0
	ldx #16+1
	ldy #16+0
	jmp display

selectThird
    lda #80
    sta selected_offset
	lda #16+0
	ldx #16+0
	ldy #16+1
	jmp display

up
	dec selected_option
	bpl done_up
	ldx #2
	stx selected_option
done_up
	jmp loop

down
	ldx selected_option
	inx
	cpx #3
	bne done_down
	ldx #0
done_down
	stx selected_option
	jmp loop

select	
    ; Copy the selected message to the history log
    clc
    lda #<$bb80+40*25+1
    adc selected_offset
    sta _PrintMessagePtr+0
    lda #>$bb80+40*25+1
    adc #0
    sta _PrintMessagePtr+1:

    ldx #0
    stx _PrintHiresX
    jsr _PrintTextHiresNoScroll

    jsr _EraseTextArea
    rts

.)





_LoopForever
	jmp _LoopForever
