;SSCM-OM1S0 - Red Castle near Sassubree
;SSCM Screen Specific Code Module
;O    Outside Map
;M1   Map 1
;S0   Screen 0

#include "SSCModuleHeader.s"
#include "ZeroPage.s"

 .text
*=$C000

'**************************
ScreenSpecificCodeBlock
        jmp ScreenInit
        jmp ScreenRun
        jmp CollisionDetection
ScreenProseVector
 .byt <ScreenProse,>ScreenProse
ScreenNameVector
 .byt <ScreenName,>ScreenName
ScreenRules
 .byt %00000000
Spare
 .dsb 2,0
'**************************
ScreenInlay
#include "M01S00.s"
ScreenProse
 .byt "Sasubree Castle lyes on the shore","s"+128
ScreenName
 .byt "A BIG CASTL","E"+128

ScreenInit
        rts
ScreenRun
        rts
CollisionDetection
        rts
