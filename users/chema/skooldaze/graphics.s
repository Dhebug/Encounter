
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; -----------------------------------
;;            Skool Daze
;;         The Oric Version
;; -----------------------------------
;;			(c) Chema 2011
;;         enguita@gmail.com
;; -----------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Graphics
;; --------------------

#include "script.h"	; For destination D_ defines


_lines1
	.byt 0,4,0,0,0,0,$ff,$78,$10,0,0,1,0,$e
_lines2
	.byt 0,4,0,0,0,0,$ff,$78,$10,0,0,3,0,$e


; tile graphics for skool data
free_before_udgs
.dsb 256-(*&255)
udg_skool 

; Tile data for Skool (cols 0-32)
; Tile skool 1
.byt $7f, $7f, $6a, $7f, $6a, $7f, $6a, $7f
; Tile skool 2
.byt $7f, $7f, $7f, $7f, $6a, $7f, $6a, $7f
; Tile skool 3
.byt $7f, $7f, $7f, $7f, $7f, $7f, $6a, $7f
; Tile skool 4
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 5
.byt $7f, $7f, $7e, $7f, $7e, $7f, $7e, $7f
; Tile skool 6
.byt $7f, $7f, $6f, $55, $6a, $55, $6a, $55
; Tile skool 7
.byt $7f, $7f, $7f, $7f, $7f, $57, $6a, $55
; Tile skool 8
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $57
; Tile skool 9
.byt $7f, $7f, $7a, $7d, $7a, $7d, $7a, $7d
; Tile skool 10
.byt $7f, $7f, $7f, $5f, $6b, $55, $6a, $55
; Tile skool 11
.byt $7f, $7f, $7f, $7f, $7f, $7f, $6f, $57
; Tile skool 12
.byt $6a, $7f, $6a, $7f, $6a, $7f, $6a, $7f
; Tile skool 13
.byt $7e, $7f, $7e, $7f, $7f, $7f, $7f, $7f
; Tile skool 14
.byt $6a, $55, $6a, $75, $7e, $7f, $7f, $7f
; Tile skool 15
.byt $6a, $55, $6a, $55, $6a, $75, $7a, $75
; Tile skool 16
.byt $6a, $55, $6a, $55, $6a, $55, $6a, $55
; Tile skool 17
.byt $7f, $57, $6b, $55, $6a, $55, $6a, $55
; Tile skool 18
.byt $7f, $7f, $7f, $7f, $7f, $5f, $6f, $55
; Tile skool 19
.byt $7a, $7d, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 20
.byt $6a, $55, $6a, $7d, $7f, $7f, $7f, $7f
; Tile skool 21
.byt $7f, $5f, $6b, $55, $6a, $55, $6a, $55
; Tile skool 22
.byt $7f, $7f, $7f, $7f, $6f, $57, $6a, $55
; Tile skool 23
.byt $6a, $7f, $6a, $7f, $6a, $7f, $6f, $61
; Tile skool 24
.byt $6a, $7f, $6a, $7f, $6a, $7f, $7e, $5f
; Tile skool 25

;Escudo
.byt $40, $7f^$bf, $6f^$bf, $67^$bf, $63^$bf, $61^$bf, $52^$bf, $4c

; Tile skool 26
.byt $6a, $7f, $55, $7f, $6a, $7f, $55, $7f
; Tile skool 27

;Escudo
.byt $40, $7f, $4f^$bf, $67, $73^$bf, $79, $5e^$bf, $4c

; Tile skool 28
.byt $7a, $75, $7a, $75, $7a, $75, $7a, $75
; Tile skool 29
.byt $7f, $6a, $7f, $55, $7f, $6a, $7f, $55

; Ventana
; Tile skool 30
.byt $7f, $60^$bf, $60, $60^$bf, $60, $60^$bf, $60, $7f
; Tile skool 31
.byt $7f, $40^$bf, $40, $40^$bf, $40, $40^$bf, $40, $7f
; Tile skool 32
.byt $7f, $41^$bf, $41, $41^$bf, $41, $41^$bf, $41, $7f


; Ventanal
; Tile skool 33
.byt $61, $61^$bf, $61, $61^$bf, $61, $79^$bf, $6f, $61^$bf
; Tile skool 34
.byt $43, $43^$bf, $43, $43^$bf, $43, $43^$bf, $63, $5f^$bf
; Tile skool 35
.byt $7f, $47, $40, $40^$bf, $40, $40^$bf, $40, $40^$bf
; Tile skool 36
.byt $6a, $7f, $5e, $4f^$bf, $4e, $4f^$bf, $4e, $4f^$bf


;Libros
; Tile skool 37
.byt $7f, $40, $7f, $7f, $6f, $77, $7b, $7d
; Tile skool 38
.byt $7f, $40, $7f, $75, $55^$bf, $55, $55^$bf, $55
; Tile skool 39
.byt $7f, $40, $7f, $6b^$bf, $6a, $6a^$bf, $6a, $6a^$bf
; Tile skool 40
.byt $7f, $40, $7f, $7f, $6b, $6b^$bf, $6b, $6b^$bf
; Tile skool 41
.byt $7f, $40, $7f, $7e, $4a^$bf, $4a, $4a^$bf, $4a
; Tile skool 42
.byt $7f, $60, $6f, $6f, $6f, $69, $6e, $69

; Libros tumbados
; Tile skool 43
.byt $7f, $40, $7f, $7f, $7f, $78, $4f, $7c
; Tile skool 44
.byt $7f, $40, $7f, $7f, $7f, $40, $7f, $41
; Tile skool 45
.byt $7f, $40, $7f, $7f, $7f, $4b, $57, $6f

; Tile skool 46
.byt $7f, $40, $7f, $77, $55^$bf, $55, $55^$bf, $55
; Tile skool 47
.byt $7f, $40, $7f, $7f, $7f, $57^$bf, $57, $56^$bf
; Tile skool 48
.byt $7f, $40, $7f, $7f, $7f, $6a, $54^$bf, $6e
; Tile skool 49
.byt $7f, $40, $7f, $6d, $45, $4d, $5d, $7d

; Ventanal
; Tile skool 50
.byt $61, $61^$bf, $61, $61^$bf, $61, $7d^$bf, $6b, $7f
; Tile skool 51
.byt $43, $43^$bf, $43, $43^$bf, $43, $43^$bf, $7f, $7f
; Tile skool 52
.byt $40, $40^$bf, $40, $40^$bf, $40, $40^$bf, $7e, $7f
; Tile skool 53
.byt $4e, $4f^$bf, $4e, $4f^$bf, $4e, $4f^$bf, $4e, $7f

; Tile skool 54
.byt $7f, $40, $7f, $7f, $6a^$bf, $6a, $6a^$bf, $6a
; Tile skool 55
.byt $7f, $40, $7f, $6f^$bf, $6a, $6a^$bf, $6a, $6a^$bf
; Tile skool 56
.byt $7f, $40, $7f, $7a^$bf, $6a, $6a^$bf, $6a, $6a^$bf
; Tile skool 57
.byt $7f, $40, $7f, $7b, $7b, $7b, $6b^$bf, $6b
; Tile skool 58
.byt $6f, $60, $6f, $6f, $69, $69, $69, $69
; Tile skool 59
.byt $7f, $40, $7f, $55^$bf, $55, $55^$bf, $55, $55^$bf
; Tile skool 60
.byt $7f, $40, $7f, $57, $55^$bf, $55, $55^$bf, $55
; Tile skool 61
.byt $7f, $40, $7f, $7f, $49, $64^$bf, $72, $7b^$bf
; Tile skool 62
.byt $7f, $40, $7f, $7f, $7c, $7c, $5c, $4c
; Tile skool 63
.byt $6a, $7f, $7f, $67, $62, $61, $62, $63
; Tile skool 64
.byt $6a, $7f, $6a, $7f, $6b, $57, $6b, $55
; Tile skool 65
.byt $6a, $7f, $6a, $7f, $6b, $7e, $6a, $7e
; Tile skool 66
.byt $40, $7f, $6a, $7f, $7f, $40, $40, $40
; Tile skool 67
.byt $40, $7f, $55, $7f, $7f, $45, $46, $45
; Tile skool 68
.byt $40, $7f, $55, $7f, $6a, $7f, $6b, $55
; Tile skool 69
.byt $40, $7f, $55, $7f, $6a, $7f, $55, $7f
; Tile skool 70
.byt $6f, $60, $6f, $6f, $6e, $6e, $6e, $6e
; Tile skool 71
.byt $7f, $40, $7f, $7f, $67, $73^$bf, $79, $7d^$bf
; Tile skool 72
.byt $7f, $40, $7f, $5f, $55, $55, $55, $55
; Tile skool 73
.byt $62, $67, $78, $78, $77, $70, $70, $78
; Tile skool 74
.byt $6a, $7f, $43, $45, $7f, $41, $41, $41
; Tile skool 75
.byt $6a, $7f, $60, $55, $7f, $5d, $6a, $5d
; Tile skool 76
.byt $6a, $7e, $4e, $56, $7e, $76, $6e, $76
; Tile skool 77
.byt $46, $45, $46, $45, $46, $45, $46, $45
; Tile skool 78
.byt $6b, $55, $6b, $55, $6b, $55, $6b, $55
; Tile skool 79
.byt $6f, $60, $60, $60, $60, $60, $60, $60
; Tile skool 80
.byt $7f, $40, $40, $40, $40, $40, $40, $40
; Tile skool 81
.byt $7f, $7f, $7f, $75, $7f, $75, $7f, $75
; Tile skool 82
.byt $7f, $7f, $7f, $55, $7f, $55, $7f, $55
; Tile skool 83
.byt $7f, $7f, $7f, $5f, $7f, $55, $7f, $55
; Tile skool 84
.byt $7f, $7f, $7f, $7f, $7f, $55, $7f, $55
; Tile skool 85
.byt $7f, $7f, $7f, $7f, $7f, $57, $7f, $55
; Tile skool 86
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $55
; Tile skool 87
.byt $7f, $7f, $7f, $7f, $7c, $57, $6a, $55
; Tile skool 88
.byt $7f, $7f, $7f, $7f, $40, $78, $6f, $55
; Tile skool 89
.byt $7f, $7f, $7f, $7f, $40, $40, $70, $5f
; Tile skool 90
.byt $7f, $7f, $7f, $7f, $40, $40, $40, $40
; Tile skool 91
.byt $7f, $7f, $7f, $7f, $43, $40, $40, $40
; Tile skool 92
.byt $7f, $7f, $7f, $7f, $7f, $41, $40, $40
; Tile skool 93
.byt $7f, $7f, $7f, $7f, $7f, $7f, $43, $40
; Tile skool 94
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $47
; Tile skool 95
.byt $6f, $75, $6a, $75, $6a, $75, $6a, $75
; Tile skool 96
.byt $7f, $7f, $7f, $7f, $6f, $55, $6a, $55
; Tile skool 97
.byt $7f, $7f, $7f, $7f, $7f, $7f, $6f, $55
; Tile skool 98
.byt $7f, $75, $7f, $75, $7f, $75, $7f, $75
; Tile skool 99
.byt $7f, $55, $7f, $55, $7f, $55, $7f, $5f
; Tile skool 100
.byt $7f, $55, $7f, $55, $7f, $55, $7f, $7f
; Tile skool 101
.byt $7f, $55, $7f, $55, $7f, $55, $7f, $55
; Tile skool 102
.byt $7e, $6b, $7e, $57, $7e, $6b, $7e, $57
; Tile skool 103
.byt $6f, $54, $6c, $54, $6c, $54, $6c, $57
; Tile skool 104
.byt $7f, $45, $46, $45, $46, $45, $46, $7d
; Tile skool 105
.byt $60, $5c, $6c, $54, $6c, $54, $6c, $7c
; Tile skool 106
.byt $6a, $75, $6a, $75, $6a, $7d, $47, $40
; Tile skool 107
.byt $6a, $55, $6a, $55, $6a, $55, $7a, $47
; Tile skool 108
.byt $6a, $55, $6a, $55, $6a, $55, $6a, $75
; Tile skool 109
.byt $70, $50, $70, $50, $70, $50, $70, $5f
; Tile skool 110
.byt $40, $40, $40, $40, $40, $40, $40, $7f
; Tile skool 111
.byt $41, $41, $41, $41, $41, $41, $41, $7f
; Tile skool 112
.byt $7f, $68, $79, $52, $79, $68, $78, $57
; Tile skool 113
.byt $7f, $4e, $4f, $6d, $4f, $4e, $4f, $7d
; Tile skool 114
.byt $7f, $5c, $6c, $5c, $6c, $5c, $6c, $5f
; Tile skool 115
.byt $70, $58, $68, $58, $68, $58, $68, $78
; Tile skool 116
.byt $7f, $50, $70, $50, $70, $50, $70, $50
; Tile skool 117
.byt $7f, $41, $41, $41, $41, $41, $41, $41
; Tile skool 118
.byt $68, $58, $68, $58, $68, $58, $68, $58
; Tile skool 119
.byt $47, $44, $44, $44, $44, $44, $44, $47
; Tile skool 120
.byt $70, $58, $68, $58, $68, $58, $6f, $40
; Tile skool 121
.byt $40, $40, $40, $40, $40, $40, $7c, $4c
; Tile skool 122
.byt $7f, $75, $7f, $75, $7e, $75, $7f, $76
; Tile skool 123
.byt $7f, $55, $7f, $50, $4f, $75, $6a, $75
; Tile skool 124
.byt $7f, $55, $7f, $55, $4f, $75, $6f, $65
; Tile skool 125
.byt $7f, $71, $62, $65, $6a, $65, $6a, $65
; Tile skool 126
.byt $7f, $75, $7f, $77, $7c, $74, $7c, $74
; Tile skool 127
.byt $7f, $55, $7f, $7f, $6e, $57, $6a, $57
; Tile skool 128
.byt $7f, $5f, $78, $51, $72, $51, $72, $51
; Tile skool 129
.byt $7f, $75, $5f, $5d, $6f, $5d, $6f, $5d
; Tile skool 130
.byt $7f, $6a, $7c, $54, $7c, $6c, $7c, $54
; Tile skool 131
.byt $7e, $41, $41, $41, $41, $41, $41, $41
; Tile skool 132
.byt $7f, $6a, $57, $6d, $57, $6a, $57, $6d
; Tile skool 133
.byt $7c, $54, $6c, $54, $6c, $54, $6f, $40
; Tile skool 134
.byt $40, $40, $40, $40, $40, $40, $7e, $46
; Tile skool 135
.byt $7e, $74, $7e, $74, $7e, $75, $7f, $75
; Tile skool 136
.byt $6a, $75, $6a, $55, $5a, $55, $5a, $5d
; Tile skool 137
.byt $6f, $55, $7b, $55, $6b, $5d, $6f, $50
; Tile skool 138
.byt $6a, $65, $60, $60, $60, $60, $7f, $40
; Tile skool 139
.byt $6c, $7f, $40, $7f, $41, $41, $7d, $7d
; Tile skool 140
.byt $6b, $7f, $40, $7d, $7d, $55, $6d, $55
; Tile skool 141
.byt $72, $79, $7f, $70, $48, $4d, $4a, $4d
; Tile skool 142
.byt $6a, $5f, $78, $4f, $4b, $5f, $6b, $5f
; Tile skool 143
.byt $7f, $78, $45, $5d, $7d, $6d, $7d, $55
; Tile skool 144
.byt $7c, $7f, $40, $40, $7f, $6a, $55, $6a
; Tile skool 145
.byt $40, $7f, $40, $40, $7f, $6a, $55, $6a
; Tile skool 146
.byt $41, $7f, $43, $43, $7f, $6b, $51, $6b
; Tile skool 147
.byt $57, $6a, $57, $6d, $57, $6a, $5f, $70
; Tile skool 148
.byt $41, $41, $41, $42, $42, $42, $7e, $40
; Tile skool 149
.byt $7a, $56, $6a, $56, $6a, $56, $6a, $7e
; Tile skool 150
.byt $7e, $75, $7f, $75, $7f, $75, $7f, $75
; Tile skool 151
.byt $6a, $67, $60, $70, $70, $57, $77, $5f
; Tile skool 152
.byt $40, $7f, $43, $43, $6e, $7e, $7f, $7f
; Tile skool 153
.byt $40, $40, $40, $57, $7f, $7f, $5f, $7f
; Tile skool 154
.byt $59, $55, $59, $5d, $5d, $6f, $7f, $7f
; Tile skool 155
.byt $6d, $55, $7d, $7d, $7f, $7f, $7f, $7f
; Tile skool 156
.byt $6a, $7d, $7b, $7f, $7f, $7f, $7f, $7f
; Tile skool 157
.byt $67, $57, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 158
.byt $7a, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 159
.byt $7b, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 160
.byt $6f, $60, $6d, $5b, $5b, $5f, $7f, $7f
; Tile skool 161
.byt $7f, $40, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 162
.byt $7a, $75, $7a, $75, $7b, $7f, $7f, $7f
; Tile skool 163
.byt $6a, $55, $6a, $57, $7f, $7f, $7f, $7f
; Tile skool 164
.byt $6a, $55, $6f, $7f, $7f, $7f, $7f, $7f
; Tile skool 165
.byt $6a, $5f, $7f, $7e, $75, $7f, $7f, $7f
; Tile skool 166
.byt $7f, $7f, $75, $6a, $55, $7f, $7f, $7f
; Tile skool 167
.byt $7e, $78, $58, $68, $58, $7f, $7f, $7f
; Tile skool 168
.byt $40, $40, $40, $40, $40, $7f, $7f, $7f
; Tile skool 169
.byt $40, $40, $43, $4f, $7f, $7f, $7f, $7f
; Tile skool 170
.byt $4f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 171
.byt $7a, $75, $7a, $77, $7f, $7f, $7f, $7f
; Tile skool 172
.byt $6b, $57, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 173
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile skool 174
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile skool 175
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile skool 176
.byt $6a, $55, $6a, $55, $6a, $55, $6f, $78
; Tile skool 177
.byt $6a, $55, $6a, $55, $6b, $7c, $43, $7d
; Tile skool 178
.byt $68, $58, $68, $58, $7f, $4f, $7a, $55
; Tile skool 179
.byt $40, $40, $40, $40, $78, $58, $68, $58
; Tile skool 180
.byt $41, $41, $41, $41, $41, $41, $41, $43
; Tile skool 181
.byt $60, $60, $60, $60, $60, $60, $60, $7f
; Tile skool 182
.byt $40, $40, $40, $40, $40, $40, $5f, $60
; Tile skool 183
.byt $41, $41, $41, $41, $41, $47, $79, $41
; Tile skool 184
.byt $60, $60, $60, $60, $67, $78, $60, $60
; Tile skool 185
.byt $43, $43, $43, $43, $7f, $43, $43, $43
; Tile skool 186
.byt $7a, $75, $7a, $75, $7a, $75, $7a, $7c
; Tile skool 187
.byt $6b, $57, $6e, $58, $70, $40, $40, $40
; Tile skool 188
.byt $60, $7f, $60, $60, $60, $60, $60, $60
; Tile skool 189
.byt $5f, $60, $40, $40, $40, $40, $40, $40
; Tile skool 190
.byt $7d, $41, $41, $41, $41, $41, $41, $41
; Tile skool 191
.byt $41, $41, $41, $41, $41, $41, $41, $47
; Tile skool 192
.byt $60, $60, $60, $60, $60, $60, $6f, $70
; Tile skool 193
.byt $43, $43, $43, $43, $43, $5f, $63, $43
; Tile skool 194
.byt $60, $60, $60, $60, $60, $7f, $60, $60
; Tile skool 195
.byt $40, $40, $40, $40, $7f, $40, $40, $40
; Tile skool 196
.byt $41, $41, $41, $7f, $41, $41, $41, $41
; Tile skool 197
.byt $60, $61, $7e, $60, $60, $60, $60, $60
; Tile skool 198
.byt $43, $7c, $40, $40, $40, $40, $40, $40
; Tile skool 199
.byt $79, $41, $41, $41, $41, $41, $41, $41
; Tile skool 200
.byt $40, $40, $40, $40, $40, $40, $47, $7f
; Tile skool 201
.byt $41, $41, $41, $41, $47, $7f, $7f, $7f
; Tile skool 202
.byt $60, $60, $67, $7f, $7f, $7f, $7f, $7f
; Tile skool 203
.byt $47, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 204
.byt $7a, $55, $6a, $55, $6a, $55, $6b, $5f
; Tile skool 205
.byt $6a, $55, $6a, $55, $6a, $5f, $7f, $7f
; Tile skool 206
.byt $6f, $57, $6f, $57, $7f, $7f, $7f, $7f
; Tile skool 207
.byt $60, $60, $60, $60, $60, $60, $67, $7f
; Tile skool 208
.byt $40, $40, $40, $40, $47, $7f, $7f, $7f
; Tile skool 209
.byt $41, $41, $4f, $7f, $7f, $7f, $7f, $7f
; Tile skool 210
.byt $67, $7f, $7f, $7f, $7f, $7f, $7f, $7f

