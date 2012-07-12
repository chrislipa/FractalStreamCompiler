#include <iostream>
#include "codegen.h"
#include "node.h"

#import "FSCompileRequest.h"
#import "FSCompileError.h"
#import "FSCompileResult.h"
#include <stdio.h>
#include "FSExtraInformation.hpp"
#include "FractalStreamScript_DialectA_parser.hpp"
#include "FractalStreamScript_DialectA_tokenizer.hpp"
#include "FSScriptLanguage.h"
#include "FSCompileResult.h"
using namespace std;

extern int FractalStreamScript_DialectA_parse(void* scanner);




/* fs_internalCompile is the core function of the Fractal Stream Compiler project.
 * It take a compile request, attempts to compile it and returns a compile
 * result.  Because it's potentially taking a user-generated request, every 
 * error condition that could come from malformed data in the request is checked
 * against.
 */
extern "C" FSCompileResult* fs_internalCompile(FSCompileRequest* compileRequest)
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
    
    
    // At this point we know we have a valid input source code string and a 
    // valid language to interpret it with.  We attempt to tokenize and parse it.
    
	char* workingSource = strdup(sourceCode);
    
	yyscan_t scanner;
	FSExtraInformation extra;
	
	
	
	(*(language.functionPointerTo_lex_init_extra))(&extra, &scanner );
    
	YY_BUFFER_STATE rv =(YY_BUFFER_STATE) (*(language.functionPointerTo_scan_string))(workingSource, scanner);
    std::cout << "return value from scan  = "<<rv<< endl;
    int rv2 = FractalStreamScript_DialectA_parse(scanner);
	//int rv2  =  (*(language.functionPointerTo_parse))(scanner);
    
	FSExtraInformation* extra_return = (FSExtraInformation*)( (*(language.functionPointerTo_get_extra))(scanner));
	Node* programBlock = extra_return->result;
    
	(*(language.functionPointerTo_lex_destroy))( scanner );


	std::cout << "parse return value  = "<<rv2<< endl;
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

