
#include    "lib.h"


extern unsigned char	Texture[256*64];
extern char				TabCos[256];



#include "angle.c"
#include "prof.c"

unsigned char  IncX;
unsigned char  IncY;




void RotoZoom()
{
	int		value_1;
	int		value_2;
	
	while (1)
	{
		DisplayTunel();
	
		IncX+=2+TabCos[value_1]>>4;
		IncY+=2+TabCos[value_2]>>4;
	
		value_1+=1;
		value_2+=2;
	}
}





void main()
{
    unsigned int    y;
    
    for (y=0;y<40*100;y++)
    {
		angle[y]&=31;
    }
    
    hires();

    RotoZoom();
}



