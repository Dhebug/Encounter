Scripting
=========
Somes games have hardcoded logic, some are completely data-driven, Encounter is somewhat in-between, with most of the player actions directly coded in normal language, while the scenes themselves use a tiny scripting system designed to be memory efficient


- [Scripting](#scripting)
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
    - [Game script](#game-script)
- [Commands](#commands)
  - [END](#end)
  - [END\_AND\_REFRESH](#end_and_refresh)
  - [WAIT](#wait)
  - [JUMP](#jump)
  - [Conditional jumps](#conditional-jumps)
    - [JUMP\_IF\_TRUE](#jump_if_true)
    - [JUMP\_IF\_FALSE](#jump_if_false)
  - [Operators](#operators)
    - [CHECK\_ITEM\_LOCATION](#check_item_location)
    - [CHECK\_ITEM\_FLAG](#check_item_flag)
    - [CHECK\_PLAYER\_LOCATION](#check_player_location)
  - [Providing information to the player](#providing-information-to-the-player)
    - [INFO\_MESSAGE](#info_message)
    - [ERROR\_MESSAGE](#error_message)
  - [Changing item properties](#changing-item-properties)
    - [SET\_ITEM\_LOCATION](#set_item_location)
    - [SET\_ITEM\_FLAGS](#set_item_flags)
    - [UNSET\_ITEM\_FLAGS](#unset_item_flags)
    - [SET\_ITEM\_DESCRIPTION](#set_item_description)
  - [Changing locations properties](#changing-locations-properties)
    - [SET\_LOCATION\_DIRECTION](#set_location_direction)
  - [Scoring and achievements](#scoring-and-achievements)
    - [UNLOCK\_ACHIEVEMENT](#unlock_achievement)
    - [INCREASE\_SCORE](#increase_score)
  - [DISPLAY\_IMAGE](#display_image)
  - [DRAW\_BITMAP](#draw_bitmap)


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
This is not used in Encounter, but technicaly the scripts could easily be loaded from disk with the scenes, which would solve the problems coming with the limited amount of memory on the machine.

The reason why this could be done is that the data is directly placed as parameters of the instructions instead of using pointers, so for example all the string messages are directly embeded in the script, which means no searching, linking or relocating is required.

## Disadvantages
Of course it's not all rainbows and unicorns, scripting languages have their issues as well.
### A new syntax to learn
Probably obvious, but by definition it's a new language that nobody else knows, so there's some kind of barier to entry.

The trick is to design something called DSL (Domain Specific Language) instead of a general purpose language: You do not want or need a complete set of operations, you just need what is necessary to implement what you game logic needs, ideally by implementing big expressive instructions with a simple syntax.

For example, instead of allowing the user to aquire a pointer or reference to an entity that can then be manipulated, instead you can implement instructions that can directly act on the most important properties of an entity.

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

![](images/scripting_location_dark_tunnel.png)

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

### Game script
> [!WARNING]  
> TODO: This section is possibly not valid anymore.

There is only a single game script for the entire game, but technically it should be trivial to have multiple ones or change it at run time.

The purpose of this script is to do book-keeping and adjustments independently of where the player is located.


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
## END
```c
#define COMMAND_END nn
#define END             .byt COMMAND_END
```

Just a single byte containg the COMMAND_END opcode. 
This signals the end of the script.
```c
  // End of script
  END
```
## END_AND_REFRESH
```c
#define COMMAND_END_AND_REFRESH nn
#define END_AND_REFRESH           .byt COMMAND_END_AND_REFRESH
```
Similar to END, except it also forces the entire scene to refresh.
Generally used when the player perform actions resulting in items being modified or moved.
```c
  // End of script (and trigger a full refresh)
  END_AND_REFRESH
```
## WAIT
```c
#define COMMAND_WAIT nn
#define WAIT(duration)    .byt COMMAND_WAIT,duration
```
Two bytes command containg the COMMAND_WAIT opcode, followed by the number of frames.

To provide some pacing, delays can be used to interrupt the execution of a script for a period of time.

The delays are encoded as frame numbers on a single byte, which means the maximum duration of a delay is about 5 seconds. 
If you need a longer delay, just put a few more delay instructions.
```c
  // Wait one second (50 frames)
  WAIT(50)
```

## JUMP
```c
#define COMMAND_JUMP nn
#define JUMP(label)     .byt COMMAND_JUMP,<label,>label
```
Three bytes command containg the COMMAND_JUMP opcode, followed by the address of the script locations where to jump.
```c
  // Jumps to the 'dog_growls' label
  JUMP(dog_growls)
  (...)
dog_growls
```
---
## Conditional jumps
These two instructions require an operator to evaluate if the condition is true or false
### JUMP_IF_TRUE
```c
#define COMMAND_JUMP_IF_TRUE nn
#define JUMP_IF_TRUE(label,expression)       .byt COMMAND_JUMP_IF_TRUE,<label,>label,expression
```
Seven bytes command containg the COMMAND_JUMP_IF_TRUE opcode, followed by the address of the script locations where to jump, followed by a 3 bytes expression evaluated at run time.
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
Seven bytes command containg the JUMP_IF_FALSE opcode, followed by the address of the script locations where to jump, followed by a 3 bytes expression evaluated at run time.
```c
  // Jump to the label 'around_the_pit' if the expression is false
  JUMP_IF_FALSE(around_the_pit,/*<check expression>*/)
  (...)
around_the_pit    
```
---
It is possible to use combinations of JUMP_IF_TRUE and JUMP_IF_FALSE to handle more complex scenearios, it's not super elegant but it works just fine.

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

---
## Operators
These operators should be used with either JUMP_IF_TRUE or JUMP_IF_FALSE
### CHECK_ITEM_LOCATION
```c
#define OPERATOR_CHECK_ITEM_LOCATION
#define CHECK_ITEM_LOCATION(item,location)   OPERATOR_CHECK_ITEM_LOCATION,item,location
```
Three bytes operator containg the OPERATOR_CHECK_ITEM_LOCATION opcode, followed by the id of the item to check, and finally the location we want to check.
```c
  /*<conditional jump instruction>*/ CHECK_ITEM_LOCATION(e_ITEM_Ladder,e_LOC_OUTSIDE_PIT) 
```
### CHECK_ITEM_FLAG
Three bytes operator containg the OPERATOR_CHECK_ITEM_FLAG opcode, followed by the id of the item to check, and finally the bit mask to apply.
```c
#define OPERATOR_CHECK_ITEM_FLAG
#define CHECK_ITEM_FLAG(item,flag)           OPERATOR_CHECK_ITEM_FLAG,item,flag
```
```c
  /*<conditional jump instruction>*/ CHECK_ITEM_FLAG(e_ITEM_Ladder,ITEM_FLAG_ATTACHED)
```

### CHECK_PLAYER_LOCATION
```c
#define OPERATOR_CHECK_PLAYER_LOCATION 
#define CHECK_PLAYER_LOCATION(location)      OPERATOR_CHECK_PLAYER_LOCATION,location
```
Two bytes operator containg the OPERATOR_CHECK_PLAYER_LOCATION opcode, followed by the location we want to check.
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
```C
  // Print a message in the main TEXT window
  INFO_MESSAGE("I have to find her fast...")
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
---
## Changing item properties
### SET_ITEM_LOCATION
```C
#define COMMAND_SET_ITEM_LOCATION nn
#define SET_ITEM_LOCATION(item,location)        .byt COMMAND_SET_ITEM_LOCATION,item,location
```  
Three bytes command containg the COMMAND_SET_ITEM_LOCATION opcode, followed by id of the item and the location where to move it.

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
Three bytes command containg the COMMAND_SET_ITEM_FLAGS opcode, followed by id of the item and the bit mask to OR with the existing flags
```c
  // Mask-in some flags of the ladder
  SET_ITEM_FLAGS(e_ITEM_Ladder,ITEM_FLAG_ATTACHED)
```  
### UNSET_ITEM_FLAGS
```C
#define COMMAND_UNSET_ITEM_FLAGS n
#define UNSET_ITEM_FLAGS(item,flags)            .byt COMMAND_UNSET_ITEM_FLAGS,item,255^flags
```  
Three bytes command containg the COMMAND_UNSET_ITEM_FLAGS opcode, followed by id of the item and the bit mask to AND with the existing flags
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
## Changing locations properties
### SET_LOCATION_DIRECTION
```C
#define COMMAND_SET_LOCATION_DIRECTION nn
#define SET_LOCATION_DIRECTION(location,direction,value)  .byt COMMAND_SET_LOCATION_DIRECTION,location,direction,value
```  
Four bytes command containg the COMMAND_SET_LOCATION_DIRECTION opcode, followed by id of the location, which of the six directions we want to change, and finally the new location
```c
  // Enable the UP direction
  SET_LOCATION_DIRECTION(e_LOC_INSIDE_PIT,e_DIRECTION_UP,e_LOC_OUTSIDE_PIT)
```
---
## Scoring and achievements
### UNLOCK_ACHIEVEMENT
```c
#define COMMAND_UNLOCK_ACHIEVEMENT nn
#define UNLOCK_ACHIEVEMENT(achievement)      .byt COMMAND_UNLOCK_ACHIEVEMENT,achievement
```
Two bytes command containg the COMMAND_UNLOCK_ACHIEVEMENT opcode, followed by the achievement id.
This would typically be used when the player does something worth remembering.
```c
  // Achievement unlocked: Fell into the pit
  UNLOCK_ACHIEVEMENT(ACHIEVEMENT_FELL_INTO_PIT)
```

### INCREASE_SCORE
```c
#define COMMAND_INCREASE_SCORE nn
#define INCREASE_SCORE(points)               .byt COMMAND_INCREASE_SCORE,points
```
Two bytes command containg the COMMAND_INCREASE_SCORE opcode, followed by the number of points to add to the score.
This would typically be used when the player does something worthy of rewarding for the high-score.
```c
  // Give 50 points to the player
  INCREASE_SCORE(50)
```

---
## DISPLAY_IMAGE
```c
#define COMMAND_FULLSCREEN_ITEM nn
#define DISPLAY_IMAGE(imagedId,description)          .byt COMMAND_FULLSCREEN_ITEM,imagedId,description,0
```
Variable number of bytes containing the COMMAND_FULLSCREEN_ITEM opcode, followed by the id of an image to load, and a null terminated string containing a description to display
Used to display a full screen image, like the map of the UK or the newspapwer with a subtitle
```c
  // Show the image of the dog eating some meat
  DISPLAY_IMAGE(LOADER_PICTURE_DOG_EATING_MEAT,"Quite a hungry dog!")
```  
## DRAW_BITMAP
```c
#define COMMAND_BITMAP nn
#define DRAW_BITMAP(imageId,size,stride,src,dst)     .byt COMMAND_BITMAP,imageId,size,stride,<src,>src,<dst,>dst
```
Nine bytes operator containg the COMMAND_BITMAP opcode, followed by the id of the image containing the data, width and height of the block to display, source stride, and the address of the source and destination
```c
  // Draw the ladder
  DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(4,50),40,_SecondImageBuffer+36,_ImageBuffer+(40*40)+19)    ; Draw the ladder 
```  



**See:**
- [game_enums.h](../code/game_enums.h) for the list of all locations

---
[^1]: The syntax to draw bitmaps is horrible, but it will be simplified at some point
