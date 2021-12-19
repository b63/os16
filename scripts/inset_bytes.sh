#!/usr/bin/env bash

if [[ ! -f $1 ]]; then
    echo "file not found: '$1'"
    exit 1
fi

cp_name="tmp_`basename $1`"
cp "$1" "$cp_name"
echo -ne "420" > "$1"
dd if="$cp_name" of="$1" bs=512 oflag=append conv=notrunc > /dev/null 2>&1
rm "$cp_name"
