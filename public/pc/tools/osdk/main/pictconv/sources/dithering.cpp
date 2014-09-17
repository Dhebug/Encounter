

#include "dithering.h"


//
// 16 bits suffisent � rajouter +1/0 pour une composante aux coordonn�es (x,y)
// Il faut 8 valeurs 16 bits pour r�cup�rer la partie de poids faible
//
unsigned short	DitherMask[9];
//unsigned char	DitherTable[16*2][256];


void ComputeDitherMask(long position,const char *chaine)
{
	unsigned short value=0;
	for (long i=0;i<16;i++)
	{
		if (chaine[i]!=' ')
		{
			value|=(1<<i);
		}
	}
	DitherMask[position]=value;
}



void GenerateDitherTable()
{
	//
	// Calcule les masques de tramage
	//
	ComputeDitherMask(0,"                ");
	ComputeDitherMask(1,"X         X     ");
	ComputeDitherMask(2,"X X     X X     ");
	ComputeDitherMask(3,"X X  X  X X    X");
	ComputeDitherMask(4,"X X  X XX X  X X");
	ComputeDitherMask(5,"X XX X XXXX  X X");
	ComputeDitherMask(6,"XXXX X XXXXX X X");
	ComputeDitherMask(7,"XXXX XXXXXXXXX X");
	ComputeDitherMask(8,"XXXXxXXXXXXXXXxX");
}
