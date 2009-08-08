;Level 1 Data

;Contains
; * Map
; * Map Blocks
; * Ground and Air based based Sprite Bitmaps and Masks(including any shift frames)
; * Guardians
; * Scripts
;These defines tell the included scripts where the graphic frames exist in the data
#define	FS_SEASHUTTEREDGUNPOST      		26
#define	FS_SCRUBSHUTTEREDGUNPOST                49
#define	FS_RIVERCONCEALEDGUNPOST                22
#define	FS_RIVERCONCEALEDGUNPOST_S		43
#define	FS_MISSILELAUNCHEREAST                  14
#define	FS_MOTHP1                             	10
#define	FS_MOTHP2                             	11
#define	FS_MOTHP3                             	20
#define	FS_HESPITFIRE                           0
#define	FS_HWSPITFIRE                           1
#define	FS_SPITFIRE                             2
#define	FS_TRAINENGINE                          38

#define	FS_APACHE_00P1			12
#define	FS_APACHE_01P1			13

#define	FS_APACHE_00P2			61
#define	FS_APACHE_01P2			62

#define	FS_APACHE_00P3			18
#define	FS_APACHE_01P3			19


#define	FS_TRAINWAGONCAMOUFLAGEDGUN            	42
#define	FS_TRAINWAGONCOAL                      	39
#define	FS_TRAINWAGONEMPTY                     	41
#define	FS_TRAINWAGONLUMBER                    	40

#define	SC_APACHE_P3			10
#define	SC_APACHE_P2			12
#define	SC_APACHE_P1			22
#define	SC_APACHE_XX			23
#define	SC_MOTHP2				13
#define	SC_MOTHP3				24
#define	SC_WAGON_COAL			16
#define	SC_WAGON_EMPTY			14
#define	SC_WAGON_GUN			18
#define	SC_WAGON_LUMBER			17

;#define SPITFIRE_FRAMESTART			14
;#define HESPITFIRE_FRAMESTART			0
;#define HWSPITFIRE_FRAMESTART			1
;#define SCRUBSHUTTEREDGUNPOST_FRAMESTART	2
;#define SEASHUTTEREDGUNPOST_FRAMESTART		38
;
;#define TRAINSMALLENGINE_FRAMESTART		50
;#define TRAINWAGONCOAL_FRAMESTART		51
;#define TRAINWAGONLUMBER_FRAMESTART		52
;#define TRAINWAGONEMPTY_FRAMESTART		53
;#define TRAINWAGONCAMOUFLAGEDGUN_FRAMESTART	54

;We do need to know how big a step is 1,2 and 3 in pixels
;1 2
;2 3
;3 6
;UnitOfMeasure
#include "Level1_BGMapTiles.s"
#include "gfxBGMap.s"
;#include "gfxBGScenery.s"

;Each Levels sprite graphic is labelled LevelFrame_00 - LevelFrame_63
;If less than 64 sprites exist the remainder are still labelled to a null byte
;Indexed by Sprite_ID
LevelBitmapFrame_00	;HESPITFIRE
#include "Air_Sprites/HESpitfire_BitmapFrame00.s"
LevelBitmapFrame_01	;HWSPITFIRE
#include "Air_Sprites/HWSpitfire_BitmapFrame00.s
LevelBitmapFrame_02
#include "Air_Sprites/VSSpitfire_BitmapFrame00.s"
LevelBitmapFrame_03
#include "Air_Sprites/VSSpitfire_BitmapFrame01.s"
LevelBitmapFrame_04
#include "Air_Sprites/VSSpitfire_BitmapFrame02.s"
LevelBitmapFrame_05
#include "Air_Sprites/VSSpitfire_BitmapFrame03.s"
LevelBitmapFrame_06
#include "Air_Sprites/VSSpitfire_BitmapFrame04.s"
LevelBitmapFrame_07
#include "Air_Sprites/VSSpitfire_BitmapFrame05.s"
LevelBitmapFrame_08
#include "Air_Sprites/VSSpitfire_BitmapFrame06.s"
LevelBitmapFrame_09
#include "Air_Sprites/VSSpitfire_BitmapFrame07.s"
LevelBitmapFrame_10
#include "Air_Sprites/VNMoth_BitmapP1.s"
LevelBitmapFrame_11
#include "Air_Sprites/VNMoth_BitmapP2.s"
LevelBitmapFrame_12
#include "Air_Sprites/VSApache_Bitmap00P1.s"
LevelBitmapFrame_13
#include "Air_Sprites/VSApache_Bitmap01P1.s"
LevelBitmapFrame_14
#include "Gnd_Sprites/MissileLauncher00.s"
LevelBitmapFrame_15
#include "Gnd_Sprites/MissileLauncher01.s"
LevelBitmapFrame_16
#include "Gnd_Sprites/MissileLauncher02.s"
LevelBitmapFrame_17
#include "Gnd_Sprites/MissileLauncher03.s"
LevelBitmapFrame_18
#include "Air_Sprites/VSApache_Bitmap00P3.s"
LevelBitmapFrame_19
#include "Air_Sprites/VSApache_Bitmap01P3.s"
LevelBitmapFrame_20
#include "Air_Sprites/VNMoth_BitmapP3.s"
LevelBitmapFrame_21

