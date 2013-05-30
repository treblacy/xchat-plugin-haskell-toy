libWhee.so: Whee.hs hsbracket.o
	ghc -O2 -dynamic -shared -fPIC -o libWhee.so Whee.hs hsbracket.o -lHSrts-ghc7.6.3

hsbracket.o: hsbracket.c
	gcc -O2 -fPIC -c hsbracket.c

clean:
	rm -f *.hi *.o *.so *_stub.h
