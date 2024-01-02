  
   0 POKE#26A,10:POKE#BB80+36,0     ' No blinking cursor, no CAPS logo
  15 LOAD"FONT.BIN",A #B400+8*32    ' Load the new font
  30 PRINT@15,11;"~N~CLOADING"
  40 PRINT@15,12;"~N~ALOADING"
  50 ' GET K$
  60 LOAD"DEMO"

