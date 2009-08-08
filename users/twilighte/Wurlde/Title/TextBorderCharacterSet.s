;TextBorderCharacterSet.s

TextCharacterSet	;Only redefine 33-42(10)
 .dsb 8,0	;Space Character

 .byt %000100	;Vertical Left(33)
 .byt %001001
 .byt %001100
 .byt %001101
 .byt %001100
 .byt %000101
 .byt %001000
 .byt %001101

 .byt %001000	;Vertical Right(34)
 .byt %100100
 .byt %001100
 .byt %101100
 .byt %001100
 .byt %101000
 .byt %000100
 .byt %101100

 .byt %000000	;Left Horizontal(35)
 .byt %101010
 .byt %000000
 .byt %111011
 .byt %110111
 .byt %000000
 .byt %000000
 .byt %000000

 .byt %000000	;Right horizontal(36)
 .byt %010101
 .byt %000000
 .byt %110111
 .byt %111011
 .byt %000000
 .byt %000000
 .byt %000000

 .byt %000000	;Gravestone Approach Left(37)
 .byt %101010
 .byt %000000
 .byt %111010
 .byt %110110
 .byt %000000
 .byt %010110
 .byt %000000

 .byt %100001
 .byt %000000
 .byt %001100
 .byt %011110
 .byt %011110
 .byt %001100
 .byt %001100
 .byt %000000

 .byt %000000   ;Gravestone Approach Right(39)
 .byt %010101
 .byt %000000
 .byt %010111
 .byt %011011
 .byt %000000
 .byt %011010
 .byt %000000

 .byt %001000	;Left Corner(40)
 .byt %001101
 .byt %000000
 .byt %101101
 .byt %000101
 .byt %110000
 .byt %010100
 .byt %000000

 .byt %000100	;Right Corner(41)
 .byt %101100
 .byt %000000
 .byt %101101
 .byt %101000
 .byt %000011
 .byt %001010
 .byt %000000

 .byt %111011	;Text Cursor(42)
 .byt %110111
 .byt %101111
 .byt %011110
 .byt %111101
 .byt %111011
 .byt %110111
 .byt %000000

 .dsb 128,0
