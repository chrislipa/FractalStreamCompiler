#include <iostream>
#include "codegen.h"
#include "node.h"

#import "FSCompileRequest.h"
#import "FSCompileError.h"
#import "FSCompileResult.h"
#include <stdio.h>
#include "ExtraInformation.hpp"
#include "FractalStreamScript_DialectA_parser.hpp"
#include "FractalStreamScript_DialectA_tokenizer.hpp"
#include "FSScriptLanguage.h"
#include "FSCompileResult.h"
using namespace std;

extern int FractalStreamScript_DialectA_parse(void* scanner);



extern "C"

FSCompileResult* fs_internalCompile(FSCompileRequest* compileRequest)
{
	NSString* languageIdentifier = [compileRequest languageIdentifier];
    if (languageIdentifier == nil) {return [FSCompileResult compileResultWithRequest:compileRequest andError:[FSCompileError noLanguageSpecified]];};
    
    FSScriptLanguage* language = [FSScriptLanguage scriptLanguageWithIdentifier:languageIdentifier];
    if (language == nil) {return [FSCompileResult compileResultWithRequest:compileRequest andError:[FSCompileError unrecognizedLanguage:languageIdentifier]];}
    
    NSString* sourceCodeNSString = compileRequest.sourceCode;
    if (sourceCodeNSString == nil) {return [FSCompileResult compileResultWithRequest:compileRequest andError:[FSCompileError missingSourceCode]];}
    if ([[sourceCodeNSString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return [FSCompileResult compileResultWithRequest:compileRequest andError:[FSCompileError missingSourceCode]];
    }
    
    NSStringEncoding encoding = [language characterSetEncoding]; 
    const char* sourceCode = [sourceCodeNSString cStringUsingEncoding:encoding];
    if (sourceCode == NULL || strlen(sourceCode) == 0) {
        return [FSCompileResult compileResultWithRequest:compileRequest andError:[FSCompileError invalidCharacterEncoding:sourceCodeNSString encoding:encoding]];
    }
    
	char* workingSource = strdup(sourceCode);
    
	yyscan_t scanner;
	ExtraInformation extra;
	
	
	
	(*(language.functionPointerTo_lex_init_extra))(&extra, &scanner );

	YY_BUFFER_STATE rv = FractalStreamScript_DialectA__scan_string(workingSource, scanner);
	int rv2  = FractalStreamScript_DialectA_parse(scanner);
	ExtraInformation* extra_return = (ExtraInformation*)( FractalStreamScript_DialectA_get_extra(scanner));
	Node* programBlock = extra_return->result;
	FractalStreamScript_DialectA_lex_destroy ( scanner );

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

