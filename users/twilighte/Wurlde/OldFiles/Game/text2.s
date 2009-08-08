;All main game Text for Wurlde (excludes SSC texts)
;?All text within the game is handled with code in text_window_handler.s and
;?option_window_handler.s

; eog,keywords,ascii,creatures,place,object,passage,questtext,caption,sentinels
;C RANGE		CATEGORY		QUANTITY	Notes
;0 000-031 	32		Unique Objects(Items)
;1 032-122	91		Letters
;2 123-152	30		keywords
;3 153-168	16		Names of locations (Inc. Banit River)
;4 169-184	16		Character Interactions(Based on posessed items)
;5 185-216	32		Character Names and descriptions
;6 217-224          8		Rumour Texts
;7 225-240	16		Group Text
;8 241-253	13		General Text Messages(that may require embedded text)

; This table breaks down any supplied 0-255 code into an index that points to the
; Text Category (C) as above.
; Whilst their are many more code types, categories group common offsets together.
CategoryIndexes
 .byt 0,32,123,153,169,185,217,225,241
CategoryFieldStart
 .byt 4,0,1,0,254,2,0,0,0

; These tables hold direct reference to the text message number.
CharacterAddressLo
TextVectorLo
;Objects(0-31)
 .byt <ObjectFixed00,<ObjectFixed01,<ObjectFixed02,<ObjectFixed03
 .byt <ObjectFixed04,<ObjectFixed05,<ObjectFixed06,<ObjectFixed07
 .byt <ObjectFixed08,<ObjectFixed09,<ObjectFixed10,<ObjectFixed11
 .byt <ObjectFixed12,<ObjectFixed13,<ObjectFixed14,<ObjectFixed15
 .byt <ObjectFixed16,<ObjectFixed17,<ObjectFixed18,<ObjectFixed19
 .byt <ObjectFixed20,<ObjectFixed21,<ObjectFixed22,<ObjectFixed23
 .byt <ObjectFixed24,<ObjectFixed25,<ObjectFixed26,<ObjectFixed27
 .byt <ObjectFixed28,<ObjectFixed29,<ObjectFixed30,<ObjectFixed31
