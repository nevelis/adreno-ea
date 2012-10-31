#!/bin/bash

OUTPUT=output.tmp

for I in `find ~/Dev/3CeAM-trunk/npc -name "*.txt" -or -name "*.npc"`; do
	# Find all script blocks in the NPC
	cat $I | egrep -n ".*(script.*{$|duplicate.*)" > sections.tmp

	exec < sections.tmp

	read START_LINE
	let START_LINE=1+`echo $START_LINE | cut -d: -f1`
	while true; do
		read END_LINE || break
		case "$END_LINE" in
			*script*)
				let END_LINE=`echo $END_LINE | cut -d: -f1`-1
				echo "{" > $OUTPUT
				sed -n "${START_LINE},${END_LINE}p" < $I >> $OUTPUT

				echo "Compiling code at $I:${START_LINE}"
				./compiler $OUTPUT || exit 1
				let START_LINE=$END_LINE+2
				;;
			*)
				read START_LINE
				let START_LINE=1+`echo $START_LINE | cut -d: -f1`
				;;
		esac
	done

	echo "OK"
done
