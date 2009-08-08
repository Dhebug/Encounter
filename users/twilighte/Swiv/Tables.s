;Tables.s

;Graphic Memory provides a Background Buffer, Screen Buffer, Background Blocks, Sprites and Tables

;The background buffer is not scrolled but instead 2 synchronised pointers(StartRow and EndRow) cycle
;upwards within(Copying the data to the ScreenBuffer) with the new row graphics being inserted (2 rows
;at a time) into the two rows above StartRow.

;Enemy, Hero and flak sprites are then placed on the ScreenBuffer masked against the BackgroundBuffer.
;However All sprites observe inversed data within the Background and inverse sprite bytes that overlay
;them.

;The ScreenBuffer is then copied to HIRES.

;The Background and Screen Buffers are 28x96 Bytes
;The Map is 7x128 Bytes
;The Graphic Blocks are 24(4)x24 Pixels

;Craters and the general destruction of the background occurs on the existing background buffer plotting
;the crater or other graphic directly but still based on StartRow and cyclic behaviour of this buffer.
BGBuffer
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
 .dsb 20,$FF
 .dsb 20,$40
; .dsb 20*138,64
 
BGBufferRowAddressLo
 .byt <BGBuffer
 .byt <BGBuffer+20*1
 .byt <BGBuffer+20*2
 .byt <BGBuffer+20*3
 .byt <BGBuffer+20*4
 .byt <BGBuffer+20*5
 .byt <BGBuffer+20*6
 .byt <BGBuffer+20*7
 .byt <BGBuffer+20*8
 .byt <BGBuffer+20*9
 .byt <BGBuffer+20*10
 .byt <BGBuffer+20*11
 .byt <BGBuffer+20*12
 .byt <BGBuffer+20*13
 .byt <BGBuffer+20*14
 .byt <BGBuffer+20*15
 .byt <BGBuffer+20*16
 .byt <BGBuffer+20*17
 .byt <BGBuffer+20*18
 .byt <BGBuffer+20*19
 .byt <BGBuffer+20*20
 .byt <BGBuffer+20*21
 .byt <BGBuffer+20*22
 .byt <BGBuffer+20*23
 .byt <BGBuffer+20*24
 .byt <BGBuffer+20*25
 .byt <BGBuffer+20*26
 .byt <BGBuffer+20*27
 .byt <BGBuffer+20*28
 .byt <BGBuffer+20*29
 .byt <BGBuffer+20*30
 .byt <BGBuffer+20*31
 .byt <BGBuffer+20*32
 .byt <BGBuffer+20*33
 .byt <BGBuffer+20*34
 .byt <BGBuffer+20*35
 .byt <BGBuffer+20*36
 .byt <BGBuffer+20*37
 .byt <BGBuffer+20*38
 .byt <BGBuffer+20*39
 .byt <BGBuffer+20*40
 .byt <BGBuffer+20*41
 .byt <BGBuffer+20*42
 .byt <BGBuffer+20*43
 .byt <BGBuffer+20*44
 .byt <BGBuffer+20*45
 .byt <BGBuffer+20*46
 .byt <BGBuffer+20*47
 .byt <BGBuffer+20*48
 .byt <BGBuffer+20*49
 .byt <BGBuffer+20*50
 .byt <BGBuffer+20*51
 .byt <BGBuffer+20*52
 .byt <BGBuffer+20*53
 .byt <BGBuffer+20*54
 .byt <BGBuffer+20*55
 .byt <BGBuffer+20*56
 .byt <BGBuffer+20*57
 .byt <BGBuffer+20*58
 .byt <BGBuffer+20*59
 .byt <BGBuffer+20*60
 .byt <BGBuffer+20*61
 .byt <BGBuffer+20*62
 .byt <BGBuffer+20*63
 .byt <BGBuffer+20*64
 .byt <BGBuffer+20*65
 .byt <BGBuffer+20*66
 .byt <BGBuffer+20*67
 .byt <BGBuffer+20*68
 .byt <BGBuffer+20*69
 .byt <BGBuffer+20*70
 .byt <BGBuffer+20*71
 .byt <BGBuffer+20*72
 .byt <BGBuffer+20*73
 .byt <BGBuffer+20*74
 .byt <BGBuffer+20*75
 .byt <BGBuffer+20*76
 .byt <BGBuffer+20*77
 .byt <BGBuffer+20*78
 .byt <BGBuffer+20*79
 .byt <BGBuffer+20*80
 .byt <BGBuffer+20*81
 .byt <BGBuffer+20*82
 .byt <BGBuffer+20*83
 .byt <BGBuffer+20*84
 .byt <BGBuffer+20*85
 .byt <BGBuffer+20*86
 .byt <BGBuffer+20*87
 .byt <BGBuffer+20*88
 .byt <BGBuffer+20*89
 .byt <BGBuffer+20*90
 .byt <BGBuffer+20*91
 .byt <BGBuffer+20*92
 .byt <BGBuffer+20*93
 .byt <BGBuffer+20*94
 .byt <BGBuffer+20*95
 .byt <BGBuffer+20*96
 .byt <BGBuffer+20*97
 .byt <BGBuffer+20*98
 .byt <BGBuffer+20*99
 .byt <BGBuffer+20*100
 .byt <BGBuffer+20*101
 .byt <BGBuffer+20*102
 .byt <BGBuffer+20*103
 .byt <BGBuffer+20*104
 .byt <BGBuffer+20*105
 .byt <BGBuffer+20*106
 .byt <BGBuffer+20*107
 .byt <BGBuffer+20*108
 .byt <BGBuffer+20*109
 .byt <BGBuffer+20*110
 .byt <BGBuffer+20*111
 .byt <BGBuffer+20*112
 .byt <BGBuffer+20*113
 .byt <BGBuffer+20*114
 .byt <BGBuffer+20*115
 .byt <BGBuffer+20*116
 .byt <BGBuffer+20*117
 .byt <BGBuffer+20*118
 .byt <BGBuffer+20*119
 .byt <BGBuffer+20*120
 .byt <BGBuffer+20*121
 .byt <BGBuffer+20*122
 .byt <BGBuffer+20*123
 .byt <BGBuffer+20*124
 .byt <BGBuffer+20*125
 .byt <BGBuffer+20*126
 .byt <BGBuffer+20*127
 .byt <BGBuffer+20*128
 .byt <BGBuffer+20*129
 .byt <BGBuffer+20*130
 .byt <BGBuffer+20*131
 .byt <BGBuffer+20*132
 .byt <BGBuffer+20*133
 .byt <BGBuffer+20*134
 .byt <BGBuffer+20*135
 .byt <BGBuffer+20*136
 .byt <BGBuffer+20*137

BGBufferRowAddressHi
 .byt >BGBuffer
 .byt >BGBuffer+20*1
 .byt >BGBuffer+20*2
 .byt >BGBuffer+20*3
 .byt >BGBuffer+20*4
 .byt >BGBuffer+20*5
 .byt >BGBuffer+20*6
 .byt >BGBuffer+20*7
 .byt >BGBuffer+20*8
 .byt >BGBuffer+20*9
 .byt >BGBuffer+20*10
 .byt >BGBuffer+20*11
 .byt >BGBuffer+20*12
 .byt >BGBuffer+20*13
 .byt >BGBuffer+20*14
 .byt >BGBuffer+20*15
 .byt >BGBuffer+20*16
 .byt >BGBuffer+20*17
 .byt >BGBuffer+20*18
 .byt >BGBuffer+20*19
 .byt >BGBuffer+20*20
 .byt >BGBuffer+20*21
 .byt >BGBuffer+20*22
 .byt >BGBuffer+20*23
 .byt >BGBuffer+20*24
 .byt >BGBuffer+20*25
 .byt >BGBuffer+20*26
 .byt >BGBuffer+20*27
 .byt >BGBuffer+20*28
 .byt >BGBuffer+20*29
 .byt >BGBuffer+20*30
 .byt >BGBuffer+20*31
 .byt >BGBuffer+20*32
 .byt >BGBuffer+20*33
 .byt >BGBuffer+20*34
 .byt >BGBuffer+20*35
 .byt >BGBuffer+20*36
 .byt >BGBuffer+20*37
 .byt >BGBuffer+20*38
 .byt >BGBuffer+20*39
 .byt >BGBuffer+20*40
 .byt >BGBuffer+20*41
 .byt >BGBuffer+20*42
 .byt >BGBuffer+20*43
 .byt >BGBuffer+20*44
 .byt >BGBuffer+20*45
 .byt >BGBuffer+20*46
 .byt >BGBuffer+20*47
 .byt >BGBuffer+20*48
 .byt >BGBuffer+20*49
 .byt >BGBuffer+20*50
 .byt >BGBuffer+20*51
 .byt >BGBuffer+20*52
 .byt >BGBuffer+20*53
 .byt >BGBuffer+20*54
 .byt >BGBuffer+20*55
 .byt >BGBuffer+20*56
 .byt >BGBuffer+20*57
 .byt >BGBuffer+20*58
 .byt >BGBuffer+20*59
 .byt >BGBuffer+20*60
 .byt >BGBuffer+20*61
 .byt >BGBuffer+20*62
 .byt >BGBuffer+20*63
 .byt >BGBuffer+20*64
 .byt >BGBuffer+20*65
 .byt >BGBuffer+20*66
 .byt >BGBuffer+20*67
 .byt >BGBuffer+20*68
 .byt >BGBuffer+20*69
 .byt >BGBuffer+20*70
 .byt >BGBuffer+20*71
 .byt >BGBuffer+20*72
 .byt >BGBuffer+20*73
 .byt >BGBuffer+20*74
 .byt >BGBuffer+20*75
 .byt >BGBuffer+20*76
 .byt >BGBuffer+20*77
 .byt >BGBuffer+20*78
 .byt >BGBuffer+20*79
 .byt >BGBuffer+20*80
 .byt >BGBuffer+20*81
 .byt >BGBuffer+20*82
 .byt >BGBuffer+20*83
 .byt >BGBuffer+20*84
 .byt >BGBuffer+20*85
 .byt >BGBuffer+20*86
 .byt >BGBuffer+20*87
 .byt >BGBuffer+20*88
 .byt >BGBuffer+20*89
 .byt >BGBuffer+20*90
 .byt >BGBuffer+20*91
 .byt >BGBuffer+20*92
 .byt >BGBuffer+20*93
 .byt >BGBuffer+20*94
 .byt >BGBuffer+20*95
 .byt >BGBuffer+20*96
 .byt >BGBuffer+20*97
 .byt >BGBuffer+20*98
 .byt >BGBuffer+20*99
 .byt >BGBuffer+20*100
 .byt >BGBuffer+20*101
 .byt >BGBuffer+20*102
 .byt >BGBuffer+20*103
 .byt >BGBuffer+20*104
 .byt >BGBuffer+20*105
 .byt >BGBuffer+20*106
 .byt >BGBuffer+20*107
 .byt >BGBuffer+20*108
 .byt >BGBuffer+20*109
 .byt >BGBuffer+20*110
 .byt >BGBuffer+20*111
 .byt >BGBuffer+20*112
 .byt >BGBuffer+20*113
 .byt >BGBuffer+20*114
 .byt >BGBuffer+20*115
 .byt >BGBuffer+20*116
 .byt >BGBuffer+20*117
 .byt >BGBuffer+20*118
 .byt >BGBuffer+20*119
 .byt >BGBuffer+20*120
 .byt >BGBuffer+20*121
 .byt >BGBuffer+20*122
 .byt >BGBuffer+20*123
 .byt >BGBuffer+20*124
 .byt >BGBuffer+20*125
 .byt >BGBuffer+20*126
 .byt >BGBuffer+20*127
 .byt >BGBuffer+20*128
 .byt >BGBuffer+20*129
 .byt >BGBuffer+20*130
 .byt >BGBuffer+20*131
 .byt >BGBuffer+20*132
 .byt >BGBuffer+20*133
 .byt >BGBuffer+20*134
 .byt >BGBuffer+20*135
 .byt >BGBuffer+20*136
 .byt >BGBuffer+20*137