;Character set(32-122) - Holding the character address table (and some embedded code pointers)
 .byt <Charset6x6		;032 _
 .byt <Charset6x6+6*1	;033 !
 .byt <Charset6x6+6*2	;034 "
 .byt <Charset6x6+6*3	;035 # ???
 .byt <Charset6x6+6*4	;036 $ ???
 .byt <Charset6x6+6*5	;037 % ???
 .byt <Charset6x6+6*6	;038 &
 .byt <Charset6x6+6*7	;039 '
 .byt <Charset6x6+6*8	;040 (
 .byt <Charset6x6+6*9	;041 )
 .byt <Charset6x6+6*10	;042 * ???
 .byt <Charset6x6+6*11	;043 +
 .byt <Charset6x6+6*12	;044 ,
 .byt <Charset6x6+6*13	;045 -
 .byt <Charset6x6+6*14	;046 .
 .byt <Charset6x6+6*15	;047 / ???
 .byt <Charset6x6+6*16	;048 0
 .byt <Charset6x6+6*17	;049 1
 .byt <Charset6x6+6*18	;050 2
 .byt <Charset6x6+6*19	;051 3
 .byt <Charset6x6+6*20	;052 4
 .byt <Charset6x6+6*21	;053 5
 .byt <Charset6x6+6*22	;054 6
 .byt <Charset6x6+6*23	;055 7
 .byt <Charset6x6+6*24	;056 8
 .byt <Charset6x6+6*25	;057 9
 .byt <Charset6x6+6*26	;058 Colon ???
 .byt <Charset6x6+6*27	;059 Semicolon ???
 .byt <Charset6x6+6*28	;060 < ???
 .byt <Charset6x6+6*29	;061 = ???
 .byt <Charset6x6+6*30	;062 > ???
 .byt <Charset6x6+6*31	;063 ?
 .byt <Charset6x6+6*32	;064 @ ???
 .byt <Charset6x6+6*33	;065 A
 .byt <Charset6x6+6*34	;066 B
 .byt <Charset6x6+6*35	;067 C
 .byt <Charset6x6+6*36	;068 D
 .byt <Charset6x6+6*37	;069 E
 .byt <Charset6x6+6*38	;070 F
 .byt <Charset6x6+6*39	;071 G
 .byt <Charset6x6+6*40	;072 H
 .byt <Charset6x6+6*41	;073 I
 .byt <Charset6x6+6*42	;074 J
 .byt <Charset6x6+6*43	;075 K
 .byt <Charset6x6+6*44	;076 L
 .byt <Charset6x6+6*45	;077 M
 .byt <Charset6x6+6*46	;078 N
 .byt <Charset6x6+6*47	;079 O
 .byt <Charset6x6+6*48	;080 P
 .byt <Charset6x6+6*49	;081 Q
 .byt <Charset6x6+6*50	;082 R
 .byt <Charset6x6+6*51	;083 S
 .byt <Charset6x6+6*52	;084 T
 .byt <Charset6x6+6*53	;085 U
 .byt <Charset6x6+6*54	;086 V
 .byt <Charset6x6+6*55	;087 W
 .byt <Charset6x6+6*56	;088 X
 .byt <Charset6x6+6*57	;089 Y
 .byt <Charset6x6+6*58	;090 Z
 .byt <Charset6x6+6*59	;091 [ ???
 .byt <Charset6x6+6*60	;092 \ ???
 .byt <Charset6x6+6*61	;093 ] ???
 .byt <Charset6x6+6*62	;094 ^ ???
 .byt <Charset6x6+6*63	;095 _ ???
 .byt <Charset6x6+6*64	;096 ` ???
 .byt <Charset6x6+6*65	;097 a
 .byt <Charset6x6+6*66	;098 b
 .byt <Charset6x6+6*67	;099 c
 .byt <Charset6x6+6*68	;100 d
 .byt <Charset6x6+6*69	;101 e
 .byt <Charset6x6+6*70	;102 f
 .byt <Charset6x6+6*71	;103 g
 .byt <Charset6x6+6*72	;104 h
 .byt <Charset6x6+6*73	;105 i
 .byt <Charset6x6+6*74	;106 j
 .byt <Charset6x6+6*75	;107 k
 .byt <Charset6x6+6*76	;108 l
 .byt <Charset6x6+6*77	;109 m
 .byt <Charset6x6+6*78	;110 n
 .byt <Charset6x6+6*79	;111 o
 .byt <Charset6x6+6*80	;112 p
 .byt <Charset6x6+6*81	;113 q
 .byt <Charset6x6+6*82	;114 r
 .byt <Charset6x6+6*83	;115 s
 .byt <Charset6x6+6*84	;116 t
 .byt <Charset6x6+6*85	;117 u
 .byt <Charset6x6+6*86	;118 v
 .byt <Charset6x6+6*87	;119 w
 .byt <Charset6x6+6*88	;120 x
 .byt <Charset6x6+6*89	;121 y
 .byt <Charset6x6+6*90	;122 z
;Keywords(123-152(30))
 .byt <Keyword00		;123
 .byt <Keyword01		;124
 .byt <Keyword02		;125
 .byt <Keyword03		;126
 .byt <Keyword04		;127
 .byt <Keyword05		;128
 .byt <Keyword06		;129
 .byt <Keyword07		;130
 .byt <Keyword08		;131
 .byt <Keyword09		;132
 .byt <Keyword10		;133
 .byt <Keyword11		;134
 .byt <Keyword12		;135
 .byt <Keyword13		;136
 .byt <Keyword14		;137
 .byt <Keyword15		;138
 .byt <Keyword16		;139
 .byt <Keyword17		;140
 .byt <Keyword18		;141
 .byt <Keyword19		;142
 .byt <Keyword20		;143
 .byt <Keyword21		;144
 .byt <Keyword22		;145
 .byt <Keyword23		;146
 .byt <Keyword24		;147
 .byt <Keyword25		;148
 .byt <Keyword26		;149
 .byt <Keyword27		;150
 .byt <Keyword28		;151
 .byt <Keyword29		;152
;3 153-168	16		Names of locations (Inc. Banit River)
;Place Names(153-158(6))
 .byt <PlaceName00		;153
 .byt <PlaceName01		;154
 .byt <PlaceName02		;155
 .byt <PlaceName03		;156
 .byt <PlaceName04		;157
 .byt <PlaceName05		;158
 .byt <PlaceName06		;159
 .byt <PlaceName07		;160
 .byt <PlaceName08		;161
 .byt <PlaceName09		;162
 .byt <PlaceName10		;163
 .byt <PlaceName11		;164
 .byt <PlaceName12		;165
 .byt <PlaceName13		;166
 .byt <PlaceName14		;167
 .byt <PlaceName15		;168

;4 169-184	16		Character Interactions(Based on posessed items)
;Character Interactions(169-184(16))
 .byt <CharacterInteraction00	;169
 .byt <CharacterInteraction01	;170
 .byt <CharacterInteraction02	;171
 .byt <CharacterInteraction03	;172
 .byt <CharacterInteraction04	;173
 .byt <CharacterInteraction05	;174
 .byt <CharacterInteraction06	;175
 .byt <CharacterInteraction07	;176
 .byt <CharacterInteraction08	;177
 .byt <CharacterInteraction09	;178
 .byt <CharacterInteraction10	;179
 .byt <CharacterInteraction11	;180
 .byt <CharacterInteraction12	;181
 .byt <CharacterInteraction13	;182
 .byt <CharacterInteraction14	;183
 .byt <CharacterInteraction15	;184

;5 185-216	32		Character Names and descriptions
;Character Names(185-216(32))
 .byt <CharacterLabels00	;185
 .byt <CharacterLabels01	;186
 .byt <CharacterLabels02	;187
 .byt <CharacterLabels03	;188
 .byt <CharacterLabels04	;189
 .byt <CharacterLabels05	;190
 .byt <CharacterLabels06	;191
 .byt <CharacterLabels07	;192
 .byt <CharacterLabels08	;193
 .byt <CharacterLabels09	;194
 .byt <CharacterLabels10	;195
 .byt <CharacterLabels11	;196
 .byt <CharacterLabels12	;197
 .byt <CharacterLabels13	;198
 .byt <CharacterLabels14	;199
 .byt <CharacterLabels15	;200
 .byt <CharacterLabels16	;201
 .byt <CharacterLabels17	;202
 .byt <CharacterLabels18	;203
 .byt <CharacterLabels19	;204
 .byt <CharacterLabels20	;205
 .byt <CharacterLabels21	;206
 .byt <CharacterLabels22	;207
 .byt <CharacterLabels23	;208
 .byt <CharacterLabels24	;209
 .byt <CharacterLabels25	;210
 .byt <CharacterLabels26	;211
 .byt <CharacterLabels27	;212
 .byt <CharacterLabels28	;213
 .byt <CharacterLabels29	;214
 .byt <CharacterLabels30	;215
 .byt <CharacterLabels31	;216

;6 217-224          8		Rumour Texts
;Rumour Texts (217-224(8))
;Rumour Text,255
 .byt <RumourText00		;217
 .byt <RumourText01		;218
 .byt <RumourText02		;219
 .byt <RumourText03		;220
 .byt <RumourText04		;221
 .byt <RumourText05		;222
 .byt <RumourText06		;223
 .byt <RumourText07		;224

;7 225-240	16		Group Text
;Group Text (225-240(16))
;Group Text,255
 .byt <GroupText00		;225
 .byt <GroupText01		;226
 .byt <GroupText02		;227
 .byt <GroupText03		;228
 .byt <GroupText04		;229
 .byt <GroupText05		;230
 .byt <GroupText06		;231
 .byt <GroupText07		;232
 .byt <GroupText08		;233
 .byt <GroupText09		;234
 .byt <GroupText10		;235
 .byt <GroupText11		;236
 .byt <GroupText12		;237
 .byt <GroupText13		;238
 .byt <GroupText14		;239
 .byt <GroupText15		;240
;8 241-253	13		General Text Messages(that may require embedded text)
;General Text Messages(241-253(13))
 .byt <EmbeddedText00	;241
 .byt <EmbeddedText01	;242
 .byt <EmbeddedText02	;243
 .byt <EmbeddedText03	;244
 .byt <EmbeddedText04	;245
 .byt <EmbeddedText05	;246
 .byt <EmbeddedText06	;247
 .byt <EmbeddedText07	;248
 .byt <EmbeddedText08	;249
 .byt <EmbeddedText09	;250
 .byt <EmbeddedText10	;251
 .byt <EmbeddedText11	;252
 .byt <EmbeddedText12	;253


CharacterAddressHi
TextVectorHi
;Objects(0-31)
 .byt >ObjectFixed00,>ObjectFixed01,>ObjectFixed02,>ObjectFixed03
 .byt >ObjectFixed04,>ObjectFixed05,>ObjectFixed06,>ObjectFixed07
 .byt >ObjectFixed08,>ObjectFixed09,>ObjectFixed10,>ObjectFixed11
 .byt >ObjectFixed12,>ObjectFixed13,>ObjectFixed14,>ObjectFixed15
 .byt >ObjectFixed16,>ObjectFixed17,>ObjectFixed18,>ObjectFixed19
 .byt >ObjectFixed20,>ObjectFixed21,>ObjectFixed22,>ObjectFixed23
 .byt >ObjectFixed24,>ObjectFixed25,>ObjectFixed26,>ObjectFixed27
 .byt >ObjectFixed28,>ObjectFixed29,>ObjectFixed30,>ObjectFixed31
;Character set(32-122) - Holding the character address table (and some embedded code pointers)
 .byt >Charset6x6		;032 _
 .byt >Charset6x6+6*1	;033 !
 .byt >Charset6x6+6*2	;034 "
 .byt >Charset6x6+6*3	;035 # ???
 .byt >Charset6x6+6*4	;036 $ ???
 .byt >Charset6x6+6*5	;037 % ???
 .byt >Charset6x6+6*6	;038 &
 .byt >Charset6x6+6*7	;039 '
 .byt >Charset6x6+6*8	;040 (
 .byt >Charset6x6+6*9	;041 )
 .byt >Charset6x6+6*10	;042 * ???
 .byt >Charset6x6+6*11	;043 +
 .byt >Charset6x6+6*12	;044 ,
 .byt >Charset6x6+6*13	;045 -
 .byt >Charset6x6+6*14	;046 .
 .byt >Charset6x6+6*15	;047 / ???
 .byt >Charset6x6+6*16	;048 0
 .byt >Charset6x6+6*17	;049 1
 .byt >Charset6x6+6*18	;050 2
 .byt >Charset6x6+6*19	;051 3
 .byt >Charset6x6+6*20	;052 4
 .byt >Charset6x6+6*21	;053 5
 .byt >Charset6x6+6*22	;054 6
 .byt >Charset6x6+6*23	;055 7
 .byt >Charset6x6+6*24	;056 8
 .byt >Charset6x6+6*25	;057 9
 .byt >Charset6x6+6*26	;058 Colon ???
 .byt >Charset6x6+6*27	;059 Semicolon ???
 .byt >Charset6x6+6*28	;060 > ???
 .byt >Charset6x6+6*29	;061 = ???
 .byt >Charset6x6+6*30	;062 > ???
 .byt >Charset6x6+6*31	;063 ?
 .byt >Charset6x6+6*32	;064 @ ???
 .byt >Charset6x6+6*33	;065 A
 .byt >Charset6x6+6*34	;066 B
 .byt >Charset6x6+6*35	;067 C
 .byt >Charset6x6+6*36	;068 D
 .byt >Charset6x6+6*37	;069 E
 .byt >Charset6x6+6*38	;070 F
 .byt >Charset6x6+6*39	;071 G
 .byt >Charset6x6+6*40	;072 H
 .byt >Charset6x6+6*41	;073 I
 .byt >Charset6x6+6*42	;074 J
 .byt >Charset6x6+6*43	;075 K
 .byt >Charset6x6+6*44	;076 L
 .byt >Charset6x6+6*45	;077 M
 .byt >Charset6x6+6*46	;078 N
 .byt >Charset6x6+6*47	;079 O
 .byt >Charset6x6+6*48	;080 P
 .byt >Charset6x6+6*49	;081 Q
 .byt >Charset6x6+6*50	;082 R
 .byt >Charset6x6+6*51	;083 S
 .byt >Charset6x6+6*52	;084 T
 .byt >Charset6x6+6*53	;085 U
 .byt >Charset6x6+6*54	;086 V
 .byt >Charset6x6+6*55	;087 W
 .byt >Charset6x6+6*56	;088 X
 .byt >Charset6x6+6*57	;089 Y
 .byt >Charset6x6+6*58	;090 Z
 .byt >Charset6x6+6*59	;091 [ ???
 .byt >Charset6x6+6*60	;092 \ ???
 .byt >Charset6x6+6*61	;093 ] ???
 .byt >Charset6x6+6*62	;094 ^ ???
 .byt >Charset6x6+6*63	;095 _ ???
 .byt >Charset6x6+6*64	;096 ` ???
 .byt >Charset6x6+6*65	;097 a
 .byt >Charset6x6+6*66	;098 b
 .byt >Charset6x6+6*67	;099 c
 .byt >Charset6x6+6*68	;100 d
 .byt >Charset6x6+6*69	;101 e
 .byt >Charset6x6+6*70	;102 f
 .byt >Charset6x6+6*71	;103 g
 .byt >Charset6x6+6*72	;104 h
 .byt >Charset6x6+6*73	;105 i
 .byt >Charset6x6+6*74	;106 j
 .byt >Charset6x6+6*75	;107 k
 .byt >Charset6x6+6*76	;108 l
 .byt >Charset6x6+6*77	;109 m
 .byt >Charset6x6+6*78	;110 n
 .byt >Charset6x6+6*79	;111 o
 .byt >Charset6x6+6*80	;112 p
 .byt >Charset6x6+6*81	;113 q
 .byt >Charset6x6+6*82	;114 r
 .byt >Charset6x6+6*83	;115 s
 .byt >Charset6x6+6*84	;116 t
 .byt >Charset6x6+6*85	;117 u
 .byt >Charset6x6+6*86	;118 v
 .byt >Charset6x6+6*87	;119 w
 .byt >Charset6x6+6*88	;120 x
 .byt >Charset6x6+6*89	;121 y
 .byt >Charset6x6+6*90	;122 z