end_udg_skool

tab_sfx_hi
	.byt >_shhit,>_knock,>_twang,>_step,>_hit,>_lines1,>_lines2,>_safeletter
tab_sfx_lo
	.byt <_shhit,<_knock,<_twang,<_step,<_hit,<_lines1,<_lines2,<_safeletter

; Little ping
_shhit
	.byt 0,1,0,3,0,0,0,$78,$10,$10,0,0,5,0
; POOONG
_twang
	.byt 0,1+3,0,2+3,0,1+3,0,$78,$10,$10,$10,0,$a-3,0
_step
	.byt 0,0,0,0,0,0,$ff,$7e,$10,0,0,$26-$20,0,9
_hit
	.byt 0,0,0,0,0,0,$ff,$77,$10,0,0,$d0,0,9
_knock
	.byt 0,1,0,0,0,0,0,$76,$10,0,0,1,2,9

; little ping
;_pic
;	.byt 5,0,10,0,5,0,0,$78,$10,$10,$10,0,$a,0

_safeletter
	.byt 0,4,0,0,0,0,$ff,$78,10,0,0,2,0,$e

; Probabilities (out of 256) that a teacher
; punishes Einistein for telling tales
tab_teachertales
	.byt 48,16,0,16


free_udg_skool1
.dsb 256-(*&255)

udg_skool2
; Tile data for Skool (cols 33-74)
; Tile skool 1
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 2
.byt $7f, $7f, $7d, $7f, $7d, $7f, $7d, $7f
; Tile skool 3
.byt $7d, $7f, $7d, $7f, $7d, $7f, $7d, $7f
; Tile skool 4
.byt $5f, $7f, $5f, $7f, $57, $7f, $57, $7f
; Tile skool 5

; Ventanas
.byt $7f, $40^$bf, $40, $40^$bf, $40, $40^$bf, $40, $7f
; Tile skool 6
.byt $7f, $41^$bf, $41, $41^$bf, $41, $41^$bf, $41, $7f
; Tile skool 7
.byt $7f, $6a, $7f, $55, $7f, $6a, $7f, $55
; Tile skool 8
.byt $7f, $60^$bf, $60, $60^$bf, $60, $60^$bf, $60, $7f

; Ventana con cacho de pared
; Tile skool 9
.byt $7f, $43^$bf, $41, $40^$bf, $40, $40^$bf, $40, $7f


; Tile skool 10
.byt $55, $7f, $75, $7f, $75, $7f, $75, $7f


; Escudos
; Tile skool 11
.byt $40, $7f^$bf, $6f, $67^$bf, $63, $61^$bf, $52, $4c
; Tile skool 12
.byt $40, $7f, $79^$bf, $79^$bf, $67^$bf, $67^$bf, $56^$bf, $4c


;Libros
; Tile skool 13
.byt $7f, $40, $7f, $7f, $67^$bf, $73, $79^$bf, $7d
; Tile skool 14
.byt $7f, $40, $7f, $7a^$bf, $6a, $6a^$bf, $6a, $6a^$bf
; Tile skool 15
.byt $7f, $40, $7f, $7a, $7a^$bf, $7a, $6a^$bf, $6a
; Tile skool 16
.byt $7f, $40, $7f, $7f, $6a, $6a^$bf, $6a, $6a^$bf
; Tile skool 17
.byt $7f, $40, $7f, $7b, $6a^$bf, $6a, $6a^$bf, $6a
; Tile skool 18
.byt $7f, $40, $7f, $6b, $6a^$bf, $6a, $6a^$bf, $6a
; Tile skool 19
.byt $7f, $40, $7f, $75^$bf, $55, $55^$bf, $55, $55^$bf
; Tile skool 20
.byt $7f, $40, $7f, $5f, $55^$bf, $55, $55^$bf, $55
; Tile skool 21
.byt $7f, $40, $7f, $5d^$bf, $55, $55^$bf, $55, $55^$bf
; Tile skool 22
.byt $7f, $4e, $7b, $5d, $4b, $6d, $6b, $7d
; Tile skool 23
.byt $7f, $60, $6f, $6b, $6a, $6a, $6a, $6a
; Tile skool 24
.byt $7f, $40, $7f, $7f, $64^$bf, $62, $69^$bf, $6c
; Tile skool 25
.byt $7f, $40, $7f, $7f, $41^$bf, $42, $45^$bf, $6a
; Tile skool 26
.byt $7f, $40, $7f, $6e^$bf, $55, $6b^$bf, $57, $6f^$bf
; Tile skool 27
.byt $7f, $40, $7f, $6f, $6a^$bf, $6a, $6a^$bf, $6a
; Tile skool 28
.byt $7f, $40, $7f, $7b, $7b, $7b, $6b, $6b^$bf
; Tile skool 29
.byt $7f, $40, $7f, $7e, $4a^$bf, $4a, $4a, $4a


; Tile skool 30
.byt $75, $7f, $75, $7f, $75, $7f, $75, $7f

; Mas libros
; Tile skool 31
.byt $7f, $40, $7f, $6a^$bf, $6a, $6a^$bf, $6a, $6a^$bf
; Tile skool 32
.byt $7f, $40, $7f, $7f, $65^$bf, $65, $65^$bf, $65
; Tile skool 33
.byt $7f, $40, $7f, $4e^$bf, $4c, $4e^$bf, $4f, $4f^$bf
; Tile skool 34
.byt $7f, $40, $7f, $7f, $5f, $48^$bf, $44, $68^$bf
; Tile skool 35
.byt $7f, $40, $7f, $7f, $7f, $40, $40, $40
; Tile skool 36
.byt $7b, $4d, $7b, $7d, $7b, $4d, $4b, $4d
; Tile skool 37
.byt $6f, $60, $6f, $6d, $6d, $6d, $6d, $6d
; Tile skool 38
.byt $7f, $40, $7f, $5a, $5a^$bf, $5a, $5a^$bf, $5a
; Tile skool 39
.byt $7f, $40, $7f, $7b^$bf, $79, $7a^$bf, $69, $6a
; Tile skool 40
.byt $7f, $40, $7f, $7b, $5a^$bf, $5a, $5a^$bf, $5a
; Tile skool 41
.byt $7f, $40, $7f, $7f, $6b, $6b^$bf, $6b, $6b^$bf
; Tile skool 42
.byt $7f, $40, $7f, $77^$bf, $55, $55^$bf, $55, $55^$bf
; Tile skool 43
.byt $7f, $40, $7f, $57, $55^$bf, $55^$bf, $55, $55^$bf
; Tile skool 44
.byt $7f, $40, $7f, $7e, $6a^$bf, $6a, $6a^$bf, $6a
; Tile skool 45
.byt $7f, $40, $7f, $7f, $64, $72^$bf, $79, $7c^$bf
; Tile skool 46
.byt $7f, $40, $7f, $7f, $6e^$bf, $6a, $6a^$bf, $6a
; Tile skool 47
.byt $7b, $4d, $7b, $7d, $7b, $7d, $7b, $7d
; Tile skool 48
.byt $6f, $60, $6f, $6a, $6a, $6a, $6a, $6a
; Tile skool 49
.byt $7f, $40, $7f, $6e^$bf, $6e, $6e^$bf, $6a, $6a^$bf
; Tile skool 50
.byt $7f, $40, $7f, $7b, $7a^$bf, $7b, $6b^$bf, $6b
; Tile skool 51
.byt $7f, $40, $7f, $7f, $5d, $4d^$bf, $65, $75^$bf
; Tile skool 52
.byt $60, $7f, $5f, $5f, $5f, $5f, $5c, $5c
; Tile skool 53
.byt $40, $7c, $7c, $7c, $78, $60, $40, $40
; Tile skool 54
.byt $40, $40, $41, $41, $41, $41, $41, $4f
; Tile skool 55
.byt $40, $7f, $5f, $5f, $5f, $5f, $5c, $7c
; Tile skool 56
.byt $7f, $40, $40, $40, $40, $40, $40, $40
; Tile skool 57
.byt $7b, $4d, $4b, $4d, $4b, $4d, $4b, $4d
; Tile skool 58
.byt $6f, $60, $60, $60, $60, $60, $60, $60
; Tile skool 59
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile skool 60
.byt $5c, $5c, $5c, $5c, $5c, $5c, $5c, $5b
; Tile skool 61
.byt $40, $40, $40, $40, $40, $40, $40, $7f
; Tile skool 62
.byt $5f, $42, $42, $42, $42, $42, $42, $7f
; Tile skool 63
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $5b
; Tile skool 64
.byt $7f, $77, $7b, $75, $7a, $75, $7a, $75
; Tile skool 65
.byt $7f, $7f, $7f, $7f, $7f, $5f, $6f, $57
; Tile skool 66
.byt $7a, $75, $7a, $75, $7a, $75, $7a, $75
; Tile skool 67
.byt $6a, $56, $6a, $56, $6a, $56, $6a, $56


; Escudo
; Tile skool 68
.byt $40, $7f, $4f^$bf, $67, $73^$bf, $79, $5e^$bf, $4c

; Tile skool 69
.byt $40, $40, $40, $40, $40, $40, $40, $7c
; Tile skool 70
.byt $40, $40, $40, $40, $40, $40, $40, $4f
; Tile skool 71
.byt $50, $7f, $7f, $7f, $7f, $7f, $7c, $68
; Tile skool 72
.byt $4c, $74, $74, $74, $78, $40, $40, $40
; Tile skool 73
.byt $40, $40, $40, $40, $40, $4f, $50, $7f
; Tile skool 74
.byt $70, $78, $68, $68, $68, $68, $58, $78
; Tile skool 75
.byt $57, $57, $57, $58, $5f, $60, $7f, $7f
; Tile skool 76
.byt $7f, $7f, $7f, $40, $7f, $40, $7f, $7f
; Tile skool 77
.byt $40, $7e, $7e, $40, $7e, $41, $7f, $7f
; Tile skool 78
.byt $7a, $75, $7a, $75, $7a, $75, $7b, $77
; Tile skool 79
.byt $6b, $57, $6f, $5f, $7f, $7f, $7f, $7f
; Tile skool 80
.byt $4f, $6f, $6f, $6f, $6f, $5f, $7f, $7f
; Tile skool 81
.byt $55, $7f, $55, $7f, $55, $7f, $55, $7f
; Tile skool 82
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile skool 83
.byt $40, $40, $40, $40, $40, $41, $43, $47
; Tile skool 84
.byt $43, $47, $4f, $5f, $7f, $7f, $7f, $7f
; Tile skool 85
.byt $60, $60, $60, $61, $63, $67, $6f, $7f
; Tile skool 86
.byt $4f, $5f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 87
.byt $55, $7f, $57, $7f, $5f, $7f, $7f, $7f
; Tile skool 88
.byt $55, $7f, $55, $7f, $55, $7f, $57, $7f
; Tile skool 89
.byt $57, $7f, $5f, $7f, $7f, $7f, $7f, $7f
; Tile skool 90
.byt $75, $7f, $75, $7f, $77, $7f, $7f, $7f
; Tile skool 91
.byt $5f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 92
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7e, $7e
; Tile skool 93
.byt $7f, $7f, $40, $40, $40, $40, $40, $40
; Tile skool 94
.byt $40, $40, $77, $77, $78, $78, $70, $7d
; Tile skool 95
.byt $40, $40, $7f, $7f, $40, $40, $40, $7f
; Tile skool 96
.byt $40, $40, $5f, $5f, $40, $40, $40, $7f
; Tile skool 97
.byt $40, $40, $7b, $7b, $43, $43, $43, $7b
; Tile skool 98
.byt $74, $75, $75, $7d, $7d, $7d, $7f, $7f
; Tile skool 99
.byt $40, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 100
.byt $4b, $6b, $6b, $6f, $6f, $6f, $7f, $7f

; Added tiles with repeated shields
; Escudos
; Tile skool 101
.byt $40, $7f, $6f^$bf, $67, $63^$bf, $61, $52, $4c
; Tile skool 102
.byt $40, $7f^$bf, $79, $79, $67^$bf, $67, $56^$bf, $4c
; Tile skool 103
.byt $40, $7f^$bf, $4f^$bf, $67^$bf, $73^$bf, $79^$bf, $5e^$bf, $4c
; Tile skool 104
.byt $40, $7f^$bf, $6f^$bf, $67^$bf, $63^$bf, $61^$bf, $52^$bf, $4c^$bf
;Tile skool 105
.byt $40, $7f, $4f^$bf, $67, $73, $79^$bf, $5e, $4c

; Clock
; Tile skool 106
.byt %11111100
.byt %11111011
.byt %11110111
.byt %11110100
.byt %11110111
.byt %11110111
.byt %11111011
.byt %11111100

; Tile skool 107
.byt %11000111
.byt %11110011
.byt %11111001
.byt %11011001
.byt %11011001
.byt %11011001
.byt %11110011
.byt %11000111

; For the blackboards we need
board_read
	.dsb 11*2*8, %01111111
board_white
	.dsb 11*2*8, %01111111
board_exam
	.dsb 11*2*8, %01111111

end_udg_skool2

speech_bubble
#ifndef RECTANGULAR_BUBBLES
	.byt $46,$5e,$5e,$5e,$5e,$5e,$5e,$58
	.byt $49,$61,$61,$61,$61,$61,$61,$64
	.byt $50,$40,$40,$40,$40,$40,$40,$42
	.byt $50,$40,$40,$40,$40,$40,$40,$42
	.byt $60,$40,$40,$40,$40,$40,$40,$41
	.byt $60,$40,$40,$40,$40,$40,$40,$41
	.byt $60,$40,$40,$40,$40,$40,$40,$41
	.byt $50,$40,$40,$40,$40,$40,$40,$42

	.byt $50,$40,$40,$40,$40,$40,$40,$42
	.byt $50,$40,$40,$40,$40,$40,$40,$42
	.byt $50,$40,$40,$40,$40,$40,$40,$42
	.byt $60,$40,$40,$40,$40,$40,$40,$41
	.byt $60,$40,$40,$40,$40,$40,$40,$41
	.byt $60,$40,$40,$40,$40,$40,$40,$41
	.byt $61,$61,$61,$61,$61,$61,$61,$61
	.byt $5e,$5e,$5e,$5e,$5e,$5e,$5e,$5e
#else
	.byt %01011111,$7f,$7f,$7f,$7f,$7f,$7f,%01111110
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011

	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt %01100000,$40,$40,$40,$40,$40,$40,%01000011
	.byt $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
	.byt %01011111,$7f,$7f,$7f,$7f,$7f,$7f,%01111110
#endif

tab_chars
	.byt 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20

free_udg_skool2
.dsb 256-(*&255)

udg_skool3

; Tile data for Skool (cols 75-128)
; Tile skool 1
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 2
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7e, $7c
; Tile skool 3
.byt $7f, $7b, $73, $63, $43, $43, $43, $43
; Tile skool 4
.byt $7f, $7f, $7f, $7f, $7f, $7c, $70, $40
; Tile skool 5
.byt $7f, $7f, $7c, $70, $40, $40, $40, $40
; Tile skool 6
.byt $7f, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile skool 7
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $75
; Tile skool 8
.byt $7f, $7f, $7f, $7d, $7f, $55, $7f, $55
; Tile skool 9
.byt $7f, $7f, $7f, $57, $7f, $57, $7f, $57

; Tejado
; Tile skool 10
;.byt $60, $58, $44, $42, $41, $40, $40, $40
.byt $60, $60, $c1, $de, $c0, $df, $c0, $df 
; Tile skool 11
;.byt $40, $40, $40, $40, $60, $50, $48, $44
.byt $40, $40, $40, $40, $70, $f3, $c1, $fe

; Tile skool 12
.byt $78, $78, $70, $60, $60, $60, $60, $60
; Tile skool 13
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile skool 14
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7c, $70
; Tile skool 15
.byt $7f, $7f, $7f, $7c, $70, $40, $40, $40
; Tile skool 16
.byt $7c, $70, $40, $40, $40, $40, $40, $40
; Tile skool 17
.byt $40, $40, $40, $40, $43, $43, $43, $43
; Tile skool 18
.byt $40, $43, $4f, $7f, $7f, $7f, $7f, $7f
; Tile skool 19
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7d
; Tile skool 20
.byt $7f, $7f, $7f, $7f, $7f, $75, $7f, $55
; Tile skool 21
.byt $7f, $7d, $7f, $55, $7f, $55, $7f, $55
; Tile skool 22
.byt $7f, $55, $7f, $55, $7f, $55, $7f, $55
; Tile skool 23
.byt $7f, $57, $7f, $57, $7f, $57, $7f, $7f


; Tile skool 24
.byt $40, $40, $40, $40, $40, $40, $40, $7f

; Tejado

; Tile skool 25
;.byt $43, $40, $40, $40, $40, $40, $40, $7f
.byt $c0, $ff, $c0, $ff, $c0, $ff, $c0, $7f
; Tile skool 26
;.byt $40, $60, $50, $4c, $42, $41, $40, $7f 
.byt $60, $50, $c3, $fd, $c0, $ff, $c0, $7f
; Tile skool 27
.byt $40, $40, $40, $40, $40, $20, $70, $78


;.byt $70, $60, $c1, $de, $c0, $df, $c0, $df 
;.byt $40, $40, $40, $40, $70, $f3, $c1, $fe

;.byt $c0, $df, $c0, $df, $c0, $df, $c0, $7f
;.byt $c0, $ff, $c0, $ff, $c0, $ff, $c0, $7f
;.byt $60, $50, $c3, $fd, $c0, $ff, $c0, $7f
/*
 .byt $70,$40,$40
 .byt $6C,$40,$40
 .byt $C1,$40,$40
 .byt $DE,$40,$40
 .byt $C0,$70,$40
 .byt $DF,$F3,$40
 .byt $C0,$C1,$40
 .byt $DF,$FE,$40
 
 .byt $C0,$C0,$60
 .byt $DF,$FF,$50
 .byt $C0,$C0,$C3
 .byt $DF,$FF,$FD
 .byt $C0,$C0,$C0
 .byt $DF,$FF,$FF
 .byt $C0,$C0,$C0
 .byt $7F,$7F,$7F
*/


