//
//  FSCompileResult.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSCompileRequest.h"
@interface FSCompileResult : NSObject  {
    bool _isCompileSuccessful;
    NSMutableArray* _compileErrors;
    FSCompileRequest* _compileRequest;
}

@property (readwrite,assign) bool isCompileSuccessful;
@property (readwrite,retain) NSMutableArray* compileErrors;
@property (readwrite,retain) FSCompileRequest* compileRequest;

@end
