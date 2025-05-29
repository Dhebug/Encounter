
#include "params.h"

#include "loader_api.h"


#define assert(expression)   if (!(expression)) { Panic(); }

// Irq
extern void System_InstallIRQ_SimpleVbl();
extern void System_RestoreIRQ_SimpleVbl();
extern void WaitIRQ();
extern void Panic();                         // Stop the program while blinking the bottom right corner with psychedelic colors

extern unsigned char VblCounter;

// Keyboard
extern char WaitKey();
extern char ReadKey();
extern char ReadKeyNoBounce();
extern void SetKeyboardLayout();    // Apply the content of gKeyboardLayout to the keyboard handler

extern char gKeyboardLayout;        // QWERTY / AZERTY / QWERTZ
extern unsigned char KeyBank[8]; // .dsb 8   ; The virtual Key Matrix

// Time
extern unsigned char TimeMillisecond;        // Actual value in milliseconds
extern unsigned char TimeHours;              // One hour digit ready to be printed (ASCII format not numerical value)
extern unsigned char TimeMinutes[2];         // Two minutes digits ready to be printed (ASCII format not numerical value)
extern unsigned char TimeSeconds[2];         // Two seconds digits ready to be printed (ASCII format not numerical value)
extern unsigned char TimeOut;                // One hour digit ready to be printed (ASCII format not numerical value)

// Display
extern void PrintFancyFont();
extern void DrawFilledRectangle();
extern void DrawVerticalLine();
extern void DrawHorizontalLine();
extern void BlitRectangle();

extern void ByteStreamCommandBUBBLE();

extern unsigned char ImageBuffer[];          // 240x128 compositing buffer, used to mix together the scene image, frame, arrows, etc...
extern unsigned char SecondImageBuffer[];    // Second 240x128 buffer
extern char gFlagDirections;                 // Bit flag containing all the possible directions for the current scene (used to draw the arrows on the scene)
extern char gSevenDigitDisplay[];            // Bitmap to redefine a few characters so they look like an old style watch drawn with LED or LCD segments
extern char gFont12x14[];                    // The 12x14 italics font
extern unsigned char gFont12x14Width[];      // Width (in pixel) of each of the characters in the fancy font
extern unsigned char gTableModulo6[];        // Given a X value, returns the value modulo 6 (used to access the proper pixel in a graphical block)
extern unsigned char gTableDivBy6[];         // Given a X value, returns the value divided by 6 (used to locate the proper byte in a scanline)
extern unsigned char gTableMulBy40Low[];     // Given a x value, returns the low byte of the value multiplied by 40 (used to locate the proper scanline)
extern unsigned char gTableMulBy40High[];    // Given a x value, returns the high byte of the value multiplied by 40 (used to locate the proper scanline)
extern unsigned char gShiftBuffer[];         // Used to display graphics at any arbitrary position instead of on multiples of 6
extern unsigned char gBitPixelMask[];        // Bitmap with each possible combination of pixel to mask to draw a vertical line
extern unsigned char gBitPixelMaskLeft[];    // Bitmap with each possible left endings - used to draw horizontal segments
extern unsigned char gBitPixelMaskRight[];   // Bitmap with each possible right endings - used to draw horizontal segments

extern unsigned char* gStatusMessageLocation;  // Where the prompt and error messages are displayed
extern unsigned char* gDrawAddress;
extern unsigned char* gDrawSourceAddress;
extern unsigned char* gDrawPatternAddress;
extern const char* gDrawExtraData;
extern unsigned char gDrawPosX;
extern unsigned char gDrawPosY;
extern unsigned char gDrawWidth;
extern unsigned char gDrawHeight;
extern unsigned char gDrawPattern;
extern unsigned char gSourceStride;

extern unsigned char gCurrentSpriteSheetIndex;  // Index of the currently loaded "sprite" image
extern unsigned char gCurrentMusicFileIndex;    // Index of the currently loaded music file

// Audio
#ifdef ENABLE_SOUND_EFFECTS
#define PlaySound(registerList)         { param0.ptr=registerList;asm("jsr _PlaySoundAsm"); }
#else
#define PlaySound(registerList)         { }
#endif

#ifdef ENABLE_MUSIC
#define PlayMusic(mixer,music)                { param0.ptr=music;MusicMixerMask=mixer;asm("jsr _StartMusic"); }
#else
#define PlayMusic(mixer,music)                { }
#endif

