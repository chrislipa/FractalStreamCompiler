/*
 *  FractalStreamCompiler.cp
 *  FractalStreamCompiler
 *
 *  Created by Christopher Lipa on 7/4/12.
 *  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
 *
 */

#include <iostream>
#include "FractalStreamCompiler.h"
#include "FractalStreamCompilerPriv.h"

void FractalStreamCompiler::HelloWorld(const char * s)
{
	 FractalStreamCompilerPriv *theObj = new FractalStreamCompilerPriv;
	 theObj->HelloWorldPriv(s);
	 delete theObj;
};

void FractalStreamCompilerPriv::HelloWorldPriv(const char * s) 
{
	std::cout << s << std::endl;
};

