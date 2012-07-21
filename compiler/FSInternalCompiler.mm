//
//  FSCompiler.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSInternalCompiler.h"
#import "FSLexerAndParser.h"

FSCompileResult* fsInternalCompile(FSCompileRequest* compileRequest) {
    Node* abstractSyntaxTree;
    FSCompileResult* lexedAndParsed = fsLexAndParse(compileRequest,abstractSyntaxTree);
    if (!lexedAndParsed.isCompileSuccessful) {
        return lexedAndParsed;
    }
    return nil;
    
}