#!/usr/bin/env bash

UPDATES=$(checkupdates 2>/dev/null | wc -l)

re='^[0-9]+$'
if ! [[ $UPDATES =~ $re ]]; then
	echo "Failed to check updates"
	exit 0
fi

echo "${UPDATES}"
