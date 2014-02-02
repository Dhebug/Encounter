
#define SCROLLER_BUFFER_SPLIT	41	; 44
#define SCROLLER_BUFFER_WIDTH   89	; 91=(Split+1)*2+1

#define SCROLLER_EFFECT_RESTART		       0
#define SCROLLER_EFFECT_SET_DISPLAY_TABLE  1
#define SCROLLER_EFFECT_SET_COLORS  	   2
#define SCROLLER_EFFECT_SET_COLUMN_OFFSET  3
#define SCROLLER_EFFECT_SET_FONT 		   4
#define SCROLLER_EFFECT_SET_DISTORT_TABLE  5


	.zero

_MessageScrollerPtr			.dsb 2
scroll_ptr_0				.dsb 2
scroll_ptr_1 				.dsb 2
scroll_tmp_0				.dsb 2
scroll_tmp_1				.dsb 2
scroll_dist_ptr_0			.dsb 2
scroll_dist_ptr_1 			.dsb 2
WaveOffset					.dsb 1
WaveOffset2					.dsb 1


	.text


DitheringLeft
	.byt %001110
	.byt %010101
	.byt %101011
	.byt %010101
	.byt %001110
	.byt %010001
	.byt %101111
	.byt %010101
	.byt %001010
	.byt %010101
	.byt %101111
	.byt %010001
	.byt %001110
	.byt %010101
	.byt %101011
	.byt %010101

DitheringRight
	.byt %011100
	.byt %101010
	.byt %110101
	.byt %101010
	.byt %011100
	.byt %100010
	.byt %111101
	.byt %101010
	.byt %010100
	.byt %101010
	.byt %111101
	.byt %100010
	.byt %011100
	.byt %101010
	.byt %110101
	.byt %101010

#define SET_HORIZONTAL_EFFECT(callback)	.asc SCROLLER_EFFECT_SET_COLUMN_OFFSET,<callback,>callback
#define SET_DISTORT_EFFECT(callback)	.asc SCROLLER_EFFECT_SET_DISTORT_TABLE,<callback,>callback
#define SET_SCANLINE_EFFECT(callback)	.asc SCROLLER_EFFECT_SET_DISPLAY_TABLE,<callback,>callback

#define SET_COLOR(top,bottom) 			.asc SCROLLER_EFFECT_SET_COLORS,top,bottom
#define SET_FONT_SMALL() 				.asc SCROLLER_EFFECT_SET_FONT,0 
#define SET_FONT_LARGE() 				.asc SCROLLER_EFFECT_SET_FONT,1 



