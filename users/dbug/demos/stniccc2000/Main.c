#include	"lib.h"

// --------------------------------------
// Mixed TEXT/HIRES graphics mode.
//	 Sample #1:
// This program demonstrates the ability
// of the Oric range of computers to use
// different color per scanline, even in
// TEXT display mode.
// --------------------------------------
// (c) 1997 Micka‰l Pointier.
// This code is provided as-is.
// I do not assume any responsability
// concerning the fact this is a bug-free
// software !!!
// Except that, you can use this example
// without any limitation !
// If you manage to do something with that
// please, contact me :)
// --------------------------------------
// --------------------------------------
// For more information, please contact me
// on internet:
// e-mail: mike@defence-force.org
// URL: http://www.defence-force.org
// --------------------------------------
// Note: This text was typed with an MS-DOS
// editor. So perhaps the text will not be
// displayed correctly with other OS.




void StopInterrupt();
void RestoreInterrupt();
void GenerateRGBTable();

extern unsigned char	Picture[];
extern char				CosTable[];
extern int				U,V,IU,IV,MU,MV;

extern unsigned	char	RedValue[];
extern unsigned	char	GreenValue[];
extern unsigned	char	BlueValue[];
extern unsigned	char	Mul5[];
extern unsigned	char	Mul20[];



#include "angle.c"	// 4000 octets (100 lignes de 40 octets)
#include "prof.c"	// 4000 octets (100 lignes de 40 octets)


#define CHARTABLE 0xFC78	// Points on the ROM definition of characters

#define PIXEL(r,g,b)	(36+  ((r)>>6)  +  (((g)>>6)*5) +  (((b)>>6)*5*4))
#define PIXEL_4(r,g,b)	(36+  ((r))  +  (((g))*5) +  (((b))*5*4))
#define P(r,g,b)	(36+  ((r))  +  (((g))*5) +  (((b))*5*4))


unsigned char RasterLine[]=
{
	// -------- 0
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),

	P(3,3,0),P(3,3,1),P(3,3,2),P(3,3,3),P(3,3,3),P(3,3,2),P(3,3,1),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),

	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),

	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	// -------- 256

	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(3,3,0),P(3,3,1),P(3,3,2),P(3,3,3),P(3,3,3),P(3,3,2),P(3,3,1),P(3,2,0),
	P(3,2,0),P(3,2,0),P(3,0,0),P(2,0,0),P(0,0,0),P(0,0,0),P(1,1,1),P(1,1,1),
	P(2,2,2),P(2,2,2),P(3,3,3),P(3,3,3),P(2,3,3),P(1,2,3),P(0,1,3),P(0,0,2),
	P(0,1,2),P(0,1,1),P(0,1,0),P(0,2,0),P(0,3,1),P(0,3,2),P(1,3,0),P(2,3,0),
	
	P(1,2,0),P(0,1,0),P(1,1,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	// -------- 384
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(3,3,0),P(3,3,1),P(3,3,2),P(3,3,3),P(3,3,3),P(3,3,2),P(3,3,1),P(3,3,0),
	P(3,3,1),P(3,3,2),P(3,3,3),P(3,3,2),P(2,3,1),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	P(1,2,0),P(0,1,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),
	P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),
	P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),
	P(3,0,3),P(3,0,3),P(3,0,3),P(3,0,2),P(2,0,1),P(2,1,0),P(2,2,0),P(2,3,0),
	
	/*
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	P(2,0,0),P(1,0,0),P(1,0,0),P(2,0,0),P(3,1,0),P(3,2,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(3,3,0),P(2,3,0),P(1,3,0),P(0,3,0),P(0,3,0),P(0,3,1),P(0,3,2),P(0,3,3),P(0,3,3),P(0,3,3),P(0,2,3),P(1,1,3),P(2,0,3),P(3,0,3),P(3,0,3),P(3,0,3),
	*/
};



void EraseScreen();

unsigned char ScreenColor;



unsigned char *ScreenAdress=(unsigned char*)0xBB80;

unsigned char CharColor;
char *PtrMessage;

