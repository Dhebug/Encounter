;InventoryObjects.s
;Objects in the background all use a common shape and
;glow or shine once every 5 or 10 seconds to indicate
;there presence.

;This should eventually be called from irq
AnimateScreenObjects
	;Update Object frame(Global)
	lda Objects_AnimationFrame
	clc
	adc #01
	and #31
	sta Objects_AnimationFrame
	;Clear out StackedItemTable
	ldx #31
	lda #255
.(
loop1	sta StackedObjectCount,x
	dex
	bpl loop1
.)
	;scan all objects in screen list
	ldx UltimateScreenObject
.(
	bmi skip1
loop1	;Extract XPOS
	lda ScreenObjects_A,x
	and #31

	clc
	adc #4
	sta temp02
	tay

	; Use to increment Stack Count
	lda StackedObjectCount-4,y
	adc #1
	sta StackedObjectCount-4,y

	; Fetch highest point in floortable and floortable+1
	lda (ContourFloor),y
	sta temp01
	iny
	cmp (ContourFloor),y
	bcc skip2
	lda temp01
skip2	; Subtract stack height from YPOS
	sec
	sbc StackedObjectCount-5,y
	; This is now Objects YPOS on screen
	tay
	lda SYLocl,y
	clc
	adc temp02
	sta screen
	lda SYLoch,y
	adc #00
	sta screen+1
	ldy Objects_AnimationFrame
	lda ObjectFrame,y
	ldy #01
;*check if screen byte is attribute, plot on row above.
	sta (screen),y

	dex
	bpl loop1
skip1	rts
.)

StackedObjectCount
 .dsb 40,0
ObjectFrame
 .byt $DF,$CF,$E7,$F3,$F9,$FC,$FE,$FF
 .dsb 24,$FF

;Add New Item to inventory(pockets)
;A == New Item ID
;Routine will also handle messaging
AddItem	sta temp01

	;Look at how many items we already have in pockets
	jsr CountHeroPocketsUsed
	cmp #10
.(
	bcs skip1
	lda temp01

	;Assign item to hero
	jsr LocateObjectIndex4Item
	lda Objects_C,x
	and #%11110000
	ora #LS_HELDBYHERO
	sta Objects_C,x

	sec
	jsr DisplayPockets
	;Item put in pocket
skip1	rts
.)

CountHeroPocketsUsed
	ldy #00
	ldx #127
.(
loop1	lda Objects_C,x
	bmi skip1
	and #15
	cmp #LS_HELDBYHERO
	bne skip1
	iny
skip1	dex
	bpl loop1
.)
	tya
	rts

CountCharacterPocketsUsed
	sta temp01
	ldy #00
	ldx #127
.(
loop1	lda Objects_C,x
	bmi skip1
	and #15
	cmp #LS_HELDBYCREATURE
	bne skip1
	lda Objects_A,x
	and #31
	cmp temp01
	bne skip1
	iny
skip1	dex
	bpl loop1
.)
	tya
	rts


LocateObjectIndex4Item
.(
	sta vector1+1
	;Process in reverse to speed up search
	ldx #00
loop1	lda Objects_B,x
	lsr
	lsr
	lsr
vector1	cmp #00
	beq skip1
	inx
	bpl loop1
skip1	rts
.)


;Attempt to Pick up item from ground
;
PickupItem     ;hcPickupRight
	;locate item
	ldx #127
.(
loop1	; Is object on current map?
	lda Objects_C,x
	and #15
	cmp MapID
	bne skip1

	; Is object on current screen?
	lda Objects_B,x
	and #7
	cmp ScreenID
	bne skip1

	;If Hero faces right, set HeroXOffsetFlag to 0
	;If hero faces left, set HeroXOffsetFlag to 1
	lda #00
	sta HeroXOffsetFlag
	ldy HeroAction
	lda HeroAnimationProperty,y
	and #hap_FRight
	bne skip2
	inc HeroXOffsetFlag
skip2

	; Is object within X bounds of hero?
	lda Objects_A,x
	and #31
	;The relative HeroX to objects depends on the dir hero faces
	clc
	adc #4
	sta iorb_xpos	;remember it for when we are restoring the background
	sec
	sbc HeroXOffsetFlag
	cmp HeroX
	bne skip1

	;Assign item to hero
	lda #LS_HELDBYHERO
	sta Objects_C,x

	;Restore Background behind screen object by grabbing it from BGB.
	jsr ioRestoreBackgroundByte

	sec
	jsr DisplayPockets

	;Rebuild Animated screen objects list
	jmp RescanScreenItems

skip1	dex
	bpl loop1
.)
	rts

