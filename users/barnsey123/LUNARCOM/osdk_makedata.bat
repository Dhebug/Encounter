@ECHO OFF


:: For Main Program
::%OSDK%\bin\pictconv -m0 -f0 -d1 -o2 pics\MaskSmallOric2.png mask.hir
::%OSDK%\bin\FilePack -p mask.hir mask.pak
::%OSDK%\bin\Bin2Txt -s1 -f2 mask.pak mask.s _LabelPicture
:: Video Call (BlahBlah)

::%OSDK%\bin\pictconv -f0 -d1 -o4_LookRight VIDEO\look-right.png LookRight.s
::%OSDK%\bin\pictconv -f0 -d1 -o4_Tears VIDEO\tears.png Tears.s
::%OSDK%\bin\pictconv -f0 -d1 -o4_YouFuck VIDEO\youfuck.png YouFuck.s
::%OSDK%\bin\pictconv -f0 -d1 -o4_Whoops VIDEO\whoops.png Whoops.s
::%OSDK%\bin\pictconv -f0 -d1 -o4_NodYes VIDEO\yes.png NodYes.s
::%OSDK%\bin\pictconv -f0 -d1 -o4_LeanForward VIDEO\leanforward.png LeanForward.s
::%OSDK%\bin\pictconv -f0 -d1 -o4_Yabber VIDEO\yabber.png Yabber.s
::%OSDK%\bin\pictconv -f0 -d1 -o4_Disdain VIDEO\disdain.png Disdain.s
::%OSDK%\bin\pictconv -f0 -d1 -o4_CheckWatch VIDEO\checkwatch.png CheckWatch.s



%OSDK%\bin\pictconv -f0 -d1 -o2 VIDEO\look-right.png chunk.hir
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak LookRight.s _LookRight
%OSDK%\bin\pictconv -f0 -d1 -o2 VIDEO\tears.png chunk.hir
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak Tears.s _Tears
%OSDK%\bin\pictconv -f0 -d1 -o2 VIDEO\youfuck.png chunk.hir
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak YouFuck.s _YouFuck
%OSDK%\bin\pictconv -f0 -d1 -o2 VIDEO\whoops.png chunk.hir
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak Whoops.s _Whoops
%OSDK%\bin\pictconv -f0 -d1 -o2 VIDEO\yes.png chunk.hir
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak NodYes.s _NodYes
%OSDK%\bin\pictconv -f0 -d1 -o2 VIDEO\leanforward.png chunk.hir
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak LeanForward.s _LeanForward
%OSDK%\bin\pictconv -f0 -d1 -o2 VIDEO\yabber.png chunk.hir
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak Yabber.s _Yabber
%OSDK%\bin\pictconv -f0 -d1 -o2 VIDEO\disdain.png chunk.hir
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak Disdain.s _Disdain
%OSDK%\bin\pictconv -f0 -d1 -o2 VIDEO\checkwatch.png chunk.hir
%OSDK%\bin\FilePack -p chunk.hir chunk.pak
%OSDK%\bin\Bin2Txt -s1 -f2 chunk.pak CheckWatch.s _CheckWatch
pause
