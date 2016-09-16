#!/bin/bash

DIRS=$(find . -type f -name '*.tf' -exec dirname {} \; | sort | uniq)

FAILS=0

for dir in $DIRS
do 
	terraform validate $dir >&2
	if [[ "$?" -ne 0 ]]; then
		let "FAILS += 1"
	fi
done

if [[ "$FAILS" -ne 0 ]]; then
	exit 1
fi

FMT_ERRORS=$(terraform fmt -write=false -list=true)

for file in $FMT_ERRORS
do
	>&2 echo "$file"
	let "FAILS += 1"
done

if [[ "$FAILS" -ne 0 ]]; then
	exit 1
fi