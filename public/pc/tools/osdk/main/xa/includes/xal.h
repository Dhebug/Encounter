

#include <stdio.h> 

extern char *gError_LabelNamePointer;			// For error reporting display

extern int gm_lab(void);
extern long gm_labm(void);
extern long ga_labm(void);

extern int DefineGlobalLabel(char *);

extern int b_init(void);
extern int b_depth(void);

extern int ga_blk(void);

extern int DefineLabel(char *s, int* l, int *x, int *f);
extern int l_such(char *s, int *l, int *x, int *v, int *afl);
extern void l_set(int n,int v,SEGMENT_e afl);
extern int l_get(int n, int *v, int *afl);
extern int LabelGetInformations(int index,int *ptr_value, char **ptr_label_name);
extern int LabelTableLookUp(char *s, int *n);     
extern int ll_pdef(char *t);

extern int b_open(void);
extern int b_close(void);

extern int l_write(FILE *fp);

