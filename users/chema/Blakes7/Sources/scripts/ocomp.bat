@ECHO OFF
setlocal enabledelayedexpansion
for %%f in (*.os) do (
	echo Compiling file %%f
	%OSDK%\bin\cpp -P %%f tmp
	OASISCompiler.exe < tmp > %%~nf.s
	if !errorlevel! neq 0 exit /b !errorlevel!
	del tmp
)

