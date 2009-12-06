set OLDDIR=%CD%
call osdk_build
if ERRORLEVEL 1 goto end
call osdk_execute
cd %OLDDIR%

:end
