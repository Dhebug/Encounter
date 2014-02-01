

#include <assert.h>
#include <stdio.h>
#include <fcntl.h>
#include <iostream>
#include <string.h>

#ifndef _WIN32
#include <unistd.h>
#endif

#include <sys/types.h>
#include <sys/stat.h>

#include "FreeImage.h"

#include "defines.h"
#include "getpixel.h"
#include "hires.h"
#include "oric_converter.h"
#include "dithering.h"

#include "common.h"

#include "image.h"


char *PtrSpaces;
char BufferSpaces[]="                                                                                                ";

int gcur_line=0;
int gmax_count=0;

bool FlagDebug=false;

/*
- u8: nombre de couleurs sur le bloc (1, 2, ou invalide)
- u8: couleur 1
- u8: couleur 2
- u8: flag (inverse vidéo possible, ...)
*/
struct BLOC6
{
  unsigned char	color_count;
  unsigned char	color[2];
  unsigned char	value;
};


BLOC6	Bloc6Buffer[40];	// For 240 pixel wide pictures


/*

Les cas possibles:
- 6 pixels unis.
* Ils peuvent être d'une de ces couleurs:
Utilisation de la couleur courante du papier
Utilisation de la couleur courante de l'encre
Utilisation de la couleur courante du papier, avec inversion vidéo
Utilisation de la couleur courante de l'encre, avec inversion vidéo

* On peur y faire:
Changement de papier de la même couleur
Changement de papier d'une couleur inversée de la couleur, en mettant la vidéo inverse



- 6 pixels, utilisant deux couleurs.




*/




