
_MessageScroller
	.asc "Assembly 2002. 11th consecutive event. Stuff you've never seen before. "
	.asc "More preparations than ever before. Commitment like you've never "
	.asc "witnessed before.                Assembly 2002 -- Bringing back the fun, "
	.asc "the attitude and That Thing You Used To Do to it. Hell yea! Don't take everything "
	.asc "too seriously ;)          ---         They helped making this intro happen:           "
	.asc "Paul 'Lone Starr' Endresen      Rob 'you know him' Hubbard          "
	.asc "God bless you for your influence.           -               Here we go! Wuuuup. "
	.asc "Assembly 2002 - a phenomal list of guest speakers including Rob Hubbard, "
	.asc "Bjorn 'Dr. Awesome' Lynne, Paul 'Lone Starr/Spaceballs' Endresen, Carlos 'Made/Bomb' Pardo "
	.asc "and many, many others! Largest ever sum of prices given away in a demoscene event and live "
	.asc "concert featuring Machinae Supremacy guest starring Rob Hubbard, Tero (Deetsay/Orange), CNCD "
	.asc "and Crankshaft (Yolk/CNCD).         -           This all on top of our 'usual' party hooplas. "
	.asc "Damn! Helsinki - Hartwall Areena - 1.-4. August. That Thing You Used To Do -- get back to it!  "
	.asc "- www.assembly.org -           -           Deck on the keys. Ha! Massive f*cking respect to Jmagic, "
	.asc "Jugi, Heatbeat and Britelite/Dekadence, Shape&THG/DCS and H7/TRSI for making this intro possible. "
	.asc "Schedule was tight but you just gotta be bloody awed seeing how these dudes pulled it off - especially "
	.asc "Jmagic and Jugi. You guys, beer will not be running out for you this Boozembly.           -           "
	.asc "People often ask me why do I keep myself bothered with these scene things.. It's because where I am "
	.asc "I am mostly because of the scene. Things I've learned. Things I've seen. Things I've experienced. "
	.asc "Every time I'm organizing something I'm listening to old modules from back in the day, watching - "
	.asc "or atleast remembering - old demos. Stuff like that. And yea, I DO have a life you know if that's "
	.asc "what you're thinking ;)  Jester/Sanity said it in one of his great modules; So if it all ends tomorrow, "
	.asc "I've seen it what's it like -- And I've had a good ride.              -       "
	.asc "A hand out to these people.. In NO order! Over the years, you've maked it all worthwhile.       "
	.asc "Heatbeat, Jmagic, Jugi, Made, Lone Starr, Chaos, Scoopex allstars, Murk, Rob Hubbard, Jester, Stobo, "
	.asc "Stargazer, Dizzy, Spaceman, Bit Arts, Audiomonster, Bruno, Cutcreator, Dean, Delorean, Dj. Joge, Dr. Awesome, "
	.asc "Dreamer, Dreamfish, Dune, Echo, Emax, Greg, Groo, Merge, Moby, Mr. Man, Nightshade, Reflex, Romeo Knight, "
	.asc "S.L.L, Slide, Subject, Supernao, Travolta, Ukulele, Yolk&Legend, Barry Leitch, Mantronix&Tip. Mostly musicians "
	.asc "I know.. Plus a lot, a lot of other people aswell but just can't remember them right at the moment.. Let's "
	.asc "just say that all of you coders and graphicians - mid-nineties Amiga-elites out there still able to read this! "
	.asc "If you ever get around Finland, feel welcomed to drop in, any time.               -               "
	.asc "About Assembly.. If we get 1 out of 100 gamers to even think about doing something for the scene.. "
	.asc "Then we're there. We've reached our goal. -- Deck/Scoopex//Assembly Org signing off - Res-f*cking-pect "
	.asc "for all of you sceners out there, oldskool or not. Keep doing your stuff and other people will follow you.            "
	.asc "It's Abyss // AsmOrg & FC hitting the keyboard now. Man, it's been like years since     I last wrote scrollers "
	.asc "for Future Crew prods, so this does feel like trip back in time! A lot has changed since - the people "
	.asc "have come and gone, the scene has changed and grown, controversy and diverse opinions abound. Still "
	.asc "something has stayed true     and unchanging for me. The commitment to the scene is the driving force "
	.asc "behind  ASSEMBLY. Sure, it's big, filled with gamers, commercial and bad for your mental health, "
	.asc "but still it manages to attract the movers and shakers of the demo scene.       Judge us by the releases "
	.asc "made at ASSEMBLY. Some of the most legendary demos have been released here - from Unreal and Second "
	.asc "Reality to Spot and Lapsuus.            --          We have the total party package for you this year. "
	.asc "Legends like Rob Hubbard and Lone Starr, seminars with outstanding speakers, tough compos with more than     "
	.asc "40 000 euros in prizes, a great oldskool party area complete with free coffee   and sofas, a monster of a "
	.asc "concert with the likes of Machinae Supremacy and CNCD -   so come and prove that the scene is alive!          "
	.asc "--              Utmost respect to Deck for putting the wheels in motion and getting this invtro done!   "
	.asc "A big hand to the dudes: Jmagic, Jugi, Heatbeat and Britelite/Dekadence, Shape&THG/DCS and H7/TRSI "
	.asc "for getting the invtro done in a record time!                 My deepest thanks to all of the 200 volunteers "
	.asc "making ASSEMBLY possible!                Some personal shouts must go out to Embo, Tee, Henchman, Marvel, "
	.asc "Pixel, Skaven, PSI, Trug, Gore, FTJ, Trixter, the FSC gang, RC, Captain and Hypponen. Pure love to my honey Eija! "
	.asc "                            "
	.byt 0