void DisplayMessage(char *ptr_message,unsigned int counter,unsigned char color)
{
	unsigned char line,col,c;
	unsigned char x,y;
	unsigned char bit;
	unsigned char *ptr_char;
	unsigned char *ptr_screen;
	char *message;

	CharColor=color;

	//
	// Display message
	//
	while (counter--)
	{
		PtrMessage=ptr_message;

		DrawText();
		/*
		message=ptr_message;
		ptr_screen=ScreenAdress+3;
		line=3;
		while (line--)
		{
			col=6;
			while (col--)
			{
				c=*message++;
				ptr_char=((unsigned char*)0xfc78)+((c-32)<<3);

				y=8;
				while (y--)
				{
					bit=*ptr_char++;
					if (bit & 32)	ptr_screen[0]=color;	// Pixel
					if (bit & 16)	ptr_screen[1]=color;	// Pixel
					if (bit & 8)	ptr_screen[2]=color;	// Pixel
					if (bit & 4)	ptr_screen[3]=color;	// Pixel
					if (bit & 2)	ptr_screen[4]=color;	// Pixel
					if (bit & 1)	ptr_screen[5]=color;	// Pixel
					ptr_screen+=40;
				}
				ptr_screen+=6-40*8;

			}
			ptr_screen+=40*8+4;
		}
		*/
	}
}





unsigned char  IncX;
unsigned char  IncY;

void RotoTunel(int delay,int speed)
{
	int		value_1;
	int		value_2;

    unsigned int    y;

    while (delay--)
    {	
		DisplayTunel();

		IncX+=speed+CosTable[value_1]>>4;
		IncY+=speed+CosTable[value_2]>>4;

		value_1+=1;
		value_2+=0;
    }
}





unsigned char Angle;
unsigned char ZoomX;
unsigned char ZoomY;

int	MoveX;
int	MoveY;
int	MoveDX;
int	MoveDY;



// c=36 + r + g*5 + b*20


void FadeToBlack();

/*
void FadeToBlack()
{
	int		x,y;
	unsigned char c,r,g,b;
	unsigned char *ptr_screen;
	char	flag;
	
	do
	{
		flag=0;
		ptr_screen=(unsigned char*)0xBB80+3;
		for (y=0;y<25;y++)
		{
			for (x=0;x<37;x++)
			{
				c=ptr_screen[x];
				
				if (c!=36)
				{
					r=RedValue[c];
					g=GreenValue[c];
					b=BlueValue[c];

					if (r)	r--;
					if (g)	g--;
					if (b)	b--;

					flag=1;
					ptr_screen[x]=PIXEL_4(r,g,b);
				}
			}
			ptr_screen+=40;
		}
	}
	while (flag);
}
*/



/*
void FadeToBlack()
{
	int		x,y;
	unsigned char c,r,g,b;
	unsigned char *ptr_screen;
	char	flag;

	do
	{
		flag=0;
		ptr_screen=(unsigned char*)0xBB80+3;
		for (y=0;y<25;y++)
		{
			for (x=0;x<37;x++)
			{
				c=ptr_screen[x];

				if (c!=36)
				{
					flag=1;
					ptr_screen[x]=c-1;
				}
			}
			ptr_screen+=40;
		}
	}
	while (flag);
}
*/


int MoveSpeed=1;


void MovePicture(int dest_x,int dest_y)
{
	int	speed;

	while ((MoveX!=dest_x) || (MoveY!=dest_y))
	{
		speed=MoveSpeed;
		while (speed--)
		{
			if (MoveX<dest_x)	MoveX++;
			else
			if (MoveX>dest_x)	MoveX--;

			if (MoveY<dest_y)	MoveY++;
			else
			if (MoveY>dest_y)	MoveY--;
		}

		DisplayPicture();
	}
}

void WaitPicture(int count)
{
	while (count--)
	{
		DisplayPicture();
	}
}


void FadeMessage(char *message,unsigned int sr,unsigned int sg,unsigned int sb)
{
	int i;

	for (i=0;i<=255;i+=4)		DisplayMessage(message,1,PIXEL(i>>sr,i>>sg,i>>sb));
	for (i=255;i>=0;i-=4)		DisplayMessage(message,1,PIXEL(i>>sr,i>>sg,i>>sb));
}


extern void DrawPlasma();
extern void FlipBuffer();

unsigned char XPlasma;



void DoPlasma(char *ptr,int delay)
{
    unsigned char	x;
	
	ScreenAdress=(unsigned char*)0xafa0;

    x=0;
    while (delay--)
    {
		//VSync();
		XPlasma=(128+CosTable[x])>>1;
		DrawPlasma();

		DisplayMessage(ptr,1,36|128);

		FlipBuffer();

		x+=1;
    }

	ScreenAdress=(unsigned char*)0xbb80;
}


