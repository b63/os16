#!/usr/bin/env bash

maxsectors=$2
size=`wc -c "$1" | cut -d ' ' -f 1`
if (( $size > 512*$maxsectors )); then
    sectors=$(($size/512))
    rem=$(($size-$sectors*512))

    printf "\033[33;1;4mWARNING\033[0m `basename $1` is larger than $maxsectors sectors:" 
    printf " $sectors sectors $rem bytes, total $size bytes\n"
fi
