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

-(id) init {
    if (self = [super init]) {
    }
    return self;
}

+(FSCompileError*) compileError {
    return [[[FSCompileError alloc] init] autorelease];
}


+(FSCompileError*) noLanguageSpecified {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = 100;
    e.errorMessage = @"Please specify a scripting language.";
    e.compileErrorType = FSCompileErrorType_MissingLanguage;
    return e;
}

+(FSCompileError*) missingSourceCode {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = 100;
    e.errorMessage = @"Source code for script is missing.";
    e.compileErrorType = FSCompileErrorType_MissingSourceCode;
    return e;
}

+(FSCompileError*) emptySourceCode  {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = 100;
    e.errorMessage = @"Source code for script is empty.";
    e.compileErrorType = FSCompileErrorType_EmptySourceCode;
    return e;
}

+(FSCompileError*) invalidCharacterEncoding {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = 100;
    e.errorMessage = @"Could not convert source code to ASCII encoding.";
    e.compileErrorType = FSCompileErrorType_EmptySourceCode;
    return e;
}

+(FSCompileError*) unrecognizedLanguage:(NSString*)languageIdentifier {
    FSCompileError* e = [self compileError];
    e.isFatalError = YES;
    e.errorSeverity = 100;
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
    e.errorSeverity = 100;
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
