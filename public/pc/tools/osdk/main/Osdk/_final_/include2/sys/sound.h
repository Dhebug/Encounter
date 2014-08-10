/* sys/sound.h */

#ifndef _SYS_SOUND_

#define _SYS_SOUND_


/* The PING (bell) sound. */

extern void ping(void);


/* Gunshot sound. */

extern void shoot(void);


/* Zap sound. */

extern void zap(void);


/* Explosion sound. */

extern void explode(void);


/* Keyclick #1, normal keys. */

extern void kbdclick1(void);


/* Keyclick #2, special keys. */

extern void kbdclick2(void);


/* The play command sets the state of the GI AY-3-8912 sound chip. */

   /* Same as ROM BASIC PLAY command. You can use the following */
   /* macros to address channel combinations and/or envelope    */
   /* patterns. */

#define PCHN_1   001
#define PCHN_2   002
#define PCHN_12  003
#define PCHN_3   004
#define PCHN_13  005
#define PCHN_23  006
#define PCHN_123 007

#define ENV_DECAY       001  /* \_________ envelope */
#define ENV_ATTACK_CUT  002  /* /_________ envelope */
#define ENV_SAW_DOWN    003  /* \\\\\\\\\\ envelope */
#define ENV_WAVE        004  /* /\/\/\/\/\ envelope */
#define ENV_DECAY_CONT  005  /* \~~~~~~~~~ envelope */
#define ENV_SAW_UP      006  /* ////////// envelope */
#define ENV_ATTACK_CONT 007  /* /~~~~~~~~~ envelope */

#define VOL_ENVELOPE  0x0
#define VOL_QUIETEST  0x1
#define VOL_LOUDEST   0xe

extern int play(int soundchanels,int noisechanels,int envelop,int volume);


/* Play a musical tone through the selected channel. */

#define CHAN_1   1
#define CHAN_2   2
#define CHAN_3   3

#define NOTE_C   1
#define NOTE_C-  2
#define NOTE_D   3
#define NOTE_D-  4
#define NOTE_E   5
#define NOTE_F   6
#define NOTE_F-  7
#define NOTE_G   8
#define NOTE_G-  9
#define NOTE_A  10
#define NOTE_A- 11
#define NOTE_B  12

#define NOTE_DO    1
#define NOTE_DO-   2
#define NOTE_RE    3
#define NOTE_RE-   4
#define NOTE_MI    5
#define NOTE_FA    6
#define NOTE_FA-   7
#define NOTE_SOL   8
#define NOTE_SOL-  9
#define NOTE_LA   10
#define NOTE_LA-  11
#define NOTE_SI   12

extern int music(int channel,int octave,int key,int volume);


/* Play a sound of given period (1/frequency) through the */
/* specified channel. */

extern int sound(int channel,int period,int volume);


#endif /* _SYS_SOUND_ */

/* end of file sys/sound.h */

