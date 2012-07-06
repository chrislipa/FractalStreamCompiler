CFLAGS= `-I../external/llvm/llvm-3.1.src/include/`

all: parser

OBJS = parser.o  \
       codegen.o \
       main.o    \
       tokens.o  \

LLVM_MODULES = core jit native

CPPFLAGS =  -I../external/llvm/llvm-3.1.src/include/ -D__STDC_LIMIT_MACROS -D__STDC_CONSTANT_MACROS -D'CMAKE_INTDIR="$(CONFIGURATION)$(EFFECTIVE_PLATFORM_NAME)"'
LDFLAGS = 
LIBS = 

clean:
	$(RM) -rf parser.cpp parser.hpp parser tokens.cpp $(OBJS)

parser.cpp: parser.y
	bison -d -o $@ $^
	
parser.hpp: parser.cpp

tokens.cpp: tokens.l parser.hpp
	flex -o $@ $^

%.o: %.cpp
	g++ -c $(CPPFLAGS) -o $@ $<


parser: $(OBJS)
	g++ -o $@ $(LDFLAGS) $(OBJS) $(LIBS)


