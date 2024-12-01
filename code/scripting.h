
#define DELAY_FIRST_BUBBLE      25
#define DELAY_INFO_MESSAGE      50*4

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
#define COMMAND_DISPLAY_IMAGE   13
#define COMMAND_STOP_BREAKPOINT 14
#define COMMAND_END_AND_REFRESH 15
#define COMMAND_ERROR_MESSAGE   16
#define COMMAND_SET_ITEM_LOCATION   17
#define COMMAND_SET_ITEM_FLAGS  18
#define COMMAND_UNSET_ITEM_FLAGS 19
#define COMMAND_SET_ITEM_DESCRIPTION 20
#define COMMAND_SET_LOCATION_DIRECTION 21
#define COMMAND_UNLOCK_ACHIEVEMENT 22
#define COMMAND_INCREASE_SCORE  23
#define COMMAND_GAME_OVER       24
#define COMMAND_CLEAR_FULL_TEXT_AREA 25
#define COMMAND_SET_SCENE_IMAGE 26
#define COMMAND_DISPLAY_IMAGE_NOBLIT 27
#define COMMAND_CLEAR_TEXT_AREA 28
#define COMMAND_GOSUB           29
#define COMMAND_RETURN          30
#define COMMAND_DO_ONCE         31
#define COMMAND_SET_CUT_SCENE   32
#define COMMAND_PLAY_SOUND      33
#define COMMAND_WAIT_RANDOM     34
#define COMMAND_START_CLOCK     35
#define COMMAND_STOP_CLOCK      36
#define COMMAND_END_AND_PARTIAL_REFRESH 37
#define COMMAND_LOAD_MUSIC      38
#define COMMAND_STOP_MUSIC      39
#define COMMAND_WAIT_KEYPRESS   40
#define COMMAND_QUICK_MESSAGE   41
#define COMMAND_SET_SKIP_POINT  42
#define COMMAND_SET_PLAYER_LOCATION 43
#define COMMAND_SET_CURRENT_ITEM 44
#define _COMMAND_COUNT          45

// Operator opcodes
#define OPERATOR_CHECK_ITEM_LOCATION   0
#define OPERATOR_CHECK_ITEM_FLAG       1
#define OPERATOR_CHECK_PLAYER_LOCATION 2
#define OPERATOR_CHECK_ITEM_CONTAINER  3

#define CHECK_ITEM_LOCATION(item,location)   OPERATOR_CHECK_ITEM_LOCATION,item,location
#define CHECK_ITEM_FLAG(item,flag)           OPERATOR_CHECK_ITEM_FLAG,item,flag
#define CHECK_ITEM_CONTAINER(item,container) OPERATOR_CHECK_ITEM_CONTAINER,item,container
#define CHECK_PLAYER_LOCATION(location)      OPERATOR_CHECK_PLAYER_LOCATION,location

// Flow control
#define END                                  .byt COMMAND_END
#define END_AND_REFRESH                      .byt COMMAND_END_AND_REFRESH
#define END_AND_PARTIAL_REFRESH              .byt COMMAND_END_AND_PARTIAL_REFRESH
#define WAIT(duration)                       .byt COMMAND_WAIT,duration
#define WAIT_RANDOM(base_duration,rand_mask) .byt COMMAND_WAIT_RANDOM,base_duration,rand_mask
#define JUMP(label)                          .byt COMMAND_JUMP,<label,>label
#define DO_ONCE(label)                       .byt COMMAND_DO_ONCE,1,<label,>label
#define JUMP_IF_TRUE(label,expression)       .byt COMMAND_JUMP_IF_TRUE,<label,>label,expression
#define JUMP_IF_FALSE(label,expression)      .byt COMMAND_JUMP_IF_FALSE,<label,>label,expression
#define GOSUB(label)                         .byt COMMAND_GOSUB,<label,>label
#define RETURN                               .byt COMMAND_RETURN
#define SET_CUT_SCENE(flag)                  .byt COMMAND_SET_CUT_SCENE,flag
#define SET_SKIP_POINT(label)                .byt COMMAND_SET_SKIP_POINT,<label,>label


