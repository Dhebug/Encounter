;SFX_Scripts.s

Script_HighBeep
 .byt SETCHANNEL_A_T
 
 .byt SETPITCH
 .byt 20
Script_Beep
 .byt SETVOLUME+15
 
 .byt PLAY+10
 
 .byt END_A_OFF

Script_LowBeep
 .byt SETCHANNEL_A_T
 
 .byt SETPITCH
 .byt 255
 
 .byt SFXJUMP
 .byt <Script_Beep,>Script_Beep

Script_MidBeep
 .byt SETCHANNEL_A_T
 
 .byt SETPITCH
 .byt 140
 
 .byt SFXJUMP
 .byt <Script_Beep,>Script_Beep

Script_Chord
 .byt SETCHANNEL_A_T

 .byt SETPITCH
 .byt 140

 .byt SETVOLUME+15

 .byt SETCHANNEL_B_T

 .byt SETPITCH
 .byt 100

 .byt SETVOLUME+15
 
 .byt SETCHANNEL_C_T

 .byt SETPITCH
 .byt 255

 .byt SETVOLUME+15
.(
lblLoop1
 .byt PLAY+5
 
 .byt SETCHANNEL_A
 .byt ADJUSTVOLUME-1
 
 .byt SETCHANNEL_B
 .byt ADJUSTVOLUME-1
 
 .byt SETCHANNEL_C
 .byt ADJUSTVOLUME-1
 
 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_Chord
.)
 .byt END_ABC_OFF


Script_SCScale
 .byt SETCHANNEL_B_T

 .byt SETVOLUME+15
 
 .byt SETCHANNEL_C_T

 .byt SETVOLUME+15
 
.(
lblLoop1
 .byt PLAY

 .byt SETCHANNEL_B
 .byt ADJUSTVOLUME-1

 .byt SETCHANNEL_C
 .byt ADJUSTVOLUME-1

 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_SCScale
.)
 .byt END_BC_OFF


Script_CorridorFootSteps
 .byt SETCHANNEL_A_NE
 .byt SETNOISE+1
 .byt SETENV
 .byt 0,7
 .byt TRIGGER_DESCEND
 .byt END_NORMAL

 
Script_FootStepLeft
 .byt SETNOISE
ScriptFootStep
 .byt SETCHANNEL_A_N
 
 .byt SETVOLUME+15
 
.(
lblLoop1
 .byt PLAY
 
 .byt ADJUSTVOLUME-1
 
 .byt LOOPONVOLUMERANGE
 .byt lblLoop1-Script_FootStepLeft
.)
 .byt END_A_OFF

Script_Electricution
 .byt SETCHANNEL_A_TE
 
 .byt SETENV
 .byt <31,>31
 
 .byt TRIGGER_SAWTOOTH
 
 .byt SETCOUNTER+7

 .byt SETPITCH
 .byt 30
 .byt SETCHANNEL_B_TE
 .byt SETPITCH
 .byt 15

.( 
lblLoop1
 .byt SETCHANNEL_A_T
 
 .byt PLAY+1

 .byt SETCHANNEL_A_TE
 
 .byt PLAY+1

 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_Electricution
.)
 .byt END_AB_OFF

Script_DeathByHeight	;Wobble pitch and Bend down whilst fading
 .byt SETCHANNEL_B_T
 .byt SETPITCH
 .byt 100
 .byt SETVOLUME+15

;Cycle on Volume
;Use Counter for wobble
.(
lblLoop3
 .byt SETCOUNTER+2
lblLoop1
 .byt ADJUSTPITCH+2
 .byt PLAY
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_DeathByHeight

 .byt SETCOUNTER+2
lblLoop2
 .byt ADJUSTPITCH-2
 .byt PLAY
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop2-Script_DeathByHeight

 .byt ADJUSTPITCH+5
 .byt ADJUSTVOLUME-2
 .byt LOOPONVOLUMERANGE
 .byt lblLoop3-Script_DeathByHeight
.)
 .byt END_B_OFF

 



Script_RobotPlasma
 .byt SETCHANNEL_C_TE
 
 .byt SETENV
 .byt <31,>31
 
 .byt TRIGGER_SAWTOOTH
 
 .byt SETCOUNTER+7

 .byt SETPITCH
 .byt 30

.( 
lblLoop1
 .byt SETCHANNEL_C_T
 
 .byt PLAY+1

 .byt SETCHANNEL_C_TE
 
 .byt PLAY+1

 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_RobotPlasma
.)
 .byt END_C_OFF

Script_LiftStart
 .byt SETCHANNEL_B_T
 
 .byt SETPITCH
 .byt 255
 
 .byt SETVOLUME+15
 
 .byt SETCHANNEL_C_T
 
 .byt SETPITCH
 .byt 253
 
 .byt SETVOLUME+15
 
 .byt SETCOUNTER+12
.(
lblLoop1
 .byt SETCHANNEL_B
 .byt ADJUSTPITCH-4
 
 .byt SETCHANNEL_C
 .byt ADJUSTPITCH-4

 .byt PLAY
 
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_LiftStart
.)
 .byt END_NORMAL
 
Script_LiftEnd
 .byt SETCOUNTER+12
.(
lblLoop1
 .byt SETCHANNEL_B
 .byt ADJUSTPITCH+4
 
 .byt SETCHANNEL_C
 .byt ADJUSTPITCH+4
 
 .byt PLAY
 
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_LiftEnd
.)

 .byt END_BC_OFF

