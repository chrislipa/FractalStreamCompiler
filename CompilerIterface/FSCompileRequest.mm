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


-(id) init {
    if  (self = [super init]) {
        
    }
    return self;
}

-(id) initWithSourceCode:(NSString*) sourceCode {
    if  (self = [super init]) {
        self.sourceCode = sourceCode;
    }
    return self;
}


+(FSCompileRequest*) getCompileRequestWithSourceCode:(NSString*) sourceCode {
    return [[[self alloc] initWithSourceCode:sourceCode] autorelease];
}

@end
