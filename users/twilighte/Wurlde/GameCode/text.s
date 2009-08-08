;text.s - Holds all common text in game.
;Character specific interactions, location narratives and cut scene stories are
;held in specific SSC source files.

;This needs to be sorted!
;1) Item names and description must exist in main memory because they can be used at any time
;2)?Technically the group name could be held in SSC rather than here
;3) The character name needs to exist in main memory because other characters may refer to them
;   and would crunch the data a little?
;4)?Character descriptions should NOT exist here and can exist in SSC only.
;5) Keywords must exist here because they can be enquired upon at any time
;6)?Technically placenames can also exist in SSC although if a magical artifact is invented that
;   can transport the hero to any part of Wurlde, they will be required
;7) Common words should remain here
; May need to expand keywords to 64

;TextSet0
EmbeddedTextAddressLo
 .byt <EmbeddedText00
 .byt <EmbeddedText01
 .byt <EmbeddedText02
 .byt <EmbeddedText03
 .byt <EmbeddedText04
 .byt <EmbeddedText05
 .byt <EmbeddedText06
 .byt <EmbeddedText07
 .byt <EmbeddedText08
 .byt <EmbeddedText09
 .byt <EmbeddedText10
 .byt <EmbeddedText11
 .byt <EmbeddedText12
 .byt <EmbeddedText13
 .byt <EmbeddedText14
 .byt <EmbeddedText15
 .byt <EmbeddedText16
 .byt <EmbeddedText17
 .byt <EmbeddedText18
 .byt <EmbeddedText19
 .byt <EmbeddedText20
 .byt <EmbeddedText21
 .byt <EmbeddedText22
 .byt <EmbeddedText23
 .byt <EmbeddedText24
 .byt <EmbeddedText25
 .byt <EmbeddedText26
 .byt <EmbeddedText27
 .byt <EmbeddedText28
 .byt <EmbeddedText29
 .byt <EmbeddedText30
 .byt <EmbeddedText31
 .byt <EmbeddedText128
 .byt <EmbeddedText129
 .byt <EmbeddedText130
 .byt <EmbeddedText131
 .byt <EmbeddedText132
 .byt <EmbeddedText133
 .byt <EmbeddedText134
 .byt <EmbeddedText135
 .byt <EmbeddedText136
 .byt <EmbeddedText137
 .byt <EmbeddedText138
 .byt <EmbeddedText139
 .byt <EmbeddedText140
 .byt <EmbeddedText141
 .byt <EmbeddedText142
 .byt <EmbeddedText143
 .byt <EmbeddedText144
 .byt <EmbeddedText145
 .byt <EmbeddedText146
 .byt <EmbeddedText147
 .byt <EmbeddedText148
 .byt <EmbeddedText149
 .byt <EmbeddedText150
 .byt <EmbeddedText151
 .byt <EmbeddedText152
 .byt <EmbeddedText153
 .byt <EmbeddedText154
 .byt <EmbeddedText155
 .byt <EmbeddedText156
 .byt <EmbeddedText157
 .byt <EmbeddedText158
 .byt <EmbeddedText159
 .byt <EmbeddedText160
 .byt <EmbeddedText161
 .byt <EmbeddedText162
 .byt <EmbeddedText163
 .byt <EmbeddedText164
 .byt <EmbeddedText165
 .byt <EmbeddedText166
 .byt <EmbeddedText167
 .byt <EmbeddedText168
 .byt <EmbeddedText169
 .byt <EmbeddedText170
 .byt <EmbeddedText171
 .byt <EmbeddedText172
 .byt <EmbeddedText173
 .byt <EmbeddedText174
 .byt <EmbeddedText175
 .byt <EmbeddedText176
 .byt <EmbeddedText177
 .byt <EmbeddedText178
 .byt <EmbeddedText179
 .byt <EmbeddedText180
 .byt <EmbeddedText181
 .byt <EmbeddedText182
 .byt <EmbeddedText183
 .byt <EmbeddedText184
 .byt <EmbeddedText185
 .byt <EmbeddedText186
 .byt <EmbeddedText187
 .byt <EmbeddedText188
 .byt <EmbeddedText189
 .byt <EmbeddedText190
 .byt <EmbeddedText191
 .byt <EmbeddedText192
 .byt <EmbeddedText193
 .byt <EmbeddedText194
 .byt <EmbeddedText195
 .byt <EmbeddedText196
 .byt <EmbeddedText197
 .byt <EmbeddedText198
 .byt <EmbeddedText199
 .byt <EmbeddedText200
 .byt <EmbeddedText201
 .byt <EmbeddedText202
 .byt <EmbeddedText203
 .byt <EmbeddedText204
 .byt <EmbeddedText205
 .byt <EmbeddedText206
 .byt <EmbeddedText207
 .byt <EmbeddedText208
 .byt <EmbeddedText209
 .byt <EmbeddedText210
 .byt <EmbeddedText211
 .byt <EmbeddedText212
 .byt <EmbeddedText213
 .byt <EmbeddedText214
 .byt <EmbeddedText215
 .byt <EmbeddedText216
 .byt <EmbeddedText217
 .byt <EmbeddedText218
 .byt <EmbeddedText219
 .byt <EmbeddedText220
 .byt <EmbeddedText221
 .byt <EmbeddedText222
 .byt <EmbeddedText223
 .byt <EmbeddedText224
 .byt <EmbeddedText225
 .byt <EmbeddedText226
 .byt <EmbeddedText227
 .byt <EmbeddedText228
 .byt <EmbeddedText229
 .byt <EmbeddedText230
 .byt <EmbeddedText231
 .byt <EmbeddedText232
 .byt <EmbeddedText233
 .byt <EmbeddedText234
 .byt <EmbeddedText235
 .byt <EmbeddedText236
 .byt <EmbeddedText237
 .byt <EmbeddedText238
 .byt <EmbeddedText239
 .byt <EmbeddedText240
 .byt <EmbeddedText241
 .byt <EmbeddedText242
 .byt <EmbeddedText243
 .byt <EmbeddedText244
 .byt <EmbeddedText245
 .byt <EmbeddedText246
 .byt <EmbeddedText247
 .byt <EmbeddedText248
 .byt <EmbeddedText249
 .byt <EmbeddedText250
 .byt <EmbeddedText251
 .byt <EmbeddedText252
 .byt <EmbeddedText253
 .byt <EmbeddedText254
 .byt <EmbeddedText255

