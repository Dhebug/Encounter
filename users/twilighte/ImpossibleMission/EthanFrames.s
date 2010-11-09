EthanFrameXStep
 .byt 0	 	 ;00 Stand (Initially Right)
           	 
 .byt 1    	 ;01 Run (Initially Right)
 .byt 0    	 ;02 - adjust this 0 or 1
 .byt 1    	 ;03
 .byt 1    	 ;04
 .byt 0    	 ;05
 .byt 1    	 ;06
 .byt 1    	 ;07
 .byt 1	 	 ;08
 .byt 1	 	 ;09
 .byt 1	 	 ;10
 .byt 1	 	 ;11
 .byt 0	 	 ;12
 .byt 1	 	 ;13
 .byt 1	 	 ;14
           	 
 .byt 0	 	 ;15 Examine
           	 
 .byt 0	 	 ;16 Jump (Initially Right)
 .byt 0	 	 ;17
 .byt 1	 	 ;18
 .byt 1	 	 ;19
 .byt 1	 	 ;20
 .byt 1	 	 ;21
 .byt 1	 	 ;22
 .byt 1	 	 ;23
 .byt 1	 	 ;24
 .byt 1	 	 ;25
 .byt 1	 	 ;26
 .byt 1	 	 ;27
           	 
EthanFrameYOffset	;2's Compliment
 .byt 21	 	 ;00 Stand
           	 
 .byt 22    	 ;01 Run
 .byt 23    	 ;02
 .byt 23    	 ;03
 .byt 23    	 ;04
 .byt 22    	 ;05
 .byt 22    	 ;06
 .byt 22    	 ;07
 .byt 22	 	 ;08
 .byt 23	 	 ;09
 .byt 23	 	 ;10
 .byt 23	 	 ;11
 .byt 22	 	 ;12
 .byt 22	 	 ;13
 .byt 22	 	 ;14
           	 
 .byt 25	;23	 	 ;30 Examine
	
 .byt 24	;255	 	 ;31 Jump
 .byt 28	;254	 	 ;32
 .byt 30	;253	 	 ;33
 .byt 31	;0	 	 ;34
 .byt 30	;253	 	 ;35
 .byt 30	;255	 	 ;36
 .byt 30	;0	 	 ;37
 .byt 28	;3	 	 ;38
 .byt 27	;1	 	 ;39
 .byt 27	;0	 	 ;40
 .byt 27	;0	 	 ;41
 .byt 23	;4	 	 ;42
           	 


EthanMSKPixelHeight
 .byt 21		 ;00 Stand

 .byt 22		 ;01 Run
 .byt 22	 	 ;02
 .byt 22	 	 ;03
 .byt 23	 	 ;04
 .byt 22		 ;05
 .byt 22		 ;06
 .byt 22		 ;07
 .byt 22		 ;08
 .byt 22	 	 ;09
 .byt 22	 	 ;10
 .byt 23	 	 ;11
 .byt 22		 ;12
 .byt 22		 ;13
 .byt 22		 ;14

 .byt 25	 	 ;30 Searching
           	 
 .byt 18	 	 ;31 Jump
 .byt 16	 	 ;32
 .byt 12	 	 ;33
 .byt 12	 	 ;34
 .byt 11	 	 ;35
 .byt 12	 	 ;36
 .byt 12	 	 ;37
 .byt 10	 	 ;38
 .byt 10	 	 ;39
 .byt 15	 	 ;40
 .byt 23	 	 ;41
 .byt 23	 	 ;42

EthanBMPPixelHeight
 .byt 13		 ;00 Stand

 .byt 13		 ;01 Run
 .byt 12	 	 ;02
 .byt 12	 	 ;03
 .byt 11	 	 ;04
 .byt 11		 ;05
 .byt 11		 ;06
 .byt 11		 ;07
 .byt 13		 ;08
 .byt 12	 	 ;09
 .byt 12	 	 ;10
 .byt 12	 	 ;11
 .byt 12		 ;12
 .byt 10		 ;13
 .byt 12		 ;14

 .byt 15	 	 ;15 Searching
           	 
 .byt 8	 	 ;16 Jump
 .byt 9	 	 ;17
 .byt 9	 	 ;18
 .byt 11	 	 ;19
 .byt 10	 	 ;20
 .byt 11	 	 ;21
 .byt 10	 	 ;22
 .byt 7	 	 ;23
 .byt 6	 	 ;24
 .byt 6	 	 ;25
 .byt 7	 	 ;26
 .byt 10	 	 ;27

EthanFootDown
 .byt 128+1 	 ;00 Stand

 .byt 128	  	 ;01 Run
 .byt 0	 	 ;02
 .byt 0	 	 ;03
 .byt 0	 	 ;04
 .byt 128+1 	 ;05
 .byt 128	 	 ;06
 .byt 128	 	 ;07
 .byt 128	 	 ;08
 .byt 0	 	 ;09
 .byt 0	 	 ;10
 .byt 0	 	 ;11
 .byt 128+1 	 ;12
 .byt 128	 	 ;13
 .byt 128	 	 ;14

 .byt 128	 	 ;15 Searching
         	 
 .byt 0	 	 ;16 Jump
 .byt 0	 	 ;17
 .byt 0	 	 ;18
 .byt 0	 	 ;19
 .byt 0	 	 ;20
 .byt 0	 	 ;21
 .byt 0	 	 ;22
 .byt 0	 	 ;23
 .byt 0	 	 ;24
 .byt 0	 	 ;25
 .byt 0	 	 ;26
 .byt 0	 	 ;27
           	 
