
#define DELAY_FIRST_BUBBLE      25

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
#define COMMAND_INCREASE_SCORE 23
#define _COMMAND_COUNT          24

// Operator opcodes
#define OPERATOR_CHECK_ITEM_LOCATION   0
#define OPERATOR_CHECK_ITEM_FLAG       1
#define OPERATOR_CHECK_PLAYER_LOCATION 2

#define CHECK_ITEM_LOCATION(item,location)   OPERATOR_CHECK_ITEM_LOCATION,item,location
#define CHECK_ITEM_FLAG(item,flag)           OPERATOR_CHECK_ITEM_FLAG,item,flag
#define CHECK_PLAYER_LOCATION(location)      OPERATOR_CHECK_PLAYER_LOCATION,location

// Flow control
#define END                                  .byt COMMAND_END
#define END_AND_REFRESH                      .byt COMMAND_END_AND_REFRESH
#define WAIT(duration)                       .byt COMMAND_WAIT,duration
#define JUMP(label)                          .byt COMMAND_JUMP,<label,>label
#define JUMP_IF_TRUE(label,expression)       .byt COMMAND_JUMP_IF_TRUE,<label,>label,expression
#define JUMP_IF_FALSE(label,expression)      .byt COMMAND_JUMP_IF_FALSE,<label,>label,expression

// Text
#define INFO_MESSAGE(message)                .byt COMMAND_INFO_MESSAGE,message,0
#define ERROR_MESSAGE(message)               .byt COMMAND_ERROR_MESSAGE,message,0
#define WHITE_BUBBLE(bubble_count)           .byt COMMAND_WHITE_BUBBLE,bubble_count
#define BLACK_BUBBLE(bubble_count)           .byt COMMAND_BLACK_BUBBLE,bubble_count
#define _BUBBLE_LINE(x,y,yoffset,text)       .byt x,y,yoffset,text,0

// Meta game
#define UNLOCK_ACHIEVEMENT(achievement)      .byt COMMAND_UNLOCK_ACHIEVEMENT,achievement
#define INCREASE_SCORE(points)               .byt COMMAND_INCREASE_SCORE,points

// Items
#define SET_ITEM_LOCATION(item,location)        .byt COMMAND_SET_ITEM_LOCATION,item,location
#define SET_ITEM_FLAGS(item,flags)              .byt COMMAND_SET_ITEM_FLAGS,item,flags
#define UNSET_ITEM_FLAGS(item,flags)            .byt COMMAND_UNSET_ITEM_FLAGS,item,255^flags
#define SET_ITEM_DESCRIPTION(item,description)  .byt COMMAND_SET_ITEM_DESCRIPTION,item,description,0

// Locations
#define SET_LOCATION_DIRECTION(location,direction,value)  .byt COMMAND_SET_LOCATION_DIRECTION,location,direction,value

#define DRAW_BITMAP(imageId,size,stride,src,dst)     .byt COMMAND_BITMAP,imageId,size,stride,<src,>src,<dst,>dst
#define DISPLAY_IMAGE(imagedId,description)          .byt COMMAND_FULLSCREEN_ITEM,imagedId,description,0

// Audio commands
#define SOUND_NOT_PLAYING        255

#define SOUND_COMMAND_END        0      // End of the sound
#define SOUND_COMMAND_END_FRAME  1      // End of command list for this frame
#define SOUND_COMMAND_SET_BANK   2      // Change a complete set of sounds: <14 values copied to registers 0 to 13>
#define SOUND_COMMAND_SET_VALUE  3      // Set a register value: <register index> <value to set>
#define SOUND_COMMAND_ADD_VALUE  4      // Add to a register:    <register index> <value to add>
#define SOUND_COMMAND_REPEAT     5      // Defines the start of a block that will repeat "n" times: <repeat count>
#define SOUND_COMMAND_ENDREPEAT  6      // Defines the end of a repeating block

// Text commands
#define TEXT_END                 255
#define TEXT_CRLF                254

// End command
#define FLAG_END_STREAM          1
#define FLAG_WAIT                2
#define FLAG_REFRESH_SCENE       4


//
#define VALUE_MAPPING(value,address)       .byt value,<address,>address


