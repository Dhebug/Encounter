#ifndef ASMSUP_H
#define ASMSUP_H

#ifdef WIN32
//#ifdef __MSVC_VER
#define MANGLE_SYM(s) _##s
#else
#define MANGLE_SYM(s) s
#endif

#endif