_MessageScroller
	SET_DISTORT_EFFECT(HorizontalMovementSinusDistorter)
	SET_HORIZONTAL_EFFECT(SetScrollerDisplayTop)
	SET_SCANLINE_EFFECT(ScrollerOffsetTable_16_Low)
	SET_FONT_LARGE()
    SET_COLOR(7,7)
	.asc "Happy New Year 2014 everybody!!!    "

	SET_FONT_SMALL()
	.asc "Here is Defence-Force's contribution to"
	SET_FONT_LARGE()
	.asc " PayBack 2014 "
	SET_FONT_SMALL()
	.asc ":)"
	.asc "                                            "


	SET_DISTORT_EFFECT(HorizontalMovementNormal)
	SET_HORIZONTAL_EFFECT(SetScrollerDisplayTop)
    SET_COLOR(7,7)
	SET_SCANLINE_EFFECT(ScrollerOffsetTable_16_Low)
	.asc "We are starting the year with a simple slideshow... "
	.asc "                                            "

	SET_DISTORT_EFFECT(HorizontalMovementSinusDistorter)
	SET_HORIZONTAL_EFFECT(SetScrollerDisplaySinus)
    SET_COLOR(3,3)
	SET_SCANLINE_EFFECT(ScrollerOffsetTable_16_Low)
	.asc "...with a fancy text scroller so you don't get too bored! "
	.asc "                                            "

	SET_DISTORT_EFFECT(HorizontalMovementNormal)
	SET_HORIZONTAL_EFFECT(SetScrollerDisplayTop)
    SET_COLOR(1,3)
	SET_SCANLINE_EFFECT(ScrollerOffsetTable_Double8_Low)
	.asc "Credits for this production goes to Dbug for all the code and tools, "
	.asc "and to many musicians and pixelers (read the NFO for details)  "
	.asc "                                     "

    SET_COLOR(5,5)
	SET_SCANLINE_EFFECT(ScrollerOffsetTable_DoubleHeight_Low)
	.asc "So, why a bloody SlideShow??? "
	.asc "                                     "

	SET_DISTORT_EFFECT(HorizontalMovementSinusDistorter)
    SET_COLOR(7,16+4)
	SET_SCANLINE_EFFECT(ScrollerOffsetTable_Mirrored_Low)
	.asc "The reason is simple: Cumulus. "
	.asc "We want more floppy based demos and games which means decent hardware and software support. "
	.asc "With Cumulus we get the hardware, and with this demo you get the software. "
	.asc "                                            "

	SET_HORIZONTAL_EFFECT(SetScrollerDisplayTop)
	SET_SCANLINE_EFFECT(ScrollerOffsetTable_16_Low)
	SET_FONT_LARGE()
    SET_COLOR(7,7)
	.asc "Software? Please tell us more!           "

	SET_DISTORT_EFFECT(HorizontalMovementNormal)
	SET_FONT_SMALL()
	.asc "Well: The full source code of this SlideShow is available, including the data files, "
	.asc "build scripts, tool chain, updated converters and packers, plus some new stuff like "
	.asc "a better YM music converter and faster picture transcoder. "
	.asc "The big novelty is "
	SET_FONT_LARGE()
	.asc " FloppyBuilder "
	SET_FONT_SMALL()
	.asc "which is a totally revamped version of what we used to create our earlier floppy based demos. "
	.asc "The FloppyBuilder accepts layout files, and comes complete with boot and loading code. "
	.asc "Future versions will probably also support the jasmin disc drive, meaning that your games and "
	.asc "demos will work on about 90% of Oric floppy drives. "
	.asc "                                            "

	SET_DISTORT_EFFECT(HorizontalMovementSinusDistorter)
	SET_HORIZONTAL_EFFECT(SetScrollerDisplaySinus)
    SET_COLOR(2,2)
	SET_SCANLINE_EFFECT(ScrollerOffsetTable_16_Low)
	.asc "Of course, no proper demo without greetings, so here they are: "
	.asc "    "
	.asc "I would like to start by giving a collective thank you to all these people who have helped keeping the little"
	.asc "Oric world alive such as people who wrote and fixed emulators, tools, user groups, magazine editors, game testers, "
	.asc "anyone really writting software for the Oric, and also anyone taking the time to play the games and watch the demos "
	.asc "and talk about them and give feedback. That's very important. "
	.asc "    "
	.asc "I will not forget the hardware people either. "
	.asc "Some of you are creating new devices such as the Cumulus, some other are fixing our 30 year old hardware. "
	.asc "Both groups deserve recognition because they help keep the spirit alive - the day we will only be able to use "
	.asc "emulators will be a sad one. "
	.asc "    "
	.asc "As a demoscener, I will give a collective thank to all people writing demos, maintaining websites such as "
	.asc "Pouet, Demozoo, Bitfellas, ArtCity, Scene.org, etc... but also people organizing demo parties because I know it "
	.asc "is a huge and often unrecognized work. (Special thanks to the ones that provide free ear plugs and coffee). "
	.asc "    "
	.asc "                                            "


	SET_DISTORT_EFFECT(HorizontalMovementNormal)
	SET_HORIZONTAL_EFFECT(SetScrollerDisplayTop)
	SET_SCANLINE_EFFECT(ScrollerOffsetTable_16_Low)
	SET_FONT_LARGE()
    SET_COLOR(6,7)

	.asc "Regularly I get asked 'Why the Oric?'    "

    SET_COLOR(7,3)
	.asc "I've had an Oric Atmos as my very first computer back in 1983, one I bought with my own money earnt by working the "
	.asc "fields in a farm during the summer hollidays break. Kids these days... whatever. "
    SET_COLOR(3,1)
	.asc "It's on the Oric I learnt programming, started doing music, and graphics as well. And I used it to write my french "
	.asc "lessons, and doing mathematics - using the 4 colors pen printer to draw graphics. "
    SET_COLOR(1,5)
	.asc "I of course also played games, but truth be told most were crap and I found more interesting trying to write my own instead.  "
    SET_COLOR(5,4)

	.asc "    "

	.asc "Fast forward to 1996 when I rediscovered the Oric in the forum of Euphoric, the first very nice to use Oric emulator. "
    SET_COLOR(4,6)
	.asc "This allowed me to discover a whole community of passioned people: The ones who stayed fidel when I instead sold "
	.asc "mine to buy an Atari ST. "
    SET_COLOR(6,2)
	.asc "I quickly found some development tools, and there we are, in 1997 I released my first real Oric demo, "
	.asc "mostly building on the skills I developped on the Atari ST back in the days. "

	.asc "    "
    SET_COLOR(3,3)
	.asc "It's now 2014, and things have changed. "
	.asc "Mostly for the best, somewhat for the worse. "
	.asc "The great excitement these days comes from Cumulus, a SD Card stand-alone replacement for the Microdisc, "
	.asc "which will extend significantly the number of people actually being able to watch demos on the real machines! "
	.asc "So to celebrate that, I decided it was time to make a decent demo exploiting the floppy drive correctly, "
	.asc "and make the whole source code and tools available to the largest number of people so other can do it as well. "
	.asc "This demo is just a small slideshow, but hopefully it will be helpful :) "

	.asc "    "

	.byt SCROLLER_EFFECT_RESTART


	/*
	.asc "ABCDEFGHIJKL"
	.asc "Happy New Year 1914 my friends! "
	.asc "Feel free to join us in this one of a kind futuristic adventure! "
	.asc "Through this marvelous tabulation device - also known as calculator - your senses will enjoy the discovery of mostly "
	.asc "unknown delightful pieces of human visual and auditory design. "
	.asc "Please sit down, get comfortable, and enjoy! "

	.asc "    "

	.asc "(This innovative presentation is copyrighted by the Defence Force and shall not be copied without written authorization "
	.asc "by the adequate members of the board of directors.)  "

	.asc "    "

	.asc "And N@..&$$$? "
	.asc SCROLLER_EFFECT_GARBAGE
	.asc "{1saVAd.. whatThe? Zeeeeezchrringkkk "
	.asc SCROLLER_EFFECT_GARBAGE
	.asc " (Bazinga!!!!) "

	.asc "    "

    .asc "You thought it was corrupted data, isn't it? "
    .asc "Nah, don't try to pretend. I can see it in your eyes. Oh, I'm sorry, I forgot the presentations. My bad. "
    .asc "My name is Dr Sheldon Cooper, "
    .asc "and you are the first person so far to witness time travel! "
    .asc "Yes, yes, I know. Everybody is impressed, but really they should not, it's like if my genius was not already famous, "
    .asc "but I disgress and "
    .asc "I need a nice cup of tea so I will let my assistant do the chit chat with you..."

	.asc "          "

	.asc "'Assistant' on the keyboard. I'm really sorry for all that, he really think he managed to do time travel "
	.asc "but he did not really realise that "
	.asc "we've been kind of cheating in his back, so please bear with us and play the game. "
	.asc "(He is comming back, talk to you later!...) "

	.asc "          "

	.asc "So, where were we. Ha, yes. Time Travel! A fascinating topic isn't it. There you are, watching these punny "
	.asc "animations thinking they are running "
	.asc "on a 1914's made computer - sorry, I meant of course 'a tabulator' "
	.asc "while in reality it's all generated on the very tiny but powerful device here on my desk, and then projected "
	.asc "through the continuum transfunctioner "
	.asc "until it appears on the projection screen. "
	.asc "So you may be wondering why you, why 1914? Well that's simple: I wanted to go back to the prehistorical times "
	.asc "to play the all knowing god with some primitive ape man, "
	.asc "but Wolowitz pointed out that the beam projection required an electrically powered device on the other side "
	.asc "of the time fracture. Rats. "

	.asc "    "

	.asc "The next best choice was 1914; I absolutely wanted to see your face when I would tell you that in just few months "
	.asc "you would assist to most deadly war the world as ever known! Scary yes I know. "
	.asc "And the more funny is they all thought it would not ever happen again, the fools! "

	.asc "So now Beeeeppppp"
	.asc SCROLLER_EFFECT_GARBAGE
	.asc "pppadsfadsfgsdgsdjgsergs!!???? "
	.asc SCROLLER_EFFECT_GARBAGE

	.asc "    "

	.asc "My dear Amy, it looks like we are back on track again. Let me check... biiiiieee"
	.asc SCROLLER_EFFECT_GARBAGE
	.asc "eeiiiiiiieeeeiiii... "
	.asc SCROLLER_EFFECT_GARBAGE
	.asc "hmmm... "
	.asc SCROLLER_EFFECT_GARBAGE
	.asc "biiIIIIIiiIIIeeee... "
	.asc SCROLLER_EFFECT_GARBAGE
	.asc "there we are. Yes it's what I thought, another time fracture, right through the last century. "
	.asc "There, one fixed. More to go. "
	.asc "Oh, who's there? Ha, yes Me of course. No I mean you. You are not supposed to be there anymore, or are you not? "
	.asc "Oh my... looks like you will have to stay with us for a while, at least until I can get you then. Yes then. "
	.asc "Not there. You are already there, just not at the right when. "

	.asc "    "

	.asc "What's that in your hands? Red and black little kliketi kliketa keyboard, Oric, Atmos, 48k? Intriguing! "
	.asc "And the thing even can make sound and pictures. Magnificent! "
	.asc "Well, well, perhaps we could connect this thing to the flux revertor and see if my brave Tardis can have "
	.asc "interesting discussions with your little brain in a box. No not YOUR brain, the one in the red and black box. "

	.asc "    "

	.asc "Since we are on the topic of travel and have plenty of time, what about I tell you a bit more about what this whole "
	.asc "thing is all about? "
	.asc "As you figured out it's not really about time travel, but sometimes when programming it actually feels like "
	.asc "the time stops, even more so when programming on these older machines. "

	.asc "    "

	.asc "I've had an Oric Atmos as my very first computer back in 1983, one I bought with my own money earnt by working the "
	.asc "fields in a farm during the summer hollidays break. Kids these days... whatever. "
	.asc "It's on the Oric I learnt programming, started doing music, and graphics as well. And I used it to write my french "
	.asc "lessons, and doing mathematics - using the 4 colors pen printer to draw graphics. "
	.asc "I of course also played games, but truth be told most were crap and I found more interesting trying to write my own instead.  "

	.asc "    "

	.asc "Fast forward to 1996 when I rediscovered the Oric in the forum of Euphoric, the first very nice to use Oric emulator. "
	.asc "This allowed me to discover a whole community of passioned people: The ones who stayed fidel when I instead sold "
	.asc "mine to buy an Atari ST. "
	.asc "I quickly found some development tools, and there we are, in 1997 I released my first real Oric demo, "
	.asc "mostly building on the skills I developped on the Atari ST back in the days. "

	.asc "    "
	.asc "It's now 2014, and things have changed. Mostly for the best, somewhat for the worse. "
	.asc "The great excitement these days comes from Cumulus, a SD Card stand-alone replacement for the Microdisc, "
	.asc "which will extend significantly the number of people actually being able to watch demos on the real machines! "
	.asc "So to celebrate that, I decided it was time to make a decent demo exploiting the floppy drive correctly, "
	.asc "and make the whole source code and tools available to the largest number of people so other can do it as well. "
	.asc "This demo is just a small slideshow, but it brings some world first: It's the first large smooth scroller "
	.asc "in the bottom border, "
	.asc "it's the first programm that loads in the background while playing music and animations. "
	.asc "It may also be the first program actually running on both Microdisc and Jasmin - that's assuming I find "
	.asc "the bug in the loader by the time I release this -."

	.asc "    "

	.asc "Credits for this small demo goes to quite many people: "
	.asc "The actual final work was done by Dbug (Code, Fonts, Tools, selection of artwork, etc...), "
	.asc "All the musics were composed on the Atari ST by talented Musicians such as Big Alex, Mad Max, "
	.asc "Excellence in Arts, Chris Mad, LTK, Matt Furniss and Count Zero. "
	.asc "Finally, the selection of pictures was a blend of native images and conversions by Alexios, "
	.asc "Chema, Christophe, Dbug, Dom, Exocet, Frederic, Gloky, Marcel, Mondrian, Mooz, Pinky, Prez, "
	.asc "Symon, Twilighte and finally Vasiloric. "

	.asc "    "
     */
	.asc "Of course, no proper demo without greetings, so here they are: "
	.asc "    "
	.asc "I would like to start by giving a collective thank you to all these people who have helped keeping the little"
	.asc "Oric world alive such as people who wrote and fixed emulators, tools, user groups, magazine editors, game testers, "
	.asc "anyone really writting software for the Oric, and also anyone taking the time to play the games and watch the demos "
	.asc "and talk about them and give feedback. That's very important. "
	.asc "    "
	.asc "I will not forget the hardware people either. "
	.asc "Some of you are creating new devices such as the Cumulus, some other are fixing our 30 year old hardware. "
	.asc "Both groups deserve recognition because they help keep the spirit alive - the day we will only be able to use "
	.asc "emulators will be a sad one. "
	.asc "    "
	.asc "As a demoscener, I will give a collective thank to all people writing demos, maintaining websites such as "
	.asc "Pouet, Demozoo, Bitfellas, ArtCity, Scene.org, etc... but also people organizing demo parties because I know it "
	.asc "is a huge and often unrecognized work. (Special thanks to the ones that provide free ear plugs and coffee). "
	.asc "    "
     /*
	.asc "I guess it would not be a proper oldskool demo if it also did not contain some fucking greetings: "
	.asc "Fuck to the 0.01%, the market, push to obsolescence, uncontrolled demographics, food and health 'care' industry. "
	.asc "Also mega fucks to life itself to take away the nice people first and leaving the assholes alive. "
	.asc "Special fucks to the spying agencies in general, and to the medias and politicians in particular for being lame. "
	.asc "         "

	.asc "I hope you liked this little demo and will feel like trying to write some stuff for the Oric as well. "
	.asc "As usual all the tools and sample code are available on the Defence Force SVN depot, at "
	.asc "http://miniserve.defence-force.org/svn and http://osdk.defence-force.org. "
	.asc "You can contact other Oric developpers on the Forum at http://forum.defence-force.org, and finally "
	.asc "you can contact me by mail: dbug@defence-force.org."
     */
	.asc "    "
	.asc "Let's may 2014 a great year!! "
	.asc "                            "

	.asc "The End :) Let's wrap...    "
			
	.asc "                            "
	.byt 0

