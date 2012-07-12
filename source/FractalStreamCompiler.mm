//
//
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#include "FractalStreamCompiler.h"
#include "Compiler.h"




extern "C" 

FSCompileResult* fractalStreamCompileRequest(FSCompileRequest* compileRequest) {
    @autoreleasepool {
        
    
        FSCompileResult* res = fs_internalCompile(compileRequest);
    
        
        return nil;
       
    }
}