;Keywords(123-152(30))
 .byt >Keyword00		;123
 .byt >Keyword01		;124
 .byt >Keyword02		;125
 .byt >Keyword03		;126
 .byt >Keyword04		;127
 .byt >Keyword05		;128
 .byt >Keyword06		;129
 .byt >Keyword07		;130
 .byt >Keyword08		;131
 .byt >Keyword09		;132
 .byt >Keyword10		;133
 .byt >Keyword11		;134
 .byt >Keyword12		;135
 .byt >Keyword13		;136
 .byt >Keyword14		;137
 .byt >Keyword15		;138
 .byt >Keyword16		;139
 .byt >Keyword17		;140
 .byt >Keyword18		;141
 .byt >Keyword19		;142
 .byt >Keyword20		;143
 .byt >Keyword21		;144
 .byt >Keyword22		;145
 .byt >Keyword23		;146
 .byt >Keyword24		;147
 .byt >Keyword25		;148
 .byt >Keyword26		;149
 .byt >Keyword27		;150
 .byt >Keyword28		;151
 .byt >Keyword29		;152
;3 153-168	16		Names of locations (Inc. Banit River)
;Place Names(153-158(6))
 .byt >PlaceName00		;153
 .byt >PlaceName01		;154
 .byt >PlaceName02		;155
 .byt >PlaceName03		;156
 .byt >PlaceName04		;157
 .byt >PlaceName05		;158
 .byt >PlaceName06		;159
 .byt >PlaceName07		;160
 .byt >PlaceName08		;161
 .byt >PlaceName09		;162
 .byt >PlaceName10		;163
 .byt >PlaceName11		;164
 .byt >PlaceName12		;165
 .byt >PlaceName13		;166
 .byt >PlaceName14		;167
 .byt >PlaceName15		;168

