#!/bin/bash

for I in `find ~/Dev/3CeAM-trunk/npc -name "*.txt" -or -name "*.npc"`; do
	echo -n "$I ... "
	./compiler $I || exit 1
	echo "OK"
done
