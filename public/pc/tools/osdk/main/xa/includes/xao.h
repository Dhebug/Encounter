

// sets file option after pass 1 
extern void set_fopt(int l, signed char *buf, int reallen);

// writes file options to a file
extern void o_write(FILE *fp);

// return overall length of header options
extern size_t o_length(void);