bool RecurseLine(unsigned char count,BLOC6 *ptr_bloc6,unsigned char *ptr_hires,unsigned char cur_paper,unsigned char cur_ink)
{
  PtrSpaces-=2;

  /*
  if (gcur_line==138)
  {
  printf("\r\n Count:%d Paper:%d Ink:%d",count,cur_paper,cur_ink);
  }
  */
  /*
  if ((time(0)-gLastTimer)>2)
  {
  //
  // End of recursion with error
  //
  if (!FlagDebug)
  {
  return false;
  }
  }
  */

  if (count<gmax_count)
  {
    gmax_count=count;
    //printf("\r\n MaxCount:%d",gmax_count);
    /*
    if ((gcur_line==138) && (gmax_count==34))
    {
    __asm {int 3 }
    }
    */
  }

  if (!count)
  {
    //
    // End of recursion
    //
    return true;
  }

  unsigned char	color_count=ptr_bloc6->color_count;
  unsigned char	c0=ptr_bloc6->color[0];
  unsigned char	c1=ptr_bloc6->color[1];
  unsigned char	v =ptr_bloc6->value;


  count--;
  ptr_bloc6++;
  ptr_hires++;

  if (color_count==1)
  {
    // ========================================
    // The current bloc of pixels is using only 
    // one color. It's the right opportunity to
    // change either the PAPER or the INK color.
    // ========================================

    if (c0==cur_paper)
    {
      //
      // The 6 pixels are using the current paper color.
      //

      // Use current paper color
      if (FlagDebug)	printf("\r\n %sUse paper color (%d)",PtrSpaces,cur_paper);
      if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
      {
        ptr_hires[-1]=64;
        return true;
      }

      // Try each of the 8 possible ink colors
      for (unsigned char color=0;color<8;color++)
      {
        if (FlagDebug)	printf("\r\n %sUse paper color (%d) while changing ink color to (%d)",PtrSpaces,cur_paper,color);
        if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,color))
        {
          ptr_hires[-1]=color;
          return true;
        }
      }
    }

    // Use current ink color
    if (c0==cur_ink)
    {
      if (FlagDebug)	printf("\r\n %sUse ink color (%d)",PtrSpaces,cur_ink);
      if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
      {
        ptr_hires[-1]=64|63;
        return true;
      }
    }


    if (c0==(7-cur_paper))
    {
      //
      // The 6 pixels are using the current inverted paper color.
      //

      // Use current paper color
      if (FlagDebug)	printf("\r\n %sUse inverted paper color (%d => %d)",PtrSpaces,cur_paper,7-cur_paper);
      if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
      {
        ptr_hires[-1]=128|64;
        return true;
      }

      // Try each of the 8 possible ink colors
      for (unsigned char color=0;color<8;color++)
      {
        if (FlagDebug)	printf("\r\n %sUse inverted paper color (%d => %d) while changing ink color to (%d)",PtrSpaces,cur_paper,7-cur_paper,color);
        if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,color))
        {
          ptr_hires[-1]=128|color;
          return true;
        }
      }
    }

    // Use current inverted ink color
    if (c0==(7-cur_ink))
    {
      if (FlagDebug)	printf("\r\n %sUse inverted ink color (%d => %d)",PtrSpaces,cur_ink,7-cur_ink);
      if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
      {
        ptr_hires[-1]=128|64|63;
        return true;
      }
    }

    // Change paper color
    if (FlagDebug)	printf("\r\n %sChange paper color to (%d)",PtrSpaces,c0);
    if (RecurseLine(count,ptr_bloc6,ptr_hires,c0,cur_ink))
    {
      ptr_hires[-1]=16+c0;
      return true;
    }


    // Change paper color, using inverse vidéo
    if (FlagDebug)	printf("\r\n %sChange paper color to (%d) using inversion (%d)",PtrSpaces,7-c0,c0);
    if (RecurseLine(count,ptr_bloc6,ptr_hires,7-c0,cur_ink))
    {
      ptr_hires[-1]=128|16+(7-c0);
      return true;
    }
  }
  else
  {
    // ========================================
    // The current bloc of pixels is using two 
    // different colors. It's totaly impossible
    // to use attributes changes on this one.
    // ========================================


    // Try simple pixels.
    if ((c0==cur_paper) && (c1==cur_ink))
    {
      if (FlagDebug)	printf("\r\n %sUse current colors (%d,%d)",PtrSpaces,cur_paper,cur_ink);
      if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
      {
        ptr_hires[-1]=64|v;
        return true;
      }
    }

    // Try simple pixels, but invert the bitmask.
    if ((c0==cur_ink) && (c1==cur_paper))
    {
      if (FlagDebug)	printf("\r\n %sUse current colors (%d,%d)",PtrSpaces,cur_paper,cur_ink);
      if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
      {
        ptr_hires[-1]=64|(v^63);
        return true;
      }
    }

    // Try simple video inverted pixels.
    if ((c0==(7-cur_paper)) && (c1==(7-cur_ink)))
    {
      if (FlagDebug)	printf("\r\n %sUse current inverted colors (%d,%d) => (%d,%d)",PtrSpaces,cur_paper,cur_ink,7-cur_paper,7-cur_ink);
      if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
      {
        ptr_hires[-1]=128|64|v;
        return true;
      }
    }

    // Try simple video inverted pixels, but invert the bitmask.
    if ((c0==(7-cur_ink)) && (c1==(7-cur_paper)))
    {
      if (FlagDebug)	printf("\r\n %sUse current inverted colors (%d,%d) => (%d,%d)",PtrSpaces,cur_paper,cur_ink,7-cur_paper,7-cur_ink);
      if (RecurseLine(count,ptr_bloc6,ptr_hires,cur_paper,cur_ink))
      {
        ptr_hires[-1]=128|64|(v^63);
        return true;
      }
    }
  }

  //printf("\r\n ==== back track !!! ====");
  //getch();
  PtrSpaces+=2;
  return false;
}