LevelBitmapFrame_22
#include "Gnd_Sprites/RiverConcealedGunpost0.s"
LevelBitmapFrame_23
#include "Gnd_Sprites/RiverConcealedGunpost1.s"
LevelBitmapFrame_24
#include "Gnd_Sprites/RiverConcealedGunpostE.s"
LevelBitmapFrame_25
#include "Gnd_Sprites/RiverConcealedGunpostSE.s"
LevelBitmapFrame_26
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame00.s"
LevelBitmapFrame_27
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame01.s"
LevelBitmapFrame_28
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame02.s"
LevelBitmapFrame_29
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame03.s"
LevelBitmapFrame_30
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame04.s"
LevelBitmapFrame_31
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame05.s"
LevelBitmapFrame_32
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame06.s"
LevelBitmapFrame_33
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame07.s"
LevelBitmapFrame_34
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame08.s"
LevelBitmapFrame_35
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame09.s"
LevelBitmapFrame_36
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame10.s"
LevelBitmapFrame_37
#include "Gnd_Sprites/SeaShutteredGunpost_BitmapFrame11.s"
LevelBitmapFrame_38
#include "Gnd_Sprites/TrainSmallEngine_BitmapFrameH.s"
LevelBitmapFrame_39
#include "Gnd_Sprites/TrainWagonCoal_BitmapFrameH.s"
LevelBitmapFrame_40
#include "Gnd_Sprites/TrainWagonLumber_BitmapFrameH.s"
LevelBitmapFrame_41
#include "Gnd_Sprites/TrainWagonEmpty_BitmapFrameH.s"
LevelBitmapFrame_42
#include "Gnd_Sprites/TrainWagonCamouflagedGun_BitmapFrameH.s"
LevelBitmapFrame_43
#include "Gnd_Sprites/RiverConcealedGunpostS.s"
LevelBitmapFrame_44
#include "Gnd_Sprites/RiverConcealedGunpostSW.s"
LevelBitmapFrame_45
#include "Gnd_Sprites/RiverConcealedGunpostW.s"
LevelBitmapFrame_46
#include "Gnd_Sprites/RiverConcealedGunpostNW.s"
LevelBitmapFrame_47
#include "Gnd_Sprites/RiverConcealedGunpostN.s"
LevelBitmapFrame_48
#include "Gnd_Sprites/RiverConcealedGunpostNE.s"
LevelBitmapFrame_49
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame00.s"
LevelBitmapFrame_50
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame01.s"
LevelBitmapFrame_51
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame02.s"
LevelBitmapFrame_52
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame03.s"
LevelBitmapFrame_53
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame04.s"
LevelBitmapFrame_54
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame05.s"
LevelBitmapFrame_55
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame06.s"
LevelBitmapFrame_56
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame07.s"
LevelBitmapFrame_57
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame08.s"
LevelBitmapFrame_58
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame09.s"
LevelBitmapFrame_59
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame10.s"
LevelBitmapFrame_60
#include "Gnd_Sprites/ShutteredGunpost_BitmapFrame11.s"
LevelBitmapFrame_61
#include "Air_Sprites/VSApache_Bitmap00P2.s"
LevelBitmapFrame_62
#include "Air_Sprites/VSApache_Bitmap01P2.s"
LevelBitmapFrame_63


