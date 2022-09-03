@echo off && color 0E && cls

echo _____ WASHING

if exist "obj" rmdir /s /q "obj" && mkdir "obj" 2>nul
if exist "bin" rmdir /s /q "bin" && mkdir "bin" 2>nul
if exist "os" rmdir /s /q "os" && mkdir "os" 2>nul

echo _____ PREPARATION 

nasm "src\boot.asm" -f bin -o "bin\boot.bin" && if not exist "bin/boot.bin" set err=boot.bin && goto :END
nasm "src\zeroes.asm" -f bin -o "bin\zeroes.bin" && if not exist "bin\zeroes.bin" set err=zeroes.bin && goto :END
nasm "src/kernel_call.asm" -f elf -o "obj/kernel_call.o" && if not exist "obj/kernel_call.o" set err=kernel_call.o && goto :END
for %%f in (src\*.c) do clang "%%f" -ffreestanding -m32 -g -c -target i386-pc-none-elf -o "obj/%%~nf.o" && if not exist "obj/%%~nf.o" set err=%%~nf.o && goto :END

echo _____ COOKING

ld.lld "obj/*.o" -Ttext 0x1000 --oformat binary -o "bin\kernel.bin" && if not exist "bin\kernel.bin" set err=kernel.bin && goto :END
@copy /b "bin\*.bin" "os\PANKUN.bin" >NUL && if not exist "os\PANKUN.bin" set err=PANKUN.bin && goto :END

echo _____ SERVE

color 0A && qemu-system-x86_64 -m 1G -no-reboot -drive format=raw,file="os\PANKUN.bin",index=0

:END 
    if defined err color 0C && echo FILE FAILED %err%
exit