_NarrowCharacterList
	.asc "iIl,;.:!'"
	.byt 0


ByteMaskRight		.byt 0
ByteMaskLeft		.byt 0
column				.byt 0 
columnCopy			.byt 20
tempWhatever        .byt 0

ScrollerCharacterColumn	.byt 0
ScrollerCurChar			.byt 0
ScrollCurCharWidth  	.byt 0
StupidRotatingMask 		.byt 0




; xx111111
;
; xx011111
; xx100000

GenerateScrollTable
.(
	ldx #0
loop	
	txa
	and #%00111111
	lsr
	ora #64
	sta ScrollTableLeft,x

	txa
	and #%00000001
	lsr
	bcc skip
	ora #%00100000
skip	
	ora #64

	sta ScrollTableRight,x
	inx
	cpx #0
	bne loop


	; Then the font character address table, first make all unknown characters
	; point to the space character.
	ldx #0
loop_init_car	
	lda #<_FontBuffer
	sta _FontAddrLow,x
	lda #>_FontBuffer
	sta _FontAddrHigh,x

	lda #2
	sta _FontCharacterWidth,x
	inx 
	cpx #128
	bne loop_init_car

	.(
	ldx #0
loop_init_width
	lda _NarrowCharacterList,x
	beq end_loop
	tay
	lda #1
	sta _FontCharacterWidth,y
	inx
	bne loop_init_width
end_loop
	.)

	; Then the font character address table, first make all unknown characters
	; point to the space character.
	lda #<_FontBuffer
	sta tmp0+0
	lda #>_FontBuffer
	sta tmp0+1

	ldx #32
loop_set_car
	clc	
	lda tmp0+0
	sta _FontAddrLow,x
	adc #32
	sta tmp0+0
	lda tmp0+1
	sta _FontAddrHigh,x
	adc #0
	sta tmp0+1
	inx 
	cpx #128
	bne loop_set_car

	rts
.)