;Indexed by Sprite_ID
LevelMaskFrame_00	;HESPITFIRE
#include "Air_Sprites/HESpitfire_MaskFrame00.s"
LevelMaskFrame_01	;HWSPITFIRE
#include "Air_Sprites/HWSpitfire_MaskFrame00.s
LevelMaskFrame_02
#include "Air_Sprites/VSSpitfire_MaskFrame00.s"
LevelMaskFrame_03
#include "Air_Sprites/VSSpitfire_MaskFrame01.s"
LevelMaskFrame_04
#include "Air_Sprites/VSSpitfire_MaskFrame02.s"
LevelMaskFrame_05
#include "Air_Sprites/VSSpitfire_MaskFrame03.s"
LevelMaskFrame_06
#include "Air_Sprites/VSSpitfire_MaskFrame04.s"
LevelMaskFrame_07
#include "Air_Sprites/VSSpitfire_MaskFrame05.s"
LevelMaskFrame_08
#include "Air_Sprites/VSSpitfire_MaskFrame06.s"
LevelMaskFrame_09
#include "Air_Sprites/VSSpitfire_MaskFrame07.s"
LevelMaskFrame_10
#include "Air_Sprites/VNMoth_MaskP1.s"
LevelMaskFrame_11
#include "Air_Sprites/VNMoth_MaskP2.s"
LevelMaskFrame_12
#include "Air_Sprites/VSApache_Mask00P1.s"
LevelMaskFrame_13
#include "Air_Sprites/VSApache_Mask01P1.s"
LevelMaskFrame_14
LevelMaskFrame_15
LevelMaskFrame_16
LevelMaskFrame_17
 .dsb 55,64
LevelMaskFrame_18
#include "Air_Sprites/VSApache_Mask00P3.s"
LevelMaskFrame_19
#include "Air_Sprites/VSApache_Mask01P3.s"
LevelMaskFrame_20
#include "Air_Sprites/VNMoth_MaskP3.s"
LevelMaskFrame_21

LevelMaskFrame_22
LevelMaskFrame_23
LevelMaskFrame_24
LevelMaskFrame_25
LevelMaskFrame_26
LevelMaskFrame_27
LevelMaskFrame_28
LevelMaskFrame_29
LevelMaskFrame_30
LevelMaskFrame_31
LevelMaskFrame_32
LevelMaskFrame_33
LevelMaskFrame_34
LevelMaskFrame_35
LevelMaskFrame_36
LevelMaskFrame_37
LevelMaskFrame_38
LevelMaskFrame_39
LevelMaskFrame_40
LevelMaskFrame_41
LevelMaskFrame_42
LevelMaskFrame_43
LevelMaskFrame_44
LevelMaskFrame_45
LevelMaskFrame_46
LevelMaskFrame_47
LevelMaskFrame_48
LevelMaskFrame_49
LevelMaskFrame_50
LevelMaskFrame_51
LevelMaskFrame_52
LevelMaskFrame_53
LevelMaskFrame_54
LevelMaskFrame_55
LevelMaskFrame_56
LevelMaskFrame_57
LevelMaskFrame_58
LevelMaskFrame_59
LevelMaskFrame_60
 .dsb 55,64
LevelMaskFrame_61
#include "Air_Sprites/VSApache_Mask00P2.s"
LevelMaskFrame_62
#include "Air_Sprites/VSApache_Mask01P2.s"
LevelMaskFrame_63

