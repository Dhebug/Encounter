# Microsoft Developer Studio Project File - Name="osdk" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=osdk - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "osdk.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "osdk.mak" CFG="osdk - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "osdk - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "osdk - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName "osdk"
# PROP Scc_LocalPath "."
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "osdk - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Build\Release"
# PROP Intermediate_Dir "Build\Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x40c /d "NDEBUG"
# ADD RSC /l 0x40c /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386 /out:"..\Osdk\_final_\Bin\osdk.exe"

!ELSEIF  "$(CFG)" == "osdk - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Build\Debug"
# PROP Intermediate_Dir "Build\Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE RSC /l 0x40c /d "_DEBUG"
# ADD RSC /l 0x40c /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /out:"osdk_debug.exe" /pdbtype:sept

!ENDIF 

# Begin Target

# Name "osdk - Win32 Release"
# Name "osdk - Win32 Debug"
# Begin Group "lib"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\_final_\lib\clock.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\ctype.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\div.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\free.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\ggeneral.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\gotoxy.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\gpchar.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\graphics.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\grsimple.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\header.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\irq.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\istring.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\itoa.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\library.ndx
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\lprintf.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\malloc.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\math.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\MEMCCPY.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\memcpy.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\memset.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\mult.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\oric.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\osdkdiv6.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\osdkmod6.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\printf.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\rand.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\random.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\realloc.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\scanf.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\SEDORIC.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\sound.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\sscanf.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRCAT.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRCHR.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRCMP.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRCMPI.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRCPY.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRCSPN.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRDUP.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRLEN.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRLWR.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRNCAT.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRNCMP.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRNCMPI.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRNCPY.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRNSET.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRPBRK.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRRCHR.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRREV.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRSET.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRSPN.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRSTR.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRTOK.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\STRUPR.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\tail.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\tape.s
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\TSTRING.S
# End Source File
# Begin Source File

SOURCE=.\_final_\lib\unpack.s
# End Source File
# End Group
# Begin Group "include"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Group "old"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\_final_\include\OLD\ORIC.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\OLD\STDLIB.H
# End Source File
# End Group
# Begin Group "sys"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\_final_\include\SYS\GRAPHICS.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\SYS\ORIC.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\SYS\SOUND.H
# End Source File
# End Group
# Begin Source File

SOURCE=.\_final_\include\6502.h
# End Source File
# Begin Source File

SOURCE=.\_final_\include\ALLOC.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\conio.h
# End Source File
# Begin Source File

SOURCE=.\_final_\include\CTYPE.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\LIB.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\MATH.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\ORIC.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\rs232.h
# End Source File
# Begin Source File

SOURCE=.\_final_\include\STDIO.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\STDLIB.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\STRING.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\STRINGS.H
# End Source File
# Begin Source File

SOURCE=.\_final_\include\time.h
# End Source File
# End Group
# Begin Group "documentation"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Group "pics"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\_final_\documentation\pics\buffy.jpg
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\buffy_0_0.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\buffy_0_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\buffy_0_2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\buffy_0_3.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\buffy_2_0.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\buffy_2_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\buffy_2_2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\buffy_2_3.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\euphoric_boot.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\euphoric_debugging.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\euphoric_menu.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\lena.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\lena_0_0.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\lena_0_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\lena_0_2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\lena_0_3.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\lena_2_0.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\lena_2_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\lena_2_2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\lena_2_3.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\logo_dosbox.png
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\logo_winehq.png
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\mire2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\mire2_0_0.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\mire2_0_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\mire2_0_2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\mire2_0_3.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\mire2_2_0.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\mire2_2_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\mire2_2_2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\mire2_2_3.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\moxica1.jpg
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\moxica1_0_0.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\moxica1_0_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\moxica1_0_2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\moxica1_0_3.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\moxica1_2_0.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\moxica1_2_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\moxica1_2_2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\moxica1_2_3.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\osdk_logo_large.png
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\osdk_logo_small.png
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\system_properties_windows2000.png
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\system_properties_windowsxp.png
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\visualstudio_new_project.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\visualstudio_project_settings_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\visualstudio_project_settings_2.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\visualstudio_setup_1.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\pics\visualstudio_setup_2.gif
# End Source File
# End Group
# Begin Source File