tmpCos	.dsb 4

_ScrollerInit
	; Write the characters in the bottom text area
	ldy #32
	ldx #1
loop_fill_text	
	tya
	sta $bb80+40*26,x
	iny
	tya
	sta $bb80+40*27,x
	iny
	inx
	cpx #38
	bne loop_fill_text

	lda #3
	sta $bb80+40*26
	lda #1
	sta $bb80+40*27

	; Black paper for the 'loading data' message
	ldx #16
	stx $bb80+40*26+37
	stx $bb80+40*27+37


;asdasf jmp asdasf
	jsr GenerateScrollTable	

	.(
	ldx #0
loop_cos
	lda _BaseCosTable,x 	; 0-256
	lsr 	; 0-128
	lsr 	; 0-64
	lsr 	; 0-32
	lsr 	; 0-16
	lsr 	; 0-8
	sta _CosTable8,x
	lsr 	; 0-4
	sta _CosTable4,x

	inx
	bne loop_cos		
	.)

	; Create the composite distorter table
	.(
	ldx #0
loop_composite_cos
	lda _CosTable8,x
	sta _CosTableDistorter,x

	txa
	asl
	asl
	tay
	lda _CosTable8,y
	clc
	adc _CosTableDistorter,x
	sta _CosTableDistorter,x

	tya
	asl
	tay
	lda _CosTable4,y
	clc
	adc _CosTableDistorter,x
	sta _CosTableDistorter,x



	inx
	bne loop_composite_cos		
	.)


	jsr SetScrollerDisplayTop


	ldy #SCROLLER_BUFFER_SPLIT
	sty column

	jsr ScrollerDisplayReset	

	;
	; Install the IRQ
	;
	sei
	lda #<_ScrollerDisplay
	sta _InterruptCallBack_2+1
	lda #>_ScrollerDisplay
	sta _InterruptCallBack_2+2
	cli
	rts





_ScrollerDisplay
	jsr __auto_jump      ; -> 2670 cycles

    jmp CopyToCharset    ; -> 

__auto_jump	
	jmp (ScrollerJumpTable)



_ScrollerPhase1
    ;jmp _ScrollerPhase1

	ldx column
	inx
	cpx #SCROLLER_BUFFER_SPLIT+1
	bcc skip_reset
	ldx #0
skip_reset	
	stx column
	clc
	txa
	adc #SCROLLER_BUFFER_SPLIT+1
	sta columnCopy


	lda ScrollerCharacterColumn
	cmp ScrollCurCharWidth
	bne WriteCharData

InsertNewChar
	;jmp InsertNewChar
	; Get character and write into the buffer
	ldy #0
	sty ScrollerCharacterColumn

	lda (_MessageScrollerPtr),y
	cmp #32
	bcs NoSpecialEffect

	asl
	clc
	adc #<ScrollerEffectJumpTable
	sta __auto_special+1
	lda #>ScrollerEffectJumpTable
	adc #0
	sta __auto_special+2
__auto_special
	jmp (ScrollerEffectJumpTable)

NoSpecialEffect	
	sta ScrollerCurChar
	tay
	lda _FontCharacterWidth,y
	sta ScrollCurCharWidth

	jsr ScrollerIncPointer

WriteCharData
	ldx ScrollerCurChar
+__auto_FontSelector
	;jsr InsertCharacter_16
	jsr InsertCharacter_8

	inc __auto_jump+1
	inc __auto_jump+1
	rts


ScrollerEffectRestart
	jsr ScrollerDisplayReset
	jmp InsertNewChar

ScrollerEffectDistortTable
	iny
	lda (_MessageScrollerPtr),y
	sta __auto_HorizontalMovement+1
	iny
	lda (_MessageScrollerPtr),y
	sta __auto_HorizontalMovement+2
	jmp EndEffectRead_3

ScrollerEffectDisplayTable
	clc
	iny
	lda (_MessageScrollerPtr),y
	sta __auto_CopyToCharset_DisplayLow+1
	adc #16
	sta __auto_CopyToCharset_DisplayHigh+1
	iny
	lda (_MessageScrollerPtr),y
	sta __auto_CopyToCharset_DisplayLow+2
	adc #0
	sta __auto_CopyToCharset_DisplayHigh+2
	jmp EndEffectRead_3

ScrollerEffectSetColors
	iny
	lda (_MessageScrollerPtr),y
	sta $bb80+40*26
	iny
	lda (_MessageScrollerPtr),y
	sta $bb80+40*27
	jmp EndEffectRead_3

ScrollerEffectSetColumnOffset
	iny
	lda (_MessageScrollerPtr),y
	sta __auto_ScrollerColumnEffect+1
	iny
	lda (_MessageScrollerPtr),y
	sta __auto_ScrollerColumnEffect+2
EndEffectRead_3
	jsr ScrollerIncPointer
EndEffectRead_2
	jsr ScrollerIncPointer
EndEffectRead_1
	jsr ScrollerIncPointer
	jmp InsertNewChar

ScrollerEffectSetFont
	iny
	lda (_MessageScrollerPtr),y
	beq smallFont
bigFont
	lda #<InsertCharacter_16
	sta __auto_FontSelector+1
	lda #>InsertCharacter_16
	sta __auto_FontSelector+2
	jmp EndEffectRead_2

smallFont	
	lda #<InsertCharacter_8
	sta __auto_FontSelector+1
	lda #>InsertCharacter_8
	sta __auto_FontSelector+2
	jmp EndEffectRead_2


