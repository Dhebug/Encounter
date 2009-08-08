;Level 1 Data

;Contains
; * Map
; * Map Blocks
; * Ground based object Masks and Bitmaps with possible shift frames
; * Aircraft
; * Guardians
; * Wave Data
; * Ground based movement data

;How do we cope with the ground based static concealed gunpost where the animations start by revealing the
;gunpost then remaining frames are directional home?
;How do we cope with static ground objects that do not posess a mask?

;Indexed by SpriteID
FrameSequenceListLo
 .byt <
FrameSequenceListHi



FrameStart
 .byt 0	;Lancaster Bomber(6bit res)

;B0-5 Count
;B6 Frames are either cyclical or based on the direction they move in(wave process)
;For cyclical(0) 	the animation runs from FrameStart to FrameStart+FrameCount indefinately
;For directional(1)	FrameCount must be 8 for E,SE,S,SW,W,NW,N,NE. However actual graphic address
;		pointer may be the same for selective directions.
;B7 End of Frame list
FrameCount
 .byt 1	;2 Frames
 .byt 128
;Holds the sequence of frames in the sprites animation
;0-127 	Frame ID
;128-191  jump to index in this sequence(0-63)
;192	
;255   	End of Frames (keep as last frame)
LancasterBomber
FrameSequence
 .byt 1,255

SpriteShiftedBitmapLoTableVectorLo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
SpriteShiftedBitmapHiTableVectorLo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
SpriteShiftedBitmapLoTableVectorHi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
SpriteShiftedBitmapHiTableVectorHi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
SpriteShiftedMaskLoTableVectorLo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <gfxSprite_BitmapShiftFrameAddress0Lo
SpriteShiftedMaskHiTableVectorLo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
 .byt >gfxSprite_BitmapShiftFrameAddress0Lo
SpriteShiftedMaskLoTableVectorHi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
 .byt <gfxSprite_BitmapShiftFrameAddress0Hi
SpriteShiftedMaskHiTableVectorHi
 .byt >gfxSprite_BitmapShiftFrameAddress0Hi
 .byt >gfxSprite_BitmapShiftFrameAddress0Hi
 .byt >gfxSprite_BitmapShiftFrameAddress0Hi
 .byt >gfxSprite_BitmapShiftFrameAddress0Hi
 .byt >gfxSprite_BitmapShiftFrameAddress0Hi
 .byt >gfxSprite_BitmapShiftFrameAddress0Hi
 

gfxSprite_BitmapShiftFrameAddress0Lo
 .byt <LancasterBomber_BitmapFrame00
 .byt <LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress1Lo
 .byt <LancasterBomber_BitmapFrame00
 .byt <LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress2Lo
 .byt <LancasterBomber_BitmapFrame00
 .byt <LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress3Lo
 .byt <LancasterBomber_BitmapFrame00
 .byt <LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress4Lo
 .byt <LancasterBomber_BitmapFrame00
 .byt <LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress5Lo
 .byt <LancasterBomber_BitmapFrame00
 .byt <LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress0Hi
 .byt >LancasterBomber_BitmapFrame00
 .byt >LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress1Hi
 .byt >LancasterBomber_BitmapFrame00
 .byt >LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress2Hi
 .byt >LancasterBomber_BitmapFrame00
 .byt >LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress3Hi
 .byt >LancasterBomber_BitmapFrame00
 .byt >LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress4Hi
 .byt >LancasterBomber_BitmapFrame00
 .byt >LancasterBomber_BitmapFrame01
gfxSprite_BitmapShiftFrameAddress5Hi
 .byt >LancasterBomber_BitmapFrame00
 .byt >LancasterBomber_BitmapFrame01