;Indexed by Sprite_ID
LevelFrameWidth
 .byt 4	;00 HESpitfire
 .byt 4	;01 HWSpitfire
 .byt 5	;02 VSSpitfire
 .byt 5	;03 VSSpitfire
 .byt 5	;04 VSSpitfire
 .byt 5	;05 VSSpitfire
 .byt 5	;06 VSSpitfire
 .byt 5	;07 VSSpitfire
 .byt 5	;08 VSSpitfire
 .byt 5	;09 VSSpitfire
 .byt 7	;10 VNMoth
 .byt 7	;11 VNMoth
 .byt 5	;12 VSApache
 .byt 5	;13 VSApache
 .byt 4	;14 MissileLauncher
 .byt 4	;15 MissileLauncher
 .byt 4	;16 MissileLauncher
 .byt 4	;17 MissileLauncher
 .byt 5	;18 Apache
 .byt 5	;19 Apache
 .byt 7	;20 Moth
 .byt 4	;21 
 .byt 2	;22 RiverConcealedGunpost
 .byt 2	;23 RiverConcealedGunpost
 .byt 2	;24 RiverConcealedGunpost
 .byt 2	;25 RiverConcealedGunpost
 .byt 4	;26 SeaShutteredGunpost
 .byt 4	;27 SeaShutteredGunpost
 .byt 4	;28 SeaShutteredGunpost
 .byt 4	;29 SeaShutteredGunpost
 .byt 4	;30 SeaShutteredGunpost
 .byt 4	;31 SeaShutteredGunpost
 .byt 4	;32 SeaShutteredGunpost
 .byt 4	;33 SeaShutteredGunpost
 .byt 4	;34 SeaShutteredGunpost
 .byt 4	;35 SeaShutteredGunpost
 .byt 4	;36 SeaShutteredGunpost
 .byt 4	;37 SeaShutteredGunpost
 .byt 5	;38 TrainSmallEngine
 .byt 4	;39 TrainWagonCoal
 .byt 4	;40 TrainWagonLumber
 .byt 6	;41 TrainWagonEmpty
 .byt 5	;42 TrainWagonCamouflagedGun
 .byt 2	;43 RiverConcealedGunpost
 .byt 2	;44 RiverConcealedGunpost
 .byt 2	;45 RiverConcealedGunpost
 .byt 2	;46 RiverConcealedGunpost
 .byt 2	;47 RiverConcealedGunpost
 .byt 2	;48 RiverConcealedGunpost
 .byt 4	;49 ScrubShutteredGunpost
 .byt 4	;50 ScrubShutteredGunpost
 .byt 4	;51 ScrubShutteredGunpost
 .byt 4	;52 ScrubShutteredGunpost
 .byt 4	;53 ScrubShutteredGunpost
 .byt 4	;54 ScrubShutteredGunpost
 .byt 4	;55 ScrubShutteredGunpost
 .byt 4	;56 ScrubShutteredGunpost
 .byt 4	;57 ScrubShutteredGunpost
 .byt 4	;58 ScrubShutteredGunpost
 .byt 4	;59 ScrubShutteredGunpost
 .byt 4	;60 ScrubShutteredGunpost
 .byt 5	;61 Apache
 .byt 5	;62 Apache
 .byt 0	;63 

;Indexed by Sprite_ID
LevelFrameHeight	;Not required for plotting but may be useful in collision code
 .byt 11	;00 HESpitfire              
 .byt 11  ;01 HWSpitfire              
 .byt 11  ;02 VSSpitfire              
 .byt 11  ;03 VSSpitfire              
 .byt 11  ;04 VSSpitfire              
 .byt 11  ;05 VSSpitfire              
 .byt 11  ;06 VSSpitfire              
 .byt 11  ;07 VSSpitfire              
 .byt 11  ;08 VSSpitfire              
 .byt 11  ;09 VSSpitfire              
 .byt 8   ;10 VNMoth                  
 .byt 8   ;11 VNMoth                  
 .byt 8   ;12 VSApache                
 .byt 8   ;13 VSApache                
 .byt 11	;14 MissileLauncher         
 .byt 11	;15 MissileLauncher         
 .byt 11	;16 MissileLauncher         
 .byt 11	;17 MissileLauncher         
 .byt 8	;18 Apache                  
 .byt 8	;19 Apache                  
 .byt 8	;20 Moth                    
 .byt 11	;21                         
 .byt 11	;22 RiverConcealedGunpost   
 .byt 11	;23 RiverConcealedGunpost   
 .byt 11	;24 RiverConcealedGunpost   
 .byt 11	;25 RiverConcealedGunpost   
 .byt 11	;26 SeaShutteredGunpost     
 .byt 11	;27 SeaShutteredGunpost     
 .byt 11	;28 SeaShutteredGunpost     
 .byt 11	;29 SeaShutteredGunpost     
 .byt 11	;30 SeaShutteredGunpost     
 .byt 11	;31 SeaShutteredGunpost     
 .byt 11	;32 SeaShutteredGunpost     
 .byt 11	;33 SeaShutteredGunpost     
 .byt 11	;34 SeaShutteredGunpost     
 .byt 11	;35 SeaShutteredGunpost     
 .byt 11	;36 SeaShutteredGunpost     
 .byt 11	;37 SeaShutteredGunpost     
 .byt 10	;38 TrainSmallEngine        
 .byt 10	;39 TrainWagonCoal          
 .byt 10	;40 TrainWagonLumber        
 .byt 10	;41 TrainWagonEmpty         
 .byt 10	;42 TrainWagonCamouflagedGun
 .byt 11	;43 RiverConcealedGunpost   
 .byt 11	;44 RiverConcealedGunpost   
 .byt 11	;45 RiverConcealedGunpost   
 .byt 11	;46 RiverConcealedGunpost   
 .byt 11	;47 RiverConcealedGunpost   
 .byt 11	;48 RiverConcealedGunpost   
 .byt 11	;49 ScrubShutteredGunpost   
 .byt 11	;50 ScrubShutteredGunpost   
 .byt 11	;51 ScrubShutteredGunpost   
 .byt 11	;52 ScrubShutteredGunpost   
 .byt 11	;53 ScrubShutteredGunpost   
 .byt 11	;54 ScrubShutteredGunpost   
 .byt 11	;55 ScrubShutteredGunpost   
 .byt 11	;56 ScrubShutteredGunpost   
 .byt 11	;57 ScrubShutteredGunpost   
 .byt 11	;58 ScrubShutteredGunpost   
 .byt 11	;59 ScrubShutteredGunpost   
 .byt 11	;60 ScrubShutteredGunpost   
 .byt 8	;61 Apache                  
 .byt 8	;62 Apache                  
 .byt 0	;63                         
