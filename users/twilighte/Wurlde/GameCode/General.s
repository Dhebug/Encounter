;General.s

getrand
         lda rndRandom+1
         sta rndTemp
         lda rndRandom
         asl
         rol rndTemp
         asl
         rol rndTemp

         clc
         adc rndRandom
         pha
         lda rndTemp
         adc rndRandom+1
         sta rndRandom+1
         pla
         adc #$11
         sta rndRandom
         lda rndRandom+1
         adc #$36
         sta rndRandom+1
         rts

;A == Maximum (eg. 0-255)
GetRNDRange
        sta rndTemp+1
        jsr getrand
.(
skip2   cmp rndTemp+1

        bcc skip1
        ;If the range was 63 and the random number was 243 then sbc (range) until in range
        sbc rndTemp+1
        jmp skip2
        ;If the range was 63(r) and the random number(n) was 243 then 
skip1   rts
.)


nl_screen
	lda screen
	clc
	adc #40
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts
add_screen
	clc
	adc screen
	sta screen
	lda screen+1
	adc #00
	sta screen+1
	rts
nl_source
	lda source
	clc
	adc #40
	sta source
	lda source+1
	adc #00
	sta source+1
	rts
add_source
	clc
	adc source
	sta source
	lda source+1
	adc #00
	sta source+1
	rts
nl_bgbuff
	lda bgbuff
	clc
	adc #40
	sta bgbuff
	lda bgbuff+1
	adc #00
	sta bgbuff+1
	rts
add_bgbuff
	clc
	adc bgbuff
	sta bgbuff
	lda bgbuff+1
	adc #00
	sta bgbuff+1
	rts

;Parsed
;source
;screen
;x Height
;y Width of source
CopySource2Screen
.(
      	sty vector1+1
loop2	ldy vector1+1
	dey
loop1	lda (source),y
	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
vector1	lda #00
	jsr add_source
	dex
	bne loop2
.)
	rts

EraseInlay
	lda #<HIRESInlayLocation
	sta screen
	lda #>HIRESInlayLocation
	sta screen+1
	ldx #120
.(
loop2	ldy #39
	lda #64
loop1	sta (screen),y
	dey
	bpl loop1
	jsr nl_screen
	dex
	bne loop2
.)
	rts