;4 169-184	16		Character Interactions(Based on posessed items)
;Character Interactions(169-184(16))
 .byt >CharacterInteraction00	;169
 .byt >CharacterInteraction01	;170
 .byt >CharacterInteraction02	;171
 .byt >CharacterInteraction03	;172
 .byt >CharacterInteraction04	;173
 .byt >CharacterInteraction05	;174
 .byt >CharacterInteraction06	;175
 .byt >CharacterInteraction07	;176
 .byt >CharacterInteraction08	;177
 .byt >CharacterInteraction09	;178
 .byt >CharacterInteraction10	;179
 .byt >CharacterInteraction11	;180
 .byt >CharacterInteraction12	;181
 .byt >CharacterInteraction13	;182
 .byt >CharacterInteraction14	;183
 .byt >CharacterInteraction15	;184

;5 185-216	32		Character Names and descriptions
;Character Names(185-216(32))
 .byt >CharacterLabels00	;185
 .byt >CharacterLabels01	;186
 .byt >CharacterLabels02	;187
 .byt >CharacterLabels03	;188
 .byt >CharacterLabels04	;189
 .byt >CharacterLabels05	;190
 .byt >CharacterLabels06	;191
 .byt >CharacterLabels07	;192
 .byt >CharacterLabels08	;193
 .byt >CharacterLabels09	;194
 .byt >CharacterLabels10	;195
 .byt >CharacterLabels11	;196
 .byt >CharacterLabels12	;197
 .byt >CharacterLabels13	;198
 .byt >CharacterLabels14	;199
 .byt >CharacterLabels15	;200
 .byt >CharacterLabels16	;201
 .byt >CharacterLabels17	;202
 .byt >CharacterLabels18	;203
 .byt >CharacterLabels19	;204
 .byt >CharacterLabels20	;205
 .byt >CharacterLabels21	;206
 .byt >CharacterLabels22	;207
 .byt >CharacterLabels23	;208
 .byt >CharacterLabels24	;209
 .byt >CharacterLabels25	;210
 .byt >CharacterLabels26	;211
 .byt >CharacterLabels27	;212
 .byt >CharacterLabels28	;213
 .byt >CharacterLabels29	;214
 .byt >CharacterLabels30	;215
 .byt >CharacterLabels31	;216

;6 217-224          8		Rumour Texts
;Rumour Texts (217-224(8))
;Rumour Text,255
 .byt >RumourText00		;217
 .byt >RumourText01		;218
 .byt >RumourText02		;219
 .byt >RumourText03		;220
 .byt >RumourText04		;221
 .byt >RumourText05		;222
 .byt >RumourText06		;223
 .byt >RumourText07		;224

;7 225-240	16		Group Text
;Group Text (225-240(16))
;Group Text,255
 .byt >GroupText00		;225
 .byt >GroupText01		;226
 .byt >GroupText02		;227
 .byt >GroupText03		;228
 .byt >GroupText04		;229
 .byt >GroupText05		;230
 .byt >GroupText06		;231
 .byt >GroupText07		;232
 .byt >GroupText08		;233
 .byt >GroupText09		;234
 .byt >GroupText10		;235
 .byt >GroupText11		;236
 .byt >GroupText12		;237
 .byt >GroupText13		;238
 .byt >GroupText14		;239
 .byt >GroupText15		;240
;8 241-253	13		General Text Messages(that may require embedded text)
;General Text Messages(241-253(13))
 .byt >EmbeddedText00	;241
 .byt >EmbeddedText01	;242
 .byt >EmbeddedText02	;243
 .byt >EmbeddedText03	;244
 .byt >EmbeddedText04	;245
 .byt >EmbeddedText05	;246
 .byt >EmbeddedText06	;247
 .byt >EmbeddedText07	;248
 .byt >EmbeddedText08	;249
 .byt >EmbeddedText09	;250
 .byt >EmbeddedText10	;251
 .byt >EmbeddedText11	;252
 .byt >EmbeddedText12	;253


; All Text in game...
; Text in game is always fed to the text-window and may be embedded into other text messages.
; This enables the user to embed keywords into any text and also allows for a much more
; compact format.

; All texts are expanded and reformatted with carriage returns and full stops at end

; Each Text category follows a unique format, usually consisting of a header followed by text
; fields.
; Text fields are always seperated with 254 and terminated (End of data) with 255.

;0 000-031 	32		Unique Objects(Items)
;GraphicLo,GraphicHi,BasePrice(2xBCD),name(up to 8) or code(*),254,description(Up to 72) or code(*),255
;The Field can specify another object to take its contents from.
ObjectFixed00
;descr 012345678901234567890123456789012345678901234567890123456789012345678901
 .byt <gfxRedApple,>gfxRedApple,0,0,"Red Apple",254
;      ******************

 .byt "The Apple looks%"
 .byt "ripe and smells%"
 .byt "succulant.]"
ObjectFixed01
 .byt <gfxFishingNet,>gfxFishingNet,0,0,"Fish Net",254
 .byt "The netting might still be salvaged",255
ObjectFixed02
 .byt <gfxGreenPotion,>gfxGreenPotion,0,0,"Potion",254
 .byt "Green potions are known to restore vitality.",255
ObjectFixed03
 .byt <gfxRedPotion,>gfxRedPotion,0,0,2,254
 .byt "Red Potions sometimes heal and sometimes hurt",255
ObjectFixed04
 .byt <gfxBluePotion,>gfxBluePotion,0,0,2,254
 .byt "Blue potions boost Mana",255
ObjectFixed05
 .byt <gfxFish,>gfxFish,0,0,"Bok Fish",254
 .byt "Bok Fish are very rare and the spawning season is almost over",255
ObjectFixed06
 .byt <gfxStick,>gfxStick,0,0,"Stick",254
 .byt "The wooden stick is strong and flexible",255
ObjectFixed07	;?
 .byt <gfxRedRock,>gfxRedRock,0,0,"Rock",254
 .byt 8,255
ObjectFixed08
 .byt <gfxBlueSphere,>gfxBlueSphere,0,0,"Sphere",254
 .byt "More an interesting object than a useful artifact",255
ObjectFixed09
 .byt <gfxScroll,>gfxScroll,0,0,"Scroll",254
 .byt "You get the feeling it might hurt people if opened",255
ObjectFixed10
 .byt <gfxRedParcel,>gfxRedParcel,0,0,"Parcel",254
 .byt 9,255
ObjectFixed11
 .byt <gfxGreenParcel,>gfxGreenParcel,0,0,10,254
 .byt 9,255