;Indexed by Sprite_ID
LevelFrameUltimateByte
 .byt 43  ;00 HESpitfire              
 .byt 43  ;01 HWSpitfire              
 .byt 54  ;02 VSSpitfire              
 .byt 54  ;03 VSSpitfire              
 .byt 54  ;04 VSSpitfire              
 .byt 54  ;05 VSSpitfire              
 .byt 54  ;06 VSSpitfire              
 .byt 54  ;07 VSSpitfire              
 .byt 54  ;08 VSSpitfire              
 .byt 54  ;09 VSSpitfire              
 .byt 55  ;10 VNMoth                  
 .byt 55  ;11 VNMoth                  
 .byt 39  ;12 VSApache                
 .byt 39  ;13 VSApache                
 .byt 43	;14 MissileLauncher         
 .byt 43	;15 MissileLauncher         
 .byt 43	;16 MissileLauncher         
 .byt 43	;17 MissileLauncher         
 .byt 39	;18 Apache                  
 .byt 39	;19 Apache                  
 .byt 55	;20 Moth                    
 .byt 43	;21                         
 .byt 21	;22 RiverConcealedGunpost   
 .byt 21	;23 RiverConcealedGunpost   
 .byt 21	;24 RiverConcealedGunpost   
 .byt 21	;25 RiverConcealedGunpost   
 .byt 43	;26 SeaShutteredGunpost     
 .byt 43	;27 SeaShutteredGunpost     
 .byt 43	;28 SeaShutteredGunpost     
 .byt 43	;29 SeaShutteredGunpost     
 .byt 43	;30 SeaShutteredGunpost     
 .byt 43	;31 SeaShutteredGunpost     
 .byt 43	;32 SeaShutteredGunpost     
 .byt 43	;33 SeaShutteredGunpost     
 .byt 43	;34 SeaShutteredGunpost     
 .byt 43	;35 SeaShutteredGunpost     
 .byt 43	;36 SeaShutteredGunpost     
 .byt 43	;37 SeaShutteredGunpost     
 .byt 49	;38 TrainSmallEngine        
 .byt 39	;39 TrainWagonCoal          
 .byt 39	;40 TrainWagonLumber        
 .byt 59	;41 TrainWagonEmpty         
 .byt 49	;42 TrainWagonCamouflagedGun
 .byt 21	;43 RiverConcealedGunpost   
 .byt 21	;44 RiverConcealedGunpost   
 .byt 21	;45 RiverConcealedGunpost   
 .byt 21	;46 RiverConcealedGunpost   
 .byt 21	;47 RiverConcealedGunpost   
 .byt 21	;48 RiverConcealedGunpost   
 .byt 43	;49 ScrubShutteredGunpost   
 .byt 43	;50 ScrubShutteredGunpost   
 .byt 43	;51 ScrubShutteredGunpost   
 .byt 43	;52 ScrubShutteredGunpost   
 .byt 43	;53 ScrubShutteredGunpost   
 .byt 43	;54 ScrubShutteredGunpost   
 .byt 43	;55 ScrubShutteredGunpost   
 .byt 43	;56 ScrubShutteredGunpost   
 .byt 43	;57 ScrubShutteredGunpost   
 .byt 43	;58 ScrubShutteredGunpost   
 .byt 43	;59 ScrubShutteredGunpost   
 .byt 43	;60 ScrubShutteredGunpost   
 .byt 39	;61 Apache                  
 .byt 39	;62 Apache                  
 .byt 0	;63                         