_ScrollerPhase2
_ScrollerPhase3
_ScrollerPhase4
_ScrollerPhase5
    jsr CopyAndShift
	inc __auto_jump+1
	inc __auto_jump+1
	rts

_ScrollerPhase6
    jsr CopyAndShift
    ; Reset to the start of the table
	lda #<ScrollerJumpTable
	sta __auto_jump+1
	rts


ScrollerDisplayReset
	lda #<_MessageScroller
	sta _MessageScrollerPtr+0
	lda #>_MessageScroller
	sta _MessageScrollerPtr+1
	rts
	

	

ScrollerIncPointer	
	inc _MessageScrollerPtr
	bne skipscrollermove
	inc _MessageScrollerPtr+1
skipscrollermove
	rts


InsertCharacter_8
.(
	stx __auto_font+1
	ldx #0
	stx __auto_font+2

	asl __auto_font+1
	rol __auto_font+2

	asl __auto_font+1
	rol __auto_font+2

	asl __auto_font+1
	rol __auto_font+2

	clc
	lda #>$9C00
	adc __auto_font+2
	sta __auto_font+2

	lda #<ScrollerBuffer1
	sta scroll_tmp_0+0
	sta scroll_tmp_1+0
	lda #>ScrollerBuffer1
	sta scroll_tmp_0+1
	sta scroll_tmp_1+1

	ldx ScrollerCharacterColumn
loop_insert_character	
__auto_font
	lda $1234,x
	ora #64
	ldy column
	sta (scroll_tmp_1),y
	ldy columnCopy
	sta (scroll_tmp_1),y

	clc
	lda scroll_tmp_1+0
	adc #SCROLLER_BUFFER_WIDTH
	sta scroll_tmp_1+0 
	lda scroll_tmp_1+1
	adc #0
	sta scroll_tmp_1+1 

	inx
	cpx #8
	bne loop_insert_character

loop_clear
	lda #64
	ldy column
	sta (scroll_tmp_1),y
	ldy columnCopy
	sta (scroll_tmp_1),y

	clc
	lda scroll_tmp_1+0
	adc #SCROLLER_BUFFER_WIDTH
	sta scroll_tmp_1+0 
	lda scroll_tmp_1+1
	adc #0
	sta scroll_tmp_1+1 

	inx
	cpx #16
	bne loop_clear

	inc ScrollerCharacterColumn

	lda #0
	sta StupidRotatingMask

	lda #1
	sta ScrollCurCharWidth

	rts
.)

InsertCharacter_16
.(
	lda _FontAddrLow,x
	sta __auto_font+1
	lda _FontAddrHigh,x
	sta __auto_font+2

	lda #<ScrollerBuffer1
	sta scroll_tmp_0+0
	sta scroll_tmp_1+0
	lda #>ScrollerBuffer1
	sta scroll_tmp_0+1
	sta scroll_tmp_1+1

	ldx ScrollerCharacterColumn
loop_insert_character	
__auto_font
	lda $1234,x
	ora #64
	ldy column
	sta (scroll_tmp_1),y
	ldy columnCopy
	sta (scroll_tmp_1),y

	clc
	lda scroll_tmp_1+0
	adc #SCROLLER_BUFFER_WIDTH
	sta scroll_tmp_1+0 
	lda scroll_tmp_1+1
	adc #0
	sta scroll_tmp_1+1 

	inx
	inx
	cpx #32
	bcc loop_insert_character

	inc ScrollerCharacterColumn

	lda #0
	sta StupidRotatingMask

	rts
.)


CopyAndShift
	lda StupidRotatingMask
	lsr
	ora #%11100000
	sta StupidRotatingMask

	ldx #0
loop_shift_character	
	ldy column
	lda (scroll_tmp_0),y

	tay
	lda ScrollTableRight,y
	sta ByteMaskRight
	lda ScrollTableLeft,y
	sta ByteMaskLeft	
	ldy column
	lda (scroll_tmp_1),y
	and #%11100000
	ora ByteMaskLeft
	sta (scroll_tmp_1),y

	ldy columnCopy
	sta tempWhatever
	lda (scroll_tmp_1),y
	and StupidRotatingMask
	ora tempWhatever
	sta (scroll_tmp_1),y


	ldy column
	iny

	lda (scroll_tmp_0),y
	tay
	lda ScrollTableLeft,y
	ora ByteMaskRight	
	ldy column
	iny
	sta (scroll_tmp_1),y

	ldy columnCopy
	iny
	sta (scroll_tmp_1),y

	clc
	lda scroll_tmp_0+0
	adc #SCROLLER_BUFFER_WIDTH
	sta scroll_tmp_0+0 
	lda scroll_tmp_0+1
	adc #0
	sta scroll_tmp_0+1 

	clc
	lda scroll_tmp_1+0
	adc #SCROLLER_BUFFER_WIDTH
	sta scroll_tmp_1+0 
	lda scroll_tmp_1+1
	adc #0
	sta scroll_tmp_1+1 

	inx
	cpx #16
	bne loop_shift_character

	rts


ScrollerOffsetTable_16_Low
	.byt <SCROLLER_BUFFER_WIDTH*0
	.byt <SCROLLER_BUFFER_WIDTH*1
	.byt <SCROLLER_BUFFER_WIDTH*2
	.byt <SCROLLER_BUFFER_WIDTH*3
	.byt <SCROLLER_BUFFER_WIDTH*4
	.byt <SCROLLER_BUFFER_WIDTH*5
	.byt <SCROLLER_BUFFER_WIDTH*6
	.byt <SCROLLER_BUFFER_WIDTH*7
	.byt <SCROLLER_BUFFER_WIDTH*8
	.byt <SCROLLER_BUFFER_WIDTH*9
	.byt <SCROLLER_BUFFER_WIDTH*10
	.byt <SCROLLER_BUFFER_WIDTH*11
	.byt <SCROLLER_BUFFER_WIDTH*12
	.byt <SCROLLER_BUFFER_WIDTH*13
	.byt <SCROLLER_BUFFER_WIDTH*14
	.byt <SCROLLER_BUFFER_WIDTH*15

