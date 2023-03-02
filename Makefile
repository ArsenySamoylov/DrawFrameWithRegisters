all: clear 

	nasm -wall frame.asm -o TEST.com -I./include -I./macroses

clear:
	rm -rf TEST.com
