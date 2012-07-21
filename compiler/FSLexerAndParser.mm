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
#include "FSScriptLanguageDescription.h"
#include "FSCompileResult.h"
using namespace std;

extern int FractalStreamScript_DialectA_parse(void* scanner);




/* fs_internalCompile is the core function of the Fractal Stream Compiler project.
 * It take a compile request, attempts to compile it and returns a compile
 * result.  Because it's potentially taking a user-generated request, every 
 * error condition that could come from malformed data in the request is checked
 * against.
 */
extern "C" FSCompileResult* fsLexAndParse(FSCompileRequest* compileRequest, Node*& abstractSyntaxTree)
{
    abstractSyntaxTree = NULL;
	NSString* languageIdentifier = [compileRequest languageIdentifier];
    if (languageIdentifier == nil) {return [FSCompileResult compileResultWithRequest:compileRequest andError:[FSCompileError noLanguageSpecified]];};
    
    FSScriptLanguageDescription* language = [FSScriptLanguageDescription scriptLanguageWithIdentifier:languageIdentifier];
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
    (*(language.functionPointerTo_scan_string))(workingSource, scanner);
    
    
	
    
    int parseReturnValue =  (*(language.functionPointerTo_parse))(scanner);
	
    // After the source code is lexed and parsed, unpack everything to see if it was successful.
    
    FSExtraInformation* extra_return = (FSExtraInformation*)( (*(language.functionPointerTo_get_extra))(scanner));
	Node* programBlock = extra_return->result;
    
    bool isAnyParsingErrorFatal = NO;
    FSCompileErrorSeverity maximumErrorSeverity = FSCompileErrorSeverity_None;
    NSMutableArray* parsingErrors = [NSMutableArray array];
    
    for (std::vector<FSParsingError>::iterator it = extra_return->errors.begin(); it != extra_return->errors.end(); ++it) {
        FSCompileError* ce = [[FSCompileError alloc] initWithParsingError:&(*it) fromLanguage:language];
        [parsingErrors addObject:ce];
        isAnyParsingErrorFatal |= ce.isFatalError;
        maximumErrorSeverity = MAX(maximumErrorSeverity, [ce errorSeverity]);
        [ce release];
    }
    
    if (parseReturnValue != 0 && !isAnyParsingErrorFatal) {
        FSCompileError* ce = [FSCompileError unknownParseError];
        [parsingErrors addObject:ce];
        isAnyParsingErrorFatal |= ce.isFatalError;
        maximumErrorSeverity = MAX(maximumErrorSeverity, [ce errorSeverity]);
        [ce release];
    }
    
    if (programBlock == NULL && !isAnyParsingErrorFatal) {
        FSCompileError* ce = [FSCompileError couldNotGenerateAST];
        [parsingErrors addObject:ce];
        isAnyParsingErrorFatal |= ce.isFatalError;
        maximumErrorSeverity = MAX(maximumErrorSeverity, [ce errorSeverity]);
        [ce release];
    }
    
	(*(language.functionPointerTo_lex_destroy))( scanner );
    free(workingSource);
    
    if (isAnyParsingErrorFatal) {
        FSCompileResult* result = [FSCompileResult compileResultWithRequest:compileRequest andErrors:parsingErrors];
        return result;
    }

    

	std::cout << "parse return value  = "<<parseReturnValue<< endl;
	std::cout << "program block = "<<programBlock<< endl;
        
    abstractSyntaxTree = programBlock;
    return [FSCompileResult compileResultWithRequest:compileRequest andErrors:parsingErrors];

	/*
		InitializeNativeTarget();
		CodeGenContext context;
		context.generateCode(*programBlock);
		//context.runCode();
	    
	std::cout<<"printing"<<endl;
	
	std::cout<<programBlock<<endl;
	std::cout<<"done"<<endl;
	
	
	return 0;
     */
}