;--
; 12 Pixels above viewable screen area
;-- 
; 134 Pixels viewable screen area
;--
; 12 Pixels below viewable screen area
;--

ScreenBuffer
 .dsb 24*158,64
 
;Waste some extra bytes at end incase of overflow
 .dsb 24*6,64

ScreenBufferRowAddressLo
 .byt <ScreenBuffer
 .byt <ScreenBuffer+24*1
 .byt <ScreenBuffer+24*2
 .byt <ScreenBuffer+24*3
 .byt <ScreenBuffer+24*4
 .byt <ScreenBuffer+24*5
 .byt <ScreenBuffer+24*6
 .byt <ScreenBuffer+24*7
 .byt <ScreenBuffer+24*8
 .byt <ScreenBuffer+24*9
 .byt <ScreenBuffer+24*10
 .byt <ScreenBuffer+24*11
 .byt <ScreenBuffer+24*12
 .byt <ScreenBuffer+24*13
 .byt <ScreenBuffer+24*14
 .byt <ScreenBuffer+24*15
 .byt <ScreenBuffer+24*16
 .byt <ScreenBuffer+24*17
 .byt <ScreenBuffer+24*18
 .byt <ScreenBuffer+24*19
 .byt <ScreenBuffer+24*20
 .byt <ScreenBuffer+24*21
 .byt <ScreenBuffer+24*22
 .byt <ScreenBuffer+24*23
 .byt <ScreenBuffer+24*24
 .byt <ScreenBuffer+24*25
 .byt <ScreenBuffer+24*26
 .byt <ScreenBuffer+24*27
 .byt <ScreenBuffer+24*28
 .byt <ScreenBuffer+24*29
 .byt <ScreenBuffer+24*30
 .byt <ScreenBuffer+24*31
 .byt <ScreenBuffer+24*32
 .byt <ScreenBuffer+24*33
 .byt <ScreenBuffer+24*34
 .byt <ScreenBuffer+24*35
 .byt <ScreenBuffer+24*36
 .byt <ScreenBuffer+24*37
 .byt <ScreenBuffer+24*38
 .byt <ScreenBuffer+24*39
 .byt <ScreenBuffer+24*40
 .byt <ScreenBuffer+24*41
 .byt <ScreenBuffer+24*42
 .byt <ScreenBuffer+24*43
 .byt <ScreenBuffer+24*44
 .byt <ScreenBuffer+24*45
 .byt <ScreenBuffer+24*46
 .byt <ScreenBuffer+24*47
 .byt <ScreenBuffer+24*48
 .byt <ScreenBuffer+24*49
 .byt <ScreenBuffer+24*50
 .byt <ScreenBuffer+24*51
 .byt <ScreenBuffer+24*52
 .byt <ScreenBuffer+24*53
 .byt <ScreenBuffer+24*54
 .byt <ScreenBuffer+24*55
 .byt <ScreenBuffer+24*56
 .byt <ScreenBuffer+24*57
 .byt <ScreenBuffer+24*58
 .byt <ScreenBuffer+24*59
 .byt <ScreenBuffer+24*60
 .byt <ScreenBuffer+24*61
 .byt <ScreenBuffer+24*62
 .byt <ScreenBuffer+24*63
 .byt <ScreenBuffer+24*64
 .byt <ScreenBuffer+24*65
 .byt <ScreenBuffer+24*66
 .byt <ScreenBuffer+24*67
 .byt <ScreenBuffer+24*68
 .byt <ScreenBuffer+24*69
 .byt <ScreenBuffer+24*70
 .byt <ScreenBuffer+24*71
 .byt <ScreenBuffer+24*72
 .byt <ScreenBuffer+24*73
 .byt <ScreenBuffer+24*74
 .byt <ScreenBuffer+24*75
 .byt <ScreenBuffer+24*76
 .byt <ScreenBuffer+24*77
 .byt <ScreenBuffer+24*78
 .byt <ScreenBuffer+24*79
 .byt <ScreenBuffer+24*80
 .byt <ScreenBuffer+24*81
 .byt <ScreenBuffer+24*82
 .byt <ScreenBuffer+24*83
 .byt <ScreenBuffer+24*84
 .byt <ScreenBuffer+24*85
 .byt <ScreenBuffer+24*86
 .byt <ScreenBuffer+24*87
 .byt <ScreenBuffer+24*88
 .byt <ScreenBuffer+24*89
 .byt <ScreenBuffer+24*90
 .byt <ScreenBuffer+24*91
 .byt <ScreenBuffer+24*92
 .byt <ScreenBuffer+24*93
 .byt <ScreenBuffer+24*94
 .byt <ScreenBuffer+24*95
 .byt <ScreenBuffer+24*96
 .byt <ScreenBuffer+24*97
 .byt <ScreenBuffer+24*98
 .byt <ScreenBuffer+24*99
 .byt <ScreenBuffer+24*100
 .byt <ScreenBuffer+24*101
 .byt <ScreenBuffer+24*102
 .byt <ScreenBuffer+24*103
 .byt <ScreenBuffer+24*104
 .byt <ScreenBuffer+24*105
 .byt <ScreenBuffer+24*106
 .byt <ScreenBuffer+24*107
 .byt <ScreenBuffer+24*108
 .byt <ScreenBuffer+24*109
 .byt <ScreenBuffer+24*110
 .byt <ScreenBuffer+24*111
 .byt <ScreenBuffer+24*112
 .byt <ScreenBuffer+24*113
 .byt <ScreenBuffer+24*114
 .byt <ScreenBuffer+24*115
 .byt <ScreenBuffer+24*116
 .byt <ScreenBuffer+24*117
 .byt <ScreenBuffer+24*118
 .byt <ScreenBuffer+24*119
 .byt <ScreenBuffer+24*120
 .byt <ScreenBuffer+24*121
 .byt <ScreenBuffer+24*122
 .byt <ScreenBuffer+24*123
 .byt <ScreenBuffer+24*124
 .byt <ScreenBuffer+24*125
 .byt <ScreenBuffer+24*126
 .byt <ScreenBuffer+24*127
 .byt <ScreenBuffer+24*128
 .byt <ScreenBuffer+24*129
 .byt <ScreenBuffer+24*130
 .byt <ScreenBuffer+24*131
 .byt <ScreenBuffer+24*132
 .byt <ScreenBuffer+24*133
 .byt <ScreenBuffer+24*134
 .byt <ScreenBuffer+24*135
 .byt <ScreenBuffer+24*136
 .byt <ScreenBuffer+24*137
 .byt <ScreenBuffer+24*138
 .byt <ScreenBuffer+24*139
 .byt <ScreenBuffer+24*140
 .byt <ScreenBuffer+24*141
 .byt <ScreenBuffer+24*142
 .byt <ScreenBuffer+24*143
 .byt <ScreenBuffer+24*144
 .byt <ScreenBuffer+24*145
 .byt <ScreenBuffer+24*146
 .byt <ScreenBuffer+24*147
 .byt <ScreenBuffer+24*148
 .byt <ScreenBuffer+24*149
 .byt <ScreenBuffer+24*150
 .byt <ScreenBuffer+24*151
 .byt <ScreenBuffer+24*152
 .byt <ScreenBuffer+24*153
 .byt <ScreenBuffer+24*154
 .byt <ScreenBuffer+24*155
 .byt <ScreenBuffer+24*156
 .byt <ScreenBuffer+24*157

