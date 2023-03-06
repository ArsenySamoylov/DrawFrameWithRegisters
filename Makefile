all: clear 

	nasm -wall key.asm -I./include -I./macroses -o START.com

clear:
	rm -rf START.com

int: int.asm
	nasm int.asm -o int.com -I./include