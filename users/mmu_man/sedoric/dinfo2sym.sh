#!/bin/sh

state=n
name=
addr=

while read tok arg; do
	#echo "[$tok][$arg]"
	case "$tok" in
		'};')
			state=n
			case "$name" in
				sedoric|ZP|STACK|VIA|'')
					# filter out
					;;
				MICRODISC_*)
					# shorten them
					name="Md_${name#MICRODISC_}"
					# print the symbol
					echo "$addr $name"
					;;
				*)
					# print the symbol
					echo "$addr $name"
					;;
			esac
			name=
			addr=
			;;
		LABEL)
			state=l
			;;
		NAME)
			name="${arg#\"}"
			name="${name%\";}"
			;;
		START|ADDR)
			addr="${arg#$}"
			addr="${addr%;}"
			test "${#addr}" -eq 3 && addr="0$addr"
	esac
done < "$1"

