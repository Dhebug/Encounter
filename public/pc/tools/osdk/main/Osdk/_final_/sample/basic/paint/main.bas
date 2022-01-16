0 ' From Geoff Phillips book "Oric Atmos and Oric 1 Graphics and Machine code techniques"
1 ' https://library.defence-force.org/index.php?content=any&page=books&sort_by=name&freesearch=007084743
2 ' Original code starts line 5 (Line 15 modified to directly set the starting position instead of asking it)
3 HIRES:CURSET120,100,3:CIRCLE50,1

5 REM BASIC VERSION OF PAINT
10 DIM A(100):S=100 
15 X=120:Y=100 'INPUT X,Y 
20 RF=0:S=S-1:A(S)=255:S=S-1:A(S)=255:GOTO 35 
30 Y=A(S):S=S+1:X=A(S):S=S+1 
35 IF X=255 THEN END 
40 IF RF=0 THEN UF=TRUE:DF=TRUE 
45 T=S:R=T
46 IF A(R)=255 THEN 50 
47 IF A(R)=YANDA(R+1)=X THEN R=R-1:FOR K=R TO T STEP-1:A(K+2)=A(K):NEXT:S=S+2:GOTO 50 
48 R=R+2:GOTO 46 
50 CURSET X,Y,1 
60 IF UF AND POINT(X,Y-1)=0 THEN S=S-1:A(S)=X:S=S-1:A(S)=Y-1 
70 UF=POINT(X,Y-1) 
80 IF DF AND POINT(X,Y+1)=0 THEN S=S-1:A(S)=X:S=S-1:A(S)=Y+1 
90 DF=POINT(X,Y+1) 
100 RF=O:IF POINT(X-1,Y)=0 THEN S=S-1:A(S)=X-1:S=S-1:A(S)=Y:RF=TRUE 
120 IF POINT(X+1,Y)=0 THEN S=S-1:A(S)=X+1:S=S-1:A(S)=Y:RF=TRUE 
130 GOTO 30