EthanBitmapFrameAddressLo
 .byt <BMPEthanStandRight	;00
 .byt <BMPEthanRunRight00     ;01
 .byt <BMPEthanRunRight01     ;02
 .byt <BMPEthanRunRight02     ;03
 .byt <BMPEthanRunRight03     ;04
 .byt <BMPEthanRunRight04     ;05
 .byt <BMPEthanRunRight05     ;06
 .byt <BMPEthanRunRight06     ;07
 .byt <BMPEthanRunRight07     ;08
 .byt <BMPEthanRunRight08     ;09
 .byt <BMPEthanRunRight09     ;10
 .byt <BMPEthanRunRight10     ;11
 .byt <BMPEthanRunRight11     ;12
 .byt <BMPEthanRunRight12     ;13
 .byt <BMPEthanRunRight13     ;14
 .byt <BMPEthanSearching	;15
 .byt <BMPEthanJumpRight00	;16
 .byt <BMPEthanJumpRight01	;17
 .byt <BMPEthanJumpRight02	;18
 .byt <BMPEthanJumpRight03	;19
 .byt <BMPEthanJumpRight04	;20
 .byt <BMPEthanJumpRight05	;21
 .byt <BMPEthanJumpRight06	;22
 .byt <BMPEthanJumpRight07	;23
 .byt <BMPEthanJumpRight08	;24
 .byt <BMPEthanJumpRight09	;25
 .byt <BMPEthanJumpRight10	;26
 .byt <BMPEthanJumpRight11	;27
EthanBitmapFrameAddressHi
 .byt >BMPEthanStandRight	;00
 .byt >BMPEthanRunRight00     ;01
 .byt >BMPEthanRunRight01     ;02
 .byt >BMPEthanRunRight02     ;03
 .byt >BMPEthanRunRight03     ;04
 .byt >BMPEthanRunRight04     ;05
 .byt >BMPEthanRunRight05     ;06
 .byt >BMPEthanRunRight06     ;07
 .byt >BMPEthanRunRight07     ;08
 .byt >BMPEthanRunRight08     ;09
 .byt >BMPEthanRunRight09     ;10
 .byt >BMPEthanRunRight10     ;11
 .byt >BMPEthanRunRight11     ;12
 .byt >BMPEthanRunRight12     ;13
 .byt >BMPEthanRunRight13     ;14
 .byt >BMPEthanSearching	;15
 .byt >BMPEthanJumpRight00	;16
 .byt >BMPEthanJumpRight01	;17
 .byt >BMPEthanJumpRight02	;18
 .byt >BMPEthanJumpRight03	;19
 .byt >BMPEthanJumpRight04	;20
 .byt >BMPEthanJumpRight05	;21
 .byt >BMPEthanJumpRight06	;22
 .byt >BMPEthanJumpRight07	;23
 .byt >BMPEthanJumpRight08	;24
 .byt >BMPEthanJumpRight09	;25
 .byt >BMPEthanJumpRight10	;26
 .byt >BMPEthanJumpRight11	;27
EthanMaskFrameAddressLo
 .byt <MSKEthanStandRight	;00
 .byt <MSKEthanRunRight00     ;01
 .byt <MSKEthanRunRight01     ;02
 .byt <MSKEthanRunRight02     ;03
 .byt <MSKEthanRunRight03     ;04
 .byt <MSKEthanRunRight04     ;05
 .byt <MSKEthanRunRight05     ;06
 .byt <MSKEthanRunRight06     ;07
 .byt <MSKEthanRunRight07     ;08
 .byt <MSKEthanRunRight08     ;09
 .byt <MSKEthanRunRight09     ;10
 .byt <MSKEthanRunRight10     ;11
 .byt <MSKEthanRunRight11     ;12
 .byt <MSKEthanRunRight12     ;13
 .byt <MSKEthanRunRight13     ;14
 .byt <MSKEthanSearching	;15
 .byt <MSKEthanJumpRight00	;16
 .byt <MSKEthanJumpRight01	;17
 .byt <MSKEthanJumpRight02	;18
 .byt <MSKEthanJumpRight03	;19
 .byt <MSKEthanJumpRight04	;20
 .byt <MSKEthanJumpRight05	;21
 .byt <MSKEthanJumpRight06	;22
 .byt <MSKEthanJumpRight07	;23
 .byt <MSKEthanJumpRight08	;24
 .byt <MSKEthanJumpRight09	;25
 .byt <MSKEthanJumpRight10	;26
 .byt <MSKEthanJumpRight11	;27
