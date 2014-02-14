/*
Femal Skeleton Movie
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
#define FRAMEWIDTH 14
#define FRAMEHEIGHT 192
#define FRAMECOUNT 1
/* Definition of Global variables */
extern unsigned char SKELETONF00[];	
extern unsigned char SKELETONF01[];		
extern unsigned char SKELETONF02[];	
extern unsigned char SKELETONF03[];
extern unsigned char SKELETONF04[];		
extern unsigned char SKELETONF05[];		 
extern unsigned char SKELETONF06[];		
extern unsigned char SKELETONF07[];		
extern unsigned char SKELETONF08[];	

extern unsigned char SKELETONF09[];	
extern unsigned char SKELETONF10[];		
extern unsigned char SKELETONF11[];	
extern unsigned char SKELETONF12[];		
extern unsigned char SKELETONF13[];		 
extern unsigned char SKELETONF14[];		
	 
	 


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
  PlayChunk(SKELETONF00);
  PlayChunk(SKELETONF01);
  PlayChunk(SKELETONF02);
  PlayChunk(SKELETONF03);
  PlayChunk(SKELETONF04); 
  PlayChunk(SKELETONF05);
  PlayChunk(SKELETONF06);
  PlayChunk(SKELETONF07);
  PlayChunk(SKELETONF08);
  
  PlayChunk(SKELETONF09);
  PlayChunk(SKELETONF10);
  PlayChunk(SKELETONF11);
  PlayChunk(SKELETONF12); 
  PlayChunk(SKELETONF13);
  PlayChunk(SKELETONF14);

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