ObjectFixed12
 .byt <gfxYellowWand,>gfxYellowWand,0,0,"Wand",254
 .byt "As you wave it around it leaves a trail of stars",255
ObjectFixed13
 .byt <gfxYellowWand,>gfxYellowWand,0,0,12,254
 .byt 12,255
ObjectFixed14
 .byt <gfxKnife,>gfxKnife,0,0,"Knife",254
 .byt "This knife seems to cut through anything",255
ObjectFixed15
 .byt <gfxFishStew,>gfxFishStew,0,0,"FishStew",254
 .byt "It smells delicious, and seems to remain hot",255
ObjectFixed16
 .byt <gfxGreenSword,>gfxGreenSword,0,0,"Sword",254
 .byt "This sword could be the Great Sword or might not be",255
ObjectFixed17
 .byt <gfxBlueTablet,>gfxBlueTablet,0,0,"Tablet",254
 .byt "The centre of the Tablet has a gently glowing indentation",255
ObjectFixed18
 .byt <gfxBirdCage,>gfxBirdCage,0,0,"Birdcage",254
 .byt "The Bird incensantly repeats everything you say.",255
ObjectFixed19
 .byt <gfxWhiteParchment,>gfxWhiteParchment,0,0,"Parchment",254
 .byt "It seems to read ",34,"if torn will release havoc",34,255
ObjectFixed20
 .byt <gfxBriarPipe,>gfxBriarPipe,0,0,"Old Briar",254
 .byt "This pipe seems in working order, just need some tobacco and a light..",255
ObjectFixed21
 .byt <gfxFlask,>gfxFlask,0,0,"Flask",254
 .byt "The Flask seems to keep liquids scoulding hot",255
ObjectFixed22	;Smoking Pipe
 .byt <gfxBriarPipe,>gfxBriarPipe,0,0,20,254
 .byt 20,255
ObjectFixed23	;Butterfly Net
 .byt <gfxBriarPipe,>gfxBriarPipe,0,0,20,254
 .byt 20,255
ObjectFixed24	;Cat Gut
 .byt <gfxBriarPipe,>gfxBriarPipe,0,0,20,254
 .byt 20,255
ObjectFixed25	;Urn?
 .byt <gfxBriarPipe,>gfxBriarPipe,0,0,20,254
 .byt 20,255
ObjectFixed26
 .byt <gfxBriarPipe,>gfxBriarPipe,0,0,20,254
 .byt 20,255
ObjectFixed27
 .byt <gfxBriarPipe,>gfxBriarPipe,0,0,20,254
 .byt 20,255
ObjectFixed28
 .byt <gfxBriarPipe,>gfxBriarPipe,0,0,20,254
 .byt 20,255
ObjectFixed29
 .byt <gfxBriarPipe,>gfxBriarPipe,0,0,20,254
 .byt 20,255
ObjectFixed30
 .byt <gfxAle,>gfxAle,0,5*16,"Ale",254
 .byt "The Ale smells of old cabbages but tastes nice",255
ObjectFixed31
 .byt <gfxQuestion,>gfxQuestion,0,0,"Unknown",254
 .byt "The owner is hiding this item from your gaze",255
;1 032-122	91		Letters
;Row0,Row1,Row2,Row3,Row4,Row5,VWC Width
Charset6x6
 .byt $40,$40,$40,$40,$40,$40	;32
 .byt $44,$4C,$48,$40,$50,$40
 .byt $54,$54,$40,$40,$40,$40
 .byt $54,$7E,$54,$7E,$54,$40
 .byt $5E,$68,$5C,$4A,$7C,$40
 .byt $52,$44,$48,$50,$64,$40
 .byt $50,$60,$56,$68,$56,$40
 .byt $48,$50,$40,$40,$40,$40
 .byt $48,$50,$50,$50,$48,$40	;40
 .byt $50,$48,$48,$48,$50,$40
 .byt $40,$54,$48,$54,$40,$40
 .byt $40,$48,$5C,$48,$40,$40
 .byt $40,$40,$40,$48,$48,$50
 .byt $40,$40,$5C,$40,$40,$40
 .byt $40,$40,$40,$40,$48,$40
 .byt $42,$44,$48,$50,$60,$40
 .byt $5C,$62,$62,$62,$5C,$40	;48
 .byt $48,$58,$48,$48,$48,$40
 .byt $7C,$42,$5C,$60,$7E,$40
 .byt $7C,$42,$4C,$42,$7C,$40
 .byt $44,$4C,$54,$7E,$44,$40
 .byt $7E,$60,$7C,$42,$7C,$40
 .byt $48,$50,$7C,$62,$5C,$40
 .byt $7E,$42,$44,$48,$48,$40
 .byt $5C,$62,$5C,$62,$5C,$40
 .byt $5C,$62,$5E,$44,$48,$40
 .byt $40,$48,$40,$48,$40,$40
 .byt $40,$48,$40,$48,$48,$50
 .byt $44,$48,$50,$48,$44,$40	;60
 .byt $40,$5C,$40,$5C,$40,$40
 .byt $50,$48,$44,$48,$50,$40
 .byt $5C,$42,$4C,$40,$48,$40
 .byt $5C,$62,$6E,$60,$5C,$40
 .byt $48,$48,$54,$5C,$62,$40	;65
 .byt $7C,$62,$7C,$62,$7C,$40
 .byt $5C,$62,$60,$62,$5C,$40
 .byt $78,$64,$62,$62,$7C,$40
 .byt $7E,$60,$7C,$60,$7E,$40
 .byt $7E,$60,$7C,$60,$60,$40	;70
 .byt $5C,$60,$66,$62,$5C,$40
 .byt $62,$62,$7E,$62,$62,$40
 .byt $7E,$48,$48,$48,$7E,$40
 .byt $42,$42,$42,$62,$5C,$40
 .byt $62,$64,$78,$64,$62,$40
 .byt $60,$60,$60,$60,$7E,$40
 .byt $62,$76,$6A,$62,$62,$40
 .byt $62,$72,$6A,$66,$62,$40
 .byt $5C,$62,$62,$62,$5C,$40
 .byt $7C,$62,$7C,$60,$60,$40	;80
 .byt $5C,$62,$6A,$64,$5A,$40
 .byt $7C,$62,$7C,$64,$62,$40
 .byt $5C,$60,$5C,$42,$7C,$40
 .byt $7E,$48,$48,$48,$48,$40
 .byt $62,$62,$62,$62,$5C,$40
 .byt $62,$54,$54,$48,$48,$40
 .byt $62,$6A,$6A,$54,$54,$40
 .byt $62,$54,$48,$54,$62,$40
 .byt $62,$54,$48,$48,$48,$40
 .byt $7E,$44,$48,$50,$7E,$40	;90
 .byt $58,$50,$50,$50,$58,$40
 .byt $60,$50,$48,$44,$42,$40
 .byt $58,$48,$48,$48,$58,$40
 .byt $48,$54,$62,$40,$40,$40
 .byt $40,$40,$40,$40,$40,$7E
 .byt $4C,$50,$78,$50,$7C,$40
 .byt $40,$5A,$66,$62,$5E,$40
 .byt $60,$6C,$72,$62,$7C,$40
 .byt $40,$5E,$60,$60,$5E,$40
 .byt $42,$5A,$66,$62,$5E,$40	;100
 .byt $40,$5C,$7E,$60,$5C,$40
 .byt $5E,$60,$7C,$60,$60,$40
 .byt $40,$5E,$62,$5E,$42,$5C
 .byt $60,$6C,$72,$62,$62,$40
 .byt $48,$40,$48,$48,$48,$40
 .byt $42,$40,$42,$42,$42,$5C
 .byt $60,$64,$78,$64,$62,$40
 .byt $48,$48,$48,$48,$48,$40
 .byt $40,$74,$6A,$6A,$6A,$40
 .byt $40,$6C,$72,$62,$62,$40	;110
 .byt $40,$5C,$62,$62,$5C,$40
 .byt $40,$7C,$62,$62,$7C,$60
 .byt $40,$5E,$62,$62,$5E,$42
 .byt $40,$6E,$70,$60,$60,$40
 .byt $40,$5C,$70,$4C,$78,$40
 .byt $50,$78,$50,$50,$4C,$40
 .byt $40,$62,$62,$62,$5C,$40
 .byt $40,$62,$54,$54,$48,$40
 .byt $40,$6A,$6A,$54,$54,$40
 .byt $40,$76,$48,$48,$76,$40	;120
 .byt $40,$62,$62,$5E,$42,$5C
 .byt $40,$7E,$44,$50,$7E,$40

