//
//  KernelBuilder.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FSKernelBuilder_H
#define FSKernelBuilder_H
#import <Foundation/Foundation.h>
#include "FractalStreamCompilerDefinitions.h"


kernel_func_ptr buildFractalStreamKernel(Node* abstractSyntaxTree);

#endif