/*
void DoPlasma()
{
	int		x,y;
	int		c,r,g,b;
	unsigned char *ptr_screen;
	char	flag;
	
	unsigned char a1,a2,a3;
	unsigned char b1,b2,b3;
	
	
	do
	{
		flag=0;
		ptr_screen=(unsigned char*)0xBB80+3;

		a1=(128+CosTable[b1]);
		a2=(128+CosTable[b2]);
		a3=(128+CosTable[b3]);
		
		r=(128+CosTable[a1])>>6;
		a1++;
		for (y=0;y<25;y++)
		{
			g=(128+CosTable[a2])>>6;
			a2++;
			for (x=0;x<37;x++)
			{
				b=(128+CosTable[a3])>>6;
				a3+=0;
				c=PIXEL_4(r,g,b);
				ptr_screen[x]=c;
			}
			ptr_screen+=40;
		}
		b3+=3;
		b2+=0;
		b1+=1;
	}
	while (1);
}
*/



void DoDemo()
{
	int x,y,z;
	int div_factor;
	int	offset;
	int	max_x;
	int max_y;
	int	i;
	int	delay;
	unsigned char red,green,blue;

	//
	// Fade to black
	//
	red=3;
	green=3;
	blue=3;
	delay=12;
	do
	{
		if (delay)
		{
			delay--;
		}
		else
		{
			delay=12;
		if (blue>green)	blue--;
		else
		if (green>red)	green--;
		else red--;
		}
		
		ScreenColor=PIXEL_4(red,green,blue);
		EraseScreen();
	}
	while (red || green || blue);

	

	ScreenColor=PIXEL(0,0,0);
	EraseScreen();

	//
	// Intro
	//
	//
	// Plasma
	//
	//        123456......123456
	DoPlasma("                  ",20);
	DoPlasma("Dbug  from  NeXT  ",50*2);
	DoPlasma("                  ",20);
	DoPlasma("    on   the  keys",50*2);
	DoPlasma("                  ",20);
	DoPlasma("to    show  you...",50*2);
	DoPlasma("                  ",20);
	DoPlasma("   the  Oric power",50*2);
	DoPlasma("                  ",20);
	
	
	/*	
	ScreenColor=PIXEL(0,0,0);
	EraseScreen();

	FadeMessage(" DBUG  FROM  NeXT ",2,1,8);
	*/



	//
	// Did he says C64 ???
	//
	MoveX=127;
	MoveY=0;
	MoveDX=256;
	MoveDY=-1;

	MoveSpeed=1;
	MovePicture(127,22);
	WaitPicture(80);

	//
	// Title
	// 
	ScreenColor=PIXEL(0,0,0);
	EraseScreen();
	//FadeMessage("1MHZ   ORIC   DEMO",2,8,1);
	//        123456......123456
	DoPlasma("                  ",20);
	DoPlasma("1MHZ   ORIC   DEMO",50*3);
	DoPlasma("                  ",20);
	
	//
	// Continue calvin
	//
	MovePicture(127,2);

	MovePicture(25,2);
	MovePicture(25,64-37);
	MovePicture(62,22);
	WaitPicture(20);

	ScreenColor=PIXEL(2,128,255);
	EraseScreen();
	DisplayMessage("CUDDLYDEMOESRULEZ!",100,PIXEL(255,128,2));
	WaitPicture(1);
	FadeToBlack();

	//
	// Bitmap tunel
	//
	RotoTunel(52*4,2);

	ScreenColor=PIXEL(128,255,128);
	EraseScreen();
	DisplayMessage("R-TIMEBITMAPTUNNEL",100,PIXEL(255,2,255));
	RotoTunel(52*4,1);
	FadeToBlack();
	
	/*
	ScreenColor=PIXEL(0,0,0);
	EraseScreen();
	FadeMessage("STNICC       2000 ",8,2,1);
	*/
	//              123456......123456
	DoPlasma("                  ",20);
	DoPlasma("Made  in one  week",50*2);
	DoPlasma("                  ",20);
	DoPlasma("only   for     the",50*2);
	DoPlasma("                  ",20);
	DoPlasma("STNICC       2000 ",50*2);
	DoPlasma("                  ",20);
	FadeToBlack();
	
	//
	// Oric Power Demo
	//
	MoveDX=1;
	MoveDY=256;
	MoveX=128;
	MoveY=0;

	MoveSpeed=3;

	MovePicture(128+128-37	,0);		// Scroll right
	MovePicture(128+128-37	,20);		// Scroll down
	MovePicture(128			,20);		// Scroll left
	MovePicture(128			,64-25);	// Scroll down
	MovePicture(128+128-37	,64-25);	// Scroll right
	MovePicture(128			,0);		// Scroll topleft
	FadeToBlack();

	//
	// Gretingz
	//

	ScreenColor=PIXEL(0,0,0);
	EraseScreen();
	//              123456......123456
	DisplayMessage("GREETZ  TO:       ",40,PIXEL(255,255,255));
	FadeToBlack();
	
	ScreenColor=PIXEL(85,85,85);
	EraseScreen();
	//              123456......123456
	DisplayMessage("STNEWS TCB    TLB ",40,PIXEL(255,0,128));
	FadeToBlack();
	
	ScreenColor=PIXEL(172,172,172);
	EraseScreen();
	//              123456......123456
	DisplayMessage("ST-CNXEQUINX  L16 ",40,PIXEL(255,255,0));
	FadeToBlack();
	
	ScreenColor=PIXEL(255,255,255);
	EraseScreen();
	//              123456......123456
	DisplayMessage("DELTA  FORCE   TEX",40,PIXEL(  2,2,2));
	FadeToBlack();
	
	ScreenColor=PIXEL(255,64,255);
	EraseScreen();
	//              123456......123456
	DisplayMessage("SECTR1 OVR  RPLCNT",40,PIXEL(85,2,128));
	FadeToBlack();
	
	ScreenColor=PIXEL(255,64,2);
	EraseScreen();
	//              123456......123456
	DisplayMessage(" DHS  LEGACY  SYNC",40,PIXEL(22,255,128));
	FadeToBlack();
	
	ScreenColor=PIXEL(255,255,255);
	EraseScreen();
	//              123456......123456
	DisplayMessage("FOXX  DMA    CREAM",40,PIXEL(  2,2,2));
	FadeToBlack();
	
	ScreenColor=PIXEL(85,85,85);
	EraseScreen();
	//              123456......123456
	DisplayMessage("TVI    ACF    DUNE",40,PIXEL(255,2,128));
	FadeToBlack();
	
	ScreenColor=PIXEL(85,85,85);
	EraseScreen();
	//              123456......123456
	DisplayMessage("ULM   LAZER ELCTRA",40,PIXEL(255,2,128));
	FadeToBlack();
	


	//
	// Rotozoom sequence
	//
	x=0;
	y=0;
	delay=52*4;
	while (delay--)
	{
		div_factor=(16+((CosTable[ZoomX]+128)>>2));
		
		IU=(CosTable[Angle]<<6) 		/ div_factor;
		IV=(CosTable[(Angle+64)&255]<<6)/ div_factor;
		MU=x;
		MV=y;
		
		Angle+=1;
		ZoomX+=1;
		ZoomY+=3;
		
		DisplayRotoZoomAsm();
		
		x+=233;
		y+=122;
	}

	ScreenColor=PIXEL(128,255,128);
	EraseScreen();
	DisplayMessage(" ROTO  ZOOM  !!!! ",100,PIXEL(255,2,255));
	delay=52*3;
	while (delay--)
	{
		div_factor=(16+((CosTable[ZoomX]+128)>>2));
		
		IU=(CosTable[Angle]<<6) 		/ div_factor;
		IV=(CosTable[(Angle+64)&255]<<6)/ div_factor;
		MU=x;
		MV=y;
		
		Angle+=1;
		ZoomX+=1;
		ZoomY+=3;
		
		DisplayRotoZoomAsm();
		
		x+=233;
		y+=122;
	}

	ScreenColor=PIXEL(0,0,0);
	EraseScreen();
	FadeMessage("That's  all Folks!",0,0,0);

	//
	// Zoom sequence simple
	//
	x=0;
	y=0;
	delay=52*6;
	Angle=0;
	while (delay--)
	{
		div_factor=(16+((CosTable[ZoomX]+128)>>3));
		
		IU=(CosTable[Angle]<<5) 		/ div_factor;
		IV=(CosTable[(Angle+64)&255]<<5)/ div_factor;
		MU=x;
		MV=y;
		
		ZoomX+=1;
		ZoomY+=3;
		
		DisplayRotoZoomAsm();
		
		x+=233;
		y+=122;
	}


	ScreenColor=PIXEL(0,0,0);
	EraseScreen();
	//FadeMessage("      \140 2000 DBUG ",8,2,1);
	DoPlasma("                  ",50);
	DoPlasma("      \140 2000 DBUG ",50*6);
	DoPlasma("                  ",50);
	FadeToBlack();
	

	//
	// Fade to white
	//
	red=3;
	green=3;
	blue=3;
	delay=12;
	do
	{
		if (delay)
		{
			delay--;
		}
		else
		{
			delay=12;
			if (blue>green)	blue--;
			else
			if (green>red)	green--;
			else red--;
		}
		
		ScreenColor=PIXEL_4(3-red,3-green,3-blue);
		EraseScreen();
	}
	while (red || green || blue);


	//
	// Temporisation
	//
	DisplayMessage("                  ",500,PIXEL(255,255,255));
}