EmbeddedTextAddressHi
 .byt >EmbeddedText00	;00  Objects
 .byt >EmbeddedText01         ;01  Objects
 .byt >EmbeddedText02         ;02  Objects
 .byt >EmbeddedText03         ;03  Objects
 .byt >EmbeddedText04         ;04  Objects
 .byt >EmbeddedText05         ;05  Objects
 .byt >EmbeddedText06         ;06  Objects
 .byt >EmbeddedText07         ;07  Objects
 .byt >EmbeddedText08         ;08  Objects
 .byt >EmbeddedText09         ;09  Objects
 .byt >EmbeddedText10         ;10  Objects
 .byt >EmbeddedText11         ;11  Objects
 .byt >EmbeddedText12         ;12  Objects
 .byt >EmbeddedText13         ;13  Objects
 .byt >EmbeddedText14         ;14  Objects
 .byt >EmbeddedText15         ;15  Objects
 .byt >EmbeddedText16         ;16  Objects
 .byt >EmbeddedText17         ;17  Objects
 .byt >EmbeddedText18         ;18  Objects
 .byt >EmbeddedText19         ;19  Objects
 .byt >EmbeddedText20         ;20  Objects
 .byt >EmbeddedText21         ;21  Objects
 .byt >EmbeddedText22         ;22  Objects
 .byt >EmbeddedText23         ;23  Objects
 .byt >EmbeddedText24         ;24  Objects
 .byt >EmbeddedText25         ;25  Objects
 .byt >EmbeddedText26         ;26  Objects
 .byt >EmbeddedText27         ;27  Objects
 .byt >EmbeddedText28         ;28  Objects
 .byt >EmbeddedText29         ;29  Objects
 .byt >EmbeddedText30         ;30  Objects
 .byt >EmbeddedText31         ;31  Objects
