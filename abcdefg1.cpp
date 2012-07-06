//
//  abcdefg1.c
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include "abcdefg1.h"
#include "tokenize.h"




extern "C" 

int abcdefg1function() {
	printf("a\n");
	tokenizestring();
	printf("b\n");
	return 7;
}