char TableDither[4]=
{
	0 +64,
	36+64,
	54+64,
	63+64
};


// B402=charset
void RedefinesChar()
{
	char	v_red,v_green,v_blue;
	char	red,green,blue;
	char	*adress;
	
	adress=(char*)0xB400+8*36;	// 36
	
	for (blue=0;blue<4;blue++)
	{
		v_blue=TableDither[blue];
		for (green=0;green<4;green++)
		{
			v_green=TableDither[green];
			for (red=0;red<4;red++)
			{
				v_red=TableDither[red];
				*adress++=64;
				*adress++=v_red;
				*adress++=v_green;
				*adress++=v_blue;
				*adress++=v_red;
				*adress++=v_green;
				*adress++=v_blue;
				*adress++=64;
			}
			// Clear that character
			adress+=8;
		}
	}
}


void OverClear()
{
	char	*adress;
	
	//
	// Neutral HIRES value everywhere
	//
	adress=(char*)0x9800;
	while (adress<(char*)0xBFE0)
	{
		*adress++=64;
	}
	
	
	//
	// Neutral TEXT value everywhere...
	//
	adress=(char*)0xBB80;
	while (adress<(char*)0xBFE0)
	{
		*adress++=36;	// First "0" character
	}
}






char TableRVB[8]=
{
	0,	//	(Neutral)
	1,	//	RED
	2,	//	GREEN
	4,	//	BLUE
	1,	// RED	
	2,	// GREEN
	4,	// BLUE 
	0	//	(Neutral)
};