_InterruptInstall
	sei
	lda #$20		; jsr
	sta $400
	lda #<_InterruptCode
	sta $401
	lda #>_InterruptCode
	sta $402
	lda #$60
	sta $403		; rts
	cli	
	rts

FlipCounter1	.byt 0
FlipCounter2	.byt 0

_VblCounter		.byt 0


_VSync
	lda _VblCounter
	beq _VSync
	lda #0
	sta _VblCounter
	rts



_InterruptCode
	inc FlipCounter1
	lda FlipCounter1
	and #2
	beq _InterruptCodeEnd

	lda #0
	sta FlipCounter1
	inc _VblCounter

	jsr _ScrollerDisplay

	inc FlipCounter2
	lda FlipCounter2
	and #2
	beq _InterruptCodeEnd

	lda #0
	sta FlipCounter2

	jsr _TeletypeUpdate

_InterruptCodeEnd
	rts


_MessageScrollerPtr	.word _MessageScroller


_ScrollerInit
	; paper
	lda #16+1
	sta $a000+40*0

	lda #16+1
	sta $a000+40*7

	lda #16+4
	sta $a000+40*1
	sta $a000+40*6


	lda #16+4
	sta $a000+40*2
	sta $a000+40*5

	lda #16+4
	sta $a000+40*3
	sta $a000+40*4

	ldx #38
	lda #64
ScrollerInitEraseLoop
	sta $a000+40*0,x
	sta $a000+40*1,x
	sta $a000+40*2,x
	sta $a000+40*3,x
	sta $a000+40*4,x
	sta $a000+40*5,x
	sta $a000+40*6,x
	sta $a000+40*7,x
	dex 
	bne ScrollerInitEraseLoop
	rts









ScrollerCounter		.byt 0

ScrollerCharBuffer	.byt 0,1,2,3,4,5,6,7	; Buffer with character to scroll

_ScrollerDisplay
;Break jmp Break

	lda ScrollerCounter
	beq ScrollerNewCharacter

	dec ScrollerCounter
	jmp ScrollerEndNewCharacter

ScrollerNewCharacter
	lda #6
	sta ScrollerCounter

	; message
	lda _MessageScrollerPtr
	sta tmp6
	lda _MessageScrollerPtr+1
	sta tmp6+1

	inc _MessageScrollerPtr
	bne skipscrollermove
	inc _MessageScrollerPtr+1
