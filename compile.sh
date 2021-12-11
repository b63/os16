#!/usr/bin/env bash
# bhavin k
# CS 456

set -e

BUILD="./build"
SRC="./src"
BIN="./bin"
ASM="./asm"
IMG="./images"
INC="./include"

mkdir -p $BUILD
mkdir -p $BIN
mkdir -p $ASM
mkdir -p $IMG

echo -e 'Compiling/Linking testproc'
gcc "-I$INC" -std=c99 -o $BIN/testproc  $SRC/testproc.c $SRC/proc.c

echo -e '\nRunning testproc'
$BIN/testproc

echo -e '\nCompiling/Linking loadFile'
g++ "-I$INC" -std=c++11 $SRC/loadFile.cpp -o $BIN/loadFile 

echo -e '\nCompiling ...'
bcc "-I$INC" -ansi -c -o $BUILD/kernel.o       $SRC/kernel.c
bcc "-I$INC" -ansi -S -o $ASM/kernelc.asm -C-t $SRC/kernel.c
bcc "-I$INC" -ansi -c -o $BUILD/uprog1.o       $SRC/uprog1.c 
bcc "-I$INC" -ansi -c -o $BUILD/uprog2.o       $SRC/uprog2.c 
bcc "-I$INC" -ansi -c -o $BUILD/userlib.o      $SRC/userlib.c 
bcc "-I$INC" -ansi -c -o $BUILD/shell.o        $SRC/shell.c 
bcc "-I$INC" -ansi -c -o $BUILD/proc.o         $SRC/proc.c 


echo -e '\nAssembling ...'
as86 $ASM/lib.asm      -o  $BUILD/lib.o 
as86 $ASM/kernel.asm   -o  $BUILD/kernel_asm.o
nasm $ASM/bootload.asm -o  $BUILD/bootload

echo -e '\nLinking ...'
ld86 -o    $BIN/uprog1 -d $BUILD/uprog1.o $BUILD/lib.o        $BUILD/userlib.o
ld86 -o    $BIN/uprog2 -d $BUILD/uprog2.o $BUILD/lib.o        $BUILD/userlib.o
ld86 -o    $BIN/shell  -d $BUILD/shell.o  $BUILD/lib.o        $BUILD/userlib.o
ld86 -M -o $BIN/kernel -d $BUILD/kernel.o $BUILD/kernel_asm.o $BUILD/proc.o

# routine to write "420" to start of a file
function insert_bytes () {
    cp_name="tmp_`basename $1`"
    cp "$1" "$cp_name"
    echo -ne "420" > "$1"
    dd if="$cp_name" of="$1" bs=512 oflag=append conv=notrunc > /dev/null 2>&1
    rm "$cp_name"
    echo -e "=> $1"
}


echo -e '\nInserting magic bytes ...'
insert_bytes $BIN/shell
insert_bytes $BIN/uprog1
insert_bytes $BIN/uprog2


# copy bootloader to floppy
echo  -e '\nCopying to floppy ...'
dd if=/dev/zero of=$IMG/floppya.img bs=512 count=2880 > /dev/null 2>&1

echo -e '=> bootloader'
dd if=$BUILD/bootload of=$IMG/floppya.img bs=512 count=1 conv=notrunc seek=0 > /dev/null 2>&1

echo -e '=> kernel'
dd if=$BIN/kernel      of=$IMG/floppya.img bs=512 conv=notrunc seek=3 > /dev/null 2>&1

echo -e '=> map.img'
dd if=$IMG/map.img     of=$IMG/floppya.img bs=512 count=1 seek=1 conv=notrunc > /dev/null 2>&1 

echo -e '=> dir.img'
dd if=$IMG/dir.img     of=$IMG/floppya.img bs=512 count=1 seek=2 conv=notrunc > /dev/null 2>&1

echo -e '\nWriting to disk...'
echo -e "=> message.txt"
$BIN/loadFile message.txt $IMG/floppya.img
echo -e "=> uprog1"
$BIN/loadFile $BIN/uprog1 $IMG/floppya.img
echo -e "=> uprog2"
$BIN/loadFile $BIN/uprog2 $IMG/floppya.img
echo -e "=> shell"
$BIN/loadFile $BIN/shell  $IMG/floppya.img


if [[ "$1" == "-r" ]]; then
    bochs -f opsys.bxrc -q
fi
