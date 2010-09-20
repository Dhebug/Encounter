
#ifndef _OPTIONS_H_
#define _OPTIONS_H_


struct Fopt;

class Options
{
public:
	Options();
	~Options();

	void Clear();

	void set_fopt(int l, signed char *buf, int reallen);			// sets file option after pass 1 
	void o_write(FILE *fp);										// writes file options to a file
	size_t o_length(void);										// return overall length of header options

public:
	Fopt	*m_olist;
	int		m_mlist;
	int		m_nlist;
};

#endif

