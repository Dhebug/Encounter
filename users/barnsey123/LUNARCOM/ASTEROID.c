/*
Asteroid Movie
11-02-2014 started work
*/
#include <lib.h>
#define BLACK 0
#define RED	1
#define GREEN 2
#define YELLOW 3
#define BLUE 4
#define MAGENTA 5
#define CYAN 6
#define WHITE 7
#define MAXFRAME 1
#define FRAMEWIDTH 40
#define FRAMEHEIGHT 200
#define FRAMECOUNT 1
/* Definition of Global variables */
extern unsigned char FlyOver00[];	
extern unsigned char FlyOver01[];		
extern unsigned char FlyOver02[];	
extern unsigned char FlyOver04[];		
extern unsigned char FlyOver05[];		 
extern unsigned char FlyOver06[];		
extern unsigned char FlyOver07[];		
extern unsigned char FlyOver08[];	

extern unsigned char FlyOver09[];	
extern unsigned char FlyOver10[];		
extern unsigned char FlyOver11[];	
extern unsigned char FlyOver12[];		
extern unsigned char FlyOver13[];		 
extern unsigned char FlyOver14[];		
extern unsigned char FlyOver15[];		
extern unsigned char FlyOver16[];	

extern unsigned char FlyOver17[];	
extern unsigned char FlyOver18[];		
extern unsigned char FlyOver19[];	
extern unsigned char FlyOver20[];		
extern unsigned char FlyOver21[];		 
extern unsigned char FlyOver22[];		
extern unsigned char FlyOver23[];		
extern unsigned char FlyOver24[];	

extern unsigned char FlyOver25[];	
extern unsigned char FlyOver26[];		
extern unsigned char FlyOver27[];	
extern unsigned char FlyOver28[];		
extern unsigned char FlyOver29[];		 
extern unsigned char FlyOver30[];		
extern unsigned char FlyOver31[];		
extern unsigned char FlyOver32[];	

extern unsigned char FlyOver33[];		
extern unsigned char FlyOver34[];

unsigned char UnPack[FRAMEWIDTH*FRAMEHEIGHT*FRAMECOUNT]; // where the image data gets unpacked to
unsigned char Frame, MaxFrame;	// Frame of video to play up to MaxFrame
//int PauseTime,PauseCount;			// amount of time to Pause
unsigned char* PtrGraphic;			// pointer to byte values of picture
unsigned char* PtrUnPack;			// pointer to byte values of unpacked picture
unsigned char InkColor;
/* Listing of Functions */
//void Pause();		// adds pause to video playback
void PlayChunk(unsigned char Chunk[]);	// play part of video
void PlayVideo();	// play all video

/****************/
/* Main Program */
/****************/
void main(){
	hires();
	InkColor=CYAN; VideoInkLeft();	// set ink to right of video
	//PauseTime=900;
	for(;;){
		PlayVideo();
	}
}


/* Definition of Functions */

void PlayVideo(){
  MaxFrame=MAXFRAME; // this gets reset at end of PlayChunk so can be freely changed
  PlayChunk(FlyOver00);
  PlayChunk(FlyOver01);
  PlayChunk(FlyOver02);
  PlayChunk(FlyOver04); 
  PlayChunk(FlyOver05);
  PlayChunk(FlyOver06);
  PlayChunk(FlyOver07);
  PlayChunk(FlyOver08);
  
  PlayChunk(FlyOver09);
  PlayChunk(FlyOver10);
  PlayChunk(FlyOver11);
  PlayChunk(FlyOver12); 
  PlayChunk(FlyOver13);
  PlayChunk(FlyOver14);
  PlayChunk(FlyOver15);
  PlayChunk(FlyOver16);
  
  PlayChunk(FlyOver17);
  PlayChunk(FlyOver18);
  PlayChunk(FlyOver19);
  PlayChunk(FlyOver20); 
  PlayChunk(FlyOver21);
  PlayChunk(FlyOver22);
  PlayChunk(FlyOver23);
  PlayChunk(FlyOver24);
  
  PlayChunk(FlyOver25);
  PlayChunk(FlyOver26);
  PlayChunk(FlyOver27);
  PlayChunk(FlyOver28); 
  PlayChunk(FlyOver29);
  PlayChunk(FlyOver30);
  PlayChunk(FlyOver31);
  PlayChunk(FlyOver32);
  
  PlayChunk(FlyOver33);
  PlayChunk(FlyOver34);
}

// Chunk[] contains packed data (e.g Yabber.s)
void PlayChunk(unsigned char Chunk[]){
	PtrUnPack=UnPack;				// set the pointer to UnPack (destination of unpacked data)
	file_unpack(PtrUnPack,Chunk);	// Unpack gets populated with unpacked Chunk
	// Play frames sequentually
	//for (Frame=0;Frame<MaxFrame; Frame++){
		PtrGraphic=UnPack;			// point to start of unpack
		DrawFrame();				// PtrGraphic and Frame used in this ASM function
		//Pause();					// Stop frames playing too fast
	//}
	// Play Frames in reverse order
	/*for (Frame=MaxFrame-1;Frame>0;Frame--){
		PtrGraphic=UnPack;			// point to start of unpack
		DrawFrame();				// PtrGraphic and Frame used in this ASM function
		Pause();					// Stop frames playing too fast
	}*/
	//MaxFrame=MAXFRAME;				// reset MaxFrame to be default value
}
/*
void Pause(){
  for (PauseCount=0; PauseCount<PauseTime;PauseCount++){};
}*/




