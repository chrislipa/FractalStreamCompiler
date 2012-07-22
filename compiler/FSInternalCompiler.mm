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
    FSCompileResult* result = fsLexAndParse(compileRequest);
    if (!result.isCompileSuccessful || result.abstractSyntaxTree == NULL) {
        return result;
    }
    fsBuildFractalStreamKernel(result);
    return result;
    
}