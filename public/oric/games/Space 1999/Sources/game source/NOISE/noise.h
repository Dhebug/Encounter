/*	This is NOISE (Novel Oric ISometric Engine)
 	Version 0.1
	José María Enguita
	2005
*/

#ifndef _NOISE_H_
#define _NOISE_H_


#include "noise_defs.h"

extern char sizes_i[]; 
extern char sizes_j[];
extern char sizes_k[]; //This should be doubled for pixel precision. Height has double granularity.



typedef struct t_cliprgn{
    unsigned char x_clip;     /* in pixel */
    unsigned char y_clip;
    unsigned char width_clip; /* in scans */
    unsigned char height_clip;
    }cliprgn_t;

extern cliprgn_t clip_rgn; 

extern char orig_i;
extern char orig_j;

/* Definitions for graphics and sprites */

typedef struct t_sprite {
     unsigned char lines;
     unsigned char scans;
     unsigned char * image;
     unsigned char * mask;
}sprite_t;


typedef struct t_moving_object {
    unsigned char fine_coord_i;     // Fine coordinate on isometric view i
    unsigned char fine_coord_j;     // Fine coordinate on isometric view j
    unsigned char fine_coord_k;     // Fine coordinate on isometric view k (height)
    unsigned char type;             // Type code bit 7: special, bit 6: invert picture, bits 5-0 size code
}moving_object_t;

  

/* Objects that might move in the game */

extern moving_object_t characters[]; // Index 0 is the PLAYER. Up to 32 in memory.
extern sprite_t char_pics[];         // Sprites for characters (6bytesx32=192)
extern unsigned char num_chars;        // Number of characters in screen (up to MAX_CHARS)
extern char chars_in_room[];  // Codes of characters in room
extern char_tiles_i[MAX_CHARS]; // i coordinate of tile in which lower-left corner of a character is in.
extern char_tiles_j[MAX_CHARS]; // j coordinate of tile in which lower-left corner of a character is in.
extern char_tiles_k[MAX_CHARS]; // k layer in which a character is in.

/* Room data */
extern sprite_t bkg_graphs[]; 
extern void * layers[];


typedef struct t_collision_data{
	unsigned char id;	// ID of object collided with. 
	unsigned char i;	// These are fine coords if collided with a free object
	unsigned char j;	// and tile coords if collided with background.
	unsigned char k;
} collision_data_t;

extern collision_data_t bkg_collision_list[];
extern char num_bkg_collisions;

extern collision_data_t obj_collision_list[];
extern char num_obj_collisions;

extern char init_when_setting; // if !=0 indicates that blocks in room should be init after calling set_tile

/* Declare the assembly code functions */
char * pixel_address(unsigned char x_pos,unsigned char y_pos,unsigned char *bit);
void put_sprite(unsigned char x_pos, unsigned char y_pos, sprite_t * sprite, char invert);
void put_sprite2(unsigned char x_pos, unsigned char y_pos, sprite_t * sprite, char invert);
void clear_clip_rgn();
void ij2xy(unsigned char i, unsigned char j, unsigned char *x, unsigned char * y);
char dodiv6(char op);
void set_doublebuff(char onoff);
void clear_buff();
void paint_buff();
void draw_room();
char get_tile(char i, char j, char k);
void set_tile(char i, char j, char k, char tilecode);
void recalc_clip(char who);
int collision_test(char who, char dir_mov);
void move_sprite(char who, char dir_mov);
void init_room();

#endif //_NOISE_H_