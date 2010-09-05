;; Main code for scenes...

#if 0

#define ST_ROW $a000+165*40

thingy
.(
	lda tmp0+1
	sta tmp1+1
	lda tmp0
	sec
	sbc #40*2
	sta tmp1
	bcs nocarry1
	dec tmp1+1
nocarry1

	lda tmp1+1
	sta tmp2+1
	lda tmp1
	sec
	sbc #40*2
	sta tmp2
	bcs nocarry2
	dec tmp2+1
nocarry2

	lda tmp2+1
	sta tmp3+1
	lda tmp2
	sec
	sbc #40*2
	sta tmp3
	bcs nocarry3
	dec tmp3+1
nocarry3

	lda tmp3+1
	sta tmp4+1
	lda tmp3
	sec
	sbc #40*2
	sta tmp4
	bcs nocarry4
	dec tmp4+1
nocarry4

	rts
.)

_BurnText
.(
	lda #<ST_ROW
	sta tmp0
	lda #>ST_ROW
	sta tmp0+1
	jsr thingy

	ldx #75
loop
	ldy #0
	lda #1
	sta (tmp1),y
	lda #2
	sta (tmp2),y
	lda #4
	sta (tmp3),y

	ldy #40
	lda #1
	sta (tmp1),y
	lda #2
	sta (tmp2),y
	lda #4
	sta (tmp3),y

.(
	ldy #39
	jsr randgen
	ora #%11000000
	sta tmp
loop2
	lda #$40
	sta (tmp0),y

	lda tmp
	and (tmp1),y
	sta (tmp1),y
	
	lda tmp
	and (tmp2),y
	sta (tmp2),y

	lda tmp
	and (tmp3),y
	sta (tmp3),y

	dey
	bne loop2
.)

.(
	ldy #39+40
	jsr randgen
	ora #%11000000
	sta tmp
loop2
	lda #$40
	sta (tmp0),y

	lda tmp
	and (tmp1),y
	sta (tmp1),y
	
	lda tmp
	and (tmp2),y
	sta (tmp2),y

	lda tmp
	and (tmp3),y
	sta (tmp3),y

	dey
	cpy #40
	bne loop2

.)


	stx sav_x+1

	ldy #$40
loopw
	ldx #$ff
loopw1
	dex
	bne loopw1
	dey
	bne loopw
sav_x
	ldx #0	;SMC

	lda tmp0
	sec
	sbc #40*2
	sta tmp0
	bcs nocarry
	dec tmp0+1
nocarry
	jsr thingy
	dex
	bmi end
	jmp loop

end
	rts
.)


#endif


#define ST_ROW $a000

thingy
.(
	lda tmp0+1
	sta tmp1+1
	lda tmp0
	clc
	adc #40*2
	sta tmp1
	bcc nocarry1
	inc tmp1+1
nocarry1

	lda tmp1+1
	sta tmp2+1
	lda tmp1
	clc
	adc #40*2
	sta tmp2
	bcc nocarry2
	inc tmp2+1
nocarry2

	lda tmp2+1
	sta tmp3+1
	lda tmp2
	clc
	adc #40*2
	sta tmp3
	bcc nocarry3
	inc tmp3+1
nocarry3

	lda tmp3+1
	sta tmp4+1
	lda tmp3
	clc
	adc #40*2
	sta tmp4
	bcc nocarry4
	inc tmp4+1
nocarry4

	rts
.)