; Ventanas
; Tile skool 28
.byt $7f, $41^$bf, $41, $41^$bf, $41, $41^$bf, $41, $7f
; Tile skool 29
.byt $60, $60, $60, $60, $60, $60, $60, $60
; Tile skool 30
.byt $7f, $40^$bf, $40, $40^$bf, $40, $40^$bf, $40, $7f
; Tile skool 31
.byt $7f, $60^$bf, $60, $60^$bf, $60, $60^$bf, $60, $7f

;Escudo
; Tile skool 32
.byt $40, $7f^$bf, $79^$bf, $79^$bf, $67^$bf, $67^$bf, $56^$bf, $4c

; Tile skool 33
.byt $7f, $75, $7f, $75, $7f, $75, $7f, $75
; Tile skool 34
.byt $7f, $57, $7f, $57, $7f, $57, $7f, $57

;Mapa
; Tile skool 35
.byt $4b, $47^$bf, $4f, $4f^$bf, $7f, $7f^$bf, $7f, $47^$bf
; Tile skool 36
.byt $46, $7c^$bf, $7e, $7c^$bf, $7c, $7f^$bf, $7e, $7c^$bf
; Tile skool 37
.byt $5f, $7f^$bf, $4f, $4f^$bf, $4e, $44^$bf, $40, $40^$bf
; Tile skool 38
.byt $60, $60^$bf, $40, $40^$bf, $40, $51^$bf, $71, $60^$bf
; Tile skool 39
.byt $40^$bf, $40, $4d^$bf, $59, $73^$bf, $7f, $7f^$bf, $7f
; Tile skool 40
.byt $47^$bf, $7f, $7f^$bf, $7f, $7f^$bf, $7f, $7f^$bf, $7f

; Ventana exterior
; Tile skool 41
.byt $40, $5f^$bf, $5f, $5f^$bf, $5f, $5f^$bf, $5f, $40

; Mapa
; Tile skool 42
.byt $43, $43^$bf, $43, $49^$bf, $40, $40^$bf, $40, $43^$bf
; Tile skool 43
.byt $7c, $70^$bf, $60, $62^$bf, $60, $51^$bf, $72, $78^$bf

; Tile skool 44
.byt $40^$bf, $44, $4c^$bf, $46, $48^$bf, $40, $40^$bf, $40
; Tile skool 45
.byt $7f^$bf, $7f, $7f^$bf, $5e, $58^$bf, $50, $48^$bf, $47
; Tile skool 46
.byt $77^$bf, $67, $62^$bf, $72, $59^$bf, $40, $40^$bf, $43

; Tile skool 47
.byt $40, $7f, $5f, $5f, $5f, $5f, $5c, $7c
; Tile skool 48
.byt $40, $7c, $7c, $7c, $78, $60, $40, $40
; Tile skool 49
.byt $40, $41, $42, $42, $42, $42, $42, $5f
; Tile skool 50
.byt $43, $43, $63, $63, $63, $63, $63, $63

; Mapa
; Tile skool 51
.byt $47, $47^$bf, $47, $43^$bf, $43, $43^$bf, $46, $44^$bf
; Tile skool 52
.byt $78, $78^$bf, $70, $70^$bf, $60, $50^$bf, $40, $40^$bf
; Tile skool 53
.byt $43^$bf, $41, $41^$bf, $40, $40^$bf, $40, $40^$bf, $40
; Tile skool 54
.byt $7f^$bf, $7e, $7e^$bf, $7e, $5e^$bf, $5e, $4e^$bf, $44

; Tile skool 55
.byt $40, $7f, $7f, $7f, $7f, $7f, $78, $78
; Tile skool 56
.byt $40, $41, $46, $44, $44, $44, $44, $5f
; Tile skool 57
.byt $43, $63, $63, $63, $63, $63, $63, $63
; Tile skool 58
.byt $7f, $49, $49, $49, $49, $49, $49, $49
; Tile skool 59
.byt $70, $5e, $49, $49, $49, $49, $49, $49
; Tile skool 60
.byt $40, $40, $60, $50, $48, $4c, $4a, $49
; Tile skool 61
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $58
; Tile skool 62
.byt $7f, $45, $45, $45, $45, $45, $45, $5e
; Tile skool 63
.byt $63, $63, $63, $63, $63, $63, $63, $63
; Tile skool 64
.byt $78, $78, $78, $78, $78, $78, $78, $77
; Tile skool 65
.byt $7f, $45, $45, $45, $45, $45, $45, $7e
; Tile skool 66
.byt $78, $78, $78, $78, $78, $78, $78, $70
; Tile skool 67
.byt $7f, $48, $48, $48, $48, $48, $48, $5f
; Tile skool 68
.byt $63, $63, $63, $63, $63, $63, $63, $43
; Tile skool 69
.byt $49, $49, $49, $49, $49, $49, $49, $49
; Tile skool 70
.byt $60, $70, $48, $4c, $4a, $49, $49, $49
; Tile skool 71
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7c
; Tile skool 72
.byt $7f, $7f, $7f, $7f, $7f, $7e, $60, $40
; Tile skool 73
.byt $7f, $7f, $7f, $7e, $70, $40, $40, $40
; Tile skool 74
.byt $7f, $7f, $71, $41, $41, $41, $41, $41
; Tile skool 75
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $60
; Tile skool 76
.byt $7f, $7f, $7f, $7f, $7f, $7e, $40, $40
; Tile skool 77
.byt $7f, $7f, $7f, $7f, $7f, $40, $40, $40
; Tile skool 78
.byt $7f, $7f, $7f, $7f, $40, $40, $40, $40
; Tile skool 79
.byt $7f, $7f, $7f, $7f, $40, $40, $4f, $78
; Tile skool 80
.byt $7f, $7f, $7f, $7f, $40, $5f, $70, $40
; Tile skool 81
.byt $7f, $7f, $7f, $7f, $7c, $60, $40, $40
; Tile skool 82
.byt $7f, $7f, $7f, $78, $40, $40, $40, $40
; Tile skool 83
.byt $7f, $7f, $7f, $7f, $7f, $7f, $78, $7f
; Tile skool 84
.byt $7f, $7f, $7f, $7f, $7f, $7f, $40, $7f
; Tile skool 85
.byt $7f, $7f, $7f, $40, $7f, $7f, $40, $7f
; Tile skool 86
.byt $7f, $7f, $7f, $40, $7f, $6f, $6f, $6f
; Tile skool 87
.byt $7f, $7f, $7f, $40, $7f, $68, $68, $68
; Tile skool 88
.byt $7f, $7f, $7f, $44, $7c, $40, $40, $40
; Tile skool 89
.byt $7f, $7f, $7f, $40, $40, $40, $40, $40
; Tile skool 90
.byt $7f, $7f, $40, $40, $40, $40, $40, $40
; Tile skool 91
.byt $7f, $41, $41, $41, $41, $41, $41, $41

;Escudo
; Tile skool 92
.byt $40, $7f, $4f^$bf, $67, $73^$bf, $79, $5e^$bf, $4c

; Tile skool 93
.byt $41, $41, $41, $41, $41, $41, $41, $7f
; Tile skool 94
.byt $41, $4e, $4d, $4a, $4d, $4a, $4d, $4f
; Tile skool 95
.byt $7f, $68, $58, $68, $58, $68, $58, $6f
; Tile skool 96
.byt $78, $48, $48, $48, $48, $48, $48, $78
; Tile skool 97
.byt $41, $41, $41, $41, $41, $41, $41, $41
; Tile skool 98
.byt $78, $78, $78, $78, $78, $78, $78, $7f
; Tile skool 99
.byt $68, $68, $68, $68, $68, $68, $68, $68
; Tile skool 100
.byt $7f, $7c, $60, $60, $60, $60, $60, $60
; Tile skool 101
.byt $43, $46, $45, $46, $45, $46, $45, $47
; Tile skool 102
.byt $7f, $40, $40, $40, $40, $40, $40, $40
; Tile skool 103
.byt $78, $78, $78, $78, $78, $68, $68, $68
; Tile skool 104
.byt $40, $40, $40, $40, $40, $40, $4f, $4c
; Tile skool 105
.byt $43, $46, $45, $46, $45, $46, $7d, $40

Espaldera
; Tile skool 106
.byt $40, $40, $40, $40, $40, $40, $50^$bf, $68

; Tile skool 107
.byt $40, $40, $40, $40, $40, $40, $40, $4f
; Tile skool 108
.byt $40, $40, $40, $40, $40, $40, $40, $7c
; Tile skool 109
.byt $40, $40, $40, $40, $40, $40, $5f, $58
; Tile skool 110
.byt $4f, $4a, $4d, $4a, $4d, $4a, $7d, $40

;Espalderas
; Tile skool 111
.byt $40^$bf, $7f, $40^$bf, $7f, $40^$bf, $7f, $40^$bf, $7f
; Tile skool 112
.byt $68^$bf, $6f, $48^$bf, $6f, $68^$bf, $6f, $48^$bf, $6f
; Tile skool 113
.byt $68^$bf, $68, $48^$bf, $68, $68^$bf, $68, $48^$bf, $68

; Tile skool 114
.byt $50, $7f, $7f, $7f, $7f, $7f, $7c, $68
; Tile skool 115
.byt $4c, $74, $74, $74, $78, $40, $40, $40
; Tile skool 116
.byt $40, $40, $40, $40, $40, $4f, $50, $7f
; Tile skool 117
.byt $70, $78, $68, $68, $68, $68, $58, $78
; Tile skool 118
.byt $57, $5a, $55, $5a, $55, $5a, $55, $5f
; Tile skool 119
.byt $54, $54, $54, $54, $54, $54, $54, $54
; Tile skool 120
.byt $57, $57, $57, $58, $5f, $60, $7f, $7f
; Tile skool 121
.byt $7f, $7f, $7f, $40, $7f, $40, $7f, $7f
; Tile skool 122
.byt $40, $7e, $7e, $40, $7e, $41, $7f, $7f
; Tile skool 123
.byt $48, $6f, $6f, $6f, $6f, $5f, $7f, $7f
; Tile skool 124
.byt $40, $40, $7c, $7f, $7f, $7f, $7f, $7f
; Tile skool 125
.byt $7c, $7e, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 126
.byt $40, $40, $60, $78, $7e, $7f, $7f, $7f
; Tile skool 127
.byt $4f, $43, $42, $43, $42, $7f, $7f, $7f
; Tile skool 128
.byt $7f, $5f, $6a, $55, $6a, $7f, $7f, $7f
; Tile skool 129
.byt $7e, $7f, $7f, $57, $6a, $7f, $7f, $7f
; Tile skool 130
.byt $40, $70, $7e, $7f, $7f, $7f, $7f, $7f
; Tile skool 131
.byt $40, $40, $40, $70, $7e, $7f, $7f, $7f
; Tile skool 132
.byt $40, $40, $40, $40, $40, $70, $7e, $7f
; Tile skool 133
.byt $68, $68, $68, $68, $68, $74, $74, $74
; Tile skool 134
.byt $68, $64, $54, $54, $54, $54, $54, $54

;Escudo
; Tile skool 135
.byt $40, $7f, $6f^$bf, $67, $63^$bf, $61, $52, $4c

; Tile skool 136
.byt $40, $40, $40, $40, $47, $46, $45, $46
; Tile skool 137
.byt $4a, $4d, $4a, $4d, $7f, $7c, $57, $6a
; Tile skool 138
.byt $6a, $55, $6a, $55, $7a, $4f, $70, $6f
; Tile skool 139
.byt $6a, $55, $6a, $55, $6a, $55, $7a, $47
; Tile skool 140
.byt $7f, $58, $68, $58, $68, $58, $68, $7f
; Tile skool 141
.byt $74, $74, $74, $74, $74, $74, $6a, $6a
; Tile skool 142
.byt $54, $4a, $4a, $4a, $4a, $4a, $4a, $4a
; Tile skool 143
.byt $54, $54, $54, $54, $54, $52, $4a, $4a
; Tile skool 144
.byt $40, $40, $40, $40, $40, $60, $78, $7e
; Tile skool 145
.byt $45, $46, $45, $46, $7f, $7c, $57, $6a
; Tile skool 146
.byt $55, $6a, $55, $6a, $75, $4f, $70, $6f
; Tile skool 147
.byt $55, $6a, $55, $6a, $55, $6a, $7d, $47
; Tile skool 148
.byt $6a, $6a, $6a, $6a, $6a, $65, $65, $65
; Tile skool 149
.byt $4a, $4a, $4a, $4a, $4a, $45, $45, $45
; Tile skool 150
.byt $4a, $4a, $4a, $4a, $4a, $4a, $4a, $4a
; Tile skool 151
.byt $7f, $7f, $7f, $60, $60, $70, $70, $70
; Tile skool 152
.byt $7f, $7f, $7f, $7f, $7f, $5f, $5f, $4f
; Tile skool 153
.byt $7f, $7f, $7f, $7f, $6f, $67, $67, $63
; Tile skool 154
.byt $60, $70, $78, $7c, $7e, $7f, $7f, $7f
; Tile skool 155
.byt $40, $40, $40, $40, $40, $40, $60, $70
; Tile skool 156
.byt $61, $60, $60, $60, $60, $60, $60, $60
; Tile skool 157
.byt $60, $78, $4e, $43, $40, $40, $40, $40
; Tile skool 158
.byt $60, $60, $60, $60, $60, $40, $40, $40
; Tile skool 159
.byt $60, $60, $60, $60, $67, $6f, $7f, $71
; Tile skool 160
.byt $40, $40, $40, $40, $7f, $7f, $7f, $7f
; Tile skool 161
.byt $40, $40, $40, $40, $70, $7c, $7e, $7e
; Tile skool 162
.byt $65, $62, $62, $61, $61, $60, $60, $60
; Tile skool 163
.byt $42, $62, $61, $51, $50, $68, $68, $54
; Tile skool 164
.byt $6a, $6a, $6a, $5a, $7a, $5a, $4d, $4d
; Tile skool 165
.byt $54, $54, $54, $54, $54, $52, $4a, $4b
; Tile skool 166
.byt $70, $78, $78, $78, $78, $7c, $7c, $7c
; Tile skool 167
.byt $47, $44, $42, $42, $41, $41, $40, $40
; Tile skool 168
.byt $7f, $40, $40, $40, $40, $40, $60, $60
; Tile skool 169
.byt $61, $50, $48, $48, $44, $42, $42, $41
; Tile skool 170
.byt $7f, $7f, $5f, $5f, $4f, $47, $43, $41
; Tile skool 171
.byt $78, $7c, $7e, $7f, $7f, $7f, $7f, $7f
; Tile skool 172
.byt $40, $40, $40, $40, $60, $70, $78, $7c

; Espalderas
; Tile skool 173
.byt $40, $7f, $40^$bf, $7f, $40, $40, $40, $40
; Tile skool 174
.byt $68^$bf, $6f, $48^$bf, $6f, $68^$bf, $68, $68^$bf, $68
; Tile skool 175
.byt $68^$bf, $68, $48^$bf, $68, $68^$bf, $68, $68^$bf, $68

; Tile skool 176
.byt $70, $70, $70, $60, $60, $60, $60, $60
; Tile skool 177
.byt $50, $50, $50, $50, $50, $60, $60, $60
; Tile skool 178
.byt $42, $42, $42, $42, $42, $41, $41, $41
; Tile skool 179
.byt $52, $4a, $45, $42, $41, $40, $40, $40
; Tile skool 180
.byt $46, $46, $73, $4f, $70, $4f, $40, $40
; Tile skool 181
.byt $69, $67, $7f, $7d, $75, $75, $75, $7d
; Tile skool 182
.byt $5c, $78, $60, $40, $40, $40, $40, $40
; Tile skool 183
.byt $7c, $7e, $7e, $7e, $7e, $7e, $7e, $7f
; Tile skool 184
.byt $40, $40, $40, $40, $40, $40, $40, $77
; Tile skool 185
.byt $50, $50, $48, $48, $44, $44, $42, $5c
; Tile skool 186
.byt $60, $60, $50, $48, $48, $44, $42, $42
; Tile skool 187
.byt $7e, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 188
.byt $40, $40, $60, $70, $78, $7c, $7e, $7f
; Tile skool 189
.byt $6f, $6f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 190
.byt $6f, $6e, $7e, $7c, $7e, $7f, $7f, $7f
; Tile skool 191
.byt $40, $40, $41, $41, $41, $62, $7a, $7e
; Tile skool 192
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile skool 193
.byt $41, $41, $40, $40, $40, $40, $40, $40
; Tile skool 194
.byt $40, $40, $60, $60, $60, $50, $5f, $5f
; Tile skool 195
.byt $68, $68, $68, $68, $68, $68, $68, $78
; Tile skool 196
.byt $7f, $7f, $7f, $7f, $7f, $7f, $5f, $5f
; Tile skool 197
.byt $77, $77, $77, $70, $77, $77, $77, $77
; Tile skool 198
.byt $7f, $7f, $7f, $40, $7f, $7f, $7f, $7f
; Tile skool 199
.byt $5e, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile skool 200
.byt $40, $7f, $5f, $5f, $5f, $40, $5f, $5f
; Tile skool 201
.byt $41, $7f, $7e, $7e, $7e, $40, $7e, $7e
; Tile skool 202
.byt $60, $70, $7c, $7e, $7f, $7f, $7f, $7f
; Tile skool 203
.byt $40, $40, $40, $40, $60, $78, $7e, $7f
; Tile skool 204
.byt $7d, $7a, $7d, $7a, $7f, $7f, $7f, $7f
; Tile skool 205
.byt $55, $6a, $55, $6a, $55, $7e, $7f, $7f
; Tile skool 206
.byt $57, $6a, $55, $6a, $55, $6a, $75, $7e
; Tile skool 207
.byt $60, $60, $7c, $7f, $7f, $7f, $7f, $7f
; Tile skool 208
.byt $40, $40, $40, $70, $7f, $7f, $7f, $7f
; Tile skool 209
.byt $40, $40, $40, $40, $40, $7c, $7f, $7f
; Tile skool 210
.byt $5f, $5f, $5f, $5f, $4a, $40, $70, $7f
; Tile skool 211
.byt $77, $77, $77, $7f, $7f, $7f, $7f, $7f
; Tile skool 212
.byt $5f, $5f, $5f, $7f, $7f, $7f, $7f, $7f
; Tile skool 213
.byt $7e, $7e, $7e, $7f, $7f, $7f, $7f, $7f
; Tile skool 214
.byt $7c, $7f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 215
.byt $40, $70, $7f, $7f, $7f, $7f, $7f, $7f
; Tile skool 216
.byt $40, $40, $40, $7c, $7f, $7f, $7f, $7f
; Tile skool 217
.byt $41, $41, $41, $41, $71, $7f, $7f, $7f


; Added shields which were repeated
;Escudo
; Tile skool 218
.byt $40, $7f^$bf, $79, $79^$bf, $67, $67^$bf, $56, $4c
; Tile skool 219
.byt $40, $7f, $79^$bf, $79^$bf, $67^$bf, $67^$bf, $56^$bf, $4c

