;SSC Common Code

ssc_AddSource
        clc
        adc source
        sta source
        lda source+1
        adc #00
        sta source+1
        rts

ssc_AddBGMask
        clc
        adc bgmask
        sta bgmask
        lda bgmask+1
        adc #00
        sta bgmask+1
        rts

ssc_SubScreen
.(
	sta vector1+1
	lda screen
	sec
vector1	sbc #00
.)
	sta screen
	lda screen+1
	sbc #00
	sta screen+1
	rts

ssc_AddScreen
        clc
        adc screen
        sta screen
        lda screen+1
        adc #00
        sta screen+1
        rts

ssc_nl_source
        lda source
        clc
        adc #40
        sta source
        lda source+1
        adc #00
        sta source+1
        rts

ssc_nl_screen
        lda screen
        clc
        adc #40
        sta screen
        lda screen+1
        adc #00
        sta screen+1
        rts
