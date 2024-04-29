
- [Audio](#audio)
  - [Sound Effects](#sound-effects)
    - [Commands](#commands)
    - [Example](#example)
  - [Music](#music)
    - [Exporting musics](#exporting-musics)


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
### Exporting musics
The source format of the Arkos Tracker 2 tunes is "AKS", but to use on the Oric we need to convert them to the "AKY" format, using the 6502 source code variant.

This export can be done in the Arkos Tracker using the Export menu, but can also be automated using the command line tools present in the "tool" folder of the tracker (these have been copied to be "bin" folder).

Here are the options of the exporter:
```
Converts to AKY any song that can be loaded into Arkos Tracker 2.
Usage: SongToAky [-s <subsong number>] [-p <comma separated psg numbers>] [-reladr] [--exportAsBinary] [--encodingAddress <address>] [--labelPrefix <prefix>] [--sourceProfile <z80/68000/6502acme/6502mads>] [-spadr <address>] [-spcom "<xxx>"] [-spskipcom] [-spbyte "<xxx>"] [-spword "<xxx>"] [-spstr "<xxx>"] [-spprelbl "<xxx>"] [-sppostlbl "<xxx>"] [-spbig] [--exportPlayerConfig] <path to input song> <path to output AKY>

<path to input song>               Path and filename to the song to load.
<path to output AKY>               Path and filename to the AKY file to create.
-s, --subsong                      The subsong number (>=1). 1 is default.
-p, --psgs                         The PSG numbers (>=1), comma separated (example: 1,2,3. 1 is default).
-bin, --exportAsBinary             If present, exports as a binary file. If not, exports as source (default).
-adr, --encodingAddress            If present, encodes the file to this address (may be hex (0xa000 for example)). Mandatory if encoding as binary.
--labelPrefix                      Useful for source generation. Indicates a prefix to all the labels.
--sourceProfile                    When generating the sources, indicates what source profile to use (among z80, 68000, 6502acme, 6502mads). Default is z80. If the export is binary, z80 must be chosen. Mnemonics can be overridden by the other related command line parameters.
-spadr                             When generating the sources, overrides the mnemonic to set the current address ("org" for example). Can be put between "".
-spcom                             When generating the sources, overrides the string to declare a comment (";" for example). Can be put between "".
-spskipcom                         When generating the sources, skips the comments if present.
-spbyte                            When generating the sources, overrides the mnemonic to declare a byte ("db" for example). Can be put between "".
-spword                            When generating the sources, overrides the mnemonic to declare a word ("dw" for example). Can be put between "".
-spstr                             When generating the sources, overrides the mnemonic to declare a string ("ds" for example). Can be put between "".
-spprelbl                          When generating the sources, defines a prefix to every label ("." for example). Can be put between "".
-sppostlbl                         When generating the sources, defines a postfix to every label (":" for example). Can be put between "".
-spbig                             When generating the sources, declares big-endianness if present.
-spomt                             When generating the sources, only one mnemonic type per line, if present.
--exportPlayerConfig               Exports a player configuration source file, if present.
-reladr                            If present, all the encoded label references will be relative to the start of the song (for example: "dw myLabel - songStart"). Useful mostly for Atari ST players.
```

For OSDK compatibility, we select the **6502acme** export format, but with different keywords for the encoding (**.byt** instead of **db** and **.word** instead of **dw**), which gives the following command line:

> bin\SongToAky --sourceProfile 6502acme -spbyte ".byt" -spword ".word" data\<source file>.aks code\<target file>.s