;Tejado
; Tile skool 220
.byt $c0, $df, $c0, $df, $c0, $df, $c0, $7f

end_udg_skool3

end_skool_udgs

_free_udg_skool3
.dsb 256-(*&255)

speech_bubble_lip	
	.byt $61
	.byt $61
	.byt $51
	.byt $51
	.byt $51
	.byt $4a
	.byt $4a
	.byt $44

children_tiles
; Tile graphic 1
.byt $0, $f, $7, $5, $0, $7, $2, $7
; Tile graphic 2
.byt $0, $20, $30, $30, $10, $38, $3c, $3e
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 4
.byt $f, $f, $f, $f, $f, $1f, $2f, $17
; Tile graphic 5
.byt $3e, $3e, $3e, $3e, $3e, $3e, $3e, $3a
; Tile graphic 6
.byt $7, $7, $2, $2, $2, $3, $3, $7
; Tile graphic 7
.byt $3c, $38, $28, $28, $28, $38, $38, $38
; Tile graphic 8
.byt $0, $1, $3, $3, $2, $7, $f, $1f
; Tile graphic 9
.byt $0, $3c, $38, $28, $0, $38, $10, $38
; Tile graphic 10
.byt $1f, $1f, $1f, $1f, $1f, $1f, $1f, $17
; Tile graphic 11
.byt $3c, $3c, $3c, $3c, $3c, $3e, $3d, $3a
; Tile graphic 12
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 13
.byt $f, $7, $5, $5, $5, $7, $7, $7
; Tile graphic 14
.byt $38, $38, $10, $10, $10, $30, $30, $38
; Tile graphic 15
.byt $0, $3, $1, $1, $0, $1, $0, $1
; Tile graphic 16
.byt $0, $38, $3c, $1c, $4, $3e, $2f, $3f
; Tile graphic 17
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 18
.byt $3, $3, $3, $3, $3, $7, $b, $5
; Tile graphic 19
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $3e
; Tile graphic 20
.byt $20, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 21
.byt $1, $0, $0, $1, $1, $3, $3, $f
; Tile graphic 22
.byt $3f, $32, $24, $a, $1d, $25, $23, $7
; Tile graphic 23
.byt $0, $0, $0, $0, $0, $0, $20, $20
; Tile graphic 24
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 25
.byt $0, $7, $f, $e, $8, $1f, $3d, $3f
; Tile graphic 26
.byt $0, $30, $20, $20, $0, $20, $0, $20
; Tile graphic 27
.byt $1, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 28
.byt $3f, $3f, $3f, $3f, $3f, $3f, $3f, $1f
; Tile graphic 29
.byt $30, $30, $30, $30, $30, $38, $34, $28
; Tile graphic 30
.byt $0, $0, $0, $0, $0, $0, $1, $1
; Tile graphic 31
.byt $3f, $13, $9, $14, $2e, $29, $31, $38
; Tile graphic 32
.byt $20, $0, $0, $20, $20, $30, $30, $3c
; Tile graphic 33
.byt $7, $7, $2, $2, $1, $1, $0, $1
; Tile graphic 34
.byt $38, $38, $10, $10, $20, $20, $0, $20
; Tile graphic 35
.byt $1, $2, $2, $5, $5, $7, $e, $1e
; Tile graphic 36
.byt $3f, $3d, $35, $4, $2, $1, $0, $1
; Tile graphic 37
.byt $0, $0, $0, $20, $10, $30, $30, $30
; Tile graphic 38
.byt $0, $0, $0, $1, $2, $3, $3, $3
; Tile graphic 39
.byt $3f, $2f, $2b, $8, $10, $20, $0, $20
; Tile graphic 40
.byt $20, $10, $10, $28, $28, $38, $1c, $1e
; Tile graphic 41
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 42
.byt $7, $3, $7, $5, $f, $11, $27, $28
; Tile graphic 43
.byt $3e, $3e, $3e, $3e, $3e, $3e, $3c, $0
; Tile graphic 44
.byt $0, $0, $0, $1, $0, $0, $0, $0
; Tile graphic 45
.byt $28, $38, $38, $38, $0, $0, $0, $0
; Tile graphic 46
.byt $1f, $1f, $1f, $1f, $1f, $1f, $f, $0
; Tile graphic 47
.byt $38, $30, $38, $28, $3c, $22, $39, $5
; Tile graphic 48
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 49
.byt $5, $7, $7, $7, $0, $0, $0, $0
; Tile graphic 50
.byt $0, $0, $0, $20, $0, $0, $0, $0
; Tile graphic 51
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 52
.byt $0, $0, $1f, $f, $b, $0, $f, $5
; Tile graphic 53
.byt $0, $0, $0, $20, $20, $30, $30, $38
; Tile graphic 54
.byt $0, $0, $0, $0, $5, $7, $7, $7
; Tile graphic 55
.byt $6, $9, $10, $24, $3a, $3f, $39, $30
; Tile graphic 56
.byt $3, $3, $2f, $1f, $f, $2f, $3f, $1f
; Tile graphic 57
.byt $38, $38, $3c, $3c, $3c, $2c, $2a, $e
; Tile graphic 58
.byt $0, $0, $0, $1, $1, $3, $3, $7
; Tile graphic 59
.byt $0, $0, $3e, $3c, $34, $0, $3c, $28
; Tile graphic 60
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 61
.byt $7, $7, $f, $f, $f, $d, $15, $1c
; Tile graphic 62
.byt $30, $30, $3d, $3e, $3c, $3d, $3f, $3e
; Tile graphic 63
.byt $18, $24, $2, $9, $17, $3f, $27, $3
; Tile graphic 64
.byt $0, $0, $0, $0, $28, $38, $38, $38
; Tile graphic 65
.byt $0, $0, $0, $0, $10, $1f, $1c, $1f
; Tile graphic 66
.byt $0, $0, $0, $0, $1f, $3f, $1b, $31
; Tile graphic 67
.byt $0, $0, $0, $3f, $3e, $3f, $3f, $3f
; Tile graphic 68
.byt $0, $2, $2e, $26, $2e, $2e, $3c, $20
; Tile graphic 69
.byt $0, $10, $1d, $19, $1d, $1d, $f, $1
; Tile graphic 70
.byt $0, $0, $0, $3f, $1f, $3f, $3f, $3f
; Tile graphic 71
.byt $0, $0, $0, $0, $3e, $3f, $36, $23
; Tile graphic 72
.byt $0, $0, $0, $0, $2, $3e, $e, $3e
; Tile graphic 73
.byt $5, $7, $1, $0, $0, $0, $0, $0
; Tile graphic 74
.byt $7, $3f, $3f, $27, $1f, $3, $3, $3
; Tile graphic 75
.byt $3e, $3e, $3e, $3e, $3e, $3e, $3e, $3e
; Tile graphic 76
.byt $4, $9, $a, $a, $a, $e, $e, $1e
; Tile graphic 77
.byt $3e, $e, $a, $a, $a, $e, $e, $1e
; Tile graphic 78
.byt $1f, $1f, $1f, $1f, $1f, $1f, $1f, $1f
; Tile graphic 79
.byt $38, $3f, $3f, $39, $3e, $30, $30, $30
; Tile graphic 80
.byt $28, $38, $20, $0, $0, $0, $0, $0
; Tile graphic 81
.byt $1f, $1c, $14, $14, $14, $1c, $1c, $1e
; Tile graphic 82
.byt $8, $24, $14, $14, $14, $1c, $1c, $1e
; Tile graphic 83
.byt $0, $0, $0, $0, $0, $0, $1f, $17
; Tile graphic 84
.byt $0, $f, $7, $5, $0, $7, $3e, $3f
; Tile graphic 85
.byt $1f, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 86
.byt $3f, $27, $3f, $7, $3, $3, $3, $3
; Tile graphic 87
.byt $0, $3c, $38, $28, $0, $38, $1f, $3f
; Tile graphic 88
.byt $0, $0, $0, $0, $0, $0, $3e, $3a
; Tile graphic 89
.byt $3f, $39, $3f, $38, $30, $30, $30, $30
; Tile graphic 90
.byt $3e, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 91
.byt $4, $a, $e, $c, $c, $e, $7, $3
; Tile graphic 92
.byt $0, $f, $7, $5, $0, $7, $2, $37
; Tile graphic 93
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 94
.byt $3f, $3f, $1f, $f, $f, $f, $f, $7
; Tile graphic 95
.byt $7, $7, $2, $2, $2, $3, $3, $7
; Tile graphic 96
.byt $0, $3c, $38, $28, $0, $38, $10, $3b
; Tile graphic 97
.byt $8, $14, $1c, $c, $c, $1c, $38, $30
; Tile graphic 98
.byt $3f, $3f, $3e, $3c, $3c, $3c, $3c, $38
; Tile graphic 99
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 100
.byt $38, $38, $10, $10, $10, $30, $30, $38
; Tile graphic 101
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 102
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 103
.byt $2, $3, $3, $3, $3, $3, $3, $3
; Tile graphic 104
.byt $20, $2f, $7, $5, $20, $27, $22, $37
; Tile graphic 105
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 106
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 107
.byt $1, $3d, $38, $28, $1, $39, $11, $3b
; Tile graphic 108
.byt $10, $30, $30, $30, $30, $30, $30, $30
; Tile graphic 109
.byt $0, $1, $2, $3, $4, $3, $0, $0
; Tile graphic 110
.byt $1f, $3f, $3f, $3f, $3f, $f, $7, $7
; Tile graphic 111
.byt $3e, $3f, $3f, $3c, $3c, $3c, $3c, $3c
; Tile graphic 112
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 113
.byt $3c, $38, $28, $28, $28, $38, $38, $38
; Tile graphic 114
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 115
.byt $1f, $3f, $3f, $f, $f, $f, $f, $f
; Tile graphic 116
.byt $3e, $3f, $3f, $3f, $3f, $3c, $38, $38
; Tile graphic 117
.byt $0, $20, $10, $30, $8, $30, $0, $0
; Tile graphic 118
.byt $f, $7, $5, $5, $5, $7, $7, $7
; Tile graphic 119
.byt $0, $0, $0, $0, $f, $8, $f, $13
; Tile graphic 120
.byt $0, $f, $7, $5, $3f, $4, $3e, $3f
; Tile graphic 121
.byt $0, $20, $30, $30, $10, $18, $1c, $3e
; Tile graphic 122
.byt $1f, $8, $0, $0, $0, $0, $0, $0
; Tile graphic 123
.byt $3f, $f, $f, $f, $f, $f, $7, $7
; Tile graphic 124
.byt $3f, $3f, $3c, $3c, $3c, $3c, $3c, $3c
; Tile graphic 125
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 126
.byt $0, $1, $3, $3, $2, $6, $e, $1f
; Tile graphic 127
.byt $0, $3c, $38, $28, $3f, $8, $1f, $3f
; Tile graphic 128
.byt $0, $0, $0, $0, $3c, $4, $3c, $32
; Tile graphic 129
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 130
.byt $3f, $3f, $f, $f, $f, $f, $f, $f
; Tile graphic 131
.byt $3f, $3c, $3c, $3c, $3c, $3c, $38, $38
; Tile graphic 132
.byt $3e, $4, $0, $0, $0, $0, $0, $0
; Tile graphic 133
.byt $0, $3, $4, $4, $6, $0, $7, $1
; Tile graphic 134
.byt $0, $30, $3c, $2c, $c, $38, $10, $1c
; Tile graphic 135
.byt $3e, $2e, $3e, $3e, $3e, $3e, $3e, $3a
; Tile graphic 136
.byt $0, $3, $f, $d, $c, $7, $2, $e
; Tile graphic 137
.byt $0, $30, $8, $8, $18, $0, $38, $20
; Tile graphic 138
.byt $1f, $1d, $1f, $1f, $1f, $1f, $1f, $17
; Tile graphic 139
.byt $0, $0, $1, $1, $1, $0, $1, $0
; Tile graphic 140
.byt $0, $3c, $f, $b, $23, $e, $34, $17
; Tile graphic 141
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 142
.byt $3f, $3b, $3f, $3f, $3f, $3f, $3f, $3e
; Tile graphic 143
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 144
.byt $0, $f, $3c, $34, $31, $1c, $b, $3a
; Tile graphic 145
.byt $0, $0, $20, $20, $20, $0, $20, $0
; Tile graphic 146
.byt $3f, $37, $3f, $3f, $3f, $3f, $3f, $1f
; Tile graphic 147
.byt $0, $0, $7, $9, $9, $c, $1, $e
; Tile graphic 148
.byt $0, $0, $20, $38, $18, $18, $30, $30
; Tile graphic 149
.byt $0, $0, $1, $7, $6, $6, $3, $3
; Tile graphic 150
.byt $0, $0, $38, $24, $24, $c, $20, $1c
; Tile graphic 151
.byt $0, $0, $0, $3d, $3d, $3f, $3e, $3d
; Tile graphic 152
.byt $0, $0, $c, $12, $2, $e, $26, $3c
; Tile graphic 153
.byt $0, $0, $c, $12, $10, $1c, $19, $f
; Tile graphic 154
.byt $0, $0, $0, $2f, $2f, $3f, $1f, $2f
; Tile graphic 155
.byt $0, $7, $f, $9, $1, $8, $f, $7
; Tile graphic 156
.byt $0, $20, $30, $30, $10, $18, $3c, $3e
; Tile graphic 157
.byt $0, $1, $3, $3, $2, $6, $f, $1f
; Tile graphic 158
.byt $0, $38, $3c, $24, $20, $4, $3c, $38
; Tile graphic 159
.byt $0, $1, $3, $2, $0, $2, $3, $1
; Tile graphic 160
.byt $0, $38, $3c, $1c, $14, $6, $3f, $3f
; Tile graphic 161
.byt $1, $0, $0, $1, $1, $3, $3, $f
; Tile graphic 162
.byt $0, $7, $f, $e, $a, $18, $3f, $3f
; Tile graphic 163
.byt $0, $20, $30, $10, $0, $10, $30, $20
; Tile graphic 164
.byt $20, $0, $0, $20, $20, $30, $30, $3c
; Tile graphic 165
.byt $0, $0, $f, $1f, $13, $2, $10, $1f
; Tile graphic 166
.byt $0, $0, $0, $20, $20, $20, $30, $38
; Tile graphic 167
.byt $0, $0, $0, $1, $1, $1, $3, $7
; Tile graphic 168
.byt $0, $0, $3c, $3e, $32, $10, $2, $3e
; Tile graphic 169
.byt $0, $0, $1, $3f, $3f, $3f, $3f, $3f
; Tile graphic 170
.byt $0, $0, $2c, $6, $6, $1e, $e, $3c
; Tile graphic 171
.byt $0, $0, $d, $18, $18, $1e, $1c, $f
; Tile graphic 172
.byt $0, $0, $20, $3f, $3f, $3f, $3f, $3f
; Tile graphic 173
.byt $0, $7, $f, $9, $1, $8, $3f, $3f
; Tile graphic 174
.byt $0, $38, $3c, $24, $20, $4, $3f, $3f
; Tile graphic 175
.byt $0, $7, $f, $9, $1, $8, $f, $37
; Tile graphic 176
.byt $0, $38, $3c, $24, $20, $4, $3c, $3b
; Tile graphic 177
.byt $20, $27, $f, $9, $21, $28, $2f, $37
; Tile graphic 178
.byt $1, $39, $3c, $24, $21, $5, $3d, $3b
; Tile graphic 179
.byt $0, $7, $8, $6, $5, $0, $7, $7
; Tile graphic 180
.byt $0, $30, $8, $8, $28, $10, $38, $3e
; Tile graphic 181
.byt $0, $3, $4, $4, $5, $2, $7, $1f
; Tile graphic 182
.byt $0, $38, $4, $18, $28, $0, $38, $38
; Tile graphic 183
.byt $0, $1, $2, $1, $1, $0, $1, $1
; Tile graphic 184
.byt $0, $3c, $2, $22, $1a, $4, $3e, $3f
; Tile graphic 185
.byt $0, $f, $10, $11, $16, $8, $1f, $3f
; Tile graphic 186
.byt $0, $20, $10, $20, $20, $0, $20, $20
; Tile graphic 187
.byt $0, $0, $f, $10, $c, $b, $0, $f
; Tile graphic 188
.byt $0, $0, $20, $10, $10, $10, $30, $38
; Tile graphic 189
.byt $0, $0, $1, $2, $2, $2, $3, $7
; Tile graphic 190
.byt $0, $0, $3c, $2, $c, $34, $0, $3c
; Tile graphic 191
.byt $0, $0, $1, $3f, $3f, $3f, $3f, $3f
; Tile graphic 192
.byt $0, $2, $1a, $a, $1a, $12, $3c, $0
; Tile graphic 193
.byt $0, $10, $16, $14, $16, $12, $f, $0
; Tile graphic 194
.byt $0, $0, $20, $3f, $3f, $3f, $3f, $3f
; Tile graphic 195
.byt $0, $7, $8, $6, $5, $0, $7, $37
; Tile graphic 196
.byt $0, $38, $4, $18, $28, $0, $38, $3b
; Tile graphic 197
.byt $20, $27, $8, $6, $25, $20, $27, $37
; Tile graphic 198
.byt $1, $39, $4, $18, $29, $1, $39, $3b
; Tile graphic 199
.byt $0, $7, $8, $6, $3e, $4, $3e, $3f
; Tile graphic 200
.byt $0, $30, $8, $8, $18, $18, $14, $3e
; Tile graphic 201
.byt $0, $3, $4, $4, $6, $6, $a, $1f
; Tile graphic 202
.byt $0, $38, $4, $18, $1f, $8, $1f, $3f
; Tile graphic 203
.byt $0, $0, $0, $0, $7, $5, $0, $7
; Tile graphic 204
.byt $0, $0, $0, $0, $20, $30, $10, $38
; Tile graphic 205
.byt $2, $7, $7, $7, $7, $f, $17, $f
; Tile graphic 206
.byt $3c, $3e, $2e, $3e, $3e, $3e, $3e, $3a
; Tile graphic 207
.byt $0, $0, $0, $0, $1, $3, $2, $7
; Tile graphic 208
.byt $0, $0, $0, $0, $38, $28, $0, $38
; Tile graphic 209
.byt $f, $1f, $1d, $1f, $1f, $1f, $1f, $17
; Tile graphic 210
.byt $10, $38, $38, $38, $38, $3c, $3a, $3c
; Tile graphic 211
.byt $0, $0, $0, $0, $1, $1, $0, $1
; Tile graphic 212
.byt $0, $0, $0, $0, $38, $1c, $4, $3e
; Tile graphic 213
.byt $0, $1, $1, $1, $1, $3, $5, $3
; Tile graphic 214
.byt $2f, $3f, $3b, $3f, $3f, $3f, $3f, $3e
; Tile graphic 215
.byt $0, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 216
.byt $1, $0, $0, $1, $1, $3, $3, $f
; Tile graphic 217
.byt $0, $0, $0, $0, $7, $e, $8, $1f
; Tile graphic 218
.byt $0, $0, $0, $0, $20, $20, $0, $20
; Tile graphic 219
.byt $0, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 220
.byt $3d, $3f, $37, $3f, $3f, $3f, $3f, $1f
; Tile graphic 221
.byt $0, $20, $20, $20, $20, $30, $28, $30
; Tile graphic 222
.byt $20, $0, $0, $20, $20, $30, $30, $3c
; Tile graphic 223
.byt $7, $7, $2, $2, $1, $1, $0, $1
; Tile graphic 224
.byt $38, $38, $10, $10, $20, $20, $0, $20
; Tile graphic 225
.byt $0, $0, $0, $0, $20, $30, $10, $30
; Tile graphic 226
.byt $3, $1, $3, $5, $7, $9, $13, $14
; Tile graphic 227
.byt $38, $3c, $3c, $3c, $3c, $3c, $38, $0
; Tile graphic 228
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 229
.byt $14, $1c, $1c, $3c, $0, $0, $0, $0
; Tile graphic 230
.byt $0, $0, $0, $0, $1, $3, $2, $3
; Tile graphic 231
.byt $7, $f, $f, $f, $f, $f, $7, $0
; Tile graphic 232
.byt $30, $20, $30, $28, $38, $24, $32, $a
; Tile graphic 233
.byt $a, $e, $e, $f, $0, $0, $0, $0
; Tile graphic 234
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 235
.byt $0, $7, $5, $0, $7, $2, $33, $f
; Tile graphic 236
.byt $0, $20, $30, $10, $30, $30, $38, $38
; Tile graphic 237
.byt $0, $0, $1, $1, $3, $f, $7, $3
; Tile graphic 238
.byt $3f, $27, $3, $13, $13, $37, $3f, $27
; Tile graphic 239
.byt $38, $38, $38, $38, $38, $38, $30, $20
; Tile graphic 240
.byt $0, $1, $3, $2, $3, $3, $7, $7
; Tile graphic 241
.byt $0, $38, $28, $0, $38, $10, $33, $3c
; Tile graphic 242
.byt $7, $7, $7, $7, $7, $7, $3, $1
; Tile graphic 243
.byt $3f, $39, $30, $32, $32, $3b, $3f, $39
; Tile graphic 244
.byt $0, $0, $20, $20, $30, $3c, $38, $30
; Tile graphic 245
.byt $0, $0, $0, $0, $4, $7, $7, $7
; Tile graphic 246
.byt $0, $0, $0, $0, $7, $3f, $6, $3c
; Tile graphic 247
.byt $0, $0, $0, $0, $3f, $3f, $3f, $1f
; Tile graphic 248
.byt $0, $0, $16, $32, $16, $36, $3e, $30
; Tile graphic 249
.byt $0, $0, $1a, $13, $1a, $1b, $1f, $3
; Tile graphic 250
.byt $0, $0, $0, $0, $3f, $3f, $3f, $3e
; Tile graphic 251
.byt $0, $0, $0, $0, $38, $3f, $18, $f
; Tile graphic 252
.byt $0, $0, $0, $0, $8, $38, $38, $38
; Tile graphic 253
.byt $0, $4, $a, $4, $0, $0, $0, $0
; Tile graphic 254
.byt $0, $8, $14, $8, $0, $0, $0, $0

