all: build/parser.cpp build/parser.hpp build/tokens.cpp

clean:
	$(RM) -rf build/parser.cpp build/parser.hpp build/parser build/tokens.cpp 

build/parser.cpp: parser.bison
	mkdir -p build
	bison -d -o $@ $^

build/parser.hpp: build/parser.cpp

build/tokens.cpp: tokens.lex build/parser.hpp
	mkdir -p build
	flex -o $@ $^
