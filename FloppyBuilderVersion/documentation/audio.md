# Audio

## Sound Effects
The sound effects system is using a custom system running at 200hz

For performance reason, the sound system maintains its own copy of the AY sound register, and then update the sound chip.
```
_PsgVirtualRegisters
_PsgfreqA 		.byt 0,0    ;  0 1    Chanel A Frequency
_PsgfreqB		.byt 0,0    ;  2 3    Chanel B Frequency
_PsgfreqC		.byt 0,0    ;  4 5    Chanel C Frequency
_PsgfreqNoise	.byt 0      ;  6      Chanel sound generator
_Psgmixer		.byt 0      ;  7      Mixer/Selector
_PsgvolumeA		.byt 0      ;  8      Volume A
_PsgvolumeB		.byt 0      ;  9      Volume B
_PsgvolumeC		.byt 0      ; 10      Volume C
_PsgfreqShape   .byt 0,0    ; 11 12   Wave period
_PsgenvShape    .byt 0      ; 13      Wave form
```
The reason is that some of the registers need to be updated at the bit level (like the mixer register #7), and due to the way the AY chip is interfaced with the Oric, it requires some heavy VIA twidling to perform any operations.

By having this "cache", we don't have to read back the values.

### Commands
```
// Audio commands
#define SOUND_NOT_PLAYING        255

#define SOUND_COMMAND_END        0      // End of the sound
#define SOUND_COMMAND_END_FRAME  1      // End of command list for this frame
#define SOUND_COMMAND_SET_BANK   2      // Change a complete set of sounds: <14 values copied to registers 0 to 13>
#define SOUND_COMMAND_SET_VALUE  3      // Set a register value: <register index> <value to set>
#define SOUND_COMMAND_ADD_VALUE  4      // Add to a register:    <register index> <value to add>
#define SOUND_COMMAND_REPEAT     5      // Defines the start of a block that will repeat "n" times: <repeat count>
#define SOUND_COMMAND_ENDREPEAT  6      // Defines the end of a repeating block
```

### Example
```; A FREQ (LOW|HIGH), B FREQ (LOW|HIGH), C FREQ (LOW|HIGH), N FREQ, CONTROL, A VOL, B VOL, C VOL, ENV (LOW|HIGH)
;                                           0   1   2   3   4   5   6   7   8   9   10  11  12  13
_ExplodeData    .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$1F,$07,$10,$10,$10,$00,$18,$00,SOUND_COMMAND_END
_ShootData      .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$0F,$07,$10,$10,$10,$00,$08,$00,SOUND_COMMAND_END
_PingData       .byt SOUND_COMMAND_SET_BANK,$18,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$00,$0F,$00,SOUND_COMMAND_END
_KeyClickHData  .byt SOUND_COMMAND_SET_BANK,$1F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00,SOUND_COMMAND_END
_KeyClickLData  .byt SOUND_COMMAND_SET_BANK,$2F,$00,$00,$00,$00,$00,$00,$3E,$10,$00,$00,$1F,$00,$00,SOUND_COMMAND_END

_ZapData        .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$00,$3E,$0F,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_REPEAT,40
                .byt SOUND_COMMAND_ADD_VALUE,0,2,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_ENDREPEAT			
                .byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END       ; Finally set the volume to 0
                .byt SOUND_COMMAND_END

// 200 hz version
_TypeWriterData .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$05,%11110111,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$04,SOUND_COMMAND_SET_VALUE,$08,$05,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$03,SOUND_COMMAND_SET_VALUE,$08,$0f,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$02,SOUND_COMMAND_SET_VALUE,$08,$0D,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$01,SOUND_COMMAND_SET_VALUE,$08,$0a,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$01,SOUND_COMMAND_SET_VALUE,$08,$07,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END                    ; Finally set the volume to 0
                .byt SOUND_COMMAND_END

_SpaceBarData   .byt SOUND_COMMAND_SET_BANK,$00,$00,$00,$00,$00,$00,$08,%11110111,$03,$00,$00,$00,$00,$00,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$0a,SOUND_COMMAND_SET_VALUE,$08,$05,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$07,SOUND_COMMAND_SET_VALUE,$08,$0f,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$05,SOUND_COMMAND_SET_VALUE,$08,$0D,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$04,SOUND_COMMAND_SET_VALUE,$08,$0a,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,$06,$03,SOUND_COMMAND_SET_VALUE,$08,$07,SOUND_COMMAND_END_FRAME
                .byt SOUND_COMMAND_SET_VALUE,8,0,SOUND_COMMAND_END                    ; Finally set the volume to 0
                .byt SOUND_COMMAND_END
```
**See:**
- [audio.s](../code/audio.s) for the sound engine implementation

## Music
The musics are using the Arkos Tracker 2 format running at 50hz

**TODO**
