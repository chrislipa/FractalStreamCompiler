#include <iostream>
#include "codegen.h"
#include "node.h"
#include "tokens.h"
#include <stdio.h>
#include "tk.h"

using namespace std;

extern int yyparse();
extern NBlock* programBlock;



int m()
{
	FILE * pFile;
	char buffer [100];
	
	pFile = fopen ("/Users/lipa/toParse.txt" , "r");
	if (pFile == NULL) perror ("Error opening file");
	else
	{
		while ( ! feof (pFile) )
		{
			if ( fgets (buffer , 100 , pFile) != NULL )
				fputs (buffer , stdout);
		}
		fclose (pFile);
	}
	return 0;
}

int tokenizestring()
{
	m();
	printf("c\n");
	FILE * pFile;
	long lSize;
	char * buffer;
	size_t result;
	
	pFile = tmpfile();
	if (pFile==NULL) {fputs ("File error",stderr); exit (1);}
	
	
	
	
	FILE * f = tmpfile(), *g = tmpfile();
	if (f == NULL) {
		//error
		return -1;
	}
	fprintf(f, "1*2");
	fseek( f, 0, SEEK_SET);

	fopen ("toParse.txt" , "r");
	
	

	yyin = fopen ("/Users/lipa/toParse.txt" , "r");
	yyout = fopen ("/Users/lipa/output.txt" , "w");
	yyparse();
	
	//std::cout << programBlock << endl;
    // see http://comments.gmane.org/gmane.comp.compilers.llvm.devel/33877
	//InitializeNativeTarget();
	//CodeGenContext context;
	//context.generateCode(*programBlock);
	//context.runCode();
	
	fclose( f );
	
	
	////
	// obtain file size:
	fseek (pFile , 0 , SEEK_END);
	lSize = ftell (pFile);
	rewind (pFile);
	
	// allocate memory to contain the whole file:
	buffer = (char*) malloc (sizeof(char)*lSize);
	if (buffer == NULL) {fputs ("Memory error",stderr); exit (2);}
	
	// copy the file into the buffer:
	result = fread (buffer,1,lSize,pFile);
	if (result != lSize) {fputs ("Reading error",stderr); exit (3);}
	
	/* the whole file is now loaded in the memory buffer. */
	
	// terminate
	fclose (pFile);
	free (buffer);
	return 0;
	////
	fclose(g);
	return 0;
}