EthanMaskFrameAddressHi
 .byt >MSKEthanStandRight	;00
 .byt >MSKEthanRunRight00     ;01
 .byt >MSKEthanRunRight01     ;02
 .byt >MSKEthanRunRight02     ;03
 .byt >MSKEthanRunRight03     ;04
 .byt >MSKEthanRunRight04     ;05
 .byt >MSKEthanRunRight05     ;06
 .byt >MSKEthanRunRight06     ;07
 .byt >MSKEthanRunRight07     ;08
 .byt >MSKEthanRunRight08     ;09
 .byt >MSKEthanRunRight09     ;10
 .byt >MSKEthanRunRight10     ;11
 .byt >MSKEthanRunRight11     ;12
 .byt >MSKEthanRunRight12     ;13
 .byt >MSKEthanRunRight13     ;14
 .byt >MSKEthanSearching	;15
 .byt >MSKEthanJumpRight00	;16
 .byt >MSKEthanJumpRight01	;17
 .byt >MSKEthanJumpRight02	;18
 .byt >MSKEthanJumpRight03	;19
 .byt >MSKEthanJumpRight04	;20
 .byt >MSKEthanJumpRight05	;21
 .byt >MSKEthanJumpRight06	;22
 .byt >MSKEthanJumpRight07	;23
 .byt >MSKEthanJumpRight08	;24
 .byt >MSKEthanJumpRight09	;25
 .byt >MSKEthanJumpRight10	;26
 .byt >MSKEthanJumpRight11	;27

BMPEthanStandRight	;3x13 
 .byt $40,$40,$40
 .byt $40,$42,$40
 .byt $40,$4E,$40
 .byt $40,$46,$40
 .byt $40,$40,$40
 .byt $40,$58,$40
 .byt $40,$58,$40
 .byt $40,$50,$40
 .byt $40,$70,$40
 .byt $40,$70,$40
 .byt $40,$50,$40
 .byt $40,$48,$40
 .byt $40,$44,$40
BMPEthanRunRight00	;3x13 
 .byt $40,$40,$40
 .byt $40,$42,$40
 .byt $40,$4E,$40
 .byt $40,$46,$40
 .byt $40,$40,$40
 .byt $40,$58,$40
 .byt $40,$58,$40
 .byt $40,$70,$40
 .byt $40,$70,$40
 .byt $40,$60,$40
 .byt $40,$60,$40
 .byt $40,$50,$40
 .byt $40,$50,$40
BMPEthanRunRight01	;3x12 
 .byt $40,$40,$40
 .byt $40,$40,$50
 .byt $40,$41,$70
 .byt $40,$40,$70
 .byt $40,$42,$40
 .byt $40,$46,$40
 .byt $40,$4C,$40
 .byt $40,$48,$40
 .byt $40,$48,$40
 .byt $40,$48,$40
 .byt $40,$48,$40
 .byt $40,$48,$40
BMPEthanRunRight02	;3x12 
 .byt $40,$40,$40
 .byt $40,$40,$60
 .byt $40,$43,$60
 .byt $40,$41,$60
 .byt $40,$40,$40
 .byt $40,$4C,$40
 .byt $40,$58,$40
 .byt $40,$50,$40
 .byt $40,$50,$40
 .byt $40,$60,$50
 .byt $40,$60,$40
 .byt $40,$60,$40
BMPEthanRunRight03	;3x11 
 .byt $40,$40,$40
 .byt $40,$41,$40
 .byt $40,$47,$40
 .byt $40,$43,$40
 .byt $40,$40,$40
 .byt $40,$5C,$40
 .byt $40,$70,$40
 .byt $40,$60,$58
 .byt $41,$40,$60
 .byt $41,$40,$40
 .byt $41,$40,$40
BMPEthanRunRight04	;3x11 
 .byt $40,$40,$40
 .byt $40,$40,$48
 .byt $40,$40,$78
 .byt $40,$40,$58
 .byt $40,$40,$40
 .byt $40,$43,$61
 .byt $40,$46,$42
 .byt $40,$44,$44
 .byt $40,$44,$40
 .byt $40,$48,$40
 .byt $40,$48,$40
BMPEthanRunRight05	;3x11 
 .byt $40,$40,$40
 .byt $40,$40,$50
 .byt $40,$41,$70
 .byt $40,$40,$70
 .byt $40,$47,$40
 .byt $40,$4C,$40
 .byt $40,$48,$40
 .byt $40,$50,$40
 .byt $40,$50,$40
 .byt $40,$50,$40
 .byt $40,$40,$58
BMPEthanRunRight06	;3x11 
 .byt $40,$40,$40
 .byt $40,$40,$60
 .byt $40,$43,$60
 .byt $40,$41,$60
 .byt $40,$46,$40
 .byt $40,$4E,$40
 .byt $40,$58,$40
 .byt $40,$50,$40
 .byt $40,$60,$40
 .byt $40,$60,$40
 .byt $40,$60,$40
BMPEthanRunRight07	;3x13 
 .byt $40,$40,$40
 .byt $40,$42,$40
 .byt $40,$4E,$40
 .byt $40,$46,$40
 .byt $40,$40,$40
 .byt $40,$58,$40
 .byt $40,$58,$40
 .byt $40,$58,$40
 .byt $40,$50,$40
 .byt $40,$50,$40
 .byt $40,$50,$40
 .byt $40,$50,$40
 .byt $40,$50,$40
BMPEthanRunRight08	;3x12 
 .byt $40,$40,$40
 .byt $40,$40,$50
 .byt $40,$41,$70
 .byt $40,$40,$70
 .byt $40,$43,$40
 .byt $40,$43,$40
 .byt $40,$4A,$40
 .byt $40,$4A,$40
 .byt $40,$49,$40
 .byt $40,$49,$40
 .byt $40,$49,$40
 .byt $40,$40,$60