iorb_temp01	.byt 0
iorb_temp02	.byt 0
iorb_xpos		.byt 0
;Parsed..
;iorb_xpos Xpos of item just picked up (Ypos sought from FloorTable)
;Corrupts..
;A Only!
ioRestoreBackgroundByte
	;Remember x and y
	stx iorb_temp01
	sty iorb_temp02
.(
	lda ContourFloor
	sta vector1+1
	lda ContourFloor+1
	sta vector1+2
	;fetch ypos for xpos of object
	ldx iorb_xpos
vector1	lda $dead,x
.)
	;extract actual ypos
	and #63
	;now calculate loc in bgb
	tay
	txa
	clc
	adc game_bgbylocl,y	;BGBYlocl,y
	sta source
	lda game_bgbyloch,y	;BGBYloch,y
	adc #00
	sta source+1
	;Calculate loc in screen
	txa
	adc SYLocl,y
	sta screen
	lda SYLoch,y
	adc #00
	sta screen+1
	;And copy bgb to screen
	ldy #00
	lda (source),y
	iny
	sta (screen),y
	;Restore registers
	ldx iorb_temp01
	ldy iorb_temp02
	rts


HeroXOffsetFlag
 .byt 0

DropItem       ;hcDropLeft
	;Drop selected item
	sec
	jsr LocateObjectForSelectedItem
	cpx #128
.(
	bcs skip1

	;Switch object to hero scene location
	lda HeroX
	cmp #4
	bcc skip2
	sbc #4
skip2	sta Objects_A,x
	lda MapID
	sta Objects_C,x
	lda Objects_B,x
	and #%11111000
	ora ScreenID
	sta Objects_B,x

	;ReDisplay pockets
	sec
	jsr DisplayPockets

	jmp RescanScreenItems
skip1	rts
.)

;Locates the object index(x) for the currently selected item(0-9) in either form(Carry clear) or info(Set)
;If object cannot be located X is +128
LocateObjectForSelectedItem
	ldy #00
	ldx #00
.(
	bcc loop2

	;Hero Search
loop1	lda Objects_C,x
	bmi skip1
	and #15
	cmp #LS_HELDBYHERO
	bne skip1
	cpy HeroSelectedPocket
	beq skip2
	iny
skip1	inx
	bpl loop1
skip2	rts

loop2	lda Objects_C,x
	bmi skip3
	and #15
	cmp #LS_HELDBYCREATURE
	bne skip3
	lda Objects_A,x
	and #31
	cmp CurrentCharacter
	bne skip3
	cpy FormSelectedPocket
	beq skip4
	iny
skip3	inx
	bpl loop2
skip4	rts
.)




;Scan items in Object list and build new list of items that
;reside in this mapid and screenid.
;This is a relatively slow process, so perform to limit item
;animation process time.
RescanScreenItems
	ldy #00
	ldx #127
.(
loop1	;Check if Object is valid
	lda Objects_B,x
	beq skip1
	;Check Objects screen id to this screen id
	and #7
	cmp ScreenID
	bne skip1
	;Check objects map id to this map id
	lda Objects_C,x
	and #15
	cmp MapID
	bne skip1
	;Add this item to list using same format
	lda Objects_A,x
	sta ScreenObjects_A,y
	lda Objects_B,x
	sta ScreenObjects_B,y
	lda Objects_C,x
	sta ScreenObjects_C,y
	;Increment New table index
	iny
	;Ensure items do not exceed 31 (hoarding not permitted!!)
	cpy #32
	bcs skip2
skip1	;Proceed to next entry
	dex
	bpl loop1
	;Recede last New Table index(>31 means no ojects on this screen)
skip2	dey
.)
	sty UltimateScreenObject
	rts

UltimateScreenObject
 .byt 255
ScreenObjects_A
 .dsb 32,0
ScreenObjects_B
 .dsb 32,0
ScreenObjects_C
 .dsb 32,0

XIndexInObjectXPOS
 .dsb 5,0
 .byt 1*8
 .byt 2*8
 .byt 3*8
 .byt 4*8
 .byt 5*8
 .byt 6*8
 .byt 7*8
 .byt 8*8
 .byt 9*8
 .byt 10*8
 .byt 11*8
 .byt 12*8
 .byt 13*8
 .byt 14*8
 .byt 15*8
 .byt 16*8
 .byt 17*8
 .byt 18*8
 .byt 19*8
 .byt 20*8
 .byt 21*8,22*8,23*8,24*8,25*8,26*8,27*8,28*8,29*8,30*8
 .dsb 6,31*8

