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
extern unsigned char LabelPicture1[2960];
extern unsigned char LabelPicture2[2960];
extern unsigned char LabelPicture3[2960];
extern unsigned char LabelPicture4[2960];
extern unsigned char LabelPicture5[2960];

extern unsigned char DistorterTableLo[6];
extern unsigned char DistorterTableHi[6];
#define GenerateLogoPreshifts(p)  { param0.ptr=(p); DistorterTableLo[0]=param0.uchars[0]; DistorterTableHi[0]=param0.uchars[1];asm("jsr _GenerateLogoPreshiftsAsm"); }

extern unsigned char ShowLogoAnimation();
extern void GenerateTables();
extern void Clear38Columns();

extern unsigned char setupColorsPaper[2];   // [0]=top half, [1]=bottom half
extern unsigned char setupColorsInk[2];     // [0]=top half, [1]=bottom half

#define SetupColors(pT,iT,pB,iB)          (setupColorsPaper[0]=(pT),setupColorsInk[0]=(iT),setupColorsPaper[1]=(pB),setupColorsInk[1]=(iB),SetupColorsAsm())
#define SetupColorsAnimated(pT,iT,pB,iB)  (setupColorsPaper[0]=(pT),setupColorsInk[0]=(iT),setupColorsPaper[1]=(pB),setupColorsInk[1]=(iB),SetupColorsAnimatedAsm())

extern unsigned char angle;
extern unsigned char height;
extern unsigned char position;
extern unsigned char frameCount;

extern void CheckOptionMenuInput();


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


int DisplayLogosWithPreshift()
{
	Hires(16+0,4);

    memset((char*)0xa000,64,8000);

    GenerateTables();    // patches CosTable in place, then derives _CosTableTimes40 from it

    HandleSettingsMenu();  // Make sure the menu is present from the start
    do
    {
        // Scroll the Servern Software up the river: Logo is 51 lines tall, from line 97 to 147
        if (SetupColors(16+0,7,16+4,6))             return 1;
        GenerateLogoPreshifts(ImageBuffer+97*40);
        height        = 53;
        position      = 0;
        frameCount    = 200;
        if (ShowLogoAnimation())                    return 1;
        if (SetupColorsAnimated(16+7,7,16+4,4))     return 1;
        Clear38Columns();

        // Scroll the Defence Force logo up the river: Logo is 74 lines tall, from line 5 to 78
        GenerateLogoPreshifts(ImageBuffer+5*40);
        height        = 73;
        position      = 74+5;
        frameCount    = 100;
        if (SetupColors(16+7,0,16+4,0))             return 1;        
        if (ShowLogoAnimation())                    return 1;
        if (SetupColorsAnimated(16+7,7,16+4,4))     return 1;
        Clear38Columns();
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
    gMonkeyKingSlowBestScoreBCD = gSaveGameFile.monkey_king_score_slow;
    gMonkeyKingFastBestScoreBCD = gSaveGameFile.monkey_king_score_fast;
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

    // If the user presses SHIFT we reset the achievements
    if ( (KeyBank[4]|KeyBank[7])&16 )  // Left/Right shift
    {
       gSaveGameFile.launchCount = 0;
       memset(gSaveGameFile.achievements,0,ACHIEVEMENT_BYTE_COUNT);
    }

    SaveFileAt(LOADER_HIGH_SCORES,&gSaveGameFile);

	// Quit and return to the loader
	InitializeFileAt(LOADER_INTRO_PROGRAM,&ModuleStartText);
}

#endif
