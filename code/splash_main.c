//
// EncounterHD - Game Splash sequence
// (c) 2020-2024 Dbug / Defence Force
//

#include <lib.h>

#include "common.h"
#include "score.h"


#ifdef ENABLE_MUSIC
extern char JingleMusic[];
#endif


#ifdef PRODUCT_TYPE_TEST_MODE
//
// System testing code
//
char gMenuKeyOption;
void HandleSettingsMenu() {}
#include "system_testing.c"
#else
//
// Normal splash screen
//
extern unsigned char LabelPicture0[2960];
extern unsigned char LabelPicture1[2960];
extern unsigned char LabelPicture2[2960];
extern unsigned char LabelPicture3[2960];
extern unsigned char LabelPicture4[2960];
extern unsigned char LabelPicture5[2960];

extern unsigned char *DistorterTable[6];

extern unsigned char CosTable[];         // Originally contains non signed values, from 0 to 255

extern DrawPreshiftLogos();


extern unsigned char  angle;
extern unsigned char  angle2;
extern unsigned char  angle3;
extern unsigned char  angle4;
extern unsigned char  y;
extern unsigned char  position;
extern unsigned char stopMoving;

extern unsigned char height;
extern unsigned char startPosition;
extern unsigned int frameCount;

extern unsigned char* ptrSrc;
extern unsigned char* ptrDst;
extern unsigned char* ptrDstBottom;

extern int offset;
extern int sourceOffset;
extern int verticalSourceOffset;
extern int maxVerticalSourceOffset;

extern unsigned char* Copy38Source;
extern unsigned char* Copy38Target;
extern unsigned char* Erase38Target;

extern void Copy38Bytes();
extern void Erase38Bytes();

extern void CheckOptionMenuInput();

//BUILD_MARKER


enum
{
    MENU_KEYBOARD_LAYOUT    = 0,
    MENU_AUDIO_SETTINGS     = 1,
    MENU_JOYSTICK_INTERFACE = 2,
};

char ShouldQuit = 0;
char UsedMenu = 0;
char MenuShouldDraw = 1;
char gMenuKeyOption = 0;
char gAudioSelection = AUDIO_SILENT;
int MenuPosition = MENU_KEYBOARD_LAYOUT;


extern const char Text_OptionMenu[];
extern const char Text_OptionKeyboard[];
extern const char Text_Azerty[];
extern const char Text_Qwerty[];
extern const char Text_Qwertz[];

extern const char Text_OptionAudio[];
extern const char Text_OptionJoystick[];

extern const char* gJoystickOptionsArray[];
extern const char* gAudioOptionsArray[];

void ApplySettings()
{
    if (gMusicEnabled)
    {
        MusicMixerMask = 1+2+4;
#ifdef ENABLE_MUSIC
        PlayMusic(1+2+4+8+16+32,JingleMusic);
#endif    
    }
    else
    {
        MusicMixerMask = 0;
        PsgStopSound();
    }
    OsdkJoystickType = gJoystickType;
    joystick_type_select();
}



