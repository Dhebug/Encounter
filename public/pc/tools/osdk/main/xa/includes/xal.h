

#include <stdio.h> 

enum ErrorCode;

extern char *gError_LabelNamePointer;			// For error reporting display

extern int gm_lab(void);
extern long gm_labm(void);
extern long ga_labm(void);

extern int b_init(void);
extern int b_depth(void);

extern int ga_blk(void);

extern int b_open(void);
extern ErrorCode b_close(void);


