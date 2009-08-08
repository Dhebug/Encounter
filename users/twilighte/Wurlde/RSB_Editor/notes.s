;Optimised Bitmap Encoding(OBE)
;Each HIRES byte defines both offset and value
;000-007 00-07 Ink
;008-008 08-08 End
;009-023 09-17 Attributes
;024-043 18-2B Columns Left(1-20)
;044-063 2C-3F Columns Right(1-20)
;064-127 40-7F Bitmap
;128-151 80-97 Inversed Attributes
;152-171 98-AB Rows Up(1-20)
;172-191 AC-BF Rows Down(1-20)
;192-255 C0-FF Inversed Bitmap

;Editor provides Load of HIRES image then position byte alligned box and resize to
;area. Then set relative start byte offset within box.
;Finally select Interlace mode (then ask if starting interlace row)

;Routine then jumps to first change in row using bytes and stores them sequentially
;to memory file. After complete box has been scanned the program will return to box.

;ASM routine needed to plot(inverse) BOX and relative start position in box.
;BASIC to navigate box, resize and move relative offset byte, to compile, and save/load

;ASM routine needed to Plot/Delete OBE later

1)
An OBE frame is based on a starting location which is called the Cursor.
From here a jump is embedded in the graphic data to move the cursor to the top most
byte to change.
In this way all frames of an animation can be alligned to a centre-point, a position
that remains stationary as the animation is played out.

2)
OBE can capture all visible attributes including Inverse, ink, paper and other attributes
and bitmaps. OBE uses the ranges 24-63 and 152-191 for movement codes, these ranges are not
generally used in the HIRES scheme. OBE also uses code 8 to signify the end of the frame.

3)
Only the visible areas are displayed. In this way overlaying multiple layers is
possible.

The First version of the Editor is very crude, having been written half in basic
and half in xa asm.
At the start the program goes into HIRES and loads the HIRES screen. The file contains
all the animation frames needed to convert. Change as appropriate.

The program then displays a large box over the image which may be moved around the
screen in byte steps using the cursor keys. Use Shift to increase the vertical step
size.
The Box appears as two horizontal inversed rows with a byte in the centre. This byte
is the Centre-Point Cursor.
The box width may be adjusted using the Z and X key.
The box height may be adjusted using the / and ' key.
The Centre-point cursor may be adjusted using the Q,A,O and P keys.

Once the box frames the image press Return to capture it.
OBE can optionally capture Split-line images, where alternate rows are masks. The
first prompt selects this special mode. If selected the second prompt asks whether
the mask is on the first row.

After prompts the program will compile the image into an OBE graphic and store to
local memory. A countdown will show progress.
Once finished the box will re-appear.

The memory file may then be printed (Sent to the printer as xa compatable .byt
statements (each row 16 bytes long). Press 5 to Print the memory file.

The image may also be displayed back on the screen. However this will 