void HandleSettingsMenu()
{
    gPrintWidth=38;
    gPrintPos = 0;
    SetLineAddress((char*)0xbb80+40*25+1);

    switch (gMenuKeyOption)
    {   
    case KEY_SPACE:
    case KEY_RETURN:
        ShouldQuit = 1;
        break;

    case KEY_UP:
        MenuPosition--;
        if (MenuPosition<0)
        {
            MenuPosition=2;
        }       
        MenuShouldDraw = 1;
        UsedMenu = 1;
        break;

    case KEY_DOWN:
        MenuPosition++;
        if (MenuPosition>2)
        {
            MenuPosition=0;
        }       
        MenuShouldDraw = 1;
        UsedMenu = 1;
        break;
    
    case KEY_LEFT:
    case KEY_RIGHT:
        switch (MenuPosition)
        {
        case MENU_KEYBOARD_LAYOUT:
            if (gMenuKeyOption==KEY_LEFT)
            {
                if (gKeyboardLayout==KEYBOARD_QWERTY) gKeyboardLayout=KEYBOARD_QWERTZ;
                else                                  gKeyboardLayout--;
            }
            else
            {
                if (gKeyboardLayout==KEYBOARD_QWERTZ) gKeyboardLayout=KEYBOARD_QWERTY;
                else                                  gKeyboardLayout++;
            }
            break;

        case MENU_JOYSTICK_INTERFACE:
            do
            {           
                if (gMenuKeyOption==KEY_LEFT)
                {
                    if (gJoystickType==JOYSTICK_INTERFACE_NOTHING)      gJoystickType=JOYSTICK_INTERFACE_DKTRONICS;
                    else                                                gJoystickType--;
                }
                else
                {
                    if (gJoystickType==JOYSTICK_INTERFACE_DKTRONICS)    gJoystickType=JOYSTICK_INTERFACE_NOTHING;
                    else                                                gJoystickType++;
                }
            } 
            while (gJoystickType==JOYSTICK_INTERFACE_TELESTRAT);   // temporary, to avoid freezing the code when selecting the Telestrat
            OsdkJoystickType = gJoystickType;
            joystick_type_select();
            break;
            
        case MENU_AUDIO_SETTINGS:
            if (gMenuKeyOption==KEY_LEFT)
            {
                if (gAudioSelection==AUDIO_SILENT)              gAudioSelection=AUDIO_EFFECTS_AND_MUSIC;
                else                                            gAudioSelection--;
            }
            else
            {
                if (gAudioSelection==AUDIO_EFFECTS_AND_MUSIC)   gAudioSelection=AUDIO_SILENT;
                else                                            gAudioSelection++;
            }
            gMusicEnabled=(gAudioSelection&AUDIO_MUSIC)?1:0;
            gSoundEnabled=(gAudioSelection&AUDIO_EFFECTS)?1:0;
            ApplySettings();
            break;
        }
        MenuShouldDraw=1;
        UsedMenu = 1;
        break;
    }

    if (MenuShouldDraw)
    {
        poke(0xbb80+40*25,(MenuPosition==0)?6:4);
        poke(0xbb80+40*26,(MenuPosition==1)?6:4);
        poke(0xbb80+40*27,(MenuPosition==2)?6:4);

        // Keyboard
        PrintStringAt(Text_OptionKeyboard,(char*)0xbb80+40*25+1);        
        PrintStringAt(
            (gKeyboardLayout==KEYBOARD_QWERTY)?Text_Qwerty:
            (gKeyboardLayout==KEYBOARD_AZERTY)?Text_Azerty:Text_Qwertz
            ,(char*)0xbb80+40*25+21);
                    
        // Audio (Music + Effects)
        PrintStringAt(Text_OptionAudio,(char*)0xbb80+40*26+1);
        PrintStringAt(gAudioOptionsArray[gAudioSelection],(char*)0xbb80+40*26+21);

        // Joystick
        PrintStringAt(Text_OptionJoystick,(char*)0xbb80+40*27+1);
        PrintStringAt(gJoystickOptionsArray[gJoystickType],(char*)0xbb80+40*27+21);

        MenuShouldDraw = 0;
    }
}


// Some quite ugly function which waits a certain number of frames
// while detecting key presses and returns 1 if either space or enter are pressed
int Wait(int frameCount)
{	
	int k;

	while (frameCount--)
	{
		WaitIRQ();

		k=ReadKeyNoBounce();
		if ((k==KEY_RETURN) || (k==' ') || ShouldQuit)
		{
			//PlaySound(KeyClickLData);
			WaitFrames(4);
			return 1;
		}
        gMenuKeyOption=k;
        HandleSettingsMenu();
	}
	return 0;
}


void PatchCosTable()
{
	int x;

	for (x=0;x<256;x++)
	{
		CosTable[x]=(((int)CosTable[x])*3)/255;
	}
}



int ShowLogoAnimation()
{
	int k;

    stopMoving = 0;
    position = startPosition;

    maxVerticalSourceOffset = height*40;

    while (frameCount--)
    {
        ptrSrc=(unsigned char*)LabelPicture0+2;
        ptrDst=(unsigned char*)0xa000+(125-position)*40+2;
        ptrDstBottom=(unsigned char*)0xa000+(125+position/2)*40;

        angle2=angle;
        angle3=angle;
        angle4=angle;
        angle+=5;

        sourceOffset=0;

        for (y=0;y<position;y++)
        {
            if (!stopMoving)
            {
                if (y<height)
                {
                    Copy38Source = ptrSrc;
                    Copy38Target = ptrDst;
                    Copy38Bytes();
                }
                else
                {
                    Erase38Target = ptrDst;
                    Erase38Bytes();
                }
            }
            if (y&1)
            {
                offset=CosTable[angle2&255]+CosTable[angle3&255];
                verticalSourceOffset=CosTable[angle4&255]*40;

                if ((y<height) && ((sourceOffset+verticalSourceOffset)<maxVerticalSourceOffset) ) 
                {
                    Copy38Source = DistorterTable[offset]+sourceOffset+2+verticalSourceOffset;
                    Copy38Target = ptrDstBottom+2;
                    Copy38Bytes();
                }
                else
                {
                    Erase38Target = ptrDstBottom+2;
                    Erase38Bytes();
                }
                sourceOffset+=80;
                ptrDstBottom-=40;

                angle2+=5;
                angle3+=7;
                angle4+=11;

            }
            ptrDst+=40;
            ptrSrc+=40;
            CheckOptionMenuInput();
        }
        /*
        if (Wait(1))
        {
            return 1;
        }
        */
		k=ReadKeyNoBounce();
		if ((k==KEY_RETURN) || (k==' ') || ShouldQuit)
		{
			return 1;
		}
        gMenuKeyOption=k;
        HandleSettingsMenu();

        if (position<height+5)
        {
            position++;
        }
        else
        {
            stopMoving=1;
        }
    }
    return 0;
}


