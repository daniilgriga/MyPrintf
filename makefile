
asm:
	nasm -g -f elf64 -l build/printf.lst -o build/MyPrintf.o src/MyPrintf.s

main:
	gcc -g -c src/main.c -o build/main.o

all:
	gcc -g -no-pie -Wl,-z,noexecstack build/main.o build/MyPrintf.o -o build/program

run:
	./build/program

debug:
	gdb ./build/program
