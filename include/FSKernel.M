//
//  FSKernel.M
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSKernel.h"
#include "llvm/Constants.h"
#include "llvm/DerivedTypes.h"
#include "llvm/Instructions.h"
#include "llvm/Function.h"
#include "llvm/CallingConv.h"
#include "llvm/Analysis/Verifier.h"
#include "llvm/Module.h"

#include "llvm/ExecutionEngine/JIT.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/PassManager.h"
#include "llvm/Assembly/PrintModulePass.h"
#include "llvm/Support/IRBuilder.h"
#include "llvm/Target/TargetData.h"
#include "llvm/Transforms/Scalar.h"
#include <iostream>
#import <dlfcn.h>
using namespace llvm;

@implementation FSKernel


@synthesize kernelLoaded = _kernelLoaded;
@synthesize useJIT = _useJIT;
@synthesize mode = _mode;
@synthesize pass = _pass;
@synthesize defaults = _defaults;
//FSECompiler* compiler;
//FSEParseNode* tree;
@synthesize val = _val;

@synthesize kernelPtr = _kernelPtr;
@synthesize module = _module;
@synthesize bldr = _bldr;

@synthesize llvmKernel = _llvmKernel;					// (Function*) llvmKernel
@synthesize inputP = _inputP;
@synthesize outputP = _outputP;	// (Value*) _inputP etc
@synthesize xP = _xP;
@synthesize jP = _jP;
@synthesize flagP = _flagP;							// (AllocaInst*) xP etc
@synthesize reportxP = _reportxP;
@synthesize reportyP = _reportyP;
@synthesize reportedP = _reportedP;
@synthesize probeP = _probeP;	// (AllocaInst*) reportxP etc
@synthesize big2= _big2;
@synthesize tiny2 = _tiny2;	// (Value*) big2 etc
@synthesize maxIt = _maxIt;
@synthesize loop_i = _loop_i; // (Value*) maxIt etc
@synthesize commenceBlock = _commenceBlock;	// (BasicBlock*) commenceBlock
@synthesize f_exp = _f_exp;
@synthesize f_log = _f_log;
@synthesize f_sqrt = _f_sqrt;
@synthesize f_cos = _f_cos;
@synthesize f_sin = _f_sin;
@synthesize f_tan = _f_tan;			// (Function*) f_exp etc
@synthesize f_cosh = _f_cosh;
@synthesize f_sinh = _f_sinh;
@synthesize f_tanh = _f_tanh;
@synthesize f_acos = _f_acos;
@synthesize f_asin = _f_asin;
@synthesize f_atan = _f_atan;	// (Function*) f_cosh etc
@synthesize f_atan2 = _f_atan2;
@synthesize f_fmod = _f_fmod;	// (Function*) f_atan2 etc
@synthesize f_frandom = _f_frandom;
@synthesize f_gaussian = _f_gaussian;	// (Function*) f_random, etc
@synthesize dsInP = _dsInP;
@synthesize dsOutP = _dsOutP;
@synthesize dsResPf = _dsResPf;
@synthesize dsResPl = _dsResPl;
@synthesize eSF_was_const = _eSF_was_const;
@synthesize eSF_const_x = _eSF_const_x;
@synthesize eSF_const_y = _eSF_const_y;
@synthesize postfixID = _postfixID;
@synthesize emitStep = _emitStep;

//FSJitter* jitter;
//FSCustomDataManager* dataManager;
@synthesize customDataPtr = _customDataPtr;
@synthesize customQueryPtr = _customQueryPtr;
@synthesize dataSource = _dataSource;
@synthesize mergeSource = _mergeSource;





- (void*) loadKernelFromFile: (NSString*) filename {
	void* dmodule;
	dmodule = dlopen([filename cStringUsingEncoding:NSUTF8StringEncoding], RTLD_NOW);
	NSLog(@"module is %p, filename is %@\n", dmodule, filename);
	if(dmodule == NULL) return NULL;
	self.kernelPtr = (void(*)(int,double*,int,double*,int,double,double)) dlsym(dmodule, "kernel");
	NSLog(@"kernelPtr is %p\n", (void*) self.kernelPtr);
	return (void*) self.kernelPtr;
}

- (void) runKernelWithMode: (int) mde input: (double*) input ofLength: (int) length output: (double*) output maxIter: (int) maxIter maxNorm: (double) maxNorm minNorm: (double) minNorm {
	self.kernelPtr(mde, input, length, output, maxIter, maxNorm, minNorm);
}



@end