_BurnText
.(
	lda #<ST_ROW
	sta tmp0
	lda #>ST_ROW
	sta tmp0+1
	jsr thingy

	ldx #90
loop
	ldy #0
	lda #1
	sta (tmp1),y
	lda #3
	sta (tmp2),y
	lda #4
	sta (tmp3),y

	ldy #40
	lda #1
	sta (tmp1),y
	lda #3
	sta (tmp2),y
	lda #4
	sta (tmp3),y

.(
	ldy #39
loop2
	lda #$40
	sta (tmp0),y

	jsr randgen
	ora #%11000000
	and (tmp1),y
	sta (tmp1),y
	
	jsr randgen
	ora #%11000000
	and (tmp2),y
	sta (tmp2),y

	jsr randgen
	ora #%11000000
	and (tmp3),y
	sta (tmp3),y

	dey
	bne loop2
.)

.(
	ldy #39+40
loop2
	lda #$40
	sta (tmp0),y

	jsr randgen
	ora #%11000000
	and (tmp1),y
	sta (tmp1),y
	
	jsr randgen
	ora #%11000000
	and (tmp2),y
	sta (tmp2),y

	jsr randgen
	ora #%11000000
	and (tmp3),y
	sta (tmp3),y

	dey
	cpy #40
	bne loop2

.)


	stx sav_x+1

	ldy #$30
loopw
	ldx #$ff
loopw1
	dex
	bne loopw1
	dey
	bne loopw
sav_x
	ldx #0	;SMC

	lda tmp0
	clc
	adc #40*2
	sta tmp0
	bcc nocarry
	inc tmp0+1
nocarry
	jsr thingy
	dex
	beq end
	jmp loop

end
	rts
.)

/*
_Breakme
.(
	lda #0
dbug beq dbug
	rts
.)

*/

_Wait
.(
	ldy #0
	lda (sp),y
	sta tmp
loop
	jsr Wait
	dec tmp
	bne loop
	rts
.)

Wait
.(
	ldy #$ff/2
loop2
	ldx #$ff
loop
	dex
	bne loop
	dey
	bne loop2
	rts
.)


_DumpWideBuff
.(	
	lda #WIDTH
	sta dump_buf+1
	;jmp dump_buf
	rts
.)

_ClearWideBuff
.(
	jsr _clr_scenearea
 	jmp set_ink2
.)

_ShowThargoid
.(
	; Unpack & show
	;lda #<buffer
	lda #<$a000+50*40
	sta ptr_destination
	;lda #>buffer
	lda #>$a000+50*40
	sta ptr_destination+1
	lda #<thargoid
	sta ptr_source
	lda #>thargoid
	sta ptr_source+1
 
	jsr _FileUnpack
	jmp _DumpWideBuff
.)

_ShowBadguy
.(
	; Unpack & show
	;lda #<buffer
	lda #<$a000+50*40
	sta ptr_destination
	;lda #>buffer
	lda #>$a000+50*40
	sta ptr_destination+1
	lda #<badguy
	sta ptr_source
	lda #>badguy
	sta ptr_source+1
 
	jsr _FileUnpack
	jmp _DumpWideBuff
.)

_ShowLogo
.(
	; Unpack & show
	;lda #<buffer
	lda #<$a000
	sta ptr_destination
	;lda #>buffer
	lda #>$a000
	sta ptr_destination+1
	lda #<logo
	sta ptr_source
	lda #>logo
	sta ptr_source+1
 
	jmp _FileUnpack
.)
_FirstText
.(
	jsr _clr_toparea
	jsr _clr_bottomarea
	lda #<_MessageEncounter
	ldx #>_MessageEncounter
	jmp _DrawTextAsm
.)


_Dialogue1
.(
	jsr _clr_toparea
	jsr _clr_bottomarea
	lda #<_MessageDialogue1
	ldx #>_MessageDialogue1
	jmp _DrawTextAsm
.)

_Dialogue2
.(
	jsr _clr_bottomarea
	jsr _clr_toparea
	lda #<_MessageDialogue2
	ldx #>_MessageDialogue2
	jmp _DrawTextAsm
.)

_Dialogue3
.(
	jsr _clr_bottomarea
	jsr _clr_toparea
	lda #<_MessageDialogue3
	ldx #>_MessageDialogue3
	jmp _DrawTextAsm
.)
_Dialogue3b
.(
	jsr _clr_bottomarea
	jsr _clr_toparea
	lda #<_MessageDialogue3b
	ldx #>_MessageDialogue3b
	jmp _DrawTextAsm
.)

_Dialogue4
.(
	jsr _clr_bottomarea
	jsr _clr_toparea
	lda #<_MessageDialogue4
	ldx #>_MessageDialogue4
	jmp _DrawTextAsm
.)
_Dialogue5
.(
	jsr _clr_bottomarea
	jsr _clr_toparea
	lda #<_MessageDialogue5
	ldx #>_MessageDialogue5
	jmp _DrawTextAsm
.)
_Dialogue6
.(
	jsr _clr_bottomarea
	jsr _clr_toparea
	lda #<_MessageDialogue6
	ldx #>_MessageDialogue6
	jmp _DrawTextAsm
.)

