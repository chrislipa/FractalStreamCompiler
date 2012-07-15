//
//  FSCompileError.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSCompileError.h"

#import "FSScriptLanguageDescription.h"

@implementation FSCompileError


@synthesize isFatalError = _isFatalError;
@synthesize errorSeverity = _errorSeverity;
@synthesize sourceRange = _sourceRange;
@synthesize sourceSubstring = _sourceSubstring;
@synthesize errorMessage = _errorMessage;
@synthesize compileErrorType = _compileErrorType;

-(id) init {
    if (self = [super init]) {
    }
    return self;
}

-(id) initWithParsingError: (FSParsingError*) parseError fromLanguage:(FSScriptLanguageDescription*) lang {
    if  (self = [super init]) {
        self.isFatalError = parseError->isFatal;
        self.errorSeverity = parseError->errorSeverity;
        self.sourceRange = [FSSourceRange sourceRangeWithBeginning:parseError->firstLine
                                                                  :parseError->firstColumn 
                                                            andEnd:parseError->lastLine
                                                                  :parseError->lastColumn ];
        self.sourceSubstring = [NSString stringWithCString:parseError->sourceCodeSubstring encoding:[lang characterSetEncoding] ];
        self.errorMessage = [NSString stringWithCString:parseError->errorMessage encoding:[lang characterSetEncoding] ];
        self.compileErrorType= parseError->errorType;
    }
    return self;
}



+(FSCompileError*) compileError {
    return [[[FSCompileError alloc] init] autorelease];
}


+(FSCompileError*) noLanguageSpecified {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = FSCompileErrorSeverity_Error;
    e.errorMessage = @"Please specify a scripting language.";
    e.compileErrorType = FSCompileErrorType_MissingLanguage;
    return e;
}

+(FSCompileError*) unknownParseError {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = FSCompileErrorSeverity_Error;
    e.errorMessage = @"Unknown parsing error.";
    e.compileErrorType = FSCompileErrorType_UnknownParsingError;
    return e;
}

+(FSCompileError*) couldNotGenerateAST {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = FSCompileErrorSeverity_Error;
    e.errorMessage = @"Could not generate abstract syntax tree.  Unknown error.";
    e.compileErrorType = FSCompileErrorType_CouldNotGenerateAST;
    return e;
}

+(FSCompileError*) missingSourceCode {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = FSCompileErrorSeverity_Error;
    e.errorMessage = @"Source code for script is missing.";
    e.compileErrorType = FSCompileErrorType_MissingSourceCode;
    return e;
}

+(FSCompileError*) emptySourceCode  {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = FSCompileErrorSeverity_Error;
    e.errorMessage = @"Source code for script is empty.";
    e.compileErrorType = FSCompileErrorType_EmptySourceCode;
    return e;
}

+(FSCompileError*) invalidCharacterEncoding {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = FSCompileErrorSeverity_Error;
    e.errorMessage = @"Could not convert source code to ASCII encoding.";
    e.compileErrorType = FSCompileErrorType_EmptySourceCode;
    return e;
}

+(FSCompileError*) unrecognizedLanguage:(NSString*)languageIdentifier {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = FSCompileErrorSeverity_Error;
    e.errorMessage = [NSString stringWithFormat:
                      @"Unknown scripting language: '%@'.", languageIdentifier];
    e.compileErrorType = FSCompileErrorType_UnrecognizedLanguage;
    return e;
}




+(FSCompileError*) invalidCharacterEncoding:(NSString*)source encoding:(NSStringEncoding) encoding {
    FSSourceRange* range = nil;
    NSString* invalidCharacterString = nil;
    unichar invalidCharacter = 0;
    int line = 1;
    int column = 1;
    for (int i = 0; i < [source length]; i++) {
        NSString* characterToTest = [source substringWithRange:NSMakeRange(i, 1)];
        const char* x = [characterToTest cStringUsingEncoding:encoding];
        if (x == NULL || strlen(x) == 0) {
            range = [FSSourceRange sourceRangeWithBeginning:line :column andEnd:line :column+1];
            invalidCharacterString = characterToTest;
            invalidCharacter = [invalidCharacterString characterAtIndex:0];
            break;
        }
        column++;
        if (x[0] == '\n') {
            line++;
            column = 1;
        }
    }
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = FSCompileErrorSeverity_Error;
    if (range != nil && invalidCharacterString != 0) {
        e.sourceRange = range;
        e.sourceSubstring = invalidCharacterString;
        e.errorMessage = [NSString stringWithFormat:@"Could not convert character '%@' (unicode code point U+%04X) at line %d, column %d to %@ encoding.",
                          invalidCharacterString,
                          invalidCharacter,
                          range.startLine, range.startColumn,
                          [NSString localizedNameOfStringEncoding:encoding]
                          ];
    } else {
        e.errorMessage = [NSString stringWithFormat:@"Could not convert source code to %@ encoding.",
                          [NSString localizedNameOfStringEncoding:encoding]
                          ];
    }
    e.compileErrorType = FSCompileErrorType_InvalidSourceCharacterEncoding;
    return e;
}


@end
