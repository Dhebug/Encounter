
#include "lib.h"



//
// From 'display.s'
//
void RotateBitMask();
void DrawAtmos();
void DrawGradientSlice();
void Drawstars();

extern unsigned char RainbowWave[16];
extern unsigned char RainbowNewOffset;
extern unsigned char RainbowOffsets[16];
extern unsigned char WaveOffset;
extern unsigned char GradientRainbow[48+4];
extern unsigned char BitMask;

extern unsigned char* ptr_src;
extern unsigned char* ptr_dst;
extern unsigned char start_offset;
extern unsigned char start_position;
extern unsigned char draw_size;

//
// From 'digiplayer.s'
//
void DigiPlayer_InstallIrq();
void WaitSync();

extern unsigned char vbl_counter;


void TeletypeUpdate();


//
// From 'pic_atmos.s'
//
extern unsigned char Atmos96x68[];	// 17*66=1088

extern unsigned char DefenceForceLogo[];


void DrawRainbow()
{
	if (start_offset<15)
	{
		char x,y;
		unsigned char* screenLine;
		unsigned char bitmask;
	
		screenLine=(unsigned char*)0xa000+39;
		screenLine+=(100-30)*40;
			
		bitmask=BitMask;
		x=16-start_offset;
		do
		{
			ptr_dst=screenLine;				
		    ptr_dst+=RainbowOffsets[x-1];
		    RainbowOffsets[x-1]=RainbowOffsets[x-2];
		    
			if (bitmask&1)
			{
				ptr_dst+=40*1;
			}
			if (x&1)
			{
				bitmask>>=1;
			}
			
			DrawGradientSlice();
			/*
			ptr_src=GradientRainbow;
			for (y=0;y<48+16;y++)
			{
				*ptr_dst=*ptr_src++;
				ptr_dst+=40;
			}
			*/
			screenLine--;
			x--;
		}	
		while (x!=0);
	}
}


void ShowLogo()
{
	unsigned char i,j;
	
	// Appear
	for (i=0;i<100;i++)
	{
		memcpy((char*)0xa000+i*40,DefenceForceLogo+i*40,40);
		memcpy((char*)0xa000+(199-i)*40,DefenceForceLogo+(199-i)*40,40);
		for (j=0;j<250;j++)
		{
		}
	}
	
	// Disappear
	for (i=0;i<100;i++)
	{
		memset((char*)0xa000+i*40,64,40);
		*((char*)0xa000+i*40)=16+6;
		memset((char*)0xa000+(199-i)*40,64,40);
		*((char*)0xa000+(199-i)*40)=16+6;
		for (j=0;j<250;j++)
		{
		}
	}
	
}


void main()
{
	paper(0);
	ink(0);
	hires();
	
	ShowLogo();
		
	ScrollerInit();
		
	//
	// Install the irq handler
	//
    DigiPlayer_InstallIrq();
	
	start_offset=31;
	draw_size=2;
	while (1)
	{
		TeletypeUpdate();
		ScrollerDisplay();
		
		RainbowNewOffset=RainbowWave[WaveOffset];
		if (BitMask&1)
		{
			RainbowNewOffset+=40*1;
		}		
		start_position=RainbowNewOffset+start_offset;
		
		Drawstars();
		DrawRainbow();
		DrawAtmos();
		
		RotateBitMask();
		
		if (start_offset)
		{
			start_offset--;
			if (draw_size<17)
			{
				draw_size++;
			}
		}		
		//WaitSync();	
    }
}




