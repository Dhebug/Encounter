:: Should be called with the name of the file to convert and the target name
::
:: Example:
:: CALL _ArkosConv music_jingle splash_music
bin\SongToAky --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\%1.aks code\%2.s
bin\SongToEvents --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\%1.aks code\%2_events.s