end_children_tiles

.dsb 256-(*&255)
tab_bit8
	.byt %10000000
	.byt %01000000
	.byt %00100000
	.byt %00010000
	.byt %00001000
	.byt %00000100
	.byt %00000010
	.byt %00000001

children_masks
; Tile mask 1
.byt $70, $60, $60, $70, $70, $70, $78, $70
; Tile mask 2
.byt $5f, $4f, $47, $47, $47, $43, $41, $40
; Tile mask 3
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7e, $7f
; Tile mask 4
.byt $60, $60, $60, $60, $60, $40, $40, $40
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $60, $70, $78, $78, $78, $78, $78, $70
; Tile mask 7
.byt $41, $43, $43, $43, $43, $43, $43, $43
; Tile mask 8
.byt $7e, $7c, $78, $78, $78, $70, $60, $40
; Tile mask 9
.byt $43, $41, $41, $43, $43, $43, $47, $43
; Tile mask 10
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 11
.byt $41, $41, $41, $41, $41, $40, $40, $40
; Tile mask 12
.byt $7f, $7f, $7f, $7f, $7f, $7f, $5f, $7f
; Tile mask 13
.byt $60, $70, $70, $70, $70, $70, $70, $70
; Tile mask 14
.byt $41, $43, $47, $47, $47, $47, $47, $43
; Tile mask 15
.byt $7c, $78, $78, $7c, $7c, $7c, $7e, $7c
; Tile mask 16
.byt $47, $43, $41, $41, $41, $40, $40, $40
; Tile mask 17
.byt $7f, $7f, $7f, $7f, $7f, $7f, $5f, $4f
; Tile mask 18
.byt $78, $78, $78, $78, $78, $70, $60, $70
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $4f, $4f, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 21
.byt $78, $7e, $7e, $7c, $7c, $78, $60, $60
; Tile mask 22
.byt $40, $40, $41, $40, $40, $40, $48, $50
; Tile mask 23
.byt $5f, $7f, $7f, $7f, $5f, $5f, $4f, $4f
; Tile mask 24
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7e, $7c
; Tile mask 25
.byt $78, $70, $60, $60, $60, $40, $40, $40
; Tile mask 26
.byt $4f, $47, $47, $4f, $4f, $4f, $5f, $4f
; Tile mask 27
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 28
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $47, $47, $47, $47, $47, $43, $41, $43
; Tile mask 30
.byt $7e, $7f, $7f, $7f, $7e, $7e, $7c, $7c
; Tile mask 31
.byt $40, $40, $60, $40, $40, $40, $44, $42
; Tile mask 32
.byt $47, $5f, $5f, $4f, $4f, $47, $41, $41
; Tile mask 33
.byt $60, $70, $78, $78, $7c, $7c, $7e, $7c
; Tile mask 34
.byt $41, $43, $47, $47, $4f, $4f, $5f, $4f
; Tile mask 35
.byt $78, $78, $78, $70, $70, $70, $60, $40
; Tile mask 36
.byt $40, $40, $40, $50, $58, $5c, $7e, $7c
; Tile mask 37
.byt $5f, $5f, $5f, $4f, $47, $47, $47, $47
; Tile mask 38
.byt $7e, $7e, $7e, $7c, $78, $78, $78, $78
; Tile mask 39
.byt $40, $40, $40, $42, $46, $4e, $5f, $4f
; Tile mask 40
.byt $47, $47, $47, $43, $43, $43, $41, $40
; Tile mask 41
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7e, $7e
; Tile mask 42
.byt $70, $78, $70, $70, $60, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $41, $43
; Tile mask 44
.byt $7e, $7e, $7e, $7c, $7e, $7f, $7f, $7f
; Tile mask 45
.byt $43, $43, $43, $43, $47, $7f, $7f, $7f
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $60, $70
; Tile mask 47
.byt $43, $47, $43, $43, $41, $40, $40, $40
; Tile mask 48
.byt $7f, $7f, $7f, $7f, $7f, $7f, $5f, $5f
; Tile mask 49
.byt $70, $70, $70, $70, $78, $7f, $7f, $7f
; Tile mask 50
.byt $5f, $5f, $5f, $4f, $5f, $7f, $7f, $7f
; Tile mask 51
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $79
; Tile mask 52
.byt $7f, $60, $40, $40, $60, $60, $60, $70
; Tile mask 53
.byt $7f, $7f, $5f, $4f, $4f, $47, $47, $43
; Tile mask 54
.byt $7f, $7f, $7f, $7a, $70, $70, $70, $70
; Tile mask 55
.byt $70, $60, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $78, $50, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $43, $43, $41, $41, $41, $41, $40, $40
; Tile mask 58
.byt $7f, $7f, $7e, $7c, $7c, $78, $78, $70
; Tile mask 59
.byt $7f, $41, $40, $40, $41, $41, $41, $43
; Tile mask 60
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $67
; Tile mask 61
.byt $70, $70, $60, $60, $60, $60, $40, $40
; Tile mask 62
.byt $47, $42, $40, $40, $40, $40, $40, $40
; Tile mask 63
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 64
.byt $7f, $7f, $7f, $57, $43, $43, $43, $43
; Tile mask 65
.byt $7f, $7f, $7f, $6f, $40, $40, $40, $40
; Tile mask 66
.byt $7f, $7f, $7f, $60, $40, $40, $40, $40
; Tile mask 67
.byt $7f, $7f, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $7d, $40, $40, $40, $40, $40, $40, $41
; Tile mask 69
.byt $6f, $40, $40, $40, $40, $40, $40, $60
; Tile mask 70
.byt $7f, $7f, $40, $40, $40, $40, $40, $40
; Tile mask 71
.byt $7f, $7f, $7f, $41, $40, $40, $40, $40
; Tile mask 72
.byt $7f, $7f, $7f, $7d, $40, $40, $40, $40
; Tile mask 73
.byt $70, $70, $78, $7e, $7f, $7f, $7f, $7f
; Tile mask 74
.byt $40, $40, $40, $40, $40, $68, $78, $78
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $70, $60, $60, $60, $60, $60, $60, $40
; Tile mask 77
.byt $40, $40, $60, $60, $60, $60, $60, $40
; Tile mask 78
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 79
.byt $40, $40, $40, $40, $40, $45, $47, $47
; Tile mask 80
.byt $43, $43, $47, $5f, $7f, $7f, $7f, $7f
; Tile mask 81
.byt $40, $40, $41, $41, $41, $41, $41, $40
; Tile mask 82
.byt $43, $41, $41, $41, $41, $41, $41, $40
; Tile mask 83
.byt $7f, $7f, $7f, $7f, $7f, $60, $40, $40
; Tile mask 84
.byt $70, $60, $60, $70, $70, $40, $40, $40
; Tile mask 85
.byt $40, $60, $7e, $7f, $7f, $7f, $7f, $7f
; Tile mask 86
.byt $40, $40, $40, $40, $78, $78, $78, $78
; Tile mask 87
.byt $43, $41, $41, $43, $43, $40, $40, $40
; Tile mask 88
.byt $7f, $7f, $7f, $7f, $7f, $41, $40, $40
; Tile mask 89
.byt $40, $40, $40, $40, $47, $47, $47, $47
; Tile mask 90
.byt $40, $41, $5f, $7f, $7f, $7f, $7f, $7f
; Tile mask 91
.byt $71, $60, $60, $61, $61, $60, $70, $78
; Tile mask 92
.byt $70, $60, $60, $70, $70, $70, $48, $40
; Tile mask 93
.byt $7c, $7e, $7f, $7f, $7f, $7f, $7f, $7f
; Tile mask 94
.byt $40, $40, $40, $60, $60, $60, $60, $70
; Tile mask 95
.byt $70, $70, $78, $78, $78, $78, $78, $70
; Tile mask 96
.byt $43, $41, $41, $43, $43, $43, $44, $40
; Tile mask 97
.byt $63, $41, $41, $61, $61, $41, $43, $47
; Tile mask 98
.byt $40, $40, $40, $41, $41, $41, $41, $43
; Tile mask 99
.byt $4f, $5f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile mask 100
.byt $43, $43, $47, $47, $47, $47, $47, $43
; Tile mask 101
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7c
; Tile mask 102
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $4f
; Tile mask 103
.byt $78, $78, $78, $78, $78, $78, $78, $78
; Tile mask 104
.byt $40, $40, $40, $40, $40, $40, $48, $40
; Tile mask 105
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7c
; Tile mask 106
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $4f
; Tile mask 107
.byt $40, $40, $40, $40, $40, $40, $44, $40
; Tile mask 108
.byt $47, $47, $47, $47, $47, $47, $47, $47
; Tile mask 109
.byt $7e, $7c, $78, $78, $70, $78, $7c, $7f
; Tile mask 110
.byt $40, $40, $40, $40, $40, $40, $70, $70
; Tile mask 111
.byt $40, $40, $40, $40, $41, $41, $41, $41
; Tile mask 112
.byt $7f, $5f, $5f, $7f, $7f, $7f, $7f, $7f
; Tile mask 113
.byt $43, $43, $43, $43, $43, $43, $43, $43
; Tile mask 114
.byt $7f, $7e, $7e, $7f, $7f, $7f, $7f, $7f
; Tile mask 115
.byt $40, $40, $40, $40, $60, $60, $60, $60
; Tile mask 116
.byt $40, $40, $40, $40, $40, $40, $43, $43
; Tile mask 117
.byt $5f, $4f, $47, $47, $43, $47, $4f, $7f
; Tile mask 118
.byt $70, $70, $70, $70, $70, $70, $70, $70
; Tile mask 119
.byt $7f, $7f, $7f, $70, $60, $60, $60, $40
; Tile mask 120
.byt $70, $60, $60, $40, $40, $40, $40, $40
; Tile mask 121
.byt $5f, $4f, $47, $47, $47, $43, $41, $40
; Tile mask 122
.byt $40, $60, $77, $7f, $7f, $7f, $7f, $7f
; Tile mask 123
.byt $40, $40, $60, $60, $60, $60, $60, $60
; Tile mask 124
.byt $40, $40, $40, $41, $41, $41, $41, $41
; Tile mask 125
.byt $5f, $5f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile mask 126
.byt $7e, $7c, $78, $78, $78, $70, $60, $40
; Tile mask 127
.byt $43, $41, $41, $40, $40, $40, $40, $40
; Tile mask 128
.byt $7f, $7f, $7f, $43, $41, $41, $41, $40
; Tile mask 129
.byt $7e, $7e, $7f, $7f, $7f, $7f, $7f, $7f
; Tile mask 130
.byt $40, $40, $40, $60, $60, $60, $60, $60
; Tile mask 131
.byt $40, $40, $41, $41, $41, $41, $41, $41
; Tile mask 132
.byt $40, $41, $7b, $7f, $7f, $7f, $7f, $7f
; Tile mask 133
.byt $7c, $78, $70, $70, $70, $70, $70, $70
; Tile mask 134
.byt $4f, $43, $41, $41, $41, $43, $43, $41
; Tile mask 135
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 136
.byt $7c, $70, $60, $60, $60, $70, $70, $60
; Tile mask 137
.byt $4f, $47, $43, $43, $43, $43, $43, $43
; Tile mask 138
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 139
.byt $7f, $7e, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 140
.byt $43, $40, $40, $40, $40, $40, $40, $40
; Tile mask 141
.byt $7f, $7f, $5f, $5f, $5f, $7f, $7f, $5f
; Tile mask 142
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 143
.byt $7f, $7f, $7e, $7e, $7e, $7f, $7f, $7e
; Tile mask 144
.byt $70, $40, $40, $40, $40, $40, $40, $40
; Tile mask 145
.byt $7f, $5f, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 146
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 147
.byt $7f, $78, $70, $60, $60, $60, $60, $60
; Tile mask 148
.byt $7f, $5f, $47, $43, $43, $43, $43, $47
; Tile mask 149
.byt $7f, $7e, $78, $70, $70, $70, $70, $78
; Tile mask 150
.byt $7f, $47, $43, $41, $41, $41, $41, $41
; Tile mask 151
.byt $7f, $7f, $42, $40, $40, $40, $40, $40
; Tile mask 152
.byt $7f, $73, $41, $40, $40, $40, $40, $41
; Tile mask 153
.byt $7f, $73, $60, $40, $40, $40, $40, $60
; Tile mask 154
.byt $7f, $7f, $50, $40, $40, $40, $40, $40
; Tile mask 155
.byt $78, $60, $60, $60, $60, $60, $60, $70
; Tile mask 156
.byt $5f, $4f, $47, $47, $47, $43, $41, $40
; Tile mask 157
.byt $7e, $7c, $78, $78, $78, $70, $60, $40
; Tile mask 158
.byt $47, $41, $41, $41, $41, $41, $41, $43
; Tile mask 159
.byt $7e, $7c, $78, $78, $78, $78, $78, $7c
; Tile mask 160
.byt $47, $43, $41, $41, $41, $40, $40, $40
; Tile mask 161
.byt $78, $7e, $7e, $7c, $7c, $78, $70, $60
; Tile mask 162
.byt $78, $70, $60, $60, $60, $40, $40, $40
; Tile mask 163
.byt $5f, $4f, $47, $47, $47, $47, $47, $4f
; Tile mask 164
.byt $47, $5f, $5f, $4f, $4f, $47, $43, $41
; Tile mask 165
.byt $7f, $70, $60, $40, $40, $40, $40, $40
; Tile mask 166
.byt $7f, $7f, $5f, $4f, $4f, $4f, $47, $43
; Tile mask 167
.byt $7f, $7f, $7e, $7c, $7c, $7c, $78, $70
; Tile mask 168
.byt $7f, $43, $41, $40, $40, $40, $40, $40
; Tile mask 169
.byt $7f, $7e, $40, $40, $40, $40, $40, $40
; Tile mask 170
.byt $7f, $43, $41, $40, $40, $40, $40, $41
; Tile mask 171
.byt $7f, $70, $60, $40, $40, $40, $40, $60
; Tile mask 172
.byt $7f, $5f, $40, $40, $40, $40, $40, $40
; Tile mask 173
.byt $78, $60, $60, $60, $60, $40, $40, $40
; Tile mask 174
.byt $47, $41, $41, $41, $41, $40, $40, $40
; Tile mask 175
.byt $78, $60, $60, $60, $60, $60, $40, $40
; Tile mask 176
.byt $47, $41, $41, $41, $41, $41, $40, $40
; Tile mask 177
.byt $48, $40, $40, $40, $40, $40, $40, $40
; Tile mask 178
.byt $44, $40, $40, $40, $40, $40, $40, $40
; Tile mask 179
.byt $78, $60, $60, $70, $70, $70, $70, $70
; Tile mask 180
.byt $4f, $47, $43, $43, $43, $47, $41, $40
; Tile mask 181
.byt $7c, $78, $70, $70, $70, $78, $60, $40
; Tile mask 182
.byt $47, $41, $41, $43, $43, $43, $43, $43
; Tile mask 183
.byt $7e, $78, $78, $7c, $7c, $7c, $7c, $7c
; Tile mask 184
.byt $43, $41, $40, $40, $40, $41, $40, $40
; Tile mask 185
.byt $70, $60, $40, $40, $40, $60, $40, $40
; Tile mask 186
.byt $5f, $47, $47, $4f, $4f, $4f, $4f, $4f
; Tile mask 187
.byt $7f, $70, $60, $40, $60, $60, $60, $60
; Tile mask 188
.byt $7f, $5f, $4f, $47, $47, $47, $47, $43
; Tile mask 189
.byt $7f, $7e, $7c, $78, $78, $78, $78, $70
; Tile mask 190
.byt $7f, $43, $41, $40, $41, $41, $41, $41
; Tile mask 191
.byt $7f, $7c, $40, $40, $40, $40, $40, $40
; Tile mask 192
.byt $7d, $40, $40, $40, $40, $40, $41, $41
; Tile mask 193
.byt $6f, $40, $40, $40, $40, $40, $60, $60
; Tile mask 194
.byt $7f, $4f, $40, $40, $40, $40, $40, $40
; Tile mask 195
.byt $78, $60, $60, $60, $60, $60, $40, $40
; Tile mask 196
.byt $47, $41, $41, $41, $41, $41, $40, $40
; Tile mask 197
.byt $48, $40, $40, $40, $40, $40, $40, $40
; Tile mask 198
.byt $44, $40, $40, $40, $40, $40, $40, $40
; Tile mask 199
.byt $78, $60, $60, $40, $40, $40, $40, $40
; Tile mask 200
.byt $4f, $47, $43, $43, $43, $43, $41, $40
; Tile mask 201
.byt $7c, $78, $70, $70, $70, $70, $60, $40
; Tile mask 202
.byt $47, $41, $41, $40, $40, $40, $40, $40
; Tile mask 203
.byt $7f, $7f, $7f, $78, $70, $70, $70, $70
; Tile mask 204
.byt $7f, $7f, $7f, $5f, $4f, $47, $47, $43
; Tile mask 205
.byt $78, $70, $70, $70, $70, $60, $40, $60
; Tile mask 206
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 207
.byt $7f, $7f, $7f, $7e, $7c, $78, $78, $70
; Tile mask 208
.byt $7f, $7f, $7f, $47, $43, $43, $43, $43
; Tile mask 209
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 210
.byt $47, $43, $43, $43, $43, $41, $40, $41
; Tile mask 211
.byt $7f, $7f, $7f, $7e, $7c, $7c, $7c, $7c
; Tile mask 212
.byt $7f, $7f, $7f, $47, $43, $41, $41, $40
; Tile mask 213
.byt $7e, $7c, $7c, $7c, $7c, $78, $70, $78
; Tile mask 214
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 215
.byt $5f, $4f, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 216
.byt $7c, $7e, $7e, $7c, $7c, $78, $70, $60
; Tile mask 217
.byt $7f, $7f, $7f, $78, $70, $60, $60, $40
; Tile mask 218
.byt $7f, $7f, $7f, $5f, $4f, $4f, $4f, $4f
; Tile mask 219
.byt $7e, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 220
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 221
.byt $5f, $4f, $4f, $4f, $4f, $47, $43, $47
; Tile mask 222
.byt $4f, $5f, $5f, $4f, $4f, $47, $43, $41
; Tile mask 223
.byt $70, $70, $78, $78, $7c, $7c, $7e, $7c
; Tile mask 224
.byt $43, $43, $47, $47, $4f, $4f, $5f, $4f
; Tile mask 225
.byt $7f, $7f, $7f, $5f, $4f, $47, $47, $47
; Tile mask 226
.byt $78, $7c, $78, $70, $70, $60, $40, $40
; Tile mask 227
.byt $43, $41, $41, $41, $41, $41, $43, $47
; Tile mask 228
.byt $7f, $7f, $7f, $7e, $7f, $7f, $7f, $7f
; Tile mask 229
.byt $41, $41, $41, $41, $43, $7f, $7f, $7f
; Tile mask 230
.byt $7f, $7f, $7f, $7e, $7c, $78, $78, $78
; Tile mask 231
.byt $70, $60, $60, $60, $60, $60, $70, $78
; Tile mask 232
.byt $47, $4f, $47, $43, $43, $41, $40, $40
; Tile mask 233
.byt $60, $60, $60, $60, $70, $7f, $7f, $7f
; Tile mask 234
.byt $7f, $7f, $7f, $5f, $7f, $7f, $7f, $7f
; Tile mask 235
.byt $78, $70, $70, $70, $70, $40, $40, $40
; Tile mask 236
.byt $5f, $4f, $47, $47, $47, $47, $43, $43
; Tile mask 237
.byt $7e, $7e, $7c, $7c, $70, $60, $60, $78
; Tile mask 238
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 239
.byt $43, $43, $43, $43, $43, $43, $43, $47
; Tile mask 240
.byt $7e, $7c, $78, $78, $78, $78, $70, $70
; Tile mask 241
.byt $47, $43, $43, $43, $43, $40, $40, $40
; Tile mask 242
.byt $70, $70, $70, $70, $70, $70, $70, $78
; Tile mask 243
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 244
.byt $5f, $5f, $4f, $4f, $43, $41, $41, $47
; Tile mask 245
.byt $7f, $7f, $7f, $7b, $70, $70, $70, $70
; Tile mask 246
.byt $7f, $7f, $7f, $78, $40, $40, $40, $40
; Tile mask 247
.byt $7f, $7f, $7f, $40, $40, $40, $40, $40
; Tile mask 248
.byt $7f, $61, $40, $40, $40, $40, $40, $41
; Tile mask 249
.byt $7f, $61, $40, $40, $40, $40, $40, $60
; Tile mask 250
.byt $7f, $7f, $7f, $40, $40, $40, $40, $40
; Tile mask 251
.byt $7f, $7f, $7f, $47, $40, $40, $40, $40
; Tile mask 252
.byt $7f, $7f, $7f, $77, $43, $43, $43, $43
; Tile mask 253
.byt $7b, $71, $60, $71, $7b, $7f, $7f, $7f
; Tile mask 254
.byt $77, $63, $41, $63, $77, $7f, $7f, $7f
end_children_masks