ScreenBufferRowAddressHi
 .byt >ScreenBuffer
 .byt >ScreenBuffer+24*1
 .byt >ScreenBuffer+24*2
 .byt >ScreenBuffer+24*3
 .byt >ScreenBuffer+24*4
 .byt >ScreenBuffer+24*5
 .byt >ScreenBuffer+24*6
 .byt >ScreenBuffer+24*7
 .byt >ScreenBuffer+24*8
 .byt >ScreenBuffer+24*9
 .byt >ScreenBuffer+24*10
 .byt >ScreenBuffer+24*11
 .byt >ScreenBuffer+24*12
 .byt >ScreenBuffer+24*13
 .byt >ScreenBuffer+24*14
 .byt >ScreenBuffer+24*15
 .byt >ScreenBuffer+24*16
 .byt >ScreenBuffer+24*17
 .byt >ScreenBuffer+24*18
 .byt >ScreenBuffer+24*19
 .byt >ScreenBuffer+24*20
 .byt >ScreenBuffer+24*21
 .byt >ScreenBuffer+24*22
 .byt >ScreenBuffer+24*23
 .byt >ScreenBuffer+24*24
 .byt >ScreenBuffer+24*25
 .byt >ScreenBuffer+24*26
 .byt >ScreenBuffer+24*27
 .byt >ScreenBuffer+24*28
 .byt >ScreenBuffer+24*29
 .byt >ScreenBuffer+24*30
 .byt >ScreenBuffer+24*31
 .byt >ScreenBuffer+24*32
 .byt >ScreenBuffer+24*33
 .byt >ScreenBuffer+24*34
 .byt >ScreenBuffer+24*35
 .byt >ScreenBuffer+24*36
 .byt >ScreenBuffer+24*37
 .byt >ScreenBuffer+24*38
 .byt >ScreenBuffer+24*39
 .byt >ScreenBuffer+24*40
 .byt >ScreenBuffer+24*41
 .byt >ScreenBuffer+24*42
 .byt >ScreenBuffer+24*43
 .byt >ScreenBuffer+24*44
 .byt >ScreenBuffer+24*45
 .byt >ScreenBuffer+24*46
 .byt >ScreenBuffer+24*47
 .byt >ScreenBuffer+24*48
 .byt >ScreenBuffer+24*49
 .byt >ScreenBuffer+24*50
 .byt >ScreenBuffer+24*51
 .byt >ScreenBuffer+24*52
 .byt >ScreenBuffer+24*53
 .byt >ScreenBuffer+24*54
 .byt >ScreenBuffer+24*55
 .byt >ScreenBuffer+24*56
 .byt >ScreenBuffer+24*57
 .byt >ScreenBuffer+24*58
 .byt >ScreenBuffer+24*59
 .byt >ScreenBuffer+24*60
 .byt >ScreenBuffer+24*61
 .byt >ScreenBuffer+24*62
 .byt >ScreenBuffer+24*63
 .byt >ScreenBuffer+24*64
 .byt >ScreenBuffer+24*65
 .byt >ScreenBuffer+24*66
 .byt >ScreenBuffer+24*67
 .byt >ScreenBuffer+24*68
 .byt >ScreenBuffer+24*69
 .byt >ScreenBuffer+24*70
 .byt >ScreenBuffer+24*71
 .byt >ScreenBuffer+24*72
 .byt >ScreenBuffer+24*73
 .byt >ScreenBuffer+24*74
 .byt >ScreenBuffer+24*75
 .byt >ScreenBuffer+24*76
 .byt >ScreenBuffer+24*77
 .byt >ScreenBuffer+24*78
 .byt >ScreenBuffer+24*79
 .byt >ScreenBuffer+24*80
 .byt >ScreenBuffer+24*81
 .byt >ScreenBuffer+24*82
 .byt >ScreenBuffer+24*83
 .byt >ScreenBuffer+24*84
 .byt >ScreenBuffer+24*85
 .byt >ScreenBuffer+24*86
 .byt >ScreenBuffer+24*87
 .byt >ScreenBuffer+24*88
 .byt >ScreenBuffer+24*89
 .byt >ScreenBuffer+24*90
 .byt >ScreenBuffer+24*91
 .byt >ScreenBuffer+24*92
 .byt >ScreenBuffer+24*93
 .byt >ScreenBuffer+24*94
 .byt >ScreenBuffer+24*95
 .byt >ScreenBuffer+24*96
 .byt >ScreenBuffer+24*97
 .byt >ScreenBuffer+24*98
 .byt >ScreenBuffer+24*99
 .byt >ScreenBuffer+24*100
 .byt >ScreenBuffer+24*101
 .byt >ScreenBuffer+24*102
 .byt >ScreenBuffer+24*103
 .byt >ScreenBuffer+24*104
 .byt >ScreenBuffer+24*105
 .byt >ScreenBuffer+24*106
 .byt >ScreenBuffer+24*107
 .byt >ScreenBuffer+24*108
 .byt >ScreenBuffer+24*109
 .byt >ScreenBuffer+24*110
 .byt >ScreenBuffer+24*111
 .byt >ScreenBuffer+24*112
 .byt >ScreenBuffer+24*113
 .byt >ScreenBuffer+24*114
 .byt >ScreenBuffer+24*115
 .byt >ScreenBuffer+24*116
 .byt >ScreenBuffer+24*117
 .byt >ScreenBuffer+24*118
 .byt >ScreenBuffer+24*119
 .byt >ScreenBuffer+24*120
 .byt >ScreenBuffer+24*121
 .byt >ScreenBuffer+24*122
 .byt >ScreenBuffer+24*123
 .byt >ScreenBuffer+24*124
 .byt >ScreenBuffer+24*125
 .byt >ScreenBuffer+24*126
 .byt >ScreenBuffer+24*127
 .byt >ScreenBuffer+24*128
 .byt >ScreenBuffer+24*129
 .byt >ScreenBuffer+24*130
 .byt >ScreenBuffer+24*131
 .byt >ScreenBuffer+24*132
 .byt >ScreenBuffer+24*133
 .byt >ScreenBuffer+24*134
 .byt >ScreenBuffer+24*135
 .byt >ScreenBuffer+24*136
 .byt >ScreenBuffer+24*137
 .byt >ScreenBuffer+24*138
 .byt >ScreenBuffer+24*139
 .byt >ScreenBuffer+24*140
 .byt >ScreenBuffer+24*141
 .byt >ScreenBuffer+24*142
 .byt >ScreenBuffer+24*143
 .byt >ScreenBuffer+24*144
 .byt >ScreenBuffer+24*145
 .byt >ScreenBuffer+24*146
 .byt >ScreenBuffer+24*147
 .byt >ScreenBuffer+24*148
 .byt >ScreenBuffer+24*149
 .byt >ScreenBuffer+24*150
 .byt >ScreenBuffer+24*151
 .byt >ScreenBuffer+24*152
 .byt >ScreenBuffer+24*153
 .byt >ScreenBuffer+24*154
 .byt >ScreenBuffer+24*155
 .byt >ScreenBuffer+24*156
 .byt >ScreenBuffer+24*157

MapRowAddressLo
 .byt <Map00
 .byt <Map00+6*1
 .byt <Map00+6*2
 .byt <Map00+6*3
 .byt <Map00+6*4
 .byt <Map00+6*5
 .byt <Map00+6*6
 .byt <Map00+6*7
 .byt <Map00+6*8
 .byt <Map00+6*9
 .byt <Map00+6*10
 .byt <Map00+6*11
 .byt <Map00+6*12
 .byt <Map00+6*13
 .byt <Map00+6*14
 .byt <Map00+6*15
 .byt <Map00+6*16
 .byt <Map00+6*17
 .byt <Map00+6*18
 .byt <Map00+6*19
 .byt <Map00+6*20
 .byt <Map00+6*21
 .byt <Map00+6*22
 .byt <Map00+6*23
 .byt <Map00+6*24
 .byt <Map00+6*25
 .byt <Map00+6*26
 .byt <Map00+6*27
 .byt <Map00+6*28
 .byt <Map00+6*29
 .byt <Map00+6*30
 .byt <Map00+6*31
 .byt <Map00+6*32
 .byt <Map00+6*33
 .byt <Map00+6*34
 .byt <Map00+6*35
 .byt <Map00+6*36
 .byt <Map00+6*37
 .byt <Map00+6*38
 .byt <Map00+6*39
 .byt <Map00+6*40
 .byt <Map00+6*41
 .byt <Map00+6*42
 .byt <Map00+6*43
 .byt <Map00+6*44
 .byt <Map00+6*45
 .byt <Map00+6*46
 .byt <Map00+6*47
 .byt <Map00+6*48
 .byt <Map00+6*49
 .byt <Map00+6*50
 .byt <Map00+6*51
 .byt <Map00+6*52
 .byt <Map00+6*53
 .byt <Map00+6*54
 .byt <Map00+6*55
 .byt <Map00+6*56
 .byt <Map00+6*57
 .byt <Map00+6*58
 .byt <Map00+6*59
 .byt <Map00+6*60
 .byt <Map00+6*61
 .byt <Map00+6*62
 .byt <Map00+6*63
 .byt <Map00+6*64
 .byt <Map00+6*65
 .byt <Map00+6*66
 .byt <Map00+6*67
 .byt <Map00+6*68
 .byt <Map00+6*69
 .byt <Map00+6*70
 .byt <Map00+6*71
 .byt <Map00+6*72
 .byt <Map00+6*73
 .byt <Map00+6*74
 .byt <Map00+6*75
 .byt <Map00+6*76
 .byt <Map00+6*77
 .byt <Map00+6*78
 .byt <Map00+6*79
 .byt <Map00+6*80
 .byt <Map00+6*81
 .byt <Map00+6*82
 .byt <Map00+6*83
 .byt <Map00+6*84
 .byt <Map00+6*85
 .byt <Map00+6*86
 .byt <Map00+6*87
 .byt <Map00+6*88
 .byt <Map00+6*89
 .byt <Map00+6*90
 .byt <Map00+6*91
 .byt <Map00+6*92
 .byt <Map00+6*93
 .byt <Map00+6*94
 .byt <Map00+6*95
 .byt <Map00+6*96
 .byt <Map00+6*97
 .byt <Map00+6*98
 .byt <Map00+6*99
 .byt <Map00+6*100
 .byt <Map00+6*101
 .byt <Map00+6*102
 .byt <Map00+6*103
 .byt <Map00+6*104
 .byt <Map00+6*105
 .byt <Map00+6*106
 .byt <Map00+6*107
 .byt <Map00+6*108
 .byt <Map00+6*109
 .byt <Map00+6*110
 .byt <Map00+6*111
 .byt <Map00+6*112
 .byt <Map00+6*113
 .byt <Map00+6*114
 .byt <Map00+6*115
 .byt <Map00+6*116
 .byt <Map00+6*117
 .byt <Map00+6*118
 .byt <Map00+6*119
 .byt <Map00+6*120
 .byt <Map00+6*121
 .byt <Map00+6*122
 .byt <Map00+6*123
 .byt <Map00+6*124
 .byt <Map00+6*125
 .byt <Map00+6*126
 .byt <Map00+6*127
MapRowAddressHi
 .byt >Map00
 .byt >Map00+6*1
 .byt >Map00+6*2
 .byt >Map00+6*3
 .byt >Map00+6*4
 .byt >Map00+6*5
 .byt >Map00+6*6
 .byt >Map00+6*7
 .byt >Map00+6*8
 .byt >Map00+6*9
 .byt >Map00+6*10
 .byt >Map00+6*11
 .byt >Map00+6*12
 .byt >Map00+6*13
 .byt >Map00+6*14
 .byt >Map00+6*15
 .byt >Map00+6*16
 .byt >Map00+6*17
 .byt >Map00+6*18
 .byt >Map00+6*19
 .byt >Map00+6*20
 .byt >Map00+6*21
 .byt >Map00+6*22
 .byt >Map00+6*23
 .byt >Map00+6*24
 .byt >Map00+6*25
 .byt >Map00+6*26
 .byt >Map00+6*27
 .byt >Map00+6*28
 .byt >Map00+6*29
 .byt >Map00+6*30
 .byt >Map00+6*31
 .byt >Map00+6*32
 .byt >Map00+6*33
 .byt >Map00+6*34
 .byt >Map00+6*35
 .byt >Map00+6*36
 .byt >Map00+6*37
 .byt >Map00+6*38
 .byt >Map00+6*39
 .byt >Map00+6*40
 .byt >Map00+6*41
 .byt >Map00+6*42
 .byt >Map00+6*43
 .byt >Map00+6*44
 .byt >Map00+6*45
 .byt >Map00+6*46
 .byt >Map00+6*47
 .byt >Map00+6*48
 .byt >Map00+6*49
 .byt >Map00+6*50
 .byt >Map00+6*51
 .byt >Map00+6*52
 .byt >Map00+6*53
 .byt >Map00+6*54
 .byt >Map00+6*55
 .byt >Map00+6*56
 .byt >Map00+6*57
 .byt >Map00+6*58
 .byt >Map00+6*59
 .byt >Map00+6*60
 .byt >Map00+6*61
 .byt >Map00+6*62
 .byt >Map00+6*63
 .byt >Map00+6*64
 .byt >Map00+6*65
 .byt >Map00+6*66
 .byt >Map00+6*67
 .byt >Map00+6*68
 .byt >Map00+6*69
 .byt >Map00+6*70
 .byt >Map00+6*71
 .byt >Map00+6*72
 .byt >Map00+6*73
 .byt >Map00+6*74
 .byt >Map00+6*75
 .byt >Map00+6*76
 .byt >Map00+6*77
 .byt >Map00+6*78
 .byt >Map00+6*79
 .byt >Map00+6*80
 .byt >Map00+6*81
 .byt >Map00+6*82
 .byt >Map00+6*83
 .byt >Map00+6*84
 .byt >Map00+6*85
 .byt >Map00+6*86
 .byt >Map00+6*87
 .byt >Map00+6*88
 .byt >Map00+6*89
 .byt >Map00+6*90
 .byt >Map00+6*91
 .byt >Map00+6*92
 .byt >Map00+6*93
 .byt >Map00+6*94
 .byt >Map00+6*95
 .byt >Map00+6*96
 .byt >Map00+6*97
 .byt >Map00+6*98
 .byt >Map00+6*99
 .byt >Map00+6*100
 .byt >Map00+6*101
 .byt >Map00+6*102
 .byt >Map00+6*103
 .byt >Map00+6*104
 .byt >Map00+6*105
 .byt >Map00+6*106
 .byt >Map00+6*107
 .byt >Map00+6*108
 .byt >Map00+6*109
 .byt >Map00+6*110
 .byt >Map00+6*111
 .byt >Map00+6*112
 .byt >Map00+6*113
 .byt >Map00+6*114
 .byt >Map00+6*115
 .byt >Map00+6*116
 .byt >Map00+6*117
 .byt >Map00+6*118
 .byt >Map00+6*119
 .byt >Map00+6*120
 .byt >Map00+6*121
 .byt >Map00+6*122
 .byt >Map00+6*123
 .byt >Map00+6*124
 .byt >Map00+6*125
 .byt >Map00+6*126
 .byt >Map00+6*127

