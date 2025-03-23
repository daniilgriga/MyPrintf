
asm:
	nasm -g -f elf64 -o add_call.o add-call.s

c:
	gcc -g -c add_f.c -o add_f.o

all:
	gcc -g -no-pie -Wl,-z,noexecstack -nostartfiles add_call.o add_f.o -o program

run:
	./program