.dsb 256-(*&255)
; Locations for goto random location script
tab_locs
	.byt D_LIBRARY
	.byt D_FIRE_ESCAPE
	.byt D_GYM
	.byt D_BIG_WINDOW


; teachers, group 1
teacher_tiles 
; Tile graphic 1
.byt $0, $1, $2, $4, $6, $4, $3, $2
; Tile graphic 2
.byt $0, $38, $4, $e, $2a, $e, $17, $7
; Tile graphic 3
.byt $0, $0, $0, $0, $0, $0, $30, $38
; Tile graphic 4
.byt $3, $7, $7, $7, $7, $7, $7, $5
; Tile graphic 5
.byt $33, $37, $3b, $b, $23, $23, $33, $33
; Tile graphic 6
.byt $3c, $34, $34, $24, $26, $26, $26, $26
; Tile graphic 7
.byt $5, $7, $7, $1, $1, $1, $1, $1
; Tile graphic 8
.byt $3b, $34, $38, $37, $35, $35, $35, $35
; Tile graphic 9
.byt $6, $2e, $1e, $3e, $1e, $1e, $1e, $1e
; Tile graphic 10
.byt $1, $1, $1, $1, $0, $0, $0, $0
; Tile graphic 11
.byt $35, $35, $3d, $3d, $d, $5, $5, $d
; Tile graphic 12
.byt $1e, $1e, $1c, $1c, $8, $8, $38, $38
; Tile graphic 13
.byt $0, $0, $0, $0, $0, $0, $3, $7
; Tile graphic 14
.byt $0, $7, $8, $1c, $15, $1c, $3a, $38
; Tile graphic 15
.byt $0, $20, $10, $8, $18, $8, $30, $10
; Tile graphic 16
.byt $f, $b, $b, $9, $19, $19, $19, $19
; Tile graphic 17
.byt $33, $3b, $37, $34, $31, $31, $33, $33
; Tile graphic 18
.byt $30, $38, $38, $38, $38, $38, $38, $28
; Tile graphic 19
.byt $18, $1d, $1e, $1f, $1e, $1e, $1e, $1e
; Tile graphic 20
.byt $37, $b, $7, $3b, $2b, $2b, $2b, $2b
; Tile graphic 21
.byt $28, $38, $38, $20, $20, $20, $20, $20
; Tile graphic 22
.byt $1e, $1e, $e, $e, $4, $4, $7, $7
; Tile graphic 23
.byt $2b, $2b, $2f, $2f, $2c, $28, $28, $2c
; Tile graphic 24
.byt $20, $20, $20, $20, $0, $0, $0, $0
; Tile graphic 25
.byt $0, $0, $0, $1, $1, $1, $0, $0
; Tile graphic 26
.byt $0, $1e, $21, $3, $2a, $3, $35, $21
; Tile graphic 27
.byt $0, $0, $0, $20, $20, $20, $3c, $3e
; Tile graphic 28
.byt $0, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 29
.byt $3c, $3d, $3e, $32, $38, $38, $3c, $1c
; Tile graphic 30
.byt $3f, $3d, $3d, $39, $39, $39, $39, $39
; Tile graphic 31
.byt $0, $0, $0, $0, $20, $20, $20, $20
; Tile graphic 32
.byt $1, $1, $1, $0, $0, $0, $0, $0
; Tile graphic 33
.byt $1e, $3d, $3e, $1d, $1d, $1d, $1d, $1d
; Tile graphic 34
.byt $31, $b, $7, $3f, $17, $17, $17, $17
; Tile graphic 35
.byt $20, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 36
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 37
.byt $1b, $19, $19, $19, $9, $9, $1f, $3f
; Tile graphic 38
.byt $17, $1f, $17, $16, $12, $11, $13, $17
; Tile graphic 39
.byt $20, $20, $20, $10, $10, $30, $20, $0
; Tile graphic 40
.byt $0, $0, $0, $1, $1, $1, $f, $1f
; Tile graphic 41
.byt $0, $1e, $21, $30, $15, $30, $2b, $21
; Tile graphic 42
.byt $0, $0, $0, $20, $20, $20, $0, $0
; Tile graphic 43
.byt $0, $0, $0, $0, $1, $1, $1, $1
; Tile graphic 44
.byt $3f, $2f, $2f, $27, $27, $27, $27, $27
; Tile graphic 45
.byt $f, $2f, $1f, $13, $7, $7, $f, $e
; Tile graphic 46
.byt $0, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 47
.byt $1, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 48
.byt $23, $34, $38, $3f, $3a, $3a, $3a, $3a
; Tile graphic 49
.byt $1e, $2f, $1f, $2e, $2e, $2e, $2e, $2e
; Tile graphic 50
.byt $20, $20, $20, $0, $0, $0, $0, $0
; Tile graphic 51
.byt $1, $1, $1, $2, $2, $3, $1, $0
; Tile graphic 52
.byt $3a, $3e, $3a, $1a, $12, $22, $32, $3a
; Tile graphic 53
.byt $36, $26, $26, $26, $24, $24, $3e, $3f
; Tile graphic 54
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 55
.byt $1, $1, $1, $1, $0, $0, $1, $3
; Tile graphic 56
.byt $35, $25, $25, $25, $25, $25, $3d, $3d
; Tile graphic 57
.byt $1e, $1e, $1c, $1c, $8, $8, $30, $30
; Tile graphic 58
.byt $1e, $1e, $e, $e, $4, $4, $3, $3
; Tile graphic 59
.byt $2b, $29, $29, $29, $29, $29, $2f, $2f
; Tile graphic 60
.byt $20, $20, $20, $20, $0, $0, $20, $30
; Tile graphic 61
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 62
.byt $0, $1, $2, $4, $6, $4, $3, $22
; Tile graphic 63
.byt $13, $f, $1f, $37, $13, $9, $9, $5
; Tile graphic 64
.byt $7, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 65
.byt $0, $20, $10, $8, $18, $8, $30, $11
; Tile graphic 66
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 67
.byt $32, $3c, $3e, $3b, $32, $24, $24, $28
; Tile graphic 68
.byt $38, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 69
.byt $0, $0, $0, $20, $10, $8, $4, $2
; Tile graphic 70
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 71
.byt $0, $0, $0, $0, $0, $1e, $21, $3
; Tile graphic 72
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 73
.byt $1, $1, $1, $0, $0, $1, $0, $0
; Tile graphic 74
.byt $31, $9, $8, $34, $35, $12, $8, $7
; Tile graphic 75
.byt $2a, $3, $35, $21, $3e, $3e, $3b, $3b
; Tile graphic 76
.byt $20, $20, $20, $30, $10, $8, $8, $28
; Tile graphic 77
.byt $0, $0, $10, $18, $1f, $1c, $1c, $1f
; Tile graphic 78
.byt $0, $0, $0, $3, $3c, $3, $f, $3f
; Tile graphic 79
.byt $1a, $1b, $3a, $36, $e, $1f, $3f, $3f
; Tile graphic 80
.byt $24, $24, $34, $32, $2a, $2e, $29, $1e
; Tile graphic 81
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 82
.byt $0, $0, $0, $0, $0, $1e, $21, $30
; Tile graphic 83
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 84
.byt $0, $0, $0, $1, $2, $4, $8, $10
; Tile graphic 85
.byt $1, $1, $1, $3, $2, $4, $4, $5
; Tile graphic 86
.byt $15, $30, $2b, $21, $1f, $1f, $37, $37
; Tile graphic 87
.byt $23, $24, $4, $b, $2b, $12, $4, $38
; Tile graphic 88
.byt $20, $20, $20, $0, $0, $20, $0, $0
; Tile graphic 89
.byt $9, $9, $b, $13, $15, $1d, $25, $1e
; Tile graphic 90
.byt $16, $36, $17, $1b, $1c, $3e, $3f, $3f
; Tile graphic 91
.byt $0, $0, $0, $30, $f, $30, $3c, $3f
; Tile graphic 92
.byt $0, $0, $2, $6, $3e, $e, $e, $3e
; Tile graphic 93
.byt $0, $1, $0, $2, $5, $2, $2, $3
; Tile graphic 94
.byt $0, $30, $c, $2e, $1a, $22, $4, $36
; Tile graphic 95
.byt $1, $3, $6, $4, $4, $4, $4, $6
; Tile graphic 96
.byt $2f, $3e, $38, $12, $17, $11, $31, $15
; Tile graphic 97
.byt $0, $20, $10, $8, $8, $8, $28, $8
; Tile graphic 98
.byt $4, $4, $6, $2, $2, $2, $3, $3
; Tile graphic 99
.byt $12, $22, $21, $11, $30, $38, $18, $17
; Tile graphic 100
.byt $18, $10, $30, $10, $10, $10, $10, $20
; Tile graphic 101
.byt $1, $1, $1, $1, $1, $3, $6, $4
; Tile graphic 102
.byt $8, $8, $8, $8, $8, $2e, $3b, $10
; Tile graphic 103
.byt $0, $3, $c, $1d, $16, $11, $8, $1b
; Tile graphic 104
.byt $0, $20, $0, $10, $28, $10, $10, $30
; Tile graphic 105
.byt $0, $1, $2, $4, $4, $4, $5, $4
; Tile graphic 106
.byt $3d, $1f, $7, $12, $3a, $22, $23, $2a
; Tile graphic 107
.byt $20, $30, $18, $8, $8, $8, $8, $18
; Tile graphic 108
.byt $6, $2, $3, $2, $2, $2, $2, $1
; Tile graphic 109
.byt $12, $11, $21, $22, $3, $7, $6, $3a
; Tile graphic 110
.byt $8, $8, $18, $10, $10, $10, $30, $30
; Tile graphic 111
.byt $4, $4, $4, $4, $4, $1d, $37, $2
; Tile graphic 112
.byt $20, $20, $20, $20, $20, $30, $18, $8
; Tile graphic 113
.byt $0, $0, $0, $0, $1, $0, $0, $0
; Tile graphic 114
.byt $0, $1c, $3, $2b, $16, $29, $21, $3d
; Tile graphic 115
.byt $0, $0, $0, $20, $20, $0, $0, $20
; Tile graphic 116
.byt $0, $0, $1, $1, $1, $1, $1, $1
; Tile graphic 117
.byt $1b, $3f, $2e, $4, $5, $4, $c, $25
; Tile graphic 118
.byt $30, $28, $4, $22, $32, $12, $1a, $12
; Tile graphic 119
.byt $1, $1, $1, $0, $0, $0, $0, $0
; Tile graphic 120
.byt $4, $9, $28, $24, $2c, $2e, $3c, $35
; Tile graphic 121
.byt $26, $4, $1c, $14, $4, $4, $4, $38
; Tile graphic 122
.byt $0, $1, $1, $1, $1, $3, $6, $4
; Tile graphic 123
.byt $25, $8, $8, $8, $10, $30, $10, $10
; Tile graphic 124
.byt $8, $24, $22, $11, $9, $7, $5, $8
; Tile graphic 125
.byt $0, $0, $0, $0, $20, $20, $20, $20
; Tile graphic 126
.byt $0, $0, $0, $1, $1, $0, $0, $1
; Tile graphic 127
.byt $0, $e, $30, $35, $1a, $25, $21, $2f
; Tile graphic 128
.byt $0, $0, $0, $0, $20, $0, $0, $0
; Tile graphic 129
.byt $3, $5, $8, $11, $13, $12, $16, $12
; Tile graphic 130
.byt $36, $3f, $1d, $8, $28, $8, $c, $29
; Tile graphic 131
.byt $0, $0, $20, $20, $20, $20, $20, $20
; Tile graphic 132
.byt $19, $8, $e, $a, $8, $8, $8, $7
; Tile graphic 133
.byt $8, $24, $5, $9, $d, $1d, $f, $2b
; Tile graphic 134
.byt $20, $20, $20, $0, $0, $0, $0, $0
; Tile graphic 135
.byt $0, $0, $0, $0, $1, $1, $1, $1
; Tile graphic 136
.byt $4, $9, $11, $22, $24, $38, $28, $4
; Tile graphic 137
.byt $29, $4, $4, $4, $2, $3, $2, $2
; Tile graphic 138
.byt $0, $20, $20, $20, $20, $30, $18, $8
; Tile graphic 139
.byt $2, $1, $1, $1, $0, $1, $3, $4
; Tile graphic 140
.byt $11, $11, $11, $11, $31, $3d, $17, $21
; Tile graphic 141
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 142
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 143
.byt $22, $22, $22, $22, $23, $2f, $3a, $21
; Tile graphic 144
.byt $10, $20, $20, $20, $0, $20, $30, $8
; Tile graphic 145
.byt $14, $18, $8, $8, $9, $1d, $17, $21
; Tile graphic 146
.byt $10, $30, $38, $34, $3e, $12, $14, $38
; Tile graphic 147
.byt $2, $3, $7, $b, $1f, $12, $a, $7
; Tile graphic 148
.byt $a, $6, $4, $4, $24, $2e, $3a, $21
; Tile graphic 149
.byt $1, $2, $2, $2, $1, $1, $0, $0
; Tile graphic 150
.byt $1, $27, $18, $38, $2a, $2a, $22, $22
; Tile graphic 151
.byt $16, $e, $2, $2, $2, $2, $3, $3
; Tile graphic 152
.byt $20, $39, $6, $7, $15, $15, $11, $11
; Tile graphic 153
.byt $20, $10, $10, $10, $20, $20, $0, $0
; Tile graphic 154
.byt $1a, $1c, $10, $10, $10, $10, $30, $30
; Tile graphic 155
.byt $0, $0, $0, $0, $0, $1, $6, $4
; Tile graphic 156
.byt $0, $0, $0, $e, $1a, $3e, $11, $15
; Tile graphic 157
.byt $0, $0, $0, $0, $0, $0, $20, $30
; Tile graphic 158
.byt $4, $4, $4, $2, $2, $1, $0, $0
; Tile graphic 159
.byt $2b, $15, $10, $1d, $a, $c, $3d, $3f
; Tile graphic 160
.byt $10, $10, $20, $30, $10, $8, $8, $8
; Tile graphic 161
.byt $0, $0, $0, $0, $0, $0, $1, $3
; Tile graphic 162
.byt $0, $0, $0, $1c, $16, $1f, $22, $2a
; Tile graphic 163
.byt $0, $0, $0, $0, $0, $20, $18, $8
; Tile graphic 164
.byt $2, $2, $1, $3, $2, $4, $4, $4
; Tile graphic 165
.byt $35, $2a, $2, $2e, $14, $c, $2f, $3f
; Tile graphic 166
.byt $8, $8, $8, $10, $10, $20, $0, $0
; Tile graphic 167
.byt $0, $3, $4, $4, $6, $4, $6, $7
; Tile graphic 168
.byt $0, $30, $8, $1c, $3c, $1c, $3c, $38
; Tile graphic 169
.byt $b, $f, $16, $16, $16, $16, $10, $1e
; Tile graphic 170
.byt $27, $3f, $3b, $3b, $3b, $3b, $1b, $23
; Tile graphic 171
.byt $0, $20, $10, $10, $10, $10, $10, $30
; Tile graphic 172
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 173
.byt $2e, $26, $1e, $f, $e, $e, $e, $e
; Tile graphic 174
.byt $39, $3a, $3b, $7, $3, $13, $13, $13
; Tile graphic 175
.byt $8, $8, $34, $34, $30, $30, $30, $30
; Tile graphic 176
.byt $e, $e, $e, $6, $2, $3, $7, $f
; Tile graphic 177
.byt $13, $11, $11, $39, $11, $37, $3f, $3f
; Tile graphic 178
.byt $30, $30, $30, $30, $0, $0, $0, $0
; Tile graphic 179
.byt $0, $3, $4, $e, $f, $e, $f, $7
; Tile graphic 180
.byt $0, $30, $8, $8, $18, $8, $18, $38
; Tile graphic 181
.byt $0, $1, $2, $2, $2, $2, $2, $3
; Tile graphic 182
.byt $39, $3f, $37, $37, $37, $37, $36, $31
; Tile graphic 183
.byt $34, $3c, $1a, $1a, $1a, $1a, $2, $1e
; Tile graphic 184
.byt $4, $4, $b, $b, $3, $3, $3, $3
; Tile graphic 185
.byt $27, $17, $37, $38, $30, $32, $32, $32
; Tile graphic 186
.byt $1d, $19, $1e, $3c, $1c, $1c, $1c, $1c
; Tile graphic 187
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 188
.byt $3, $3, $3, $3, $0, $0, $0, $0
; Tile graphic 189
.byt $32, $22, $22, $27, $22, $3b, $3f, $3f
; Tile graphic 190
.byt $1c, $1c, $1c, $18, $10, $30, $38, $3c
; Tile graphic 191
.byt $0, $3c, $2, $7, $2f, $7, $2f, $3e
; Tile graphic 192
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 193
.byt $2, $3, $5, $5, $5, $5, $5, $7
; Tile graphic 194
.byt $39, $3f, $e, $2e, $26, $2a, $2c, $2e
; Tile graphic 195
.byt $30, $38, $34, $34, $34, $34, $34, $3c
; Tile graphic 196
.byt $f, $9, $7, $3, $3, $3, $3, $3
; Tile graphic 197
.byt $2e, $2e, $2e, $31, $20, $24, $24, $24
; Tile graphic 198
.byt $12, $22, $3d, $3d, $3c, $3c, $3c, $3c
; Tile graphic 199
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 200
.byt $3, $3, $2, $2, $2, $7, $f, $1f
; Tile graphic 201
.byt $e, $f, $1f, $17, $10, $20, $20, $20
; Tile graphic 202
.byt $1c, $c, $4, $22, $12, $a, $e, $1e
; Tile graphic 203
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 204
.byt $0, $f, $10, $38, $3d, $38, $3d, $1f
; Tile graphic 205
.byt $3, $7, $b, $b, $b, $b, $b, $f
; Tile graphic 206
.byt $27, $3f, $1c, $1d, $19, $15, $d, $1d
; Tile graphic 207
.byt $10, $30, $28, $28, $28, $28, $28, $38
; Tile graphic 208
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 209
.byt $12, $11, $2f, $2f, $f, $f, $f, $f
; Tile graphic 210
.byt $1d, $1d, $1d, $23, $1, $9, $9, $9
; Tile graphic 211
.byt $3c, $24, $38, $30, $30, $30, $30, $30
; Tile graphic 212
.byt $e, $c, $8, $11, $12, $14, $1c, $1e
; Tile graphic 213
.byt $1c, $3c, $3e, $3a, $2, $1, $1, $1
; Tile graphic 214
.byt $30, $30, $10, $10, $10, $38, $3c, $3e
; Tile graphic 215
.byt $e, $f, $f, $7, $0, $1, $3, $7
; Tile graphic 216
.byt $13, $11, $11, $11, $31, $37, $3f, $3f
; Tile graphic 217
.byt $32, $22, $22, $22, $23, $3b, $3f, $3f
; Tile graphic 218
.byt $1c, $3c, $3c, $38, $0, $20, $30, $38
; Tile graphic 219
.byt $3, $3, $3, $1, $0, $0, $1, $1
; Tile graphic 220
.byt $28, $38, $39, $31, $11, $3e, $3c, $3c
; Tile graphic 221
.byt $3c, $3c, $3c, $1c, $3c, $1c, $18, $30
; Tile graphic 222
.byt $f, $f, $f, $e, $f, $e, $6, $3
; Tile graphic 223
.byt $5, $7, $27, $23, $22, $1f, $f, $f
; Tile graphic 224
.byt $30, $30, $30, $20, $0, $0, $20, $20
; Tile graphic 225
.byt $0, $0, $0, $0, $0, $0, $0, $2
; Tile graphic 226
.byt $5, $4, $5, $3, $2, $2, $1, $1
; Tile graphic 227
.byt $b, $2f, $36, $16, $16, $16, $0, $e
; Tile graphic 228
.byt $0, $0, $0, $0, $0, $0, $0, $10
; Tile graphic 229
.byt $34, $3d, $1b, $1a, $1a, $1a, $0, $1c
; Tile graphic 230
.byt $28, $8, $28, $30, $10, $10, $20, $20
; Tile graphic 231
.byt $0, $0, $0, $0, $1, $2, $4, $4
; Tile graphic 232
.byt $0, $0, $c, $12, $3f, $10, $11, $3b
; Tile graphic 233
.byt $0, $0, $0, $0, $0, $20, $30, $30
; Tile graphic 234
.byt $5, $4, $4, $2, $2, $1, $0, $0
; Tile graphic 235
.byt $31, $3b, $1e, $1f, $e, $1e, $3b, $3b
; Tile graphic 236
.byt $10, $10, $20, $30, $10, $8, $8, $28
; Tile graphic 237
.byt $0, $0, $0, $0, $0, $1, $3, $3
; Tile graphic 238
.byt $0, $0, $c, $12, $3f, $2, $22, $37
; Tile graphic 239
.byt $0, $0, $0, $0, $20, $10, $8, $8
; Tile graphic 240
.byt $2, $2, $1, $3, $2, $4, $4, $5
; Tile graphic 241
.byt $23, $37, $1e, $3e, $1c, $1e, $37, $37
; Tile graphic 242
.byt $28, $8, $8, $10, $10, $20, $0, $0
end_teacher_tiles