extern const char* SoundDataPointer;
extern unsigned char PsgPlayPosition;
extern unsigned char PsgPlayLoopIndex;
extern unsigned char MusicLoopIndex;    // Just a simple counter incrementing each time a new pattern starts
extern unsigned char MusicEvent;        // Value from the event track for the music

extern char PsgNeedUpdate;
extern char PsgVirtualRegisters[];
extern char ExplodeData[];
extern char ShootData[];
extern char PingData[];                 // Used in the typewriter sequence
extern char ZapData[];
extern char KeyClickHData[];
extern char KeyClickLData[];
extern char TypeWriterData[];
extern char SpaceBarData[];
extern char ScrollPageData[];
extern char WatchBeepData[];
extern char VroomVroom[];
extern char EngineRunning[];
extern char WatchButtonPress[];
extern char WaterDrip[];
extern char FlickeringLight[];
extern char BirdChirp1[];
extern char BirdChirp2[];
extern char Acid[];
extern char FuseBurningStart[];
extern char FuseBurning[];
extern char ErrorPlop[];
extern char Pling[];
extern char AlarmLedBeeping[];
extern char DoorOpening[];
extern char DoorClosing[];
extern char Swoosh[];
extern char Snore[];
//extern char DogGrowling[];    // Work in progress - not happy

extern unsigned int PsgfreqA;
extern unsigned int PsgfreqB;
extern unsigned int PsgfreqC;
extern unsigned char PsgfreqNoise;
extern unsigned char Psgmixer;
extern unsigned char PsgvolumeA;
extern unsigned char PsgvolumeB;
extern unsigned char PsgvolumeC;
extern unsigned int PsgfreqShape;
extern unsigned char PsgenvShape;

extern unsigned char MusicMixerMask;

//#define BUILD_MARKER  const char gBuildMarker[] = "Build ID: " VERSION " " __DATE__ " at " __TIME__;

// Common
#define SetLineAddress(address)            { gPrintAddress=address; }
#define PrintStringAt(message,address)     { param0.ptr=message;gPrintAddress=(char*)address;gPrintPos=0;asm("jsr _PrintStringInternal"); } 
#define PrintString(message)               { param0.ptr=message;asm("jsr _PrintStringInternal"); } 

#define UnlockAchievement(assignment)      { param0.uchar=assignment;asm("jsr _UnlockAchievementAsm"); }

#define Text(paperColor,inkColor)          { param0.uchar=paperColor;param0.uchars[1]=inkColor;asm("jsr _TextAsm"); }
#define Hires(paperColor,inkColor)         { param0.uchar=paperColor;param0.uchars[1]=inkColor;asm("jsr _HiresAsm"); }

char KeywordCompare(); // Fill param0.ptr=first;param1.ptr=second; first, returns in X
extern const char* gKeywordString;

union ParamType
{
    unsigned char uchar;        // One single byte
    unsigned char uchars[2];    // Array of two bytes
    unsigned int uint;          // One 16 bit value
    const void* ptr;            // One pointer
};

extern union ParamType param0;
extern union ParamType param1;
extern union ParamType param2;

#define WaitFrames(frames)                 { param0.uint=frames;asm("jsr _WaitFramesAsm"); }
#define PrintStatusMessage(color,message)  { param0.ptr=message;param1.uchar=color;asm("jsr _PrintStatusMessageAsm"); } 
#define PrintInformationMessage(message)   { param0.ptr=message;asm("jsr _PrintInformationMessageAsm"); } 
#define PrintErrorMessage(message)         { param0.ptr=message;asm("jsr _PrintErrorMessageAsm"); } 
#define PrintErrorMessageShort(message)    { param0.ptr=message;asm("jsr _PrintErrorMessageShortAsm"); } 

extern char gIsHires;
extern char* gPrintAddress;
extern unsigned char gPrintWidth;
extern unsigned char gPrintPos;
extern unsigned char gPrintLineTruncated;
extern unsigned char gPrintTerminator;
extern unsigned char gShowHighlights;
extern unsigned char gPrintRemovePrefix;
extern unsigned char TemporaryBuffer479[479];   // Can be used for temporary operations, like flicker free inventory update

