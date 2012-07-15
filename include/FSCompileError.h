//
//  FSCompileError.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSSourceRange.h"
#import "FSCompilerErrorTypeDefinitions.h"
#import "FSParsingError.h"
#import "FSScriptLanguageDescription.h"


@interface FSCompileError : NSObject  {
    bool _isFatalError;
    FSCompileErrorSeverity _errorSeverity;
    FSCompileErrorType _compileErrorType;
    FSSourceRange* _sourceRange;
    NSString* _sourceSubstring;
    NSString* _errorMessage;
}

@property (readwrite,assign) FSCompileErrorType compileErrorType;
@property (readwrite,assign) bool isFatalError;
@property (readwrite,assign) FSCompileErrorSeverity errorSeverity;
@property (readwrite,retain) FSSourceRange* sourceRange;
@property (readwrite,retain) NSString* sourceSubstring;
@property (readwrite,retain) NSString* errorMessage;


-(id) initWithParsingError: (FSParsingError*) parseError fromLanguage:(FSScriptLanguageDescription*) lang;

+(FSCompileError*) compileError;

+(FSCompileError*) noLanguageSpecified;
+(FSCompileError*) unrecognizedLanguage:(NSString*)languageIdentifier;
+(FSCompileError*) couldNotGenerateAST ;
+(FSCompileError*) missingSourceCode;
+(FSCompileError*) emptySourceCode;
+(FSCompileError*) unknownParseError ;
+(FSCompileError*) invalidCharacterEncoding:(NSString*)source encoding:(NSStringEncoding) encoding;


@end