;The reason why this split occurs is that the embedded code is either 0-31 or 128-255
;The code itself subtracts 96 if the value is greater than 31 to index this table.
 .byt >EmbeddedText128        ;32  Group
 .byt >EmbeddedText129        ;33  Group
 .byt >EmbeddedText130        ;34  Group
 .byt >EmbeddedText131        ;35  Group
 .byt >EmbeddedText132        ;36  Group
 .byt >EmbeddedText133        ;37  Group
 .byt >EmbeddedText134        ;38  Group
 .byt >EmbeddedText135        ;39  Group
 .byt >EmbeddedText136        ;40  Group
 .byt >EmbeddedText137        ;41  Group
 .byt >EmbeddedText138        ;42  Group
 .byt >EmbeddedText139        ;43  Group
 .byt >EmbeddedText140        ;44  Group
 .byt >EmbeddedText141        ;45  Group
 .byt >EmbeddedText142        ;46  Group
 .byt >EmbeddedText143        ;47  Group
 .byt >EmbeddedText144        ;48  Character
 .byt >EmbeddedText145        ;49  Character
 .byt >EmbeddedText146        ;50  Character
 .byt >EmbeddedText147        ;51  Character
 .byt >EmbeddedText148        ;52  Character
 .byt >EmbeddedText149        ;53  Character
 .byt >EmbeddedText150        ;54  Character
 .byt >EmbeddedText151        ;55  Character
 .byt >EmbeddedText152        ;56  Character
 .byt >EmbeddedText153        ;57  Character
 .byt >EmbeddedText154        ;58  Character
 .byt >EmbeddedText155        ;59  Character
 .byt >EmbeddedText156        ;60  Character
 .byt >EmbeddedText157        ;61  Character
 .byt >EmbeddedText158        ;62  Character
 .byt >EmbeddedText159        ;63  Character
 .byt >EmbeddedText160        ;64  Character
 .byt >EmbeddedText161        ;65  Character
 .byt >EmbeddedText162        ;66  Character
 .byt >EmbeddedText163        ;67  Character
 .byt >EmbeddedText164        ;68  Character
 .byt >EmbeddedText165        ;69  Character
 .byt >EmbeddedText166        ;70  Character
 .byt >EmbeddedText167        ;71  Character
 .byt >EmbeddedText168        ;72  Character
 .byt >EmbeddedText169        ;73  Character
 .byt >EmbeddedText170        ;74  Character
 .byt >EmbeddedText171        ;75  Character
 .byt >EmbeddedText172        ;76  Character
 .byt >EmbeddedText173        ;77  Character
 .byt >EmbeddedText174        ;78  Character
 .byt >EmbeddedText175        ;79  Character
 .byt >EmbeddedText176        ;80  Keyword
 .byt >EmbeddedText177        ;81  Keyword
 .byt >EmbeddedText178        ;82  Keyword
 .byt >EmbeddedText179        ;83  Keyword
 .byt >EmbeddedText180        ;84  Keyword
 .byt >EmbeddedText181        ;85  Keyword
 .byt >EmbeddedText182        ;86  Keyword
 .byt >EmbeddedText183        ;87  Keyword
 .byt >EmbeddedText184        ;88  Keyword
 .byt >EmbeddedText185        ;89  Keyword
 .byt >EmbeddedText186        ;90  Keyword
 .byt >EmbeddedText187        ;91  Keyword
 .byt >EmbeddedText188        ;92  Keyword
 .byt >EmbeddedText189        ;93  Keyword
 .byt >EmbeddedText190        ;94  Keyword
 .byt >EmbeddedText191        ;95  Keyword
 .byt >EmbeddedText192        ;96  Keyword
 .byt >EmbeddedText193        ;97  Keyword
 .byt >EmbeddedText194        ;98  Keyword
 .byt >EmbeddedText195        ;99  Keyword
 .byt >EmbeddedText196        ;100 Keyword
 .byt >EmbeddedText197        ;101 Keyword
 .byt >EmbeddedText198        ;102 Keyword
 .byt >EmbeddedText199        ;103 Keyword
 .byt >EmbeddedText200        ;104 Keyword
 .byt >EmbeddedText201        ;105 Keyword
 .byt >EmbeddedText202        ;106 Keyword
 .byt >EmbeddedText203        ;107 Keyword
 .byt >EmbeddedText204        ;108 Keyword
 .byt >EmbeddedText205        ;109 Keyword
 .byt >EmbeddedText206        ;110 Keyword
 .byt >EmbeddedText207        ;111 Keyword
 .byt >EmbeddedText208        ;112 Location
 .byt >EmbeddedText209        ;113 Location
 .byt >EmbeddedText210        ;114 Location
 .byt >EmbeddedText211        ;115 Location
 .byt >EmbeddedText212        ;116 Location
 .byt >EmbeddedText213        ;117 Location
 .byt >EmbeddedText214        ;118 Location
 .byt >EmbeddedText215        ;119 Location
 .byt >EmbeddedText216        ;120 Location
 .byt >EmbeddedText217        ;121 Location
 .byt >EmbeddedText218        ;122 Location
 .byt >EmbeddedText219        ;123 Location
 .byt >EmbeddedText220        ;124 Location
 .byt >EmbeddedText221        ;125 Location
 .byt >EmbeddedText222        ;126 Location
 .byt >EmbeddedText223        ;127 Location
 .byt >EmbeddedText224        ;128 General Text
 .byt >EmbeddedText225        ;129 General Text
 .byt >EmbeddedText226        ;130 General Text
 .byt >EmbeddedText227        ;131 General Text
 .byt >EmbeddedText228        ;132 General Text
 .byt >EmbeddedText229        ;133 General Text
 .byt >EmbeddedText230        ;134 General Text
 .byt >EmbeddedText231        ;135 General Text
 .byt >EmbeddedText232        ;136 General Text
 .byt >EmbeddedText233        ;137 General Text
 .byt >EmbeddedText234        ;138 General Text
 .byt >EmbeddedText235        ;139 General Text
 .byt >EmbeddedText236        ;140 General Text
 .byt >EmbeddedText237        ;141 General Text
 .byt >EmbeddedText238        ;142 General Text
 .byt >EmbeddedText239        ;143 General Text
 .byt >EmbeddedText240        ;144 General Text
 .byt >EmbeddedText241        ;145 General Text
 .byt >EmbeddedText242        ;146 General Text
 .byt >EmbeddedText243        ;147 General Text
 .byt >EmbeddedText244        ;148 General Text
 .byt >EmbeddedText245        ;149 General Text
 .byt >EmbeddedText246        ;150 General Text
 .byt >EmbeddedText247        ;151 General Text
 .byt >EmbeddedText248        ;152 General Text
 .byt >EmbeddedText249        ;153 General Text
 .byt >EmbeddedText250        ;154 General Text
 .byt >EmbeddedText251        ;155 General Text
 .byt >EmbeddedText252        ;156 General Text
 .byt >EmbeddedText253        ;157 General Text
 .byt >EmbeddedText254        ;158 General Text
 .byt >EmbeddedText255        ;159 General Text

EmbeddedText00
;0-31	Objects(32)
;9x1  Name (EOF==])
;18x4 Description (CR==% EOF==])
;>>>>>>*********
 .byt "Fruit]"
;>>>>>>******************
 .byt "Fruit is sometimes%"
 .byt "hard to forage for%"
 .byt "because most of it%"
 .byt "is seasonal.]"
EmbeddedText01
 .byt "Net]"
;>>>>>>******************
 .byt "Useful in catching%"
 .byt "butterflies,flies,%"
 .byt "moths and insects,%"
 .byt "and it is durable.]"
EmbeddedText02
 .byt "Potion]"
;>>>>>>******************
 .byt "A secret blend of%"
 .byt "herbs, funghi and%"
 .byt "spices brewed to%"
 .byt "restore vitality.]"
EmbeddedText03
;>>>>>>*********
 .byt "Elixir]"
;>>>>>>******************
 .byt "Said to hold blood%"
 .byt "from a pit dragon,%"
 .byt "this elixir boosts%"
 .byt "health & vitality.]"
