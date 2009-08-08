;Script_Bonus
;Not sure if i can put a script to this since the frame is dependant on the hit
BonusScript
;This is always the first thing shown
; .byt SET_FRAME
; .byt BONUSHEART_FRAME
;On hitting the bonus with a projectile it will go to the Hit script (flips it and shows new bonus) 
 .byt SET_HITINDEX
 .byt HitScript-BonusScript
;Keep bonus moving down screen
HitRent
 .byt SCROLL_SOUTH
 .byt 1
;Branch back
 .byt BRANCH
 .byt HitRent-BonusScript
 
HitScript
 .byt SET_FRAME
 .byt BONUSFLIP00_FRAME
 
 .byt MOVE_NORTH
 .byt 6
 
 .byt DISPLAY_SPRITE
 
 .byt SET_FRAME
 .byt BONUSFLIP01_FRAME
 
 .byt MOVE_NORTH
 .byt 6
 
 .byt DISPLAY_SPRITE

 .byt SET_FRAME
 .byt BONUSFLIP02_FRAME
 
 .byt MOVE_NORTH
 .byt 6
 
 .byt DISPLAY_SPRITE

 .byt SET_FRAME
 .byt BONUSFLIP01_FRAME
 
 .byt DISPLAY_SPRITE

 .byt SET_FRAME
 .byt BONUSFLIP02_FRAME
 
 .byt DISPLAY_SPRITE

 .byt CALL_SPECIAL
 .byt <csNextBonus,>csNextBonus
 
 .byt BRANCH
 .byt HitRent-BonusScript
 
 