BMPEthanRunRight09	;3x12 
 .byt $40,$40,$40
 .byt $40,$40,$60
 .byt $40,$43,$60
 .byt $40,$41,$60
 .byt $40,$46,$40
 .byt $40,$46,$40
 .byt $40,$56,$40
 .byt $40,$52,$40
 .byt $40,$51,$40
 .byt $40,$60,$78
 .byt $40,$60,$40
 .byt $40,$60,$40
BMPEthanRunRight10	;3x12 
 .byt $40,$40,$40
 .byt $40,$41,$40
 .byt $40,$47,$40
 .byt $40,$43,$40
 .byt $40,$40,$40
 .byt $40,$46,$40
 .byt $40,$46,$40
 .byt $40,$63,$58
 .byt $41,$61,$60
 .byt $41,$40,$40
 .byt $42,$40,$40
 .byt $42,$40,$40
BMPEthanRunRight11	;3x12 
 .byt $40,$40,$40
 .byt $40,$40,$48
 .byt $40,$40,$78
 .byt $40,$40,$58
 .byt $40,$40,$40
 .byt $40,$40,$71
 .byt $40,$40,$7A
 .byt $40,$44,$4C
 .byt $40,$44,$40
 .byt $40,$44,$40
 .byt $40,$48,$40
 .byt $40,$48,$40
BMPEthanRunRight12	;3x10 
 .byt $40,$40,$40
 .byt $40,$40,$50
 .byt $40,$41,$70
 .byt $40,$40,$70
 .byt $40,$43,$40
 .byt $40,$43,$40
 .byt $40,$53,$40
 .byt $40,$51,$40
 .byt $40,$51,$60
 .byt $40,$50,$78
BMPEthanRunRight13	;3x12 
 .byt $40,$40,$40
 .byt $40,$40,$60
 .byt $40,$43,$60
 .byt $40,$41,$60
 .byt $40,$42,$40
 .byt $40,$46,$40
 .byt $40,$46,$40
 .byt $40,$46,$40
 .byt $40,$42,$40
 .byt $40,$42,$40
 .byt $40,$41,$40
 .byt $40,$41,$40


MSKEthanStandRight	;3x21 
 .byt $7F,$71,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$61,$7F
 .byt $7F,$43,$7F
 .byt $7F,$43,$7F
 .byt $7F,$47,$7F
 .byt $7E,$47,$7F
 .byt $7E,$47,$7F
 .byt $7F,$47,$7F
 .byt $7E,$43,$7F
 .byt $7E,$41,$7F
 .byt $7E,$40,$7F
 .byt $7F,$40,$7F
 .byt $7F,$40,$7F
 .byt $7E,$48,$7F
 .byt $7E,$59,$7F
 .byt $78,$73,$7F
 .byt $79,$67,$7F
 .byt $78,$63,$7F
MSKEthanRunRight00	;3x22 
 .byt $7F,$71,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$61,$7F
 .byt $7F,$41,$7F
 .byt $7F,$41,$7F
 .byt $7E,$43,$7F
 .byt $7E,$43,$7F
 .byt $7E,$43,$7F
 .byt $7E,$43,$7F
 .byt $7F,$41,$7F
 .byt $7F,$40,$7F
 .byt $7F,$44,$5F
 .byt $7F,$46,$4F
 .byt $7F,$44,$4F
 .byt $7E,$40,$7F
 .byt $7C,$43,$7F
 .byt $78,$57,$7F
 .byt $70,$7F,$7F
 .byt $73,$7F,$7F
 .byt $73,$7F,$7F
MSKEthanRunRight01	;3x22 
 .byt $7F,$7E,$4F
 .byt $7F,$7C,$47
 .byt $7F,$7C,$47
 .byt $7F,$7C,$47
 .byt $7F,$78,$4F
 .byt $7F,$70,$5F
 .byt $7F,$60,$5F
 .byt $7F,$60,$5F
 .byt $7F,$60,$5F
 .byt $7F,$60,$5F
 .byt $7F,$60,$4F
 .byt $7F,$60,$43
 .byt $7F,$70,$43
 .byt $7F,$71,$41
 .byt $7F,$63,$63
 .byt $7F,$47,$63
 .byt $7E,$4F,$67
 .byt $7C,$5F,$4F
 .byt $7C,$7F,$4F
 .byt $79,$7F,$6F
 .byt $7B,$7F,$6F
 .byt $7B,$7F,$7F
MSKEthanRunRight02	;3x22 
 .byt $7F,$7C,$4F
 .byt $7F,$78,$4F
 .byt $7F,$78,$4F
 .byt $7F,$78,$4F
 .byt $7F,$70,$5F
 .byt $7F,$60,$5F
 .byt $7F,$40,$5F
 .byt $7F,$40,$5F
 .byt $7F,$40,$4F
 .byt $7E,$40,$47
 .byt $7E,$40,$4F
 .byt $7E,$40,$4F
 .byt $7F,$50,$47
 .byt $7F,$70,$43
 .byt $7F,$71,$61
 .byt $7F,$71,$71
 .byt $7E,$43,$79
 .byt $78,$4F,$79
 .byt $71,$7F,$79
 .byt $77,$7F,$79
 .byt $7F,$7F,$79
 .byt $7F,$7F,$7C