EmbeddedText04
 .byt "Vial]"
 .byt "A mixture of many%"
 .byt "minerals and herbs%"
 .byt "that boost Mana,%"
 .byt "focusing the mind.]"
EmbeddedText05
 .byt "Bok Fish]"
;>>>>>>******************
 .byt "Bok Fish are very%"
 .byt "rare in Sassubree%"
 .byt "but offer a tasty%"
 .byt "alternative fish.]"
EmbeddedText06
 .byt "Spare]"
 .byt "The wooden stick%"
 .byt "is strong and%"
 .byt "flexible]"
EmbeddedText07
 .byt "Spare]"	;Spare?
 .byt "More of geological%"
 .byt "interest than a%"
 .byt "useful artifact]"
EmbeddedText08
 .byt "Butterfly]"
;>>>>>>******************
 .byt "This Butterfly is%"
 .byt "a particular type%"
 .byt "that provides red%"
 .byt "pigment for ink.]"
; .byt "Sphere]"
; .byt "The Sphere is made%"
; .byt "of glass with no%"
; .byt "apparent seam.%"
; .byt "It glows within]"
EmbeddedText09
 .byt "Scroll]"
 .byt "You get the%"
 .byt "feeling it might%"
 .byt "hurt people if%"
 .byt "opened]"
EmbeddedText10
 .byt "AquaStone]"	;Spare?
;>>>>>>******************
 .byt "The stone soaks up%"
 .byt "sea water draining%"
 .byt "it to fresh water%"
 .byt "which is drinkable]"
EmbeddedText11
 .byt "Mire Note]"	;Spare?
 .byt " Rising in silvery%"
 .byt "ink the note says:%"
 .byt "Like King Galdwine%"
 .byt "Hide In Every Area]"
EmbeddedText12
 .byt "IvoryWand]"
 .byt "As you wave it%"
 .byt "around it leaves a%"
 .byt "trail of stars]"
EmbeddedText13
 .byt "EbonyWand]"
 .byt "It seems to cut%"
 .byt "the air leaving%"
 .byt "a black streak%"
 .byt "in its wake]"
EmbeddedText14
 .byt "Knife]"
 .byt "This knife seems%"
 .byt "to cut through%"
 .byt "anything]"
EmbeddedText15
 .byt "Fish Stew]"
;>>>>>>******************
 .byt "Barton's Fish Stew%"
 .byt "is a hotpot of the%"
 .byt "finest ingredients%"
 .byt "served with Bread.]"
EmbeddedText16
 .byt "Sword]"
 .byt "This sword could%"
 .byt "be the Great Sword%"
 .byt "or might not be]"
EmbeddedText17
 .byt "Tablet]"	;Spare?
;>>>>>>******************
 .byt "Stone tablets are%"
 .byt "commonly surface%"
 .byt "notch on one edge%"
 .byt "permitting is cold to%
 .byt "the touch notch
EmbeddedText18
 .byt "Bird Cage]"
;>>>>>>******************
 .byt "The canary within%"
 .byt "incessantly relays%"
 .byt "every syllable you%"
 .byt "utter back at you.]"
EmbeddedText19
 .byt "Parchment]"
;>>>>>>******************
 .byt "The silvery words%"
 .byt "gradually appear:"
 .byt "Only Knives Greet%"
 .byt "Hiding Deserters.]    "
EmbeddedText20
 .byt "Old Briar]"
 .byt "As soon as air is%"
 .byt "drawn through it,%"
 .byt "a sweat pungent%"
 .byt "aroma is received]"
EmbeddedText21
 .byt "GreasePot]"
;>>>>>>******************
 .byt "The Flask contains%"
 .byt "Grease, commonly a%"
 .byt "lubricant for wood%"
 .byt "based machinery.]"
EmbeddedText22
 .byt "Grog]"
 .byt "The Ale smells of%"
 .byt "rotten cabbages%"
 .byt "but tastes nice]"
EmbeddedText23
 .byt "Glant]"
;>>>>>>******************
 .byt "Glant are the most%"
 .byt "prevalent fish in%"
 .byt "these parts. They%"
 .byt "are often salted.]"
EmbeddedText24
 .byt "Lodging]"
 .byt "The bed has clean%"
 .byt "linen in an airy%"
 .byt "room and includes%"
 .byt "a hearty breakfast]"
EmbeddedText25
;>>>>>>******************
 .byt "Blak Loaf]"
 .byt "This unleven Dark%"
 .byt "bread is hard but%"
 .byt "lasts for weeks.]"
EmbeddedText26
 .byt "Lem Bread]"
 .byt "This leven Bread%"
 .byt "is sweet and pro-%"
 .byt "vides nourishment%"
 .byt "like no other.]"
EmbeddedText27
 .byt "Funghi]"
;>>>>>>******************
 .byt "Funghi is abundant%"
 .byt "locally, Providing%"
 .byt "food and medicinal%"
 .byt "properties.]"
EmbeddedText28
 .byt "Bow]"
;>>>>>>******************
 .byt "The strong bow was%"
 .byt "hune from the best%"
 .byt "Sampa,a local wood%"
 .byt "and Cat gut string]"
EmbeddedText29
 .byt "Arrows]"
;>>>>>>******************
 .byt "Iron tipped arrows%"
 .byt "with feathers from%"
 .byt "the rare Faba bird%"
 .byt "and stem of Sampa.]"
EmbeddedText30
 .byt "GreatHorn]"