SOURCE=.\_final_\documentation\arrow_back.gif
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_6502_instruction.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_assembler.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_bas2tap.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_BASIC_instruction.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_bin2txt.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_compiler.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_copyright.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_creating_project.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_debugger.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_euphoric.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_filepack.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_glossary.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_header.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_historic.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_installation.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_issues.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_library.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_linker.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_memmap.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_memorymap.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_pictconv.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_presentation.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_samples.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_tap2wav.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_ultraedit.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_visualstudio.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_writedsk.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\doc_zeropage.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\documentation.css
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\documentation.htm
# End Source File
# Begin Source File

SOURCE=.\_final_\documentation\euphoric_menu.gif
# End Source File
# End Group
# Begin Group "extra"

# PROP Default_Filter ""
# Begin Group "UltraEdit"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\_final_\extra\UltraEdit\WORDFILE.TXT
# End Source File
# End Group
# Begin Group "VisualC++6"

# PROP Default_Filter ""
# Begin Group "OsdkSampleProject"

# PROP Default_Filter ""
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\OsdkSampleProject\display.h"

!IF  "$(CFG)" == "osdk - Win32 Release"

# PROP Exclude_From_Build 1

!ELSEIF  "$(CFG)" == "osdk - Win32 Debug"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\OsdkSampleProject\display.s"

!IF  "$(CFG)" == "osdk - Win32 Release"

# PROP Exclude_From_Build 1

!ELSEIF  "$(CFG)" == "osdk - Win32 Debug"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\OsdkSampleProject\documentation.txt"

!IF  "$(CFG)" == "osdk - Win32 Release"

# PROP Exclude_From_Build 1

!ELSEIF  "$(CFG)" == "osdk - Win32 Debug"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\OsdkSampleProject\Main.c"

!IF  "$(CFG)" == "osdk - Win32 Release"

# PROP Exclude_From_Build 1

!ELSEIF  "$(CFG)" == "osdk - Win32 Debug"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\OsdkSampleProject\osdk_build.bat"

!IF  "$(CFG)" == "osdk - Win32 Release"

# PROP Exclude_From_Build 1

!ELSEIF  "$(CFG)" == "osdk - Win32 Debug"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\OsdkSampleProject\osdk_config.bat"

!IF  "$(CFG)" == "osdk - Win32 Release"

# PROP Exclude_From_Build 1

!ELSEIF  "$(CFG)" == "osdk - Win32 Debug"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\OsdkSampleProject\osdk_execute.bat"

!IF  "$(CFG)" == "osdk - Win32 Release"

# PROP Exclude_From_Build 1

!ELSEIF  "$(CFG)" == "osdk - Win32 Debug"

!ENDIF 

# End Source File
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\OsdkSampleProject\OsdkSampleProject.dsp"

!IF  "$(CFG)" == "osdk - Win32 Release"

# PROP Exclude_From_Build 1

!ELSEIF  "$(CFG)" == "osdk - Win32 Debug"

!ENDIF 

# End Source File
# End Group
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\language.reg"
# End Source File
# Begin Source File

SOURCE=".\_final_\extra\VisualC++6\usertype.dat"
# End Source File
# End Group
# Begin Group "CrimsonEditor"

# PROP Default_Filter ""
# End Group
# End Group
# Begin Group "bin"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\_final_\Bin\make.bat
# End Source File
# Begin Source File

SOURCE=.\_final_\Bin\vc_execute.bat
# End Source File
# Begin Source File

SOURCE=.\_final_\Bin\vc_make.bat
# End Source File
# End Group
# Begin Group "macro"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\_final_\macro\MACROS.H
# End Source File
# End Group
# End Target
# End Project
