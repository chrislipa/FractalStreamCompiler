//
//  abcdefg1.c
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include "FractalStreamCompiler.h"
#include "Compiler.h"




extern "C" 

void compile(const char* source) {
	internalCompileString(source);
}