#ifdef ASSEMBLER
#define IF_TRUE(expression,label)            .byt COMMAND_JUMP_IF_FALSE,<label,>label,expression   
#define IF_FALSE(expression,label)           .byt COMMAND_JUMP_IF_TRUE,<label,>label,expression 
#define ELSE(else,endif)          else = *+3: .byt COMMAND_JUMP,<endif,>endif                                          
#define ENDIF(endif)              endif
#define ENDDO(enddo)              enddo
#endif

// Text
#define INFO_MESSAGE(message)                .byt COMMAND_INFO_MESSAGE,message,0
#define QUICK_MESSAGE(message)               .byt COMMAND_QUICK_MESSAGE,message,0
#define ERROR_MESSAGE(message)               .byt COMMAND_ERROR_MESSAGE,message,0
#define WHITE_BUBBLE(bubble_count)           .byt COMMAND_WHITE_BUBBLE,bubble_count
#define BLACK_BUBBLE(bubble_count)           .byt COMMAND_BLACK_BUBBLE,bubble_count
#define _BUBBLE_LINE(x,y,yoffset,text)       .byt x,y,yoffset,text,0
#define CLEAR_TEXT_AREA(paper_color)         .byt COMMAND_CLEAR_TEXT_AREA,16+(paper_color&7)
#define CLEAR_FULL_TEXT_AREA(paper_color)    .byt COMMAND_CLEAR_FULL_TEXT_AREA,16+(paper_color&7)

// Meta game
#define UNLOCK_ACHIEVEMENT(achievement)      .byt COMMAND_UNLOCK_ACHIEVEMENT,achievement
#define DECREASE_SCORE(points)               .byt COMMAND_INCREASE_SCORE,<(65536-points),>(65536-points)
#define INCREASE_SCORE(points)               .byt COMMAND_INCREASE_SCORE,<points,>points
#define GAME_OVER(condition)                 .byt COMMAND_GAME_OVER,condition

#define START_CLOCK                          .byt COMMAND_START_CLOCK
#define STOP_CLOCK                           .byt COMMAND_STOP_CLOCK

#define WAIT_KEYPRESS                        .byt COMMAND_WAIT_KEYPRESS

// Items
#define SET_CURRENT_ITEM(item)                  .byt COMMAND_SET_CURRENT_ITEM,item
#define SET_ITEM_LOCATION(item,location)        .byt COMMAND_SET_ITEM_LOCATION,item,location
#define SET_ITEM_FLAGS(item,flags)              .byt COMMAND_SET_ITEM_FLAGS,item,flags
#define UNSET_ITEM_FLAGS(item,flags)            .byt COMMAND_UNSET_ITEM_FLAGS,item,255^flags
#define SET_ITEM_DESCRIPTION(item,description)  .byt COMMAND_SET_ITEM_DESCRIPTION,item,description,0

// Locations
#define SET_LOCATION_DIRECTION(location,direction,value)  .byt COMMAND_SET_LOCATION_DIRECTION,location,direction,value
#define SET_PLAYER_LOCATION(location)                   .byt COMMAND_SET_PLAYER_LOCATION,location
#define SET_SCENE_IMAGE(imageId)                     .byt COMMAND_SET_SCENE_IMAGE,imageId

// Graphics
#define BLOCK_SIZE(w,h) w,h

#define DRAW_BITMAP(imageId,size,stride,src,dst)     .byt COMMAND_BITMAP,imageId,size,stride,<src,>src,<dst,>dst
#define DISPLAY_IMAGE(imagedId)                      .byt COMMAND_DISPLAY_IMAGE,imagedId
#define DISPLAY_IMAGE_NOBLIT(imagedId)               .byt COMMAND_DISPLAY_IMAGE_NOBLIT,imagedId
#define FADE_BUFFER                                  .byt COMMAND_FADE_BUFFER

