**WIP**

# Scripting
Somes games have hardcoded logic, some are completely data-driven, Encounter is somewhat in-between, with most of the player actions directly coded in normal language, while the scenes themselves use a tiny scripting system designed to be memory efficient

## Features
The main feature of the scripts is to populate the scene images with the proper content, like speech bubles and items, or draw the game-over sequence.

The [location](locations.md) structure contains a **script** field with a pointer to a script executed each time a scene is drawn.

## The concept
A script is just a sequence of commands, a byte stream really, with a final "end" command.

A stream is launched with the **PlayStream** function, and the bytecode execute all the commands immediately until it either reach the end of the stream or encounter a "Wait" instruction, this basically is the equivalent of having a "setup" phase followed by some more stuff happening later.

Typically the setup will be in charge of checking the state of the game to draw and print different elements depending of the context, and the rest will be these description bubbles which appear over time to make the game "more alive" than a standard text adventure game.

Scripts can also loop and branch, basic conditions are supported.

## Commands

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
#define COMMAND_BUBBLE          4
#define COMMAND_WAIT            5
#define COMMAND_BITMAP          6
#define COMMAND_FADE_BUFFER     7
#define COMMAND_JUMP            8      // Really, that's a GOTO :p
#define COMMAND_JUMP_IF_TRUE    9
#define COMMAND_JUMP_IF_FALSE   10
#define COMMAND_INFO_MESSAGE    11 
#define COMMAND_FULLSCREEN_ITEM 12
#define COMMAND_STOP_BREAKPOINT 13
#define _COMMAND_COUNT          14

// Operator opcodes
#define OPERATOR_CHECK_ITEM_LOCATION 0
#define OPERATOR_CHECK_ITEM_FLAG     1

#define END                                  .byt COMMAND_END
#define WAIT(duration)                       .byt COMMAND_WAIT,duration
#define JUMP(label)                          .byt COMMAND_JUMP,<label,>label
#define JUMP_IF_TRUE(label,expression)       .byt COMMAND_JUMP_IF_TRUE,<label,>label,expression
#define JUMP_IF_FALSE(label,expression)      .byt COMMAND_JUMP_IF_FALSE,<label,>label,expression
#define CHECK_ITEM_LOCATION(item,location)   OPERATOR_CHECK_ITEM_LOCATION,item,location
#define CHECK_ITEM_FLAG(item,flag)           OPERATOR_CHECK_ITEM_FLAG,item,flag

#define DRAW_BITMAP(imageId,size,stride,src,dst)     .byt COMMAND_BITMAP,imageId,size,stride,<src,>src,<dst,>dst
```

## Examples

### Scene bubbles
To provide some cartoony feeling, the game is using the scripting system to display some messages over time.

Delays are done with the COMMAND_WAIT instruction, while the COMMAND_BUBBLE is used to display the text bubbles
```
_gDescriptionRoad
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
    .byt 4,100,0,"All roads lead...",0
    .byt 4,106,4,"...somewhere?",0
    END
```

### Full screen items
Some of the actions done by the player, like reading the newspaper, or looking at the map in the library result in the game loading a fullscreen image, then show some comments about the action.

These are done by small scripts
```
  (...)
  // Show the newspaper content
  PlayStream(gSceneActionReadNewsPaper);
  (...)

_gSceneActionReadNewsPaper
    .byt COMMAND_FULLSCREEN_ITEM,LOADER_PICTURE_NEWSPAPER,"The Daily Telegraph, September 29th",0
    .byt COMMAND_INFO_MESSAGE,"I have to find her fast...",0
    WAIT(50*2)
    .byt COMMAND_INFO_MESSAGE,"...I hope she is fine!",0
    WAIT(50*2)
    END
```

### Animations 
Animations are done by updating the graphics on the scene, waiting a bit, updating graphics again, looping, etc...

The system does not support moving objects, but it's good enough for things that change state or cycling animations.

```
_gDescriptionMarketPlace
    WAIT(DELAY_FIRST_BUBBLE)
    .byt COMMAND_BUBBLE,2,64
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
