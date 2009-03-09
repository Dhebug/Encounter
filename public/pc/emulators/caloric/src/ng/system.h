/*
 *	system.h
 *	AYM 2003-08-04
 */

/*
This file is copyright André Majorel 2003.

This program is free software; you can redistribute it and/or modify it under
the terms of version 2 of the GNU General Public License as published by the
Free Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 59 Temple
Place, Suite 330, Boston, MA 02111-1307, USA.
*/


#ifndef SYSTEM_H
#define SYSTEM_H


/* This class contains everything that is shared between all the
   components */
class Oric
{
  public :
    System ();
    ~System ();
    bool irq;
    bool overlay;
    bool vsync;

  protected :
    unsigned char mem[0x10000];		
    int banknum; 

  private :

};


/* This class c */
class Component
{
  public :
    Component () = 0;
    ~Component () = 0;

  private :
};


#endif
