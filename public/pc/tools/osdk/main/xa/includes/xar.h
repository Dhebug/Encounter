

// jumps to r[td]_set, depending on segment 
extern int r_set(int pc, int reloc, int len);	
extern int u_set(int pc, int reloc, int label, int len);	

extern int rt_set(int pc, int reloc, int len, int label);
extern int rd_set(int pc, int reloc, int len, int label);
extern int rt_write(FILE *fp, int pc);
extern int rd_write(FILE *fp, int pc);

#define	RMODE_ABS	0
#define	RMODE_RELOC	1

extern void r_mode(int mode);

extern int rmode;

extern int h_write(FILE *fp, int mode, int tlen, int dlen, int blen, int zlen, int stacklen);

extern void seg_start(int fmode, int tbase, int dbase, int bbase, int zbase,
						int stacklen, int relmode);
extern void seg_end(FILE*);
extern void seg_pass2(void);


