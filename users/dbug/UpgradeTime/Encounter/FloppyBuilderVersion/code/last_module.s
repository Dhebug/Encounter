

    .text

_EndText

#echo Remaining space:
#print ($9800 - *)  

    .bss

* = $9800             ; STD charset for HIRES mode: 1024 bytes
; Width (in pixels) of each of the 95 characters in the 12x14 font
_gFont12x14Width      .dsb 95

; Contains all the combinations of 6 pixels patterns shifted by 0 to 5 pixels to the right.
; Each entry requires two bytes, and each need to be merged to the target buffer to rebuild
; the complete shifted graphics
_gShiftBuffer         .dsb 64*2*6           ; 768 bytes
_free_to_use_1        .dsb 1024-768-95

* = $9C00             ; ALT charset for HIRES mode: 1024 bytes
_free_to_use_2        .dsb 1024

* = $A000             ; Top of the HIRES screen: 8000 bytes

* = $B400             ; STD charset for TEXT mode (the 256 first bytes are not displayable)
_Attribute_TEXT       .dsb 1        ; Contains the attribute to switch to TEXT mode
_free_to_use_3        .dsb 255

* = $B800             ; ALT charset for TEXT mode (the 256 first bytes are not displayable)
; Contains all the combination of X*40 to access specific scanlines
_gTableMulBy40Low     .dsb 128
_gTableMulBy40High    .dsb 128

* = $BB80             ; Top of the TEXT screen: 1120 bytes
_Attribute_HIRES      .dsb 1        ; Contains the attribute to switch to HIRES mode
_free_to_use_4        .dsb 479

* = $C000             ; Start of the ROM/Overlay ram

; Screeen is in $A000 = %10100000 00000000
; Buffer is in  $C000 = %11000000 00000000 -> Same address, +8192 bytes
_ImageBuffer          .dsb 40*128   ; 128 lines of HIRES
_ImageBufferEnd       .dsb 40*8     ; an extra 8 lines to make things more practical with the redefined characters
_SecondImageBuffer    .dsb 40*128   ; A second buffer that can store a full image
_free_to_use_5



* = $fe00
_DiskLoader

