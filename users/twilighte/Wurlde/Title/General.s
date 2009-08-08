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

;A == Maximum (eg. 0-39)
GetRNDRange
        sta rndTemp+1
        jsr getrand
        cmp rndTemp+1
.(
        bcc skip1
        and rndTemp+1
skip1   rts
.)