_CreditsElite
.(
	jsr _clr_all
	lda #<_MessageElite
	ldx #>_MessageElite
	jmp _DrawTextAsm
.)

_Credits1
.(
	jsr _clr_all
	lda #$0
	ldx #$0
	jsr set_ink
	lda #<_MessageChema
	ldx #>_MessageChema
	jsr _DrawTextAsm
	lda #<_MessageTwilighte
	ldx #>_MessageTwilighte
	jsr _DrawTextAsm
	lda #$03
	ldx #$06
	jmp set_ink
.)

/*
_Credits2
.(
	jsr _clr_all
	lda #$0
	ldx #$0
	jsr set_ink
	lda #<_MessageTwilighte
	ldx #>_MessageTwilighte
	jsr _DrawTextAsm
	lda #$07
	ldx #$06
	jmp set_ink
.)
*/
_Credits4
.(
	jsr _clr_all
	lda #$0
	ldx #$0
	jsr set_ink
	lda #<_MessageChema2
	ldx #>_MessageChema2
	jsr _DrawTextAsm
	lda #<_MessageHelp
	ldx #>_MessageHelp
	jsr _DrawTextAsm
	lda #$02
	ldx #$06
	jmp set_ink
.)

_Credits3
.(
	jsr _clr_all
	lda #$0
	ldx #$0
	jsr set_ink
	lda #<_MessageDbug
	ldx #>_MessageDbug
	jsr _DrawTextAsm
	lda #$03
	ldx #$06
	jmp set_ink
.)

_Credits5
.(
	jsr _clr_all
	lda #$0
	ldx #$0
	jsr set_ink
	lda #<_MessageMusic
	ldx #>_MessageMusic
	jsr _DrawTextAsm
	lda #<_MessageMusic2
	ldx #>_MessageMusic2
	jsr _DrawTextAsm
	lda #$06
	ldx #$06
	jmp set_ink
.)

_CreditsEnd
.(
	jsr _clr_all
	lda #$0
	ldx #$0
	jsr set_ink

	lda #<_MessageExclusive
	ldx #>_MessageExclusive
	jsr _DrawTextAsm
	lda #<_MessageWebsite
	ldx #>_MessageWebsite
	jsr _DrawTextAsm
	lda #$06
	ldx #$06
	jmp set_ink
.)

_ShowStory
.(
	jsr _clr_all
	lda #$0
	ldx #$0
	jsr set_ink

	lda #<_MessageStory
	ldx #>_MessageStory
	jsr _DrawTextAsm
	lda #<_MessageStoryb
	ldx #>_MessageStoryb
	jsr _DrawTextAsm
	lda #$03
	ldx #$06
	jmp set_ink
.)

/*
_ShowStory2
.(
	jsr _clr_all
	lda #$0
	ldx #$0
	jsr set_ink
;	lda #<_MessageStory2
;	ldx #>_MessageStory2
;	jsr _DrawTextAsm
	lda #<_MessageStory2b
	ldx #>_MessageStory2b
	jsr _DrawTextAsm

	lda #$03
	ldx #$06
	jmp set_ink
.)

*/
_SequenceDefenceForceLogo
.(
	jsr _clr_all

	;lda #<_BufferUnpack
	lda #<$c000
	sta ptr_destination
	;lda #>_BufferUnpack
	lda #>$c000
	sta ptr_destination+1
	lda #<_LabelPictureDefenceForce
	sta ptr_source
	lda #>_LabelPictureDefenceForce
	sta ptr_source+1
 
	jsr _FileUnpack
	
	
	jsr _DisplayPaperSet
	jsr _DisplayMakeShiftedLogos
	jsr _DisplayDefenceForceFrame

	lda #100
	sta tmp5
loop	
	jsr _DisplayScrappIt
	dec tmp5
	bne loop

	jmp _clr_all
	;rts
.)