;Number of bytes to read/write to collision map (zero based)
;Indexed by Sprite_ID
LevelFrameCollisionBytes
 .byt 7	;00 HESpitfire               4x(11/6)
 .byt 7  	;01 HWSpitfire               4x(11/6)
 .byt 9	;02 VSSpitfire               5x(11/6)
 .byt 9  	;03 VSSpitfire               5x(11/6)
 .byt 9  	;04 VSSpitfire               5x(11/6)
 .byt 9  	;05 VSSpitfire               5x(11/6)
 .byt 9  	;06 VSSpitfire               5x(11/6)
 .byt 9  	;07 VSSpitfire               5x(11/6)
 .byt 9  	;08 VSSpitfire               5x(11/6)
 .byt 9  	;09 VSSpitfire               5x(11/6)
 .byt 13 	;10 VNMoth                   7x(8/6)
 .byt 13 	;11 VNMoth                   7x(8/6)
 .byt 9  	;12 VSApache                 5x(8/6)
 .byt 9  	;13 VSApache                 5x(8/6)
 .byt 7 	;14 MissileLauncher          4x(11/6)
 .byt 7 	;15 MissileLauncher          4x(11/6)
 .byt 7 	;16 MissileLauncher          4x(11/6)
 .byt 7 	;17 MissileLauncher          4x(11/6)
 .byt 7 	;18 Apache                   4x(8/6)
 .byt 7 	;19 Apache                   4x(8/6)
 .byt 7 	;20 Moth                     4x(8/6)
 .byt 7 	;21                          4x(11/6)
 .byt 3	;22 RiverConcealedGunpost    2x(11/6)
 .byt 3	;23 RiverConcealedGunpost    2x(11/6)
 .byt 3	;24 RiverConcealedGunpost    2x(11/6)
 .byt 3	;25 RiverConcealedGunpost    2x(11/6)
 .byt 7	;26 SeaShutteredGunpost      4x(11/6)
 .byt 7	;27 SeaShutteredGunpost      4x(11/6)
 .byt 7	;28 SeaShutteredGunpost      4x(11/6)
 .byt 7	;29 SeaShutteredGunpost      4x(11/6)
 .byt 7	;30 SeaShutteredGunpost      4x(11/6)
 .byt 7	;31 SeaShutteredGunpost      4x(11/6)
 .byt 7	;32 SeaShutteredGunpost      4x(11/6)
 .byt 7	;33 SeaShutteredGunpost      4x(11/6)
 .byt 7	;34 SeaShutteredGunpost      4x(11/6)
 .byt 7	;35 SeaShutteredGunpost      4x(11/6)
 .byt 7	;36 SeaShutteredGunpost      4x(11/6)
 .byt 7	;37 SeaShutteredGunpost      4x(11/6)
 .byt 9	;38 TrainSmallEngine         5x(10/6)
 .byt 7	;39 TrainWagonCoal           4x(10/6)
 .byt 7	;40 TrainWagonLumber         4x(10/6)
 .byt 11	;41 TrainWagonEmpty          6x(10/6)
 .byt 9	;42 TrainWagonCamouflagedGun 5x(10/6)
 .byt 3	;43 RiverConcealedGunpost    2x(11/6)
 .byt 3	;44 RiverConcealedGunpost    2x(11/6)
 .byt 3	;45 RiverConcealedGunpost    2x(11/6)
 .byt 3	;46 RiverConcealedGunpost    2x(11/6)
 .byt 3	;47 RiverConcealedGunpost    2x(11/6)
 .byt 3	;48 RiverConcealedGunpost    2x(11/6)
 .byt 7 	;49 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;50 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;51 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;52 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;53 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;54 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;55 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;56 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;57 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;58 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;59 ScrubShutteredGunpost    4x(11/6)
 .byt 7 	;60 ScrubShutteredGunpost    4x(11/6)
 .byt 9	;61 Apache                   5x(8/6)
 .byt 9	;62 Apache                   5x(8/6)
 .byt 0	;63                          


