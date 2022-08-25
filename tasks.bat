@echo off

cls

echo ---------- %~nx0 STARTED

echo upsert BIN dir
mkdir BIN 2>nul

echo ---------- CLEANING...

echo clean BIN dir
del /q BIN\*.*

echo ---------- COMPILING...

echo compile boot.asm to boot.bin as bin
nasm OS/boot.asm -f bin -o BIN/boot.bin

echo ---------- VIRTUALIZING...

echo virtualize using qemu
qemu-system-x86_64 -drive file=BIN/boot.bin,format=raw

echo ---------- %~nx0 COMPLETED