_clr_all
.(	
	lda #<$a000
	sta tmp
	lda #>$a000
	sta tmp+1
	lda common_clr_area+1
	sta patch_val+1
	lda #200
	sta common_clr_area+1
	jsr common_clr_area
patch_val
	lda #0
	sta common_clr_area+1
	rts
.)

_clr_scenearea
.(
	lda #<$a000+50*40
	sta tmp
	lda #>$a000+50*40
	sta tmp+1
	lda common_clr_area+1
	sta patch_val+1
	lda #100
	sta common_clr_area+1
	jsr common_clr_area
patch_val
	lda #0
	sta common_clr_area+1
	rts
.)
_clr_bottomarea
.(	
	lda #<$a000+152*40
	sta tmp
	lda #>$a000+152*40
	sta tmp+1
	jmp common_clr_area
.)


_clr_toparea
	lda #<$a000
	sta tmp
	lda #>$a000
	sta tmp+1
common_clr_area
.(
	lda #49
	sta tmp0
loop2
	ldy #39
	lda #$40
loop
	sta (tmp),y
	dey
	bpl loop

	lda tmp
	clc
	adc #40
	sta tmp
	bcc nocarry
	inc tmp+1
nocarry
	dec tmp0
	bne loop2

	rts
.)


_reboot_oric
.(
    lda $0314
    and #%01111101
    sta $0314
    
    ldx #0
    txs

    jmp $eb7e 
.)


; Special codes:
; -  0=end of text
; -  1=select base character (followed by character index)
; -  2=offset X (followed by signed pixel offset)
; -  3=offset Y (followed by signed pixel offset)
; -  4=copy column zero attributes to next column (followed by number of lines to copy)
; - 10=carriage return (followed by number of scanlines to skip)
;
#define DONE	0
#define FONT	1
#define MOVX	2
#define MOVY	3


_MessageEncounter
	.byt 6,6
	.byt FONT,0, "Gelesoma system. Galactic Sector 7.",10,15
	.byt FONT,0, "An unusual encounter takes place..."
	.byt DONE

_MessageDialogue1
	.byt 6,156
	.byt FONT,0, "Thargoid ship:",10,15
	.byt FONT,0, "We have studied your proposal",10,15
	.byt FONT,0, "and find it adequate."
	.byt DONE

_MessageDialogue2
	;.byt 6,156
	.byt 6,6
	.byt FONT,0, "Mamba ship:",10,15
	.byt FONT,0, "I am glad to hear we can come",10,15
	.byt FONT,0, "to an agreement."
	.byt DONE

_MessageDialogue3
	.byt 6,156
	;.byt FONT,0, "Thargoid:",10,15
	.byt FONT,0, "Just bring us that technical",10,15
	.byt FONT,0, "information, and you will have",10,15
	.byt FONT,0, "what you ask for: your credits",10,15
	.byt DONE
_MessageDialogue3b
	.byt 6,156
	;.byt FONT,0, "what you ask for: your credits",10,15
	.byt FONT,0, "and a Governor position once",10,15
	.byt FONT,0, "the eigth galaxies are assimilated."
	.byt DONE

_MessageDialogue4
	;.byt 6,156
	.byt 6,6+15
	;.byt FONT,0, "Mamba:",10,15
	.byt FONT,0, "I have an insider who is willing",10,15
	.byt FONT,0, "to cooperate."
	.byt DONE

_MessageDialogue5
	.byt 6,156
	;.byt FONT,0, "Thargoid:",10,15
	.byt FONT,0, "Good. Contact us by the usual",10,15
	.byt FONT,0, "channel.",10,15
	.byt DONE

_MessageDialogue6
	;.byt 6,156
	.byt 6,6+15+15
	;.byt FONT,0, "Mamba:",10,15
	.byt FONT,0, "Understood."
	.byt DONE

_MessageElite
	.byt 10,90-15
	.byt 1,0,"          special thanks to",10,15
	.byt 1,71,"   D. Braben and I. Bell",10,25
	.byt 2,4,1,0, "  for one of the best games ever",10,40
	.byt 1,0, "     Press ESC to skip this intro"
	.byt DONE

