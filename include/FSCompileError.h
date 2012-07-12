//
//  FSCompileError.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSSourceRange.h"

typedef enum {
    FSCompileErrorType_None = 0,
    FSCompileErrorType_UnrecognizedToken = 1,
    FSCompileErrorType_UnableToParse = 2,
    FSCompileErrorType_Unknown = 9999
} FSCompileErrorType;


@interface FSCompileError : NSObject  {
    bool _isFatalError;
    int _errorSeverity;
    FSCompileErrorType _compileErrorType;
    FSSourceRange* _sourceRange;
    NSString* _sourceSubstring;
    NSString* _errorMessage;
}

@property (readwrite,assign) FSCompileErrorType compileErrorType;
@property (readwrite,assign) bool isFatalError;
@property (readwrite,assign) int errorSeverity;
@property (readwrite,retain) FSSourceRange* sourceRange;
@property (readwrite,retain) NSString* sourceSubstring;
@property (readwrite,retain) NSString* errorMessage;


@end
