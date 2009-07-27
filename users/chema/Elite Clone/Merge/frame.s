;;;;;

; Now the game frame :)


freespace .dsb ($bf68-60*40)-*


_controls
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$73,$77,$7f,$7f,$7f,$7f,$7e,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$5f,$60,$44,$40
    .byt  $40,$40,$40,$40,$40,$53,$7b,$7d,$68,$44,$47,$7f,$7f,$7f,$7f,$7e
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$41,$60,$58,$44,$40,$40,$40,$40,$40,$40,$54,$42,$45
    .byt  $6f,$73,$67,$7f,$7f,$7f,$7f,$7e,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$42,$40,$44,$44,$40
    .byt  $40,$40,$40,$40,$40,$53,$73,$79,$68,$40,$57,$7f,$7f,$7f,$7f,$7e
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$44,$40,$42,$44,$40,$40,$40,$40,$40,$40,$50,$4a,$41
    .byt  $68,$47,$67,$7f,$7f,$7f,$7f,$7e,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$48,$40,$41,$44,$40
    .byt  $40,$40,$40,$40,$40,$57,$72,$41,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$50,$40,$40,$64,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$50,$40,$40,$67,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$60,$40,$40,$54,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$43,$77,$7f,$7f,$40,$40,$40,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$45,$55,$55,$55,$50,$40,$40,$40,$40,$40,$60,$40,$40,$54,$40
    .byt  $40,$41,$60,$40,$40,$57,$7a,$41,$68,$64,$47,$7f,$7f,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$40,$40,$45,$50,$40,$40,$40,$45,$50,$40
    .byt  $40,$40,$40,$60,$40,$40,$54,$40,$40,$41,$60,$40,$40,$54,$4a,$41
    .byt  $6f,$63,$67,$7f,$7f,$40,$40,$40,$40,$50,$40,$40,$40,$40,$40,$45
    .byt  $70,$40,$40,$40,$40,$40,$46,$60,$40,$40,$40,$60,$40,$40,$54,$40
    .byt  $40,$41,$60,$40,$40,$57,$72,$41,$68,$60,$57,$7f,$7f,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$43,$70,$68,$40,$40,$40,$40,$40,$54,$4f
    .byt  $40,$40,$40,$60,$40,$40,$54,$40,$40,$41,$60,$40,$40,$54,$52,$41
    .byt  $68,$67,$67,$7f,$7f,$40,$40,$40,$40,$50,$40,$40,$40,$40,$78,$40
    .byt  $44,$40,$40,$40,$40,$40,$60,$40,$5c,$40,$40,$60,$40,$40,$54,$40
    .byt  $40,$41,$60,$40,$40,$54,$4b,$7d,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$46,$40,$42,$42,$40,$40,$40,$40,$41,$41,$40
    .byt  $41,$60,$40,$50,$40,$40,$64,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40,$40,$70,$40,$40
    .byt  $41,$40,$40,$40,$40,$42,$40,$40,$40,$4c,$40,$50,$40,$40,$67,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$42,$40,$40,$48,$40,$60,$40,$40,$40,$44,$40,$50
    .byt  $40,$41,$40,$48,$40,$41,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$74,$57,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$48,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$48,$40,$40,$40,$40,$50,$44,$40,$42,$44,$40
    .byt  $46,$40,$40,$40,$40,$57,$63,$7d,$68,$44,$57,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$50,$40,$40,$60,$40,$40,$60,$40,$48,$40,$40,$40,$50,$40,$44
    .byt  $40,$40,$44,$42,$40,$44,$44,$40,$46,$40,$40,$40,$40,$54,$52,$41
    .byt  $6f,$74,$57,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$42,$48,$62,$48,$44
    .byt  $51,$44,$40,$40,$40,$62,$48,$60,$51,$44,$51,$41,$60,$58,$44,$40
    .byt  $46,$40,$40,$40,$40,$54,$4a,$41,$68,$44,$57,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$50,$40,$48,$40,$40,$42,$40,$40,$42,$40,$40,$41,$40,$40,$41
    .byt  $40,$40,$40,$50,$5f,$60,$44,$40,$46,$40,$40,$40,$40,$54,$4a,$41
    .byt  $68,$47,$77,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$41,$40,$40,$42,$40,$40,$40,$40,$40,$40,$40,$40,$40,$44,$40
    .byt  $46,$40,$40,$40,$40,$57,$7b,$7d,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$60,$40,$40,$48,$40,$40,$40,$60,$40,$44,$40,$40,$40
    .byt  $50,$40,$40,$44,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$50,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$42,$40,$40,$40,$60,$40,$40,$40,$48,$40,$50,$40,$40,$40
    .byt  $44,$40,$40,$41,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$77,$77,$60,$40,$40,$40,$40,$40,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$44,$40,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$70,$50,$4e,$41,$68,$41,$47,$60,$40,$40,$40,$40
    .byt  $40,$50,$44,$40,$40,$42,$40,$40,$40,$40,$42,$41,$40,$40,$40,$40
    .byt  $41,$40,$40,$40,$60,$40,$47,$7f,$7f,$7f,$7f,$7f,$70,$50,$46,$41
    .byt  $68,$41,$47,$60,$40,$40,$40,$40,$40,$50,$48,$40,$40,$40,$40,$40
    .byt  $40,$40,$41,$42,$40,$40,$40,$40,$40,$40,$40,$40,$50,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$70,$50,$46,$41,$68,$41,$47,$60,$40,$40,$40,$40
    .byt  $40,$50,$48,$40,$40,$48,$40,$40,$40,$40,$40,$64,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$50,$40,$47,$7f,$7f,$7f,$7f,$7f,$70,$50,$46,$41
    .byt  $6f,$71,$47,$60,$40,$40,$40,$40,$40,$50,$4c,$51,$44,$41,$44,$51
    .byt  $44,$51,$44,$58,$62,$48,$62,$48,$62,$41,$44,$51,$50,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$70,$50,$5f,$61,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$48,$40,$40,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$44,$40,$40,$50,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$48,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$50,$40,$40,$40,$40,$40,$40,$40,$40,$50,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$44,$40,$42,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$41,$40,$40,$60,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $68,$47,$74,$40,$40,$40,$40,$40,$40,$50,$44,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$60,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$68,$41,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$42,$40,$48,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$50,$41,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$41,$61
    .byt  $68,$41,$44,$40,$40,$40,$40,$40,$40,$50,$41,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$50,$40,$40,$40,$40,$40,$40,$40,$42,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$68,$41,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$60,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$44,$44,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$58,$41
    .byt  $6f,$61,$44,$40,$40,$40,$40,$40,$40,$50,$40,$50,$40,$40,$40,$40
    .byt  $40,$40,$40,$48,$40,$40,$40,$40,$40,$40,$40,$48,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$4a,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$41,$50,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$46,$62,$48,$62,$48
    .byt  $62,$48,$62,$51,$44,$51,$44,$51,$44,$51,$45,$60,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$41,$60,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$46,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6f,$44,$47,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$58,$40,$40,$40
    .byt  $40,$40,$40,$48,$40,$40,$40,$40,$40,$40,$58,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$68,$64,$47,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$50,$40,$40,$46,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$41,$60,$40,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$41,$61
    .byt  $6f,$64,$47,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$41,$60,$40,$40
    .byt  $40,$40,$40,$50,$40,$40,$40,$40,$40,$46,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$68,$64,$47,$7f,$7f,$7f,$7f,$7f
    .byt  $7f,$50,$40,$40,$40,$5c,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$78,$40,$40,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$41,$61
    .byt  $68,$67,$77,$7f,$7f,$7f,$7f,$7f,$7f,$50,$40,$40,$40,$43,$60,$40
    .byt  $40,$40,$40,$48,$40,$40,$40,$40,$47,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$5f,$61,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $40,$50,$40,$40,$40,$40,$5c,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $78,$40,$40,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$70,$40,$40,$40,$40,$43,$70
    .byt  $40,$40,$40,$50,$40,$40,$40,$4f,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$7f,$7f,$7f,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $60,$50,$40,$40,$40,$40,$40,$4f,$60,$40,$40,$40,$40,$40,$47,$70
    .byt  $40,$40,$40,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41
    .byt  $6c,$40,$44,$40,$40,$40,$40,$40,$60,$50,$40,$40,$40,$40,$40,$40
    .byt  $5f,$78,$40,$48,$40,$5f,$78,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$58,$41,$6b,$7f,$64,$40,$40,$40,$40,$40
    .byt  $60,$50,$40,$40,$40,$40,$40,$40,$40,$47,$7f,$7f,$7f,$60,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$59,$61
    .byt  $6f,$7f,$74,$40,$40,$40,$40,$40,$60,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$59,$61,$6b,$7f,$64,$40,$40,$40,$40,$40
    .byt  $60,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$47,$7f,$7f,$7f,$7f,$7f,$7f,$70,$5f,$61
    .byt  $6c,$40,$44,$40,$40,$40,$40,$40,$60,$50,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$47,$7f
    .byt  $7f,$7f,$7f,$7f,$7f,$70,$41,$61,$60,$40,$44,$40,$40,$40,$40,$40
    .byt  $60,$50,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40,$40
    .byt  $40,$40,$40,$40,$40,$40,$44,$40,$40,$40,$40,$40,$40,$50,$40,$41


textlines
*=$bf68
.dsb 120,$0

#echo **** Free space:
#print (_controls - freespace)
#echo
