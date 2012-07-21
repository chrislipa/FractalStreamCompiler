//
//
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#include "FractalStreamCompiler.h"
#import "FSInternalCompiler.h"




extern "C" 

FSCompileResult* fractalStreamCompileRequest(FSCompileRequest* compileRequest) {
    
        
    
        return fsInternalCompile(compileRequest);
    
       
    
}