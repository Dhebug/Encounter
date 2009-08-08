;Level1_BGMapTiles.s
#include "BG_Tiles/bgfxBuilding1.s"		;00 bgfxBuilding1	             
#include "BG_Tiles/bgfxScrubland1.s"             	;01 bgfxScrubland1	            
#include "BG_Tiles/bgfxNissanOnScrub.s"          	;02 bgfxNissanOnScrub	         
#include "BG_Tiles/bgfxVRunway.s"                	;03 bgfxVRunway		              
#include "BG_Tiles/bgfxHouse.s"                  	;04 bgfxHouse		                
#include "BG_Tiles/bgfxCanalNS.s"                	;05 bgfxCanalNS		              
#include "BG_Tiles/bgfxCamouflage.s"             	;06 bgfxCamouflage             
#include "BG_Tiles/bgfxScrubWaterInsideEdgeTL.s"  ;07 bgfxScrubWaterInsideEdgeTL 
#include "BG_Tiles/bgfxScrubWaterInsideEdgeTR.s"  ;08 bgfxScrubWaterInsideEdgeTR 
#include "BG_Tiles/bgfxRoadNSTrackRight.s"        ;09 bgfxRoadNSTrackRight         
#include "BG_Tiles/bgfxTrackWE.s"                	;10 bgfxTrackWE
#include "BG_Tiles/bgfxHTrackBridge.s"           	;11 bgfxHTrackBridge
#include "BG_Tiles/bgfxRoadNS.s"                 	;12 bgfxRoadNS                   
#include "BG_Tiles/bgfxRoadWE.s"                 	;13 bgfxRoadWE                   
#include "BG_Tiles/bgfxRoadWN.s"                 	;14 bgfxRoadWN                   
#include "BG_Tiles/bgfxRoadWS.s"                 	;15 bgfxRoadWS                   
#include "BG_Tiles/bgfxRoadES.s"                 	;16 bgfxRoadES                   
#include "BG_Tiles/bgfxRoadNE.s"                 	;17 bgfxRoadNE                   
#include "BG_Tiles/bgfxRoadWETrackN.s"           	;18 bgfxRoadWETrackN             
#include "BG_Tiles/bgfxTrackNS.s"                	;19 bgfxTrackNS                  
#include "BG_Tiles/bgfxScrubRailway.s"           	;20 bgfxScrubRailway             
#include "BG_Tiles/bgfxScrubRailGates.s"         	;21 bgfxScrubRailGates           
#include "BG_Tiles/bgfxHRailBridge.s"            	;22 bgfxHRailBridge
#include "BG_Tiles/bgfxScrubWaterInsideEdgeBL.s"	;23 bgfxScrubWaterInsideEdgeBL 
#include "BG_Tiles/bgfxScrubWaterInsideEdgeBR.s"	;24 bgfxScrubWaterInsideEdgeBR 
#include "BG_Tiles/bgfxSea.s"                    	;25 bgfxSea                    
#include "BG_Tiles/bgfxRoadBrickWE.s"            	;26 bgfxRoadBrickWE            
#include "BG_Tiles/bgfxScrubWaterOutsideEdgeBL.s"	;27 bgfxScrubWaterOutsideEdgeBL
#include "BG_Tiles/bgfxRoadBrickTS.s"            	;28 bgfxRoadBrickTS            
#include "BG_Tiles/bgfxRoadBrickNS.s"            	;29 bgfxRoadBrickNS            
#include "BG_Tiles/bgfxUniformTree.s"            	;30 bgfxUniformTree            
#include "BG_Tiles/bgfxScrubWaterOutsideEdgeBR.s"	;31 bgfxScrubWaterOutsideEdgeBR
#include "BG_Tiles/bgfxScrubRedTank.s"           	;32 bgfxScrubRedTank           
#include "BG_Tiles/bgfxBeach.s"                  	;33 bgfxBeach                  
#include "BG_Tiles/bgfxBuilding2.s"              	;34 bgfxBuilding2              
#include "BG_Tiles/bgfxScrubBarrels.s"           	;35 bgfxScrubBarrels           
#include "BG_Tiles/bgfxTrackWS.s"                	;36 bgfxTrackWS                
#include "BG_Tiles/bgfxTrackNW.s"                	;37 bgfxTrackNW                
#include "BG_Tiles/bgfxTrackNE.s"                	;38 bgfxTrackNE                
#include "BG_Tiles/bgfxTrackSE.s"                	;39 bgfxTrackSE                
#include "BG_Tiles/bgfxScrubland2.s"             	;40 bgfxScrubland2             
#include "BG_Tiles/bgfxScrubShrubs.s"            	;41 bgfxScrubShrubs            
#include "BG_Tiles/bgfxScrub2Beach.s"            	;42 bgfxScrub2Beach            
#include "BG_Tiles/bgfxScrubPond.s"              	;43 bgfxScrubPond              
#include "BG_Tiles/bgfxBeach2Water.s"            	;44 bgfxBeach2Water            
#include "BG_Tiles/bgfxLonghouseL.s"		;45 bgfxLonghouseL             
#include "BG_Tiles/bgfxLonghouseR.s"             	;46 bgfxLonghouseR             
#include "BG_Tiles/bgfxHillN.s"                  	;47 bgfxHillN                  
#include "BG_Tiles/bgfxHillS.s"                  	;48 bgfxHillS                  
#include "BG_Tiles/bgfxHillSCornerR.s"		;49 bgfxHillSCornerR           
#include "BG_Tiles/bgfxHillE.s"                  	;50 bgfxHillE
#include "BG_Tiles/bgfxHillNCornerR.s"           	;51 bgfxHillNCornerR           
#include "BG_Tiles/bgfxHillTop1.s"               	;52 bgfxHillTop1               
#include "BG_Tiles/bgfxHillTopCrater.s"          	;53 bgfxHillTopCrater          
#include "BG_Tiles/bgfxHillTopPond.s"            	;54 bgfxHillTopPond            
#include "BG_Tiles/bgfxHillSCornerL.s"           	;55 bgfxHillSCornerL           
#include "BG_Tiles/bgfxHillW.s"                  	;56 bgfxHillW                  
#include "BG_Tiles/bgfxHillNCornerL.s"           	;57 bgfxHillNCornerL           
#include "BG_Tiles/bgfxHillTop2.s"               	;58 bgfxHillTop2               
#include "BG_Tiles/bgfxHillTopNissan.s"          	;59 bgfxHilltopNissan               
#include "BG_Tiles/bgfxCrater.s"	          ;60 bgfxCrater                               
#include "BG_Tiles/bgfxScrubWaterOutsideEdgeTL.s"	;61 bgfxScrubWaterOutsideEdgeTL       
#include "BG_Tiles/bgfxIslandShutteredGunpost.s"	;62 bgfxIslandShutteredGunpost       
#include "BG_Tiles/bgfxRunwayBarrier.s"	          ;63 bgfxRunwayBarrier          