_MessageMusic
	.byt 12,60
	.byt 1,0,"original music theme",10,15
	.byt 1,71,"Vangelis"
	.byt DONE
_MessageMusic2
	.byt 110,100
	.byt 1,0,"adaptation",10,15
	.byt 1,71,"Jose Maria",10,21
	.byt 1,0,"'Chema'",10,11
	.byt 1,71,"Enguita"
	.byt DONE

_MessageChema
	.byt 6,25
	.byt 1,0,"designer/programmer",10,15
	.byt 1,71,"   Jose Maria",10,21
	.byt 1,0,"         'Chema'",10,11
	.byt 1,71,"        Enguita"
	.byt DONE
_MessageChema2
	.byt 10,10+6
	.byt 1,0,"3D engine adapted from lib3d",10,15
	.byt 1,71,"   Stephen L. Judd"
	.byt DONE

_MessageHelp
	.byt 110,80
	.byt 1,0,"additional code",10,15
	.byt 1,71,"Twilighte",10,26
	.byt 1,71,"Dbug",10,26
	.byt 1,71,"Thrust"
	.byt DONE
_MessageTwilighte
	.byt 150-16,100-10
	.byt 1,0,"additional graphics",10,15
	.byt 1,71,"Jonathan",10,21
	.byt 1,0,"'Twilighte'",10,11
	.byt 1,71,"Bristow"
	.byt DONE
_MessageDbug
	;.byt 126,20
	.byt 80,20
	.byt 1,0,"intro",10,15
	.byt 1,71," Mickael",10,22
	.byt 1,0,"  'Dbug'",10,13
	.byt 1,71,"  Pointier",10,22
	.byt 1,0,"and",10,15
	.byt 1,71," Jose Maria",10,22
	.byt 1,0,"  'Chema'",10,13
	.byt 1,71,"  Enguita"
	.byt DONE

_MessageExclusive
	.byt 20,82
	.byt 1,0,"An exclusive space adventure for",10,13
	.byt 1,0,"   your Oric Microdisc system.",10,15
	.byt 1,0,"       -september 2010-"
	.byt DONE
			
_MessageWebsite
	.byt 35,120+15
	.byt 1,0,"http",58,"/","/","1337.defence-force.org",0

_MessageStory
	.byt 6,12
	.byt 1,0,"It is year 1337 after the foundation",10,13
	.byt 1,0,"of the Galactic Cooperative",10,13
	.byt 1,0,"of Worlds, comprising more than",10,13
	.byt 1,0,"2000 systems spread throughout",10,13
	.byt 1,0,"eigth galaxies.",0
	
_MessageStoryb
	.byt 6,90	
	.byt 1,0,"The last thirty-five years have",10,13
	.byt 1,0,"been dominated by the menace of the",10,13
	.byt 1,0,"Thargoid, an insectoid alien race who is",10,13
	.byt 1,0,"trying to conquer the planets and",10,13
	.byt 1,0,"enslave their inhabitants.",0
/*
_MessageStory2
	.byt 6,12
	.byt 1,0,"Unstability in some local governments",10,13
	.byt 1,0,"has increased, and piracy is becoming",10,13
	.byt 1,0,"a common bussiness, making commerce",10,13
	.byt 1,0,"and transportation risky activities.",0
*/
_MessageStory2b
	.byt 6,100	
	.byt 1,0,"Do you have what it takes to make a",10,13
	.byt 1,0,"living in this universe, tough but",10,13
	.byt 1,0,"full of opportunities?",10,30
	.byt 1,0,"Come and show you can become one",10,13
	.byt 1,0,"of the Elite...",0