;>>>>>>******************
 .byt "The Horn was used%"
 .byt "to summon the Pit%"
 .byt "dragon of old.]"
EmbeddedText31
 .byt "SpellBook]"
 .byt "The book of spells%"
 .byt "is leather bound &%"
 .byt "covered in spidery%"
 .byt "elven runes.]"
;128-143	Group(16)
;>>>>>>*********
EmbeddedText128
 .byt "Publican]"
EmbeddedText129
 .byt "Pirate]"
EmbeddedText130
 .byt "Baker]"
EmbeddedText131
 .byt "Cobbler]"
EmbeddedText132
 .byt "Labourer]"
EmbeddedText133
 .byt "Fisherman]"
EmbeddedText134
 .byt "Peasant]"
EmbeddedText135
 .byt "Tribesman]"
EmbeddedText136
 .byt "Grocer]"
EmbeddedText137
 .byt "Carpenter]"
EmbeddedText138
 .byt "Steward]"
EmbeddedText139
 .byt "Antiquary]"
EmbeddedText140
 .byt "FishMongr]"
EmbeddedText141
 .byt "Clergyman]"
EmbeddedText142
 .byt "Sorcerer]"
EmbeddedText143
 .byt "Ironsmith]"
;144-175	Character Name(32)
;>>>>>>********
;>>>>>>******************
EmbeddedText144	;0
 .byt "NYLOT]"	;Location 15(1 of 1) (Solice)
; .byt "Nylot is a Tribes-%"
; .byt "man and holds a%"
; .byt "wealth of local%"
; .byt "knowledge]"
EmbeddedText145	;1
 .byt "DRUMMOND]"	;Location 1(1 of ?) (Pirates Arms)
; .byt "Reknowned for his%"
; .byt "strong morals and%"
; .byt "strict tea total%"
; .byt "attitude]"
EmbeddedText146	;2
 .byt "LIEF]"	;Location 1(2 of ?) (Pirates Arms)
; .byt "A barmaid as well%"
; .byt "as the wife of%"
; .byt "Drummond. Known to%"
; .byt "follow witchcraft]"
EmbeddedText147	;3
 .byt "DERB]"	;Location 7(1 of 2) (Bakery)
;>>>>>>******************
; .byt "Derb the baker%"
; .byt "makes some of the%"
; .byt "finest Breads in%"
; .byt "all of Wurlde.]"
EmbeddedText148	;4
 .byt "JUMBEE]"	;Location 2(1 of ?) (Market Square)
; .byt "Jumbee mends shoes%"
; .byt "and posesses quite%"
; .byt "a large collection%"
; .byt "of foot garments]"
EmbeddedText149	;5
 .byt "BARTON]"     ;Location 0(1 of 6) (Kissing Widow)
; .byt "One of the oldest%"
; .byt "Innkeepers and his%"
; .byt "Fish stew is%"
; .byt "Wurlde reknowned]"
EmbeddedText150	;6
 .byt "KEESHA]"	;Location 0(2 of 6) (Kissing Widow)
; .byt "Reputed to be in%"
; .byt "love with Barton%"
; .byt "but half his age]"
EmbeddedText151	;7
 .byt "KOBLA]"	;Location 0(3 of 6) (Kissing Widow)
; .byt "One of the most%"
; .byt "dispicable pirates%"
; .byt "to have existed]"
EmbeddedText152	;8
 .byt "RIBALD]"     ;Location 0(4 of 6) (Kissing Widow)
; .byt "Known to be Koblas%"
; .byt "ship mate, Ribald%"
; .byt "is rarely caught%"
; .byt "sober]"
EmbeddedText153	;9
 .byt "RANGARD]"	;Location 14(1 of ?) and 1(3 of ?)
; .byt "Stern and strong,%"
; .byt "Rangard will not%"
; .byt "suffer fools%"
; .byt "gladly]"
EmbeddedText154	;10
 .byt "KEGGS]"      ;Location 0(5 of 6) (Kissing Widow)
; .byt "Salt of the earth%"
; .byt "Fisherman who has%"
; .byt "earnt the love of%"
; .byt "many a maiden]"
EmbeddedText155	;11
 .byt "MILO]"	;Location 2(2 of ?) (Market Square)
; .byt "Known locally as%"
; .byt "Rat boy for his%"
; .byt "Wurlde reknowned%"
; .byt "fetish for rats]"
EmbeddedText156	;12
 .byt "RETNIG]"     ;Location 1(4 of 4) (Pirates Arms)
; .byt "Retnig is known%"
; .byt "to enjoy the%"
; .byt "company of men%"
; .byt "rather than women]"
EmbeddedText157	;13
 .byt "YLTENDOQ]"   ;Location 6(1 of ?) (Samson Monastary)
; .byt "Practising Spheric%"
; .byt "and also some dark%"
; .byt "magic for good%"
; .byt "measure]"
EmbeddedText158	;14
 .byt "MARDON]"
; .byt "Sly and secretive,%"
; .byt "Mardon will twist%"
; .byt "the truth to meet%"
; .byt "his requirements]"
EmbeddedText159	;15
 .byt "LINTU]"	;Location 2(4 of 6) (Market Square)
; .byt "Lintu is a%"
; .byt "scavenger child]"
EmbeddedText160	;16
 .byt "TEMPLE]"	;Location 0(6 of 6) (Fishy Plaice)