// game_misc
extern void HandleByteStream();
#define SetByteStream(frames)                 { gCurrentStream=frames;gDelayStream=0; }
#define PlayStream(byteStream)                { param0.ptr=byteStream;asm("jsr _PlayStreamAsm"); }
#define DispatchStream(streamTable,id)        { param0.uchar=id;param1.ptr=streamTable;asm("jsr _DispatchStream"); }
#define DispatchStream2(streamTable,id1,id2)  { param0.uchar=id1;param1.ptr=streamTable;param2.uchar=id2;asm("jsr _DispatchStream2"); }
 
#define ClearMessageWindow(paperColor)        { param0.uchar=paperColor;asm("jsr _ClearMessageWindowAsm"); }
#define ClearMessageAndInventoryWindow(paperColor) { param0.uchar=paperColor;asm("jsr _ClearMessageAndInventoryWindow"); }


#define DrawRectangleOutline(xPos,yPos,width,height,fillValue)  { param0.uchar=xPos;param0.uchars[1]=yPos;param1.uchar=width;param1.uchars[1]=height;param2.uchar=fillValue;asm("jsr _DrawRectangleOutlineAsm"); }


extern void InitializeGraphicMode();

extern const char* gCurrentStream;
extern char gCurrentStreamStop;
extern unsigned int gDelayStream;
extern char gStreamCutScene;
extern const char* gStreamSkipPoint;

#ifdef ENABLE_DEBUG_TEXT
#define DEBUG_TEXT(text)   { sprintf((char*)0xbb80+40*27,"%c%s(%d): %s%c",16+1,  __FILE__ , __LINE__ , text, 1); }
#else
#define DEBUG_TEXT(text)   
#endif

// settings
extern char gMusicEnabled;          // 0 or 255
extern char gSoundEnabled;          // 0 or 255
extern char gJoystickType;          // See enum in lib.h (0=JOYSTICK_INTERFACE_NOTHING, ijk/pase/telestrat/opel/dktronics)
extern unsigned int gMonkeyKingSlowBestScoreBCD;    // minigame high score (BCD format)
extern unsigned int gMonkeyKingSlowSessionBest;     // Best score of the player in that session (normal format)
extern unsigned int gMonkeyKingFastBestScoreBCD;    // minigame high score (BCD format)
extern unsigned int gMonkeyKingFastSessionBest;     // Best score of the player in that session (normal format)


// game_text
extern char gDescriptionDarkTunel[];
extern char gDescriptionMarketPlace[];
extern char gDescriptionDarkAlley[];
extern char gDescriptionRoad[];
extern char gDescriptionMainStreet[];
extern char gDescriptionNarrowPath[];
extern char gDescriptionInThePit[];
extern char gDescriptionTarmacArea[];
extern char gDescriptionOldWell[];
extern char gDescriptionWoodedAvenue[];
extern char gDescriptionGravelDrive[];
extern char gDescriptionZenGarden[];
extern char gDescriptionFrontLawn[];
extern char gDescriptionGreenHouse[];
extern char gDescriptionTennisCourt[];
extern char gDescriptionVegetableGarden[];
extern char gDescriptionFishPond[];
extern char gDescriptionTiledPatio[];
extern char gDescriptionAppleOrchard[];
extern char gDescriptionEntranceHall[];
extern char gDescriptionLibrary[];
extern char gDescriptionNarrowPassage[];
extern char gDescriptionEntranceLounge[];
extern char gDescriptionDiningRoom[];
extern char gDescriptionGamesRoom[];
extern char gDescriptionSunLounge[];
extern char gDescriptionKitchen[];
extern char gDescriptionNarrowStaircase[];
extern char gDescriptionCellar[];
extern char gDescriptionDarkerCellar[];
extern char gDescriptionStaircase[];
extern char gDescriptionMainLanding[];
extern char gDescriptionEastGallery[];
extern char gDescriptionChildBedroom[];
extern char gDescriptionGuestBedroom[];
extern char gDescriptionShowerRoom[];
extern char gDescriptionWestGallery[];
extern char gDescriptionBoxRoom[];
extern char gDescriptionClassyBathRoom[];
extern char gDescriptionTinyToilet[];
extern char gDescriptionMasterBedRoom[];
extern char gDescriptionPadlockedRoom[];
extern char gDescriptionOutsidePit[];
extern char gDescriptionStudyRoom[];
