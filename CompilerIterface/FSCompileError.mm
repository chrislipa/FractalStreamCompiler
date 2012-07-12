//
//  FSCompileError.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSCompileError.h"



@implementation FSCompileError


@synthesize isFatalError = _isFatalError;
@synthesize errorSeverity = _errorSeverity;
@synthesize sourceRange = _sourceRange;
@synthesize sourceSubstring = _sourceSubstring;
@synthesize errorMessage = _errorMessage;
@synthesize compileErrorType = _compileErrorType;

@end
