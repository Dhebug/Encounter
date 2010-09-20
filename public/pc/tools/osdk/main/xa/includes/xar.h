
#ifndef _RELOCATION_H_
#define _RELOCATION_H_

// jumps to r[td]_set, depending on segment 

#define	RMODE_ABS	0
#define	RMODE_RELOC	1

extern void r_mode(int mode);

extern int rmode;


struct relocateInfo 
{
	int             next;
	int             adr;
	int             afl;			
	int             lab;
};


class Relocation
{
public:
	Relocation(bool is_text);
	~Relocation();

	int Set(int pc,int afl,int l,int lab);
	int Write(FILE *fp,int pc);

private:
	Relocation();

public:
	bool			m_is_text;		// text/data
	relocateInfo 	*rlist;
	int 			mlist;
	int				nlist;
	int				first;
};


#endif

