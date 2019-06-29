
VPATH:=src

PICS= \
	logoa13.png \
	logovip1.png \
	logovip2.png \
	logovip3.png \
	logovip4.png \
	hey.png


TARGETS := \
	TUNEDORI.s \
	logoa13_c.s logoa13.h \
	logovip1_c.s logovip1.h \
	logovip2_c.s logovip2.h \
	logovip3_c.s logovip3.h \
	logovip4_c.s logovip4.h \
	hey_c.s hey.h \


DISABLED= \
	hey.png \
	scrl.png \
	scrlt.png \
	scrlm.png \
	scrlm1.png \
	scrlm2.png \
	scrlm3.png \
	scrlb.png \
	vip17_s1.png vip17_s1.tap vip17_s1.s vip17_s1.z2.png \
	alch12_1.png \
	alch12_2.png \
	alch12_3.png \
	alch12s1.png alch12s1.tap alch12s1.s alch12s1.z2.png \
	alch12s2.png alch12s2.tap alch12s2.s alch12s2.z2.png \
	alch12s3.png alch12s3.tap alch12s3.s alch12s3.z2.png \
	Minecrafter.ttf \
	qrcode_alchimie.png \
	qrcode_alchimie.tap \
	vip17_e1.png vip17_e1.z2.png \
	vip17_e2.png vip17_e2.z2.png \
	alch12.png \
	alch12s1.png alch12s1.tap alch12s1.s alch12s1.z2.png \
	vip2017_splash_oric_base.png \
	test3.png \
	test4.png \


# previews
PPICS= $(PICS:%.png=%_p.png)

# binary form for pics
BPICS= $(PICS:%.png=%.bin)

# source hex for pics
SPICS= $(PICS:%.png=%.s)

# C header with pic defines (width / height)
HPICS= $(PICS:%.png=%.h)

# compressed source
CPICS= $(PICS:%.png=%_c.s)

# tape for pics
TPICS= $(PICS:%.png=%.tap)

define targets_for =
 $(1:%.png=%_p.png) $(1:%.png=%.bin) $(1:%.png=%.s) $(1:%.png=%.h) $(1:%.png=%_c.s) $(1:%.png=%.tap)
endef



PICTCONV_M := -m0
#PICTCONV_OPTS := -f6 -d3

#$(PICS) 
all: $(TARGETS) pics.h
# SYNTORIC.s

# avoid circular deps...
%.out : %

debug:
	echo $(PICS)
	echo $(PPICS)
	echo $(BPICS)
	echo $(CPICS)
	echo $(HPICS)
	echo $(SPICS)
	echo $(TPICS)
	echo $(call targets_for,hey.png)

clean:
	rm -f $(PICS) $(PPICS) $(BPICS) $(CPICS) $(HPICS) $(SPICS) $(TPICS) oriccolors.png

preview: $(PPICS)

headers: $(HPICS)

pics.h: $(HPICS)
	cat $(HPICS) > $@

# XXX: remove Makefile dep!
$(PICS) $(PPICS): oriccolors.png Makefile

%_p.png: %.png
	$(OSDK)/bin/pictconv $(PICTCONV_M) $(PICTCONV_OPTS) -o5 $< $@

%.tap: %.png
	$(OSDK)/bin/pictconv $(PICTCONV_M) $(PICTCONV_OPTS) -o0 -v1 -n16 $< $@

%.s: %.png
	$(OSDK)/bin/pictconv $(PICTCONV_M) $(PICTCONV_OPTS) -o4_$(SYMNAME) -v1 -n16 $< $@

%.bin: %.png
	$(OSDK)/bin/pictconv $(PICTCONV_M) $(PICTCONV_OPTS) -o2 -v1 -n16 $< $@

%.h: %.png
	echo "/* $(SYMNAME) */" > $@
	echo "#define $(SYMNAME)_W $$(identify -verbose $< | grep 'Geometry:' | sed 's/x.*//;s/.* //')" >> $@
	echo "#define $(SYMNAME)_H $$(identify -verbose $< | grep 'Geometry:' | sed 's/.*x//;s/\+.*//')" >> $@
	# ifndef ASM ???
	#echo "#ifdef __LCC__" >> $@
	echo "extern unsigned char $(SYMNAME)[];" >> $@
	#echo "#endif" >> $@
	echo "" >> $@



%_c.s: %.bin
	$(OSDK)/bin/filepack $< $@.packed
	$(OSDK)/bin/bin2txt -s1 -f2 -n8 $@.packed $@ _$(SYMNAME)
	rm $@.packed


