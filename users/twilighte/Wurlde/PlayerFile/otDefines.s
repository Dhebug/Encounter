;otDefines.s - Object Definitions

;A0-2 MapID(0-5)
;A3-7 XPOS (4-35)
;B0-2 ScreenID(0-7)
;B3-7 ObjectID(0-30)

#define	oMap0		0
#define	oMap1		1
#define	oMap2		2
#define	oMap3		3
#define	oMap4		4
#define	oMap5		5

#define	oXPOS4		0
#define	oXPOS5		1
#define	oXPOS6		2
#define	oXPOS7		3
#define	oXPOS8		4
#define	oXPOS9		5
#define	oXPOS10		6
#define	oXPOS11		7
#define	oXPOS12		8
#define	oXPOS13		9
#define	oXPOS14		10
#define	oXPOS15		11
#define	oXPOS16		12
#define	oXPOS17		13
#define	oXPOS18		14
#define	oXPOS19		15
#define	oXPOS20		16
#define	oXPOS21		17
#define	oXPOS22		18
#define	oXPOS23		19
#define	oXPOS24		20
#define	oXPOS25		21
#define	oXPOS26		22
#define	oXPOS27		23
#define	oXPOS28		24
#define	oXPOS29		25
#define	oXPOS30		26
#define	oXPOS31		27
#define	oXPOS32		28
#define	oXPOS33		29
#define	oXPOS34		30
#define	oXPOS35		31

#define	oScreenID0	0
#define	oScreenID1	1
#define	oScreenID2	2
#define	oScreenID3	3
#define	oScreenID4	4
#define	oScreenID5	5
#define	oScreenID6	6
#define	oScreenID7	7

#define	oObjectID0	8*0
#define	oObjectID1	8*1
#define	oObjectID2	8*2
#define	oObjectID3	8*3
#define	oObjectID4	8*4
#define	oObjectID5	8*5
#define	oObjectID6	8*6
#define	oObjectID7	8*7
#define	oObjectID8	8*8
#define	oObjectID9	8*9
#define	oObjectID10	8*10
#define	oObjectID11	8*11
#define	oObjectID12	8*12
#define	oObjectID13	8*13
#define	oObjectID14	8*14
#define	oObjectID15	8*15
#define	oObjectID16	8*16
#define	oObjectID17	8*17
#define	oObjectID18	8*18
#define	oObjectID19	8*19
#define	oObjectID20	8*20
#define	oObjectID21	8*21
#define	oObjectID22	8*22
#define	oObjectID23	8*23
#define	oObjectID24	8*24
#define	oObjectID25	8*25
#define	oObjectID26	8*26
#define	oObjectID27	8*27
#define	oObjectID28	8*28
#define	oObjectID29	8*29
#define	oObjectID30	8*30
#define	oObjectID31	8*31

#define	oInfiniteSupply	64
;A3-7 CreatureID(0-31)
;B0 Owned by Creature(0) or Held for Hero(1)
;B1 Shown(0) or Hidden(1)
;B2 Normally Shown(0) Normally Hidden(1)
;B3-7 ObjectID

;A0-2 Held by Creature(6)
#define	oCreatureHeld	10

;A0-2 Held by Hero(7)
#define	oHeroHeld		11

;A3-7 CreatureID of lender
#define	oCreatureID0	0
#define	oCreatureID1	1
#define	oCreatureID2	2
#define	oCreatureID3	3
#define	oCreatureID4	4
#define	oCreatureID5	5
#define	oCreatureID6	6
#define	oCreatureID7	7
#define	oCreatureID8	8
#define	oCreatureID9	9
#define	oCreatureID10	10
#define	oCreatureID11	11
#define	oCreatureID12	12
#define	oCreatureID13	13
#define	oCreatureID14	14
#define	oCreatureID15	15
#define	oCreatureID16	16
#define	oCreatureID17	17
#define	oCreatureID18	18
#define	oCreatureID19	19
#define	oCreatureID20	20
#define	oCreatureID21	21
#define	oCreatureID22	22
#define	oCreatureID23	23
#define	oCreatureID24	24
#define	oCreatureID25	25
#define	oCreatureID26	26
#define	oCreatureID27	27
#define	oCreatureID28	28
#define	oCreatureID29	29
#define	oCreatureID30	30
#define	oCreatureID31	31

;B0 Owned by Hero or Character(0) or Held for Creature or Hero(1)
#define	oOwned		0
#define	oHeld		1

;B1 Shown(0) or Hidden(1) (Do not reveal to characters)
#define	oShown		0
#define	oHidden		2

;B2 Normally Shown(0) Normally Hidden(1)
#define	oNormallyShown	0
#define	oNormallyHidden	4

