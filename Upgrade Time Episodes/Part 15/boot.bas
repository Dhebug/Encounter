  05 MOVE#BB80,#BB80+1,#BB82:REM Ugly way to force the system to load the BANK 1 (Temporary hack)
  10 CLS:TEXT:CLS
  15 LOAD"FONT.BIN",A #B400+8*32:Z$=CHR$(27)
  20 POKE#BB80+35,0:PRINT CHR$(17):Z$=CHR$(27)
  30 PRINT@15,11;Z$;"N";Z$;"CLOADING"
  40 PRINT@15,12;Z$;"N";Z$;"ALOADING"
  50 REM GET K$
  60 LOAD"DEMO"
