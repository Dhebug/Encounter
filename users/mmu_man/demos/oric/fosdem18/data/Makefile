

all: oriccolors.png logo.png logo1.png logo.s schedule.h

clean:
	rm -f oriccolors.png logo.png logo1.png logo.s schedule.h

oriccolors.png:
	convert -size 1x1 'xc:#000000' 'xc:#0000ff' 'xc:#00ff00' 'xc:#00ffff' 'xc:#ff0000' 'xc:#ff00ff' 'xc:#ffff00' 'xc:#ffffff' +append $@


box.png: 
	wget https://fosdem.org/2018/support/promote/box.png

logo.png: box.png
	convert $< -gravity north -crop 240x200+0+4\! \
		+dither \
		-posterize 4 \
		-remap oriccolors.png \
		-posterize 3 \
		$@

logo1.png: logo.png
	$(OSDK)/bin/pictconv -m0 -f6 -d3 -o5 $< $@

logo.s: logo.png
	$(OSDK)/bin/pictconv -m0 -f6 -d3 -o4_logof -v1 -n16 $< $@

logop.s: logo.png
	$(OSDK)/bin/pictconv -m0 -f6 -d3 -o2 -v1 -n16 $< $@.bin
	$(OSDK)/bin/filepack $@.bin $@.packed
	$(OSDK)/bin/bin2txt -s1 -f2 -n8 $@.packed $@ _logo
	rm $@.bin $@.packed

schedule.ics:
	wget -O $@ https://fosdem.org/2018/schedule/track/retrocomputing.ics

schedule.h: schedule.ics
	tr -d '\r' < $< | awk 'BEGIN{ds=""};/^DTSTART:/{ ds = substr($$0,18,2)":"substr($$0,20,2) };/^SUMMARY:/{ print "\""ds"\\n"substr($$0,9)"\"," };END{print "0" }' > $@


