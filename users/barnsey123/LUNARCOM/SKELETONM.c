/*
Male Skeleton Movie
16-02-2014 started work
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
#define FRAMEWIDTH 9
#define FRAMEHEIGHT 129
#define FRAMECOUNT 1
/* Definition of Global variables */
extern unsigned char SKELETONM00[];	
extern unsigned char SKELETONM01[];		
extern unsigned char SKELETONM02[];	
extern unsigned char SKELETONM03[];
extern unsigned char SKELETONM04[];		
extern unsigned char SKELETONM05[];		 
extern unsigned char SKELETONM06[];		
extern unsigned char SKELETONM07[];		
extern unsigned char SKELETONM08[];	

extern unsigned char SKELETONM09[];	
extern unsigned char SKELETONM10[];		
extern unsigned char SKELETONM11[];	
extern unsigned char SKELETONM12[];		
extern unsigned char SKELETONM13[];		 
extern unsigned char SKELETONM14[];	
extern unsigned char SKELETONM15[];		
extern unsigned char SKELETONM16[];	
extern unsigned char SKELETONM17[];		
extern unsigned char SKELETONM18[];		 
extern unsigned char SKELETONM19[];	
	 
	 


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
	InkColor=RED; VideoInkLeft();	// set ink to right of video
	//PauseTime=900;
	for(;;){
		PlayVideo();
	}
}


/* Definition of Functions */

void PlayVideo(){
  MaxFrame=MAXFRAME; // this gets reset at end of PlayChunk so can be freely changed
  PlayChunk(SKELETONM00);
  PlayChunk(SKELETONM01);
  PlayChunk(SKELETONM02);
  PlayChunk(SKELETONM03);
  PlayChunk(SKELETONM04); 
  PlayChunk(SKELETONM05);
  PlayChunk(SKELETONM06);
  PlayChunk(SKELETONM07);
  PlayChunk(SKELETONM08);
  
  PlayChunk(SKELETONM09);
  PlayChunk(SKELETONM10);
  PlayChunk(SKELETONM11);
  PlayChunk(SKELETONM12); 
  PlayChunk(SKELETONM13);
  PlayChunk(SKELETONM14);
  PlayChunk(SKELETONM15);
  PlayChunk(SKELETONM16);
  PlayChunk(SKELETONM17); 
  PlayChunk(SKELETONM18);
  PlayChunk(SKELETONM19);

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