.dsb 256-(*&255)

tab_safecode
	.dsb 4		; The safe combination code
tab_safecodes
	.dsb 4		; The safe combination letters for the teachers:

teacher_masks
; Tile mask 1
.byt $7e, $7c, $78, $70, $70, $70, $78, $78
; Tile mask 2
.byt $47, $43, $41, $40, $40, $40, $40, $40
; Tile mask 3
.byt $7f, $7f, $7f, $7f, $7f, $4f, $47, $43
; Tile mask 4
.byt $78, $70, $70, $70, $70, $70, $70, $70
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $41, $41, $41, $41, $40, $40, $40, $40
; Tile mask 7
.byt $70, $70, $70, $78, $7c, $7c, $7c, $7c
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 10
.byt $7c, $7c, $7c, $7c, $7e, $7f, $7f, $7f
; Tile mask 11
.byt $40, $40, $40, $40, $40, $70, $70, $60
; Tile mask 12
.byt $40, $40, $41, $41, $43, $43, $43, $43
; Tile mask 13
.byt $7f, $7f, $7f, $7f, $7f, $7c, $78, $70
; Tile mask 14
.byt $78, $70, $60, $40, $40, $40, $40, $40
; Tile mask 15
.byt $5f, $4f, $47, $43, $43, $43, $47, $47
; Tile mask 16
.byt $60, $60, $60, $60, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $47, $43, $43, $43, $43, $43, $43, $43
; Tile mask 19
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $43, $43, $43, $47, $4f, $4f, $4f, $4f
; Tile mask 22
.byt $40, $40, $60, $60, $70, $70, $70, $70
; Tile mask 23
.byt $40, $40, $40, $40, $40, $43, $43, $41
; Tile mask 24
.byt $4f, $4f, $4f, $4f, $5f, $7f, $7f, $7f
; Tile mask 25
.byt $7f, $7f, $7e, $7c, $7c, $7c, $7e, $7e
; Tile mask 26
.byt $61, $40, $40, $40, $40, $40, $40, $40
; Tile mask 27
.byt $7f, $7f, $5f, $4f, $4f, $43, $41, $40
; Tile mask 28
.byt $7e, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 31
.byt $5f, $5f, $5f, $5f, $4f, $4f, $4f, $4f
; Tile mask 32
.byt $7c, $7c, $7c, $7e, $7f, $7f, $7f, $7f
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 34
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 35
.byt $4f, $4f, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 36
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7e
; Tile mask 37
.byt $40, $40, $40, $40, $60, $60, $40, $40
; Tile mask 38
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 39
.byt $4f, $4f, $4f, $47, $47, $47, $4f, $5f
; Tile mask 40
.byt $7f, $7f, $7e, $7c, $7c, $70, $60, $40
; Tile mask 41
.byt $61, $40, $40, $40, $40, $40, $40, $40
; Tile mask 42
.byt $7f, $7f, $5f, $4f, $4f, $4f, $5f, $5f
; Tile mask 43
.byt $7e, $7e, $7e, $7e, $7c, $7c, $7c, $7c
; Tile mask 44
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 45
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 46
.byt $5f, $4f, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 47
.byt $7c, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 48
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 49
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 50
.byt $4f, $4f, $4f, $5f, $7f, $7f, $7f, $7f
; Tile mask 51
.byt $7c, $7c, $7c, $78, $78, $78, $7c, $7e
; Tile mask 52
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 53
.byt $40, $40, $40, $40, $41, $41, $40, $40
; Tile mask 54
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $5f
; Tile mask 55
.byt $7c, $7c, $7c, $7c, $7e, $7e, $7c, $78
; Tile mask 56
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 57
.byt $40, $40, $41, $41, $43, $43, $47, $47
; Tile mask 58
.byt $40, $40, $60, $60, $70, $70, $78, $78
; Tile mask 59
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 60
.byt $4f, $4f, $4f, $4f, $5f, $5f, $4f, $47
; Tile mask 61
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $7c
; Tile mask 62
.byt $7e, $7c, $78, $70, $70, $70, $58, $48
; Tile mask 63
.byt $40, $40, $40, $40, $40, $60, $60, $70
; Tile mask 64
.byt $70, $78, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 65
.byt $5f, $4f, $47, $43, $43, $43, $46, $44
; Tile mask 66
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7f, $4f
; Tile mask 67
.byt $40, $40, $40, $40, $40, $41, $41, $43
; Tile mask 68
.byt $43, $47, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 69
.byt $7f, $7f, $5f, $4f, $47, $63, $71, $78
; Tile mask 70
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7e, $4c
; Tile mask 71
.byt $7f, $7f, $7f, $7f, $61, $40, $40, $40
; Tile mask 72
.byt $7f, $7f, $7f, $7f, $7f, $7f, $5f, $4f
; Tile mask 73
.byt $7c, $7c, $7c, $7e, $7e, $7c, $7e, $7f
; Tile mask 74
.byt $44, $40, $40, $40, $40, $40, $60, $70
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $4f, $4f, $4f, $47, $47, $43, $43, $43
; Tile mask 77
.byt $7f, $6f, $47, $40, $40, $40, $40, $40
; Tile mask 78
.byt $7f, $7f, $7c, $40, $40, $40, $40, $40
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $41, $41, $41, $40, $40, $40, $40, $40
; Tile mask 81
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7e, $7c
; Tile mask 82
.byt $7f, $7f, $7f, $7f, $61, $40, $40, $40
; Tile mask 83
.byt $7f, $7f, $7f, $7f, $7f, $7f, $5f, $4c
; Tile mask 84
.byt $7f, $7f, $7e, $7c, $78, $71, $63, $47
; Tile mask 85
.byt $7c, $7c, $7c, $78, $78, $70, $70, $70
; Tile mask 86
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 87
.byt $48, $40, $40, $40, $40, $40, $41, $43
; Tile mask 88
.byt $4f, $4f, $4f, $5f, $5f, $4f, $5f, $7f
; Tile mask 89
.byt $60, $60, $60, $40, $40, $40, $40, $40
; Tile mask 90
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 91
.byt $7f, $7f, $4f, $40, $40, $40, $40, $40
; Tile mask 92
.byt $7f, $7d, $78, $40, $40, $40, $40, $40
; Tile mask 93
.byt $7e, $7c, $7c, $78, $70, $78, $78, $78
; Tile mask 94
.byt $4f, $43, $41, $40, $40, $40, $41, $40
; Tile mask 95
.byt $7c, $78, $70, $70, $70, $70, $70, $70
; Tile mask 96
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 97
.byt $5f, $4f, $47, $43, $43, $43, $43, $43
; Tile mask 98
.byt $70, $70, $70, $78, $78, $78, $78, $78
; Tile mask 99
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 100
.byt $43, $47, $47, $47, $47, $47, $47, $4f
; Tile mask 101
.byt $7c, $7c, $7c, $7c, $7c, $78, $70, $70
; Tile mask 102
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 103
.byt $7c, $70, $60, $40, $40, $40, $60, $40
; Tile mask 104
.byt $5f, $4f, $4f, $47, $43, $47, $47, $47
; Tile mask 105
.byt $7e, $7c, $78, $70, $70, $70, $70, $70
; Tile mask 106
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 107
.byt $4f, $47, $43, $43, $43, $43, $43, $43
; Tile mask 108
.byt $70, $78, $78, $78, $78, $78, $78, $7c
; Tile mask 109
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 110
.byt $43, $43, $43, $47, $47, $47, $47, $47
; Tile mask 111
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 112
.byt $4f, $4f, $4f, $4f, $4f, $47, $43, $43
; Tile mask 113
.byt $7f, $7f, $7f, $7e, $7c, $7e, $7e, $7e
; Tile mask 114
.byt $63, $40, $40, $40, $40, $40, $40, $40
; Tile mask 115
.byt $7f, $7f, $5f, $4f, $4f, $4f, $5f, $4f
; Tile mask 116
.byt $7f, $7e, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 117
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 118
.byt $47, $43, $41, $40, $40, $40, $40, $40
; Tile mask 119
.byt $7c, $7c, $7c, $7e, $7e, $7e, $7e, $7e
; Tile mask 120
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 121
.byt $40, $41, $41, $41, $41, $41, $41, $43
; Tile mask 122
.byt $7e, $7c, $7c, $7c, $7c, $78, $70, $70
; Tile mask 123
.byt $40, $40, $42, $43, $47, $47, $47, $47
; Tile mask 124
.byt $43, $41, $40, $40, $60, $70, $70, $60
; Tile mask 125
.byt $7f, $7f, $7f, $5f, $4f, $4f, $4f, $4f
; Tile mask 126
.byt $7f, $7f, $7e, $7c, $7c, $7c, $7e, $7c
; Tile mask 127
.byt $71, $40, $40, $40, $40, $40, $40, $40
; Tile mask 128
.byt $7f, $7f, $7f, $5f, $4f, $5f, $5f, $5f
; Tile mask 129
.byt $78, $70, $60, $40, $40, $40, $40, $40
; Tile mask 130
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 131
.byt $7f, $5f, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 132
.byt $40, $60, $60, $60, $60, $60, $60, $70
; Tile mask 133
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 134
.byt $4f, $4f, $4f, $5f, $5f, $5f, $5f, $5f
; Tile mask 135
.byt $7f, $7f, $7f, $7e, $7c, $7c, $7c, $7c
; Tile mask 136
.byt $70, $60, $40, $40, $41, $43, $43, $41
; Tile mask 137
.byt $40, $40, $50, $70, $78, $78, $78, $78
; Tile mask 138
.byt $5f, $4f, $4f, $4f, $4f, $47, $43, $43
; Tile mask 139
.byt $78, $7c, $7c, $7c, $7e, $7c, $78, $70
; Tile mask 140
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 141
.byt $5f, $5f, $5f, $5f, $5f, $5f, $5f, $5f
; Tile mask 142
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7e, $7e
; Tile mask 143
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 144
.byt $47, $4f, $4f, $4f, $5f, $4f, $47, $43
; Tile mask 145
.byt $40, $40, $60, $60, $60, $40, $40, $40
; Tile mask 146
.byt $47, $47, $43, $41, $40, $40, $41, $43
; Tile mask 147
.byt $78, $78, $70, $60, $40, $40, $60, $70
; Tile mask 148
.byt $40, $40, $41, $41, $41, $40, $40, $40
; Tile mask 149
.byt $78, $78, $78, $78, $7c, $7c, $7e, $7e
; Tile mask 150
.byt $58, $40, $40, $40, $40, $40, $40, $40
; Tile mask 151
.byt $40, $60, $70, $78, $78, $78, $78, $78
; Tile mask 152
.byt $46, $40, $40, $40, $40, $40, $40, $40
; Tile mask 153
.byt $47, $47, $47, $47, $4f, $4f, $5f, $5f
; Tile mask 154
.byt $40, $41, $43, $47, $47, $47, $47, $47
; Tile mask 155
.byt $7f, $7f, $7f, $7f, $7e, $78, $70, $70
; Tile mask 156
.byt $7f, $7f, $71, $60, $40, $40, $40, $40
; Tile mask 157
.byt $7f, $7f, $7f, $7f, $7f, $5f, $4f, $47
; Tile mask 158
.byt $70, $70, $70, $78, $78, $7c, $7e, $7e
; Tile mask 159
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 160
.byt $47, $47, $4f, $47, $47, $43, $43, $43
; Tile mask 161
.byt $7f, $7f, $7f, $7f, $7f, $7e, $7c, $78
; Tile mask 162
.byt $7f, $7f, $63, $41, $40, $40, $40, $40
; Tile mask 163
.byt $7f, $7f, $7f, $7f, $5f, $47, $43, $43
; Tile mask 164
.byt $78, $78, $7c, $78, $78, $70, $70, $70
; Tile mask 165
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 166
.byt $43, $43, $43, $47, $47, $4f, $5f, $5f
; Tile mask 167
.byt $7c, $78, $70, $70, $70, $70, $70, $70
; Tile mask 168
.byt $4f, $47, $43, $41, $41, $41, $41, $40
; Tile mask 169
.byt $60, $60, $40, $40, $40, $40, $40, $40
; Tile mask 170
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 171
.byt $5f, $4f, $47, $47, $47, $47, $47, $47
; Tile mask 172
.byt $7e, $7e, $7f, $7f, $7f, $7f, $7f, $7f
; Tile mask 173
.byt $40, $40, $40, $60, $60, $60, $60, $60
; Tile mask 174
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 175
.byt $43, $43, $41, $41, $43, $47, $47, $47
; Tile mask 176
.byt $60, $60, $60, $70, $78, $78, $70, $60
; Tile mask 177
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 178
.byt $47, $47, $47, $47, $4f, $5f, $5f, $5f
; Tile mask 179
.byt $7c, $78, $70, $60, $60, $60, $60, $40
; Tile mask 180
.byt $4f, $47, $43, $43, $43, $43, $43, $43
; Tile mask 181
.byt $7e, $7c, $78, $78, $78, $78, $78, $78
; Tile mask 182
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 183
.byt $41, $41, $40, $40, $40, $40, $40, $40
; Tile mask 184
.byt $70, $70, $60, $60, $70, $78, $78, $78
; Tile mask 185
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 186
.byt $40, $40, $40, $41, $41, $41, $41, $41
; Tile mask 187
.byt $5f, $5f, $7f, $7f, $7f, $7f, $7f, $7f
; Tile mask 188
.byt $78, $78, $78, $78, $7c, $7e, $7e, $7e
; Tile mask 189
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 190
.byt $41, $41, $41, $43, $47, $47, $43, $41
; Tile mask 191
.byt $43, $41, $40, $40, $40, $40, $40, $40
; Tile mask 192
.byt $7f, $7f, $7f, $5f, $5f, $5f, $5f, $4f
; Tile mask 193
.byt $78, $78, $70, $70, $70, $70, $70, $70
; Tile mask 194
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 195
.byt $47, $43, $43, $41, $41, $41, $41, $40
; Tile mask 196
.byt $60, $60, $70, $78, $78, $78, $78, $78
; Tile mask 197
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 198
.byt $40, $40, $40, $40, $40, $41, $41, $41
; Tile mask 199
.byt $7f, $7f, $5f, $5f, $5f, $7f, $7f, $7f
; Tile mask 200
.byt $78, $78, $78, $78, $78, $70, $60, $40
; Tile mask 201
.byt $40, $40, $40, $40, $40, $4f, $4f, $4f
; Tile mask 202
.byt $43, $43, $41, $40, $40, $60, $60, $40
; Tile mask 203
.byt $7f, $7f, $7f, $7e, $7e, $7e, $7e, $7c
; Tile mask 204
.byt $70, $60, $40, $40, $40, $40, $40, $40
; Tile mask 205
.byt $78, $70, $70, $60, $60, $60, $60, $40
; Tile mask 206
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 207
.byt $47, $47, $43, $43, $43, $43, $43, $43
; Tile mask 208
.byt $7f, $7f, $7e, $7e, $7e, $7f, $7f, $7f
; Tile mask 209
.byt $40, $40, $40, $40, $40, $60, $60, $60
; Tile mask 210
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 211
.byt $41, $41, $43, $47, $47, $47, $47, $47
; Tile mask 212
.byt $70, $70, $60, $40, $40, $41, $41, $40
; Tile mask 213
.byt $40, $40, $40, $40, $40, $7c, $7c, $7c
; Tile mask 214
.byt $47, $47, $47, $47, $47, $43, $41, $40
; Tile mask 215
.byt $60, $60, $60, $70, $78, $7c, $78, $60
; Tile mask 216
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 217
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 218
.byt $41, $41, $41, $43, $47, $4f, $47, $41
; Tile mask 219
.byt $78, $78, $78, $7c, $7e, $7e, $7c, $7c
; Tile mask 220
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 221
.byt $41, $41, $41, $41, $41, $41, $43, $47
; Tile mask 222
.byt $60, $60, $60, $60, $60, $60, $70, $78
; Tile mask 223
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 224
.byt $47, $47, $47, $4f, $5f, $5f, $4f, $4f
; Tile mask 225
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7d, $70
; Tile mask 226
.byt $70, $70, $70, $78, $78, $78, $7c, $7c
; Tile mask 227
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 228
.byt $7f, $7f, $7f, $7f, $7f, $7f, $6f, $43
; Tile mask 229
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 230
.byt $43, $43, $43, $47, $47, $47, $4f, $4f
; Tile mask 231
.byt $7f, $7f, $7f, $7e, $7c, $78, $70, $70
; Tile mask 232
.byt $7f, $73, $61, $40, $40, $40, $40, $40
; Tile mask 233
.byt $7f, $7f, $7f, $7f, $5f, $4f, $47, $47
; Tile mask 234
.byt $70, $70, $70, $78, $78, $7c, $7e, $7e
; Tile mask 235
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 236
.byt $47, $47, $47, $47, $47, $43, $43, $43
; Tile mask 237
.byt $7f, $7f, $7f, $7f, $7e, $7c, $78, $78
; Tile mask 238
.byt $7f, $73, $61, $40, $40, $40, $40, $40
; Tile mask 239
.byt $7f, $7f, $7f, $5f, $4f, $47, $43, $43
; Tile mask 240
.byt $78, $78, $78, $78, $78, $70, $70, $70
; Tile mask 241
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 242
.byt $43, $43, $43, $47, $47, $4f, $5f, $5f
end_teacher_masks

