all: clear 

	nasm -wall key.asm -I./include -I./macroses -o START.com

clear:
	rm -rf START.com
