;StonedBehaviourtables.s
;Synopsis
;The hero stands on the right or left of the screen and must avoid the mire by jumping on stones that rise and dissappear on the
;surface.
;Objects may also rise atop Stones enticing the player to pursue them even if it means reversing course.

;The hero may move to an adjacent stone in a number of ways
;1)Standing Jumping  (8 Steps/Bytes)
;2)Stepping          (1 Step/Byte)
;3)Maybe through running jump but frames and code not implemented yet

;Each Stone is 2x5 at full height and 18 different xpos's
;are available.
;****************************************
;--s s s s s s s s s s s s s s s s s s_--
;Each graphic uses a combination of display techniques to achieve the "Whitest" result over the varied background.
;When the stone reaches the surface (top most position) the floortable for the two positions is raised by one.
;If the hero lands in the mire (Whether by jumping, stepping, falling or waiting too long) he will gradually sink
;up to 2 ypos and his life will quickly drain from him. If he remains he will die but if he steps or runs or jumps
;his ypos will be restored but standing still will cause him to sink again. If he finds a stone to land on the
;floortable will ensure he returns to full height again though his life will still remain.

;Up to 4 stones may be simultaneously in motion.



;
ProcessStoneActivity
	ldx #03
.(
loop1	lda StoneActivity,x
	beq skip1
	lda StoneDelayFracCounter,x
	sec
	adc StoneDelayFracValue,x
	sta StoneDelayFracCounter,x
	bcc
	;Animate Stone
	jsr MoveStone
	bcc skip1
	;Update frame
	jsr UpdateFrame
	;Progress
skip1	dex
	bpl loop1
.)
	rts