;2 123-152	30		keywords
;Fields..
; Character(175-206) or GroupID(0-15) or Anyone(128) to give response
; KeywordText(16) or link
; 254
; KeywordResponse(105) or Link
; 255
Keyword00		;123
 .byt 128,"Birist",254
 .byt "It is the beast spirit of old, born from evil itself.",255
Keyword01		;124
 .byt 128,"Briar Pipe",254
 .byt 125,"is the only one i know of who smokes a pipe",255
Keyword02		;125	;Barton
 .byt 190,"Old Tom",254
 .byt "He is usually found in the old mill house in Homeland. But take some",15,"for him.",255
Keyword03		;126 Spare
 .byt 128,133,254,133,255
Keyword04		;127
 .byt 128,"Dwarven Mines",254
 .byt "They lie at the top of the great mountain in the province of ?",255
Keyword05		;128
 .byt 128,"Old sluece",254
 .byt "It lies beneath the jetty near the Kissing Widow Tavern",255
Keyword06		;129
 .byt 128,"Pit Dragon",254
 .byt "Dragons used to be peaceful animals but are now being driven to hard labour by ",123,255
Keyword07		;130
 .byt 128,"Samson Isle",254
 .byt "That's where the",131,"frequent, though getting their would take a mighty sailor",255
Keyword08		;131
 .byt 128,"Stollon Monks",254
 .byt "Little is known of them apart from they are reputed to posess magical powers.",255
Keyword09		;132
 .byt 128,"Talisman",254
 .byt "The only Talisman i know of is old",133,". I've not seen him but i think Barton has.",255
Keyword10		;133	;Barton
 .byt 190,"Merideth",254
 .byt "Yeah, i saw him a while back. He visits Sassubree Market quite regularly now.",255
Keyword11		;134
 .byt 128,"Keesha",254
 .byt "She works at the Kissing widow Tavern in Sassubree.",255
Keyword12		;135
 .byt 128,133,254,133,255
Keyword13		;136
 .byt 128,133,254,133,255
Keyword14		;137
 .byt 128,133,254,133,255
Keyword15		;138
 .byt 128,133,254,133,255
Keyword16		;139
 .byt 128,133,254,133,255
Keyword17		;140
 .byt 128,133,254,133,255
Keyword18		;141
 .byt 128,133,254,133,255
Keyword19		;142
 .byt 128,133,254,133,255
Keyword20		;143
 .byt 128,133,254,133,255
Keyword21		;144
 .byt 128,133,254,133,255
Keyword22		;145
 .byt 128,133,254,133,255
Keyword23		;146
 .byt 128,133,254,133,255
Keyword24		;147
 .byt 128,133,254,133,255
Keyword25		;148
 .byt 128,133,254,133,255
Keyword26		;149
 .byt 128,133,254,133,255
Keyword27		;150
 .byt 128,133,254,133,255
Keyword28		;151
 .byt 128,133,254,133,255
Keyword29		;152
 .byt 128,133,254,133,255

;3 153-168	16		Names of locations (Inc. Banit River)
;Region Names(153-168(6)) (Maps)
;PlaceName,254,Town/Region Name or link,255
PlaceName00	;153
 .byt "Kissing Widow Tavern",254,"Sassubree",255
PlaceName01	;154
 .byt "Pirates Arms Inn",254,153,255
PlaceName02	;155
 .byt "Market Square",254,153,255
PlaceName03	;156
PlaceName04         ;157
PlaceName05         ;158
PlaceName06         ;159
 .byt "Tallon Monastary",254,"Samson Isle",255
PlaceName07         ;160
 .byt "The Bakery",254,153,255
PlaceName08	;161
 .byt "Mill House",254,"Ritemoor",255
PlaceName09	;162
 .byt "Windmill",254,161,255
PlaceName10	;163
 .byt "Wizards House",254,"Homeland",255
PlaceName11         ;164
 .byt "Banit Witches Castle",254,161,255
PlaceName12         ;165
 .byt "Tirn Church",254,163,255
PlaceName13         ;166
 .byt "Banit River",254,161,255
PlaceName14         ;167
 .byt "Fishy Plaice",254,153,255
PlaceName15         ;168
 .byt "Nowhere",254,"Nowhere",255

;4 169-184	16		Character Interactions(Based on posessed items)
;Character Interactions(169-184(16))
;Fields..
; keyword(123-152)
; Characters(185-216) or GroupIDs(0-15) or Anyone(Leave field blank)
; 254
; posession/s (multiple 0-31) and/or Keywords(123-152) required or leave field blank
; 254
; posession/s taken(multiple 0-31) or leave field blank
; 254
; Response text
; 255
CharacterInteraction00	;169 Old Tom
 .byt 20,207,254,254,15,254
 .byt "I remember seeing a",124,"in the old Bogmire but could never reach it meself",255