# zoomed up versions
%.z2.png: %.png
	convert -scale 480x400 $< $@



oriccolors.png:
	convert -size 1x1 'xc:#000000' 'xc:#0000ff' 'xc:#00ff00' 'xc:#00ffff' 'xc:#ff0000' 'xc:#ff00ff' 'xc:#ffff00' 'xc:#ffffff' +append $@

logocolors.png:
	convert -size 1x1 'xc:#000000' 'xc:#0000ff' 'xc:#ff00ff' 'xc:#ffffff' +append $@


qrcode_alchimie.png:
	qrencode -s 2 -m 0 -o $@ "http://triplea.fr/alchimie/"

qrcode_ualchimie.png:
	qrencode -s 2 -m 0 -o $@ "http://triplea.fr/microalchimie/"

qrcode_alchimie.tap: qrcode_alchimie.png
	$(OSDK)/bin/pictconv -m0 -f0 -d3 -o0 -v1 -n16 $< $@

qrcode_ualchimie.tap: qrcode_ualchimie.png
	$(OSDK)/bin/pictconv -m0 -f0 -d3 -o0 -v1 -n16 $< $@


logovip.png: cropped-57798684_10156621907129822_2811413531000307712_o.jpg
	convert \
		$< \
		-crop 262x428+32+36 \
		-threshold 22% \
		-scale 240x \
		-threshold 22% \
		+repage \
		-colors 2 \
		$@

$(call targets_for,logovip1.png): PICTCONV_OPTS=-f0 -d0
$(call targets_for,logovip1.png): SYMNAME=LogoVIP1

$(call targets_for,logovip2.png): PICTCONV_OPTS=-f0 -d0
$(call targets_for,logovip2.png): SYMNAME=LogoVIP2

$(call targets_for,logovip3.png): PICTCONV_OPTS=-f0 -d0
$(call targets_for,logovip3.png): SYMNAME=LogoVIP3

$(call targets_for,logovip4.png): PICTCONV_OPTS=-f0 -d0
$(call targets_for,logovip4.png): SYMNAME=LogoVIP4


logovip1.png: logovip.png
	convert \
		$< \
		-crop 240x100+0+0 \
		+repage \
		$@
#		-crop 240x200+0+0 \


logovip2.png: logovip.png
	convert \
		$< \
		-crop 240x100+0+100 \
		+repage \
		$@
#		-crop 240x200+0+200 \


logovip3.png: logovip.png
	convert \
		$< \
		-crop 240x100+0+200 \
		+repage \
		$@

logovip4.png: logovip.png
	convert \
		$< \
		-crop 240x100+0+300 \
		+repage \
		$@

$(call targets_for,hey.png): PICTCONV_OPTS=-f6 -d3
$(call targets_for,hey.png): SYMNAME=Hey

hey.png: bienvenue2019.png
	convert \
		$< \
		-crop 1500x712+0+396 \
		+dither \
		-scale 240x200 \
		+repage \
		-gamma 0.6 \
		$@
#		-gamma 0.95 \
#		-modulate 85,90 \
#		+dither \
#		-antialias \
#		-remap oriccolors.png \

$(call targets_for,logoa13.png): PICTCONV_OPTS=-f6 -d0
$(call targets_for,logoa13.png): SYMNAME=LogoA13

logoa13.png: black_alchimie13.png logocolors.png
	convert \
		$< \
		-crop 2000x600+300+338 \
		+dither \
		-scale 240x200 \
		+repage \
		$@
#		-remap oriccolors.png \
#		-gamma 0.95 \
#		-modulate 85,95 \
#		-colors 8 \
#		+dither \
#		-antialias \


#$(call targets_for,scrl.png): PICTCONV_OPTS=-f6 -d0
$(call targets_for,scrl.png): PICTCONV_OPTS=-f0 -d3
$(call targets_for,scrl.png): SYMNAME=Scroll

scrl.png: scroll.png
	convert \
		$< \
		-scale 240x200 \
		+dither \
		-antialias \
		-gamma 1.1 \
		-remap oriccolors.png \
		-background black \
		-gravity east \
		-extent 240x200 \
		$@


$(foreach pic,scrlt.png scrlm.png scrlm1.png scrlm2.png scrlm3.png scrlb.png,$(eval $(call targets_for,$(pic)): PICTCONV_OPTS=-f0 -d3))

