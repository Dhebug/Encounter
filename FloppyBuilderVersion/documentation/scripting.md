Scripting
=========
Somes games have hardcoded logic, some are completely data-driven, Encounter is somewhat in-between, with most of the player actions directly coded in normal language, while the scenes themselves use a tiny scripting system designed to be memory efficient


- [Scripting](#scripting)
- [Features](#features)
- [The concept](#the-concept)
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
  - [DISPLAY\_IMAGE](#display_image)
  - [DRAW\_BITMAP](#draw_bitmap)
- [More complex examples](#more-complex-examples)
  - [Jumps and conditions](#jumps-and-conditions)
  - [Scene bubbles](#scene-bubbles)
  - [Full screen items](#full-screen-items)
  - [Animations](#animations)


# Features
The main feature of the scripts is to populate the scene images with the proper content, like speech bubles and items, or draw the game-over sequence.

The [location](locations.md) structure contains a **script** field with a pointer to a script executed each time a scene is drawn.

# The concept
A script is just a sequence of commands, a byte stream really, with a final "end" command.

A stream is launched with the **PlayStream** function, and the bytecode execute all the commands immediately until it either reach the end of the stream or encounter a "Wait" instruction, this basically is the equivalent of having a "setup" phase followed by some more stuff happening later.

Typically the setup will be in charge of checking the state of the game to draw and print different elements depending of the context, and the rest will be these description bubbles which appear over time to make the game "more alive" than a standard text adventure game.

Scripts can also loop and branch, basic conditions are supported.

# Commands

```
#define OFFSET(x,y) x,y
#define BLOCK_SIZE(w,h) w,h
#define STRIDE(b) b
#define RECTANGLE(x,y,w,h) x,y,w,h

// Command opcodes
#define COMMAND_END             0
#define COMMAND_RECTANGLE       1
#define COMMAND_FILL_RECTANGLE  2
#define COMMAND_TEXT            3
#define COMMAND_WHITE_BUBBLE    4
#define COMMAND_BLACK_BUBBLE    5
#define COMMAND_WAIT            6
#define COMMAND_BITMAP          7
#define COMMAND_FADE_BUFFER     8
#define COMMAND_JUMP            9      // Really, that's a GOTO :p
#define COMMAND_JUMP_IF_TRUE    10
#define COMMAND_JUMP_IF_FALSE   11
#define COMMAND_INFO_MESSAGE    12 
#define COMMAND_FULLSCREEN_ITEM 13
#define COMMAND_STOP_BREAKPOINT 14
#define COMMAND_END_AND_REFRESH 15
#define COMMAND_ERROR_MESSAGE   16
#define COMMAND_SET_ITEM_LOCATION   17
#define COMMAND_SET_ITEM_FLAGS  18
#define COMMAND_UNSET_ITEM_FLAGS 19
#define COMMAND_SET_ITEM_DESCRIPTION 20
#define COMMAND_SET_LOCATION_DIRECTION 21
#define COMMAND_UNLOCK_ACHIEVEMENT 22
#define _COMMAND_COUNT          23

// Operator opcodes
#define OPERATOR_CHECK_ITEM_LOCATION 0
#define OPERATOR_CHECK_ITEM_FLAG     1

#define END                                  .byt COMMAND_END
#define END_AND_REFRESH                      .byt COMMAND_END_AND_REFRESH
#define WAIT(duration)                       .byt COMMAND_WAIT,duration
#define JUMP(label)                          .byt COMMAND_JUMP,<label,>label
#define JUMP_IF_TRUE(label,expression)       .byt COMMAND_JUMP_IF_TRUE,<label,>label,expression
#define JUMP_IF_FALSE(label,expression)      .byt COMMAND_JUMP_IF_FALSE,<label,>label,expression
#define CHECK_ITEM_LOCATION(item,location)   OPERATOR_CHECK_ITEM_LOCATION,item,location
#define CHECK_ITEM_FLAG(item,flag)           OPERATOR_CHECK_ITEM_FLAG,item,flag
#define INFO_MESSAGE(message)                .byt COMMAND_INFO_MESSAGE,message,0
#define ERROR_MESSAGE(message)               .byt COMMAND_ERROR_MESSAGE,message,0

#define UNLOCK_ACHIEVEMENT(achievement)      .byt COMMAND_UNLOCK_ACHIEVEMENT,achievement

// Items
#define SET_ITEM_LOCATION(item,location)        .byt COMMAND_SET_ITEM_LOCATION,item,location
#define SET_ITEM_FLAGS(item,flags)              .byt COMMAND_SET_ITEM_FLAGS,item,flags
#define UNSET_ITEM_FLAGS(item,flags)            .byt COMMAND_UNSET_ITEM_FLAGS,item,flags
#define SET_ITEM_DESCRIPTION(item,description)  .byt COMMAND_SET_ITEM_DESCRIPTION,item,description,0

// Locations
#define SET_LOCATION_DIRECTION(location,direction,value)  .byt COMMAND_SET_LOCATION_DIRECTION,location,direction,value

#define DRAW_BITMAP(imageId,size,stride,src,dst)     .byt COMMAND_BITMAP,imageId,size,stride,<src,>src,<dst,>dst
#define DISPLAY_IMAGE(imagedId,description)          .byt COMMAND_FULLSCREEN_ITEM,imagedId,description,0
```
## END
Just a single byte containg the COMMAND_END opcode. 
This signals the end of the script.
```
  ; End of script
  END
```
## END_AND_REFRESH
Similar to END, except it also forces the entire scene to refresh.
Generally used when the player perform actions resulting in items being modified or moved.
```
  ; End of script (and trigger a full refresh)
  END_AND_REFRESH
```
## WAIT
Two bytes command containg the COMMAND_WAIT opcode, followed by the number of frames.

To provide some pacing, delays can be used to interrupt the execution of a script for a period of time.

The delays are encoded as frame numbers on a single byte, which means the maximum duration of a delay is about 5 seconds. 
If you need a longer delay, just put a few more delay instructions.
```
  ; Wait one second (50 frames)
  WAIT(50)
```

## JUMP
Three bytes command containg the COMMAND_JUMP opcode, followed by the address of the script locations where to jump.
```
  ; Jumps to the 'dog_growls' label
  JUMP(dog_growls)
  (...)
dog_growls
```
---
## Conditional jumps
These two instructions require an operator to evaluate if the condition is true or false
### JUMP_IF_TRUE
Seven bytes command containg the COMMAND_JUMP_IF_TRUE opcode, followed by the address of the script locations where to jump, followed by a 3 bytes expression evaluated at run time.

### JUMP_IF_FALSE
Seven bytes command containg the JUMP_IF_FALSE opcode, followed by the address of the script locations where to jump, followed by a 3 bytes expression evaluated at run time.

---
## Operators
These operators should be used with either JUMP_IF_TRUE or JUMP_IF_FALSE
### CHECK_ITEM_LOCATION
Three bytes operator containg the OPERATOR_CHECK_ITEM_LOCATION opcode, followed by the id of the item to check, and finally the location we want to check.

### CHECK_ITEM_FLAG
Three bytes operator containg the OPERATOR_CHECK_ITEM_FLAG opcode, followed by the id of the item to check, and finally the bit mask to apply.

### CHECK_PLAYER_LOCATION
Two bytes operator containg the OPERATOR_CHECK_PLAYER_LOCATION opcode, followed by the location we want to check.

---
## Providing information to the player
### INFO_MESSAGE
Variable number of bytes containing the COMMAND_INFO_MESSAGE opcode, followed by a null terminated string containing the message to display
```
  ; Print a message in the main TEXT window
  INFO_MESSAGE("I have to find her fast...")
```
### ERROR_MESSAGE
Similar to INFO_MESSAGE, except it uses the COMMAND_ERROR_MESSAGE opcode and the message is printed out as an error 
```
  ; Print an error message with a sound effect 
  ERROR_MESSAGE("I can't do that")
```  
---
## Changing item properties
### SET_ITEM_LOCATION
Three bytes command containg the COMMAND_SET_ITEM_LOCATION opcode, followed by id of the item and the location where to move it
```
  ; Change the location of the ladder
  SET_ITEM_LOCATION(e_ITEM_Ladder,e_LOCATION_OUTSIDE_PIT)
```  
### SET_ITEM_FLAGS
Three bytes command containg the COMMAND_SET_ITEM_FLAGS opcode, followed by id of the item and the bit mask to OR with the existing flags
```
  ; Mask-in some flags of the ladder
  SET_ITEM_FLAGS(e_ITEM_Ladder,ITEM_FLAG_ATTACHED)
```  
### UNSET_ITEM_FLAGS
Three bytes command containg the COMMAND_UNSET_ITEM_FLAGS opcode, followed by id of the item and the bit mask to AND with the existing flags
```
  ; Mask-out some flags on the curtain
  UNSET_ITEM_FLAGS(e_ITEM_Curtain,ITEM_FLAG_CLOSED)
```
### SET_ITEM_DESCRIPTION
Variable number of bytes containing the COMMAND_SET_ITEM_DESCRIPTION opcode, followed by the id of the item, then a null terminated string containing the description
```
  ; Change the description of the curtain object
  SET_ITEM_DESCRIPTION(e_ITEM_Curtain,"a closed curtain")
```
---
## Changing locations properties
### SET_LOCATION_DIRECTION
Four bytes command containg the COMMAND_SET_LOCATION_DIRECTION opcode, followed by id of the location, which of the six directions we want to change, and finally the new location
```
  ; Enable the UP direction
  SET_LOCATION_DIRECTION(e_LOCATION_INSIDE_PIT,e_DIRECTION_UP,e_LOCATION_OUTSIDE_PIT)
```
---
## Scoring and achievements
### UNLOCK_ACHIEVEMENT
Two bytes command containg the COMMAND_UNLOCK_ACHIEVEMENT opcode, followed by the achievement id.
This would typically be used when the player does something worth remembering.
```
  ; Achievement unlocked: Fell into the pit
  UNLOCK_ACHIEVEMENT(ACHIEVEMENT_FELL_INTO_PIT)
```

---
## DISPLAY_IMAGE
Variable number of bytes containing the COMMAND_FULLSCREEN_ITEM opcode, followed by the id of an image to load, and a null terminated string containing a description to display
Used to display a full screen image, like the map of the UK or the newspapwer with a subtitle
```
  ; Show the image of the dog eating some meat
  DISPLAY_IMAGE(LOADER_PICTURE_DOG_EATING_MEAT,"Quite a hungry dog!")
```  
## DRAW_BITMAP
Nine bytes operator containg the COMMAND_BITMAP opcode, followed by the id of the image containing the data, width and height of the block to display, source stride, and the address of the source and destination
```
  ; Draw the ladder
  DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(4,50),40,_SecondImageBuffer+36,_ImageBuffer+(40*40)+19)    ; Draw the ladder 
```  

# More complex examples
Obviously a proper script would use a combination of all these commands.

## Jumps and conditions 
Scripts by default are executed instruction by instruction, but it's possible to jump around.

In this example we check if the rope is present outside of the pit, if it is not we jump to the 'no_rope' label, else we check if the rope has the 'attached' flag set, and if true we jump to the 'rope_attached_to_tree' label.
```
    JUMP_IF_FALSE(no_rope,CHECK_ITEM_LOCATION(e_ITEM_Rope,e_LOCATION_OUTSIDE_PIT))
    JUMP_IF_TRUE(rope_attached_to_tree,CHECK_ITEM_FLAG(e_ITEM_Rope,ITEM_FLAG_ATTACHED))
no_rope    
    JUMP(digging_for_gold);            ; Generic message if the ladder or rope are not present
rope_attached_to_tree    
    (...)
digging_for_gold
```

## Scene bubbles
To provide some cartoony feeling, the game is using the scripting system to display some messages over time.

Delays are done with the COMMAND_WAIT instruction, while the COMMAND_WHITE_BUBBLE and COMMAND_BLACK_BUBBLE is used to display the text bubbles
```
_gDescriptionRoad
    WAIT(DELAY_FIRST_BUBBLE)              // Initial delay
    .byt COMMAND_WHITE_BUBBLE,2           // "Draw black on white background speech bubble", two text entries
    .byt 4,100,0,"All roads lead...",0    // X position, Y position, vertical text offset, first text, null terminator
    .byt 4,106,4,"...somewhere?",0        // X position, Y position, vertical text offset, second text, null terminator
    END                                   // End of script
```

## Full screen items
Some of the actions done by the player, like reading the newspaper, or looking at the map in the library result in the game loading a fullscreen image, then show some comments about the action.

These are done by small scripts
```
  (...)
  // Show the newspaper content
  PlayStream(gSceneActionReadNewsPaper);
  (...)

_gSceneActionReadNewsPaper
    DISPLAY_IMAGE(LOADER_PICTURE_NEWSPAPER,"The Daily Telegraph, September 29th")
    INFO_MESSAGE("I have to find her fast...")
    WAIT(50*2)
    INFO_MESSAGE("...I hope she is fine!")
    WAIT(50*2)
    END
```

## Animations 
Animations are done by updating the graphics on the scene, waiting a bit, updating graphics again, looping, etc...

The system does not support moving objects, but it's good enough for things that change state or cycling animations.

```
_gDescriptionMarketPlace
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_WHITE_BUBBLE,2
    .byt 4,100,0,"The market place",0
    .byt 4,106,4,"is deserted",0
blinky_shop
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(8,11),40,_SecondImageBuffer+(40*116)+32,$a000+(14*40)+11)    ; Draw the Fish Shop "grayed out"
    WAIT(50) 
    DRAW_BITMAP(LOADER_SPRITE_ITEMS,BLOCK_SIZE(8,11),40,_SecondImageBuffer+(40*104)+32,$a000+(14*40)+11)    ; Draw the Fish Shop "fully drawn"
    WAIT(50)
    JUMP(blinky_shop)
    END
```


**See:**
- [game_enums.h](../code/game_enums.h) for the list of all locations
