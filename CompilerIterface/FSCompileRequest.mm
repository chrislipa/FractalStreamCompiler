//
//  FSCompileRequest.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSCompileRequest.h"

@implementation FSCompileRequest

@synthesize sourceCode = _sourceCode;
@synthesize languageIdentifier = _languageIdentifier;
@synthesize languageVersion = _languageVersion;
@synthesize maximumLoopDepth = _maximumLoopDepth;
@synthesize numberOfVariables = _numberOfVariables;

-(id) init {
    if  (self = [super init]) {
        
    }
    return self;
}

-(id) initWithSourceCode:(NSString*) sourceCode andLanguage:(NSString*) language {
    if  (self = [super init]) {
        self.sourceCode = sourceCode;
        self.languageIdentifier = language;
    }
    return self;
}


+(FSCompileRequest*) getCompileRequestWithSourceCode:(NSString*) sourceCode andLanguage:(NSString*) language {
    return [[[self alloc] initWithSourceCode:sourceCode andLanguage:language] autorelease];
}


-(void) dealloc {
    [_sourceCode release];
    [_languageIdentifier release];
    [_languageVersion release];
    [super dealloc];
}
@end
