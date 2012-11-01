#!/bin/bash

INPUT=input.tmp
OUTPUT=output.tmp

FAILED=0
RUN=0

failed() {
	echo "$1"
	cat output.tmp
	let FAILED=$FAILED+1
}

for I in `find ~/Dev/3CeAM-trunk/npc -name "*.txt" -or -name "*.npc"`; do
	# Find all script blocks in the NPC
	cat $I | sed '
:t
s|\(.*\)/\*.*\*/|\1|
tt
/\/\*/!b
N
bt
' | sed 's#//.*$##g' > $INPUT
	cat $INPUT | egrep -n ".*(	script	.*{|	warp	.*|	duplicate.*|	monster	.*|	boss_monster	.*)" > sections.tmp
	echo "$I ..."

	exec < sections.tmp

	PREV=0
	LAST=0
	SKIP=0
	SKIP_NEXT=0
	while [ $LAST == 0 ]; do
		read LINE || LAST=1
		if [ $LAST == 1 ]; then
			let LINE=`wc -l $INPUT | awk '{ print $1 }'`+1
		else
			if egrep -q "(duplicate|warp|monster|boss_monster)" <<<$LINE; then
				SKIP_NEXT=1
			fi

			LINE=`echo "$LINE" | cut -d: -f1`
		fi

		if [ $SKIP == 0 ]; then
			if [ $PREV != 0 ]; then
				let L=$LINE-1
				sed -n "${PREV},${L}p" < $INPUT | sed 's/.*	script	[^{]*{/{/g' > \
					$OUTPUT

				./compiler $OUTPUT || failed "$I: $PREV-$L"
			fi
		fi

		PREV=$LINE
		SKIP=$SKIP_NEXT
		SKIP_NEXT=0
		let RUN=$RUN+1
	done
done

let PASSED=$RUN-$FAILED
echo "$PASSED/$RUN passed"

