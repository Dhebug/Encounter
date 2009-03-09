# $Id:  $

AM_CPPFLAGS = -I./  $(SDL_CFLAGS) $(GTK_CFLAGS) $(GLADE_CFLAGS)

bin_PROGRAMS = caloric $(fcntl_programs)

caloric_SOURCES = 6502_c.c  datapath.c  host.c       interrup.c  locate.c  oric.c     screenshot.c  stats.c  ula.c config.c  dsp.c       hosttraps.c  keyb_us.c   misc.c    rcfiles.c  sdl.c         tape2.c  1793.S  6502.S  6551.S  8912.S  banks.S  charset.S  clock.S  debug.S  hardware.S  tape.S  time.S  traps.S  via1.S  via2.S

caloric_LDADD =  $(SDL_LIBS) $(GTK_LIBS) $(GLADE_LIBS)
caloric_LDFLAGS = $(SDL_CFLAGS) $(GTK_CFLAGS) $(GLADE_CFLAGS) @MATH_LIBS@ @SDL_LIBS@