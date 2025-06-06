LABEL(_FirstSprite)
	; All 26 barrels
	; First floor (5)
LABEL(FirstBarrel)
	SPRITE_DATA(9,200+3,2,10,Barrel_Right)
	SPRITE_DATA(14,198+4,2,10,Barrel_BottomRight)
	SPRITE_DATA(19,196+5,2,10,Barrel_Bottom)
	SPRITE_DATA(24,192+7,2,10,Barrel_BottomLeft)
	SPRITE_DATA(30,190+7,2,10,Barrel_Left)
	; Second floor (6)
	SPRITE_DATA(30,155+7,2,10,Barrel_BottomLeft)
LABEL(SecondFloorBarrel)
	SPRITE_DATA(24,155+5,2,10,Barrel_Bottom)
	SPRITE_DATA(19,155+4,2,10,Barrel_BottomRight)
	SPRITE_DATA(14,155+2,2,10,Barrel_Right)
	SPRITE_DATA(9,155+1,2,10,Barrel_TopRight)
	SPRITE_DATA(4,150,2,10,Barrel_Top)
	; Third floor (6)
	SPRITE_DATA(4 ,109,2,10,Barrel_Right)
LABEL(BarrelInsertionLeft)    
	SPRITE_DATA(9 ,102-2,2,10,Barrel_Right)
	SPRITE_DATA(13,102-3,2,10,Barrel_Right)
LABEL(BarrelInsertionMiddle)    
	SPRITE_DATA(16,102-4,2,10,Barrel_Right)
	SPRITE_DATA(19,102-4,2,10,Barrel_Right)
LABEL(BarrelInsertionRight)    
	SPRITE_DATA(22,102-5,2,10,Barrel_Right)
LABEL(LastBarrel)
	; Left fall (3)
	SPRITE_DATA(128+9 ,87,2,10,Barrel_FallDiagonal_4)
LABEL(BarrelCollideFallLeft)
	SPRITE_DATA(128+9 ,59,2,11,Barrel_FallDiagonal_3)
LABEL(BarrelStartLeft)
	SPRITE_DATA(9 ,42,2,9,Barrel_FallStraight)
	; Middle fall (3)
	SPRITE_DATA(128+16 ,87,2,9,Barrel_FallDiagonal_6)
LABEL(BarrelCollideFallMiddle)
	SPRITE_DATA(128+16 ,57,2,10,Barrel_FallDiagonal_2)
LABEL(BarrelStartMiddle)
	SPRITE_DATA(16 ,42,2,9,Barrel_FallStraight)
	; Right fall (3)
	SPRITE_DATA(128+22 ,87,2,9,Barrel_FallDiagonal_5)
LABEL(BarrelCollideFallRight)
	SPRITE_DATA(128+22 ,59,2,11,Barrel_FallDiagonal_1)
LABEL(BarrelStartRight)
	SPRITE_DATA(22 ,42,2,9,Barrel_FallStraight)

LABEL(FirstGirder)
	; Moving girders (5)
	SPRITE_DATA(5 ,115,4,11,Girder_1)
	SPRITE_DATA(10 ,115+2,4,11,Girder_2)
	SPRITE_DATA(15,115+3,4,11,Girder_1)
	SPRITE_DATA(21,115+5,4,11,Girder_2)
	SPRITE_DATA(26,115+6,4,11,Girder_1)

LABEL(FirstKong)
	; Kong 1 (4)
	SPRITE_DATA(8 ,1,4,17,Kong_Barrel_Left)
	SPRITE_DATA(8 ,13,5,24,Kong_Body_Left)
	SPRITE_DATA(7 ,22,2,13,Kong_LeftHand_Left)
	SPRITE_DATA(11,19,3,10,Kong_RightHand_Left)
	; Kong 2 (4)
	SPRITE_DATA(7+8 ,2,3,13,Kong_Barrel)
	SPRITE_DATA(7+8 ,12,3,25,Kong_Body)
	SPRITE_DATA(7+7 ,19,2,11,Kong_LeftHand)
	SPRITE_DATA(7+10 ,19,2,11,Kong_RightHand)
	; Kong 3 (4)
	SPRITE_DATA(13+8 ,0,5,18,Kong_Barrel_Right)
	SPRITE_DATA(13+7 ,11,5,26,Kong_Body_Right)
	SPRITE_DATA(13+6 ,16,3,8,Kong_LeftHand_Right)
	SPRITE_DATA(13+11 ,20,2,10,Kong_RightHand_Right)
	; Kong falling (1)
LABEL(FirstKongFalling)
	SPRITE_DATA(24,84,4,28+3,Kong_Falling)
LABEL(LastKong)

	; Long platforms (3)
LABEL(FirstPlatform)
	SPRITE_DATA(7,38,6,5,Plaform)
	SPRITE_DATA(13,38,6,5,Plaform)
	SPRITE_DATA(19,38,6,5,Plaform)
LABEL(FirstPlatformFalling)
	; Long platforms falling down(3)
	SPRITE_DATA(128+5,44,4,30,Plaform_Falling1)
	SPRITE_DATA(128+12,44,3,34,Plaform_Falling2)
	SPRITE_DATA(128+16,44,6,12,Plaform_Falling3)

LABEL(FirstHook)
	; Hooks that attach platforms (4)
	SPRITE_DATA(25,14,2,29,Hook_Left)
	SPRITE_DATA(26,17,1,26,Hook_CenterLeft)
	SPRITE_DATA(27,17,1,26,Hook_CenterRight)
	SPRITE_DATA(28,15,1,28,Hook_Right)
