#include <iostream>
#include "codegen.h"
//#include "node.h"
#include "tokens.h"
#include <stdio.h>
#include "tk.h"

using namespace std;

extern int yyparse();
extern NBlock* programBlock;




int tokenizestring()
{
	const char* s = "1*2*";
	yyscan_t scanner;
	
	yylex_init ( &scanner );

	YY_BUFFER_STATE rv = yy_scan_string(s, scanner);
	yylex_destroy ( scanner );
	std::cout << rv;
	
	

	//yyparse();
	
	//std::cout << programBlock << endl;
    // see http://comments.gmane.org/gmane.comp.compilers.llvm.devel/33877
	//InitializeNativeTarget();
	//CodeGenContext context;
	//context.generateCode(*programBlock);
	//context.runCode();
	
	return 0;
}