MSKEthanRunRight03	;3x23 
 .byt $7F,$78,$7F
 .byt $7F,$70,$5F
 .byt $7F,$70,$5F
 .byt $7F,$70,$5F
 .byt $7F,$60,$7F
 .byt $7F,$40,$7F
 .byt $7E,$40,$67
 .byt $7E,$40,$43
 .byt $7C,$40,$47
 .byt $7C,$40,$5F
 .byt $7C,$41,$7F
 .byt $7E,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$5F
 .byt $7F,$44,$5F
 .byt $7F,$46,$4F
 .byt $60,$4F,$47
 .byt $4C,$5F,$67
 .byt $5F,$7F,$67
 .byt $7F,$7F,$63
 .byt $7F,$7F,$73
 .byt $7F,$7F,$7B
 .byt $7F,$7F,$78
MSKEthanRunRight04	;3x22 
 .byt $7F,$7F,$47
 .byt $7F,$7E,$43
 .byt $7F,$7E,$43
 .byt $7F,$7E,$43
 .byt $7F,$7C,$46
 .byt $7F,$78,$44
 .byt $7F,$70,$40
 .byt $7F,$70,$41
 .byt $7F,$70,$43
 .byt $7F,$62,$4F
 .byt $7F,$62,$4F
 .byt $7F,$76,$47
 .byt $7F,$7E,$47
 .byt $7E,$7E,$47
 .byt $7C,$4E,$43
 .byt $78,$40,$43
 .byt $7F,$78,$61
 .byt $7F,$7C,$71
 .byt $7F,$7F,$71
 .byt $7F,$7F,$79
 .byt $7F,$7F,$79
 .byt $7F,$7F,$78
MSKEthanRunRight05	;3x22 
 .byt $7F,$7E,$4F
 .byt $7F,$7C,$47
 .byt $7F,$7C,$47
 .byt $7F,$78,$47
 .byt $7F,$70,$4F
 .byt $7F,$60,$5F
 .byt $7F,$60,$5F
 .byt $7F,$40,$7F
 .byt $7F,$40,$5F
 .byt $7F,$40,$47
 .byt $7F,$60,$43
 .byt $7F,$70,$47
 .byt $7F,$70,$5F
 .byt $7C,$50,$5F
 .byt $78,$40,$4F
 .byt $7F,$60,$4F
 .byt $7F,$70,$5F
 .byt $7F,$7C,$5F
 .byt $7F,$7C,$5F
 .byt $7F,$7C,$7F
 .byt $7F,$7C,$7F
 .byt $7F,$7C,$4F
MSKEthanRunRight06	;3x22 
 .byt $7F,$7C,$5F
 .byt $7F,$78,$4F
 .byt $7F,$78,$4F
 .byt $7F,$70,$4F
 .byt $7F,$70,$5F
 .byt $7F,$60,$7F
 .byt $7F,$40,$7F
 .byt $7F,$41,$7F
 .byt $7E,$41,$7F
 .byt $7E,$41,$7F
 .byt $7E,$40,$5F
 .byt $7F,$40,$47
 .byt $7F,$70,$47
 .byt $7F,$40,$4F
 .byt $7E,$40,$5F
 .byt $7E,$58,$5F
 .byt $7F,$71,$7F
 .byt $7F,$63,$7F
 .byt $7F,$63,$7F
 .byt $7F,$4F,$7F
 .byt $7E,$4F,$7F
 .byt $7F,$47,$7F
MSKEthanRunRight07	;3x22 
 .byt $7F,$71,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$61,$7F
 .byt $7F,$43,$7F
 .byt $7F,$43,$7F
 .byt $7F,$43,$7F
 .byt $7F,$43,$7F
 .byt $7F,$43,$7F
 .byt $7F,$43,$7F
 .byt $7F,$41,$7F
 .byt $7F,$40,$7F
 .byt $7F,$44,$5F
 .byt $7F,$46,$4F
 .byt $7F,$44,$4F
 .byt $7E,$40,$7F
 .byt $7C,$43,$7F
 .byt $78,$57,$7F
 .byt $70,$7F,$7F
 .byt $73,$7F,$7F
 .byt $73,$7F,$7F
MSKEthanRunRight08	;3x22 
 .byt $7F,$7E,$4F
 .byt $7F,$7C,$47
 .byt $7F,$7C,$47
 .byt $7F,$7C,$47
 .byt $7F,$78,$4F
 .byt $7F,$70,$5F
 .byt $7F,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$5F
 .byt $7F,$60,$5F
 .byt $7F,$60,$4F
 .byt $7F,$70,$43
 .byt $7F,$70,$43
 .byt $7F,$71,$41
 .byt $7F,$63,$63
 .byt $7F,$47,$63
 .byt $7E,$4F,$67
 .byt $7C,$5F,$4F
 .byt $7C,$7F,$4F
 .byt $79,$7F,$6F
 .byt $7B,$7F,$6F
 .byt $7B,$7F,$7F
