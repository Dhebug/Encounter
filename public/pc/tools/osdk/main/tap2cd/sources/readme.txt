June 2012: IMPORTANT
=========================

This is version 2 of this program. It has been revised so it now works with Atmos machines 
which had problems with the previous version, as well as with a wider variety of real 
players (some seemed to invert the signal). Auto-run is now well preserved.

It now has an option to perform an 8-bit CRC on every page loaded (activate it with -c 
in the command line options), so loading errors are detected and reported inmediately.

It also has a new option to load the hires screen first (activate it with -h). Use this 
with caution, as it needs that the original tape includes the hires screen in the same file. 

Thanks Fabrice for this splendid work!

Chema


Original Text of tap2cd
=======================

CLOADING AT 22050 BAUD ON THE ORIC

Here is a program that will allow you to load programs on your real Oric at
the amazing speed of 22050 baud... you can use it for direct transfers from
your PC to your Oric, or you can use it to build an Oric archive on a tape or
an audio-CD...

HOW FAST IS IT ?

As with the standard Oric routines, the real speed depends on the pattern of
bits ('1' bits are faster than '0' bits), so let's consider a program that has
an equivalent amount of '1' and '0' bits : in such a case, the real speed is
12600 bps (vs ~1900bps with the standard Oric routines).
But unlike the standard Oric routines, this is the real speed you will get
when loading a program (because the program is loaded 256 bytes at once without
start, parity or stop bits for each byte). 
In other words, my routine loads 1575 bytes per second, vs 150 bytes per
second with the ROM routines. 10 times faster !

Just imagine: you needed about 4'30" to load a program like Zorgons' Revenge, 
it only requires 30" now... will you ever return to 2400 baud ?

This also means a 74-minutes CD offers a capacity of more than 6 MB for your
Oric programs (i.e. more than 200 programs of 30 KB each), or even twice this
number if you want to store programs on both left and right channels.

SO, HOW DO I USE IT ?

Tap2cd is a program that converts .TAP files to .WAV files (22kHz mono).
Just run tap2cd like this:

tap2cd gobbler.tap gobbler.wav

You will be prompted to enter an Oric filename for it because many TAP files
don't have one (as usual with the Oric, this should be no more than 16 
characters, but you can't enter an empty name here: this is because you will
soon want to fill a CD track with several programs in sequence, and the expected
program has to be named if you want to find it). Let's say you reply GOBBLER 
in this example. The program will then end, leaving a gobbler.wav file.
You can now load the program on your real Oric with the usual command (once 
you have connected your PC soundcard to your Oric of course) :
CLOAD"GOBBLER"
or CLOAD"

THE ORIC CD ARCHIVE CONSTRUCTION KIT

Of course, a speed of 22050 baud is ideal for storing Oric programs on a CD.
Building an archive of all your programs on a CD will require you to plan
some strategy... If you have 200 programs or so, you are probably not going to
reserve a full track for each of them on the CD, right ? This means you have
to sort your programs and decide which of them you will append together on a
single track. In order to build a CD track, you will need a WAV tool that
allows you to append (concatenate) several WAV files.

For example, you may decide to append all arcade games together in a single
track, all adventure games in another track, etc.

Then, you must also decide how you are going to make your CD user-friendly...
This will require you to build some kind of menu, don't forget to read simple
hints and tips at the end of this file.

You are absolutely free to program either a small menu for each of your tracks
or a single big menu that you will record in track 1, allowing you to chose
among all your programs, and requesting the user to seek the CD to the track
that contains the chosen program...

HOW DOES IT WORK ?

This is the result of months of work, some of you might remember my first
Oric-CD (oops, was it really 3 years ago ?), with its standard 2400 baud tracks,
and experimental tracks written at 22050 baud. The encoding scheme for the 
22050 baud tracks on this first Oric-CD didn't work, I then developed zillions
of other schemes before this one... To make a long story short, the first 
encoding scheme was simply using the standard Oric format, at the maximum 
possible speed on a CD : 22050 baud (because two 44100 Hz samples are needed 
for a '1' bit). As I am rather obstinate, I decided I would succeed to reach 
this speed. If you want to know how I finally arrived to this routine (which
takes into account the deformation that the signal suffers when travelling
through the input circuitry of the Oric), I have written a long article in 
the Rhetoric magazine...

Of course, the standard Oric routines are not able to read this format, so
a small loader is prepended to the WAV file, and it automatically loads the
following 22050 baud program.

HINTS AND TIPS

- Important: I forgot to say the loader routine is only compatible with the
Atmos rom, don't even try to load your program on an Oric-1 unless you have
upgraded its rom to an Atmos one.
- I would recommend to build a big menu program and to store it alone in
track 1. Additionnally, a simple menu at the beginning of each track allows
the user to quickly access a program if he knows which track it is on.
- I would suggest to sort the programs in a track in ascending size order and/or
decreasing popularity order... this way, you wouldn't wait minutes before a
small program loads. Conversely, you don't want to wait several programs before
loading your favorite program... It's possible a thematic sort of all your 
programs might not be the best solution, after all. Perhaps it is better to
select the 15 or 20 most popular programs and place them each in first position
in their track, then select the 15 or 20 next popular programs and place them in
second position in the tracks, etc.
- don't ask me to provide you with a ready-made archive CD unless you want to
offer me a CD-writer (I don't have one yet).
- of course, tap2cd might fail to produce an usable file if the input .TAP
file contains a copy-protection scheme (e.g. an header with false addresses),
or if a multipart program uses its own loading routines.
Don't call me in such a case, YOU must unprotect it if you want to use tap2cd.
Don't call me either for any difficulty you have when converting a particular
file, YOU must examine your particular program and modify it yourself so that
tap2cd can convert it successfully...
- Don't forget to insert a few seconds of silence between the menu and the
following program if you want the user to have enough time to make his selection.

Happy CLOADing,

Fabrice