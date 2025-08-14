**Scripting**

Some games have hardcoded logic, some are completely data-driven, Encounter is somewhat in-between, with most of the player actions directly coded in normal language, while the scenes themselves use a tiny scripting system designed to be memory efficient


- [Features](#features)
  - [The concept](#the-concept)
  - [Benefits](#benefits)
    - [Portability](#portability)
    - [Size](#size)
    - [Dynamic loading](#dynamic-loading)
  - [Disadvantages](#disadvantages)
    - [A new syntax to learn](#a-new-syntax-to-learn)
    - [Worse performance](#worse-performance)
    - [Wonky syntax](#wonky-syntax)
  - [Types of scripts](#types-of-scripts)
    - [Location scripts](#location-scripts)
    - [Action scripts](#action-scripts)
    - [Scene Preload Script](#scene-preload-script)
- [Commands](#commands)
  - [Delays](#delays)
    - [WAIT](#wait)
    - [WAIT\_RANDOM](#wait_random)
    - [SET\_CUT\_SCENE](#set_cut_scene)
    - [WAIT\_KEYPRESS](#wait_keypress)
  - [Flow Control (Static)](#flow-control-static)
    - [END](#end)
    - [END\_AND\_REFRESH](#end_and_refresh)
    - [END\_AND\_PARTIAL\_REFRESH](#end_and_partial_refresh)
    - [JUMP](#jump)
    - [DO\_ONCE](#do_once)
    - [CALL\_NATIVE](#call_native)
    - [GOSUB](#gosub)
    - [RETURN](#return)
    - [SET\_SKIP\_POINT](#set_skip_point)
  - [Flow Control (Dynamic)](#flow-control-dynamic)
    - [JUMP\_IF\_TRUE](#jump_if_true)
    - [JUMP\_IF\_FALSE](#jump_if_false)
    - [IF\_TRUE](#if_true)
    - [IF\_FALSE](#if_false)
    - [CHECK\_ITEM\_LOCATION](#check_item_location)
    - [CHECK\_ITEM\_FLAG](#check_item_flag)
    - [CHECK\_ITEM\_CONTAINER](#check_item_container)
    - [CHECK\_PLAYER\_LOCATION](#check_player_location)
  - [Providing information to the player](#providing-information-to-the-player)
    - [INFO\_MESSAGE](#info_message)
    - [QUICK\_MESSAGE](#quick_message)
    - [ERROR\_MESSAGE](#error_message)
    - [CLEAR\_TEXT\_AREA](#clear_text_area)
    - [CLEAR\_FULL\_TEXT\_AREA](#clear_full_text_area)
  - [Items management](#items-management)
    - [SET\_CURRENT\_ITEM](#set_current_item)
    - [SET\_ITEM\_LOCATION](#set_item_location)
    - [SET\_ITEM\_FLAGS](#set_item_flags)
    - [UNSET\_ITEM\_FLAGS](#unset_item_flags)
    - [SET\_ITEM\_DESCRIPTION](#set_item_description)
  - [Location management](#location-management)
    - [SET\_PLAYER\_LOCATION](#set_player_location)
    - [SET\_LOCATION\_DIRECTION](#set_location_direction)
    - [SET\_SCENE\_IMAGE](#set_scene_image)
  - [Scoring and achievements](#scoring-and-achievements)
    - [UNLOCK\_ACHIEVEMENT](#unlock_achievement)
    - [INCREASE\_SCORE](#increase_score)
    - [DECREASE\_SCORE](#decrease_score)
    - [GAME\_OVER](#game_over)
    - [START\_CLOCK](#start_clock)
    - [STOP\_CLOCK](#stop_clock)
  - [Graphic stuff](#graphic-stuff)
    - [DISPLAY\_IMAGE](#display_image)
    - [DISPLAY\_IMAGE\_ONLY](#display_image_only)
    - [DISPLAY\_IMAGE\_NOBLIT](#display_image_noblit)
    - [DRAW\_BITMAP](#draw_bitmap)
  - [Audio](#audio)
    - [PLAY\_SOUND](#play_sound)
    - [LOAD\_MUSIC](#load_music)
    - [STOP\_MUSIC](#stop_music)

# Features

The main feature of the scripts is to populate the scene images with the proper content, like speech bubles and items, or draw the game-over sequence, but also to handle in a memory efficient way the most common actions the player can do (like use an item, read something, etc...)

The [location](locations.md) structure contains a **script** field with a pointer to a script executed each time a scene is drawn.

## The concept

A script is just a sequence of commands, a byte stream really, with a final "end" command.

A stream is launched with the **PlayStream** function, and the bytecode execute all the commands immediately until it either reach the end of the stream or encounter a "Wait" instruction, this basically is the equivalent of having a "setup" phase followed by some more stuff happening later.

Typically the setup will be in charge of checking the state of the game to draw and print different elements depending of the context, and the rest will be these description bubbles which appear over time to make the game "more alive" than a standard text adventure game.

Scripts can also loop and branch, basic conditions are supported.

## Benefits

Obviously an interpreted byte stream will never run as fast as native assembler (or even C) code, but there are some valid reasons to do that: 

### Portability

If all the game logic is written in assembler (a logical choice when targeting a retro computer), it requires a lot of effort to port to a different architecture (say from 6502 to Z80). 

When using a scripting system, you just need to convert the "code interpreter" and if that's done properly, the scripts will run just fine on the new target without requiring any change.

### Size

Obviously the various instructions used by the scripting system need to be implemented, so the code comes with a fixed price, but the idea is that this cost is amortized as soon as a specific command is used more than once.

Let see an example with the "increase score" command.

First we have two bytes used in the dispatcher to map each of the commands opcodes to the function that is going to perform the operation.

```c
_ByteStreamCallbacks
    .word _ByteStreamCommandEnd
    (...)
    .word _ByteStreamCommandIncreaseScore
```

Then obviously we have the code that perform the operation, which in this case is just "getting the next byte" which contains the value we want to add to the score (a 16bit variable in normal memory), and finally move the stream pointer to the next instruction, which is a grand total of 24 bytes.

```c
; .byt COMMAND_INCREASE_SCORE,points
_ByteStreamCommandIncreaseScore
.(
    ldy #0
    lda (_gCurrentStream),y             // Number of points
    clc
    adc _gScore+0                       // Add to existing score
    sta _gScore+0

    lda #0
    adc _gScore+1
    sta _gScore+1

    lda #1                              // Move the stream pointer by one byte
    jmp _ByteStreamMoveByA
.)
```

Then when we use this code in the scripts, it's just two bytes:

```c
  INCREASE_SCORE(42)   // Expands to .byt COMMAND_INCREASE_SCORE,42
```

If we ever only use this instruction once, the total cost is:

- 2 bytes for the table entry
- +24 bytes for the implementation
- +2 bytes for the script instance
- = 28 bytes

How much would cost a single instance in C?

```c
   gScore+=50;   // Add 50 points to the player score
```

Well, it's a 16 bit variable to which we add a 8 bit value, and generally the code gets converted to this:

```c
    clc
    lda _gScore+0
    adc #50                   // Add to existing score
    sta _gScore+0
    lda _gScore+1
    adc #0
    sta _gScore+1
```

which is a grand total of 17 bytes instead of 28, and also runs much faster.

What about if we wanted to increment the score twice?

- Script version: (2+24)+2*2 = 30 bytes
- Normal code: 17*2 = 34 bytes

So we just need TWO uses to already start gaining memory compared to the normal code.

The situation get better if we try to use a subfunction to perform the addition, but we have to use the registers to pass the parameters, using the stack would take much more room:

```c
  lda #50                     //  2 bytes
  jsr AddToScore              // +3 bytes = 5 bytes

AddToScore
    clc                       // 1
    adc _gScore+0             // 3
    sta _gScore+0             // 3
    lda _gScore+1             // 3
    adc #0                    // 2
    sta _gScore+1             // 3
    rts                       // 1 = 16 bytes
```

Which gives us:

- 16+5=21 bytes for the first call (which beats the 2+24+2=28 for the script)
- 16+5*2=26 for the second call (which beats the (2+24)+2*2=30 for the script)
- 16+5*3=31 for the second call (which beats the (2+24)+2*3=32 for the script)
- 16+5*4=36 for the second call (which does not beats the (2+24)+2*4=34 for the script)

The score adding is a best case scenario for the native code because there is only one value to pass, the 6502 only has three registers, so for more complicated situations we would have to use some proper parameter passing methods, either by filling a structure or pushing on the stack... and in no way would the result be more compact than what the script provides.

### Dynamic loading

This is not used in Encounter, but technically the scripts could easily be loaded from disk with the scenes, which would solve the problems coming with the limited amount of memory on the machine.

The reason why this could be done is that the data is directly placed as parameters of the instructions instead of using pointers, so for example all the string messages are directly embedded in the script, which means no searching, linking or relocating is required.

## Disadvantages

Of course it's not all rainbows and unicorns, scripting languages have their issues as well.

### A new syntax to learn

Probably obvious, but by definition it's a new language that nobody else knows, so there's some kind of barrier to entry.

The trick is to design something called DSL (Domain Specific Language) instead of a general purpose language: You do not want or need a complete set of operations, you just need what is necessary to implement what you game logic needs, ideally by implementing big expressive instructions with a simple syntax.

For example, instead of allowing the user to acquire a pointer or reference to an entity that can then be manipulated, instead you can implement instructions that can directly act on the most important properties of an entity.

Where in Encounter's scripting language you have to do this:

```c
  // Change the location of the ladder
  SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_OUTSIDE_PIT)
```  

in a more classical language you would find something like that:

```c
  // Change the location of the ladder
  item=GetItem(e_ITEM_Ladder)
  item.SetLocation(e_LOC_OUTSIDE_PIT)
```  

One could argue that the second style is much more powerful (it is), but it's also much more complex and does not promote consistency of style, because you could must probably have done that as well:

```c
  // Change the location of the ladder
  GetItem(e_ITEM_Ladder).SetLocation(e_LOC_OUTSIDE_PIT)
```  

I find a simple boring language that does not afford a lot of flexibility, does not have life time consideration, memory allocation, etc... easier to use when writing scripts.

### Worse performance

Since the script is parsed byte by byte, the execution is definitely slower than native code, but contrary to BASIC, it's not a general purpose language where you execute time critical loops and arithmetic operations... all the script does is to execute now and then series of meta instructions that does a lot of things, which events out the cost of the parsing. 

### Wonky syntax

I could have written a proper syntax, then a compiler to generate the code, but I've already spent too much time doing some tooling, so instead it's all implemented with pre-processor macros.

But technically it could have been done with a real tool, so it's just something I need to deal with and get the game out!

## Types of scripts

Technically, all the scripts can use all the commands, but there are three main use cases for scripts:

### Location scripts

Each of the in-game [location](locations.md) has an associated script pointer, which in Encounter is used to display the description bubbles, draw relevant items in the scene, or check for game-over conditions.

Let's examine two of the first locations, the **market place** and the **dark tunel**, these are defined like that in the [game_data.c](../code/game_data.c):

```c
location gLocations[e_LOC_COUNT_] =
{ 
  { // e_LOC_MARKETPLACE     
    e_LOC_DARKTUNNEL,      // Location to the North
    e_LOC_NONE,            // Location to the South
    e_LOC_DARKALLEY,       // Location to the East
    e_LOC_NONE,            // Location to the West
    e_LOC_NONE,            // Location going up
    e_LOC_NONE,            // Location going down
    gDescriptionMarketPlace     // Script
  },         
  { // e_LOC_DARKTUNNEL 
    e_LOC_WOODEDAVENUE,    // Location to the North
    e_LOC_MARKETPLACE,     // Location to the South
    e_LOC_NONE,            // Location to the East
    e_LOC_NONE,            // Location to the West
    e_LOC_NONE,            // Location going up
    e_LOC_NONE,            // Location going down
    gDescriptionDarkTunel       // Script
  },
  (...)
}
```

The dark tunel script is the simplest one, it just shows some text bubbles commenting about the scene:

```c
_gDescriptionDarkTunel
    WAIT(DELAY_FIRST_BUBBLE)         // Wait about a quarter of a second
    WHITE_BUBBLE(2)                  // This bubble has two line entries
#ifdef LANGUAGE_FR                   // Line entries for the French version
    _BUBBLE_LINE(4,4,0,"Un tunnel ordinaire: sombre,")
    _BUBBLE_LINE(4,13,1,"humide et inquiétant.")
#else                                // Line entries for other versions (English is default)
    _BUBBLE_LINE(4,4,0,"Like most tunnels: dark, damp,")
    _BUBBLE_LINE(4,13,1,"and somewhat scary.")
#endif    
    END                              // End of script
```

To provide some cartoony feeling, the game is using the scripting system to display some messages over time.

Delays are done with the **WAIT** instruction, while the **WHITE_BUBBLE** (or **BLACK_BUBBLE**) and **_BUBBLE_LINE** are used to display the text bubbles.

```c
#define COMMAND_WHITE_BUBBLE nn
#define COMMAND_BLACK_BUBBLE nn

#define WHITE_BUBBLE(bubble_count)           .byt COMMAND_WHITE_BUBBLE,bubble_count
#define BLACK_BUBBLE(bubble_count)           .byt COMMAND_BLACK_BUBBLE,bubble_count
#define _BUBBLE_LINE(x,y,yoffset,text)       .byt x,y,yoffset,text,0
```

When running the game, when the tunnel location is accessed, the player will see the following:

![Images of the Dark Tunnel, with the speech bubble in English and French](images/scripting_location_dark_tunnel.png)

Because of the END instruction, this script stops there and is not active anymore, but a script does not have to finish, in which case it will keep running in the background until the player moves to another location or some internal flags ends up impacting the script flow.

The market place script is more complex and shows a blinking neon sign[^1] done by updating the graphics on the scene, waiting a bit, updating graphics again, looping, etc...

```c
_gDescriptionMarketPlace
    WAIT(DELAY_FIRST_BUBBLE)         // Wait about a quarter of a second
    WHITE_BUBBLE(2)                  // This bubble has two line entries
#ifdef LANGUAGE_FR                   // Line entries for the French version    
    _BUBBLE_LINE(4,100,0,"La place du marché")
    _BUBBLE_LINE(4,106,4,"est désertée")
#else                                // Line entries for other versions (English is default)
    _BUBBLE_LINE(4,100,0,"The market place")
    _BUBBLE_LINE(4,106,4,"is deserted")
#endif    
blinky_shop                          // Label
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(8,11),40,_SecondImageBuffer+(40*116)+32,$a000+(14*40)+11)    // Draw the Fish Shop "grayed out"
    WAIT(50)                         // Wait one second
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(8,11),40,_SecondImageBuffer+(40*104)+32,$a000+(14*40)+11)    // Draw the Fish Shop "fully drawn"
    WAIT(50)                         // Wait one second
    JUMP(blinky_shop)                // Jump to the label
```

Which will result in the following sequence:

![Blinking Neon Sign](images/scripting_location_blinking_sign.gif)

The system does not support moving objects, but it's good enough for things that change state or cycling animations.

### Action scripts

Action scripts are triggered when the player do some explicit action like using an object, looking at something, etc...

Some of the actions done by the player, like reading the newspaper, or looking at the map in the library result in the game loading a fullscreen image, then show some comments about the action.

Here is a very simple script which shows a picture of a newspaper with somme comments, if the player decides to read it

```c
_gSceneActionReadNewsPaper
    DISPLAY_IMAGE(LOADER_PICTURE_NEWSPAPER,"The Daily Telegraph, September 29th")
    INFO_MESSAGE("I have to find her fast...")
    WAIT(50*2)
    INFO_MESSAGE("...I hope she is fine!")
    WAIT(50*2)
    END_AND_REFRESH
```

And here is what that looks like in the game.

![Reading newspaper](images/scripting_newspaper.png)

Actions can also trigger other scripts, change variables, move things around, etc... 

### Scene Preload Script

The game requires a script called **_ScenePreLoadScript** which will be systematically executed from the LoadScene function in the game:

```C
void LoadScene()
{
  gCurrentLocationPtr = &gLocations[gCurrentLocation];
  gSceneImage = LOADER_PICTURE_LOCATIONS_START+gCurrentLocation;

  // Run the Scene "preload" script
  PlayStream(ScenePreLoadScript);              <----

  // Set the byte stream pointer
  SetByteStream(gCurrentLocationPtr->script);

  ClearMessageWindow(16+4);

  LoadFileAt(gSceneImage,ImageBuffer);	
  (...)
}
```

The purpose of this script is to do book-keeping and adjustments independently of where the player is located, and even move the player around automatically.

In Encounter this is used to simply have the victim follow the player around after she's been freed:

```c
// This is a script that is run before the setup of a scene is done.
// In the current status it is used to get the girl to follow us
_ScenePreLoadScript
.(
    // If the girl is "attached" we move her to the playe current location
    JUMP_IF_FALSE(end_girl_following,CHECK_ITEM_FLAG(e_ITEM_YoungGirl,ITEM_FLAG_ATTACHED))
        SET_ITEM_LOCATION(e_ITEM_YoungGirl,e_LOC_CURRENT)
end_girl_following
    END
.)
```

You could also use that to run events independently of where the player is, trigger random events, etc...

# Commands

The commands are all defined in [scripting.h](../code/scripting.h) and implemented in [bytestream.s](../code/bytestream.s) and most of them use references to locations and item ids defined in [game_enums.h](../code/game_enums.h).

```C
#define BLOCK_SIZE(w,h) w,h

// Command opcodes
#define COMMAND_RECTANGLE       1
#define COMMAND_FILL_RECTANGLE  2
#define COMMAND_TEXT            3
#define COMMAND_FADE_BUFFER     8
#define _COMMAND_COUNT          24
```

## Delays 

Sometimes you want to pause the game, or add delays for dramatic effects.

### WAIT

```c
#define COMMAND_WAIT nn
#define WAIT(duration)    .byt COMMAND_WAIT,duration
```

Two bytes command containing the COMMAND_WAIT opcode, followed by the number of frames.

To provide some pacing, delays can be used to interrupt the execution of a script for a period of time.

The delays are encoded as frame numbers on a single byte, which means the maximum duration of a delay is about 5 seconds. 
If you need a longer delay, just put a few more delay instructions.

```c
  // Wait one second (50 frames)
  WAIT(50)
```

### WAIT_RANDOM

```c
#define COMMAND_WAIT_RANDOM nn
#define WAIT_RANDOM(base_duration,rand_mask)  .byt COMMAND_WAIT_RANDOM,base_duration,rand_mask
```

Three bytes command containing the COMMAND_WAIT_RANDOM opcode, followed by the minimum number of frames to wait, plus a modulo random mask.

In Encounter this command is mostly used in background scripts that do animation, to provide a more organic feeling, like the buzzing and flickering light bulb in the dirty alley or the birds chirping in the woods.

```c
blinky_light_bulb
  PLAY_SOUND(_FlickeringLight)
  // Draw the bright light
  BLIT_BLOCK(LOADER_SPRITE_ITEMS,4,11)                     
    _IMAGE(28,117)
    _SCREEN(4,37)
  WAIT_RANDOM(5,15)
  // Draw the non working (dark) light
  BLIT_BLOCK(LOADER_SPRITE_ITEMS,4,11)                     
    _IMAGE(28,106)
    _SCREEN(4,37)  
  WAIT_RANDOM(10,255)
  JUMP(blinky_light_bulb)
```

### SET_CUT_SCENE

```c
#define COMMAND_SET_CUT_SCENE nn
#define SET_CUT_SCENE(flag)                  .byt COMMAND_SET_CUT_SCENE,flag
```

Two bytes command containing the COMMAND_SET_CUT_SCENE opcode, followed by a either 0 or 1.

When the cut scene mode is enabled, the script interpreter does not give the control back to the player during the WAIT instructions.

In Encounter this used in the end game sequences.


```c
  // Make it so the player can't exit the sequence by entering commands or pressing keys
  SET_CUT_SCENE(1)
  (...)
  SET_CUT_SCENE(0)
```

### WAIT_KEYPRESS

```c
#define COMMAND_WAIT_KEYPRESS
#define WAIT_KEYPRESS       .byt COMMAND_WAIT_KEYPRESS
```

One byte command containing the COMMAND_WAIT_KEYPRESS opcode.

If you actually need to know which key was pressed, you can just directly read the _gInputKey variable value using CHECK_ADDRESS_VALUE.

```c
  // Wait for the user to press a key
  COMMAND_WAIT_KEYPRESS
  IF_TRUE(CHECK_ADDRESS_VALUE(_gInputKey,KEY_RETURN),confirmation)
      // Do something
  ENDIF(confirmation)
```

---

## Flow Control (Static)

The following commands are related to the lifetime of script and how it flows around when executing code.

### END

```c
#define COMMAND_END nn
#define END             .byt COMMAND_END
```

Just a single byte containing the COMMAND_END opcode. 
This signals the end of the script.

```c
  // End of script
  END
```

### END_AND_REFRESH

```c
#define COMMAND_END_AND_REFRESH nn
#define END_AND_REFRESH           .byt COMMAND_END_AND_REFRESH
```

Similar to END, except it also forces the entire scene to refresh.
Generally used when the player perform actions resulting in items being modified or moved.

```c
  // End of script (and triggers a full refresh)
  END_AND_REFRESH
```

### END_AND_PARTIAL_REFRESH

```c
#define COMMAND_END_AND_PARTIAL_REFRESH nn
#define END_AND_PARTIAL_REFRESH           .byt COMMAND_END_AND_PARTIAL_REFRESH
```

Similar to END, except it also forces the text area (including the inventory) to refresh

Generally used when the player perform actions resulting in items being modified or moved.

```c
  // End of script (and triggers a partial refresh of the screen)
  END_AND_PARTIAL_REFRESH
```

### JUMP

```c
#define COMMAND_JUMP nn
#define JUMP(label)     .byt COMMAND_JUMP,<label,>label
```

Three bytes command containing the COMMAND_JUMP opcode, followed by the address of the script locations where to jump.

```c
  // Jumps to the 'dog_growls' label
  JUMP(dog_growls)
  (...)
dog_growls
```

### DO_ONCE

```c
#define COMMAND_DO_ONCE nn
#define DO_ONCE(label)     .byt COMMAND_DO_ONCE,1,<label,>label
#define ENDDO(enddo)              enddo
```

Three bytes command containing the COMMAND_DO_ONCE opcode, followed by the address of the script locations where to jump.

This command basically implements a self destructing code sequence: The first time the script reaches the DO_ONCE it executes its content, but it also self modifies the script from DO_ONCE to JUMP, so the code block will be skipped any other time it is reached.

The ENDDO command is not technically necessary, all it does is to write the label, but it allows having nicely symmetrical blocks of code.

```c
// Print the "Thank you" message (only once)
DO_ONCE(thank_you)
  WHITE_BUBBLE(1)
  #ifdef LANGUAGE_FR   
    _BUBBLE_LINE(12,50,0,"Merci !")
  #else
    _BUBBLE_LINE(12,50,0,"Thank you!")
  #endif   
ENDDO(thank_you)
```

### CALL_NATIVE

```c
#define COMMAND_CALL_NATIVE nn
#define CALL_NATIVE(address)     .byt COMMAND_CALL_NATIVE,<address,>address
```

Three bytes command containing the COMMAND_CALL_NATIVE opcode, followed by the address of a native function.

In Encounter this is used in two locations, once to reset the Oric back to BASIC, and also to launch the minigame.

```c
  QUICK_MESSAGE("RESET...")
  CALL_NATIVE(_Reset)
```

### GOSUB

```c
#define COMMAND_GOSUB nn
#define GOSUB(label)      .byt COMMAND_GOSUB,<label,>label
```

Three bytes command containing the COMMAND_GOSUB opcode, followed by the address of the script locations where to jump.

Important: There is no callstack, only one GOSUB level is supported. The subfunction does not need to return, it can call any of the END_ commands.

```c
  // Calls the '_SubCollateralDamage' function and comes back after
  GOSUB(_SubCollateralDamage)
  (...)

_SubCollateralDamage
  RETURN
```


### RETURN

```c
#define COMMAND_RETURN nn
#define RETURN                .byt COMMAND_RETURN
```

One byte command containing the COMMAND_RETURN opcode.

Important: There is no callstack, only one GOSUB level is supported to only one RETURN level will work.

```c
  // Calls the '_SubCollateralDamage' function and comes back after
  GOSUB(_SubCollateralDamage)
  (...)

_SubCollateralDamage
  RETURN
```

### SET_SKIP_POINT

```c
#define COMMAND_SET_SKIP_POINT nn
#define SET_SKIP_POINT(label)                .byt COMMAND_SET_SKIP_POINT,<label,>label
```

Three bytes command containing the COMMAND_SET_SKIP_POINT opcode, followed by the address of a script locations.

In Encounter this command is used to allow the player to skip the intro sequence by pressing a key.

```c
  SET_SKIP_POINT(end_intro_sequence)

  (...)

end_intro_sequence        
```


## Flow Control (Dynamic)

The following instructions require an operator to evaluate if the condition is true or false. There are two functionally equivalent ways of doing conditionals:

- JUMP_IF_TRUE and JUMP_IF_FALSE are similar to assembly language conditional branches
- IF_TRUE and IF_FALSE are similar to higher level languages and support ELSE and ENDIF

### JUMP_IF_TRUE

```c
#define COMMAND_JUMP_IF_TRUE nn
#define JUMP_IF_TRUE(label,expression)       .byt COMMAND_JUMP_IF_TRUE,<label,>label,expression
```

Seven bytes command containing the COMMAND_JUMP_IF_TRUE opcode, followed by the address of the script locations where to jump, followed by a 3 bytes expression evaluated at run time.

```c
  // Jump to the label 'around_the_pit' if the expression is true
  JUMP_IF_TRUE(around_the_pit,/*<check expression>*/)
  (...)
around_the_pit    
```

### JUMP_IF_FALSE

```c
#define COMMAND_JUMP_IF_FALSE nn
#define JUMP_IF_FALSE(label,expression)      .byt COMMAND_JUMP_IF_FALSE,<label,>label,expression
```

Seven bytes command containing the JUMP_IF_FALSE opcode, followed by the address of the script locations where to jump, followed by a 3 bytes expression evaluated at run time.

```c
  // Jump to the label 'around_the_pit' if the expression is false
  JUMP_IF_FALSE(around_the_pit,/*<check expression>*/)
  (...)
around_the_pit    
```

It is possible to use combinations of JUMP_IF_TRUE and JUMP_IF_FALSE to handle more complex scenarios, it's not super elegant but it works just fine.

In this example we check if the rope is present outside of the pit, if it is not we jump to the 'no_rope' label, else we check if the rope has the 'attached' flag set, and if true we jump to the 'rope_attached_to_tree' label.

```c
  // Is there a rope?
  JUMP_IF_FALSE(no_rope,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOC_OUTSIDE_PIT))
  // Ok there is a rope, but is it attached to the tree?
  JUMP_IF_TRUE(rope_attached_to_tree,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
no_rope    
  JUMP(digging_for_gold);     // Generic message if the ladder or rope are not present
rope_attached_to_tree    
  (...)
digging_for_gold
```

### IF_TRUE

```c
#define COMMAND_JUMP_IF_FALSE nn
#define IF_TRUE(expression,label)     .byt COMMAND_JUMP_IF_FALSE,<label,>label,expression
#define ELSE(else,endif)              else = *+3: .byt COMMAND_JUMP,<endif,>endif  
#define ENDIF(endif)                  endif                                           
```

Seven bytes command containing the COMMAND_JUMP_IF_FALSE opcode, followed by the address of the script locations where to jump, followed by a 3 bytes expression evaluated at run time.

The reason for the weird syntax is that the "language" is just some preprocessor trickery, so the user needs to pass labels to where to jump for the else and endif parts of the construct.

If you want to avoid being creative finding unique names for the labels, the simplest way is to use .( and .) around to create local labels not visible outside the scope.


```c
  // Is the ladder in the cellar?
  IF_TRUE(CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_DARKCELLARROOM),ladder)  
    // Draw the ladder
    BLIT_BLOCK(LOADER_SPRITE_ITEMS,7,87)                     
      _IMAGE(0,40)
      _BUFFER(29,7)
    // Enable the UP direction
    SET_LOCATION_DIRECTION(e_LOC_DARKCELLARROOM,e_DIRECTION_UP,e_LOC_CELLAR_WINDOW)     
  ELSE(ladder,no_ladder)
    // Disable the UP direction
    SET_LOCATION_DIRECTION(e_LOC_DARKCELLARROOM,e_DIRECTION_UP,e_LOC_NONE)              
  ENDIF(no_ladder)
```

### IF_FALSE

```c
#define COMMAND_JUMP_IF_TRUE nn
#define IF_FALSE(expression,label)     .byt COMMAND_JUMP_IF_TRUE,<label,>label,expression
#define ELSE(else,endif)              else = *+3: .byt COMMAND_JUMP,<endif,>endif  
#define ENDIF(endif)                  endif                                           
```

Seven bytes command containing the COMMAND_JUMP_IF_TRUE opcode, followed by the address of the script locations where to jump, followed by a 3 bytes expression evaluated at run time.

The reason for the weird syntax is that the "language" is just some preprocessor trickery, so the user needs to pass labels to where to jump for the else and endif parts of the construct.

If you want to avoid being creative finding unique names for the labels, the simplest way is to use .( and .) around to create local labels not visible outside the scope.

It's possible to have multiple levels of IF/ENDIF as long as they have unique labels.

```c
  // Is the safe door open?
  IF_FALSE(CHECK_ITEM_FLAG(e_ITEM_HeavySafe,ITEM_FLAG_CLOSED),else) 
    // Draw the open damaged door  
    BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,49)                        
      _IMAGE(14,0)
      _BUFFER(20,17)
  ELSE(else,safe_open)
    // Is the bomb installed?
    IF_TRUE(CHECK_ITEM_FLAG(e_ITEM_Bomb,ITEM_FLAG_ATTACHED),bomb)  
      // Draw the bomb attached to the closed door  
      BLIT_BLOCK(LOADER_SPRITE_SAFE_ROOM,3,49)                     
        _IMAGE(17,0)
        _BUFFER(20,17)
    ENDIF(bomb)
  ENDIF(safe_open)
```


---
Here are the operators you can use with JUMP_IF_TRUE, JUMP_IF_FALSE, IF_TRUE or IF_FALSE

### CHECK_ITEM_LOCATION

```c
#define OPERATOR_CHECK_ITEM_LOCATION
#define CHECK_ITEM_LOCATION(item,location)   OPERATOR_CHECK_ITEM_LOCATION,item,location
```

Three bytes operator containing the OPERATOR_CHECK_ITEM_LOCATION opcode, followed by the id of the item to check, and finally the location we want to check.

```c
  /*<conditional jump instruction>*/ CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_OUTSIDE_PIT) 
```

### CHECK_ITEM_FLAG

```c
#define OPERATOR_CHECK_ITEM_FLAG
#define CHECK_ITEM_FLAG(item,flag)           OPERATOR_CHECK_ITEM_FLAG,item,flag
```

Three bytes operator containing the OPERATOR_CHECK_ITEM_FLAG opcode, followed by the id of the item to check, and finally the bit mask to apply.

```c
  /*<conditional jump instruction>*/ CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED)
```

### CHECK_ITEM_CONTAINER

```c
#define OPERATOR_CHECK_ITEM_CONTAINER
#define CHECK_ITEM_CONTAINER(item,container)           OPERATOR_CHECK_ITEM_CONTAINER,item,container
```

Three bytes operator containing the OPERATOR_CHECK_ITEM_CONTAINER opcode, followed by the id of the item to check, and finally the bit mask to apply.

```c
    // If the dove is in the box then we need to free it
    JUMP_IF_TRUE(_DropDove,CHECK_ITEM_CONTAINER(e_ITEM_LargeDove,e_ITEM_CardboardBox))
```

### CHECK_PLAYER_LOCATION

```c
#define OPERATOR_CHECK_PLAYER_LOCATION 
#define CHECK_PLAYER_LOCATION(location)      OPERATOR_CHECK_PLAYER_LOCATION,location
```

Two bytes operator containing the OPERATOR_CHECK_PLAYER_LOCATION opcode, followed by the location we want to check.

```c
  /*<conditional jump instruction>*/ CHECK_PLAYER_LOCATION(e_LOC_INSIDE_PIT)
```


---

## Providing information to the player

### INFO_MESSAGE

```C
#define COMMAND_INFO_MESSAGE nn
#define INFO_MESSAGE(message)                .byt COMMAND_INFO_MESSAGE,message,0
```

Variable number of bytes containing the COMMAND_INFO_MESSAGE opcode, followed by a null terminated string containing the message to display

There is a 150 frames delay (3 seconds) after the message display.

```C
  // Print a message in the main TEXT window
  INFO_MESSAGE("I have to find her fast...")
```

### QUICK_MESSAGE

```C
#define COMMAND_QUICK_MESSAGE nn
#define QUICK_MESSAGE(message)                .byt COMMAND_QUICK_MESSAGE,message,0
```

Variable number of bytes containing the COMMAND_QUICK_MESSAGE opcode, followed by a null terminated string containing the message to display

Contrary to INFO_MESSAGE, there is no delay at all after the display of the text: The typical use case is when a message is to be displayed while an image is being loaded and displayed.

```C
  // Print a message in the main TEXT window
  QUICK_MESSAGE("Oops...")
```

### ERROR_MESSAGE

```C
#define COMMAND_ERROR_MESSAGE nn
#define ERROR_MESSAGE(message)               .byt COMMAND_ERROR_MESSAGE,message,0
```

Similar to INFO_MESSAGE, except it uses the COMMAND_ERROR_MESSAGE opcode and the message is printed out as an error 

```C
  // Print an error message with a sound effect 
  ERROR_MESSAGE("I can't do that")
```  

### CLEAR_TEXT_AREA

```C
#define COMMAND_CLEAR_TEXT_AREA nn
#define CLEAR_TEXT_AREA(paper_color)               .byt COMMAND_CLEAR_TEXT_AREA,16+(paper_color&7)
```

Two bytes command containing the COMMAND_CLEAR_TEXT_AREA opcode, followed by the color to use to clear the area.

The most common use is to use colors to change the mood, like switching to yellow when there is danger, or red when the player fails.

```C
  // Erase the scene description area with red color (inventory is not impacted)
  CLEAR_TEXT_AREA(1)
```  


### CLEAR_FULL_TEXT_AREA

```C
#define COMMAND_CLEAR_FULL_TEXT_AREA nn
#define CLEAR_FULL_TEXT_AREA(paper_color)               .byt COMMAND_CLEAR_FULL_TEXT_AREA,16+(paper_color&7)
```

Two bytes command containing the COMMAND_CLEAR_FULL_TEXT_AREA opcode, followed by the color to use to clear the area.

Contrarily to CLEAR_TEXT_AREA, this command clears the entire bottom area, including the inventory. 

In Encounter it's used at the end when the player wins during the end sequence.

```C
  // Erase the entire bottom area of the game screen, including the player inventory
  CLEAR_FULL_TEXT_AREA(0)
```  


---

## Items management

### SET_CURRENT_ITEM

```C
#define COMMAND_SET_CURRENT_ITEM  nn
#define SET_CURRENT_ITEM(item)              .byt COMMAND_SET_CURRENT_ITEM,item
```  

Two bytes command containing the COMMAND_SET_CURRENT_ITEM opcode, followed by id of the item to set as current.

This is used to change the value of e_ITEM_CURRENT which can then be used to call some generic code usable for different items.

```c
  // Let use the Hose as the current item.
  SET_CURRENT_ITEM(e_ITEM_Hose)
```  

### SET_ITEM_LOCATION

```C
#define COMMAND_SET_ITEM_LOCATION nn
#define SET_ITEM_LOCATION(item,location)        .byt COMMAND_SET_ITEM_LOCATION,item,location
```  

Three bytes command containing the COMMAND_SET_ITEM_LOCATION opcode, followed by id of the item and the location where to move it.

There are a few different types of locations:

- Actual locations in the game (e_LOC_MARKETPLACE, e_LOC_CELLAR, e_LOC_MAINSTREET ...)
- e_LOC_INVENTORY, which represents any item in the player's inventory
- e_LOC_NONE location, used for when an item is not yet available (maybe the player need to do something)
- e_LOC_GONE_FOREVER, used when we want to definitely take an item out of the game
- e_LOC_CURRENT, which contains the id of wherever the player is currently located

```c
  // Move the ladder into the pit
  SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_OUTSIDE_PIT)

  // Give the key to the player
  SET_ITEM_LOCATION(e_ITEM_SmallKey,e_LOC_INVENTORY)

  // Drop the knife at the current location
  SET_ITEM_LOCATION(e_ITEM_SilverKnife,e_LOC_CURRENT)
```  

### SET_ITEM_FLAGS

```C
#define COMMAND_SET_ITEM_FLAGS  nn
#define SET_ITEM_FLAGS(item,flags)              .byt COMMAND_SET_ITEM_FLAGS,item,flags
```  

Three bytes command containing the COMMAND_SET_ITEM_FLAGS opcode, followed by id of the item and the bit mask to OR with the existing flags

```c
  // Mask-in some flags of the ladder
  SET_ITEM_FLAGS(e_ITEM_Ladder,ITEM_FLAG_ATTACHED)
```  

### UNSET_ITEM_FLAGS

```C
#define COMMAND_UNSET_ITEM_FLAGS n
#define UNSET_ITEM_FLAGS(item,flags)            .byt COMMAND_UNSET_ITEM_FLAGS,item,255^flags
```  

Three bytes command containing the COMMAND_UNSET_ITEM_FLAGS opcode, followed by id of the item and the bit mask to AND with the existing flags

```c
  // Mask-out some flags on the curtain
  UNSET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)
```

### SET_ITEM_DESCRIPTION

```C
#define COMMAND_SET_ITEM_DESCRIPTION nn
#define SET_ITEM_DESCRIPTION(item,description)  .byt COMMAND_SET_ITEM_DESCRIPTION,item,description,0
```  

Variable number of bytes containing the COMMAND_SET_ITEM_DESCRIPTION opcode, followed by the id of the item, then a null terminated string containing the description

```c
  // Change the description of the curtain object
  SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"a closed curtain")
```

---

## Location management

### SET_PLAYER_LOCATION

```C
#define COMMAND_SET_PLAYER_LOCATION nn
#define SET_PLAYER_LOCATION(location)       .byt COMMAND_SET_PLAYER_LOCATION,location
```  

Two bytes command containing the COMMAND_SET_PLAYER_LOCATION opcode, followed by id of the location.

This command can be used to move the player to another location. In Encounter this is used for example when examining the car.

```c
#ifdef LANGUAGE_FR
  INFO_MESSAGE("Rapprochons-nous")
#else
  INFO_MESSAGE("Let's get closer")
#endif        
  SET_PLAYER_LOCATION(e_LOC_ABANDONED_CAR)
```

---

### SET_LOCATION_DIRECTION

```C
#define COMMAND_SET_LOCATION_DIRECTION nn
#define SET_LOCATION_DIRECTION(location,direction,value)  .byt COMMAND_SET_LOCATION_DIRECTION,location,direction,value
```  

Four bytes command containing the COMMAND_SET_LOCATION_DIRECTION opcode, followed by id of the location, which of the six directions we want to change, and finally the new location

```c
  // Enable the UP direction
  SET_LOCATION_DIRECTION(e_LOC_INSIDE_PIT,e_DIRECTION_UP,e_LOC_OUTSIDE_PIT)
```

---

### SET_SCENE_IMAGE

```C
#define COMMAND_SET_SCENE_IMAGE nn
#define SET_SCENE_IMAGE(imageId)            .byt COMMAND_SET_SCENE_IMAGE,imageId
```  

Two bytes command containing the COMMAND_SET_SCENE_IMAGE opcode, followed by id of the image to display.

In Encounter this is used to show a different image when something has changed in the scene, like between a dark room and the same room with the curtains open.

```c
  // Show the view with the googles on
  SET_SCENE_IMAGE(LOADER_PICTURE_STEEL_DOOR_WITH_GOOGLES)                
```

---

## Scoring and achievements

### UNLOCK_ACHIEVEMENT

```c
#define COMMAND_UNLOCK_ACHIEVEMENT nn
#define UNLOCK_ACHIEVEMENT(achievement)      .byt COMMAND_UNLOCK_ACHIEVEMENT,achievement
```

Two bytes command containing the COMMAND_UNLOCK_ACHIEVEMENT opcode, followed by the achievement id.
This would typically be used when the player does something worth remembering.

```c
  // Achievement unlocked: Fell into the pit
  UNLOCK_ACHIEVEMENT(ACHIEVEMENT_FELL_INTO_PIT)
```

### INCREASE_SCORE

```c
#define COMMAND_INCREASE_SCORE nn
#define INCREASE_SCORE(points)               .byt COMMAND_INCREASE_SCORE,<points,>points
```

Three bytes command containing the COMMAND_INCREASE_SCORE opcode, followed by the number of points to add to the score (signed 16 bit).
This would typically be used when the player does something worthy of rewarding for the high-score.

```c
  // Give 50 points to the player
  INCREASE_SCORE(50)
```

### DECREASE_SCORE

```c
// Note: This command calls the increase score code, just with a negated value
#define COMMAND_INCREASE_SCORE nn
#define DECREASE_SCORE(points)               .byt COMMAND_INCREASE_SCORE,<(65536-points),>(65536-points)
```

Three bytes command containing the COMMAND_INCREASE_SCORE opcode, followed by the number of points to remove from the score (signed 16 bit).
This would typically be used when the player does something that requires a penalty.

```c
  // Remove 1500 points from the player's score
  DECREASE_SCORE(1500)
```

### GAME_OVER

```c
#define COMMAND_GAME_OVER nn
#define GAME_OVER(condition)               .byt COMMAND_GAME_OVER,condition
```

Two bytes command containing the COMMAND_GAME_OVER opcode, followed by the reason for failing.
This is used to terminate the game session and go to the outro sequence.

```c
  // The player ran out of time
  GAME_OVER(e_SCORE_RAN_OUT_OF_TIME)
```

### START_CLOCK

```c
#define COMMAND_START_CLOCK
#define START_CLOCK                        .byt COMMAND_START_CLOCK
```

One byte command containing the START_CLOCK opcode.
This is used to start the game clock, can be used at the start of the game when the player can finally play, or at the end of a PAUSE operation

```c
  // Start the game clock
  START_CLOCK
```

### STOP_CLOCK

```c
#define COMMAND_STOP_CLOCK
#define STOP_CLOCK                        .byt COMMAND_STOP_CLOCK
```

One byte command containing the STOP_CLOCK opcode.
This is used to stop the game clock, can be used at the start of a PAUSE operation, and when the player session ends to stop counting the time.

```c
  // Pause the game clock
  STOP_CLOCK
```


---

## Graphic stuff

There are a few different ways to display graphics in Encounter.

The main concept is that graphics are located in three different locations:

- The actual HIRES video memory showing the 240x128 graphical window in memory
- The internal mixing buffer (_ImageBuffer) where the images are loaded first before being blit to the HIRES screen
- The secondary buffer (_SecondImageBuffer) where sheets of graphical "patches" are loaded

Depending of which command you use, the data loaded from disk will end up in the primary or secondary image buffer.

### DISPLAY_IMAGE

```c
#define COMMAND_FULLSCREEN_ITEM nn
#define DISPLAY_IMAGE(imagedId)          .byt COMMAND_FULLSCREEN_ITEM,imagedId
```

Two bytes command containing the COMMAND_DISPLAY_IMAGE_NOBLIT opcode, followed by the id of the image to load.

This is the most commonly used variant: It erases the text area, loads the image into _ImageBuffer, and finally blits it to screen.

```c
  // Show the image of the dog eating some meat
  DISPLAY_IMAGE(LOADER_PICTURE_DOG_EATING_MEAT)
```  

### DISPLAY_IMAGE_ONLY

```c
#define COMMAND_DISPLAY_IMAGE_ONLY nn
#define DISPLAY_IMAGE_ONLY(imagedId)          .byt COMMAND_DISPLAY_IMAGE_ONLY,imagedId
```

Two bytes command containing the COMMAND_DISPLAY_IMAGE_NOBLIT opcode, followed by the id of the image to load.

This variant: Also loads the image into _ImageBuffer and blits it to screen, but it does not erase the text area

```c
  // Show the image of the dog eating some meat
  DISPLAY_IMAGE_ONLY(LOADER_PICTURE_DOG_EATING_MEAT)
```  

### DISPLAY_IMAGE_NOBLIT

```c
#define COMMAND_DISPLAY_IMAGE_NOBLIT nn
#define DISPLAY_IMAGE_NOBLIT(imagedId)          .byt COMMAND_DISPLAY_IMAGE_NOBLIT,imagedId
```

Two bytes command containing the COMMAND_DISPLAY_IMAGE_NOBLIT opcode, followed by the id of the image to load.

This last variant does erase the text area and load the image into _ImageBuffer, but it does not actually blit it to screen.
It is used to perform a cross fade between images, or to perform controlled copy-pasted of blocks before blitting to the screen

```c
  // Draw the base image with the hole over an empty room
  DISPLAY_IMAGE_NOBLIT(LOADER_PICTURE_HOLE)                            
  // Draw the patch with the girl restrained on the floor 
  BLIT_BLOCK_STRIDE(LOADER_SPRITE_HOLE_WITH_GIRL_ATTACHED,17,76,17)    
    _IMAGE_STRIDE(0,0,17)
    _BUFFER(10,26)
  FADE_BUFFER
```  

### DRAW_BITMAP

```c
#define COMMAND_BITMAP nn
#define DRAW_BITMAP(imageId,size,stride,src,dst)     .byt COMMAND_BITMAP,imageId,size,stride,<src,>src,<dst,>dst
```

Nine bytes operator containing the COMMAND_BITMAP opcode, followed by the id of the image containing the data, width and height of the block to display, source stride, and the address of the source and destination

```c
  // Draw the ladder
  DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(4,50),40,_SecondImageBuffer+36,_ImageBuffer+(40*40)+19)    ; Draw the ladder 
```  

## Audio

### PLAY_SOUND

```c
#define COMMAND_PLAY_SOUND nn
#define PLAY_SOUND(sound)         .byt COMMAND_PLAY_SOUND,<sound,>sound
```

Three bytes command containing the COMMAND_PLAY_SOUND opcode, followed by the address in memory of the sound to play.

The sounds are two small to be worth loading from disk, so it is assumed they are all present in memory.

```c
  // Play the sound of the door opening
  PLAY_SOUND(_DoorOpening) 
```  

### LOAD_MUSIC

```c
#define COMMAND_LOAD_MUSIC nn
#define LOAD_MUSIC(sound)         .byt COMMAND_LOAD_MUSIC,musicId
```

Two bytes command containing the COMMAND_LOAD_MUSIC opcode, followed by the id of a music to load and play.

Note: When a music is playing, it is highly recommended to avoid doing disk accesses, so if you need to do some animations like in the end sequence of the game, try to load the graphical assets first, then start the music, then display the loaded assets on screen.

```c
  // Play the game over music
  LOAD_MUSIC(LOADER_MUSIC_GAME_OVER)
```  

### STOP_MUSIC

```c
#define COMMAND_STOP_MUSIC nn
#define STOP_MUSIC              .byt COMMAND_STOP_MUSIC
```

One byte command containing the COMMAND_STOP_MUSIC opcode.

```c
  // Stop whatever music is currently playing
  STOP_MUSIC() 
```  


**See:**

- [game_enums.h](../code/game_enums.h) for the list of all locations

---
[^1]: The syntax to draw bitmaps is horrible, but it will be simplified at some point