MSKEthanRunRight09	;3x22 
 .byt $7F,$7C,$4F
 .byt $7F,$78,$4F
 .byt $7F,$78,$4F
 .byt $7F,$78,$4F
 .byt $7F,$70,$5F
 .byt $7F,$60,$5F
 .byt $7F,$40,$5F
 .byt $7F,$40,$5F
 .byt $7F,$40,$47
 .byt $7E,$48,$43
 .byt $7E,$48,$47
 .byt $7E,$48,$4F
 .byt $7F,$50,$47
 .byt $7F,$70,$43
 .byt $7F,$71,$61
 .byt $7F,$71,$71
 .byt $7E,$43,$79
 .byt $78,$4F,$79
 .byt $71,$7F,$79
 .byt $77,$7F,$79
 .byt $7F,$7F,$79
 .byt $7F,$7F,$7C
MSKEthanRunRight10	;3x23 
 .byt $7F,$78,$7F
 .byt $7F,$70,$5F
 .byt $7F,$70,$5F
 .byt $7F,$70,$5F
 .byt $7F,$78,$7F
 .byt $7F,$60,$7F
 .byt $7F,$40,$43
 .byt $7E,$40,$43
 .byt $7C,$40,$43
 .byt $7C,$50,$5F
 .byt $78,$71,$7F
 .byt $78,$60,$7F
 .byt $7D,$60,$7F
 .byt $7F,$60,$5F
 .byt $7F,$44,$5F
 .byt $7F,$46,$4F
 .byt $60,$4F,$47
 .byt $4C,$5F,$67
 .byt $5F,$7F,$67
 .byt $7F,$7F,$63
 .byt $7F,$7F,$73
 .byt $7F,$7F,$7B
 .byt $7F,$7F,$78
MSKEthanRunRight11	;3x22 
 .byt $7F,$7F,$47
 .byt $7F,$7E,$43
 .byt $7F,$7E,$43
 .byt $7F,$7E,$43
 .byt $7F,$7F,$46
 .byt $7F,$7C,$44
 .byt $7F,$78,$40
 .byt $7F,$70,$41
 .byt $7F,$70,$43
 .byt $7F,$70,$4F
 .byt $7F,$62,$4F
 .byt $7F,$62,$4F
 .byt $7F,$76,$47
 .byt $7E,$7E,$47
 .byt $7C,$4E,$43
 .byt $78,$40,$43
 .byt $7F,$78,$61
 .byt $7F,$7C,$71
 .byt $7F,$7F,$71
 .byt $7F,$7F,$79
 .byt $7F,$7F,$79
 .byt $7F,$7F,$78
MSKEthanRunRight12	;3x22 
 .byt $7F,$7E,$4F
 .byt $7F,$7C,$47
 .byt $7F,$7C,$47
 .byt $7F,$78,$47
 .byt $7F,$70,$4F
 .byt $7F,$60,$5F
 .byt $7F,$40,$5F
 .byt $7F,$40,$5F
 .byt $7F,$40,$47
 .byt $7F,$40,$43
 .byt $7F,$60,$47
 .byt $7F,$70,$5F
 .byt $7F,$70,$5F
 .byt $7C,$50,$5F
 .byt $78,$40,$4F
 .byt $7F,$60,$4F
 .byt $7F,$70,$5F
 .byt $7F,$7C,$5F
 .byt $7F,$7C,$5F
 .byt $7F,$7C,$7F
 .byt $7F,$7C,$7F
 .byt $7F,$7C,$4F
MSKEthanRunRight13	;3x22 
 .byt $7F,$7C,$5F
 .byt $7F,$78,$4F
 .byt $7F,$78,$4F
 .byt $7F,$7C,$4F
 .byt $7F,$78,$5F
 .byt $7F,$70,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$7F
 .byt $7F,$60,$5F
 .byt $7F,$60,$4F
 .byt $7F,$70,$47
 .byt $7F,$70,$47
 .byt $7F,$40,$4F
 .byt $7E,$40,$5F
 .byt $7E,$58,$5F
 .byt $7F,$71,$7F
 .byt $7F,$63,$7F
 .byt $7F,$63,$7F
 .byt $7F,$4F,$7F
 .byt $7E,$4F,$7F
 .byt $7F,$47,$7F


BMPEthanJumpRight00	;3x8 
 .byt $40,$40,$40
 .byt $40,$42,$40
 .byt $40,$4F,$40
 .byt $40,$46,$40
 .byt $40,$46,$40
 .byt $40,$43,$40
 .byt $40,$41,$60
 .byt $40,$40,$50
BMPEthanJumpRight01	;3x9 
 .byt $40,$40,$40
 .byt $40,$46,$40
 .byt $40,$46,$60
 .byt $40,$44,$70
 .byt $40,$4C,$40
 .byt $40,$48,$40
 .byt $40,$48,$40
 .byt $40,$48,$40
 .byt $40,$48,$40
BMPEthanJumpRight02	;3x9 
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$70
 .byt $40,$41,$70
 .byt $40,$46,$40
 .byt $40,$48,$70
 .byt $40,$50,$60
BMPEthanJumpRight03	;3x11 
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$4C
 .byt $40,$40,$7C
 .byt $40,$41,$60
 .byt $40,$42,$44
 .byt $40,$44,$4E
 .byt $40,$40,$48
BMPEthanJumpRight04	;3x10 
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$78,$40
 .byt $40,$46,$40
 .byt $40,$43,$40
 .byt $40,$41,$40
 .byt $40,$42,$40
 .byt $40,$47,$40
 .byt $40,$44,$40
