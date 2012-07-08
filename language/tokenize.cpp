#include <iostream>
#include "codegen.h"
#include "node.h"
#include "tokens.h"
#include <stdio.h>
#include "tk.h"
#include "parser.hpp"
#include "context.hpp"

using namespace std;

extern int yyparse(void* scanner);





int tokenizestring()
{
	const char* s = "12";
	yyscan_t scanner;
	YYContext extra;
	
	
	
	yylex_init_extra(&extra, &scanner );

	YY_BUFFER_STATE rv = yy_scan_string(s, scanner);
	int rv2  = yyparse(scanner);
	YYContext* extra_return = (YYContext*)( yyget_extra(scanner));
	Node* programBlock = extra_return->result;
	yylex_destroy ( scanner );

	std::cout << "buffer state  = "<<rv<< endl;
	std::cout << "yyparse return value  = "<<rv2<< endl;
	std::cout << "program block = "<<programBlock<< endl;
	

	
	
	if (programBlock == NULL) {
		std::cout << "programBlock == NULL.  could not parse?"<<endl;
	} else {
		InitializeNativeTarget();
		CodeGenContext context;
		context.generateCode(*programBlock);
		context.runCode();
	}
    
	
	
	
	
	return 0;
}