;UseItem
;Called when hero standing left or right and presses Item+Action
;Will action the hero to use the currently selected item
UseItem
	sec
	jsr LocateObjectForSelectedItem
	cpx #128
.(
	bcs skip1	;No selected item
	
	; Fetch ObjectID
	lda Objects_B,x
	lsr
	lsr
	lsr

	; Branch to process action associated with Object(Item)
	tay
	lda AssociatedItemActionVectorLo,y
	sta vector1+1
	lda AssociatedItemActionVectorHi,y
	sta vector1+2
	
vector1	jmp $dead	
skip1	rts
.)

	;Fetch direction hero is facing
	ldy HeroAction
	lda HeroAnimationProperty,y
	and #hap_FRight
AssociatedItemActionVectorLo
 .byt <aiaConsume		;00 "Fruit]"         Eat
 .byt <aiaCannot		;01 "Netting]"       -
 .byt <aiaConsume		;02 "Potion]"        Drink
 .byt <aiaConsume		;03 "Elixir]"	 Drink
 .byt <aiaConsume		;04 "Vial]"          Quaff (Handled differently because affects Mana and not health!)
 .byt <aiaConsume		;05 "Bok Fish]"      Consume
 .byt <aiaCannot		;06 "Wood]"          -
 .byt <aiaCannot		;07 "Emerald]"	-
 .byt <aiaCannot		;08 "Butterfly]"     -
 .byt <aiaCannot		;09 "Scroll]"        Use
 .byt <aiaCannot		;10 "AquaStone]"     Use
 .byt <aiaCannot		;11 "Mire Note]"	 Read
 .byt <aiaCannot		;12 "IvoryWand]"     -
 .byt <aiaCannot		;13 "EbonyWand]"     -
 .byt <aiaThrowKnife	;14 "Knife]"         Use Weapon
 .byt <aiaConsume		;15 "Fish Stew]"     Eat
 .byt <aiaCannot		;16 "Sword]"         Use Weapon	
 .byt <aiaCannot		;17 "Tablet]"	-
 .byt <aiaCannot		;18 "Bird Cage]"     Use
 .byt <aiaCannot		;19 "Parchment]"     -
 .byt <aiaCannot		;20 "Old Briar]"     Smoke?
 .byt <aiaCannot		;21 "GreasePot]"     -
 .byt <aiaConsume		;22 "Grog]"          Drink
 .byt <aiaConsume		;23 "Glant]"         Eat
 .byt <aiaCannot		;24 "Lodging]"       -
 .byt <aiaConsume		;25 "Blak Loaf]"     Eat
 .byt <aiaConsume		;26 "Lem Bread]"     Eat
 .byt <aiaConsume		;27 "Funghi]"        Eat
 .byt <aiaUseBow		;28 "Bow]"           Use Weapon
 .byt <aiaUseBow		;29 "Arrows]"        Use Weapon
 .byt <aiaCannot		;30 "GreatHorn]"     Blow
 .byt <aiaCannot		;31 "SpellBook]"     Read

AssociatedItemActionVectorHi
 .byt >aiaConsume		;00 "Fruit]"    
 .byt >aiaCannot	          ;01 "Netting]"  
 .byt >aiaConsume	          ;02 "Potion]"   
 .byt >aiaConsume	          ;03 "Elixir]"   
 .byt >aiaConsume	          ;04 "Vial]"     
 .byt >aiaConsume	          ;05 "Bok Fish]" 
 .byt >aiaCannot	          ;06 "Wood]"     
 .byt >aiaCannot	          ;07 "Emerald]"  
 .byt >aiaCannot	          ;08 "Butterfly]"
 .byt >aiaCannot	          ;09 "Scroll]"   
 .byt >aiaCannot	          ;10 "AquaStone]"
 .byt >aiaCannot	          ;11 "Mire Note]"
 .byt >aiaCannot	          ;12 "IvoryWand]"
 .byt >aiaCannot	          ;13 "EbonyWand]"
 .byt >aiaThrowKnife          ;14 "Knife]"    
 .byt >aiaConsume	          ;15 "Fish Stew]"
 .byt >aiaCannot	          ;16 "Sword]"    
 .byt >aiaCannot	          ;17 "Tablet]"   
 .byt >aiaCannot	          ;18 "Bird Cage]"
 .byt >aiaCannot	          ;19 "Parchment]"
 .byt >aiaCannot	          ;20 "Old Briar]"
 .byt >aiaCannot	          ;21 "GreasePot]"
 .byt >aiaConsume	          ;22 "Grog]"     
 .byt >aiaConsume	          ;23 "Glant]"    
 .byt >aiaCannot	          ;24 "Lodging]"  
 .byt >aiaConsume	          ;25 "Blak Loaf]"
 .byt >aiaConsume	          ;26 "Lem Bread]"
 .byt >aiaConsume	          ;27 "Funghi]"   
 .byt >aiaUseBow	          ;28 "Bow]"      
 .byt >aiaUseBow	          ;29 "Arrows]"   
 .byt >aiaCannot	          ;30 "GreatHorn]"
 .byt >aiaCannot	          ;31 "SpellBook]"

