# Microsoft Developer Studio Project File - Name="cockpit" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=cockpit - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "tine.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "tine.mak" CFG="cockpit - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "cockpit - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "cockpit - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "cockpit - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0xc0a /d "NDEBUG"
# ADD RSC /l 0xc0a /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386

!ELSEIF  "$(CFG)" == "cockpit - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE RSC /l 0xc0a /d "_DEBUG"
# ADD RSC /l 0xc0a /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# Begin Custom Build
InputPath=.\Debug\tine.exe
SOURCE="$(InputPath)"

"tine.exe" : $(SOURCE) "$(INTDIR)" "$(OUTDIR)"
	osdk_build.bat

# End Custom Build

!ENDIF 

# Begin Target

# Name "cockpit - Win32 Release"
# Name "cockpit - Win32 Debug"
# Begin Group "configuration"

# PROP Default_Filter "bat"
# Begin Source File

SOURCE=.\osdk_build.bat
# End Source File
# Begin Source File

SOURCE=.\osdk_config.bat
# End Source File
# Begin Source File

SOURCE=.\osdk_execute.bat
# End Source File
# Begin Source File

SOURCE=.\osdk_showmap.bat
# End Source File
# Begin Source File

SOURCE=.\txtcomp.bat
# End Source File
# End Group
# Begin Group "includes"

# PROP Default_Filter "*.h"
# Begin Source File

SOURCE=.\cockpit.h
# End Source File
# Begin Source File

SOURCE=.\main.h
# End Source File
# Begin Source File

SOURCE=.\ships.h
# End Source File
# Begin Source File

SOURCE=.\tine.h
# End Source File
# End Group
# Begin Group "oobj3d"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\oobj3d\circle.s
# End Source File
# Begin Source File

SOURCE=.\oobj3d\clip.s
# End Source File
# Begin Source File

SOURCE=.\oobj3d\filler.s
# End Source File
# Begin Source File

SOURCE=.\oobj3d\lib3d.s
# End Source File
# Begin Source File

SOURCE=.\oobj3d\lib3dtab.s
# End Source File
# Begin Source File

SOURCE=.\oobj3d\LineDraw.s
# End Source File
# Begin Source File

SOURCE=.\oobj3d\mextra.s
# End Source File
# Begin Source File

SOURCE=.\oobj3d\obj3d.h
# End Source File
# Begin Source File

SOURCE=.\oobj3d\obj3d.s
# End Source File
# Begin Source File

SOURCE=.\oobj3d\params.h
# End Source File
# End Group
# Begin Group "notes"

# PROP Default_Filter "*.txt"
# Begin Source File

SOURCE=.\todolist.txt
# End Source File
# End Group
# Begin Group "missions"

# PROP Default_Filter "*.s"
# Begin Source File

SOURCE=.\missions\mission0.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission1.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission10.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission11.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission2.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission3.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission4.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission5.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission6.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission7.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission8.s
# End Source File
# Begin Source File

SOURCE=.\missions\mission9.s
# End Source File
# Begin Source File

SOURCE=.\missions\tutorial0.s
# End Source File
# Begin Source File

SOURCE=.\missions\tutorial1.s
# End Source File
# Begin Source File

SOURCE=.\missions\tutorial2.s
# End Source File
# Begin Source File

SOURCE=.\missions\tutorial3.s
# End Source File
# End Group
# Begin Source File

SOURCE=.\cockpit.s
# End Source File
# Begin Source File

SOURCE=.\data.s
# End Source File
# Begin Source File

SOURCE=.\dict.s
# End Source File
# Begin Source File

SOURCE=.\dictc.s
# End Source File
# Begin Source File

SOURCE=.\disk.s
# End Source File
# Begin Source File

SOURCE=.\galaxy.s
# End Source File
# Begin Source File

SOURCE=.\grammar.s
# End Source File
# Begin Source File

SOURCE=.\graphics.s
# End Source File
# Begin Source File

SOURCE=.\keyboard.s
# End Source File
# Begin Source File

SOURCE=.\main.s
# End Source File
# Begin Source File

SOURCE=.\missions.s
# End Source File
# Begin Source File

SOURCE=.\models.s
# End Source File
# Begin Source File

SOURCE=.\music.s
# End Source File
# Begin Source File

SOURCE=.\oobj3d\overlay.s
# End Source File
# Begin Source File

SOURCE=.\radar.s
# End Source File
# Begin Source File

SOURCE=.\random.s
# End Source File
# Begin Source File

SOURCE=.\ships.s
# End Source File
# Begin Source File

SOURCE=.\sound.s
# End Source File
# Begin Source File

SOURCE=.\stars.s
# End Source File
# Begin Source File

SOURCE=.\tactics.s
# End Source File
# Begin Source File

SOURCE=.\tail.s
# End Source File
# Begin Source File

SOURCE=.\text.s
# End Source File
# Begin Source File

SOURCE=.\tinefuncs.s
# End Source File
# Begin Source File

SOURCE=.\tineinc.s
# End Source File
# Begin Source File

SOURCE=.\tineloop.s
# End Source File
# Begin Source File

SOURCE=.\universe.s
# End Source File
# End Target
# End Project
