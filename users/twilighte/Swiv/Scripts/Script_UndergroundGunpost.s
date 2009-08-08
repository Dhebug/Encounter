;UndergroundGunpost_Script

Script_ConcealedGunpost	;Concealed Gunpost
;Set frames for directions
 .byt oss_frame+6	;Set frame gunpost
 .byt oss_4e	;This frame is East
 .byt oss_frame+7	;Set frame gunpost
 .byt oss_4se	;This frame is South-East
 .byt oss_frame+8	;Set frame gunpost
 .byt oss_4s	;This frame is South
 .byt oss_frame+9	;Set frame gunpost
 .byt oss_4sw	;This frame is South-West
 .byt oss_frame+10	;Set frame gunpost
 .byt oss_4w	;This frame is West
 .byt oss_frame+11	;Set frame gunpost
 .byt oss_4nw	;This frame is North-West
 .byt oss_frame+12	;Set frame gunpost
 .byt oss_4n	;This frame is North
 .byt oss_frame+13	;Set frame gunpost
 .byt oss_4ne	;This frame is North-East

;delay hatch opening at start until fully visible on screen
 .byt oss_frame+2	;Set Frame 2 - Gunpost hatch shut
 .byt oss_counter+6	;count for 12 rows
 .byt oss_condcounter
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_back+1	;move down and display frame2 for the next 12 rows

;Open hatch
 .byt oss_frame+3	;Set Frame 2 - Gunpost hatch opening
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_frame+4	;Set Frame 2 - Gunpost hatch opening
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_frame+5	;Set Frame 2 - Gunpost hatch opening
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_display	;display for 1
 .byt oss_s

;Set big loop count
 .byt oss_counter+4

;Rotate until in direction of hero
 .byt oss_condnothero	;Loop whilst not facing hero
 .byt oss_turnhero	;Turn turret towards hero
 .byt oss_display	;display for 1
 .byt oss_s	;Move south
 .byt oss_back+2
;Fire Missile
 .byt oss_fire	;Fire Missile
;Wait a while
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_display	;display for 1
;Loop for count 
 .byt oss_s
 .byt oss_condcounter	;Restore counter timeout condition
 .byt oss_back+12	;big loop back(and countdown) whilst counter hasn't timed out

;rotate until east again
 .byt oss_condnoteast
 .byt oss_turnhero
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_back+2

;Close hatch
 .byt oss_frame+5	;Set Frame 2 - Gunpost hatch shut
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_frame+4	;Set Frame 2 - Gunpost hatch shut
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_frame+3	;Set Frame 2 - Gunpost hatch shut
 .byt oss_display	;display for 1
 .byt oss_s
 .byt oss_frame+2	;Set Frame 2 - Gunpost hatch shut
 .byt oss_display	;display for 1

;cont until offscreen
 .byt oss_condnone
 .byt oss_s	;1
 .byt oss_display	;0
 .byt oss_back+1	;^

