/*
Asteroid2 Movie
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
#define FRAMEWIDTH 38
#define FRAMEHEIGHT 155
#define FRAMECOUNT 1
/* Definition of Global variables */
extern unsigned char ASTEROID200[];	
extern unsigned char ASTEROID201[];		
extern unsigned char ASTEROID202[];	
extern unsigned char ASTEROID203[];
extern unsigned char ASTEROID204[];		
extern unsigned char ASTEROID205[];		 
extern unsigned char ASTEROID206[];		
extern unsigned char ASTEROID207[];		
extern unsigned char ASTEROID208[];	

extern unsigned char ASTEROID209[];	
extern unsigned char ASTEROID210[];		
extern unsigned char ASTEROID211[];	
extern unsigned char ASTEROID212[];		
extern unsigned char ASTEROID213[];		 
extern unsigned char ASTEROID214[];		
extern unsigned char ASTEROID215[];		
extern unsigned char ASTEROID216[];	

extern unsigned char ASTEROID217[];	
extern unsigned char ASTEROID218[];		
extern unsigned char ASTEROID219[];	
extern unsigned char ASTEROID220[];		
extern unsigned char ASTEROID221[];		 
	 


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
  PlayChunk(ASTEROID200);
  PlayChunk(ASTEROID201);
  PlayChunk(ASTEROID202);
  PlayChunk(ASTEROID203);
  PlayChunk(ASTEROID204); 
  PlayChunk(ASTEROID205);
  PlayChunk(ASTEROID206);
  PlayChunk(ASTEROID207);
  PlayChunk(ASTEROID208);
  
  PlayChunk(ASTEROID209);
  PlayChunk(ASTEROID210);
  PlayChunk(ASTEROID211);
  PlayChunk(ASTEROID212); 
  PlayChunk(ASTEROID213);
  PlayChunk(ASTEROID214);
  PlayChunk(ASTEROID215);
  PlayChunk(ASTEROID216);
  
  PlayChunk(ASTEROID217);
  PlayChunk(ASTEROID218);
  PlayChunk(ASTEROID219);
  PlayChunk(ASTEROID220); 
  PlayChunk(ASTEROID221);
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