void SetupLineColors(unsigned char y,unsigned char paperTop,unsigned char inkTop,unsigned char paperBottom,unsigned char inkBottom)
{
    unsigned char* ptr=(unsigned char*)0xa000+y*40;
    if (y<125)
    {
        // Top half of the screen
        ptr[0]=paperTop;
        ptr[1]=inkTop;
    }
    else
    {
        // Bottom half of the screen (the river where things reflect)
        ptr[0]=paperBottom;
        ptr[1]=inkBottom;
    }
    memset(ptr+2,64,38);
}


int SetupColors(unsigned char paperTop,unsigned char inkTop,unsigned char paperBottom,unsigned char inkBottom)
{
    int y,spacing;
    for (spacing=16;spacing>=1;spacing>>=1)
    {
        for (y=0;y<200;y+=spacing)
        {
            SetupLineColors(y,paperTop,inkTop,paperBottom,inkBottom);
            CheckOptionMenuInput();
        }
        if (Wait(spacing/2))
        {
            return 1;
        }
    }
    return 0;
}



int DisplayLogosWithPreshift()
{
	Hires(16+0,4);

    memset((char*)0xa000,64,8000);

    PatchCosTable();

    do
    {
        // Scroll the Servern Software up the river: Logo is 51 lines tall, from line 97 to 147
        if (SetupColors(16+0,7,16+4,6))       return 1;
        memcpy(LabelPicture0,ImageBuffer+97*40,51*40);
        DrawPreshiftLogos();
        height        = 51;
        startPosition = 0;
        frameCount    = 90;
        if (ShowLogoAnimation())      return 1;


        // Scroll the Defence Force logo up the river: Logo is 74 lines tall, from line 5 to 78
        if (SetupColors(16+7,0,16+4,0))       return 1;
        memcpy(LabelPicture0,ImageBuffer+5*40,74*40);
        DrawPreshiftLogos();
        height        = 74;
        startPosition = 74+5;
        frameCount    = 60;
        if (ShowLogoAnimation())   return 1;
    }
    while (UsedMenu);  // If the user did not use the menu, we quit after one loop, else we stay there

    return 0;
}


extern const char* gLoadingMessagesArray[];

void main()
{
	// Load the charset
	//LoadFileAt(LOADER_FONT_6x8,0x9900);              // Art Deco font
	LoadFileAt(LOADER_FONT_TYPEWRITER_6x8,0x9900);     // Typewriter font

	// Load the first picture at the default address specified in the script
	LoadFileAt(INTRO_PICTURE_LOGOS,ImageBuffer);

	// Load the highscores from the disk
	LoadFileAt(LOADER_HIGH_SCORES,&gSaveGameFile);
    // Make sure the achievements are copied to high memory
    memcpy(gAchievements,gSaveGameFile.achievements,ACHIEVEMENT_BYTE_COUNT);
    gKeyboardLayout = gSaveGameFile.keyboard_layout;
    gMusicEnabled   = gSaveGameFile.music_enabled;
    gSoundEnabled   = gSaveGameFile.sound_enabled;
#ifdef FORCE_JOYSTICK
    gJoystickType   = FORCE_JOYSTICK;
#else    
    gJoystickType   = gSaveGameFile.joystick_interface;
#endif    
    if (gSoundEnabled)  gAudioSelection|=AUDIO_EFFECTS;
    if (gMusicEnabled)  gAudioSelection|=AUDIO_MUSIC;
    ApplySettings();

	// Install the IRQ so we can use the keyboard
	System_InstallIRQ_SimpleVbl();

    // Display the Severn Software and Defence Force logos
	DisplayLogosWithPreshift();

    // Clear the screen
    SetupColors(16+0,7,16+0,6);
    
    // Ensure that the screen is erased even if the player pressed a key
    memset((char*)0xa000,64,8000);
    memset((char*)0xbb80+40*25,32,40*3);

	System_RestoreIRQ_SimpleVbl();
#ifdef ENABLE_MUSIC
    EndMusic();
#endif    
    PsgStopSoundAndForceUpdate();

    // Show some informative message for the player to patient during loading
    gPrintWidth = 40;
    gPrintTerminator=0;    
    PrintStringAt(gLoadingMessagesArray[gSaveGameFile.launchCount&3],(char*)0xbb80+40*25);

    // Increment the launch count and save back the scores
    gSaveGameFile.launchCount++;
    memcpy(gSaveGameFile.achievements,gAchievements,ACHIEVEMENT_BYTE_COUNT);
    gSaveGameFile.keyboard_layout    = gKeyboardLayout;
    gSaveGameFile.music_enabled      = gMusicEnabled;
    gSaveGameFile.sound_enabled      = gSoundEnabled;
    gSaveGameFile.joystick_interface = gJoystickType;

    SaveFileAt(LOADER_HIGH_SCORES,&gSaveGameFile);

	// Quit and return to the loader
	InitializeFileAt(LOADER_INTRO_PROGRAM,LOADER_INTRO_PROGRAM_ADDRESS);   // 0x400
}

#endif