BlinkingColourRow0
 .byt 6,0
BlinkingColourRow1
 .byt 3,0
BlinkingColourRow2
 .byt 7,0
BlinkingColourRow3
 .byt 7,0
BlinkingColourRow4
 .byt 3,0
BlinkingColourRow5
 .byt 6,0

CollisionMap
 .dsb 24*27,0

;Indexed by Sprite_Y
CollisionMap_YLOCLo
 .dsb 6,<CollisionMap
 .dsb 6,<CollisionMap+24*1
 .dsb 6,<CollisionMap+24*2
 .dsb 6,<CollisionMap+24*3
 .dsb 6,<CollisionMap+24*4
 .dsb 6,<CollisionMap+24*5
 .dsb 6,<CollisionMap+24*6
 .dsb 6,<CollisionMap+24*7
 .dsb 6,<CollisionMap+24*8
 .dsb 6,<CollisionMap+24*9
 .dsb 6,<CollisionMap+24*10
 .dsb 6,<CollisionMap+24*11
 .dsb 6,<CollisionMap+24*12
 .dsb 6,<CollisionMap+24*13
 .dsb 6,<CollisionMap+24*14
 .dsb 6,<CollisionMap+24*15
 .dsb 6,<CollisionMap+24*16
 .dsb 6,<CollisionMap+24*17
 .dsb 6,<CollisionMap+24*18
 .dsb 6,<CollisionMap+24*19
 .dsb 6,<CollisionMap+24*20
 .dsb 6,<CollisionMap+24*21
 .dsb 6,<CollisionMap+24*22
 .dsb 6,<CollisionMap+24*23
 .dsb 6,<CollisionMap+24*24
 .dsb 6,<CollisionMap+24*25
 .dsb 6,<CollisionMap+24*26
 .dsb 6,<CollisionMap+24*27

CollisionMap_YLOCHi
 .dsb 6,>CollisionMap
 .dsb 6,>CollisionMap+24*1
 .dsb 6,>CollisionMap+24*2
 .dsb 6,>CollisionMap+24*3
 .dsb 6,>CollisionMap+24*4
 .dsb 6,>CollisionMap+24*5
 .dsb 6,>CollisionMap+24*6
 .dsb 6,>CollisionMap+24*7
 .dsb 6,>CollisionMap+24*8
 .dsb 6,>CollisionMap+24*9
 .dsb 6,>CollisionMap+24*10
 .dsb 6,>CollisionMap+24*11
 .dsb 6,>CollisionMap+24*12
 .dsb 6,>CollisionMap+24*13
 .dsb 6,>CollisionMap+24*14
 .dsb 6,>CollisionMap+24*15
 .dsb 6,>CollisionMap+24*16
 .dsb 6,>CollisionMap+24*17
 .dsb 6,>CollisionMap+24*18
 .dsb 6,>CollisionMap+24*19
 .dsb 6,>CollisionMap+24*20
 .dsb 6,>CollisionMap+24*21
 .dsb 6,>CollisionMap+24*22
 .dsb 6,>CollisionMap+24*23
 .dsb 6,>CollisionMap+24*24
 .dsb 6,>CollisionMap+24*25
 .dsb 6,>CollisionMap+24*26
 .dsb 6,>CollisionMap+24*27

Sprite_HeroTarget		;Holds the hero(0 or 1) for the sprite to target
 .dsb 32,0
Sprite_ExplosionScript	;Holds the Explosion ScriptID (popped in script)
 .dsb 32,0
Sprite_ScriptID		;Holds the Sprites ScriptID
 .dsb 32,0
Sprite_ScriptIndex		;Holds the Sprites Script Index pointer
 .dsb 32,0
Sprite_PausePeriod		;
 .dsb 32,0
Sprite_CurrentDir
 .dsb 32,0
Sprite_X
 .dsb 32,0
Sprite_Y
 .dsb 32,0
Sprite_ID
 .dsb 32,0
Sprite_DirectionsTable
 .dsb 32*8,0
Sprite_ConditionID
 .dsb 32,0
Sprite_Counter
 .dsb 32,0
Sprite_GroupID
 .dsb 32,0
