all: build/FractalStreamScript_DialectA_parser.hpp build/FractalStreamScript_DialectA_parser.cpp build/FractalStreamScript_DialectA_tokenizer.cpp build/FractalStreamScript_DialectA_tokenizer.hpp

clean:
	$(RM) -rf build/FractalStreamScript_DialectA_parser.hpp build/FractalStreamScript_DialectA_parser.cpp build/FractalStreamScript_DialectA_tokenizer.cpp build/FractalStreamScript_DialectA_tokenizer.hpp build/FractalStreamScript_DialectA_parser.output

build/FractalStreamScript_DialectA_parser.cpp : FractalStreamScript_DialectA_parser.y
	mkdir -p build
	bison -v -d -o $@ $^
	
build/FractalStreamScript_DialectA_parser.hpp:  build/FractalStreamScript_DialectA_parser.cpp 
	mkdir -p build

build/FractalStreamScript_DialectA_tokenizer.cpp build/FractalStreamScript_DialectA_tokenizer.hpp : FractalStreamScript_DialectA_tokens.l build/FractalStreamScript_DialectA_parser.hpp
	mkdir -p build
	flex -o $@ $^



