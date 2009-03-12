#!/bin/sh

#
# Copyright 2009, François Revol, <revol@free.fr>.
# Distributed under the terms of the CC-BY-SA or MIT License.
#

# REQUIRES:
# convert (ImageMagick) v6.2.5

# 1 if alt graphics charset
alt_charset=0

ctrl_chars="                                "
ctrl_chars="|"
# MUST stay iso latin!
charset_def="$ctrl_chars"' !"#$%&'\''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^  abcdefghijklmnopqrstuvwxyz{|}'
# MUST stay iso latin!
charset_alt="$ctrl_chars"' !"#$%&'\''()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^  abcdefghijklmnopqrstuvwxyz{|}'
charset="$charset_def"
#charset="charset_def"

CHAR_WIDTH=6
CHAR_RWIDTH=8
CHAR_HEIGHT=8

FG=black
BG=white

usage()
{
	echo "$0 [-a] font.ttf [ptsize [offsetx,offsety]]"
	exit 1
}

gen_bitmap()
{
	ttf="$1"
	ptsize="$2"
	offset="$3"
	size="8x$((8*${#charset}))"
	x=2
	y=6
	TMPSC=/tmp/imsc.txt

	convert_args="-background $BG -fill $FG -size $size xc:$BG -colors 2"

	if [ -n "$ttf" ]; then
		convert_args="$convert_args -font $ttf"
	fi
	if [ -n "$ptsize" ]; then
		convert_args="$convert_args -pointsize $ptsize"
	fi
	if [ -n "$offset" ]; then
		x=$(($x + ${offset%,*}))
		y=$(($y + ${offset#*,}))
		echo "$x $y"
		convert_args="$convert_args -pointsize $ptsize"
	fi
	echo "" > $TMPSC
	for i in $(seq 0 $((${#charset} - 1))); do
		c="${charset:$i:1}"
		case "$c" in
		\\)	ec="\\\\"	;;
		\')	ec="\\'"	;;
		*)	ec="$c"		;;
		esac
		#echo "$i: '$c'"
		#printf "%03i: %s %s\n" "$i" "$c" "$ec"
		echo "text $x,$y '$ec' " >> $TMPSC
		#convert_args="$convert_args -draw 'text $x,$y $ec'"
		#echo "$convert_args"
		y="$(($y + $CHAR_HEIGHT))"
	done
	convert_args="$convert_args -draw @$TMPSC"
	 convert $convert_args out.png
	 # convert to an hex dump...
	 # the XBM format seems to have bits in reverse order
	 # so we flop.
	 convert out.png -flop out.xbm
	return 0
}

gen_font()
{
	gen_bitmap "$@"
	return 0
}



if [ "$1" = "-a" ]; then
	alt_charset=1
	charset="$charset_alt"
	shift
fi

if [ -z "$1" ]; then
	usage
fi

gen_font "$@"

