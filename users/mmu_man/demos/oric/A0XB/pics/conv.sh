#!/bin/bash

# convertit une image 320x240 en texte pour le charset alternatif ORIC
# (c) 2006, mmu_man (Francois Revol, revol@free.fr)

W=54
H=12
FRAMECOUNT=1

# convertir en 32*24 1bpp
#for n in $(seq 1 $FRAMECOUNT); do convert frame000$n.jpg -sample 32x24 -colors 2 f0$n.xpm; done
convert logoalchimie.png -colors 2 logoalchimie.xpm

for n in $(seq 1 $FRAMECOUNT); do
	h=$(($H/3))
	w=$(($W/2))
	l=0
	grep '"................................*"' < logoalchimie.xpm | tr -d ',"' | tr ' .' '01' >/tmp/frame.tmp
	echo "_frame$n"
	while [ $l -lt $h ]; do
		read L1
		read L2
		read L3
		#echo $L1
		#echo $L2
		#echo $L3
		echo -n "	.byt "
		for c in $(seq 0 $(($w-1))); do
			v=0
			b0=${L1:0:1}
			b1=${L1:1:1}
			b2=${L2:0:1}
			b3=${L2:1:1}
			b4=${L3:0:1}
			b5=${L3:1:1}
			echo "$l, $c: $b5$b4$b3$b2$b1$b0"
			v=$((32+${b5}*32+$b4*16+$b3*8+$b2*4+$b1*2+$b0))
			#echo "$v"
			printf "\$%2x" $v
			L1=${L1:2:32}
			L2=${L2:2:32}
			L3=${L3:2:32}
			test "$c" != "$(($w-1))" && echo -n ", "
		done 
		echo ""
		l=$(($l+1))
		
	done < /tmp/frame.tmp 
done > video.s

	