;Indexed by Script_ID
;The number of points awarded to player for killing this enemy
LevelFrameHitpoints
 .byt 5   	;SeaShutteredGunpost
 .byt 5   	;ScrubShutteredGunpost
 .byt 8   	;RiverConcealedGunpost
 .byt 20  	;MissileLauncherEast
 .byt 15  	;MothMain
 .byt 5   	;HESpitfire
 .byt 5   	;HWSpitfire
 .byt 5   	;Spitfire
 .byt 5   	;TrainEngineE
 .byt 5   	;TrainEngineW
 .byt 50  	;ApacheMain
 .byt 20  	;MissileLauncherWest
 .byt 50  	;ApacheTail
 .byt 10  	;MothTail
 .byt 4   	;ETrainWagonCamouflagedGun
 .byt 4   	;ETrainWagonCoal
 .byt 4   	;ETrainWagonEmpty
 .byt 4   	;ETrainWagonLumber
 .byt 4   	;WTrainWagonCamouflagedGun
 .byt 4   	;WTrainWagonCoal          
 .byt 4		;WTrainWagonEmpty         
 .byt 4		;WTrainWagonLumber
 
DistanceBetweenWaveSprites
 .byt 0   	;SeaShutteredGunpost
 .byt 0   	;ScrubShutteredGunpost
 .byt 0   	;RiverConcealedGunpost
 .byt 0   	;MissileLauncherEast
 .byt 0   	;MothMain
 .byt 3   	;HESpitfire
 .byt 3   	;HWSpitfire
 .byt 20  	;Spitfire
 .byt 0   	;TrainEngineE
 .byt 0   	;TrainEngineW
 .byt 0   	;ApacheMain
 .byt 0   	;MissileLauncherWest
 .byt 0   	;ApacheTail
 .byt 0   	;MothTail
 .byt 0   	;ETrainWagonCamouflagedGun
 .byt 0   	;ETrainWagonCoal
 .byt 0   	;ETrainWagonEmpty
 .byt 0   	;ETrainWagonLumber
 .byt 0   	;WTrainWagonCamouflagedGun
 .byt 0   	;WTrainWagonCoal          
 .byt 0		;WTrainWagonEmpty         
 .byt 0		;WTrainWagonLumber
;Defines the bonuses available for each Sprite as two alternating sides in hi/lo nibble of byte
;00 bmpBonus_Blank
;01 bmpBonus_Health
;02 bmpBonus_Life
;03 bmpBonus_DoubleCannon
;04 bmpBonus_Splay
;05 bmpBonus_Sidewinders
;06 bmpBonus_Retros
;07 bmpBonus_SmartBomb
;08 bmpBonus_Missile
;09 bmpBonus_Laser
;10 bmpBonus_SpeedUp
;11 bmpBonus_Invisibility
;12 bmpBonus_Shield
;13 bmpBonus_Orb
;14 bmpBonus_Blank
;15 bmpBonus_Blank
LevelBonuses
 .byt 0   	;SeaShutteredGunpost
 .byt 0   	;ScrubShutteredGunpost
 .byt 0   	;RiverConcealedGunpost
 .byt 12+16*2    	;MissileLauncherEast
 .byt 7+16*1    	;MothMain
 .byt 0    	;HESpitfire
 .byt 0    	;HWSpitfire
 .byt 0    	;Spitfire
 .byt 3+16*1    	;TrainEngineE
 .byt 3+16*1    	;TrainEngineW
 .byt 4+16*1    	;ApacheMain
 .byt 12+16*2    	;MissileLauncherWest
 .byt 4+16*1    	;ApacheTail
 .byt 7+16*1	;MothTail
 .byt 0	    	;ETrainWagonCamouflagedGun
 .byt 0	    	;ETrainWagonCoal
 .byt 0	    	;ETrainWagonEmpty
 .byt 0	    	;ETrainWagonLumber
 .byt 0	    	;WTrainWagonCamouflagedGun
 .byt 0	    	;WTrainWagonCoal          
 .byt 0		;WTrainWagonEmpty         
 .byt 0		;WTrainWagonLumber