;Bit7 Ground based Sprite (Process first when rendering to ScreenBuffer)
;Bit6 Square Sprite (In order to directly plot to screenbuffer without mask)
;Bit5 Current Bonus Selection(If sprite is Bonus, this bit sets which nibble is currently displayed)
;Bit4 Don't detect Collisions(Explosion)
;Bit3 Show Sprites Shadow (Bonuses,projectiles and ground based sprite don't have shadows)
;Bit2 Whiteout Flag (when sprite hit)
;Bits0-1
; 0 Sprite is single (Never players)
; 1 Sprite is part of bigger group(Never players)
; 2 Player A
; 3 Player B
Sprite_Attributes
 .dsb 32,0
Sprite_Width
 .dsb 32,0
Sprite_Height
 .dsb 32,0
Sprite_UltimateByte
 .dsb 32,0
Sprite_UniqueID
 .byt 1	;This is always the hero
 .dsb 31,0
Sprite_CollisionBytes	;0 based
 .byt 2	;For players must by +1 because plotting always starts +1 (+1,+2)
 .byt 2
 .dsb 30,0
;For Sprite Hitpoints it is the Sprites Health
Sprite_HitPoints
 .dsb 32,0
Sprite_Health
 .dsb 32,0
;Reflects the prize given in destroying the sprite.
Sprite_ScorePoints
 .dsb 32,1
Sprite_HitIndex
 .dsb 32,0
;Bonuses only set by Bonus
;B0 Orb
;B1 Double Cannon
;B2 Splay
;B3 Sidewinders
;B4 Retros
;B5 Smartbomb
;B6 Missiles
;B7 Laser
Sprite_Bonuses
 .dsb 32,0

SpriteBitmapFrameAddressLo
 .byt <LevelBitmapFrame_00			;64
 .byt <LevelBitmapFrame_01
 .byt <LevelBitmapFrame_02
 .byt <LevelBitmapFrame_03
 .byt <LevelBitmapFrame_04
 .byt <LevelBitmapFrame_05
 .byt <LevelBitmapFrame_06
 .byt <LevelBitmapFrame_07
 .byt <LevelBitmapFrame_08
 .byt <LevelBitmapFrame_09
 .byt <LevelBitmapFrame_10
 .byt <LevelBitmapFrame_11
 .byt <LevelBitmapFrame_12
 .byt <LevelBitmapFrame_13
 .byt <LevelBitmapFrame_14
 .byt <LevelBitmapFrame_15
 .byt <LevelBitmapFrame_16
 .byt <LevelBitmapFrame_17
 .byt <LevelBitmapFrame_18
 .byt <LevelBitmapFrame_19
 .byt <LevelBitmapFrame_20
 .byt <LevelBitmapFrame_21
 .byt <LevelBitmapFrame_22
 .byt <LevelBitmapFrame_23
 .byt <LevelBitmapFrame_24
 .byt <LevelBitmapFrame_25
 .byt <LevelBitmapFrame_26
 .byt <LevelBitmapFrame_27
 .byt <LevelBitmapFrame_28
 .byt <LevelBitmapFrame_29
 .byt <LevelBitmapFrame_30
 .byt <LevelBitmapFrame_31
 .byt <LevelBitmapFrame_32
 .byt <LevelBitmapFrame_33
 .byt <LevelBitmapFrame_34
 .byt <LevelBitmapFrame_35
 .byt <LevelBitmapFrame_36
 .byt <LevelBitmapFrame_37
 .byt <LevelBitmapFrame_38
 .byt <LevelBitmapFrame_39
 .byt <LevelBitmapFrame_40
 .byt <LevelBitmapFrame_41
 .byt <LevelBitmapFrame_42
 .byt <LevelBitmapFrame_43
 .byt <LevelBitmapFrame_44
 .byt <LevelBitmapFrame_45
 .byt <LevelBitmapFrame_46
 .byt <LevelBitmapFrame_47
 .byt <LevelBitmapFrame_48
 .byt <LevelBitmapFrame_49
 .byt <LevelBitmapFrame_50
 .byt <LevelBitmapFrame_51
 .byt <LevelBitmapFrame_52
 .byt <LevelBitmapFrame_53
 .byt <LevelBitmapFrame_54
 .byt <LevelBitmapFrame_55
 .byt <LevelBitmapFrame_56
 .byt <LevelBitmapFrame_57
 .byt <LevelBitmapFrame_58
 .byt <LevelBitmapFrame_59
 .byt <LevelBitmapFrame_60
 .byt <LevelBitmapFrame_61
 .byt <LevelBitmapFrame_62
 .byt <LevelBitmapFrame_63

 .byt <gfxSprite_PlayerARetroBitmap		;64 Hero Craft North
 .byt <gfxSprite_PlayerANormalBitmap		;65 Hero Craft South
 .byt <gfxSprite_PlayerAAweLeftBitmap		;66 Hero Craft West
 .byt <gfxSprite_PlayerAAweRightBitmap		;67 Hero Craft East
 

 .byt <gfxSprite_HeroMainForwardCannon_Bitmap	;68

 .byt <gfxExplosionBitmap00			;69
 .byt <gfxExplosionBitmap01			;70
 .byt <gfxExplosionBitmap02			;71
 .byt <gfxExplosionBitmap03			;72
 .byt <gfxExplosionBitmap04                       ;73
 .byt <gfxExplosionBitmap05                       ;74
 .byt <gfxExplosionBitmap06                       ;75
 .byt <gfxExplosionBitmap07                       ;76
 .byt <gfxExplosionBitmap08                       ;77
 .byt <gfxExplosionBitmap09                       ;78
 .byt <gfxExplosionBitmap10                       ;79

 .byt <gfxSprite_PlayerBRetroBitmap		;80 Hero Craft North
 .byt <gfxSprite_PlayerBNormalBitmap		;81 Hero Craft South
 .byt <gfxSprite_PlayerBAweLeftBitmap		;82 Hero Craft West
 .byt <gfxSprite_PlayerBAweRightBitmap		;83 Hero Craft East

 .byt <gfxGenericBullet_BitmapFrameN		;84
 .byt <gfxGenericBullet_BitmapFrameNE		;85
 .byt <gfxGenericBullet_BitmapFrameE		;86
 .byt <gfxGenericBullet_BitmapFrameSE		;87
 .byt <gfxGenericBullet_BitmapFrameS		;88
 .byt <gfxGenericBullet_BitmapFrameSW		;89
 .byt <gfxGenericBullet_BitmapFrameW		;90
 .byt <gfxGenericBullet_BitmapFrameNW		;91
 
 .byt <bmpBonus_Blank			;92  - 0
 .byt <bmpBonus_Health			;93  - 1
 .byt <bmpBonus_Life                              ;94  - 2
 .byt <bmpBonus_DoubleCannon                      ;95  - 3
 .byt <bmpBonus_Splay                             ;96  - 4
 .byt <bmpBonus_Sidewinders                       ;97  - 5
 .byt <bmpBonus_Retros                            ;98  - 6
 .byt <bmpBonus_SmartBomb                         ;99  - 7
 .byt <bmpBonus_Missile                           ;100 - 8
 .byt <bmpBonus_Laser                             ;101 - 9
 .byt <bmpBonus_SpeedUp                           ;102 - A
 .byt <bmpBonus_Invisibility                      ;103 - B
 .byt <bmpBonus_Shield                            ;104 - C
 .byt <bmpBonus_Orb                               ;105 - D 
 .byt <bmpBonus_Blank			;106 - E
 .byt <bmpBonus_Blank			;107 - F
 .byt <bmpBonus_Flip00                            ;108  
 .byt <bmpBonus_Flip01                            ;109  
 .byt <bmpBonus_Flip02                            ;110

SpriteBitmapFrameAddressHi
 .byt >LevelBitmapFrame_00
 .byt >LevelBitmapFrame_01
 .byt >LevelBitmapFrame_02
 .byt >LevelBitmapFrame_03
 .byt >LevelBitmapFrame_04
 .byt >LevelBitmapFrame_05
 .byt >LevelBitmapFrame_06
 .byt >LevelBitmapFrame_07
 .byt >LevelBitmapFrame_08
 .byt >LevelBitmapFrame_09
 .byt >LevelBitmapFrame_10
 .byt >LevelBitmapFrame_11
 .byt >LevelBitmapFrame_12
 .byt >LevelBitmapFrame_13
 .byt >LevelBitmapFrame_14
 .byt >LevelBitmapFrame_15
 .byt >LevelBitmapFrame_16
 .byt >LevelBitmapFrame_17
 .byt >LevelBitmapFrame_18
 .byt >LevelBitmapFrame_19
 .byt >LevelBitmapFrame_20
 .byt >LevelBitmapFrame_21
 .byt >LevelBitmapFrame_22
 .byt >LevelBitmapFrame_23
 .byt >LevelBitmapFrame_24
 .byt >LevelBitmapFrame_25
 .byt >LevelBitmapFrame_26
 .byt >LevelBitmapFrame_27
 .byt >LevelBitmapFrame_28
 .byt >LevelBitmapFrame_29
 .byt >LevelBitmapFrame_30
 .byt >LevelBitmapFrame_31
 .byt >LevelBitmapFrame_32
 .byt >LevelBitmapFrame_33
 .byt >LevelBitmapFrame_34
 .byt >LevelBitmapFrame_35
 .byt >LevelBitmapFrame_36
 .byt >LevelBitmapFrame_37
 .byt >LevelBitmapFrame_38
 .byt >LevelBitmapFrame_39
 .byt >LevelBitmapFrame_40
 .byt >LevelBitmapFrame_41
 .byt >LevelBitmapFrame_42
 .byt >LevelBitmapFrame_43
 .byt >LevelBitmapFrame_44
 .byt >LevelBitmapFrame_45
 .byt >LevelBitmapFrame_46
 .byt >LevelBitmapFrame_47
 .byt >LevelBitmapFrame_48
 .byt >LevelBitmapFrame_49
 .byt >LevelBitmapFrame_50
 .byt >LevelBitmapFrame_51
 .byt >LevelBitmapFrame_52
 .byt >LevelBitmapFrame_53
 .byt >LevelBitmapFrame_54
 .byt >LevelBitmapFrame_55
 .byt >LevelBitmapFrame_56
 .byt >LevelBitmapFrame_57
 .byt >LevelBitmapFrame_58
 .byt >LevelBitmapFrame_59
 .byt >LevelBitmapFrame_60
 .byt >LevelBitmapFrame_61
 .byt >LevelBitmapFrame_62
 .byt >LevelBitmapFrame_63

 .byt >gfxSprite_PlayerARetroBitmap		;64 Hero Craft North
 .byt >gfxSprite_PlayerANormalBitmap		;65 Hero Craft South
 .byt >gfxSprite_PlayerAAweLeftBitmap		;66 Hero Craft West
 .byt >gfxSprite_PlayerAAweRightBitmap		;67 Hero Craft East
 
;Projectiles start 68
 .byt >gfxSprite_HeroMainForwardCannon_Bitmap	;68

 .byt >gfxExplosionBitmap00                       ;69
 .byt >gfxExplosionBitmap01                       ;70
 .byt >gfxExplosionBitmap02                       ;71
 .byt >gfxExplosionBitmap03                       ;72
 .byt >gfxExplosionBitmap04                       ;73
 .byt >gfxExplosionBitmap05                       ;74
 .byt >gfxExplosionBitmap06                       ;75
 .byt >gfxExplosionBitmap07                       ;76
 .byt >gfxExplosionBitmap08                       ;77
 .byt >gfxExplosionBitmap09                       ;78
 .byt >gfxExplosionBitmap10                       ;79

 .byt >gfxSprite_PlayerBRetroBitmap		;80 Hero Craft North
 .byt >gfxSprite_PlayerBNormalBitmap		;81 Hero Craft South
 .byt >gfxSprite_PlayerBAweLeftBitmap		;82 Hero Craft West
 .byt >gfxSprite_PlayerBAweRightBitmap		;83 Hero Craft East

 .byt >gfxGenericBullet_BitmapFrameN		;84
 .byt >gfxGenericBullet_BitmapFrameNE		;85
 .byt >gfxGenericBullet_BitmapFrameE		;86
 .byt >gfxGenericBullet_BitmapFrameSE		;87
 .byt >gfxGenericBullet_BitmapFrameS		;88
 .byt >gfxGenericBullet_BitmapFrameSW		;89
 .byt >gfxGenericBullet_BitmapFrameW		;90
 .byt >gfxGenericBullet_BitmapFrameNW		;91

 .byt >bmpBonus_Blank			;92  - 0
 .byt >bmpBonus_Health			;93  - 1
 .byt >bmpBonus_Life                              ;94  - 2
 .byt >bmpBonus_DoubleCannon                      ;95  - 3
 .byt >bmpBonus_Splay                             ;96  - 4
 .byt >bmpBonus_Sidewinders                       ;97  - 5
 .byt >bmpBonus_Retros                            ;98  - 6
 .byt >bmpBonus_SmartBomb                         ;99  - 7
 .byt >bmpBonus_Missile                           ;100 - 8
 .byt >bmpBonus_Laser                             ;101 - 9
 .byt >bmpBonus_SpeedUp                           ;102 - A
 .byt >bmpBonus_Invisibility                      ;103 - B
 .byt >bmpBonus_Shield                            ;104 - C
 .byt >bmpBonus_Orb                               ;105 - D 
 .byt >bmpBonus_Blank			;106 - E
 .byt >bmpBonus_Blank			;107 - F
 .byt >bmpBonus_Flip00                            ;108  
 .byt >bmpBonus_Flip01                            ;109  
 .byt >bmpBonus_Flip02                            ;110

SpriteMaskFrameAddressLo
 .byt <LevelMaskFrame_00
 .byt <LevelMaskFrame_01
 .byt <LevelMaskFrame_02
 .byt <LevelMaskFrame_03
 .byt <LevelMaskFrame_04
 .byt <LevelMaskFrame_05
 .byt <LevelMaskFrame_06
 .byt <LevelMaskFrame_07
 .byt <LevelMaskFrame_08
 .byt <LevelMaskFrame_09
 .byt <LevelMaskFrame_10
 .byt <LevelMaskFrame_11
 .byt <LevelMaskFrame_12
 .byt <LevelMaskFrame_13
 .byt <LevelMaskFrame_14
 .byt <LevelMaskFrame_15
 .byt <LevelMaskFrame_16
 .byt <LevelMaskFrame_17
 .byt <LevelMaskFrame_18
 .byt <LevelMaskFrame_19
 .byt <LevelMaskFrame_20
 .byt <LevelMaskFrame_21
 .byt <LevelMaskFrame_22
 .byt <LevelMaskFrame_23
 .byt <LevelMaskFrame_24
 .byt <LevelMaskFrame_25
 .byt <LevelMaskFrame_26
 .byt <LevelMaskFrame_27
 .byt <LevelMaskFrame_28
 .byt <LevelMaskFrame_29
 .byt <LevelMaskFrame_30
 .byt <LevelMaskFrame_31
 .byt <LevelMaskFrame_32
 .byt <LevelMaskFrame_33
 .byt <LevelMaskFrame_34
 .byt <LevelMaskFrame_35
 .byt <LevelMaskFrame_36
 .byt <LevelMaskFrame_37
 .byt <LevelMaskFrame_38
 .byt <LevelMaskFrame_39
 .byt <LevelMaskFrame_40
 .byt <LevelMaskFrame_41
 .byt <LevelMaskFrame_42
 .byt <LevelMaskFrame_43
 .byt <LevelMaskFrame_44
 .byt <LevelMaskFrame_45
 .byt <LevelMaskFrame_46
 .byt <LevelMaskFrame_47
 .byt <LevelMaskFrame_48
 .byt <LevelMaskFrame_49
 .byt <LevelMaskFrame_50
 .byt <LevelMaskFrame_51
 .byt <LevelMaskFrame_52
 .byt <LevelMaskFrame_53
 .byt <LevelMaskFrame_54
 .byt <LevelMaskFrame_55
 .byt <LevelMaskFrame_56
 .byt <LevelMaskFrame_57
 .byt <LevelMaskFrame_58
 .byt <LevelMaskFrame_59
 .byt <LevelMaskFrame_60
 .byt <LevelMaskFrame_61
 .byt <LevelMaskFrame_62
 .byt <LevelMaskFrame_63
 
 .byt <gfxSprite_PlayerARetroMask		;64 Hero Craft North
 .byt <gfxSprite_PlayerANormalMask		;65 Hero Craft South
 .byt <gfxSprite_PlayerAAweLeftMask		;66 Hero Craft West
 .byt <gfxSprite_PlayerAAweRightMask		;67 Hero Craft East
 
;Projectiles start 68
 .byt <gfxSprite_HeroMainForwardCannon_Mask	;68

 .byt <gfxExplosionMask00                         ;69
 .byt <gfxExplosionMask01                         ;70
 .byt <gfxExplosionMask02                         ;71
 .byt <gfxExplosionMask03                         ;72
 .byt <gfxExplosionMask04                         ;73
 .byt <gfxExplosionMask05                         ;74
 .byt <gfxExplosionMask06                         ;75
 .byt <gfxExplosionMask07                         ;76
 .byt <gfxExplosionMask08                         ;77
 .byt <gfxExplosionMask09                         ;78
 .byt <gfxExplosionMask10                         ;79

 .byt <gfxSprite_PlayerBRetroMask		;80 PlayerB Craft North
 .byt <gfxSprite_PlayerBNormalMask		;81 PlayerB Craft South
 .byt <gfxSprite_PlayerBAweLeftMask		;82 PlayerB Craft West
 .byt <gfxSprite_PlayerBAweRightMask		;83 PlayerB Craft East

 .byt <gfxGenericBullet_MaskFrameN		;84
 .byt <gfxGenericBullet_MaskFrameNE		;85
 .byt <gfxGenericBullet_MaskFrameE		;86
 .byt <gfxGenericBullet_MaskFrameSE		;87
 .byt <gfxGenericBullet_MaskFrameS		;88
 .byt <gfxGenericBullet_MaskFrameSW		;89
 .byt <gfxGenericBullet_MaskFrameW		;90
 .byt <gfxGenericBullet_MaskFrameNW		;91

 .byt <mskBonus_Generic			;92
 .byt <mskBonus_Generic                         	;93
 .byt <mskBonus_Generic                      	;94
 .byt <mskBonus_Generic                         	;95
 .byt <mskBonus_Generic                       	;96
 .byt <mskBonus_Generic                         	;97
 .byt <mskBonus_Generic                         	;98
 .byt <mskBonus_Generic                         	;99
 .byt <mskBonus_Generic                         	;100
 .byt <mskBonus_Generic                         	;101
 .byt <mskBonus_Generic                      	;102
 .byt <mskBonus_Generic                         	;103
 .byt <mskBonus_Generic                         	;104
 .byt <mskBonus_Generic                         	;105
 .byt <mskBonus_Generic                         	;106
 .byt <mskBonus_Generic                         	;107
 .byt <mskBonus_Flip00                         	;108
 .byt <mskBonus_Flip01                         	;109
 .byt <mskBonus_Flip02                         	;110

SpriteMaskFrameAddressHi
 .byt >LevelMaskFrame_00
 .byt >LevelMaskFrame_01
 .byt >LevelMaskFrame_02
 .byt >LevelMaskFrame_03
 .byt >LevelMaskFrame_04
 .byt >LevelMaskFrame_05
 .byt >LevelMaskFrame_06
 .byt >LevelMaskFrame_07
 .byt >LevelMaskFrame_08
 .byt >LevelMaskFrame_09
 .byt >LevelMaskFrame_10
 .byt >LevelMaskFrame_11
 .byt >LevelMaskFrame_12
 .byt >LevelMaskFrame_13
 .byt >LevelMaskFrame_14
 .byt >LevelMaskFrame_15
 .byt >LevelMaskFrame_16
 .byt >LevelMaskFrame_17
 .byt >LevelMaskFrame_18
 .byt >LevelMaskFrame_19
 .byt >LevelMaskFrame_20
 .byt >LevelMaskFrame_21
 .byt >LevelMaskFrame_22
 .byt >LevelMaskFrame_23
 .byt >LevelMaskFrame_24
 .byt >LevelMaskFrame_25
 .byt >LevelMaskFrame_26
 .byt >LevelMaskFrame_27
 .byt >LevelMaskFrame_28
 .byt >LevelMaskFrame_29
 .byt >LevelMaskFrame_30
 .byt >LevelMaskFrame_31
 .byt >LevelMaskFrame_32
 .byt >LevelMaskFrame_33
 .byt >LevelMaskFrame_34
 .byt >LevelMaskFrame_35
 .byt >LevelMaskFrame_36
 .byt >LevelMaskFrame_37
 .byt >LevelMaskFrame_38
 .byt >LevelMaskFrame_39
 .byt >LevelMaskFrame_40
 .byt >LevelMaskFrame_41
 .byt >LevelMaskFrame_42
 .byt >LevelMaskFrame_43
 .byt >LevelMaskFrame_44
 .byt >LevelMaskFrame_45
 .byt >LevelMaskFrame_46
 .byt >LevelMaskFrame_47
 .byt >LevelMaskFrame_48
 .byt >LevelMaskFrame_49
 .byt >LevelMaskFrame_50
 .byt >LevelMaskFrame_51
 .byt >LevelMaskFrame_52
 .byt >LevelMaskFrame_53
 .byt >LevelMaskFrame_54
 .byt >LevelMaskFrame_55
 .byt >LevelMaskFrame_56
 .byt >LevelMaskFrame_57
 .byt >LevelMaskFrame_58
 .byt >LevelMaskFrame_59
 .byt >LevelMaskFrame_60
 .byt >LevelMaskFrame_61
 .byt >LevelMaskFrame_62
 .byt >LevelMaskFrame_63

 .byt >gfxSprite_PlayerARetroMask		;64 PlayerA Craft North
 .byt >gfxSprite_PlayerANormalMask		;65 PlayerA Craft South
 .byt >gfxSprite_PlayerAAweLeftMask		;66 PlayerA Craft West
 .byt >gfxSprite_PlayerAAweRightMask		;67 PlayerA Craft East
 
;Projectiles start 68
 .byt >gfxSprite_HeroMainForwardCannon_Mask	;68
 
 .byt >gfxExplosionMask00			;69
 .byt >gfxExplosionMask01                         ;70
 .byt >gfxExplosionMask02                         ;71
 .byt >gfxExplosionMask03                         ;72
 .byt >gfxExplosionMask04                         ;73
 .byt >gfxExplosionMask05                         ;74
 .byt >gfxExplosionMask06                         ;75
 .byt >gfxExplosionMask07                         ;76
 .byt >gfxExplosionMask08                         ;77
 .byt >gfxExplosionMask09                         ;78
 .byt >gfxExplosionMask10                         ;79
 
 .byt >gfxSprite_PlayerBRetroMask		;80 PlayerB Craft North
 .byt >gfxSprite_PlayerBNormalMask		;81 PlayerB Craft South
 .byt >gfxSprite_PlayerBAweLeftMask		;82 PlayerB Craft West
 .byt >gfxSprite_PlayerBAweRightMask		;83 PlayerB Craft East

 .byt >gfxGenericBullet_MaskFrameN		;84
 .byt >gfxGenericBullet_MaskFrameNE		;85
 .byt >gfxGenericBullet_MaskFrameE		;86
 .byt >gfxGenericBullet_MaskFrameSE		;87
 .byt >gfxGenericBullet_MaskFrameS		;88
 .byt >gfxGenericBullet_MaskFrameSW		;89
 .byt >gfxGenericBullet_MaskFrameW		;90
 .byt >gfxGenericBullet_MaskFrameNW		;91
 
 .byt >mskBonus_Generic			;92
 .byt >mskBonus_Generic                         	;93
 .byt >mskBonus_Generic                      	;94
 .byt >mskBonus_Generic                         	;95
 .byt >mskBonus_Generic                       	;96
 .byt >mskBonus_Generic                         	;97
 .byt >mskBonus_Generic                         	;98
 .byt >mskBonus_Generic                         	;99
 .byt >mskBonus_Generic                         	;100
 .byt >mskBonus_Generic                         	;101
 .byt >mskBonus_Generic                      	;102
 .byt >mskBonus_Generic                         	;103
 .byt >mskBonus_Generic                         	;104
 .byt >mskBonus_Generic                         	;105
 .byt >mskBonus_Generic                         	;106
 .byt >mskBonus_Generic                         	;107
 .byt >mskBonus_Flip00                         	;108
 .byt >mskBonus_Flip01                         	;109
 .byt >mskBonus_Flip02                         	;110

SpriteScriptAddressLo
 .byt <LevelScript_00
 .byt <LevelScript_01
 .byt <LevelScript_02
 .byt <LevelScript_03
 .byt <LevelScript_04
 .byt <LevelScript_05
 .byt <LevelScript_06
 .byt <LevelScript_07
 .byt <LevelScript_08
 .byt <LevelScript_09
 .byt <LevelScript_10
 .byt <LevelScript_11
 .byt <LevelScript_12
 .byt <LevelScript_13
 .byt <LevelScript_14
 .byt <LevelScript_15
 .byt <LevelScript_16
 .byt <LevelScript_17
 .byt <LevelScript_18
 .byt <LevelScript_19
 .byt <LevelScript_20
 .byt <LevelScript_21
 .byt <LevelScript_22
 .byt <LevelScript_23
 .byt <LevelScript_24
 .byt <LevelScript_25
 .byt <LevelScript_26
 .byt <LevelScript_27
 .byt <LevelScript_28
 .byt <LevelScript_29
 .byt <LevelScript_30
 .byt <LevelScript_31

 .byt <HeroScript		;32
 .byt <BonusScript		;33
 .byt <ExplosionScript	;34
 


SpriteScriptAddressHi
 .byt >LevelScript_00			;64
 .byt >LevelScript_01
 .byt >LevelScript_02
 .byt >LevelScript_03
 .byt >LevelScript_04
 .byt >LevelScript_05
 .byt >LevelScript_06
 .byt >LevelScript_07
 .byt >LevelScript_08
 .byt >LevelScript_09
 .byt >LevelScript_10
 .byt >LevelScript_11
 .byt >LevelScript_12
 .byt >LevelScript_13
 .byt >LevelScript_14
 .byt >LevelScript_15
 .byt >LevelScript_16
 .byt >LevelScript_17
 .byt >LevelScript_18
 .byt >LevelScript_19
 .byt >LevelScript_20
 .byt >LevelScript_21
 .byt >LevelScript_22
 .byt >LevelScript_23
 .byt >LevelScript_24
 .byt >LevelScript_25
 .byt >LevelScript_26
 .byt >LevelScript_27
 .byt >LevelScript_28
 .byt >LevelScript_29
 .byt >LevelScript_30
 .byt >LevelScript_31

 .byt >HeroScript
 .byt >BonusScript		;33
 .byt >ExplosionScript	;34



HeroScript
.(
lblLoop
 .byt DISPLAY_SPRITE
 .byt BRANCH
 .byt lblLoop-HeroScript
.)

ProcessBonusCodeVectorLo
 .byt <ProcessBonus_Health			; - 1
 .byt <ProcessBonus_Life                          ; - 2
 .byt <ProcessBonus_DoubleCannon                  ; - 3
 .byt <ProcessBonus_Splay                         ; - 4
 .byt <ProcessBonus_Sidewinders                   ; - 5
 .byt <ProcessBonus_Retros                        ; - 6
 .byt <ProcessBonus_SmartBomb                     ; - 7
 .byt <ProcessBonus_Missile                       ; - 8
 .byt <ProcessBonus_Laser                         ; - 9
 .byt <ProcessBonus_SpeedUp                       ; - A
 .byt <ProcessBonus_Invisibility                  ; - B
 .byt <ProcessBonus_Shield                        ; - C
 .byt <ProcessBonus_Orb                           ; - D 
 .byt <ProcessBonus_Blank			; - E
 .byt <ProcessBonus_Blank			; - F
ProcessBonusCodeVectorHi
 .byt >ProcessBonus_Health			; - 1
 .byt >ProcessBonus_Life                          ; - 2
 .byt >ProcessBonus_DoubleCannon                  ; - 3
 .byt >ProcessBonus_Splay                         ; - 4
 .byt >ProcessBonus_Sidewinders                   ; - 5
 .byt >ProcessBonus_Retros                        ; - 6
 .byt >ProcessBonus_SmartBomb                     ; - 7
 .byt >ProcessBonus_Missile                       ; - 8
 .byt >ProcessBonus_Laser                         ; - 9
 .byt >ProcessBonus_SpeedUp                       ; - A
 .byt >ProcessBonus_Invisibility                  ; - B
 .byt >ProcessBonus_Shield                        ; - C
 .byt >ProcessBonus_Orb                           ; - D 
 .byt >ProcessBonus_Blank			; - E
 .byt >ProcessBonus_Blank			; - F
Score4Bonus
 .byt 0
 .byt 10		;ProcessBonus_Health	; - 1
 .byt 10		;ProcessBonus_Life            ; - 2
 .byt 10		;ProcessBonus_DoubleCannon    ; - 3
 .byt 10		;ProcessBonus_Splay           ; - 4
 .byt 10		;ProcessBonus_Sidewinders     ; - 5
 .byt 10		;ProcessBonus_Retros          ; - 6
 .byt 10		;ProcessBonus_SmartBomb       ; - 7
 .byt 10		;ProcessBonus_Missile         ; - 8
 .byt 10		;ProcessBonus_Laser           ; - 9
 .byt 10		;ProcessBonus_SpeedUp         ; - A
 .byt 10		;ProcessBonus_Invisibility    ; - B
 .byt 10		;ProcessBonus_Shield          ; - C
 .byt 10		;ProcessBonus_Orb             ; - D 
 .byt 10		;ProcessBonus_Blank		; - E
 .byt 10		;ProcessBonus_Blank		; - F


;Projectiles start here

;     E SE S
DirectionStepX
 .byt 1,1,0,254,254,254,0,1
DirectionStepY
 .byt 0,1,1,1,0,254,254,254
SpriteStartX
 .byt 2,6,10,14,18	

;These tables are indexed by the Sprite WidthID
ScreenBufferOffsetTableLo
 .byt <Sprite1x11_Offset
 .byt <Sprite2x11_Offset
 .byt <Sprite3x11_Offset
 .byt <Sprite4x11_Offset
 .byt <Sprite5x11_Offset
 .byt <Sprite6x11_Offset
 .byt <Sprite7x11_Offset
 .byt <Sprite8x11_Offset
 .byt <Sprite9x11_Offset
 .byt <Sprite10x11_Offset
 .byt <Sprite11x11_Offset
ScreenBufferOffsetTableHi
 .byt >Sprite1x11_Offset
 .byt >Sprite2x11_Offset
 .byt >Sprite3x11_Offset
 .byt >Sprite4x11_Offset
 .byt >Sprite5x11_Offset
 .byt >Sprite6x11_Offset
 .byt >Sprite7x11_Offset
 .byt >Sprite8x11_Offset
 .byt >Sprite9x11_Offset
 .byt >Sprite10x11_Offset
 .byt >Sprite11x11_Offset
;Sprite_GraphicUltimateByte
; .byt 10
; .byt 21
; .byt 32
; .byt 43
; .byt 54
; .byt 65

;We should only need to worry about 1 direction for these offset tables
;for example if we require a 2x11 we'll use Sprite2x11_Offset to the end
;but if we require a 2x7 then we can just take to 7th row (based on -
;gfxSprite_UltimateByte in level data)
Sprite1x11_Offset	;0-10
 .byt 0
 .byt 24
 .byt 48
 .byt 72
 .byt 96
 .byt 120
 .byt 144
 .byt 168
 .byt 192
 .byt 216
 .byt 240
Sprite2x11_Offset	;0-21
 .byt 0,1
 .byt 24,25
 .byt 48,49
 .byt 72,73
 .byt 96,97
 .byt 120,121
 .byt 144,145
 .byt 168,169
 .byt 192,193
 .byt 216,217
 .byt 240,241
Sprite3x11_Offset	;0-32
 .byt 0,1,2
 .byt 24,25,26
 .byt 48,49,50
 .byt 72,73,74
 .byt 96,97,98
 .byt 120,121,122
 .byt 144,145,146
 .byt 168,169,170
 .byt 192,193,194
 .byt 216,217,218
 .byt 240,241,242
Sprite4x11_Offset	;0-43
 .byt 0,1,2,3
 .byt 24,25,26,27
 .byt 48,49,50,51
 .byt 72,73,74,75
 .byt 96,97,98,99
 .byt 120,121,122,123
 .byt 144,145,146,147
 .byt 168,169,170,171
 .byt 192,193,194,195
 .byt 216,217,218,219
 .byt 240,241,242,243
Sprite5x11_Offset	;0-54
 .byt 0,1,2,3,4
 .byt 24,25,26,27,28
 .byt 48,49,50,51,52
 .byt 72,73,74,75,76
 .byt 96,97,98,99,100
 .byt 120,121,122,123,124
 .byt 144,145,146,147,148
 .byt 168,169,170,171,172
 .byt 192,193,194,195,196
 .byt 216,217,218,219,220
 .byt 240,241,242,243,244
Sprite6x11_Offset	;0-65
 .byt 0,1,2,3,4,5
 .byt 24,25,26,27,28,29
 .byt 48,49,50,51,52,53
 .byt 72,73,74,75,76,77
 .byt 96,97,98,99,100,101
 .byt 120,121,122,123,124,125
 .byt 144,145,146,147,148,149
 .byt 168,169,170,171,172,173
 .byt 192,193,194,195,196,197
 .byt 216,217,218,219,220,221
 .byt 240,241,242,243,244,245
Sprite7x11_Offset	;0-76
 .byt 0,1,2,3,4,5,6
 .byt 24,25,26,27,28,29,30
 .byt 48,49,50,51,52,53,54
 .byt 72,73,74,75,76,77,78
 .byt 96,97,98,99,100,101,102
 .byt 120,121,122,123,124,125,126
 .byt 144,145,146,147,148,149,150
 .byt 168,169,170,171,172,173,174
 .byt 192,193,194,195,196,197,198
 .byt 216,217,218,219,220,221,222
 .byt 240,241,242,243,244,245,246
Sprite8x11_Offset	;0-87
 .byt 0,1,2,3,4,5,6,7
 .byt 24,25,26,27,28,29,30,31
 .byt 48,49,50,51,52,53,54,55
 .byt 72,73,74,75,76,77,78,79
 .byt 96,97,98,99,100,101,102,103
 .byt 120,121,122,123,124,125,126,127
 .byt 144,145,146,147,148,149,150,151
 .byt 168,169,170,171,172,173,174,175
 .byt 192,193,194,195,196,197,198,199
 .byt 216,217,218,219,220,221,222,223
 .byt 240,241,242,243,244,245,246,247
Sprite9x11_Offset	;0-98
 .byt 0,1,2,3,4,5,6,7,8
 .byt 24,25,26,27,28,29,30,31,32
 .byt 48,49,50,51,52,53,54,55,56
 .byt 72,73,74,75,76,77,78,79,80
 .byt 96,97,98,99,100,101,102,103,104
 .byt 120,121,122,123,124,125,126,127,128
 .byt 144,145,146,147,148,149,150,151,152
 .byt 168,169,170,171,172,173,174,175,176
 .byt 192,193,194,195,196,197,198,199,200
 .byt 216,217,218,219,220,221,222,223,224
 .byt 240,241,242,243,244,245,246,247,248
Sprite10x11_Offset	;0-109
 .byt 0,1,2,3,4,5,6,7,8,9
 .byt 24,25,26,27,28,29,30,31,32,33
 .byt 48,49,50,51,52,53,54,55,56,57
 .byt 72,73,74,75,76,77,78,79,80,81
 .byt 96,97,98,99,100,101,102,103,104,105
 .byt 120,121,122,123,124,125,126,127,128,129
 .byt 144,145,146,147,148,149,150,151,152,153
 .byt 168,169,170,171,172,173,174,175,176,177
 .byt 192,193,194,195,196,197,198,199,200,201
 .byt 216,217,218,219,220,221,222,223,224,225
 .byt 240,241,242,243,244,245,246,247,248,249
Sprite11x11_Offset	;0-120
 .byt 0,1,2,3,4,5,6,7,8,9,10
 .byt 24,25,26,27,28,29,30,31,32,33,34
 .byt 48,49,50,51,52,53,54,55,56,57,58
 .byt 72,73,74,75,76,77,78,79,80,81,82
 .byt 96,97,98,99,100,101,102,103,104,105,106
 .byt 120,121,122,123,124,125,126,127,128,129,130
 .byt 144,145,146,147,148,149,150,151,152,153,154
 .byt 168,169,170,171,172,173,174,175,176,177,178
 .byt 192,193,194,195,196,197,198,199,200,201,202
 .byt 216,217,218,219,220,221,222,223,224,225,226
 .byt 240,241,242,243,244,245,246,247,248,249,250

ScreenOffset
 .byt 0,40,80,120,160,200,240
BluPrintPlayerXOffset
 .byt 0,30
Bitpos
 .byt 1,2,4,8,16,32,64,128


;LR1UD2
;CursorKeys + Right Ctrl + Right Shift
PlayerA_KeyboardColumn
 .byt $DF,$7F,$EF,$F7,$BF,$EF,0,0
PlayerA_KeyboardRow
 .byt 4,4,0,4,4,7,0,0

;Player keys are always 16 bytes apart so we can calc player in frontend

;ZXQA + Left Ctrl + Left Shift
PlayerB_KeyboardColumn
 .byt $DF,$BF,$EF,$BF,$DF,$EF,0,0
PlayerB_KeyboardRow
 .byt 2,0,2,1,6,4,0,0

ScriptCommandAddressLo
 .byt <ScrollSouth00
 .byt <MoveEast01
 .byt <MoveSouth02
 .byt <MoveWest03
 .byt <MoveNorth04
 .byt <MoveForward05
 .byt <MoveTowardsHero06
 .byt <MoveXY07
 .byt <SetDirectionFrame08
 .byt <SetExplosion09
 .byt <SetCounter10
 .byt <SetCondition11
 .byt <SetTarget12
 .byt <SetFrame13
 .byt <DecrementFrame14
 .byt <IncrementFrame15
 .byt <TurnClockwise16
 .byt <TurnAnticlockwise16
 .byt <TurnTowardHero18
 .byt <SpawnScript19
 .byt <SpawnScriptPlusX20
 .byt <Branch21
 .byt <DisplaySprite22
 .byt <Terminate23
 .byt <Wait24
 .byt <SpawnProjectile25
 .byt <SetHitIndex26
 .byt <CallSpecial27
 .byt <SetAttributes28
 .byt <SetHitpoints29
 .byt <SetBonuses30
 .byt <JumpToScript31
 .byt <SetWidth32

ScriptCommandAddressHi
 .byt >ScrollSouth00
 .byt >MoveEast01
 .byt >MoveSouth02
 .byt >MoveWest03
 .byt >MoveNorth04
 .byt >MoveForward05
 .byt >MoveTowardsHero06
 .byt >MoveXY07
 .byt >SetDirectionFrame08
 .byt >SetExplosion09
 .byt >SetCounter10
 .byt >SetCondition11
 .byt >SetTarget12
 .byt >SetFrame13
 .byt >DecrementFrame14
 .byt >IncrementFrame15
 .byt >TurnClockwise16
 .byt >TurnAnticlockwise16
 .byt >TurnTowardHero18
 .byt >SpawnScript19
 .byt >SpawnScriptPlusX20
 .byt >Branch21
 .byt >DisplaySprite22
 .byt >Terminate23
 .byt >Wait24
 .byt >SpawnProjectile25
 .byt >SetHitIndex26
 .byt >CallSpecial27
 .byt >SetAttributes28
 .byt >SetHitpoints29
 .byt >SetBonuses30
 .byt >JumpToScript31
 .byt >SetWidth32

ScriptCommandStep	;one less because routine has carry set
 .byt 1	;000 ScrollSouth00      	Step
 .byt 0	;001 MoveEast01         	-
 .byt 1	;002 MoveSouth02        	Step
 .byt 0	;003 MoveWest03         	-
 .byt 1	;004 MoveNorth04        	Step
 .byt 0	;005 MoveForward05      	-
 .byt 0	;006 MoveTowardsHero06  	-
 .byt 2	;007 MoveXY07           	X,Y
 .byt 2	;008 SetDirectionFrame08	Direction,Frame
 .byt 1	;009 SetExplosion09     	Script
 .byt 1	;010 SetCounter10       	Value
 .byt 1	;011 SetCondition11     	ConditionID
 .byt 1	;012 SetTarget12        	TargetID
 .byt 1	;013 SetFrame13         	FrameID
 .byt 0	;014 DecrementFrame14   	-
 .byt 0	;015 IncrementFrame15   	-
 .byt 0	;016 TurnClockwise16    	-
 .byt 0	;017 TurnAnticlockwise16	-
 .byt 0	;018 TurnTowardHero18   	-
 .byt 2	;019 SpawnScript19      	Script,Group Flag
 .byt 3	;020 SpawnScriptPlusX20    	X,Script,Group Flag
 .byt 1	;021 Branch21           	Index
 .byt 0	;022 DisplaySprite22    	-
 .byt 0	;023 Terminate23        	-
 .byt 1	;024 Wait24             	Period
 .byt 2	;025 Spawn Projectile	Type(0-9)
 .byt 1	;026 Set Hit Index		Hit Index
 .byt 2	;027 Call Special Code	Low Address, High Address
 .byt 1	;028 SetAttributes		Attributes
 .byt 2	;029 SetHitpoints		Hitpoints,Health
 .byt 1	;030 SetBonuses		Bonuses
 .byt 1	;031 JumpToScript		Script
 .byt 1	;032 SetWidth		Width

Sprite_XLOC
 .dsb 6,0
 .dsb 6,1
 .dsb 6,2
 .dsb 6,3
 .dsb 6,4
 .dsb 6,5
 .dsb 6,6
 .dsb 6,7
 .dsb 6,8
 .dsb 6,9
 .dsb 6,10
 .dsb 6,11
 .dsb 6,12
 .dsb 6,13
 .dsb 6,14
 .dsb 6,15
 .dsb 6,16
 .dsb 6,17
 .dsb 6,18
 .dsb 6,19
 .dsb 6,20
 .dsb 6,21
 .dsb 6,22
 .dsb 6,23
 
 
ShiftedXPositionInByte
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5
 .byt 0,1,2,3,4,5

BGFlagTable
 .byt 128,0

;Simply holds the value of each health bar byte (6 pixels) from 0 to 23
HealthByte0
 .byt $FF,$DF,$CF,$C7,$C3,$C1,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
HealthByte1
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$CF,$C7,$C3,$C1,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0,$C0
HealthByte2
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$CF,$C7,$C3,$C1,$C0,$C0,$C0,$C0,$C0,$C0,$C0
HealthByte3
 .byt $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$DF,$CF,$C7,$C3,$C1,$C0
gfxPanelCraft
 .byt $45,$68
 .byt $54,$4A
 .byt $EA,$D5
 .byt $C2,$D0
 .byt $CA,$D4
 .byt $C9,$E4
 .byt $62,$51
PanelCraftScreenOffset
 .byt 0,1
 .byt 40,41
 .byt 80,81
 .byt 120,121
 .byt 160,161
 .byt 200,201
 .byt 240,241
PlayerAPanelCraftLocsLo
 .byt <$B4F1
 .byt <$B4F4
 .byt <$B4F7
PlayerAPanelCraftLocsHi
 .byt >$B4F1
 .byt >$B4F4
 .byt >$B4F7
PlayerBPanelCraftLocsLo
 .byt <$B50F
 .byt <$B512
 .byt <$B515
PlayerBPanelCraftLocsHi
 .byt >$B50F
 .byt >$B512
 .byt >$B515
PlayerScorePanelLocLo
 .byt <$B06C
 .byt <$B08A
PlayerScorePanelLocHi
 .byt >$B06C
 .byt >$B08A
;This is for Digits 0,3,6
DigitScreenGraphicBitmap234_0
 .byt %01011100,%01001000,%01011100,%01011100,%01010100,%01011100,%01011100,%01011100,%01011100,%01011100
DigitScreenGraphicBitmap234_1
 .byt %01010100,%01001000,%01000100,%01000100,%01010100,%01010000,%01010000,%01000100,%01010100,%01011100
DigitScreenGraphicBitmap234_2
 .byt %01010100,%01001000,%01011100,%01011100,%01011100,%01011100,%01011100,%01000100,%01011100,%01011100
DigitScreenGraphicBitmap234_3
 .byt %01010100,%01001000,%01010000,%01000100,%01000100,%01000100,%01010100,%01000100,%01010100,%01000100
DigitScreenGraphicBitmap234_4
 .byt %01011100,%01001000,%01011100,%01011100,%01000100,%01011100,%01011100,%01000100,%01011100,%01000100
DigitScreenGraphicBitmap012_0
 .byt %01000111,%01000010,%01000111,%01000111,%01000101,%01000111,%01000111,%01000111,%01000111,%01000111
DigitScreenGraphicBitmap012_1
 .byt %01000101,%01000010,%01000001,%01000001,%01000101,%01000100,%01000100,%01000001,%01000101,%01000101
DigitScreenGraphicBitmap012_2
 .byt %01000101,%01000010,%01000111,%01000111,%01000111,%01000111,%01000111,%01000001,%01000111,%01000111
DigitScreenGraphicBitmap012_3
 .byt %01000101,%01000010,%01000100,%01000001,%01000001,%01000001,%01000101,%01000001,%01000101,%01000001
DigitScreenGraphicBitmap012_4
 .byt %01000111,%01000010,%01000111,%01000111,%01000001,%01000111,%01000111,%01000001,%01000111,%01000001
DigitScreenGraphicBitmap45_0
 .byt %01110000,%01100000,%01110000,%01110000,%01010000,%01110000,%01110000,%01110000,%01110000,%01110000
DigitScreenGraphicBitmap45_1
 .byt %01010000,%01100000,%01010000,%01010000,%01010000,%01000000,%01000000,%01010000,%01010000,%01010000
DigitScreenGraphicBitmap45_2
 .byt %01010000,%01100000,%01110000,%01110000,%01110000,%01110000,%01110000,%01010000,%01110000,%01110000
DigitScreenGraphicBitmap45_3
 .byt %01010000,%01100000,%01000000,%01010000,%01010000,%01010000,%01010000,%01010000,%01010000,%01010000
DigitScreenGraphicBitmap45_4
 .byt %01110000,%01100000,%01110000,%01110000,%01010000,%01110000,%01110000,%01010000,%01110000,%01010000
DigitScreenGraphicBitmap0_0
 .byt %01000001,%01000000,%01000001,%01000001,%01000001,%01000001,%01000001,%01000001,%01000001,%01000001
DigitScreenGraphicBitmap0_1
 .byt %01000001,%01000000,%01000000,%01000000,%01000001,%01000001,%01000001,%01000000,%01000001,%01000001
DigitScreenGraphicBitmap0_2
 .byt %01000001,%01000000,%01000001,%01000001,%01000000,%01000001,%01000001,%01000000,%01000001,%01000000
DigitScreenGraphicBitmap0_3
 .byt %01000001,%01000000,%01000001,%01000000,%01000000,%01000000,%01000001,%01000000,%01000001,%01000000
DigitScreenGraphicBitmap0_4
 .byt %01000001,%01000000,%01000001,%01000001,%01000000,%01000001,%01000001,%01000000,%01000001,%01000000
PlayerScoreDigits01
 .byt 0,0
PlayerScoreDigits23
 .byt 0,0
PlayerScoreDigits45
 .byt 0,0
PlayerScoreDigits67
 .byt 0,0
PlayerScore2Display01
 .byt 0
PlayerScore2Display23
 .byt 0
PlayerScore2Display45
 .byt 0
PlayerScore2Display67
 .byt 0