skipscrollermove

	; Get character and write into the buffer
	ldy #0
	lda (tmp6),y
	beq ScrollerDisplayReset 

	sta tmp7
	lda #0
	sta tmp7+1

	asl tmp7
	rol tmp7+1

	asl tmp7
	rol tmp7+1

	asl tmp7
	rol tmp7+1

	clc
	lda #<_picture_font_2-32*8
	adc tmp7
	sta tmp7
	lda #>_picture_font_2-32*8
	adc tmp7+1
	sta tmp7+1

	ldy #0
loopcopychar
	lda (tmp7),y
	ora #64
	sta ScrollerCharBuffer,y
	iny
	cpy #8
	bne loopcopychar

ScrollerEndNewCharacter


;Break jmp Break

	lda #<$a000
	sta tmp6
	lda #>$a000
	sta tmp6+1


	ldx #0
ScrollerDisplayLoopMessageY
	; Get pixel from character
	clc
	lda ScrollerCharBuffer,x
	rol
	cmp #192
	and #$3F
	ora #64
	sta ScrollerCharBuffer,x

	; And then scroll the whole scanline
	ldy #38
ScrollerDisplayLoopMessageX
	lda (tmp6),y
	rol
	cmp #192
	and #%00111111
	ora #%01000000
	sta (tmp6),y

	dey
	bne ScrollerDisplayLoopMessageX

	clc
	lda tmp6
	adc #40
	sta tmp6
	bcc skipkipppp
	inc tmp6+1
skipkipppp

	inx
	cpx #8
	bne ScrollerDisplayLoopMessageY

	rts


ScrollerDisplayReset
	lda #<_MessageScroller
	sta _MessageScrollerPtr
	lda #>_MessageScroller
	sta _MessageScrollerPtr+1
	rts




TeletypeMessage
	;     0123456789012345678901234567890123456789
	.asc "ASSEMBLY.ORG production:",3,"ASSEMBLY 2002",0
	.asc " ",0
	.asc 4,"Starring:",0
	.asc "  JUGI KAARINEN",0
	.asc "  JMAGIC HEIKKINEN.",0
	.asc " ",0
	.asc 4,"Produced by:",0
	.asc "  PEKKA AAKKO",0
	.asc " ",0
	.asc 4,"Directed by:",0
	.asc "  JUSSI LAAKKONEN",0
	.asc " ",0
	.asc 4,"Also starring:",0
	.asc "  ALEKSI 'HEATBEAT' EEBEEN",0
	.asc "  JUUSO 'DECK' SALMIJARVI",0
	.asc " ",0
	.asc 4,"Oric port by:",0
	.asc "  JONATHAN 'TWILIGHTE' BRISTOW",0
	.asc "  JEROME 'JEDE' DEBRUNE",0
	.asc "  MICKAEL 'DBUG' POINTIER",0
	.asc " ",0
	.asc 4,"ASSEMBLY.ORG website:",0
	;     0123456789012345678901234567890123456789
	.asc "       http://www.assembly.org         ",0
	.asc " ",0
	.asc 4,"DEFENCE FORCE website:",0
	;     0123456789012345678901234567890123456789
	.asc "    http://www.defence-force.org       ",0
	.asc " ",0

	.asc " ",0
	.asc " ",0
	.asc " ",0
	.asc 1

TeletypeMessagePtr	.word TeletypeMessage
TeletypeXPos		.byt 0

_TeletypeUpdate
	; Red paper
	lda #17
	sta $bf68+40*0
	sta $bf68+40*1
	sta $bf68+40*2

	; Insert new char
	lda TeletypeMessagePtr
	sta tmp6
	lda TeletypeMessagePtr+1
	sta tmp6+1

	ldy #0

	lda (tmp6),y
	cmp #1
	bne TeletypeNoEndOfText

	; Reinitialise to begin of message
	; and reload character
	lda #<TeletypeMessage
	sta TeletypeMessagePtr
	sta tmp6
	lda #>TeletypeMessage
	sta TeletypeMessagePtr+1
	sta tmp6+1
	jmp	TeletypeScrollUp

TeletypeNoEndOfText

	inc TeletypeMessagePtr
	bne skipteletypemove
	inc TeletypeMessagePtr+1
