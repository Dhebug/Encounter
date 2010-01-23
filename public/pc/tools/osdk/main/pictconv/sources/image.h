#ifndef IMAGE_CONTAINER_H
#define IMAGE_CONTAINER_H

// Crappy FreeImage wrapper
#include <string>
#include <vector>
#include <map>

struct FIBITMAP;
class RgbColor;
class AtariClut;

class ImageContainer
{
public:
	ImageContainer();
	ImageContainer(const ImageContainer& otherImage);
	~ImageContainer();

	void Clear();
	bool Allocate(unsigned int width,unsigned int height,unsigned int bpp);

	FIBITMAP* GetBitmap()
	{
		return m_pBitmap;
	}

	unsigned int GetWidth() const;
	unsigned int GetHeight() const;
	unsigned int GetDpp() const;
	unsigned int GetPaletteSize() const;

	bool LoadPicture(const std::string& fileName);
	bool SavePicture(const std::string& fileName) const;

	void WriteColor(const RgbColor& rgb,int x,int y);
	RgbColor ReadColor(int x,int y) const;

	// Utility functions
	bool ConvertToGrayScale();	// Pure grey scale conversion
	bool ReduceColorDepth(const AtariClut* pClut=0);
	bool ReduceColorDepthPerScanline(const std::map<int,AtariClut>* pCluts=0);

	// Block copy functions
	bool CreateFromImage(const ImageContainer& otherImage,unsigned int x,unsigned int y,unsigned int width,unsigned int height);	// Accepts itself as a valid source, can use that to crop a picture

private:
	FIBITMAP*	m_pBitmap;
};


// Utility function missing from the FreeImage library
unsigned char* FreeImage_GetBitsRowCol(FIBITMAP *dib,int x,int y);


#endif