ScrollerOffsetTable_16_High
	.byt >SCROLLER_BUFFER_WIDTH*0
	.byt >SCROLLER_BUFFER_WIDTH*1
	.byt >SCROLLER_BUFFER_WIDTH*2
	.byt >SCROLLER_BUFFER_WIDTH*3
	.byt >SCROLLER_BUFFER_WIDTH*4
	.byt >SCROLLER_BUFFER_WIDTH*5
	.byt >SCROLLER_BUFFER_WIDTH*6
	.byt >SCROLLER_BUFFER_WIDTH*7
	.byt >SCROLLER_BUFFER_WIDTH*8
	.byt >SCROLLER_BUFFER_WIDTH*9
	.byt >SCROLLER_BUFFER_WIDTH*10
	.byt >SCROLLER_BUFFER_WIDTH*11
	.byt >SCROLLER_BUFFER_WIDTH*12
	.byt >SCROLLER_BUFFER_WIDTH*13
	.byt >SCROLLER_BUFFER_WIDTH*14
	.byt >SCROLLER_BUFFER_WIDTH*15



ScrollerOffsetTable_Double8_Low
	.byt <SCROLLER_BUFFER_WIDTH*0
	.byt <SCROLLER_BUFFER_WIDTH*1
	.byt <SCROLLER_BUFFER_WIDTH*2
	.byt <SCROLLER_BUFFER_WIDTH*3
	.byt <SCROLLER_BUFFER_WIDTH*4
	.byt <SCROLLER_BUFFER_WIDTH*5
	.byt <SCROLLER_BUFFER_WIDTH*6
	.byt <SCROLLER_BUFFER_WIDTH*7
	.byt <SCROLLER_BUFFER_WIDTH*0
	.byt <SCROLLER_BUFFER_WIDTH*1
	.byt <SCROLLER_BUFFER_WIDTH*2
	.byt <SCROLLER_BUFFER_WIDTH*3
	.byt <SCROLLER_BUFFER_WIDTH*4
	.byt <SCROLLER_BUFFER_WIDTH*5
	.byt <SCROLLER_BUFFER_WIDTH*6
	.byt <SCROLLER_BUFFER_WIDTH*7

ScrollerOffsetTable_Double8_High
	.byt >SCROLLER_BUFFER_WIDTH*0
	.byt >SCROLLER_BUFFER_WIDTH*1
	.byt >SCROLLER_BUFFER_WIDTH*2
	.byt >SCROLLER_BUFFER_WIDTH*3
	.byt >SCROLLER_BUFFER_WIDTH*4
	.byt >SCROLLER_BUFFER_WIDTH*5
	.byt >SCROLLER_BUFFER_WIDTH*6
	.byt >SCROLLER_BUFFER_WIDTH*7
	.byt >SCROLLER_BUFFER_WIDTH*0
	.byt >SCROLLER_BUFFER_WIDTH*1
	.byt >SCROLLER_BUFFER_WIDTH*2
	.byt >SCROLLER_BUFFER_WIDTH*3
	.byt >SCROLLER_BUFFER_WIDTH*4
	.byt >SCROLLER_BUFFER_WIDTH*5
	.byt >SCROLLER_BUFFER_WIDTH*6
	.byt >SCROLLER_BUFFER_WIDTH*7



ScrollerOffsetTable_DoubleHeight_Low
	.byt <SCROLLER_BUFFER_WIDTH*0
	.byt <SCROLLER_BUFFER_WIDTH*0
	.byt <SCROLLER_BUFFER_WIDTH*1
	.byt <SCROLLER_BUFFER_WIDTH*1
	.byt <SCROLLER_BUFFER_WIDTH*2
	.byt <SCROLLER_BUFFER_WIDTH*2
	.byt <SCROLLER_BUFFER_WIDTH*3
	.byt <SCROLLER_BUFFER_WIDTH*3
	.byt <SCROLLER_BUFFER_WIDTH*4
	.byt <SCROLLER_BUFFER_WIDTH*4
	.byt <SCROLLER_BUFFER_WIDTH*5
	.byt <SCROLLER_BUFFER_WIDTH*5
	.byt <SCROLLER_BUFFER_WIDTH*6
	.byt <SCROLLER_BUFFER_WIDTH*6
	.byt <SCROLLER_BUFFER_WIDTH*7
	.byt <SCROLLER_BUFFER_WIDTH*7

ScrollerOffsetTable_DoubleHeight_High
	.byt >SCROLLER_BUFFER_WIDTH*0
	.byt >SCROLLER_BUFFER_WIDTH*0
	.byt >SCROLLER_BUFFER_WIDTH*1
	.byt >SCROLLER_BUFFER_WIDTH*1
	.byt >SCROLLER_BUFFER_WIDTH*2
	.byt >SCROLLER_BUFFER_WIDTH*2
	.byt >SCROLLER_BUFFER_WIDTH*3
	.byt >SCROLLER_BUFFER_WIDTH*3
	.byt >SCROLLER_BUFFER_WIDTH*4
	.byt >SCROLLER_BUFFER_WIDTH*4
	.byt >SCROLLER_BUFFER_WIDTH*5
	.byt >SCROLLER_BUFFER_WIDTH*5
	.byt >SCROLLER_BUFFER_WIDTH*6
	.byt >SCROLLER_BUFFER_WIDTH*6
	.byt >SCROLLER_BUFFER_WIDTH*7
	.byt >SCROLLER_BUFFER_WIDTH*7



ScrollerOffsetTable_Mirrored_Low
	.byt <SCROLLER_BUFFER_WIDTH*0
	.byt <SCROLLER_BUFFER_WIDTH*1
	.byt <SCROLLER_BUFFER_WIDTH*2
	.byt <SCROLLER_BUFFER_WIDTH*3
	.byt <SCROLLER_BUFFER_WIDTH*4
	.byt <SCROLLER_BUFFER_WIDTH*5
	.byt <SCROLLER_BUFFER_WIDTH*6
	.byt <SCROLLER_BUFFER_WIDTH*7
	.byt <SCROLLER_BUFFER_WIDTH*7
	.byt <SCROLLER_BUFFER_WIDTH*6
	.byt <SCROLLER_BUFFER_WIDTH*5
	.byt <SCROLLER_BUFFER_WIDTH*4
	.byt <SCROLLER_BUFFER_WIDTH*3
	.byt <SCROLLER_BUFFER_WIDTH*2
	.byt <SCROLLER_BUFFER_WIDTH*1
	.byt <SCROLLER_BUFFER_WIDTH*0

ScrollerOffsetTable_Mirrored_High
	.byt >SCROLLER_BUFFER_WIDTH*0
	.byt >SCROLLER_BUFFER_WIDTH*1
	.byt >SCROLLER_BUFFER_WIDTH*2
	.byt >SCROLLER_BUFFER_WIDTH*3
	.byt >SCROLLER_BUFFER_WIDTH*4
	.byt >SCROLLER_BUFFER_WIDTH*5
	.byt >SCROLLER_BUFFER_WIDTH*6
	.byt >SCROLLER_BUFFER_WIDTH*7
	.byt >SCROLLER_BUFFER_WIDTH*7
	.byt >SCROLLER_BUFFER_WIDTH*6
	.byt >SCROLLER_BUFFER_WIDTH*5
	.byt >SCROLLER_BUFFER_WIDTH*4
	.byt >SCROLLER_BUFFER_WIDTH*3
	.byt >SCROLLER_BUFFER_WIDTH*2
	.byt >SCROLLER_BUFFER_WIDTH*1
	.byt >SCROLLER_BUFFER_WIDTH*0



