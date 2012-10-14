//
//  main.c
//  test
//
//  Created by Christopher Lipa on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include "FractalStreamCompiler.h"


void test(FSCompileRequest* req) {
    printf("Input:  (language = %s)\n",[[req languageIdentifier] cStringUsingEncoding:NSUTF8StringEncoding]);
    printf("----\n");
    printf("%s\n",[req.sourceCode cStringUsingEncoding:NSUTF8StringEncoding]);
    
    printf("\n\n");
    FSCompileResult* res = fractalStreamCompileRequest(req);
    printf("\n\n");
    
    printf("success = %d\n\n", res.isCompileSuccessful);
    
    
    if  ([[res compileErrors] count] > 0) {
        printf("errors:");
        printf("----");
        for (FSCompileError* e in [res compileErrors]) {
            printf("%s\n",[[e description] cStringUsingEncoding:NSUTF8StringEncoding]);
            printf("\n");   
        }
    }
}


int main(int argc, const char * argv[])
{
    @autoreleasepool {
        
    //@"iterate z^2+c until z escapes."
    NSString* source = @"iterate z^2+c until z escapes.";
    FSCompileRequest* req = [FSCompileRequest getCompileRequestWithSourceCode:source andLanguage:@"fsa"];
        
    test(req);
	
	
    return 0;
    }
}

