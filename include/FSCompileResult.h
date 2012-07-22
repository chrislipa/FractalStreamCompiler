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
#import "node.h"
#import "FractalStreamCompilerDefinitions.h"
@class FSCompileError;

@interface FSCompileResult : NSObject  {
    
    bool _isCompileSuccessful;
    NSMutableArray* _compileErrors;
    FSCompileRequest* _compileRequest;
    Node* _abstractSyntaxTree;
    void(*_kernel)(int, double*, int, double*, int, double, double);
}
@property (readwrite,assign) void(*kernel)(int, double*, int, double*, int, double, double);
@property (readwrite,assign) Node* abstractSyntaxTree;
@property (readwrite,assign) bool isCompileSuccessful;
@property (readwrite,retain) NSMutableArray* compileErrors;
@property (readwrite,retain) FSCompileRequest* compileRequest;

+(FSCompileResult*) compileResultWithRequest:(FSCompileRequest*) request andError:(FSCompileError*) error;
+(FSCompileResult*) compileResultWithRequest:(FSCompileRequest*) request andErrors:(NSMutableArray*) errors;

@end
