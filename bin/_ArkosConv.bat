::ECHO ON
:: Should be called with the name of the file to convert and the target name
::
:: Example:
:: CALL _ArkosConv music_jingle splash_music
:: Note, can add --exportPlayerConfig to get the config files
IF "%3"=="" GOTO SourceExport

:BinaryExport
SET TargetFile=%TARGET%\%2%TARGET_EXTENSION%
bin\SongToAky -bin -adr %EXPORT_ADDRESS% data\%1.aks %TargetFile%

CALL :FileSize %TargetFile% 
IF %FileSize% LEQ %3% GOTO End
ECHO %ESC%[41m %2%TARGET_EXTENSION% is %FileSize% bytes long, larger than %3 bytes%ESC%[0m
GOTO End

:SourceExport
bin\SongToAky --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\%1.aks code\%2.s
GOTO End


:FileSize
SET FileSize=%~z1
GOTO End


:End
