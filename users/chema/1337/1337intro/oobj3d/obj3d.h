/* Obj3D Definition file */
/* Oric port Chema 2008  */

#ifndef _OBJ3D_H_
#define _OBJ3D_H_

#define X1 _LargeX0	
#define Y1 _LargeY0
#define X2 _LargeX1	
#define Y2 _LargeY1



//#define USEOBLETS

//#define AVOID_INVISBLEVERTICES

// Maximum number of objects that can be handled
// Was  32*2  
#define MAXOBJS     8
#define MAXVERTEX   64

/*
 Each object is of the following form (32 bytes):

 Object:
        CenterX          2 bytes
        CenterY          2 bytes
        CenterZ          2 bytes
        Obj data pointer 2 bytes
        ID byte          1 byte
        User byte        1 byte
        Center position  1 byte
        CenterXRem       1 byte
              YRem       1 byte
              ZRem       1 byte
        Orientation matrix 18 bytes
*/


#define ObjCX       0
#define ObjCY       2
#define ObjCZ       4
#define ObjData     6
#define ObjID       8
#define ObjUser     9
#define ObjCenPos   10
#define ObjCXRem    11
#define ObjCYRem    12
#define ObjCZRem    13
#define ObjMat      14
#define ObjSize     32

/*
 CenterX/Y/Z represents the object location
 Data pointer points to object data, below.
 ID and user byte is optional, to let the user assign an ID to an object
 CenterX/Y/ZRem is the fractional part of the object centers,
   used by the movement routines
 Orientation matrix consists of 9-byte integer matrix and 9-byte remainder



 Object data: There are two types of
 objects, normal and compound, which
 are objects made up of a number of
 smaller "oblets".  Normal object data
 is of the following form:

        TypeID = 0   1 byte
        # of points  1 byte
        # of faces   1 byte
        xcoords      n bytes
        ycoords      n bytes
        zcoords      n bytes
    faces:
        # of points  1 byte
        fill pattern 1 byte
        point list   m bytes

 that is, point data followed by a list of faces.
 Fill pattern is an index into fill pattern list, used with solid polygons.
 x/y/zcoords consist of p object points (-96..96) followed by q normals.

 Compound objects are of the form:

        TypeID = $80 1 byte
        # of points  1 byte
        # of oblets  1 byte
        xcoords      n bytes
        ycoords      n bytes
        zcoords      n bytes
    oblets:
        ref points   p bytes
        oblet 1
          oblet size (in bytes)
                     1 byte
          # of faces 1 byte
          faces
        oblet 2 ...

 Each oblet is similar to a normal object, but is associated with a point
 in the point list -- the reference point.  The oblets are drawn by first
 depth-sorting these points and drawing from back to front.

*/


/* Oric Port... with TINE in mind */
/* The TypeID field indicates how the object is to be drawn
   by obj3D, and it has the following values: 
    +---------------+
    |c|x|x|x|d|m|s|p|
    +---------------+
     | | | | | | | |
     | | | | | | | +---------> Planet (draw as circle)
     | | | | | | +-----------> Sun (draw as filled circle)
     | | | | | +-------------> Moon (small circle) 
     | | | | +---------------> Space Debris (draw as little dot or square)
     | | | +-----------------> |
     | | +-------------------> > Free
     | +---------------------> |
     +-----------------------> Draw as compound object

*/

#define COMPOUND 128
#define NORMAL   0
#define PLANET   1
#define SUN      2
#define MOON     4
#define DEBRIS   8



#endif //_OBJ3D_H_