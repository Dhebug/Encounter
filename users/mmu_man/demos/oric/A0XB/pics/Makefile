#convert logoa0xb.xcf -scale 160x100 logoa0xb.png
#convert logoa0xb.xcf -scale 100x80 +dither -remap oriccolors.png logoa0xb.png

PICS= \
	logoa0xb3.s \
	chars.s \
	boing.s \
	vipsplash.s \
	oriccolors.png \
	sprites.tap \
	qrcode_alchimie.png \
	gadgets.s

PPICS= \
	logoa0xb3.png \
	boing.gif \
	vipsplash_src.png \
	vipsplash.png \
	vipsplash.tap \

all: $(PICS)

preview: $(PPICS)

$(PICS) $(PPICS): Makefile

chars.s: chars.png
	$(OSDK)/bin/pictconv -m0 -f5 -o2 -v1 $< $@.png
	$(OSDK)/bin/pictconv -m0 -f5 -o4FixedChars -v1 $< $@

gadgets.s: gadgets.png
	$(OSDK)/bin/pictconv -m0 -f0 -o4_Gadgets -v1 $< $@

oriccolors.png:
	convert -size 1x1 'xc:#000000' 'xc:#0000ff' 'xc:#00ff00' 'xc:#00ffff' 'xc:#ff0000' 'xc:#ff00ff' 'xc:#ffff00' 'xc:#ffffff' +append $@

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


#boing%.png: boing%


boing.gif: boing.xcf
	convert boing.xcf -crop 60x40 -page +0+0 boing.png
	convert -delay 100 boing-?.png boing-.gif
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o5 -v1 -n9 boing-0.png boing0.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o5 -v1 -n9 boing-1.png boing1.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o5 -v1 -n9 boing-2.png boing2.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o5 -v1 -n9 boing-3.png boing3.png
	convert -delay 100 boing?.png boing.gif
	rm boing?.png boing-?.png

boing.s: boing.xcf
	convert boing.xcf -crop 60x40 -page +0+0 boing.png
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o4Boing0 -v1 -n9 boing-0.png boing0.s
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o4Boing1 -v1 -n9 boing-1.png boing1.s
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o4Boing2 -v1 -n9 boing-2.png boing2.s
	$(OSDK)/bin/pictconv -m0 -f6 -d2 -o4Boing3 -v1 -n9 boing-3.png boing3.s
	cat boing?.s > boing.s
	rm boing?.s
	rm boing-?.png

qrcode_alchimie.png:
	qrencode -s 1 -m 0 -o $@ "http://triplea.fr/alchimie/"

clean:
	rm -f $(PICS) $(PPICS)