CharacterInteraction01	;170
CharacterInteraction02	;171
CharacterInteraction03	;172
CharacterInteraction04	;173
CharacterInteraction05	;174
CharacterInteraction06	;175
CharacterInteraction07	;176
CharacterInteraction08	;177
CharacterInteraction09	;178
CharacterInteraction10	;179
CharacterInteraction11	;180
CharacterInteraction12	;181
CharacterInteraction13	;182
CharacterInteraction14	;183
CharacterInteraction15	;184

;5 185-216	32		Character Names and descriptions
;<FaceGraphicLo,>FaceGraphicHi,Character Names(175-206(32))
;CharacterName,254,CharacterDescription,255
CharacterLabels00   ;185
 .byt <gfxNylot,>gfxNylot,"NYLOT",254
 .byt "Nylot holds a wealth of local bushcraft knowledge",255
CharacterLabels01   ;186
 .byt <gfxDrummond,>gfxDrummond,"DRUMMOND",254
 .byt "Reknowned for his strong morals and strict tea total attitude",255
CharacterLabels02   ;187
 .byt <gfxLief,>gfxLief,"LIEF",254
 .byt "A barmaid as well as the wife of Drummond. Known to follow witchcraft.",255
CharacterLabels03   ;188
 .byt <gfxDerb,>gfxDerb,"DERB",254
 .byt "Makes the finest Breads in the whole of Wurlde.",255
CharacterLabels04   ;189
 .byt <gfxJumbee,>gfxJumbee,"JUMBEE",254
 .byt "Jumbee mends shoes and posesses quite a large collection of foot garments.",255
CharacterLabels05   ;190
 .byt <gfxBarton,>gfxBarton,"BARTON",254
 .byt "One of the oldest Innkeepers and his Fish stew is Wurlde reknowned.",255
CharacterLabels06   ;191
 .byt <gfxKeesha,>gfxKeesha,"KEESHA",254
 .byt "Reputed to be in love with Barton but half his age.",255
CharacterLabels07   ;192
 .byt <gfxKobla,>gfxKobla,"KOBLA",254
 .byt "One of the most dispicable pirates to have existed.",255
CharacterLabels08   ;193
 .byt <gfxRibald,>gfxRibald,"RIBALD",254
 .byt "Known to be Koblas ship mate, Ribald is rarely caught sober.",255
CharacterLabels09   ;194
 .byt <gfxRangard,>gfxRangard,"RANGARD",254
 .byt "Stern and strong, Rangard will not suffer fools gladly.",255
CharacterLabels10   ;195
 .byt <gfxKeggs,>gfxKeggs,"KEGGS",254
 .byt "Salt of the earth Fisherman who has earnt the love of many a maiden.",255
CharacterLabels11   ;196
 .byt <gfxTygor,>gfxTygor,"TYGOR",254
 .byt "Known locally as Rat boy for his Wurlde reknowned fetish for rats.",255
CharacterLabels12   ;197
 .byt <gfxRetnig,>gfxRetnig,"RETNIG",254
 .byt "Retnig is known to enjoy the company of men rather than women.",255
CharacterLabels13   ;198
 .byt <gfxYltendoq,>gfxYltendoq,"YLTENDOQ",254
 .byt "Practising Spheric and also some dark magic for good measure.",255
CharacterLabels14   ;199
 .byt <gfxMardon,>gfxMardon,"MARDON",254
 .byt "Sly and secretive,Mardon will twist the truth to meet his requirements.",255
CharacterLabels15   ;200
 .byt <gfxLintu,>gfxLintu,"LINTU",254
 .byt "Most children have been taken to be enslaved by Birist but Lintu remains.",255
CharacterLabels16   ;201
 .byt <gfxTemple,>gfxTemple,"TEMPLE",254
 .byt "Temple serves at the Kissing Widow Tavern and enjoys swimming.",255
CharacterLabels17   ;202
 .byt <gfxTallard,>gfxTallard,"TALLARD",254
 .byt "Steward of this area and known to have a unsettled grudge on Kobla.",255
CharacterLabels18   ;203
 .byt <gfxKinda,>gfxKinda,"KINDA",254
 .byt "Kinda helps Derb in the bakery and Rangard early in the morning.",255
CharacterLabels19   ;204
 .byt <gfxMerideth,>gfxMerideth,"MERIDETH",254
 .byt "The Talisman holds the key to fortune through rune stone and Olde law.",255
CharacterLabels20   ;205
 .byt <gfxPrest,>gfxPrest,"PREST",254
 .byt "Prest is a servant of the Spheric order of high priests.",255
CharacterLabels21   ;206
 .byt <gfxJiro,>gfxJiro,"JIRO",254
 .byt "Found at birth in the reed banks, Jiro now studies Magic with Erth.",255
CharacterLabels22	;207
 .byt <gfxOldTom,>gfxOldTom,"Old Tom",254
 .byt "Farmer Giles rests his weary feet after another long day resting his feet.",255
CharacterLabels23	;208
CharacterLabels24	;209
CharacterLabels25	;210
CharacterLabels26	;211
CharacterLabels27	;212
CharacterLabels28	;213
CharacterLabels29	;214
CharacterLabels30	;215
CharacterLabels31	;216

;6 217-224          8		Rumour Texts
;Rumour Text,255
RumourText00	;217
;      01234567890123456789012345678901234
 .byt "I heard tell of a",124,"that renders its smoker cold sober!",255
RumourText01	;218
 .byt "Dark clouds are said to be brewing high in the mountains near the",127,255
RumourText02	;219
 .byt "I heard some girl called",134,"lost her gold ring on the quayside "
 .byt "near the",128,"the other day.",255
RumourText03	;220
 .byt "I heard a",129,"has been seen flying over",130,".",255
RumourText04	;221
 .byt "Most people avoid Banit River but i did hear a",132,"found a set of rune stones that banished"
 .byt " the Banit Witches.",255
RumourText05	;222
 .byt "Sorry, i haven't heard anything recently.",255
RumourText06	;223
 .byt "There is a stranger in our midst.",255
RumourText07	;224
 .byt "I don't spread rumours, only facts!",255

;Rumour sets limit the rumours spread by each character. This enables some rumours to be hidden
;until the hero locates the individuals.
;It also prevents inconsistencies like rumours about keesha being spread by keesha!
RumourSet0	;Stern
 .byt 222,224,222,224
RumourSet1	;One
 .byt 222,218,222,218
RumourSet2	;Two
 .byt 217,218,222,222
RumourSet3	;Most
 .byt 219,220,221,223


;7 225-240	16		Group Text
;Group Name,255
GroupText00	;225
 .byt "Innkeeper",255
GroupText01	;226
 .byt "Wench",255
GroupText02	;227
 .byt "Baker",255
GroupText03	;228
 .byt "Cobbler",255
GroupText04	;229
 .byt "Pirate",255
GroupText05	;230
 .byt "Fisherman",255
