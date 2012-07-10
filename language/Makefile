all: build/parser.hpp build/parser.cpp build/tokens.cpp build/tokens.hpp

clean:
	$(RM) -rf build/parser.cpp build/parser.hpp build/tokens.hpp build/tokens.cpp

build/parser.cpp: parser.y
	mkdir -p build
	bison -v -d -o $@ $^
	
build/parser.hpp: build/parser.cpp
	mkdir -p build

build/tokens.cpp build/tokens.hpp : tokens.l build/parser.hpp
	mkdir -p build
	flex -o $@ $^



