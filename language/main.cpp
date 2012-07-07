#include <iostream>
//#include "codegen.h"
//#include "node.h"
#include "tokens.h"
using namespace std;

extern int yyparse();
//extern NBlock* programBlock;

int main(int argc, char **argv)
{
	int     fd[2];
	pipe(fd);
	char    string[] = "1*1*";
	
	
	write(fd[1], string, (strlen(string)));
	dup2(fd[0], STDIN_FILENO);
	close(fd[1]);
	
	yyscan_t scanner;
	
	yylex_init ( &scanner );
	//yylex ( scanner );
	yylex_destroy ( scanner );
	
	
	//std::cout << programBlock << endl;
    // see http://comments.gmane.org/gmane.comp.compilers.llvm.devel/33877
	//InitializeNativeTarget();
	//CodeGenContext context;
	//context.generateCode(*programBlock);
	//context.runCode();
	
	return 0;
}

