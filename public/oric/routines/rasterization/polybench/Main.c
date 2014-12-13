#include    "lib.h"

// --------------------------------------
//   PolyBench
// --------------------------------------
// (c) 2003-2014 Mickael Pointier.
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
// Note: This text was typed with a Win32
// editor. So perhaps the text will not be
// displayed correctly with other OS.

// Bench Results:
// Date      |Comment                                        Size | Ratio|Performance
// 2008-04-19|PolyBench1:                                         |100.0%|3871 3407 3546                      <- PolyBench 1
// 2008-04-19|Moving X0,Y0,X1,Y1 to zero page:                    | 99.5%|3852 3389 3527 3557 3693 3747 3639
// 2008-04-19|Moving FlagFirst, OddEvenFlag to zero page:         | 99.3%|3844 3382 3519 3550 3684 3739 3630
// 2008-04-20|Optimized the clearing of scanlines:                | 83.4%|3230 2769 2906 2937 3071 3127 3017  <- PolyBench 2
// 2008-04-20|Cleaned the C part, removing useless things:        | 83.3%|3228 2767 2904 2936 3069 3125 3015
// 2008-04-20|Fixed some 16 bits adds using bcc               7502| 82.4%|3193 2738 2871 2906 3034 3092 2980
// 2008-04-20|Used a unrolled drawing loop plus jump table        | 81.6%|3160 2729 2873 2867 3032 3051 2974
// 2008-04-21|Used a 8 bit offset table and self modified jmp 7758| 80.8%|3131 2706 2848 2841 3004 3024 2949
// 2008-04-21|Improved the main loop - odd/even test is faster    | 80.0%|3100 2681
// 2008-04-21|Change ddetection code for single/multiple byte     | 79.9%|3095 2678 2814
// 2008-04-21|Inner loop fits in the BCC jump range :D            | 79.5%|3079 2665 2801 2798 2953
// 2008-04-21|Removed useless register reloading                  | 79.2%|3067 2655 2789 2788 2941 2965 2885
// 2008-04-21|Replaced LDA $xxxx,y/TAX by LDX $xxxx,y             | 78.7%|3050 2641 2775 2775 2925 2950 2868
// 2008-04-21|Improved pattern management                         | 78.7%|3049 2640 2774 2774 2924 2949 2868  <- PolyBench 3
// 2014-12-13|Testing again... after 6 years :)                   | 78.7%|3048 2638 2771 2771 2921 2947 2866
// 2014-12-13|Avoided some pointless clc and sec                  | 78.4%|3038 2631 2762 2763 2910 2939 2858
// 2014-12-13|Used DX as an unsigned 8bit value                   | 78.3%|3031 2623 2754 2758 2902 2928 2846
// 2014-12-13|Used the direction test to compute the width        | 76.9%|2977 2577 2708 2706 2856 2878 2806


// ---- Externs
extern	unsigned char	RandomValue;
extern	void		GetRand();
extern	void	_InitTables();

extern	unsigned char	X0;
extern	unsigned char	Y0;
extern	unsigned char	X1;
extern	unsigned char	Y1;

extern	void AddLineASM();
extern	void FillTablesASM();
extern	void ClearAndSwapFlag();
extern	void ComputeDivMod();



#define RAND_MAX    255
#define NB_TRI		3
#define SPEED		4

					
unsigned char   x[3*NB_TRI];
unsigned char   y[3*NB_TRI];
char			ix[3*NB_TRI];
char			iy[3*NB_TRI];

unsigned int	CurrentPattern=0;




int random(unsigned int value)
{
    GetRand();
    return RandomValue&3;
}


void AddTriangle(unsigned char x0,unsigned char y0,unsigned char x1,unsigned char y1,unsigned char x2,unsigned char y2,unsigned char pattern)
{
    X0=x0;
    Y0=y0;
    X1=x1;
    Y1=y1;
    AddLineASM();
    X0=x0;
    Y0=y0;
    X1=x2;
    Y1=y2;
    AddLineASM();
    X0=x2;
    Y0=y2;
    X1=x1;
    Y1=y1;
    AddLineASM();

    CurrentPattern=pattern<<3;
    FillTablesASM();
}


void main()
{
	int				delay;
    unsigned char   pattern;
    unsigned char   i,j;

    char	    flag=1;

	paper(1);
	ink(4);
	hires();
	paper(4);
	ink(3);

	printf("PolyBench\n");
	
    ComputeDivMod();
    InitTables();


	//
	// Initialise triangles
	//
    j=0;
    for (i=0;i<NB_TRI;i++)
    {
		x[0+j]=120;
		y[0+j]=80;
		x[1+j]=80;
		y[1+j]=140;
		x[2+j]=200;
		y[2+j]=120;

		ix[0+j]=2;
		iy[0+j]=1;
		ix[1+j]=-1;
		iy[1+j]=+3;
		ix[2+j]=+1;
		iy[2+j]=-2;

		j+=3;
    }


	//
	// Move the triangles around the screen
	//
    while (1)
    {
		*(unsigned int*)0x276=0;

		delay=200;
		
		while (delay--)
		{	    
			ClearAndSwapFlag();
	
			j=0;
			for (i=0;i<NB_TRI;i++)
			{
				AddTriangle(x[0+j],y[0+j],x[1+j],y[1+j],x[2+j],y[2+j],(i&3));
				j+=3;
			}
	
			for (i=0;i<3*NB_TRI;i++)
			{
				x[i]+=ix[i];
				y[i]+=iy[i];
				if (x[i]>220)   ix[i]=-random(SPEED);
				if (x[i]<20)    ix[i]=random(SPEED);
				if (y[i]>195)   iy[i]=-random(SPEED);
				if (y[i]<4)		iy[i]=random(SPEED);
			}
		}
		
		delay=65536-(*(unsigned int*)0x276);
		printf(" %d",delay);
		
    }
}



