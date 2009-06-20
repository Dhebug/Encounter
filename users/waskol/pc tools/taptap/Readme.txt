What is "taptap" ?
------------------
It is a command line utility for windows, written in in Delphi(kind of Object Pascal).
It permits to work on oric tap files.


Syntax :
--------
Catalog :
  taptap.exe cat <File>
    <File>.... : Tap file to be processed - mandatory
  Example : taptap.exe cat myfile.tap

Rename an Oric file in a .tap File :
  taptap.exe ren <TapFile> <Newname> <FileIndex>
    <FromFile>. : Tap file to be processed - mandatory
    <NewName>.. : New file name of the oric file to be processed -mandatory
                  The New oric file name can be specified
                  in 2 different ways
                  - as a string : in that case it must be
                    enclosed between quotes
                    examples : "Space Invaders", "Terror of the deep",...
                  - as a succession of 8 bits hexadecimal
                    values (2 digits each), without any space
                    It then permits to have some text attributes
                    into the oric title : ink or paper color, blink...
                        (please refer to Oric manual for values).
                    In that case, the string must be preceeded by
                    the # symbol and the null hexadecimal values (INK 0)
                    are forbidden.
                    example : #0148656C6C6F07
                    ...will print "Hello" in red on the status line
                       while loading.
    <FileIndex> : File index in Tap File, 0 is the 1st file,
                  index 1 the 2nd, etc - Mandatory

Set Auto run On or Off :
   Simply write
  taptap.exe AutoOn <TapFile> <FileIndex>
   or
  taptap.exe AutoOff <TapFile> <FileIndex>


Practical example of use :
--------------------------
let's see a practical example, I took the game Galaxian
if I type in a command line:

taptap.exe cat galaxian.tap

..I obtain
____________________________________________
Catalog of "galaxian.tap"
Index.... : 0
Name..... : GALAXIANS
File kind : BASIC
Auto..... : Yes (#C7)
Starting Address : #0501
Ending   Address : #16F1
Size............ : 4593 bytes

Index.... : 1
Name..... : GALAXIAN.1
File kind : Machine code or memory bloc
Auto..... : No
Starting Address : #5800
Ending   Address : #6FFF
Size............ : 6144 bytes
____________________________________________

thus, there are two files on the tape.
If I want to rename the BASIC program, I just do :
Code:
taptap ren galaxian.tap "super game !" 0

And now, if I ask for the catalog :

____________________________________________
Catalog of "galaxian.tap"
Index.... : 0
Name..... : super game !
File kind : BASIC
Auto..... : Yes (#C7)
Starting Address : #0501
Ending   Address : #16F1
Size............ : 4593 bytes

Index.... : 1
Name..... : GALAXIAN.1
File kind : Machine code or memory bloc
Auto..... : No
Starting Address : #5800
Ending   Address : #6FFF
Size............ : 6144 bytes
____________________________________________

Just what we expected...

But we can also do some nice printing (blinking cyan for instance) :
cyan --> #06 (TEXT Attribute for cyan)
blink --> #0C
G-->#47 (ASCII codes in Hex format)
A-->#41
L-->#4C
A-->#47
X-->#58
I-->#49
A-->#41
N-->#4E
Back to white + inverse for the 'B' of BASIC of the status line -->#87

that gives us :

taptap ren galaxian.tap #060C47414C475849414E87 0


convert to wav if you want to see something when loading this... Wink


Remove autoboot in order to get the listing ?
Code:
taptap autooff galaxian.tap 0


Then load it in Euphoric, LIST, and...
Code:
 1 IFPEEK(#5800)<>#D0THENCLOAD"":RUN
 5 DIM HS(8),HS$(8)
 7 PRINTCHR$(17);CHR$(6);
 20 FOR T=1 TO 8:HS(T)=50:HS$(T)="ALPHA":NEXT T
 30 SOUND 1,0,0:SOUND 2,0,0:PLAY 0,0,0,0
 40 DATA 7,60,80,100,120,140,160,180
 42 DATA 6,70,90,110,130,150,170
 44 DATA 4,90,110,130,150
 46 DATA 4,90,110,130,150
 48 IF PEEK(#9768)=83 GOTO 100
 50 DOKE#9600,0:CALL#6C00
 60 IF DEEK(#9600)=30418 THEN POKE#9768,83:GOTO 100
 70 GOSUB 9500
 100 GOSUB 9000
....



How to compile ?
----------------
It can be compiled with any version of Delphi (such like Turbo Delphi, wich is free for download), 
and may be with Lazarus (Open Source Delphi "clone"). 

While Delphi can compile only for Windows OS, Lazarus should be able to compile for Linux, MacOs, etc...

Usefull links :
---------------
Turbo Delphi : http://www.turboexplorer.com/delphi
Lazarus : http://www.lazarus.freepascal.org/