; .byt "Temple serves at%"
; .byt "the Kissing Widow%"
; .byt "Tavern and enjoys%"
; .byt "swimming]"
EmbeddedText161	;17
 .byt "TALLARD]"	;Location 1(3 of 4) (Pirates Arms)
; .byt "Steward of this%"
; .byt "area and known to%"
; .byt "have a unsettled%"
; .byt "grudge on Kobla]"
EmbeddedText162	;18
 .byt "KINDA]"	;Location 7(2 of 2) (Bakery) and 14(2 of ?) (Fishy Plaice)
; .byt "Kinda helps Derb%"
; .byt "in the bakery and%"
; .byt "Rangard early in%"
; .byt "the morning]"
EmbeddedText163	;19
 .byt "ABBOT]"   ;Location 2(5 of 6) (Market Square)
; .byt "The Talisman holds%"
; .byt "the key to fortune%"
; .byt "through rune stone%"
; .byt "and Old law]"
EmbeddedText164	;20
 .byt "PREST]"	;Location 12(1 of 1) (Tirn Church)
; .byt "Prest is a servant%"
; .byt "of the Spheric%"
; .byt "order of high%"
; .byt "priests]"
EmbeddedText165	;21
 .byt "JIRO]"	;Location 10(1 of 2) (Wizards House)
; .byt "Found at birth in%"
; .byt "the reed banks,%"
; .byt "Jiro now studies%"
; .byt "Magic with Erth]"
EmbeddedText166	;22
 .byt "OLD TOM]"	;Location 8(1 of 1) (Mill House)
; .byt "Farmer Giles rests%"
; .byt "his weary feet%"
; .byt "after another long%"
; .byt "day resting]"
EmbeddedText167	;23
 .byt "MERIDETH]"	;Location 11(1 of 3) (Banit Castle)
; .byt "Herbs and plants%"
; .byt "i grow, to hinder%"
; .byt "and to drug.]"
EmbeddedText168	;24
 .byt "WITCH]"     ;Location 11(2 of 3) (Banit Castle)
; .byt "Fire and brimstone%"
; .byt "these are my tools%"
; .byt "so keep at bay and%"
; .byt "follow my rules.]"
EmbeddedText169	;25
 .byt "SPIDER]"     ;Location 11(3 of 3) (Banit Castle)
; .byt "Power is within my%"
; .byt "mind, sweet brain%"
; .byt "i yearn, the more%"
; .byt "alive the tender.]"
EmbeddedText170	;26
;>>>>>>******************
 .byt "ERTH]"	;Location 10(2 of 2) (Wizards House)
; .byt "The Last of the%"
; .byt "Great Wizards to%"
; .byt "still remain.]"
EmbeddedText171	;27
 .byt "MUNK]"	;Location
; .byt "Hearty monk of the%"
; .byt "Spherics,known for%"
; .byt "his good beer.%"
EmbeddedText172	;28
 .byt "ROTFILSH]"
EmbeddedText173
 .byt "TRIFFITH]"	;Location 2(6 of 6) (Market Square)
; .byt "I travel near and%"
; .byt "far to trade only%"
; .byt "the finest items%"
; .byt "at best prices.]"
EmbeddedText174	;Location 2(3 of 6) (Market Square)
 .byt "CALLUM]"	;
; .byt "Duncel Callum is%"
; .byt "one of only a few%"
; .byt "dealers remaining%"
; .byt "selling weaponry.]"
EmbeddedText175
 .byt "JILES]"
;176-207	Keyword(32)
;>>>>>>****************
EmbeddedText176
 .byt "Birist]"
EmbeddedText177
 .byt "Briar Pipe]"
EmbeddedText178
 .byt "Old Tom]"
EmbeddedText179
 .byt "Dwarven Mines]"
EmbeddedText180
 .byt "]"
EmbeddedText181
 .byt "Pit Dragon]"
EmbeddedText182
 .byt "Samson Isle]"
EmbeddedText183
 .byt "Stollon Monks]"
EmbeddedText184
 .byt "Talisman]"
EmbeddedText185
 .byt "Merideth]"
EmbeddedText186
 .byt "Keesha]"
EmbeddedText187
 .byt "Hayden]"
EmbeddedText188
 .byt "Underwurlde]"
EmbeddedText189
 .byt "Great Horn]"
EmbeddedText190
 .byt "Old Clay Pipe]"
EmbeddedText191
 .byt "Straw Beyond]"
EmbeddedText192
 .byt "Perga]"
EmbeddedText193
 .byt "Quagmire]"
EmbeddedText194
 .byt "Supplies]"
EmbeddedText195
 .byt "Spare]"
EmbeddedText196
 .byt "Spare]"
EmbeddedText197
 .byt "Spare]"
EmbeddedText198
 .byt "Spare]"
EmbeddedText199
 .byt "Spare]"
EmbeddedText200
 .byt "Spare]"
EmbeddedText201
 .byt "Spare]"
EmbeddedText202
 .byt "Spare]"
EmbeddedText203
 .byt "Spare]"
EmbeddedText204
 .byt "Spare]"
EmbeddedText205
 .byt "Spare]"
EmbeddedText206
 .byt "Spare]"
EmbeddedText207
 .byt "Spare]"
;208-223	Placename(16)
;>>>>>>*************
EmbeddedText208	;Location 0
 .byt "Kissing Widow]"
EmbeddedText209     ;Location 1
 .byt "Pirates Arms]"
EmbeddedText210     ;Location 2
 .byt "Market Square]"
