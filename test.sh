#!/bin/bash

OUTPUT=output.tmp

for I in `find ~/Dev/3CeAM-trunk/npc -name "*.txt" -or -name "*.npc"`; do
	# Find all script blocks in the NPC
	cat $I | egrep -n ".*(	script	.*{|	duplicate.*)" > sections.tmp

	exec < sections.tmp

	PREV=0
	LAST=0
	SKIP=0
	SKIP_NEXT=0
	while [ $LAST == 0 ]; do
		read LINE || LAST=1
		if [ $LAST == 1 ]; then
			let LINE=`wc -l $I | awk '{ print $1 }'`+1
		else
			if grep -q "duplicate" <<<$LINE; then
				SKIP_NEXT=1
			fi

			LINE=`echo "$LINE" | cut -d: -f1`
		fi

		if [ $SKIP == 0 ]; then
			if [ $PREV != 0 ]; then
				let L=$LINE-1
				echo "$I: $PREV-$L"
				sed -n "${PREV},${L}p" < $I | sed 's/.*	script	[^{]*{/{/g' > \
					$OUTPUT

				./compiler $OUTPUT || exit 1
			fi
		fi

		PREV=$LINE
		SKIP=$SKIP_NEXT
		SKIP_NEXT=0
	done
done