$(call targets_for,scrlt.png): SYMNAME=ScrollT
$(call targets_for,scrlm.png): SYMNAME=ScrollM
$(call targets_for,scrlm1.png): SYMNAME=ScrollM1
$(call targets_for,scrlm2.png): SYMNAME=ScrollM2
$(call targets_for,scrlm3.png): SYMNAME=ScrollM3
$(call targets_for,scrlb.png): SYMNAME=ScrollB

scrlt.png: IMCROP=240x40+0+0
scrlm.png: IMCROP=240x120+0+40
scrlm1.png: IMCROP=240x120+0+40
scrlm2.png: IMCROP=240x120+0+40
scrlm3.png: IMCROP=240x120+0+40
scrlb.png: IMCROP=240x40+0+160

#scrlt.png: IMCROP=240x30+0+0
#scrlm.png: IMCROP=240x140+0+40
#scrlm1.png: IMCROP=240x140+0+30
#scrlm2.png: IMCROP=240x140+0+30
#scrlb.png: IMCROP=240x30+0+170


scrlt.png scrlm.png scrlb.png: scrl.png
	convert \
		$< \
		-crop $(IMCROP) \
		$@

scrlm1.png: label1.txt
scrlm2.png: label2.txt
scrlm3.png: label3.txt

FONT=hobbitonbrushhand.ttf

# looks like [re]page doesn't work at all with captions :-(
#		caption:"$$(cat $(filter %.txt,$^) | uconv -x NFD)" \

scrlm1.png scrlm2.png scrlm3.png: scrl.png
	convert \
		\( \
		$< \
		-crop $(IMCROP) \
		+repage \
		\) \
		-page +80+0 \
		\( \
		\( \
		-page +80-10 \
		-size 180x120+0-10 \
		-page +80-10 \
		-background transparent \
		-fill black \
		-pointsize 11 \
		-interline-spacing -13 \
		-kerning 2 \
		-antialias \
		-font $(FONT) \
		caption:"$$(cat $(filter %.txt,$^) | uconv -x any-ascii)" \
		+repage \
		\) \
		-geometry +6+0 \
		\) \
		-gravity center \
		-composite \
		-black-threshold "95%" \
		+repage \
		-remap oriccolors.png \
		$@

#		label:"$$(cat $(filter %.txt,$^))" \
#		-gravity center \
#		-interline-spacing 20 \ # doesn't work :-(
# transparent

# fonts
# https://www.dafont.com/hobbiton-brush-hand.font
# https://www.dafont.com/elven-common-speak.font

elvencommonspeak.ttf:
	wget -O tmp.zip https://dl.dafont.com/dl/?f=elven_common_speak
	unzip tmp.zip
	rm tmp.zip

hobbitonbrushhand.ttf:
	wget -O tmp.zip https://dl.dafont.com/dl/?f=hobbiton_brush_hand
	unzip tmp.zip
	rm tmp.zip

fonts: elvencommonspeak.ttf hobbitonbrushhand.ttf


TUNEDORI.ym: TUNEDORI.out

TUNEDORI.mym: TUNEDORI.ym

TUNEDORI.s: TUNEDORI.mym

%.ym: %.out
	# truncated:
	# truncate -s 18500 $<
	# TODO: integrate to OSDK
	/home/revol/devel/oric/svn/users/mmu_man/tools/out2ym $< $@

%.mym: %.ym
	$(OSDK)/bin/ym2mym -m6000 -t0 -v5 $< $@

%.s: %.mym
	$(OSDK)/bin/bin2txt -f2 -n16 $< $@ _Music


## OLD STUFF BELOW

alch12_1.png: IMCROP=360x300+0+0
alch12_2.png: IMCROP=360x300+360+0
alch12_3.png: IMCROP=360x300+720+0

#alch12.png: 18198313_1876657589288676_8789177043047575198_n.jpg
alch12_1.png alch12_2.png alch12_3.png: bandeaualchimie12.png
	convert \
		-size 1080x300 xc:white \
		$< \
		-composite \
		+dither \
		-gamma 0.95 \
		-modulate 85,90 \
		-antialias \
		-crop $(IMCROP) \
		-scale 240x200 \
		-remap oriccolors.png \
		$@
#		-gamma 1.1 \

alch12.png: bandeaualchimie12.png
	convert \
		$< \
		+dither \
		-gamma 0.95 \
		-modulate 85,90 \
		-antialias \
		-crop 936x300+0+0 \
		-scale 624x200 \
		-remap oriccolors.png \
		$@
