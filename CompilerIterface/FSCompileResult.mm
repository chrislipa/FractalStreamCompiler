//
//  FSCompileResult.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSCompileResult.h"

@implementation FSCompileResult 
@synthesize isCompileSuccessful = _isCompileSuccessful;
@synthesize compileErrors = _compileErrors;
@synthesize compileRequest = _compileRequest;

-(id) init {
    if  (self = [super init]) {
    }
    return self;
}


+(FSCompileResult*) compileResultWithRequest:(FSCompileRequest*) request andError:(FSCompileError*) error {
    FSCompileResult* r = [[FSCompileResult alloc] init];
    r.isCompileSuccessful = NO;
    r.compileRequest = request;
    r.compileErrors = [NSArray arrayWithObjects:error, nil];
    return [r autorelease];
}



-(void) dealloc {
    [_compileErrors release];
    [_compileRequest release];
    [super dealloc];
}


@end
