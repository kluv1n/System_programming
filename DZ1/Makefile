all: clean&run

clean:
	@rm -f *.o prog

array: array.asm
	fasm array.asm

main: main.c
	gcc -c main.c -o main.o

build: array main
	gcc -no-pie main.o array.o -o prog

run: build
	./prog

clear:
	clear

clean&run: clean clear run
