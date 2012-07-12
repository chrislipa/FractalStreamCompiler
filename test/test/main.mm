//
//  main.c
//  test
//
//  Created by Christopher Lipa on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <stdio.h>
#include "FractalStreamCompiler.h"

int main(int argc, const char * argv[])
{
    FSCompileRequest* req = [FSCompileRequest getCompileRequestWithSourceCode:@"9*17*11"];
	FSCompileResult* res = fractalStreamCompileRequest(req);
	
    printf("%ld",(long)res);
	
    return 0;
}

