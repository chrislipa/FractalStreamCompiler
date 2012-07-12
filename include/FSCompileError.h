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
    FSCompileErrorType_MissingLanguage =        101,
    FSCompileErrorType_UnrecognizedLanguage =   102,
    FSCompileErrorType_MissingSourceCode =         201,
    FSCompileErrorType_EmptySourceCode =       202,
    FSCompileErrorType_InvalidSourceCharacterEncoding =       203,
    FSCompileErrorType_UnrecognizedToken =      301,
    FSCompileErrorType_UnableToParse =          401,
    FSCompileErrorType_Unknown =                9999
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

+(FSCompileError*) compileError;

+(FSCompileError*) noLanguageSpecified;
+(FSCompileError*) unrecognizedLanguage:(NSString*)languageIdentifier;

+(FSCompileError*) missingSourceCode;
+(FSCompileError*) emptySourceCode;

+(FSCompileError*) invalidCharacterEncoding:(NSString*)source encoding:(NSStringEncoding) encoding;

@end