BMPEthanJumpRight05	;3x11 
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $41,$40,$40
 .byt $40,$60,$40
 .byt $40,$58,$40
 .byt $40,$4C,$40
 .byt $40,$6C,$40
 .byt $41,$70,$40
 .byt $40,$60,$40
BMPEthanJumpRight06	;3x10 
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$44,$40
 .byt $40,$44,$40
 .byt $40,$44,$40
 .byt $40,$42,$40
 .byt $40,$52,$40
 .byt $40,$76,$40
 .byt $40,$56,$40
BMPEthanJumpRight07	;3x7 
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$44,$40
 .byt $40,$48,$40
 .byt $48,$70,$40
 .byt $4D,$60,$40
 .byt $5B,$40,$40
BMPEthanJumpRight08	;3x6 
 .byt $40,$40,$40
 .byt $40,$42,$40
 .byt $48,$44,$40
 .byt $4C,$58,$40
 .byt $59,$70,$40
 .byt $43,$60,$40
BMPEthanJumpRight09	;3x6 
 .byt $40,$40,$40
 .byt $44,$48,$40
 .byt $5E,$50,$40
 .byt $4D,$60,$40
 .byt $4F,$40,$40
 .byt $46,$40,$40
BMPEthanJumpRight10	;3x7 
 .byt $40,$40,$40
 .byt $40,$41,$40
 .byt $40,$62,$40
 .byt $41,$6C,$40
 .byt $43,$78,$40
 .byt $41,$70,$40
 .byt $41,$60,$40
BMPEthanJumpRight11	;3x10 
 .byt $40,$40,$40
 .byt $40,$48,$40
 .byt $40,$78,$40
 .byt $40,$50,$40
 .byt $40,$40,$40
 .byt $40,$70,$40
 .byt $40,$70,$40
 .byt $40,$78,$40
 .byt $40,$58,$40
 .byt $40,$47,$60

MSKEthanJumpRight00 ;3x18 
 .byt $7F,$78,$7F
 .byt $7F,$60,$5F
 .byt $7E,$40,$5F
 .byt $78,$40,$5F
 .byt $78,$50,$7F
 .byt $70,$78,$4F
 .byt $71,$7C,$47
 .byt $71,$7E,$47
 .byt $71,$7F,$6F
 .byt $61,$7F,$7F
 .byt $41,$7F,$7F
 .byt $41,$7F,$7F
 .byt $59,$7F,$7F
 .byt $79,$7F,$7F
 .byt $79,$7F,$7F
 .byt $79,$7F,$7F
 .byt $7D,$7F,$7F
 .byt $7D,$7F,$7F
MSKEthanJumpRight01 ;3x16 
 .byt $7C,$41,$7F
 .byt $78,$40,$4F
 .byt $70,$70,$47
 .byt $70,$70,$47
 .byt $70,$61,$4F
 .byt $78,$61,$7F
 .byt $78,$63,$7F
 .byt $78,$63,$7F
 .byt $78,$63,$7F
 .byt $78,$77,$7F
 .byt $78,$7F,$7F
 .byt $7C,$7F,$7F
 .byt $7C,$7F,$7F
 .byt $78,$7F,$7F
 .byt $7C,$7F,$7F
 .byt $7E,$7F,$7F
MSKEthanJumpRight02 ;3x12 
 .byt $7F,$63,$7F
 .byt $7F,$40,$7F
 .byt $7F,$40,$5F
 .byt $7F,$40,$47
 .byt $7F,$44,$47
 .byt $7F,$40,$47
 .byt $7F,$40,$47
 .byt $7F,$40,$47
 .byt $7F,$42,$47
 .byt $7E,$47,$4F
 .byt $7C,$7F,$7F
 .byt $78,$7F,$7F
MSKEthanJumpRight03 ;3x12 
 .byt $7F,$7F,$7F
 .byt $7F,$7F,$7F
 .byt $7F,$7F,$7F
 .byt $7F,$7C,$4F
 .byt $7F,$78,$43
 .byt $7F,$78,$41
 .byt $7F,$78,$41
 .byt $67,$60,$40
 .byt $40,$60,$40
 .byt $58,$40,$60
 .byt $7F,$43,$60
 .byt $7F,$7F,$71
MSKEthanJumpRight04 ;3x11 
 .byt $73,$7C,$7F
 .byt $79,$78,$5F
 .byt $7D,$40,$5F
 .byt $7C,$40,$4F
 .byt $7C,$40,$4F
 .byt $7C,$40,$4F
 .byt $7E,$40,$4F
 .byt $7F,$40,$5F
 .byt $7F,$60,$5F
 .byt $7F,$70,$5F
 .byt $7F,$78,$7F
MSKEthanJumpRight05 ;3x12 
 .byt $7F,$6F,$7F
 .byt $7F,$6F,$7F
 .byt $7F,$4F,$7F
 .byt $7E,$58,$7F
 .byt $7C,$50,$5F
 .byt $78,$40,$5F
 .byt $78,$40,$4F
 .byt $7C,$40,$4F
 .byt $7E,$40,$5F
 .byt $7C,$40,$7F
 .byt $7E,$43,$7F
 .byt $7F,$4F,$7F