LevelFrameHealth
 .byt 2   	;SeaShutteredGunpost
 .byt 2   	;ScrubShutteredGunpost
 .byt 2   	;RiverConcealedGunpost
 .byt 10  	;MissileLauncherEast
 .byt 15  	;MothMain
 .byt 1   	;HESpitfire
 .byt 1   	;HWSpitfire
 .byt 2   	;Spitfire
 .byt 7   	;TrainEngineE
 .byt 7   	;TrainEngineW
 .byt 30  	;ApacheMain
 .byt 10  	;MissileLauncherWest
 .byt 30  	;ApacheTail
 .byt 15  	;MothTail
 .byt 5   	;ETrainWagonCamouflagedGun
 .byt 5   	;ETrainWagonCoal
 .byt 5   	;ETrainWagonEmpty
 .byt 5   	;ETrainWagonLumber
 .byt 5   	;WTrainWagonCamouflagedGun
 .byt 5   	;WTrainWagonCoal          
 .byt 5		;WTrainWagonEmpty         
 .byt 5		;WTrainWagonLumber

;Indexed by Sprite_ScriptID
LevelScript_00
#include "Scripts/Script_SeaShutteredGunpost.s"	;Triggers Projectiles
LevelScript_01
#include "Scripts/Script_ScrubShutteredGunpost.s"	;Triggers Projectiles
LevelScript_02
#include "Scripts/Script_RiverConcealedGunpost.s"	;Triggers Projectiles
LevelScript_03
#include "Scripts/Script_MissileLauncherEast.s"   ;Triggers Projectiles
LevelScript_04
#include "Scripts/Script_MothP1.s"		;Triggers 13 and 24
LevelScript_05
#include "Scripts/Script_HESpitfire.s"
LevelScript_06
#include "Scripts/Script_HWSpitfire.s"
LevelScript_07
#include "Scripts/Script_Spitfire.s"
LevelScript_08
#include "Scripts/Script_TrainEngineE.s"	;Triggers Coal(15)
LevelScript_09
#include "Scripts/Script_TrainEngineW.s"	;Triggers Coal(19)
LevelScript_10
#include "Scripts/Script_ApacheP3.s"		;Triggers 12 and Projectiles
LevelScript_11
#include "Scripts/Script_MissileLauncherWest.s"	;Triggers Projectiles
LevelScript_12
#include "Scripts/Script_ApacheP2.s"
LevelScript_13
#include "Scripts/Script_MothP2.s"		;Triggers Projectiles
LevelScript_14
#include "Scripts/Script_ETrainWagonCamouflagedGun.s"	;Triggers 17 and Projectiles
LevelScript_15
#include "Scripts/Script_ETrainWagonCoal.s"	;Triggers 16
LevelScript_16
#include "Scripts/Script_ETrainWagonEmpty.s"	;Triggers 14
LevelScript_17
#include "Scripts/Script_ETrainWagonLumber.s"	;Always last Wagon
LevelScript_18
#include "Scripts/Script_WTrainWagonCamouflagedGun.s"	;Triggers 21 and Projectiles
LevelScript_19
#include "Scripts/Script_WTrainWagonCoal.s"	;Triggers 20
LevelScript_20
#include "Scripts/Script_WTrainWagonEmpty.s"	;Triggers 18
LevelScript_21
#include "Scripts/Script_WTrainWagonLumber.s"	;Always last Wagon
LevelScript_22
#include "Scripts/Script_ApacheP1.s"
LevelScript_23
#include "Scripts/Script_ApacheXX.s"
LevelScript_24
#include "Scripts/Script_MothP3.s"
LevelScript_25
LevelScript_26
LevelScript_27
LevelScript_28
LevelScript_29
LevelScript_30
LevelScript_31