GroupText06	;231
 .byt "Peasant",255
GroupText07	;232
 .byt "Tribesman",255
GroupText08	;233
 .byt "Dealer",255
GroupText09	;234
 .byt "Child",255
GroupText10	;235
 .byt "Steward",255
GroupText11	;236
 .byt "Farmer",255
GroupText12	;237
 .byt "Seaman",255
GroupText13	;238
 .byt "Clergy",255
GroupText14	;239
 .byt "Sorcerer",255
GroupText15	;240
 .byt "Spare",255

;6 241-253	13		General Text Messages
EmbeddedText00	;241
 .byt "Heard any rumours?",255
EmbeddedText01       ;242
 .byt "No Item in this Pocket.",255
EmbeddedText02       ;243
 .byt "This item is currently hidden.",255
EmbeddedText03       ;244
EmbeddedText04       ;245
EmbeddedText05       ;246
EmbeddedText06       ;247
EmbeddedText07       ;248
EmbeddedText08       ;249
EmbeddedText09       ;250
EmbeddedText10       ;251
EmbeddedText11       ;252
EmbeddedText12       ;253

;********************* End of Embedded Text types ********************

;The following texts do not generate keywords or require words used above.

;There are currently a total of ? option sets, each one containing X number
;of options. Options are built at runtime in Selector.s
OptionPromptLo
 .byt <OptionPrompt00
 .byt <OptionPrompt01
 .byt <OptionPrompt02
 .byt <OptionPrompt03
 .byt <OptionPrompt04
 .byt <OptionPrompt05
 .byt <OptionPrompt06
 .byt <OptionPrompt07
OptionPromptHi
 .byt >OptionPrompt00
 .byt >OptionPrompt01
 .byt >OptionPrompt02
 .byt >OptionPrompt03
 .byt >OptionPrompt04
 .byt >OptionPrompt05
 .byt >OptionPrompt06
 .byt >OptionPrompt07

OptionPrompt00      ;
 .byt "Select option..",255
OptionPrompt01      ;
 .byt "Select keyword..",255
OptionPrompt02      ;
 .byt "Select first item..",255
OptionPrompt03	;
 .byt "Select second item..",255
OptionPrompt04	;
 .byt "Select third item..",255
OptionPrompt05	;
 .byt "Select item",255
OptionPrompt06	;
 .byt "Select item you wish to buy..",255
OptionPrompt07	;
 .byt "Select item you wish to sell..",255


GeneralTextLo
 .byt <GeneralText00
 .byt <GeneralText01
 .byt <GeneralText02
 .byt <GeneralText03
 .byt <GeneralText04
GeneralTextHi
 .byt >GeneralText00
 .byt >GeneralText01
 .byt >GeneralText02
 .byt >GeneralText03
 .byt >GeneralText04

;Welcome text at start of game
GeneralText00	;
 .byt "And as the waves crash on the shore the hero is awoken to face a new day..",255
;Character Dead Message
GeneralText01	;
 .byt "They may have played a small part, may have loved and been adored but now lies alone..",255
;Hero dies Message
GeneralText02	;
 .byt "And so another life is lost, in this small chapter.",255
;Hero As Character description
GeneralText03	;
 .byt "My name is Lucien But little else i know. I may be a Hero someday.",255
GeneralText04
 .byt "YOU!",255
GeneralText05
 .byt "LUCIEN",255

;Option Lists
OptionListTextLo
 .byt <OptionListText00	;
 .byt <OptionListText01	;
 .byt <OptionListText02	;
 .byt <OptionListText03	;
 .byt <OptionListText04	;
 .byt <OptionListText05	;
 .byt <OptionListText06	;
 .byt <OptionListText07	;
 .byt <OptionListText08	;
 .byt <OptionListText09	;
 .byt <OptionListText10	;
 .byt <OptionListText11	;
 .byt <OptionListText12	;
 .byt <OptionListText13	;
 .byt <OptionListText14	;
 .byt <OptionListText15	;
OptionListTextHi
 .byt >OptionListText00	;
 .byt >OptionListText01	;
 .byt >OptionListText02	;
 .byt >OptionListText03	;
 .byt >OptionListText04	;
 .byt >OptionListText05	;
 .byt >OptionListText06	;
 .byt >OptionListText07	;
 .byt >OptionListText08	;
 .byt >OptionListText09	;
 .byt >OptionListText10	;
 .byt >OptionListText11	;
 .byt >OptionListText12	;
 .byt >OptionListText13	;
 .byt >OptionListText14	;
 .byt >OptionListText15	;

;Option Lists (207-247(41))
OptionListText00	;
 .byt "Combine Items",255
OptionListText01	;
 .byt "Ask about..",255
OptionListText02	;
 .byt "Rumours?",255
OptionListText03	;
 .byt "Examine Items",255
OptionListText04	;
 .byt "Seek Lodging",255
OptionListText05	;
 .byt "Buy Item",255
OptionListText06	;
 .byt "Sell Item",255
OptionListText07	;
 .byt "Compliment",255
OptionListText08	;
 .byt "Insult",255
OptionListText09    ;
 .byt "Lend Item",255
OptionListText10    ;
 .byt "Recall Item",255
OptionListText11    ;
 .byt "Buy Ale",255
OptionListText12	;
 .byt "Haggle Price",255
OptionListText13	;
 .byt "Yes",255
OptionListText14	;
 .byt "No",255
OptionListText15	;
 .byt "Cancel",255




ComplimentTextLo
 .byt <ComplimentText00
 .byt <ComplimentText01
 .byt <ComplimentText02
 .byt <ComplimentText03
ComplimentTextHi
 .byt >ComplimentText00
 .byt >ComplimentText01
 .byt >ComplimentText02
 .byt >ComplimentText03

ComplimentText00
 .byt "You are looking very well today.",255
ComplimentText01
 .byt "You really are attractive.",255
ComplimentText02
 .byt "I really want to kiss you",255
ComplimentText03
 .byt "Get your coat, you've just pulled.",255


InsultTextLo
 .byt <InsultText00
 .byt <InsultText01
 .byt <InsultText02
 .byt <InsultText03
InsultTextHi
 .byt >InsultText00
 .byt >InsultText01
 .byt >InsultText02
 .byt >InsultText03

InsultText00
 .byt "I don't think i like you anymore.",255
InsultText01
 .byt "You remind me of an old drunk i knew.",255
InsultText02
 .byt "Why didn't you run away with the sewerage?",255
InsultText03
 .byt "Don't talk, it smells bad when you talk",255

CharacterResponseText2Compliment
CharacterResponseText2Insult
 .byt "Errr... Ok"
 .byt "Is that so?"
 .byt "Well
NoHeroItemText
 .byt "         ",255

CharacterDeadText
 .byt "The inert lump does not move.",255