;#include "BG_Tiles/bgfxScrubWaterOutsideEdgeTR.s"
;#include "BG_Tiles/bgfxRiverTurn2.s"             	
;#include "BG_Tiles/bgfxRiverTurn3.s"             	
GraphicBlockAddressLo	
 .byt <bgfxBuilding1		;00
 .byt <bgfxScrubland1		;01
 .byt <bgfxNissanOnScrub		;02
 .byt <bgfxVRunway			;03
 .byt <bgfxHouse			;04
 .byt <bgfxCanalNS			;05
 .byt <bgfxCamouflage                   ;06
 .byt <bgfxScrubWaterInsideEdgeTL       ;07
 .byt <bgfxScrubWaterInsideEdgeTR       ;08
 .byt <bgfxRoadNSTrackRight             ;09
 .byt <bgfxTrackWE                      ;10
 .byt <bgfxHTrackBridge                 ;11
 .byt <bgfxRoadNS                       ;12
 .byt <bgfxRoadWE                       ;13
 .byt <bgfxRoadWN                       ;14
 .byt <bgfxRoadWS                       ;15
 .byt <bgfxRoadES                       ;16
 .byt <bgfxRoadNE                       ;17
 .byt <bgfxRoadWETrackN                 ;18
 .byt <bgfxTrackNS                      ;19
 .byt <bgfxScrubRailway                 ;20
 .byt <bgfxScrubRailGates               ;21
 .byt <bgfxHRailBridge                  ;22
 .byt <bgfxScrubWaterInsideEdgeBL       ;23
 .byt <bgfxScrubWaterInsideEdgeBR       ;24
 .byt <bgfxSea                          ;25
 .byt <bgfxRoadBrickWE                  ;26
 .byt <bgfxScrubWaterOutsideEdgeBL      ;27
 .byt <bgfxRoadBrickTS                  ;28
 .byt <bgfxRoadBrickNS                  ;29
 .byt <bgfxUniformTree                  ;30
 .byt <bgfxScrubWaterOutsideEdgeBR      ;31
 .byt <bgfxScrubRedTank                 ;32
 .byt <bgfxBeach                        ;33
 .byt <bgfxBuilding2                    ;34
 .byt <bgfxScrubBarrels                 ;35
 .byt <bgfxTrackWS                      ;36
 .byt <bgfxTrackNW                      ;37
 .byt <bgfxTrackNE                      ;38
 .byt <bgfxTrackSE                      ;39
 .byt <bgfxScrubland2                   ;40
 .byt <bgfxScrubShrubs                  ;41
 .byt <bgfxScrub2Beach                  ;42
 .byt <bgfxScrubPond                    ;43
 .byt <bgfxBeach2Water                  ;44
 .byt <bgfxLonghouseL                   ;45
 .byt <bgfxLonghouseR                   ;46
 .byt <bgfxHillN                        ;47
 .byt <bgfxHillS                        ;48
 .byt <bgfxHillSCornerR                 ;49
 .byt <bgfxHillE                        ;50
 .byt <bgfxHillNCornerR                 ;51
 .byt <bgfxHillTop1                     ;52
 .byt <bgfxHillTopCrater                ;53
 .byt <bgfxHillTopPond                  ;54
 .byt <bgfxHillSCornerL                 ;55
 .byt <bgfxHillW                        ;56
 .byt <bgfxHillNCornerL                 ;57
 .byt <bgfxHillTop2                     ;58
 .byt <bgfxHilltopNissan                ;59
 .byt <bgfxCrater                       ;60
 .byt <bgfxScrubWaterOutsideEdgeTL      ;61
 .byt <bgfxIslandShutteredGunpost       ;62
 .byt <bgfxRunwayBarrier                ;63

