//
//  FSCompileResult.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCompileRequest.h"
#import "FSCompileError.h"

@class FSCompileError;

@interface FSCompileResult : NSObject  {
    bool _isCompileSuccessful;
    NSMutableArray* _compileErrors;
    FSCompileRequest* _compileRequest;
}

@property (readwrite,assign) bool isCompileSuccessful;
@property (readwrite,retain) NSMutableArray* compileErrors;
@property (readwrite,retain) FSCompileRequest* compileRequest;

+(FSCompileResult*) compileResultWithRequest:(FSCompileRequest*) request andError:(FSCompileError*) error;
+(FSCompileResult*) compileResultWithRequest:(FSCompileRequest*) request andErrors:(NSMutableArray*) errors;

@end