void OricPictureConverter::convert_colored(const ImageContainer& sourcePicture)
{
  ImageContainer convertedPicture(sourcePicture);

  //
  // Phase 1: Create a buffer with infos
  //
  bool flag=false;
  unsigned char *ptr_hires=m_Buffer.m_buffer;

  bool error_in_picture=false;

  for (unsigned y=0;y<m_Buffer.m_buffer_height;y++)
  {
    if (m_flag_debug)
    {
      printf("\r\nLine %d ",y);
    }

    BLOC6 *ptr_bloc6=Bloc6Buffer;
    bool error_in_line=false;

    //
    // Create a buffer for the scanline
    //
    int x=0;
    for (int col=0;col<m_Buffer.m_buffer_cols;col++)
    {
      bool error_in_bloc=false;

      // Init that bloc
      ptr_bloc6->color_count=0;
      ptr_bloc6->color[0]=0;
      ptr_bloc6->color[1]=0;
      ptr_bloc6->value=0;

      for (int bit=0;bit<6;bit++)
      {
        ptr_bloc6->value<<=1;

        // Get the original pixel color 
        BYTE *ptr_byte=FreeImage_GetBitsRowCol(convertedPicture.GetBitmap(),x,y);
        unsigned char color=0;
        if ((*ptr_byte++)>128)	color|=4;
        if ((*ptr_byte++)>128)	color|=2;
        if ((*ptr_byte++)>128)	color|=1;

        // Check if it's already present in the color map
        switch (ptr_bloc6->color_count)
        {
        case 0:
          ptr_bloc6->color_count++;
          ptr_bloc6->color[0]=color;
          ptr_bloc6->color[1]=color;	// To avoid later tests
          break;

        case 1:
          if (ptr_bloc6->color[0]!=color)
          {
            // one more color
            ptr_bloc6->color_count++;
            ptr_bloc6->color[1]=color;
            ptr_bloc6->value|=1;
          }
          break;

        case 2:
          if (ptr_bloc6->color[0]!=color)
          {
            if (ptr_bloc6->color[1]==color)
            {
              // second color
              ptr_bloc6->value|=1;
            }
            else
            {
              // color overflow !!!
              ptr_bloc6->color_count++;

              error_in_bloc=true;
            }
          }
          break;
        }
        x++;
      }

      if (error_in_bloc)
      {
        if (!error_in_line)
        {
          printf("\r\nLine %d ",y);
        }
        printf("[%d colors bloc %d] ",ptr_bloc6->color_count,col);
        error_in_line=true;
      }
      ptr_bloc6++;
    }
    if (error_in_line)
    {
      error_in_picture=true;
    }

    //
    // Convert to monochrome
    //
    //gLastTimer=time(0);
    ptr_bloc6=Bloc6Buffer;

    unsigned char val;

    PtrSpaces=BufferSpaces+strlen(BufferSpaces);
    gcur_line=y;
    gmax_count=m_Buffer.m_buffer_cols;
#ifdef _DEBUG
    if (y==138)
    {
      //__asm int 3;
    }
#endif
    if (RecurseLine((unsigned char)m_Buffer.m_buffer_cols,ptr_bloc6,ptr_hires,0,7))
      //if (RecurseLine(7,ptr_bloc6,ptr_hires,0,7))
    {
      //
      // Recursion work.
      // Nothing to do.
      //
      if (FlagDebug)	
      {
        printf("\r\n ======= found =====");
        printf("\r\n Dump: ");
        for (int col=0;col<7;col++)
        {
          val=ptr_hires[col];
          printf("[%d,%d,%d] ",(val>>7)&1,(val>>6)&1,(val&63));
        }

        //getch();
      }
      ptr_bloc6+=m_Buffer.m_buffer_cols;
      ptr_hires+=m_Buffer.m_buffer_cols;
    }
    else
    {
      if (!error_in_line)
      {
        printf("\r\nLine %d ",y);
      }
      printf(" max:%d ",gmax_count);

      //
      // Unable to perfom conversion
      // Use standard monochrom algorithm
      //
      x=0;
      for (int col=0;col<m_Buffer.m_buffer_cols;col++)
      {
        if (flag)
        {
          if (ptr_bloc6->color_count>2)
          {
            val=127;
          }
          else
          {
            val=64;
          }
        }
        else
        {
          val=64+ptr_bloc6->value;
        }
        *ptr_hires++=val;
        ptr_bloc6++;
      }
    }
  }
}

