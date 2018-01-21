
	.zero

_PrintScreenX       .dsb 1
_PrintScreenColor   .dsb 1

_PrintHiresX       .dsb 1
_PrintHiresColor   .dsb 1

_PrintMessagePtr	.dsb 2      ; The address of the message to display

	.text

_PrintSelectedText
.(
	ldy #255
loop_line
	jsr _ScrollUpText
	ldx _PrintScreenX
	lda _PrintScreenColor
	jmp printOut
loop_name
    iny
	lda (_PrintMessagePtr),y
	beq end_name
	cmp #13
	bne printOut
    ; Carriage return
    jmp loop_line
printOut	
	sta $BB80+40*27,x

	inx
	cpx #38
	bne loop_name	
	ldx #0
	jmp loop_line
end_name
    stx _PrintScreenX
	rts
.)


#define SCROLLUP(ypos)  lda $bb80+40*(ypos+1),x:sta $bb80+40*ypos,x


; 40*28=1120 bytes
_ScrollUpText
    ;jmp _ScrollUpText
.(
	pha
	txa
	pha

	ldx #0
loop
	SCROLLUP(25)
	SCROLLUP(26)

	lda #32
	sta $bb80+40*27,x
	inx
	cpx #40
	beq end
	jmp loop
end	
	pla 
	tax 
	pla
	rts
.)

_EraseTextArea
.(
	ldx #0
loop
	lda #32
	sta $bb80+40*25,x
	inx 
	cpx #40*3
	bne loop	
	rts
.)

; _Font6x6
saveY  .byt 0

_PrintTextHiresNoScroll
	ldy #255
	jmp do_print

_PrintTextHires
.(
	ldy #255
loop_line
	jsr _ScrollUpHires
+do_print	
	ldx _PrintHiresX
	lda _PrintHiresColor
	jmp printOut
loop_name
    iny
	lda (_PrintMessagePtr),y
	beq end_name
	cmp #13
	bne printOut
    ; Carriage return
    jmp loop_line
printOut	
	sty saveY
	tay
    lda _Font6x6+256*0,y
	sta $a000+40*6*32+40*0,x

    lda _Font6x6+256*1,y
	sta $a000+40*6*32+40*1,x

    lda _Font6x6+256*2,y
	sta $a000+40*6*32+40*2,x

    lda _Font6x6+256*3,y
	sta $a000+40*6*32+40*3,x

    lda _Font6x6+256*4,y
	sta $a000+40*6*32+40*4,x

    lda _Font6x6+256*5,y
	sta $a000+40*6*32+40*5,x

	ldy saveY

	inx
	cpx #40
	bne loop_name	
	ldx #0
	jmp loop_line
end_name
    stx _PrintHiresX
	rts
.)



_PatchFont
.(
	ldx #0
loop_code	
	txa
	sta _Font6x6+256*0,x
	sta _Font6x6+256*1,x
	sta _Font6x6+256*2,x
	sta _Font6x6+256*3,x
	sta _Font6x6+256*4,x
	sta _Font6x6+256*5,x
	inx
	cpx #32
	bne loop_code
	rts
.)

; 40*28=1120 bytes
; We scroll the hires screen by 6 scanlines

_ScrollUpHires
    ;jmp _ScrollUpHires
.(
	pha
	txa
	pha
	tya
	pha

	lda #<$a000
	sta tmp1+0
	lda #>$a000
	sta tmp1+1

	lda #<$a000+40*6
	sta tmp2+0
	lda #>$a000+40*6
	sta tmp2+1

	ldx #32   ; 33*6=198
loop_y
	ldy #0
loop_x
	lda (tmp2),y
	sta (tmp1),y
	iny
	cpy #240
	bne loop_x

	jsr Add240Tmp1
	jsr Add240Tmp2

	dex
	bne loop_y

	; Clean the last line
	ldy #0
loop_x_clean
	lda #64
	sta (tmp1),y
	iny
	cpy #40*6
	bne loop_x_clean

	pla 
	tay
	pla 
	tax 
	pla
;bla jmp bla	
	rts
.)


; Let's have the messages of the game:

; Days of the week
_MessageMonday    .byt 3,16+1,"A new monday starts...",16+0,13,13,0
_MessageTuesday   .byt 3,16+1,"A new tuesday starts...",16+0,13,13,0
_MessageWednesday .byt 3,16+1,"A new wednesday starts...",16+0,13,13,0
_MessageThursday  .byt 3,16+1,"A new thursday starts...",16+0,13,13,0
_MessageFriday    .byt 3,16+1,"A new friday starts...",16+0,13,13,0
_MessageSaturday  .byt 3,16+1,"A new saturday starts...",16+0,13,13,0
_MessageSunday    .byt 3,16+1,"A new sunday starts...",16+0,13,13,0