ScrollBufferAddrLow 	
	.byt <ScrollerBuffer6+2
	.byt <ScrollerBuffer5+2
	.byt <ScrollerBuffer4+2
	.byt <ScrollerBuffer3+2
	.byt <ScrollerBuffer2+2
	.byt <ScrollerBuffer1+2
	; Garbage
	.byt <_ScrollerDisplay

ScrollBufferAddrHigh
	.byt >ScrollerBuffer6+2
	.byt >ScrollerBuffer5+2
	.byt >ScrollerBuffer4+2
	.byt >ScrollerBuffer3+2
	.byt >ScrollerBuffer2+2
	.byt >ScrollerBuffer1+2
	; Garbage
	.byt >_ScrollerDisplay

ScrollBufferCounter	.byt 1

ScrollScanlineStartLow	.dsb 16
ScrollScanlineStartHigh	.dsb 16

ScrollHorizontalOffset	
	.byt 0
	.byt 1
	.byt 2
	.byt 3
	.byt 4
	.byt 5
	.byt 6
	.byt 7
	.byt 8
	.byt 9
	.byt 10
	.byt 11
	.byt 12
	.byt 13
	.byt 14
	.byt 15

TableSelectLine
	.byt 0
	.byt 1
	.byt 2
	.byt 3
	.byt 4
	.byt 5


moduloTmp	.byt 0
divTmp		.byt 0
globalcosTmp		.byt 0
globalcosTmp2		.byt 0

localcosTmp		.byt 0
localcosTmp2		.byt 0



HorizontalMovementNormal
.(
	lda #0
	ldx #0
loop_fill_table	
	sta ScrollHorizontalOffset,x
	inx
	cpx #16
	bne loop_fill_table
	rts
.)


HorizontalMovementSinusDistorter
.(
	ldy globalcosTmp
	iny
	sty globalcosTmp

	ldx #0
loop_cos	
	/*
	ldy localcosTmp
	iny
	iny
	iny
	sty localcosTmp
	lda _CosTable8,y

	ldy localcosTmp2
	iny
	iny
	iny
	iny
	iny
	sty localcosTmp2
	clc
	adc _CosTable8,y
	*/
	lda _CosTableDistorter,y
	iny
	sta ScrollHorizontalOffset,x
	inx
	cpx #16
	bne loop_cos
	rts
.)


HandleHorizontalScrollerMovement
.(
	.(
	ldx ScrollBufferCounter
	inx 
	cpx #42*6
	bne skip
	ldx #0
skip
	stx ScrollBufferCounter
	.)

+__auto_HorizontalMovement
	jsr HorizontalMovementSinusDistorter



	ldx #0
loop_y

	clc
	lda ScrollBufferCounter
	adc ScrollHorizontalOffset,x
	tay

	lda TableModulo6,y
	sta moduloTmp

	lda TableDivBy6,y
	sta divTmp

	ldy moduloTmp

	clc
	lda ScrollBufferAddrLow,y
	adc divTmp
	sta scroll_ptr_0+0
	lda ScrollBufferAddrHigh,y
	adc #0
	sta scroll_ptr_0+1


	clc
	lda scroll_ptr_0+0
+__auto_CopyToCharset_DisplayLow	
	adc ScrollerOffsetTable_16_Low,x
	sta ScrollScanlineStartLow,x

	lda scroll_ptr_0+1
+__auto_CopyToCharset_DisplayHigh
	adc ScrollerOffsetTable_16_High,x
	sta ScrollScanlineStartHigh,x

	inx
	cpx #16
	bne loop_y	
	rts
.)



CopyToCharset
.(
	jsr HandleHorizontalScrollerMovement   ; -> 2355 cycles
	jsr HandleVerticalScrollerMovement     ; -> 2991 cycles

	ldx #0
loop
	lda ScrollScanlineStartLow,x
	sta scroll_ptr_1+0
	lda ScrollScanlineStartHigh,x
	sta scroll_ptr_1+1

	ldy #0
	lda (scroll_ptr_1),y
	and DitheringLeft,x
+__auto_CopyToCharset_Column_0
	sta $9800+32*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_1
	sta $9800+34*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_2
	sta $9800+36*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_3
	sta $9800+38*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_4
	sta $9800+40*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_5
	sta $9800+42*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_6
	sta $9800+44*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_7
	sta $9800+46*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_8
	sta $9800+48*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_9
	sta $9800+50*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_10
	sta $9800+52*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_11
	sta $9800+54*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_12
	sta $9800+56*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_13
	sta $9800+58*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_14
	sta $9800+60*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_15
	sta $9800+62*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_16
	sta $9800+64*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_17
	sta $9800+66*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_18
	sta $9800+68*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_19
	sta $9800+70*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_20
	sta $9800+72*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_21
	sta $9800+74*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_22
	sta $9800+76*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_23
	sta $9800+78*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_24
	sta $9800+80*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_25
	sta $9800+82*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_26
	sta $9800+84*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_27
	sta $9800+86*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_28
	sta $9800+88*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_29
	sta $9800+90*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_30
	sta $9800+92*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_31
	sta $9800+94*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_32
	sta $9800+96*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_33
	sta $9800+98*8,x

	iny
	lda (scroll_ptr_1),y
+__auto_CopyToCharset_Column_34
	sta $9800+100*8,x

	iny
	lda (scroll_ptr_1),y
	and DitheringRight,x	
+__auto_CopyToCharset_Column_35
	sta $9800+102*8,x

	inx
	cpx #16
	beq end
    jmp loop
end

	rts
.)