void main()
{
	int i,j;
	int c;
	char *adress;
	char red,green,blue;
	
	StopInterrupt();
	
	//	  InitMusic();
	
	OverClear();
	
	
	//
	// First, we must set the 222 HIRES
	// scan-lines to the values we want !
	// For instance, we want to change the
	// INK color, and then switch back to
	// TEXT mode.
	//
	adress=(char*)0xa000;
	for (i=0;i<200;i++)
	{
		adress[1]=TableRVB[i&7];	  // Raster color (set attribut)
		adress[2]=26;			// Text mode
		adress+=40;
	}
	
	//
	// We have to set the 25 displayable
	// TEXT line, for calling HIRES mode.
	//
	adress=(char*)0xBB80;
	for (i=0;i<25;i++)
	{
		*adress=30;    // hires mode
		adress+=40;
	}
	
	RedefinesChar();
	
	GenerateRGBTable();
		
	//PreparePicture();
	
	while (1)
	{
		DoDemo();
	}
	

	//RestoreInterrupt();
}




#if 0

Memory map of that weird video mode !

0x26 -> switch to text (to put in a hires screen)
0x31 -> switch to hires (to put in a text screen)

BB82 = TEXT SCREEN
A222 = HIRES SCREEN

B402 = CHARSET NORMAL
B822 = CHARSET ALTERNATE



Clear from "0x9822" area... beware !!!

2 BB82   2-  7 A222 
1 BBA8   8- 15 A140
2 BBD2  16- 23 A282
3 BBF8  24- 31 A3C2
4 BC22  32- 39 A522
5 BC48  40- 47 A640
6 BC72  48- 55 A782
7 BC98  56- 63 A8C2
8 BCC2  64- 71 AA22
9 BCE8  72- 79 AB40
12 BD12  82- 87 AC82
11 BD38  88- 95 ADC2
12 BD62  96-123 AF22
13 BD88 124-111 B240
14 BDB2 112-119 B182
15 BDD8 122-127 B2C2
16 BE22 128-135 B402 -> TEXT CharSet
17 BE28 136-143 B540 -> TEXT CharSet
18 BE52 144-151 B682 -> TEXT CharSet
19 BE78 152-159 B7C2 -> ALT CharSet
22 BEA2 162-167 B922
21 BEC8 168-175 BA40
22 BEF2 176-183 BB82
23 BF18 184-191 BCC2
24 BF40 192-222 BE22
25 BF68 -------
26 BF92 -------
27 BFB8 -------
BFE2 - THE END OF THE VIDEO MEMORY IS HERE - 














#endif


