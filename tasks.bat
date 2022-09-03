@echo off
color 0E
cls
echo ___ INIT

mkdir x 2>nul

echo ___ CLEAN

del /q x\*.*

echo ___ BUILD

nasm "os/boot.asm" -f bin -o "x/boot.bin"
if not exist "x/boot.bin" set msg="boot.bin" BUILD FAILED && goto :END

nasm "os/kernel_call.asm" -f elf -o "x/kernel_call.o"
if not exist "x/kernel_call.o" set msg="kernel_call.o" BUILD FAILED && goto :END

clang -ffreestanding -m32 -O2 -g -c "os/kernel.c" -o "x/kernel.o" -target i386-pc-none-elf
if not exist "x/kernel.o" set msg="kernel.o" BUILD FAILED && goto :END

nasm "os/zeroes.asm" -f bin -o "x/zeroes.bin"
if not exist "x/zeroes.bin" set msg="zeroes.bin" BUILD FAILED && goto :END


echo ___ LINKING

ld.lld "x/kernel_call.o" "x/kernel.o" -Ttext 0x1000 --oformat binary -o "x/full_kernel.bin"
if not exist "x\full_kernel.bin" set msg="full_kernel.bin" LINKING FAILED && goto :END

echo ___ CONCATENATING

@copy /b "x\boot.bin" + "x\full_kernel.bin" + "x\zeroes.bin" "x\OS.bin" >NUL
if not exist "x\OS.bin" set msg="OS.bin" CONCATENATING FAILED && goto :END

echo ___ RUN

qemu-system-x86_64 -drive format=raw,file="x\OS.bin",index=0 -m 1G

color 0A

:END
    if defined msg (
        color 0C
        echo | set /p=FAILED %msg%
    )

exit