skipteletypemove

	cmp #0
	beq TeletypeScrollUp

	ldx TeletypeXPos
	sta $bf68+40*2+1,x
	inc TeletypeXPos

	rts


TeletypeScrollUp
	ldx #39
TeletypeScrollUpLoopX
	lda $bf68+40*1,x
	sta $bf68+40*0,x
	lda $bf68+40*2,x
	sta $bf68+40*1,x
	lda #32
	sta $bf68+40*2,x
	dex
	bne TeletypeScrollUpLoopX

	ldx #0
	stx TeletypeXPos
	rts



_MessageAssemblyIntro
	.asc "ASSEMBLY 2002.",0
	.asc " 11TH CONSECUTIVE EVENT.",0
	.asc "  STUFF YOU HAVE NEVER SEEN BEFORE.",0
	.asc "   MORE PREPARATIONS THAN EVER",0
	.asc "    BEFORE.",0
	.asc "     COMMITMENT LIKE YOU HAVE NEVER",0
	.asc "      WITNESSED BEFORE.",0
	.asc " ",0
	.asc "ASSEMLY 2002 BRINGING BACK THE FUN",0
	.asc " THE ATTITUDE AND THAT THING YOU",0
	.asc "  USED TO DO IT.",0
	.asc "   HELL YEA DON'T TAKE EVERYTHING TOO",0
	.asc "    SERIOUSLY",0
	.asc 1


_MessageFightersIntro
	.asc "DURING THE ASSEMBLY, YOU",0
	.asc "WILL ENCOUNTER VARIOUS",0
	.asc "FIGHTERS... HERE'S A SHORT",0
	.asc "INTRODUCTION TO SOME OF THE",0
	.asc "MOST DANGEROUS ONES.",0
	.asc 1


_MessageFighterPehu
	.asc "PEHU HAS A SET OF",0
	.asc "POWERFUL SPELLS TO",0
	.asc "LAME ANY OPPONENT",0
	.asc "HE STARTS TO FIGHT",0
	.asc "WITH.",0
	.asc "SPECIAL ABILITIES:",0
	.asc "SPELL OF",0
	.asc "CONFISCATION",0
	.asc "OF BEVERAGES",0
	.asc 1

_MessageFighterAbyss
	.asc "WITH HIS POWERFULL TOOLS,",0
	.asc "ABYSS CAN CONTACT HIS",0
	.asc "ARMY FROM GREAT",0
	.asc "DISTANCES.",0
	.asc "COMBINED WITH SPECIAL",0
	.asc "KICKBOARDPORTATION",0
	.asc "TRICK,THIS MAKES",0
	.asc "HIM VERY MOBILE FIGHTER.",0
	.asc "ABYSS CANNOT MOVE",0
	.asc "OFF-ROAD, SO USE",0
	.asc "THE ENVIRONMENT",0
	.asc "WISELY AS A",0
	.asc "DEFENCE.",0
	.asc 1

_MessageFighterEetu
	.asc "EETU IS THE MASTER OF",0
	.asc "CAMOUFLAGE AND MAN WITH",0
	.asc "SEVERAL TOURNAMENT",0
	.asc "VICTORIES.",0
	.asc "YOU MIGHT MEET THIS",0
	.asc "FIGHTER WITH ONE FACE",0
	.asc "BUT IN SEVERAL PHYSICAL",0
	.asc "BODIES.",0
	.asc 1

_MessageFighterSivu
	.asc "WITH SURPRISING STAMINA,",0
	.asc "SIVU KEEPS ON FIGHTING",0
	.asc "TILL THE VERY END.",0
	.asc "SPECIAL ABILITIES:",0
	.asc "TOURNAMENT ENDURANCE",0
	.asc 1

_MessageFighterVirne
	.asc "VIRNE IS A WIZARD WHO IS",0
	.asc "ESPECIALLY STRONG IN SPIRIT.",0
	.asc "HIS MAGICAL POTIONS AND FAMOUS",0
	.asc "GRILL OF FIRE CAN HAVE VERY",0
	.asc "SURPRINSING RESULTS AND",0
	.asc "ATTRACT OTHER FIREFIGHTERS.",0
	.asc 1



