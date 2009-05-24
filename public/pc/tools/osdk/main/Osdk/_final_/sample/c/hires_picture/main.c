//
// This program simply display a picture on the hires screen
//

#include <lib.h>

extern unsigned char LabelPicture[];

void main()
{
	hires();
	memcpy((unsigned char*)0xa000,LabelPicture,8000);
}

