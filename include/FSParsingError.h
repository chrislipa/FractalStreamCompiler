//
//  ParseError.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FractalStreamCompiler_ParseError_h
#define FractalStreamCompiler_ParseError_h

#include "FSCompilerErrorTypeDefinitions.h"



struct FSParsingError {
    FSCompileErrorSeverity errorSeverity;
    FSCompileErrorType errorType;
    char* errorMessage;
    char* sourceCodeSubstring;
    int firstLine, firstColumn, lastLine, lastColumn;
    bool isFatal;
};


#endif
