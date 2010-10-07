;SFX_Scripts.s for Stormlord
;Channel A - Hero Sounds (Projectiles)
;Channel B - Pickups (Fairy,Key,Umbrella,Honeypot)
;Channel C - Creature sounds
;Envelope and Noise shared

;	SFX_LEVELCOMPLETE             1
;	SFX_KILLED                    2
;	SFX_GAMEOVER                  3
;
;	SFX_PASSFAIRY                 4
;
;	SFX_LAUNCHER                  5
;	SFX_FAIRYTEAR                 6
;	SFX_GRUB			7
;	SFX_SPIDER		8
;
;
;	SFX_COLLECTKEY     		9
;	SFX_COLLECTFAIRY              10
;	SFX_COLLECTUMBRELLA           11
;	SFX_COLLECTSHOES              12
;	SFX_COLLECTTEAR               13
;
;	SFX_OPENDOOR                  14
;	SFX_USETRAMPOLENE             15
;
;	SFX_FIREHEART               	16
;	SFX_FIREORB                 	17
;	SFX_FIRESWORD                 18

Script_Killed		;c#cf#
 .byt SETCHANNEL_A_T
 
 .byt SETNOTE
 .byt 25
 .byt SETVOLUME+15
 
 .byt PLAY+11
 
 .byt SETCHANNEL_B_T
 
 .byt SETNOTE
 .byt 24
 .byt SETVOLUME+15
 
 .byt PLAY+11

 .byt SETCHANNEL_C_T
 .byt 18
 .byt SETVOLUME+15
 
 .byt PLAY+21
 
 .byt END_ABC_OFF
 
Script_FireOrb	;shhh sound slow rise/slow fall
 .byt SETCHANNEL_A_N
 .byt SETVOLUME+0
 .byt SETCOUNTER+7
.(
lblLoop1
 .byt ADJUSTVOLUME+1
 .byt PLAY+2
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_FireOrb
.)
 .byt END_A_OFF
 
Script_FireSword	;high pitch and noise fade
 .byt SETCHANNEL_A_TN
 .byt SETVOLUME+15
 .byt SETNOTE
 .byt 120
.(
lblLoop1
 .byt ADJUSTVOLUME-1
 .byt PLAY+2
 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_FireSword
.)
 .byt END_A_OFF

Script_FireHeart	;High pitch fade with vibrato
 .byt SETCHANNEL_A_T
 .byt SETVOLUME+15
.(
lblLoop1
 .byt SETNOTE
 .byt 108
 .byt PLAY+2
 .byt SETNOTE
 .byt 110
 .byt PLAY+2
 .byt SETNOTE
 .byt 112
 .byt PLAY+2
 .byt ADJUSTVOLUME-1
 .byt PLAY+2
 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_FireHeart
.)
 .byt END_A_OFF

Script_CollectUmbrella
 .byt SETCHANNEL_B_TN
 .byt SETPITCH
 .byt 40
 .byt SFXJUMP
 .byt <SwapItemRent,>SwapItemRent

Script_CollectHoney
 .byt SETCHANNEL_B_TN
 .byt SETPITCH
 .byt 60
 .byt SFXJUMP
 .byt <SwapItemRent,>SwapItemRent
 
Script_CollectBoots
 .byt SETCHANNEL_B_TN
 .byt SETPITCH
 .byt 80
 .byt SFXJUMP
 .byt <SwapItemRent,>SwapItemRent

Script_CollectKey
 .byt SETCHANNEL_B_TN
 .byt SETPITCH
 .byt 20

SwapItemRent
 .byt SETVOLUME+12
 .byt SETNOISE
 .byt PLAY+1
 .byt SETCHANNEL_B_T
.(
lblLoop0
 .byt ADJUSTVOLUME-2
 .byt PLAY+1
 .byt LOOPONVOLUMERANGE
 .byt lblLoop0-Script_CollectKey
.)
 .byt END_B_OFF
 
Script_Launcher
 .byt SETCHANNEL_C_T
 .byt SETVOLUME+12
 .byt SETPITCH
 .byt 255
 .byt PLAY+6
 .byt SETPITCH
 .byt 245
.(
lblLoop1
 .byt ADJUSTPITCH-2
 .byt ADJUSTVOLUME-1
 .byt PLAY+1
 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_Launcher
.)
 .byt END_C_OFF
 
Script_FreeFairy
 .byt SETCHANNEL_B_T
 .byt SETVOLUME+8
.(
lblLoop1
 .byt SETPITCH
 .byt 28
 .byt PLAY+1
 .byt SETPITCH
 .byt 25
 .byt PLAY+1
 .byt ADJUSTVOLUME-1
 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_FreeFairy
.)
 .byt END_B_OFF
 
Script_RainDrop
 .byt SETCHANNEL_B_TE
 .byt SETPITCH
 .byt 0
 .byt TRIGGER_DESCEND
 .byt SETENV
 .byt 5,0
 .byt PLAY+11
 .byt END_B_OFF
 
 
Script_Spider	;Quietly Repeating rythmic Tone toggle
 .byt SETCHANNEL_C_N
 .byt SETCOUNTER	;0 so RND 1-8
