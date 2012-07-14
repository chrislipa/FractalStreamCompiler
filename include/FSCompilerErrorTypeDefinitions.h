//
//  CompilerErrorTypeDefinitions.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FractalStreamCompiler_CompilerErrorTypeDefinitions_h
#define FractalStreamCompiler_CompilerErrorTypeDefinitions_h


typedef enum {
    FSCompileErrorType_None = 0,
    FSCompileErrorType_MissingLanguage =        101,
    FSCompileErrorType_UnrecognizedLanguage =   102,
    FSCompileErrorType_MissingSourceCode =         201,
    FSCompileErrorType_EmptySourceCode =       202,
    FSCompileErrorType_InvalidSourceCharacterEncoding =       203,
    FSCompileErrorType_UnrecognizedToken =      301,
    FSCompileErrorType_UnableToParse =          401,
    FSCompileErrorType_Unknown =                9999
} FSCompileErrorType;

#endif
