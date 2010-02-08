
#define X_SIZE      240
#define Y_SIZE      200
#define ROW_SIZE    X_SIZE/6

    .dsb 256-(*&255)

_HiresAddrLow           .dsb Y_SIZE

    .dsb 256-(*&255)

_HiresAddrHigh          .dsb Y_SIZE

    .dsb 256-(*&255)

    .byt 0
_TableDiv6              .dsb X_SIZE

    .dsb 256-(*&255)

    .byt 0
_TableMod6              .dsb X_SIZE

    .dsb 256-(*&255)

    .byt 0
_TableDiv6Rev           .dsb X_SIZE

    .dsb 256-(*&255)

    .byt 0
_TableBit6Reverse
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80

    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80

    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80

    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80
    .byt 32,16,8,4,2,1|$80

    .dsb 256-(*&255)

    .byt 0
_TableBit6
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80

    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80

    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80

    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80
    .byt 1,2,4,8,16,32|$80


_GenerateTables
.(

    ; Generate screen offset data
.(
    lda #<$a000
    sta tmp0+0
    lda #>$a000
    sta tmp0+1

    ldx #0
loop
    ; generate two bytes screen adress
    clc
    lda tmp0+0
    sta _HiresAddrLow,x
    adc #ROW_SIZE
    sta tmp0+0
    lda tmp0+1
    sta _HiresAddrHigh,x
    adc #0
    sta tmp0+1

    inx
    cpx #Y_SIZE
    bne loop
.)


    ; Generate multiple of 6 data table
.(
    lda #0      ; cur div
    tay         ; cur mod
    tax
loop
    sta _TableDiv6,x
    pha
    tya
    sta _TableMod6,x
    pla

    iny
    cpy #6
    bne skip_mod
    ldy #0
    adc #0      ; carry = 1!
skip_mod

    inx
    cpx #X_SIZE
    bne loop
.)
.(
    lda #0      ; cur div
    tay         ; cur mod
    ldx #X_SIZE
loop
    dex
    sta _TableDiv6Rev,x

    iny
    cpy #6
    bne skip_mod
    ldy #0
    adc #0      ; carry = 1!
skip_mod

    cpx #0
    bne loop
.)
.)
    rts







