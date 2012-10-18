//
//  FSCompiler.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSInternalCompiler.h"
#import "FSLexerAndParser.h"
#import "FractalStreamCompiler.h"
#import "FSKernelBuilder.h"

FSCompileResult* fsInternalCompile(FSCompileRequest* compileRequest) {
    Node* abstractSyntaxTree=NULL;
    FSCompileResult* result = fsLexAndParse(compileRequest, &abstractSyntaxTree);
    if (!result.isCompileSuccessful || abstractSyntaxTree == NULL) {
        if (!result.isCompileSuccessful) {
            printf("Compile not successful.");
        } else if (abstractSyntaxTree == NULL) {
            printf("Could not generate AST.");
        }
        return result;
    }
    std::string aststr = abstractSyntaxTree->description();
    printf("\n\nAbstract Syntax Tree:\n\n%s\n\n",aststr.c_str());
    fsBuildFractalStreamKernel(compileRequest, result);
    printf("\n\nkernel = 0x%LX\n\n",(long long)(result.kernel));
    return result;
    
}