Script_RobotTurn
 .byt SETCHANNEL_B_T

 .byt SETVOLUME+7
 
 .byt SETCOUNTER+2
.(
lblLoop1
 .byt SETPITCH
 .byt 100
 
 .byt PLAY+1
 
 .byt SETPITCH
 .byt 104
 
 .byt PLAY+1

 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_RobotTurn
.)
 .byt END_B_OFF

Script_RobotMotors
 .byt SETCHANNEL_A_T

 .byt SETVOLUME+4
 
 .byt SETPITCH
 .byt 100
.(
lblLoop1
 
 .byt PLAY
 
; .byt ADJUSTPITCH+15
 .byt ADJUSTPITCH+15
 .byt ADJUSTPITCH+15
 .byt ADJUSTPITCH+15
 .byt ADJUSTPITCH+15

 .byt ADJUSTPITCH+15
 
 .byt SFXJUMP
 .byt <lblLoop1,>lblLoop1
.)

Script_PlasmaKill
 .byt END_NORMAL

Script_RoomFootstep	;Play footstep over room-motors
 .byt SETCHANNEL_A_TN
 .byt SETNOISE+31

 .byt SETVOLUME+7
 
 .byt SETPITCH
 .byt 100
 
 .byt PLAY
 
 .byt SETCHANNEL_A_T
 .byt SETVOLUME+4

.(
lblLoop1
 
 .byt PLAY
 
; .byt ADJUSTPITCH+15
 .byt ADJUSTPITCH+15
 .byt ADJUSTPITCH+15
 .byt ADJUSTPITCH+15
 .byt ADJUSTPITCH+15

 .byt ADJUSTPITCH+15
 
 .byt SFXJUMP
 .byt <lblLoop1,>lblLoop1
.)

Script_RoomLiftStart	;C+E
 .byt SETCHANNEL_C_TE
 
 .byt SETENV
 .byt 60,0
 
 .byt SETPITCH
 .byt 30
 
 .byt SETVOLUME
 .byt 16
 
 .byt TRIGGER_SAWTOOTH
 
 .byt SETCOUNTER+7
 
 .byt PLAY
 
 .byt SETENV
 .byt 56,0
 .byt SETPITCH
 .byt 28
 
 .byt PLAY
 
 .byt SETENV
 .byt 52,0
 .byt SETPITCH
 .byt 26

 .byt PLAY
 
 .byt SETENV
 .byt 48,0
 .byt SETPITCH
 .byt 24

 .byt PLAY
 
 .byt SETENV
 .byt 44,0
 .byt SETPITCH
 .byt 22
 
 .byt PLAY
 
 .byt SETENV
 .byt 40,0
 .byt SETPITCH
 .byt 20
 
 .byt PLAY
 
 .byt SETENV
 .byt 36,0
 .byt SETPITCH
 .byt 18

 .byt PLAY
 
 .byt SETENV
 .byt 32,0
 .byt SETPITCH
 .byt 16

 .byt PLAY
 
 .byt SETENV
 .byt 28,0
 .byt SETPITCH
 .byt 14

 .byt PLAY
 
 .byt SETENV
 .byt 24,0
 .byt SETPITCH
 .byt 12

 .byt PLAY
 
 .byt SETENV
 .byt 20,0
 .byt SETPITCH
 .byt 10
 
 .byt END_C_OFF

Script_RoomLiftEnd

Script_DialTone
 .byt SETCHANNEL_A_T	;Play Dialling Tone (US)

 .byt SETPITCH
 .byt 178

 .byt SETVOLUME+7

 .byt SETCHANNEL_B_T

 .byt SETPITCH
 .byt 142

 .byt SETVOLUME+7
 
 .byt END_NORMAL

; .byt PLAY+40
; .byt PLAY+20
;
; .byt END_AB_OFF

Script_DialDigit
 .byt SETCHANNEL_A_T
 .byt SETVOLUME+9

 .byt SETCHANNEL_B_T
 .byt SETVOLUME+9

 .byt PLAY+3
;Since 0 is repeated in dialled number, lets spend one play with everything off
 .byt SETVOLUME
 .byt SETCHANNEL_A_T
 .byt SETVOLUME
 .byt PLAY
 .byt END_AB_OFF

;ModemTalk is split into the following sections
;High pitch whistle (as modem synchronises)
;Random buzz (start of comms)
;Silence (Comms)
;Click (Hang up)
Script_ModemTalk
 .byt SETCHANNEL_A_T
 .byt SETPITCH
 .byt 15	;852
 .byt SETVOLUME+6
 
 .byt PLAY+40
 
 .byt SETCHANNEL_B_T
 .byt SETPITCH
 .byt 23	;852
 .byt SETVOLUME+6
 
 .byt PLAY+40

 .byt SETCHANNEL_B_T
 .byt SETVOLUME+6
 .byt SETCOUNTER+50
.(
lblLoop1
 .byt SETPITCH
 .byt RANDOM_HIGH
 .byt PLAY
 .byt LOOPONCOUNTERRANGE
 .byt lblLoop1-Script_ModemTalk
.)
 .byt SETVOLUME		;Zero volume
 .byt SETCHANNEL_A_T
 .byt SETVOLUME
 
 .byt PLAY+40		;Silence during comms
 .byt PLAY+40
 
 .byt SETVOLUME+6		;Click
 .byt SETCHANNEL_B_T
 .byt SETVOLUME+6
 .byt PLAY+1
 .byt SETVOLUME
 .byt SETCHANNEL_A_T
 .byt SETVOLUME
 
 .byt END_AB_OFF
 