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
extern NBlock* programBlock;




int tokenizestring()
{
	const char* s = "12";
	yyscan_t scanner;
	YYContext extra(scanner);
	
	
	
	yylex_init_extra(&extra, &scanner );

	YY_BUFFER_STATE rv = yy_scan_string(s, scanner);
	int rv2  = yyparse(scanner);
	YYContext* context = (YYContext*)( yyget_extra(scanner));
	int result = context->result;
	yylex_destroy ( scanner );
	std::cout << rv;
	std::cout << rv2;
	std::cout << result;
	

	//yyparse();
	
	//std::cout << programBlock << endl;
    // see http://comments.gmane.org/gmane.comp.compilers.llvm.devel/33877
	//InitializeNativeTarget();
	//CodeGenContext context;
	//context.generateCode(*programBlock);
	//context.runCode();
	
	return 0;
}

