#!/bin/bash

ARQ=`basename $1|sed "s/\.cmm//"`
BIN_DIR="bin"

# Create bin directory if it doesn't exist
mkdir -p "$BIN_DIR"

java Parser "$1" > "$BIN_DIR/$ARQ.s"
# 32 bits
# as -o "$BIN_DIR/$ARQ.o" "$BIN_DIR/$ARQ.s"
#ld -o $BIN_DIR/$ARQ"   "$BIN_DIR/$ARQ.o"

# 64 bits 
as --32 -o "$BIN_DIR/$ARQ.o" "$BIN_DIR/$ARQ.s"
ld -m elf_i386 -s -o "$BIN_DIR/$ARQ"   "$BIN_DIR/$ARQ.o"