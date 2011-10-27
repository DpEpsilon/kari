CFLAGS=-ansi -g -p -pg -pedantic -Wall -Wshadow -Wpointer-arith  -Wcast-qual -Wextra -Wc++-compat -Werror -Wno-unused-parameter -Ideps/gc/include/ -iquote inc/

all: deps/gc/libgc.la libkari.a repl

release:
	@make clean
	make all CFLAGS="-ansi -O3 -pedantic -Wall -Wshadow -Wpointer-arith  -Wcast-qual -Wextra -Wc++-compat -Werror -Wno-unused-parameter -Ideps/gc/include/ -iquote inc/" 

clean:
	rm -f src/*.o
	rm -f src/lib/*.o
	rm -f repl/*.o
	rm -f repl/*.inc
	rm -f libkari.a
	rm -f ikari

repl: libkari.a repl/.startup.kari.inc repl/ikari.o
	$(CC) $(CFLAGS) -o ikari libkari.a repl/*.o

repl/%.o: repl/%.c inc/*.h

repl/.startup.kari.inc: repl/startup.kari
	perl -e 'shift; while(<>) { chomp; s/"/\\"/g; print "\""; print; print "\"\n"; }' < repl/startup.kari > repl/.startup.kari.inc

libkari.a:	src/context.o src/dict.o src/kari.o src/vec.o src/parser.o src/execute.o src/st.o \
						src/lib/math.o src/lib/system.o src/lib/control.o src/lib/comparison.o \
						src/lib/string.o src/lib/array.o src/lib/dict.o src/lib/io.o
	ar r libkari.a src/*.o src/lib/*.o deps/gc/*.o 2> /dev/null

src/%.o: src/%.c inc/%.h

deps/gc/libgc.la: deps/gc/Makefile
	make -C deps/gc all

deps/gc/Makefile:
	cd deps/gc; \
	./configure