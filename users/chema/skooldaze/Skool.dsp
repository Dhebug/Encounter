# Microsoft Developer Studio Project File - Name="Skool" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) External Target" 0x0106

CFG=Skool - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "Skool.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "Skool.mak" CFG="Skool - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "Skool - Win32 Release" (based on "Win32 (x86) External Target")
!MESSAGE "Skool - Win32 Debug" (based on "Win32 (x86) External Target")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""

!IF  "$(CFG)" == "Skool - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Cmd_Line "NMAKE /f Skool.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "Skool.exe"
# PROP BASE Bsc_Name "Skool.bsc"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Cmd_Line "%OSDK%\bin\vc_make.bat"
# PROP Rebuild_Opt "/a"
# PROP Target_File "Skool.exe"
# PROP Bsc_Name ""
# PROP Target_Dir ""

!ELSEIF  "$(CFG)" == "Skool - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Cmd_Line "NMAKE /f Skool.mak"
# PROP BASE Rebuild_Opt "/a"
# PROP BASE Target_File "Skool.exe"
# PROP BASE Bsc_Name "Skool.bsc"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Cmd_Line "%OSDK%\bin\vc_make.bat"
# PROP Rebuild_Opt "/a"
# PROP Target_File "Skool.exe"
# PROP Bsc_Name ""
# PROP Target_Dir ""

!ENDIF 

# Begin Target

# Name "Skool - Win32 Release"
# Name "Skool - Win32 Debug"

!IF  "$(CFG)" == "Skool - Win32 Release"

!ELSEIF  "$(CFG)" == "Skool - Win32 Debug"

!ENDIF 

# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\auxiliar.s
# End Source File
# Begin Source File

SOURCE=.\charset.s
# End Source File
# Begin Source File

SOURCE=.\common.s
# End Source File
# Begin Source File

SOURCE=.\data.s
# End Source File
# Begin Source File

SOURCE=.\engine.s
# End Source File
# Begin Source File

SOURCE=.\eric.s
# End Source File
# Begin Source File

SOURCE=.\graphics.s
# End Source File
# Begin Source File

SOURCE=.\init.s
# End Source File
# Begin Source File

SOURCE=.\keyboard.s
# End Source File
# Begin Source File

SOURCE=.\script.s
# End Source File
# Begin Source File

SOURCE=.\text.s
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\params.h
# End Source File
# Begin Source File

SOURCE=.\script.h
# End Source File
# Begin Source File

SOURCE=.\text.h
# End Source File
# Begin Source File

SOURCE=.\todo.txt
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group
# Begin Group "Configuration Files"

# PROP Default_Filter "*.bat"
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
# End Target
# End Project