LABEL(LastHook)

LABEL(FirstMario)
	; All 22 mario sprites
LABEL(FirstFloorMario)
	; First floor (5)
	SPRITE_DATA(6,181+8+5+1,3,19,Mario_Right_1)    ; * . . .
	SPRITE_DATA(11,181+6+5,3,20,Mario_Right_2)     ; . * . .
	SPRITE_DATA(16,181+4+4+3,3,20,Mario_Right_3)   ; . . * .
	SPRITE_DATA(21,181+2+3+5,3,20,Mario_Right_4)   ; . . . *
LABEL(MarioLader_1)
	SPRITE_DATA(128+26,178+1+7+3,4,19,Mario_FirstClimb)

LABEL(SecondFloorMario)
	; Second floor (5)
    SPRITE_DATA(26,144+6,3,20,Mario_UpFirstLadder)           ; . . . . *
    SPRITE_DATA(21,144+5,3,20,Mario_CenterRightSecondFloor)  ; . . . * .
    SPRITE_DATA(16,144+4,3,20,Mario_CenterSecondFloor)       ; . . * . .
	SPRITE_DATA(11,144+2,3,20,Mario_Left_1)                  ; . * . . .
    SPRITE_DATA(128+5,144+1,4,20,Mario_DownSecondLadder)         ; * . . . .
LABEL(MarioLader_2)
	; Lader (2)
	SPRITE_DATA(128+5,127,4,21,Mario_Climb2)
LABEL(MarioLaderCollide)
	SPRITE_DATA(128+6,90,3,22,Mario_Climb)

LABEL(ThirdFloorMario)
	; Third floor (3)
	SPRITE_DATA(128+7,65,4,19,Mario_Manette)
	SPRITE_DATA(128+15,66,4,18,Mario_LoopUp)
	SPRITE_DATA(128+20,65,4,19,Mario_WaitForJump)

LABEL(MarioJump)
	; Mario jumping and falling (3)
	SPRITE_DATA(25+1,45,3,24,Mario_JumpForHook)
	SPRITE_DATA(26,68,3,20,Mario_Fall)
	SPRITE_DATA(29,91,3,21,Mario_Crash)
	; Mario gripped to hook
	SPRITE_DATA(28,56,3,20,Mario_GrippedToHook)

LABEL(FirstMarioJump)
	; Mario jumping First Floor (2)
	SPRITE_DATA(7,169+5+3,3,17,Mario_Jump_Right)
	SPRITE_DATA(21,169+5,3,17,Mario_Jump_Right)
	; Mario jumping Second Floor (2)
	SPRITE_DATA(21,126+5,3,18,Mario_Jump_Left)
	SPRITE_DATA(16,126+3,3,18,Mario_Jump_Left)
LABEL(LastMario)

LABEL(FirstCrane)	; Crane stick (3 positions)
	SPRITE_DATA(33,62,5,19,Crane_StickDown)
	SPRITE_DATA(30+1,36,7,20,Crane_StickCenter)
	SPRITE_DATA(30,0,8,34,Crane_StickUp)

LABEL(FirstCraneHook)	; Hooks (5 positions)
	SPRITE_DATA(32+1,46,2,10,Crane_Hook_1)
	SPRITE_DATA(31+1,44,2,17,Crane_Hook_2)
	SPRITE_DATA(30+1,43,1,19,Crane_Hook_3)
	SPRITE_DATA(28+1,41,3,18,Crane_Hook_4)
	SPRITE_DATA(27+1,38,3,14,Crane_Hook_5)

LABEL(FirstVictoryPose)	; Victory poses (2x2 positions)
    SPRITE_DATA(34-1,82,4,36,Mario_VictoryGround)
LABEL(LastCrane)

LABEL(FirstMarioHand)	; Mario hands (2)
	SPRITE_DATA(7,78,2,8,Mario_HandDown)
	SPRITE_DATA(6,75,2,5,Mario_HandUp)

LABEL(FirstCraneStick)	; Crane control stick (2)
	SPRITE_DATA(6,79,2,4,Crane_ControlDown)
	SPRITE_DATA(5,70,2,9,Crane_ControlUp)

LABEL(FirstHeart)       ; Hearts of victory (2)
	SPRITE_DATA(6,8,1,7,SmallHeart)
	SPRITE_DATA(6,2,2,8,BigHeart)

LABEL(BestScore)      ; The indicators that indicates the best score 
	SPRITE_DATA(30,214,6,9,_SpriteBestScore)

LABEL(GameMenu)      ; The Slow/Fast/Quit menu options
#ifdef LANGUAGE_FR
	SPRITE_DATA(32,149,5,17,_GameMenu)
#else
	SPRITE_DATA(33,149,4,17,_GameMenu)
#endif    

LABEL(GameMenuOption)   ; The marker in front of the selected menu option 
	SPRITE_DATA(36,149,1,5,_MenuOptionSelector)
	SPRITE_DATA(36,155,1,5,_MenuOptionSelector)
	SPRITE_DATA(36,161,1,5,_MenuOptionSelector)

LABEL(CraneLabel)   ; The label to indicate the player it's a control for the crane
	SPRITE_DATA(1,62,4,5,_SpriteCraneSign)

LABEL(PlayerLives)      ; The indicators for remaining lives
	SPRITE_DATA(34,197,2,16,_SpriteMario_Life)
	SPRITE_DATA(36,197,2,16,_SpriteMario_Life)
	SPRITE_DATA(38,197,2,16,_SpriteMario_Life)

LABEL(_LastSprite)

