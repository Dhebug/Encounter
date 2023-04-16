

    .text

_EndText

#echo Remaining space:
#print ($9800 - *)  

    .bss

* = $9800
_STD_Charset_HIRES

* = $9C00
_ALT_Charset_HIRES

* = $A000
_HIRES_Screen

* = $B400
_Standard_Charset_HIRES

* = $B800
_Alternate_Charset_HIRES

* = $BB80
_TEXT_Screen

* = $fe00
_DiskLoader