gfxSprite_MaskShiftFrameAddress0Lo
 .byt <LancasterBomber_MaskFrame00
 .byt <LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress1Lo
 .byt <LancasterBomber_MaskFrame00
 .byt <LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress2Lo
 .byt <LancasterBomber_MaskFrame00
 .byt <LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress3Lo
 .byt <LancasterBomber_MaskFrame00
 .byt <LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress4Lo
 .byt <LancasterBomber_MaskFrame00
 .byt <LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress5Lo
 .byt <LancasterBomber_MaskFrame00
 .byt >LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress0Hi
 .byt >LancasterBomber_MaskFrame00
 .byt >LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress1Hi
 .byt >LancasterBomber_MaskFrame00
 .byt >LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress2Hi
 .byt >LancasterBomber_MaskFrame00
 .byt >LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress3Hi
 .byt >LancasterBomber_MaskFrame00
 .byt >LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress4Hi
 .byt >LancasterBomber_MaskFrame00
 .byt >LancasterBomber_MaskFrame01
gfxSprite_MaskShiftFrameAddress5Hi
 .byt >LancasterBomber_MaskFrame00
 .byt >LancasterBomber_MaskFrame01
gfxSprite_Width
 .byt 5
gfxSprite_Height
 .byt 10
gfxSprite_UltimateByte
 .byt 49
;B0-3 Group
; 0 Ground based Static(0)
; 1 Ground based moving(1) - Requires capture of BG beneath
;
; 4 Aircraft(2)	     - Requires shadow
; 5 Missiles & bombs(3)    - Requires shadow(must have suitable res
;
; 8 Orb(4)
; 12 guardian(5)
;B4-5 Bitmap Resolution
;B6-7 Mask Resolution
; If bitmap is byte based, high res mask means when craft is hit, it will plummet to ground
; with shadow verging towards craft diagnonally to give the appearance of it falling from sky
gfxSprite_GroupAndProperties
 .byt 2+BITMAP6+MASK2

LancasterBomber_BitmapFrame00
 .byt $40,$40,$40,$40,$40
 .byt $40,$40,$C0,$40,$40
 .byt $40,$40,$4C,$40,$40
 .byt $40,$40,$4C,$40,$40
 .byt $40,$40,$4C,$40,$40
 .byt $40,$C6,$F3,$D8,$40
 .byt $40,$EA,$E1,$D5,$40
 .byt $40,$FB,$E1,$F7,$40
 .byt $40,$4E,$4C,$5C,$40
 .byt $40,$40,$40,$40,$40
LancasterBomber_BitmapFrame01
 .byt $40,$40,$40,$40,$40
 .byt $40,$40,$C0,$40,$40
 .byt $40,$40,$4C,$40,$40
 .byt $40,$40,$4C,$40,$40
 .byt $40,$40,$4C,$40,$40
 .byt $40,$C6,$F3,$D8,$40
 .byt $40,$EA,$E1,$D5,$40
 .byt $40,$FB,$E1,$F7,$40
 .byt $40,$44,$4C,$48,$40
 .byt $40,$40,$40,$40,$40
LancasterBomber_MaskFrame00
 .byt $7F,$7E,$40,$5F,$7F
 .byt $7F,$7E,$40,$5F,$7F
 .byt $7F,$7E,$40,$5F,$7F
 .byt $7F,$7F,$61,$7F,$7F
 .byt $7E,$40,$40,$40,$5F
 .byt $7E,$40,$40,$40,$5F
 .byt $7E,$40,$40,$40,$5F
 .byt $7E,$40,$40,$40,$5F
 .byt $7E,$40,$40,$40,$5F
 .byt $7F,$71,$61,$63,$7F
LancasterBomber_MaskFrame01
 .byt $7F,$7E,$40,$5F,$7F
 .byt $7F,$7E,$40,$5F,$7F
 .byt $7F,$7E,$40,$5F,$7F
 .byt $7F,$7F,$61,$7F,$7F
 .byt $7E,$40,$40,$40,$5F
 .byt $7E,$40,$40,$40,$5F
 .byt $7E,$40,$40,$40,$5F
 .byt $7E,$40,$40,$40,$5F
 .byt $7E,$40,$40,$40,$5F
 .byt $7F,$7B,$61,$77,$7F
