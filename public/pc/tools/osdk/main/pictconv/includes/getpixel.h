



typedef struct
{
	unsigned char	red;
	unsigned char	green;
	unsigned char	blue;
}RGB;


BYTE* FreeImage_GetBitsRowCol(FIBITMAP *dib,int x,int y);
void GetColor(FIBITMAP *dib,RGB *rgb,int x,int y);
void WriteColor(FIBITMAP *dib,RGB *rgb,int x,int y);