EmbeddedText211     ;Location 3
 .byt "Log Cabin]"
EmbeddedText212     ;Location 4
 .byt "?]"
EmbeddedText213     ;Location 5
 .byt "Monastery]"
EmbeddedText214     ;Location 6
 .byt "Littlepee]"
EmbeddedText215     ;Location 7
 .byt "The Bakery]"
EmbeddedText216     ;Location 8
 .byt "Mill House]"
EmbeddedText217     ;Location 9
 .byt "Windmill]"
EmbeddedText218     ;Location 10
 .byt "Wizards House]"
EmbeddedText219     ;Location 11
 .byt "Banit Castle]"
EmbeddedText220     ;Location 12
 .byt "Tirn Church]"
EmbeddedText221     ;Location 13
 .byt "?]"
EmbeddedText222     ;Location 14
 .byt "Fishy Plaice]"
EmbeddedText223     ;Location 15 - Reserved for absence
 .byt "]"
;224-255 Common words (32)
;>>>>>>Unlimited
EmbeddedText224
 .byt " ]"	;No hero item text
EmbeddedText225
 .byt "wibble]"
EmbeddedText226
 .byt "wibble]"
EmbeddedText227
 .byt "wibble]"
EmbeddedText228
 .byt "wibble]"
EmbeddedText229
 .byt "wibble]"
EmbeddedText230
 .byt "wibble]"
EmbeddedText231
 .byt "wibble]"
EmbeddedText232
 .byt "wibble]"
EmbeddedText233
 .byt "wibble]"
EmbeddedText234
 .byt "wibble]"
EmbeddedText235
 .byt "wibble]"
EmbeddedText236
 .byt "wibble]"
EmbeddedText237
 .byt "wibble]"
EmbeddedText238
 .byt "wibble]"
EmbeddedText239
 .byt "wibble]"
EmbeddedText240
 .byt "wibble]"
EmbeddedText241
 .byt "wibble]"
EmbeddedText242
 .byt "wibble]"

; *********************************** Drink Health or Mana Benefit
;"Lucien quaffs the ********* in one.]"
EmbeddedText243	;147
 .byt "Lucien quaffs the "
EmbeddedText243_ItemCode
 .byt "* in one.]"

EmbeddedText244	;148
 .byt "It does nothing useful]"

; *********************************** Food Health Benefit
;"Lucien devours the ********* and as%"
;"a consequence feels a little better]"
EmbeddedText245	;149
 .byt "Lucien devours the "
EmbeddedText245_ItemCode
 .byt "* and as%"
 .byt "a consequence feels a little better]"
EmbeddedText246	;150
 .byt "Select item to examine or Press%"
 .byt "ESC to quit.]"
EmbeddedText247	;151
EmbeddedText247_CharacterName
 .byt 144
 .byt " is willing to buy the%"
EmbeddedText247_ItemName
 .byt 0
 .byt " for "
EmbeddedText247_BuyPrice
 .byt "00"
 .byt " Grotes.%"
 .byt "Press Action key to sell, Navigate%"
 .byt "to another item or press ESC to%"
 .byt "quit.]"

EmbeddedText248	;152

 .byt "No item selected. Navigate to%"
 .byt "another item or press ESC to quit.]"
EmbeddedText249	;153
EmbeddedText249_CharacterName
 .byt 144
 .byt " is selling the "
EmbeddedText249_ItemName
 .byt 0
 .byt "%"
 .byt "for "
EmbeddedText249_SellPrice
 .byt "00"
 .byt " Grotes.%"
;>>>>>>***********************************
 .byt "Press Action key to buy, Navigate%"
 .byt "to another item or press ESC to%"
 .byt "quit.]"


EmbeddedText250	;154
 .byt "You are drunk!]"
 .byt "You pass out blind drunk. When you%"
 .byt "awake you find yourself in the%"
 .byt "towns stocks with all your%"
 .byt "posessions and money gone. After a%"
 .byt "time you are released.]"
EmbeddedText251	;155
 .byt "The ale tastes slightly sweet and%"
 .byt "strong.]"
EmbeddedText252
 .byt "? Refuses to drink alone.%"
 .byt "Are you willing to buy a round for%"
 .byt "both you and your guest?]"
EmbeddedText253	;? is replaced with embedded code for character in selector.s
 .byt "? is Drunk]"
EmbeddedText254	;? is replaced with embedded code for character in selector.s
 .byt "You buy ? an ale]"
;>>>>>>***********************************
EmbeddedText255
 .byt "-"	;Lucien does not have enough Grotes]"

OptionPromptLo
 .byt <OptionPrompt00
 .byt <OptionPrompt01
 .byt <OptionPrompt02
 .byt <OptionPrompt03
 .byt <OptionPrompt04
 .byt <OptionPrompt05
 .byt <OptionPrompt06
 .byt <OptionPrompt07
 .byt <OptionPrompt08
 .byt <OptionPrompt09
 .byt <OptionPrompt10
 .byt <OptionPrompt11
 .byt <OptionPrompt12
 .byt <OptionPrompt13
OptionPromptHi
 .byt >OptionPrompt00
 .byt >OptionPrompt01
 .byt >OptionPrompt02
 .byt >OptionPrompt03
 .byt >OptionPrompt04
 .byt >OptionPrompt05
 .byt >OptionPrompt06
 .byt >OptionPrompt07
 .byt >OptionPrompt08
 .byt >OptionPrompt09
 .byt >OptionPrompt10
 .byt >OptionPrompt11
 .byt >OptionPrompt12
 .byt >OptionPrompt13