#		-gamma 1.1 \

#alch12s1.png alch12s1.tap alch12s1.s: alch12.png
alch12s1.png alch12s1.tap alch12s1.s: alch12_1.png
alch12s2.png alch12s2.tap alch12s2.s: alch12_2.png
alch12s3.png alch12s3.tap alch12s3.s: alch12_3.png

#alch12s1.png alch12s2.png alch12s3.png:
alch12s%.png: alch12_%.png
#alch12s%.png: alch12.png
	$(OSDK)/bin/pictconv -m0 -f6 -d3 -o5 $< $@

alch12s%.tap: alch12_%.png
#alch12s%.tap: alch12.png
	$(OSDK)/bin/pictconv -m0 -f6 -d3 -o0 -v1 -n16 $< $@

alch12s%.s: alch12_%.png
#alch12s%.s: alch12.png
	$(OSDK)/bin/pictconv -m0 -f6 -d3 -o2 -v1 -n16 $< $@.bin
	$(OSDK)/bin/filepack $@.bin $@.packed
	$(OSDK)/bin/bin2txt -s1 -f2 -n8 $@.packed $@ _LogoA12_$(subst alch12s,,$(subst .s,,$@))
	rm $@.bin $@.packed





vip2017_splash_oric_base.png: home-f248a31af7d5d43fcf9decebf20b68e6ce7d94c0200c96f6e12cffface638e90.png
	convert $< -scale 240x200 \
		+dither \
		-modulate 110,100 \
		-remap oriccolors.png \
		$@
#		-gamma 1.1 \




vip17_s1.png: vip2017_splash_oric_fix1.png
	$(OSDK)/bin/pictconv -m0 -f6 -d3 -o5 $< $@

vip17_s1.tap: vip2017_splash_oric_fix1.png
	$(OSDK)/bin/pictconv -m0 -f6 -d3 -o0 -v1 -n16 $< $@

vip17_s1.s: vip2017_splash_oric_fix1.png
	$(OSDK)/bin/pictconv -m0 -f6 -d3 -o2 -v1 -n16 $< $@.bin
	$(OSDK)/bin/filepack $@.bin $@.packed
	$(OSDK)/bin/bin2txt -s1 -f2 -n8 $@.packed $@ _LogoVIP1
	rm $@.bin $@.packed

vip17_e1.png: vip2017_splash_oric_elph1.png
	$(OSDK)/bin/pictconv -f6 -d3 -o5 $< $@

vip17_e2.png: vip2017_splash_oric_elph2.png
	$(OSDK)/bin/pictconv -f6 -d3 -o5 $< $@


test3.png: vip2017_splash_oric_base.png
	$(OSDK)/bin/pictconv -f2 -o5 $< $@

test4.png: vip2017_splash_oric_base.png
	$(OSDK)/bin/pictconv -f2 -d2 -o5 $< $@













vipsplash_src.png: splash-de642cfae883d66c5cd6c55eb852b1cd.png oriccolors.png
	convert $< -scale 240x200 -alpha opaque \
		-modulate 100,110 \
		-gamma 0.32 \
		+dither -remap oriccolors.png \
		$@
#	convert $< -scale 240x200 -gamma 0.7 -alpha opaque +dither -remap oriccolors.png $@
# -gamma 0.6 
# -remap oriccolors.png
# -dither Riemersma

logoa0xb3.png: logoa0xb2.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o5 -v1 -n16 $< $@
logoa0xb3.s: logoa0xb2.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o2 -v1 -n16 $< $@.bin
	$(OSDK)/bin/filepack $@.bin $@.packed
	$(OSDK)/bin/bin2txt -s1 -f2 -n8 $@.packed $@ _LogoA0XB
	rm $@.bin $@.packed
#	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o4_LogoA0XB -v1 -n18 $< $@

vipsplash.png: vipsplash_src.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o5 -v1 -n16 $< $@

vipsplash.tap: vipsplash_src.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o0 -v1 -n16 $< $@

vipsplash.s: vipsplash_src.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o2 -v1 -n16 $< $@.bin
	$(OSDK)/bin/filepack $@.bin $@.packed
	$(OSDK)/bin/bin2txt -s1 -f2 -n8 $@.packed $@ _VIPSplash
	rm $@.bin $@.packed


sprites.tap: sprites.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o5 -v1 -n16 $< $@.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o0 -v1 -n16 $< $@