MSKEthanJumpRight06 ;3x12 
 .byt $7F,$7F,$6F
 .byt $7F,$7F,$67
 .byt $7F,$78,$4F
 .byt $7F,$70,$7F
 .byt $7F,$61,$7F
 .byt $7F,$61,$7F
 .byt $7F,$60,$4F
 .byt $7F,$40,$47
 .byt $7E,$40,$47
 .byt $7E,$40,$47
 .byt $7E,$40,$4F
 .byt $7F,$78,$5F
MSKEthanJumpRight07 ;3x10 
 .byt $7F,$7D,$7D
 .byt $7F,$78,$41
 .byt $7F,$70,$41
 .byt $77,$40,$7F
 .byt $62,$40,$7F
 .byt $40,$4C,$5F
 .byt $40,$40,$5F
 .byt $64,$40,$5F
 .byt $7C,$40,$7F
 .byt $7F,$61,$7F
MSKEthanJumpRight08 ;3x10 
 .byt $7F,$7D,$7F
 .byt $77,$78,$7F
 .byt $63,$61,$62
 .byt $40,$43,$40
 .byt $40,$46,$4C
 .byt $60,$4C,$5F
 .byt $7C,$4C,$5F
 .byt $7E,$40,$5F
 .byt $7F,$60,$7F
 .byt $7F,$71,$7F
MSKEthanJumpRight09 ;3x15 
 .byt $63,$77,$7F
 .byt $41,$63,$7F
 .byt $40,$47,$7F
 .byt $60,$4F,$7F
 .byt $60,$5F,$7F
 .byt $60,$7F,$7F
 .byt $61,$7F,$7F
 .byt $71,$7F,$7F
 .byt $70,$41,$7F
 .byt $78,$40,$5F
 .byt $7C,$40,$4F
 .byt $7F,$7F,$47
 .byt $7F,$7F,$63
 .byt $7F,$7F,$73
 .byt $7F,$7F,$78
MSKEthanJumpRight10 ;3x23 
 .byt $7F,$7E,$7F
 .byt $7F,$5C,$5F
 .byt $7C,$40,$7F
 .byt $78,$41,$7F
 .byt $78,$43,$7F
 .byt $7C,$47,$7F
 .byt $7C,$4F,$7F
 .byt $7C,$5F,$7F
 .byt $7C,$5F,$7F
 .byt $7C,$5F,$7F
 .byt $7C,$4F,$7F
 .byt $7E,$47,$7F
 .byt $7E,$43,$7F
 .byt $7F,$43,$7F
 .byt $7F,$61,$7F
 .byt $7F,$60,$7F
 .byt $7F,$70,$7F
 .byt $7F,$70,$5F
 .byt $7F,$70,$5F
 .byt $7F,$72,$5F
 .byt $7F,$72,$5F
 .byt $7F,$72,$5F
 .byt $7F,$70,$4F
MSKEthanJumpRight11 ;3x23 
 .byt $7F,$47,$7F
 .byt $7E,$43,$7F
 .byt $7E,$43,$7F
 .byt $7E,$47,$7F
 .byt $7F,$4F,$7F
 .byt $7E,$47,$7F
 .byt $7E,$47,$7F
 .byt $7E,$43,$7F
 .byt $7E,$40,$5F
 .byt $7E,$40,$4F
 .byt $7E,$48,$5F
 .byt $7F,$47,$7F
 .byt $7E,$47,$7F
 .byt $7E,$47,$7F
 .byt $7E,$47,$7F
 .byt $7E,$47,$7F
 .byt $7E,$47,$7F
 .byt $7E,$47,$7F
 .byt $7C,$67,$7F
 .byt $7C,$67,$7F
 .byt $79,$67,$7F
 .byt $79,$67,$7F
 .byt $78,$63,$7F

BMPEthanSearching
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$40,$40
 .byt $40,$4E,$40
 .byt $40,$60,$60
 .byt $40,$60,$60
 .byt $41,$60,$70
 .byt $41,$40,$50
 .byt $43,$40,$58
 .byt $46,$40,$4C	;14th row
 .byt $48,$40,$42

MSKEthanSearching
 .byt $7F,$7F,$7F	;01
 .byt $7F,$7F,$7F   ;02
 .byt $7F,$71,$7F   ;03
 .byt $7F,$60,$7F   ;04
 .byt $7F,$60,$7F   ;05
 .byt $7F,$60,$7F   ;06
 .byt $7F,$71,$7F   ;07
 .byt $7F,$40,$5F   ;08
 .byt $7E,$40,$4F   ;09
 .byt $7E,$40,$4F   ;10
 .byt $7C,$40,$47   ;11
 .byt $7C,$40,$47   ;12
 .byt $78,$40,$43   ;13
 .byt $70,$60,$61	;14 -
 .byt $61,$40,$50   ;15
 .byt $77,$40,$5D   ;16
 .byt $7F,$44,$5F   ;17
 .byt $7F,$44,$5F   ;18
 .byt $7E,$4E,$4F   ;19
 .byt $7E,$4E,$4F   ;20
 .byt $7E,$4E,$4F   ;21
 .byt $7E,$4E,$4F   ;22
 .byt $7E,$5F,$4F   ;23
 .byt $7E,$5F,$4F   ;24
 .byt $78,$5F,$43   ;25