#define BLIT_BLOCK(imageId,w,h)                      .byt COMMAND_BITMAP,imageId,w,h,40
#define BLIT_BLOCK_STRIDE(imageId,w,h,stride)        .byt COMMAND_BITMAP,imageId,w,h,stride
#define _BUFFER(x,y)                                 .byt <_ImageBuffer+x+(40*y),>_ImageBuffer+x+(40*y)
#define _IMAGE(x,y)                                  .byt <_SecondImageBuffer+x+(40*y),>_SecondImageBuffer+x+(40*y)
#define _IMAGE_STRIDE(x,y,stride)                    .byt <_SecondImageBuffer+x+(stride*y),>_SecondImageBuffer+x+(stride*y)
#define _SCREEN(x,y)                                 .byt <$a000+x+(40*y),>$a000+x+(40*y)

// Sound 
#ifdef ENABLE_SOUND_EFFECTS
#define PLAY_SOUND(sound)                            .byt COMMAND_PLAY_SOUND,<sound,>sound
#else
#define PLAY_SOUND(sound)                            
#endif

#ifdef ENABLE_MUSIC
#define LOAD_MUSIC(musicId)                          .byt COMMAND_LOAD_MUSIC,musicId
#define STOP_MUSIC()                                 .byt COMMAND_STOP_MUSIC
#else
#define LOAD_MUSIC(musicId)                          
#define STOP_MUSIC()                                 
#endif


// Audio commands
#define SOUND_NOT_PLAYING        255

#define SOUND_COMMAND_END        0      // End of the sound
#define SOUND_COMMAND_END_FRAME  1      // End of command list for this frame
#define SOUND_COMMAND_SET_BANK   2      // Change a complete set of sounds: <14 values copied to registers 0 to 13>
#define SOUND_COMMAND_SET_VALUE  3      // Set a register value: <register index> <value to set>
#define SOUND_COMMAND_ADD_VALUE  4      // Add to a register:    <register index> <value to add>
#define SOUND_COMMAND_REPEAT     5      // Defines the start of a block that will repeat "n" times: <repeat count>
#define SOUND_COMMAND_ENDREPEAT  6      // Defines the end of a repeating block


#define REG_A_FREQ_LOW	  0     ; Chanel A Frequency (lower 8 bits)
#define REG_A_FREQ_HI	  1     ; Chanel A Frequency (higher 4 bits)
#define REG_B_FREQ_LOW	  2     ; Chanel B Frequency (lower 8 bits)
#define REG_B_FREQ_HI	  3     ; Chanel B Frequency (higher 4 bits)
#define REG_C_FREQ_LOW	  4     ; Chanel C Frequency (lower 8 bits)
#define REG_C_FREQ_HI	  5     ; Chanel C Frequency (higher 4 bits)
#define REG_NOISE_FREQ	  6     ; Chanel sound generator (0-31)
#define REG_MIXER		  7     ; Mixer/Selector -> Everything is disabled by default
#define REG_A_VOLUME	  8     ; Volume A
#define REG_B_VOLUME      9     ; Volume B
#define REG_C_VOLUME	 10     ; Volume C
#define REG_ENV_LOW      11     ; Wave period
#define REG_ENV_HI       12     ; Wave period
#define REG_ENV_SHAPE    13     ; Wave form


// Text commands
#define TEXT_END                 255
#define TEXT_CRLF                254

// End command
#define FLAG_END_STREAM          1
#define FLAG_WAIT                2
#define FLAG_REFRESH_SCENE       4
#define FLAG_PARTIAL_REFRESH     8


// Value mapping
#define VALUE_MAPPING(value,address)            .byt value,<address,>address
#define VALUE_MAPPING2(value1,value2,address)   .byt value1,value2,<address,>address
#define COMBINE_MAPPING(value1,value2,address)  .byt value1,value2,<address,>address,value2,value1,<address,>address
#define WORD_MAPPING(value,address,flag)        .byt value,flag,<address,>address

// This mapping list of flags should probably be redone, but good enough for now
// Basically, should separate concepts: Is it CODE or STREAM, and does it require an item(s) lookup in a table
#define FLAG_MAPPING_DEFAULT             0      // Just a simple C or assembler function to call
#define FLAG_MAPPING_STREAM              1      // 0 = Function pointer,  1 = Stream pointer
#define FLAG_MAPPING_TWO_ITEMS           2      // 0 = Only one item, 1 = Two items (ex: Combine)
#define FLAG_MAPPING_STREAM_CALLBACK     4      // No item at all, just a stream callback
