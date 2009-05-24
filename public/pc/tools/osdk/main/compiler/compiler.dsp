# Microsoft Developer Studio Project File - Name="compiler" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=compiler - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "compiler.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "compiler.mak" CFG="compiler - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "compiler - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "compiler - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName "compiler"
# PROP Scc_LocalPath "."
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "compiler - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "build\Release"
# PROP Intermediate_Dir "build\Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /I "includes" /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x40c /d "NDEBUG"
# ADD RSC /l 0x40c /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386 /out:"..\Osdk\_final_\Bin\Compiler.exe"

!ELSEIF  "$(CFG)" == "compiler - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "build\Debug"
# PROP Intermediate_Dir "build\Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /I "includes" /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE RSC /l 0x40c /d "_DEBUG"
# ADD RSC /l 0x40c /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /out:"compiler_debug.exe" /pdbtype:sept

!ENDIF 

# Begin Target

# Name "compiler - Win32 Release"
# Name "compiler - Win32 Debug"
# Begin Group "sources"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\sources\dag.c
# End Source File
# Begin Source File

SOURCE=.\sources\debug.c
# End Source File
# Begin Source File

SOURCE=.\sources\decl.c
# End Source File
# Begin Source File

SOURCE=.\sources\enode.c
# End Source File
# Begin Source File

SOURCE=.\sources\error.c
# End Source File
# Begin Source File

SOURCE=.\sources\expr.c
# End Source File
# Begin Source File

SOURCE=.\sources\gen.c
# End Source File
# Begin Source File

SOURCE=.\sources\init.c
# End Source File
# Begin Source File

SOURCE=.\sources\input.c
# End Source File
# Begin Source File

SOURCE=.\sources\lex.c
# End Source File
# Begin Source File

SOURCE=.\sources\main.c
# End Source File
# Begin Source File

SOURCE=.\sources\output.c
# End Source File
# Begin Source File

SOURCE=.\sources\profio.c
# End Source File
# Begin Source File

SOURCE=.\sources\simp.c
# End Source File
# Begin Source File

SOURCE=.\sources\stmt.c
# End Source File
# Begin Source File

SOURCE=.\sources\string.c
# End Source File
# Begin Source File

SOURCE=.\sources\sym.c
# End Source File
# Begin Source File

SOURCE=.\sources\tree.c
# End Source File
# Begin Source File

SOURCE=.\sources\types.c
# End Source File
# End Group
# Begin Group "includes"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\includes\c.h
# End Source File
# Begin Source File

SOURCE=.\includes\config.h
# End Source File
# Begin Source File

SOURCE=.\includes\keywords.h
# End Source File
# Begin Source File

SOURCE=.\includes\ops.h
# End Source File
# Begin Source File

SOURCE=.\includes\token.h
# End Source File
# Begin Source File

SOURCE=.\includes\version.h
# End Source File
# End Group
# Begin Group "data"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\data\icones.rc
# End Source File
# Begin Source File

SOURCE=.\data\normal.ico
# End Source File
# End Group
# End Target
# End Project
