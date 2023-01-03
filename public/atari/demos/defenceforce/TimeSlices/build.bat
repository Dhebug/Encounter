::
:: http://sun.hasenbraten.de/vasm/index.php?view=tutorial
:: http://sun.hasenbraten.de/vasm/release/vasm.html
::
del temporary.prg
vasm.exe -m68000 -Ftos -noesc -no-opt -o temporary.prg timslces.s

del Final\timslces.prg
upx-3.03 --ultra-brute temporary.prg -o Final\timslces.prg
del temporary.prg

pause
