

/*
CRC code from http://www.6502.org/source/integers/crc.htm
. CRC-32

Usage

Call MAKECRCTABLE to set up the CRCT0 through CRCT3 tables.
Initialize CRC, CRC+1, CRC+2, CRC+3 to $FF.
For each byte in the data, LDA it and call UPDCRC.
Exclusive-or each of CRC, CRC+1, CRC+2, CRC+3 with $FF.
The CRC is in CRC (low byte) through CRC+3.
Notes
UPDCRC clobbers A and X. It can be easily changed to clobber Y instead of X or, at a performance cost, to preserve registers.
UPDCRC takes 42 cycles per byte if inlined and the tables are page-aligned.

Why complement the result? Because the CRC-32 standard says so. I guess it made things easier for with hardware compatibility, and now we're stuck with it.
*/

    .zero

CRC
_CRC      .dsb 4          ; 4 bytes in ZP

    .text

_MAKECRCTABLE:
         LDX #0          ; X counts from 0 to 255
BYTELOOP LDA #0          ; A contains the high byte of the CRC-32
         STA CRC+2       ; The other three bytes are in memory
         STA CRC+1
         STX CRC
         LDY #8          ; Y counts bits in a byte
BITLOOP  LSR             ; The CRC-32 algorithm is similar to CRC-16
         ROR CRC+2       ; except that it is reversed (originally for
         ROR CRC+1       ; hardware reasons). This is why we shift
         ROR CRC         ; right instead of left here.
         BCC NOADD       ; Do nothing if no overflow
         EOR #$ED        ; else add CRC-32 polynomial $EDB88320
         PHA             ; Save high byte while we do others
         LDA CRC+2
         EOR #$B8        ; Most reference books give the CRC-32 poly
         STA CRC+2       ; as $04C11DB7. This is actually the same if
         LDA CRC+1       ; you write it in binary and read it right-
         EOR #$83        ; to-left instead of left-to-right. Doing it
         STA CRC+1       ; this way means we won't have to explicitly
         LDA CRC         ; reverse things afterwards.
         EOR #$20
         STA CRC
         PLA             ; Restore high byte
NOADD    DEY
         BNE BITLOOP     ; Do next bit
         STA CRCT3,X     ; Save CRC into table, high to low bytes
         LDA CRC+2
         STA CRCT2,X
         LDA CRC+1
         STA CRCT1,X
         LDA CRC
         STA CRCT0,X
         INX
         BNE BYTELOOP    ; Do next byte
         RTS

_UPDCRC:
         EOR CRC         ; Quick CRC computation with lookup tables
         TAX
         LDA CRC+1
         EOR CRCT0,X
         STA CRC
         LDA CRC+2
         EOR CRCT1,X
         STA CRC+1
         LDA CRC+3
         EOR CRCT2,X
         STA CRC+2
         LDA CRCT3,X
         STA CRC+3
         RTS

/*
Example: Computing the CRC-32 of 16384 bytes of data in $C000-$FFFF
*/

_ComputeROMCRC32
    //jmp _ComputeROMCRC32
.(
    /*
    sei
    lda #0
    sta $3fb

    lda #0
    sta $3fa
    */

         JSR _MAKECRCTABLE
         LDY #$FF
         STY CRC
         STY CRC+1
         STY CRC+2
         STY CRC+3
         INY
LOOP     LDA $c000,Y
         JSR _UPDCRC
         INY
         BNE LOOP
         INC LOOP+2  ; Have we reached back 0000 ?
         BNE LOOP

         LDY #3
COMPL    LDA CRC,Y
         EOR #$FF
         STA CRC,Y
         DEY
         BPL COMPL

done
    //jmp done
         RTS
.)


CRCT0    .dsb 256       ; Four 256-byte tables
CRCT1    .dsb 256       ; (should be page-aligned for speed)
CRCT2    .dsb 256
CRCT3    .dsb 256

