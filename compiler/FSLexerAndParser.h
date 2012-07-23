//
//  Compiler.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FractalStreamCompiler_Compiler
#define FractalStreamCompiler_Compiler

#include "node.h"
#import "FSCompileRequest.h"
#import "FSCompileResult.h"

extern "C"

FSCompileResult* fsLexAndParse(FSCompileRequest* compileRequest, Node** abstractSyntaxTree);

#endif