ScrollerPatchTable_Low
	.byt <__auto_CopyToCharset_Column_0
	.byt <__auto_CopyToCharset_Column_1
	.byt <__auto_CopyToCharset_Column_2
	.byt <__auto_CopyToCharset_Column_3
	.byt <__auto_CopyToCharset_Column_4
	.byt <__auto_CopyToCharset_Column_5
	.byt <__auto_CopyToCharset_Column_6
	.byt <__auto_CopyToCharset_Column_7
	.byt <__auto_CopyToCharset_Column_8
	.byt <__auto_CopyToCharset_Column_9
	.byt <__auto_CopyToCharset_Column_10
	.byt <__auto_CopyToCharset_Column_11
	.byt <__auto_CopyToCharset_Column_12
	.byt <__auto_CopyToCharset_Column_13
	.byt <__auto_CopyToCharset_Column_14
	.byt <__auto_CopyToCharset_Column_15
	.byt <__auto_CopyToCharset_Column_16
	.byt <__auto_CopyToCharset_Column_17
	.byt <__auto_CopyToCharset_Column_18
	.byt <__auto_CopyToCharset_Column_19
	.byt <__auto_CopyToCharset_Column_20
	.byt <__auto_CopyToCharset_Column_21
	.byt <__auto_CopyToCharset_Column_22
	.byt <__auto_CopyToCharset_Column_23
	.byt <__auto_CopyToCharset_Column_24
	.byt <__auto_CopyToCharset_Column_25
	.byt <__auto_CopyToCharset_Column_26
	.byt <__auto_CopyToCharset_Column_27
	.byt <__auto_CopyToCharset_Column_28
	.byt <__auto_CopyToCharset_Column_29
	.byt <__auto_CopyToCharset_Column_30
	.byt <__auto_CopyToCharset_Column_31
	.byt <__auto_CopyToCharset_Column_32
	.byt <__auto_CopyToCharset_Column_33
	.byt <__auto_CopyToCharset_Column_34
	.byt <__auto_CopyToCharset_Column_35

ScrollerPatchTable_High
	.byt >__auto_CopyToCharset_Column_0
	.byt >__auto_CopyToCharset_Column_1
	.byt >__auto_CopyToCharset_Column_2
	.byt >__auto_CopyToCharset_Column_3
	.byt >__auto_CopyToCharset_Column_4
	.byt >__auto_CopyToCharset_Column_5
	.byt >__auto_CopyToCharset_Column_6
	.byt >__auto_CopyToCharset_Column_7
	.byt >__auto_CopyToCharset_Column_8
	.byt >__auto_CopyToCharset_Column_9
	.byt >__auto_CopyToCharset_Column_10
	.byt >__auto_CopyToCharset_Column_11
	.byt >__auto_CopyToCharset_Column_12
	.byt >__auto_CopyToCharset_Column_13
	.byt >__auto_CopyToCharset_Column_14
	.byt >__auto_CopyToCharset_Column_15
	.byt >__auto_CopyToCharset_Column_16
	.byt >__auto_CopyToCharset_Column_17
	.byt >__auto_CopyToCharset_Column_18
	.byt >__auto_CopyToCharset_Column_19
	.byt >__auto_CopyToCharset_Column_20
	.byt >__auto_CopyToCharset_Column_21
	.byt >__auto_CopyToCharset_Column_22
	.byt >__auto_CopyToCharset_Column_23
	.byt >__auto_CopyToCharset_Column_24
	.byt >__auto_CopyToCharset_Column_25
	.byt >__auto_CopyToCharset_Column_26
	.byt >__auto_CopyToCharset_Column_27
	.byt >__auto_CopyToCharset_Column_28
	.byt >__auto_CopyToCharset_Column_29
	.byt >__auto_CopyToCharset_Column_30
	.byt >__auto_CopyToCharset_Column_31
	.byt >__auto_CopyToCharset_Column_32
	.byt >__auto_CopyToCharset_Column_33
	.byt >__auto_CopyToCharset_Column_34
	.byt >__auto_CopyToCharset_Column_35



SetScrollerDisplayTop
	.(
	lda #0
	ldx #40
loop_columns_offset
	sta _ColumnOffsetBuffer-1,x
	dex
	bne loop_columns_offset		
	rts
	.)

SetScrollerDisplayBottom
	.(
	lda #8
	ldx #40
loop_columns_offset
	sta _ColumnOffsetBuffer-1,x
	dex
	bne loop_columns_offset		
	rts
	.)

SetScrollerDisplayDiagonale1
	.(
	lda #0
	ldx #0
loop_columns_offset
	sta _ColumnOffsetBuffer,x
	inx
	sta _ColumnOffsetBuffer,x
	inx
	sta _ColumnOffsetBuffer,x
	inx
	sta _ColumnOffsetBuffer,x

	tay
	iny
	tya

	inx
	cpx #38
	bcc loop_columns_offset		
	rts
	.)


SetScrollerDisplayCamShaft
	.(
	ldx WaveOffset
	inx
	inx
	inx
	inx
	stx WaveOffset
	stx WaveOffset2

	ldx #0
loop_columns_offset
	ldy WaveOffset2
	iny
	iny
	iny
	iny
	iny
	sty WaveOffset2
	lda _CosTable8,y   ; 0-8

	sta _ColumnOffsetBuffer+0,x
	sta _ColumnOffsetBuffer+18,x

	inx
	cpx #9
	bne loop_columns_offset		
	rts
	.)


SetScrollerDisplaySinus
	.(
	ldx WaveOffset
	inx
	inx
	inx
	inx
	stx WaveOffset
	stx WaveOffset2

	ldx #0
loop_columns_offset
	ldy WaveOffset2
	iny
	iny
	iny
	iny
	iny
	sty WaveOffset2
	lda _CosTable8,y   ; 0-8

	sta _ColumnOffsetBuffer,x

	inx
	cpx #36
	bne loop_columns_offset		
	rts
	.)


HandleVerticalScrollerMovement
	;jmp HandleVerticalScrollerMovement
.(
	;jsr SetScrollerDisplayTop
	;jsr SetScrollerDisplaySinus
	;jsr SetScrollerDisplayDiagonale1
+__auto_ScrollerColumnEffect	
	jsr SetScrollerDisplayCamShaft

	lda #<$9800+32*8
	sta scroll_dist_ptr_0+0
	lda #>$9800+32*8
	sta scroll_dist_ptr_0+1

	clc
	ldx #0
loop
	lda ScrollerPatchTable_Low,x
	sta scroll_dist_ptr_1+0
	lda ScrollerPatchTable_High,x
	sta scroll_dist_ptr_1+1

	;clc
	ldy #1
	lda _ColumnOffsetBuffer,x
	adc scroll_dist_ptr_0+0
	sta (scroll_dist_ptr_1),y
	iny
	lda scroll_dist_ptr_0+1
	adc #0
	sta (scroll_dist_ptr_1),y

	;clc
	lda scroll_dist_ptr_0+0
	adc #16
	sta scroll_dist_ptr_0+0
	bcc skip
	inc scroll_dist_ptr_0+1
skip

	inx
	cpx #36
	bne loop
    rts
.)

