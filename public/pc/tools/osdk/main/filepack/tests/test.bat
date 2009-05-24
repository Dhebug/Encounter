::@ECHO OFF
ECHO Packing data
CALL CONVERT_ONE.BAT buffy
CALL CONVERT_ONE.BAT troll
CALL CONVERT_ONE.BAT kaniving
CALL CONVERT_ONE.BAT oric_only
CALL CONVERT_ONE.BAT blueface
CALL CONVERT_ONE.BAT supertomato

CALL CONVERT_ONE.BAT fight_1
CALL CONVERT_ONE.BAT fight_2
CALL CONVERT_ONE.BAT fight_3
CALL CONVERT_ONE.BAT fight_4
CALL CONVERT_ONE.BAT fight_5



Pause

::FilePack -p "kaniving.tap" "buffy_pack.tap"
::FilePack -p "troll3.img" "buffy_pack.tap"
::FilePack -p "buffy_8000.tap" "buffy_pack.tap"
::FilePack -u "buffy_pack.tap" "buffy_unpack.tap" 
::c:\tools\bin2txt.exe -s1 -f2 "buffy_pack.tap" "buffy_pack.s" picture
::pause