GraphicBlockAddressHi
 .byt >bgfxBuilding1	
 .byt >bgfxScrubland1	
 .byt >bgfxNissanOnScrub	
 .byt >bgfxVRunway		
 .byt >bgfxHouse		
 .byt >bgfxCanalNS
 .byt >bgfxCamouflage
 .byt >bgfxScrubWaterInsideEdgeTL
 .byt >bgfxScrubWaterInsideEdgeTR
 .byt >bgfxRoadNSTrackRight
 .byt >bgfxTrackWE
 .byt >bgfxHTrackBridge
 .byt >bgfxRoadNS
 .byt >bgfxRoadWE
 .byt >bgfxRoadWN
 .byt >bgfxRoadWS
 .byt >bgfxRoadES
 .byt >bgfxRoadNE
 .byt >bgfxRoadWETrackN
 .byt >bgfxTrackNS
 .byt >bgfxScrubRailway
 .byt >bgfxScrubRailGates
 .byt >bgfxHRailBridge
 .byt >bgfxScrubWaterInsideEdgeBL
 .byt >bgfxScrubWaterInsideEdgeBR
 .byt >bgfxSea
 .byt >bgfxRoadBrickWE
 .byt >bgfxScrubWaterOutsideEdgeBL
 .byt >bgfxRoadBrickTS
 .byt >bgfxRoadBrickNS
 .byt >bgfxUniformTree
 .byt >bgfxScrubWaterOutsideEdgeBR
 .byt >bgfxScrubRedTank
 .byt >bgfxBeach
 .byt >bgfxBuilding2
 .byt >bgfxScrubBarrels
 .byt >bgfxTrackWS
 .byt >bgfxTrackNW
 .byt >bgfxTrackNE
 .byt >bgfxTrackSE
 .byt >bgfxScrubland2
 .byt >bgfxScrubShrubs
 .byt >bgfxScrub2Beach
 .byt >bgfxScrubPond
 .byt >bgfxBeach2Water
 .byt >bgfxLonghouseL
 .byt >bgfxLonghouseR
 .byt >bgfxHillN
 .byt >bgfxHillS
 .byt >bgfxHillSCornerR
 .byt >bgfxHillE
 .byt >bgfxHillNCornerR
 .byt >bgfxHillTop1
 .byt >bgfxHillTopCrater
 .byt >bgfxHillTopPond
 .byt >bgfxHillSCornerL
 .byt >bgfxHillW
 .byt >bgfxHillNCornerL
 .byt >bgfxHillTop2
 .byt >bgfxHilltopNissan
 .byt >bgfxCrater
 .byt >bgfxScrubWaterOutsideEdgeTL
 .byt >bgfxIslandShutteredGunpost
 .byt >bgfxRunwayBarrier
