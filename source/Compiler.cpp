#include <iostream>
#include "codegen.h"
#include "node.h"
#include "tokens.h"
#include <stdio.h>
#include "ExtraInformation.hpp"
#include "parser.hpp"


using namespace std;

extern int yyparse(void* scanner);





int internalCompileString(const char* sourceCode)
{
	
	char* workingSource = strdup(sourceCode);
	yyscan_t scanner;
	ExtraInformation extra;
	
	
	
	yylex_init_extra(&extra, &scanner );

	YY_BUFFER_STATE rv = yy_scan_string(workingSource, scanner);
	int rv2  = yyparse(scanner);
	ExtraInformation* extra_return = (ExtraInformation*)( yyget_extra(scanner));
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
		//context.runCode();
	}
    
	std::cout<<"printing"<<endl;
	
	std::cout<<programBlock<<endl;
	std::cout<<"done"<<endl;
	
	free(workingSource);
	return 0;
}