; The description messages
_MessageNewDayStarts       
	.byt 7,"It's still dark outside.",13
	.byt 7,"A normal winter day in Oslo.",13,13
	.byt 1,"The alarm clock beeps...",13
	.byt 0

_MessageSaturdaySummary
	.byt 7,"It's still dark outside.",13
	.byt 7,"A normal winter day in Oslo.",13,13
	.byt 7,"But today is Saturday, so I don't have"
	.byt 7,"to go to work.",13,13
	.byt 7,"There are still some rituals to",13
	.byt 7,"perform, such as go shopping and",13
	.byt 7,"cleaning, but I will spare you these.",13
	.byt 0

_MessageSundaySummary
	.byt 7,"It's still dark outside.",13
	.byt 7,"A normal winter day in Oslo.",13,13
	.byt 7,"But today is Sunday, so I don't have",13
	.byt 7,"to go to work.",13,13
	.byt 7,"I guess the only Sunday's ritual I can"
	.byt 7,"think of is to not do much at all and",13
	.byt 7,"just enjoy the day.",13
	.byt 0

_MessageWokenUp
	.byt 13,7,"I slowly get out of the bed.",13,13
	.byt 7,"A bit of stretching helps the old",13
	.byt 7,"carcass prepare for the day ahead.",13,13
	.byt 7,"I need to get ready for work.",13
	.byt 0

_MessageClean
	.byt 13,7,"Nice shower is nice.",13,13
	.byt 7,"I put my clothes and leave.",13,13
	.byt 7,"I will take my breakfast at work.",13
	.byt 0

_MessageMetroSitting
	.byt 13,7,"The tbane arrives.",13,13
	.byt 7,"I like to optimize everything I do:",13
	.byt 7,"If you board the right car you can",13
	.byt 7,"exit faster which helps catching the",13
	.byt 7,"next transport!",13
	.byt 0

_MessageWhichBus
	.byt 13,7,"I spend the next 20 minutes reading on"
	.byt 7,"my ebook reader while listening epic",13
	.byt 7,"music on my mobile phone.",13,13
	.byt 7,"When the metro arrives at Stortinget I"
	.byt 7,"move to the last door of the car and",13
	.byt 7,"briskly walk toward the town hall as",13
	.byt 7,"soon as the doors open.",13
	.byt 0

_MessageOffice
	.byt 13,7,"The bus to Skoyen is not that fast",13
	.byt 7,"during rush hours, but after a while",13
	.byt 7,"I'm finally at the Maritim bus stop.",13,13
	.byt 7,"Few hundred meters walking and I'm in",13
	.byt 7,"the office ready for new challenges.",13
	.byt 0

_MessageOfficeDone
	.byt 13,7,"It's another long day spent coding, ",13
	.byt 7,"designing, debugging, helping and ",13
	.byt 7,"discussing with colleagues.",13,13
	.byt 7,"I finally call it a day and leave.",13
	.byt 0

_MessageHomeOfficeDone
	.byt 13,7,"I start the VPN and connect to my work"
	.byt 7,"computer.",13,13
	.byt 7,"It's another long day spent coding, ",13
	.byt 7,"designing, debugging, helping and ",13
	.byt 7,"discussing with colleagues on Skype.",13,13
	.byt 7,"I finally call it a day and disconnect.",13
	.byt 0

_MessageAtHome
	.byt 13,7,"I'm finally home, tired and hungry",13
	.byt 0

_MessageFeelingBetter
	.byt 13,7,"I call that a 'Powernap', it's a great"
	.byt 7,"way to recharge the batteries.",13,13
	.byt 7,"I'm now ready for the evening rituals.",13
	.byt 0

_MessageEveningRituals
	.byt 13,7,"My girlfriend and I like to watch",13
	.byt 7,"series together while having dinner.",13,13
	.byt 7,"After that I spend some time on my",13
	.byt 7,"computer.",13
	.byt 0

_MessageBedTime
	.byt 13,7,"I spend few hours on the computer.",13,13
	.byt 7,"It's now late, so...",13
	.byt 7,"...time to go to bed!!!",13,13
	.byt 7,"Let's have a good night sleep.",13
	.byt 0

; What would I do
_MessagePlayerChoice	.byt 1,12,16+7,"What would Mickael do? ",16+0,0

