Memory
======

- [Memory](#memory)
  - [Memory in general](#memory-in-general)
  - [Memory on the Oric](#memory-on-the-oric)
  - [Overlay memory and floppy disk drive](#overlay-memory-and-floppy-disk-drive)
  - [FloppyBuilder system](#floppybuilder-system)
  - [System ROM](#system-rom)
- [Memory in Encounter](#memory-in-encounter)
  - [Reserved locations](#reserved-locations)
    - [Page 1 - 6502 processor stack](#page-1---6502-processor-stack)
    - [Page 3 - Input/Output area](#page-3---inputoutput-area)
    - [Video memory and charsets](#video-memory-and-charsets)
    - [6502 vectors](#6502-vectors)
  - [Free areas](#free-areas)
    - [Page 0](#page-0)
    - [Page 2](#page-2)
    - [Page 4 to charsets](#page-4-to-charsets)
    - [Overlay memory](#overlay-memory)
  - [Total free memory](#total-free-memory)

## Memory in general
On modern machines, with a lot of RAM and virtual memory, optimizing memory usage is mostly a thing of the past: Doing it may definitely improve performance, but it's not an actual requirement to get things running at all.

On a 8bit computer, you have a fixed quantity of memory, no virtualization, fixed locations for I/O, hardware vectors and CPU stack, sometimes you have some form of memory banking, but that's about it.

## Memory on the Oric
Encounter is designed to run on Oric computers with 64KB of RAM, which includes all the machines (Oric 1, Oric Atmos, Telestrat, Oric Nova 64 and Pravetz 8D) with the exception of the 16KB Oric 1 (and technically 16KB Oric Atmos but I have never seen a real one).

The Telestrat has 64KB and can be extended to 128KB using ram cartridges, but this is not supported.

## Overlay memory and floppy disk drive
The Oric Atmos 48K actually has 64KB of RAM, it just happens that the top 16KB of RAM are located at the same location as the 16KB of ROM, and the machine does not come with the necessary circuitry to select the one you want to use.

When a floppy disk drive (Microdisc or Jasmin) is connected to the Oric, it comes with a controller board providing the missing circuitry as well as a boot ROM able to bootstrap the system.

The 16KB of RAM become available under the name of "Overlay memory", and are used by the system to store the DOS, generally with a bit of RAM in page[^1] 4 sacrificied to handle the dispatching between BASIC ROM and DOS RAM depending of what the user or applications are doing.

## FloppyBuilder system
A proper DOS is useful when you need to be able to create or delete files, rename them, modify them, etc... which requires maintaining some directory structure to keep track of the location of files, handling fragmentation, etc...

In the case of games or demos, most of the content is static and known 100% at build time, handling things like game saves can be done using preallocated fixed locations on disks (called "slots"), which means you can avoid the requirement for a directory structure, and if all the files are nicely laid out linearly, all you need is to know the position of the first sectors as well as the size of the file.

This is exactly what the Floppy Builder system is doing.

Using a [master script filescripting.h](../code/floppybuilderscript_master.txt) describing the list of all files required to build the floppy disk, the Floppy Builder generates both a .DSK file and a [layout file](../build/floppy_description.h) which can be used by the game loader to access easily all the files.

Since the system is much simpler, most of the features of a proper DOS are not required, all that is needed is code able to read and save bunch of sectors, plus some fancy features such as the ability to decompress data on the fly.

As a result, the [loader](../code/loader.asm) is about 768 bytes in total, to which you can add a couple simple functions for the [loader api](../code/loader_api.h)

## System ROM
Technically it's possible to still access the system ROM, but the Oric 1, Oric Atmos and Telestrat have vastly different ROMs with different access points, making the compatibility quite problematic.

Assuming the compatibility is properly handled, using the system ROM comes with a significant set of constraints since the ROM uses most of the pages 0 and 2 to keep track of system information.

The choice was made to not use the ROM at all, which means we have to initialize and manage the hardware ourself, and we also need to reimplement all the base functionalities like keyboard handling, changing video mode, timers, etc...

In exchange, we gain full liberty on how we use the memory, including pages 0, 1 and 2.

# Memory in Encounter
So, we have much more memory available with this system than we would have with a normal game on tape or even using a standard Sedoric format, but that does not mean we can do whatever we want.

## Reserved locations
The Oric is a 6502 based system, which means a certain number of locations are imposed and cannot be avoided, plus some hardware choices made by the Oric company when they designed the machine.

### Page 1 - 6502 processor stack
The memory area from $100 to $1FF is used by the 6502 everytime an interuption is handled, a jump to subroutine performed, or a push accumulator is done.

We can technically use some of it if we are sure we don't use too many recursion calls, but that's about it.

### Page 3 - Input/Output area
The entire area from $300 to $3FF is reserved for the hardware registers for peripherals such as the 6522 VIA or the floppy disk controller board, unused locations are not mapped to memory, so it's not possible to store anything there

### Video memory and charsets
The Oric has a convoluted video memory system, with a TEXT mode (40x28 character) located from $BB80 to $BFDF and a HIRES mode (240x200 pixels plus three additional lines of characters) located from $A000 to $BFDF.

Each of these modes have two associated character sets called STD (standard) and ALT (alternate).

Each of these character sets occupies 1024 bytes, but since the characters from 0 to 31 are not displayable, only 768 bytes are actually used, which leaves 256 bytes free at the start of each charset.

The two TEXT charset are located at $B400 (STD) and $B800 (ALT), while the two HIRES charset are located at $9800 (STD) and $9C00 (ALT).

There is also a small zone of 32 bytes located at the end of the screen and just before the ROM area, from $BFE0 to $BFFF, which is generally not used but is extremely practical to store resident information in a program made of multiple parts that need to communicate.

### 6502 vectors
At the very end of the addressable space are 6 bytes which have special significance to the processor:
- NMI - from $FFFA to $FFFB contains the address where the CPU jumps when the reset button is pressed
- RESET - from $FFFC to $FFFD is only used when the machine starts to define where the system boot code is located
- IRQ/BRK - from $FFFE to $FFFF is the most important one and contains the location of the IRQ vector called when a VIA timer interuption triggers, or when a BRK instruction is executed by the processor

## Free areas
So by elimination this leaves all these free for our use:
### Page 0
Since the ROM is not executed, we have full access to these 256 bytes of scratch memory

### Page 2
The Page 2 is normally used by the ROM to store book-keeping data (video mode, timer values, exception handlers, ...) but since the ROM is not present we have full access to it.

### Page 4 to charsets
It's hard to provide a fixed end address since what is available depends of the video combination, but basically we have a solid chunk of memory available from $400 to $B400 (45056 bytes) if we are using TEXT mode, and from $400 to $9800 (37888 bytes) if we are using HIRES mode.

### Overlay memory
Since we are not using a DOS, we have access to all the memory from $C000 to $FFFF (16384 bytes), minus the room used by the loader and the exception vectors (about 768 bytes), which leaves us with about 15616 bytes.

## Total free memory
So, in total, here what we have available assuming a worse case situation (HIRES mode):
-   256 bytes - Page 0 
-   256 bytes - Page 2
- 37888 bytes - Main memory
- 15616 bytes - Overlay memory
-------------------------------
Total = 54016


----
[^1] You can think of the 65536 bytes of memory as being made of 256 "pages" of 256 bytes.