;>>>>>>***********************************
OptionPrompt00      ;
 .byt "Select option or character..]"
OptionPrompt01      ;
 .byt "Select keyword..]"
OptionPrompt02      ;
 .byt "Select first item..]"
OptionPrompt03	;
 .byt "Select second item..]"
OptionPrompt04	;
 .byt "Select third item..]"
OptionPrompt05	;
 .byt "Select item]"
OptionPrompt06	;
 .byt "Select item you wish to buy..]"
OptionPrompt07	;
 .byt "Select item you wish to sell..]"
OptionPrompt08
 .byt "Lucien does not have enough Grotes!]"
OptionPrompt09
 .byt "On passing the money, Lucien is led%"
 .byt "up the stairs and into a small room%"
 .byt "where their is a comfortable bed, a%"
 .byt "hot meal laid out on a table and a%"
 .byt "large steaming bath. After enjoying%"
 .byt "the bath and food he lays down on%"
 .byt "the bed and promptly falls asleep.]"
OptionPrompt10
 .byt "Lucien is short of Pockets!]"
OptionPrompt11
 .byt "By virtue of being hidden the item%"
 .byt "cannot be bought.]"
OptionPrompt12
 .byt "By Virtue of being hidden the item%"
 .byt "cannot be sold.]"
OptionPrompt13
 .byt "  does not have enough Grotes!]"
;Text Window General Messages
twGeneralMessagesLo
 .byt <twGeneralMessage00
 .byt <twGeneralMessage01
twGeneralMessagesHi
 .byt >twGeneralMessage00
 .byt >twGeneralMessage01

;>>>>>>***********************************
twGeneralMessage00
 .byt "And so your life has ended.]"
twGeneralMessage01
 .byt "?Heard any rumours?]"

;Form Description General Messages
fdGeneralMessagesLo
 .byt <fdGeneralMessage00
 .byt <fdGeneralMessage01
 .byt <fdGeneralMessage02
 .byt <fdGeneralMessage03
 .byt <fdGeneralMessage04
 .byt <fdGeneralMessage05
fdGeneralMessagesHi
 .byt >fdGeneralMessage00
 .byt >fdGeneralMessage01
 .byt >fdGeneralMessage02
 .byt >fdGeneralMessage03
 .byt >fdGeneralMessage04
 .byt >fdGeneralMessage05

;>>>>>>******************
fdGeneralMessage00
 .byt "May they rest in%"
 .byt "peace, for their%"
 .byt "life has now%"
 .byt "ended.]"
fdGeneralMessage01
 .byt "My name is Lucien%"
 .byt "But little else i%"
 .byt "know. I may be a%"
 .byt "Hero someday.]"
fdGeneralMessage02
 .byt "YOU!]"
fdGeneralMessage03
 .byt "LUCIEN]"
fdGeneralMessage04
 .byt "No Item in this%"
 .byt "Pocket.]"
fdGeneralMessage05
 .byt "This item is%"
 .byt "currently hidden.]"

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
;>>>>>>*****************
OptionListText00	;
 .byt "Combine Items]"
OptionListText01	;
 .byt "Ask about..]"
OptionListText02	;Similar to rumours but does not expect rumours as response.
 .byt "Chitchat]"
OptionListText03	;
 .byt "Examine Items]"
OptionListText04	;
 .byt "Seek Lodging]"
OptionListText05	;
 .byt "Buy Item]"
OptionListText06	;
 .byt "Sell Item]"
OptionListText07	;
 .byt "Compliment]"
OptionListText08	;
 .byt "Insult]"
OptionListText09    ;
 .byt "Lend Item]"
OptionListText10    ;
 .byt "Recall Item]"
OptionListText11    ;
 .byt "Buy Ale]"
OptionListText12	;
 .byt "Haggle Price]"
OptionListText13	;
 .byt "Yes]"
OptionListText14	;
 .byt "No]"
OptionListText15	;
 .byt "Cancel]"




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

;>>>>>>***********************************
ComplimentText00
 .byt "You are looking very well today.]"
ComplimentText01
 .byt "You really are attractive.]"
ComplimentText02
 .byt "I really want to kiss you]"
ComplimentText03
 .byt "Get your coat, you've just pulled.]"


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

;>>>>>>***********************************
InsultText00
 .byt "I don't think i like you anymore.]"
InsultText01
 .byt "You remind me of an old drunk i%"
 .byt "once knew.]"
InsultText02
 .byt "Why didn't you run away with the%"
 .byt "sewerage?]"
InsultText03
 .byt "Don't talk, it smells bad when you%"
 .byt "talk]"

RumourDenialTextLo
 .byt <RumourText0
 .byt <RumourText1
 .byt <RumourText2
 .byt <RumourText3
RumourDenialTextHi
 .byt >RumourText0
 .byt >RumourText1
 .byt >RumourText2
 .byt >RumourText3

;>>>>>>***********************************
RumourText0
 .byt "Sorry i know no rumours.]"
RumourText1
 .byt "Yes.. ummm.. no.. sorry.]"
RumourText2
 .byt "I have heard something, but need to%"
 .byt "wait until i have all the facts.]"
RumourText3
 .byt "I am a bit busy at the moment.]"
ExtraText0
 .byt "Sorry i know nothing about that.]"
CharacterAddressLo
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
 .byt <Charset6x6+6*28	;060 > ???
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

CharacterAddressHi
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