_MessageBadChoice
	.byt 13,5,"That was not very logical!",13
	.byt 5,"I'm probably still sleeping...",13
	.byt 5,"Another weird dream???",13,13,13
	.byt 0

; Actions
_MessageSnooze				.byt 2,"I hit the snooze button",0
_MessageLeaveTheBed  		.byt 2,"I leave the bed",0
_MessageCallSick 			.byt 2,"I call work and say I'm sick",0
_MessageTakeShower			.byt 2,"I jump into the shower",0
_MessageHaveBreakfast		.byt 2,"I get my breakfast",0	
_MessageSwitchOnComputer	.byt 2,"I switch on my computer",0
_MessageTakeTheMetro		.byt 2,"I go to the metro station",0
_MessageWalkToTheOffice		.byt 2,"I walk to the office",0
_MessageTakeTheCar			.byt 2,"I take the car",0
_MessageSitFront			.byt 2,"I sit in the front",0
_MessageSitMiddle			.byt 2,"I sit in the middle",0
_MessageSitBack				.byt 2,"I sit in the back",0
_MessageTramway				.byt 2,"I take the tramway",0
_MessageBus31				.byt 2,"I take the bus 31, 31E or 32",0
_MessageBus36				.byt 2,"I take the bus 36E, 70 or 74",0
_MessageMailAndBreakfast	.byt 2,"I read mails and eat breakfast",0
_MessageBreakTheBuild		.byt 2,"I break the build",0
_MessagePranks				.byt 2,"I prank some colleagues",0
_MessagePartyTime			.byt 2,"I go to a party",0
_MessageGoHome				.byt 2,"I go home",0
_MessageOvertime			.byt 2,"I do some overtime",0
_MessagePizza				.byt 2,"I order some food",0
_MessageComputerTime		.byt 2,"I spend time on the computer",0
_MessageNapTime				.byt 2,"I take a 20 minutes nap",0
_MessageTvDinner			.byt 2,"I watch some series while eating",0
_MessageInstagram			.byt 2,"I post photos of my dinner",0
_MessageCallMyParents		.byt 2,"I call my parents",0

_MessageComputerDefenceForce .byt 2,"I do some defence force stuff",0
_MessageComputerSocial		.byt 2,"I browse 9gag, 4chan and reddit",0
_MessageComputerMMO			.byt 2,"I log on my favorite MMO",0

; Actions error explanations
_MessageSnoozeError  			.byt 13,5,"I never use the snooze button",0
_MessageCallSickError			.byt 13,5,"Seriously, how lame is that!",0
_MessageHaveBreakfastError  	.byt 13,5,"I usually take my breakfast at work",0
_MessageSwitchOnComputerError 	.byt 13,5,"I can check my mail at work while",13,5,"I'm eating my breakfast",0
_MessageTakeTheCarError			.byt 13,5,"I really love the Feltvogn but",13,5,"that's not for the daily commute.",0
_MessageWalkToTheOfficeError	.byt 13,5,"I would love to walk to the office",13,5,"but it's wayyyy to far.",0
_MessageSitError				.byt 13,5,"That's not optimal if you leave",13,5,"at the National Theater stop!",0
_MessageBus36Error				.byt 13,5,"The bus 36E does not stop at Maritim",0
_MessageTramwayError			.byt 13,5,"The tramway does not go where I need",0
_MessageBreakTheBuildErrors		.byt 13,5,"I would not do that on purpose",0
_MessagePranksErrors			.byt 13,5,"That's not funny",0
_MessagePartyTimeErrors			.byt 13,5,"Unfortunately I'm not 25 anymore",0
_MessageOvertimeErrors			.byt 13,5,"That would be exceptional",0
_MessageComputerTimeError		.byt 13,5,"I will do that later",0
_MessagePizzaErrors				.byt 13,5,"Only on weekend ;)",0
_MessageInstagramError			.byt 13,5,"I don't own a smartphone",0
_MessageCallMyParentsErrors		.byt 13,5,"I should probably do that",0
_MessageShowerError             .byt 13,5,"When I work from home I switch on the",13,5,"computer before taking my shower.",0
_MessageHomeBreakfastError      .byt 13,5,"When I work from home I switch on the",13,5,"computer before eating breakfast.",0
_MessageComputerSocialError		.byt 13,5,"If you want to find time to do stuff,",13,5,"you should really avoid these sites.",0
_MessageComputerMMOError		.byt 13,5,"I really tried hard to like MMOs, but",13,5,"ultimately I found them very boring.",0

