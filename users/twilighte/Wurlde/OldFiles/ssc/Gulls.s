;Gulls.s
;Gulls must..
; Fly at varying distances, soaring, swooping, landing on jetty wall, taking off, diving behind wall

;If gull is low enough but at distance - dive behind jetty (to get fish), rise with catch
;If gull is low enough but close - land, woddle, brood, sleep, takeoff
;If gull is high enough - soar, swoop, drift, fly away, fly towards

;All gulls will be masked against bg so they will always fly behind jetty, watch-tower and kissing widow.

;Gulls will be used in SSCM-OM1S4, SSCM-OM1S5 and perhaps SSCM-OM1S6 (depending on screen behaviour)

InitialiseGulls

RunGulls
	ldx #15
.(
loop1	ldy GullActivity,x
	bmi InactiveGull
	lda GullActivityCodeVectorLo,y
	sta vector1+1
	lda GullActivityCodeVectorHi,y
	sta vector1+2
vector1	jsr $dead
	dex
	bpl loop1
.)
	rts


gaDive
gaRise
gaLand
gaWoddleLeft
gaWoddleRight
gaBrood
gaSleep
gaTakeoff
gaSoar
gaSwoop
gaDrift
ga
