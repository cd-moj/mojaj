libc-wrapper.so: libc-wrapper.c
	gcc libc-wrapper.c -o libc-wrapper.so -shared -lc -nostdlib -ldl -O2 -fPIC -Wall
