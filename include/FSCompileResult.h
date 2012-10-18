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

#import "FractalStreamCompilerDefinitions.h"
#include "FSKernel.h"

@class FSCompileError;



@interface FSCompileResult : NSObject  {
    
    bool _isCompileSuccessful;
    NSMutableArray* _compileErrors;
    FSCompileRequest* _compileRequest;
    void* _abstractSyntaxTree;
    
    FSKernel* _kernel;

    
}
@property (readwrite,assign) void* abstractSyntaxTree;
@property (readwrite,assign) bool isCompileSuccessful;
@property (readwrite,retain) NSMutableArray* compileErrors;
@property (readwrite,retain) FSCompileRequest* compileRequest;
@property (readwrite,assign) FSKernel* kernel;

+(FSCompileResult*) compileResultWithRequest:(FSCompileRequest*) request andError:(FSCompileError*) error;
+(FSCompileResult*) compileResultWithRequest:(FSCompileRequest*) request andErrors:(NSMutableArray*) errors;

@end