.(
lblLoop1
 .byt SETVOLUME+4
 .byt PLAY+1
 .byt SETVOLUME
 .byt PLAY+1
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_Spider
.)
 .byt END_C_OFF

Script_Trampolene	;Boing using 2 close channels(AB) with bend
 .byt SETCHANNEL_A_T
 .byt SETVOLUME+15
 .byt SETPITCH
 .byt 255
 .byt SETCHANNEL_B_T
 .byt SETVOLUME+15
 .byt SETPITCH
 .byt 240
.(
lblLoop1
 .byt SETCHANNEL_A_T
 .byt ADJUSTPITCH-4
 .byt ADJUSTVOLUME-1
 .byt SETCHANNEL_B_T
 .byt ADJUSTPITCH-2
 .byt ADJUSTVOLUME-1
 .byt PLAY+1
 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_Trampolene
.)
 .byt SETVOLUME
 .byt SETCHANNEL_A_T
 .byt SETVOLUME
 .byt END_AB_OFF

Script_Door	;Door Creek
 .byt SETCHANNEL_B_T
 .byt SETVOLUME+12
 .byt SETPITCH
 .byt 255
 .byt PLAY+3
 .byt SETCOUNTER+10
.(
lblLoop1
 .byt ADJUSTPITCH-10
; .byt ADJUSTVOLUME-1
 .byt PLAY+1
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_Door
.)
 .byt END_B_OFF

Script_Footstep
 .byt SETCHANNEL_A_N
 .byt SETNOISE
 .byt SETVOLUME+5
 .byt PLAY+1
 .byt END_A_OFF

Script_Bees

Script_Explosion
 .byt SETCHANNEL_C_N
 .byt SETNOISE+31
 .byt SETVOLUME+15
.(
lblLoop1
 .byt ADJUSTVOLUME-1
; .byt ADJUSTNOISE-1
 .byt PLAY+1
 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_Explosion
.)
 .byt END_C_OFF
 
Script_GameOver
 .byt SETCHANNEL_A_TE
 .byt SETVOLUME+15
 
 .byt SETENV
 .byt 0,0
 .byt TRIGGER_SAWTOOTH
 
 .byt SETNOTE
 .byt 8+12*5

 .byt SETCHANNEL_B_TE
 .byt SETVOLUME+15
 
 .byt SETNOTE
 .byt 3+12*5

 .byt SETCHANNEL_C_TE
 .byt SETVOLUME+15
 
 .byt SETNOTE
 .byt 11+12*4

 .byt SETCOUNTER+50
.(
lblLoop1
 .byt SETCHANNEL_A_TE
 .byt ADJUSTPITCH+1
 .byt SETCHANNEL_B_TE
 .byt ADJUSTPITCH+1
 .byt SETCHANNEL_C_TE
 .byt ADJUSTPITCH+1
 .byt PLAY+2
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_GameOver
.)
 .byt PLAY+20
 .byt END_ABC_OFF

Script_LevelComplete
;Set up initial volume
 .byt SETCHANNEL_A_T
 .byt SETVOLUME+15
.(
lblLoop1
 .byt SETNOTE
 .byt 2+12*5
 
 .byt PLAY+5
 
 .byt SETNOTE
 .byt 9+12*4

 .byt PLAY+5

 .byt SETNOTE
 .byt 4+12*5

 .byt PLAY+5

 .byt SETNOTE
 .byt 4+12*4

 .byt PLAY+5

 .byt ADJUSTVOLUME-2

 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_LevelComplete
.)
 .byt END_A_OFF

Script_Starfield
 .byt SETCHANNEL_A_T
 .byt SETVOLUME+6
 .byt SETNOTE
 .byt 0
 .byt SETCHANNEL_B_T
 .byt SETVOLUME+6
 .byt SETNOTE
 .byt 0
 .byt SETCHANNEL_C_T
 .byt SETVOLUME+6
 .byt SETNOTE
 .byt 0
.(
lblLoop0
 .byt SETCOUNTER+4
lblLoop1
 .byt SETCHANNEL_A_T
 .byt ADJUSTPITCH-1
 .byt SETCHANNEL_B_T
 .byt ADJUSTPITCH+1
 .byt SETCHANNEL_C_T
 .byt ADJUSTPITCH-1
 .byt PLAY+1
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_Starfield
 .byt SETCOUNTER+4
lblLoop2
 .byt SETCHANNEL_A_T
 .byt ADJUSTPITCH+1
 .byt SETCHANNEL_B_T
 .byt ADJUSTPITCH-1
 .byt SETCHANNEL_C_T
 .byt ADJUSTPITCH+1
 .byt PLAY+1
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop2-Script_Starfield

 .byt SETCHANNEL_A_T
 .byt ADJUSTVOLUME-1
 .byt SETCHANNEL_B_T
 .byt ADJUSTVOLUME-1
 .byt SETCHANNEL_C_T
 .byt ADJUSTVOLUME-1
 .byt LOOPONVOLUMERANGE
 .byt lblLoop0-Script_Starfield
.)
 .byt SFXJUMP
 .byt <Script_Starfield,>Script_Starfield

