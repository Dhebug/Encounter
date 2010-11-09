;The Corridor lift section comprises a main table 13x8

;O|O|O|O|O|O|O
;O|O|O|O|O|O|O
;O|O|O|O|O|O|O
;O|O|O|O|O|O|O
;O|O|O|O|O|O|O
;O|O|O|O|O|O|O
;O|O|O|O|O|O|O
;O|O|O|O|O|O|O

;This table describes the Rooms, Exits(Corridors) and lift shafts and is referred to by the Lift shaft plotting
;routine, the room glow cursor routine, the Room map plot routine and the Room plot routine

;For Rooms
;B0-5 RoomID or Earth
; 0    No Room(Earth)
; 1-32 RoomID
;B6   Room Flag(1)
;B7   Room Plundered(Discovered) Flag

;For LiftShafts
;B0-5 Exits(can be calculated from adjacent rooms)
; 0 No Exit
; 1 TL Exit only
; 2 TR Exit Only
; 3 BL Exit Only
; 4 BR Exit Only
; 5 TL/TR Exits
; 6 BL/BR Exits
; 7 TL/BR Exits
; 8 BL/TR Exits
;B6   Room Flag(0)
;B7   Shaft Plundered(Discovered) Flag

