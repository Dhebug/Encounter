# Microsoft Developer Studio Project File - Name="OsdkSampleProject" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) External Target" 0x0106

CFG=OsdkSampleProject - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "OsdkSampleProject.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "OsdkSampleProject.mak" CFG="OsdkSampleProject - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "OsdkSampleProject - Win32 Release" (based on "Win32 (x86) External Target")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Build"
# PROP BASE Intermediate_Dir "Build"
# PROP BASE Cmd_Line "NMAKE /f OsdkSampleProject.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "OsdkSampleProject.exe"
# PROP BASE Bsc_Name "OsdkSampleProject.bsc"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Build"
# PROP Intermediate_Dir "Build"
# PROP Cmd_Line "%OSDK%\bin\vc_make.bat"
# PROP Rebuild_Opt "/a"
# PROP Target_File "OsdkSampleProject.exe"
# PROP Bsc_Name ""
# PROP Target_Dir ""
# Begin Target

# Name "OsdkSampleProject - Win32 Release"

!IF  "$(CFG)" == "OsdkSampleProject - Win32 Release"

!ENDIF 

# Begin Group "Sources"

# PROP Default_Filter "c;s;h"
# Begin Source File

SOURCE=.\display.h
# End Source File
# Begin Source File

SOURCE=.\display.s
# End Source File
# Begin Source File

SOURCE=.\Main.c
# End Source File
# End Group
# Begin Group "Config"

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
# End Group
# Begin Group "Documentation"

# PROP Default_Filter "txt"
# Begin Source File

SOURCE=.\documentation.txt
# End Source File
# End Group
# End Target
# End Project