.dsb 256-(*&255)

; For the keyboard routine
KeyBank .dsb 8

teacher2_tiles
; Tile graphic 1
.byt $0, $1, $0, $1, $1, $1, $1, $0
; Tile graphic 2
.byt $0, $3e, $3f, $1, $2b, $1, $39, $20
; Tile graphic 3
.byt $0, $0, $20, $30, $30, $10, $10, $20
; Tile graphic 4
.byt $3, $4, $8, $8, $a, $a, $a, $a
; Tile graphic 5
.byt $23, $3f, $17, $16, $16, $16, $16, $d
; Tile graphic 6
.byt $3c, $2, $2, $2, $12, $12, $12, $3a
; Tile graphic 7
.byt $b, $a, $c, $8, $9, $7, $3, $3
; Tile graphic 8
.byt $0, $d, $1e, $3f, $3f, $3f, $3f, $3f
; Tile graphic 9
.byt $32, $14, $c, $4, $28, $38, $20, $20
; Tile graphic 10
.byt $1, $1, $1, $1, $1, $3, $4, $7
; Tile graphic 11
.byt $3f, $3f, $3f, $3f, $3f, $3f, $8, $3f
; Tile graphic 12
.byt $0, $0, $0, $0, $0, $0, $20, $20
; Tile graphic 13
.byt $0, $0, $1, $3, $3, $2, $2, $1
; Tile graphic 14
.byt $0, $1f, $3f, $20, $35, $20, $27, $1
; Tile graphic 15
.byt $0, $20, $0, $20, $20, $20, $20, $0
; Tile graphic 16
.byt $f, $10, $10, $10, $12, $12, $12, $17
; Tile graphic 17
.byt $31, $3f, $3a, $1a, $1a, $1a, $1a, $2c
; Tile graphic 18
.byt $30, $8, $4, $4, $14, $14, $14, $14
; Tile graphic 19
.byt $13, $a, $c, $8, $5, $7, $1, $1
; Tile graphic 20
.byt $0, $2c, $1e, $3f, $3f, $3f, $3f, $3f
; Tile graphic 21
.byt $34, $14, $c, $4, $24, $38, $30, $30
; Tile graphic 22
.byt $0, $0, $0, $0, $0, $0, $1, $1
; Tile graphic 23
.byt $3f, $3f, $3f, $3f, $3f, $3f, $4, $3f
; Tile graphic 24
.byt $20, $20, $20, $20, $20, $30, $8, $38
; Tile graphic 25
.byt $0, $1f, $f, $10, $1a, $10, $1e, $8
; Tile graphic 26
.byt $0, $20, $38, $1c, $3c, $14, $14, $8
; Tile graphic 27
.byt $0, $1, $2, $2, $2, $2, $2, $2
; Tile graphic 28
.byt $38, $f, $5, $5, $25, $25, $25, $23
; Tile graphic 29
.byt $3f, $30, $30, $20, $24, $24, $24, $1e
; Tile graphic 30
.byt $0, $20, $20, $20, $20, $20, $20, $20
; Tile graphic 31
.byt $2, $2, $3, $2, $2, $1, $0, $0
; Tile graphic 32
.byt $30, $23, $7, $f, $1f, $3f, $3f, $3f
; Tile graphic 33
.byt $c, $15, $23, $31, $3a, $3e, $38, $38
; Tile graphic 34
.byt $20, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 35
.byt $0, $0, $1, $1, $1, $7, $c, $3
; Tile graphic 36
.byt $3d, $3c, $3c, $38, $38, $38, $8, $38
; Tile graphic 37
.byt $38, $3c, $3e, $1e, $d, $5, $b, $1e
; Tile graphic 38
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 39
.byt $0, $1, $7, $e, $f, $a, $a, $4
; Tile graphic 40
.byt $0, $3e, $3c, $2, $16, $2, $1e, $4
; Tile graphic 41
.byt $0, $1, $1, $1, $1, $1, $1, $1
; Tile graphic 42
.byt $3f, $3, $3, $1, $9, $9, $9, $1e
; Tile graphic 43
.byt $7, $3c, $28, $28, $29, $29, $29, $31
; Tile graphic 44
.byt $0, $20, $10, $10, $10, $10, $10, $10
; Tile graphic 45
.byt $1, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 46
.byt $c, $2a, $31, $23, $17, $1f, $7, $7
; Tile graphic 47
.byt $3, $31, $38, $3c, $3e, $3f, $3f, $3f
; Tile graphic 48
.byt $10, $10, $30, $10, $10, $20, $0, $0
; Tile graphic 49
.byt $0, $0, $0, $0, $0, $0, $0, $0
; Tile graphic 50
.byt $7, $f, $1f, $1e, $2c, $28, $34, $1e
; Tile graphic 51
.byt $2f, $f, $f, $7, $7, $7, $4, $7
; Tile graphic 52
.byt $0, $0, $20, $20, $20, $38, $c, $30
; Tile graphic 53
.byt $3, $1, $1, $1, $0, $1, $2, $7
; Tile graphic 54
.byt $3f, $3f, $3f, $3f, $3f, $3f, $10, $3f
; Tile graphic 55
.byt $3f, $3f, $3f, $3f, $3f, $3f, $2, $3f
; Tile graphic 56
.byt $30, $20, $20, $20, $0, $20, $10, $38
; Tile graphic 57
.byt $0, $0, $0, $0, $0, $0, $0, $1
; Tile graphic 58
.byt $1f, $f, $7, $f, $f, $1f, $21, $3f
; Tile graphic 59
.byt $30, $30, $38, $3e, $3e, $1a, $12, $1e
; Tile graphic 60
.byt $3, $3, $7, $1f, $1f, $16, $12, $1e
; Tile graphic 61
.byt $3e, $3c, $38, $3c, $3c, $3e, $21, $3f
; Tile graphic 62
.byt $0, $0, $0, $0, $0, $0, $0, $20
; Tile graphic 63
.byt $2, $5, $4, $5, $7, $1, $0, $0
; Tile graphic 64
.byt $3, $4, $28, $28, $18, $8, $20, $12
; Tile graphic 65
.byt $e, $3, $2, $2, $2, $2, $3, $3
; Tile graphic 66
.byt $0, $2d, $e, $f, $f, $3f, $3f, $3f
; Tile graphic 67
.byt $30, $8, $5, $5, $6, $4, $1, $12
; Tile graphic 68
.byt $10, $28, $8, $28, $38, $20, $0, $0
; Tile graphic 69
.byt $0, $2d, $1c, $3c, $3c, $3f, $3f, $3f
; Tile graphic 70
.byt $1c, $30, $10, $10, $10, $10, $30, $30
; Tile graphic 71
.byt $0, $0, $0, $0, $1, $2, $5, $5
; Tile graphic 72
.byt $0, $0, $1c, $22, $3e, $3f, $1, $2b
; Tile graphic 73
.byt $0, $0, $0, $0, $0, $20, $30, $30
; Tile graphic 74
.byt $5, $4, $4, $2, $2, $1, $0, $0
; Tile graphic 75
.byt $1, $39, $20, $23, $1e, $1c, $3d, $3d
; Tile graphic 76
.byt $10, $10, $20, $30, $10, $8, $8, $28
; Tile graphic 77
.byt $0, $0, $10, $18, $1f, $1c, $1c, $1f
; Tile graphic 78
.byt $0, $0, $0, $3, $3c, $3, $f, $3f
; Tile graphic 79
.byt $1a, $1b, $3a, $36, $e, $1f, $3f, $3f
; Tile graphic 80
.byt $24, $24, $34, $32, $2a, $2e, $29, $1e
; Tile graphic 81
.byt $0, $0, $0, $0, $0, $1, $3, $3
; Tile graphic 82
.byt $0, $0, $e, $11, $1f, $3f, $20, $35
; Tile graphic 83
.byt $0, $0, $0, $0, $20, $10, $28, $28
; Tile graphic 84
.byt $2, $2, $1, $3, $2, $4, $4, $5
; Tile graphic 85
.byt $20, $27, $1, $31, $1e, $e, $2f, $2f
; Tile graphic 86
.byt $28, $8, $8, $10, $10, $20, $0, $0
; Tile graphic 87
.byt $9, $9, $b, $13, $15, $1d, $25, $1e
; Tile graphic 88
.byt $16, $36, $17, $1b, $1c, $3e, $3f, $3f
; Tile graphic 89
.byt $0, $0, $0, $30, $f, $30, $3c, $3f
; Tile graphic 90
.byt $0, $0, $2, $6, $3e, $e, $e, $3e
end_teacher2_tiles

.dsb 256-(*&255)
.dsb 8
teacher2_masks

; Tile mask 1
.byt $7e, $7c, $7e, $7c, $7c, $7c, $7c, $7c
; Tile mask 2
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 3
.byt $7f, $5f, $4f, $47, $47, $47, $47, $43
; Tile mask 4
.byt $78, $70, $60, $60, $60, $60, $60, $60
; Tile mask 5
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 6
.byt $41, $40, $40, $40, $40, $40, $40, $40
; Tile mask 7
.byt $60, $60, $60, $60, $60, $60, $78, $78
; Tile mask 8
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 9
.byt $40, $41, $41, $41, $43, $43, $47, $4f
; Tile mask 10
.byt $7c, $7c, $7c, $7c, $7c, $78, $70, $70
; Tile mask 11
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 12
.byt $5f, $5f, $5f, $5f, $5f, $5f, $4f, $4f
; Tile mask 13
.byt $7f, $7e, $7c, $78, $78, $78, $78, $70
; Tile mask 14
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 15
.byt $5f, $4f, $5f, $4f, $4f, $4f, $4f, $4f
; Tile mask 16
.byt $60, $40, $40, $40, $40, $40, $40, $40
; Tile mask 17
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 18
.byt $47, $43, $41, $41, $41, $41, $41, $41
; Tile mask 19
.byt $40, $60, $60, $60, $70, $70, $78, $7c
; Tile mask 20
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 21
.byt $41, $41, $41, $41, $41, $41, $47, $47
; Tile mask 22
.byt $7e, $7e, $7e, $7e, $7e, $7e, $7c, $7c
; Tile mask 23
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 24
.byt $4f, $4f, $4f, $4f, $4f, $47, $43, $43
; Tile mask 25
.byt $60, $40, $60, $40, $40, $40, $40, $40
; Tile mask 26
.byt $5f, $47, $43, $41, $41, $41, $41, $40
; Tile mask 27
.byt $7e, $7c, $78, $78, $78, $78, $78, $78
; Tile mask 28
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 29
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 30
.byt $5f, $4f, $4f, $4f, $4f, $4f, $4f, $4f
; Tile mask 31
.byt $78, $78, $78, $78, $78, $7c, $7e, $7e
; Tile mask 32
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 33
.byt $40, $40, $40, $40, $40, $40, $41, $43
; Tile mask 34
.byt $4f, $5f, $5f, $5f, $7f, $7f, $7f, $7f
; Tile mask 35
.byt $7e, $7e, $7c, $7c, $78, $70, $60, $60
; Tile mask 36
.byt $40, $40, $40, $43, $43, $43, $43, $43
; Tile mask 37
.byt $43, $41, $40, $40, $60, $70, $60, $40
; Tile mask 38
.byt $7f, $7f, $7f, $7f, $5f, $5f, $5f, $7f
; Tile mask 39
.byt $7e, $78, $70, $60, $60, $60, $60, $40
; Tile mask 40
.byt $41, $40, $41, $40, $40, $40, $40, $40
; Tile mask 41
.byt $7e, $7c, $7c, $7c, $7c, $7c, $7c, $7c
; Tile mask 42
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 43
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 44
.byt $5f, $4f, $47, $47, $47, $47, $47, $47
; Tile mask 45
.byt $7c, $7e, $7e, $7e, $7f, $7f, $7f, $7f
; Tile mask 46
.byt $40, $40, $40, $40, $40, $40, $60, $70
; Tile mask 47
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 48
.byt $47, $47, $47, $47, $47, $4f, $5f, $5f
; Tile mask 49
.byt $7f, $7f, $7f, $7f, $7e, $7e, $7e, $7f
; Tile mask 50
.byt $70, $60, $40, $40, $41, $43, $41, $40
; Tile mask 51
.byt $40, $40, $40, $70, $70, $70, $70, $70
; Tile mask 52
.byt $5f, $5f, $4f, $4f, $47, $43, $41, $41
; Tile mask 53
.byt $78, $7c, $7c, $7c, $7e, $7c, $78, $70
; Tile mask 54
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 55
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 56
.byt $47, $4f, $4f, $4f, $5f, $4f, $47, $43
; Tile mask 57
.byt $7f, $7f, $7f, $7f, $7f, $7f, $7e, $7c
; Tile mask 58
.byt $40, $60, $70, $60, $60, $40, $40, $40
; Tile mask 59
.byt $47, $47, $41, $40, $40, $40, $40, $40
; Tile mask 60
.byt $78, $78, $60, $40, $40, $40, $40, $40
; Tile mask 61
.byt $40, $41, $43, $41, $41, $40, $40, $40
; Tile mask 62
.byt $7f, $7f, $7f, $7f, $7f, $7f, $5f, $4f
; Tile mask 63
.byt $78, $70, $70, $70, $70, $78, $7e, $7f
; Tile mask 64
.byt $78, $50, $40, $40, $40, $40, $40, $40
; Tile mask 65
.byt $70, $70, $78, $78, $78, $78, $78, $78
; Tile mask 66
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 67
.byt $47, $42, $40, $40, $40, $40, $40, $40
; Tile mask 68
.byt $47, $43, $43, $43, $43, $47, $5f, $7f
; Tile mask 69
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 70
.byt $43, $43, $47, $47, $47, $47, $47, $47
; Tile mask 71
.byt $7f, $7f, $7f, $7e, $7c, $78, $70, $70
; Tile mask 72
.byt $7f, $63, $41, $40, $40, $40, $40, $40
; Tile mask 73
.byt $7f, $7f, $7f, $7f, $5f, $4f, $47, $47
; Tile mask 74
.byt $70, $70, $70, $78, $78, $7c, $7e, $7e
; Tile mask 75
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 76
.byt $47, $47, $4f, $47, $47, $43, $43, $43
; Tile mask 77
.byt $7f, $6f, $47, $40, $40, $40, $40, $40
; Tile mask 78
.byt $7f, $7f, $7c, $40, $40, $40, $40, $40
; Tile mask 79
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 80
.byt $41, $41, $41, $40, $40, $40, $40, $40
; Tile mask 81
.byt $7f, $7f, $7f, $7f, $7e, $7c, $78, $78
; Tile mask 82
.byt $7f, $71, $60, $40, $40, $40, $40, $40
; Tile mask 83
.byt $7f, $7f, $7f, $5f, $4f, $47, $43, $43
; Tile mask 84
.byt $78, $78, $7c, $78, $78, $70, $70, $70
; Tile mask 85
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 86
.byt $43, $43, $43, $47, $47, $4f, $5f, $5f
; Tile mask 87
.byt $60, $60, $60, $40, $40, $40, $40, $40
; Tile mask 88
.byt $40, $40, $40, $40, $40, $40, $40, $40
; Tile mask 89
.byt $7f, $7f, $4f, $40, $40, $40, $40, $40
; Tile mask 90
.byt $7f, $7d, $78, $40, $40, $40, $40, $40
end_teacher2_masks











