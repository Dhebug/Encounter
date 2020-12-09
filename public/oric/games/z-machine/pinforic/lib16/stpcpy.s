; char *stpcpy(char *s1, char *s2)

_stpcpy
        jsr _strcpy
        tya
        clc
        adc op1
        tax
        lda op1+1
        adc #0
        rts