;Consume the item in Y whose object index is in X
; ***********************************
;"Lucien devours the ********* and as%"
;"a consequence feels a little better]"
aiaConsume
	;Insert item code into reports (might aswell write to all three types here
	sty EmbeddedText245_ItemCode
	sty EmbeddedText243_ItemCode
	;Locate foodstuffs health value
	tya
	ldy #10
.(
loop1	cmp FoodStuffLookup,y
	beq skip1
	dey
	bpl loop1
	;If we cannot find food stuff, default to 0
	ldy #00
skip1	lda FoodStuffProperty,y
.)
.(
	bmi AddMana
AddHealth	and #15
	;Add to hero's health
	clc
	adc HeroHealth
	cmp #16
	bcc skip1
	lda #15
skip1	sta HeroHealth
	jmp skip2
AddMana	and #15
	;Add to Hero's Mana
	clc
	adc HeroMana	
	cmp #16
	bcc skip3
	lda #15
skip3	sta HeroMana
skip2	;Destroy object
.)
	lda #128
	sta Objects_C,x
	
	;Calc Message Number
	lda FoodStuffMessageNumber,y
	tay
	
	;Report action to bottom window - "Lucien devours the * and feels a little better"
	lda #8+128
	ldx #0
	jsr DisplayBlockField
	
	;Update Hero's Health Bar
	jsr UpdateHealthBar
	
	;Update Pockets and Inventory item description
	sec
	jmp DisplayPockets

FoodStuffLookup
 .byt 00	;"Fruit]"
 .byt 05	;"Bok Fish]"
 .byt 15	;"Fish Stew]"
 .byt 23	;"Glant]"
 .byt 25	;"Blak Loaf]"
 .byt 26	;"Lem Bread]"
 .byt 27	;"Funghi]"
 
 .byt 02	;"Potion]"        Drink
 .byt 03	;"Elixir]"	Drink
 .byt 04	;"Vial]"          Quaff (Handled differently because affects Mana and not health!)
 .byt 22	;"Grog]"          Drink

;FoodStuffProperty
;B0-3 Health Benefit
;B4-5 -
;B6   Solid(0) or Liquid(1)
;B7   Health(0) or Mana(1)
FoodStuffProperty
 .byt 2		;"Fruit]"
 .byt 5		;"Bok Fish]"
 .byt 5		;"Fish Stew]"
 .byt 5		;"Glant]"
 .byt 2		;"Blak Loaf]"
 .byt 2		;"Lem Bread]"
 .byt 2		;"Funghi]"

 .byt 10		;"Potion]"
 .byt 15		;"Elixir]"
 .byt 5+128	;"Vial]"
 .byt 1		;"Grog]"
FoodStuffMessageNumber
 .byt 149		;"Fruit]"
 .byt 149		;"Bok Fish]"
 .byt 149		;"Fish Stew]"
 .byt 149		;"Glant]"
 .byt 149		;"Blak Loaf]"
 .byt 149		;"Lem Bread]"
 .byt 149		;"Funghi]"

 .byt 147		;"Potion]"
 .byt 147		;"Elixir]"
 .byt 147		;"Vial]"
 .byt 147		;"Grog]"


;Cannot Action the item here
aiaCannot
	;Report action to bottom window
	lda #8+128
	ldx #0
	ldy #148
	jmp DisplayBlockField

;Throw the knife whose object index is in X
aiaThrowKnife
	rts
	
;Fire Arrow with bow
aiaUseBow
	;Requires both Arrows and Bow to work
	rts