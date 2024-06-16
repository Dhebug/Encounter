:: Should be called with the name of the file to convert
::
:: Example:
:: CALL _PictConv view_donkey_kong_top
::
:: Expects the following variables to be set up:
:: PICTCONV
:: PARAMS
:: TARGET
:: TARGET_EXTENSION

::ECHO ON
%PICTCONV% %PARAMS% data\%1.png %TARGET%\%1%TARGET_EXTENSION%
::ECHO OFF