/*

_Message_StarringMartinLandau
	.byt 50,72
	.byt 1,0,"starring",10,15,1,71,"Martin",10,21,"Landau"
	.byt DONE
_Message_StarringBarbaraBain
	.byt 160,51
	.byt 1,0,"starring",10,13,1,71,"Barbara",10,20,"Bain"
	.byt DONE
	
_Message_StarringBarryMorse
	.byt 152,17
	.byt 1,0,"also starring",10,15,1,71,"Barry",10,21,"Morse"
	.byt DONE

_Message_SylviaAnderson
	.byt 72,117
	.byt 1,0,"producer",10,15,1,71,"Sylvia",10,21,"Anderson"
	.byt DONE
	
_Message_GerryAnderson
	.byt 126,27
	.byt 1,0,"executive producer",10,15,1,71," Gerry",10,21," Anderson"
	.byt DONE
	
_Message_Music
	.byt 12,80
	.byt 1,0,"original theme",10,15
	.byt 1,71,"Barry",10,21
	.byt "Gray"
	.byt DONE
	
_Message_Chema
	.byt 120,10
	.byt 1,0,"designer/programmer",10,15
	.byt 1,71,"   Jose Maria",10,21
	.byt 1,0,"         'Chema'",10,11
	.byt 1,71,"        Enguita"
	.byt DONE
	
_Message_Twilighte
	.byt 110,130
	.byt 1,0,"adaptation",10,15
	.byt 1,71,"Jonathan",10,21
	.byt 1,0,"'Twilighte'",10,11
	.byt 1,71,"Bristow"
	.byt DONE
	
_Message_Dbug
	.byt 126,20
	.byt 1,0,"intro",10,15
	.byt 1,71," Mickael",10,22
	.byt 1,0,"  'Dbug'",10,13
	.byt 1,71,"  Pointier"
	.byt DONE

_Message_ProducedBy
	.byt 90,40
	.byt 1,0,"produced by"
	.byt DONE
	
_Message_Title
	.byt 20,60
	.byt 1,71,"'OUT OF MEMORY'"
	.byt DONE

_Message_Exclusive
	.byt 20,82
	.byt 1,0,"An exclusive Space:1999 episode for",10,13
	.byt 1,0,"    your Oric Microdisc system.",10,15
	.byt DONE
			
_Message_Website
	.byt 30,120
	.byt 1,0,"     Download it today on:",10,13
	.byt 1,0,"http",58,"/","/","space1999.defence-force.org",0

_Message_Quote1
	.byt 6,0
	.byt 1,0,"'Cult 1970s sci-fi plus obscure 1980s 8-bit",10,13
	.byt 1,0,"computer",58," something beautifully obscure.'",10,13
	.byt 1,0,"                           Malevolent"
	.byt DONE

_Message_Quote2
	.byt 6,50
	.byt 1,0,"'For modern gaming, check out Space",10,13
	.byt 1,0,"1999, a very nifty isometric adventure.'",10,13
	.byt 1,0,"                           Retrogamer"
	.byt DONE

_Message_Quote3
	.byt 6,100
	.byt 1,0,"'If only games like this were out for the",10,13
	.byt 1,0,"machine in the 80s.  I might not have",10,13
	.byt 1,0,"been quite so gutted when I got one of ",10,13
	.byt 1,0,"these for Christmas.'        Caffeinekid"
	.byt DONE
		
_Message_Quote4
	.byt 6,170
	.byt 1,0,"'Ay, caramba!'",10,13
	.byt 1,0,"                           Bart Simpson"
	.byt DONE
		

_Message_Rating
	.byt 12,20
	.byt 1,0,"THE FOLLOWING",1,71,MOVY,256-6,"PREVIEW",MOVY,6,1,0,"HAS BEEN",10,14
	.byt 1,0,"APPROVED FOR",10,16
	.byt 1,71,"      ALL AUDIENCES",10,28
	.byt 1,0," BY THE MOVING PIXELS ASSOCIATION",10,30
	.byt 1,0,"THE FILM ADVERTISED HAS BEEN RATED",10,20
	.byt DONE
	
_Message_Rating_Bottom	
	.byt 12,123
	.byt 1,71,MOVX,2,"G",1,0,MOVX,40,MOVY,3,"GENERAL AUDIENCES",10,22-3
	.byt 1,0,MOVX,3,"Some Material May Be Slow Or Ugly",10,15
	.byt 1,0,MOVX,3,"Isometric 3D does not require glasses"
	.byt DONE
	
_Message_EmergencyRedAlert
	.byt 55,80
	.byt 1,71
	.byt "EMERGENCY",10,40
	.byt MOVX,45,"RED",10,25
	.byt MOVX,35,"ALERT",10,30
	.byt DONE
*/	
