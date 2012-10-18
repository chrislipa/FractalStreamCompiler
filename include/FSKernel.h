//
//  FSKernel.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#ifndef FS_FSKERNEL
#define FS_FSKERNEL

#import <Cocoa/Cocoa.h>
#include "FractalStreamCompilerDefinitions.h"




@interface FSKernel : NSObject {
	BOOL _kernelLoaded;
	BOOL _useJIT;
	int _mode, _pass, _defaults;
	//FSECompiler* compiler;
	//FSEParseNode* tree;
	void** _val;
	kernel_func_ptr _kernelPtr;;
	void* _module;
	void* _bldr;
	
	void* _llvmKernel;					// (Function*) llvmKernel
	void *_inputP, *_outputP;	// (Value*) _inputP etc
	void *_xP, *_jP, *_flagP;							// (AllocaInst*) xP etc
	void *_reportxP, *_reportyP, *_reportedP, *_probeP;	// (AllocaInst*) reportxP etc
	void *_big2, *_tiny2;	// (Value*) big2 etc
	void *_maxIt, *_loop_i; // (Value*) maxIt etc
	void *_commenceBlock;	// (BasicBlock*) commenceBlock
	void *_f_exp, *_f_log, *_f_sqrt, *_f_cos, *_f_sin, *_f_tan;			// (Function*) f_exp etc
	void *_f_cosh, *_f_sinh, *_f_tanh, *_f_acos, *_f_asin, *_f_atan;	// (Function*) f_cosh etc
	void *_f_atan2, *_f_fmod;	// (Function*) f_atan2 etc
	void *_f_frandom, *_f_gaussian;	// (Function*) f_random, etc
	void *_dsInP, *_dsOutP, *_dsResPf, *_dsResPl;
	int _eSF_was_const;
	double _eSF_const_x;
	double _eSF_const_y;
	char* _postfixID;
	int _emitStep;
	
	//FSJitter* jitter;
	//FSCustomDataManager* dataManager;
	void* _customDataPtr;
	void* _customQueryPtr;
	void** _dataSource;
	void** _mergeSource;
}
///---

@property (readwrite,assign) BOOL kernelLoaded;
@property (readwrite,assign) BOOL useJIT;
@property (readwrite,assign) int mode;
@property (readwrite,assign) int pass;
@property (readwrite,assign) int defaults;
//FSECompiler* compiler;
//FSEParseNode* tree;
@property (readwrite,assign) void** val;

@property (readwrite,assign)  kernel_func_ptr kernelPtr;
@property (readwrite,assign) void* module;
@property (readwrite,assign) void* bldr;

@property (readwrite,assign) void* llvmKernel;					// (Function*) llvmKernel
@property (readwrite,assign) void* inputP;
@property (readwrite,assign) void* outputP;	// (Value*) _inputP etc
@property (readwrite,assign) void* xP;
@property (readwrite,assign) void* jP;
@property (readwrite,assign) void* flagP;							// (AllocaInst*) xP etc
@property (readwrite,assign) void *reportxP;
@property (readwrite,assign) void*reportyP;
@property (readwrite,assign) void*reportedP;
@property (readwrite,assign) void*probeP;	// (AllocaInst*) reportxP etc
@property (readwrite,assign) void *big2;
@property (readwrite,assign) void*tiny2;	// (Value*) big2 etc
@property (readwrite,assign) void *maxIt;
@property (readwrite,assign) void*loop_i; // (Value*) maxIt etc
@property (readwrite,assign) void *commenceBlock;	// (BasicBlock*) commenceBlock
@property (readwrite,assign) void *f_exp;
@property (readwrite,assign) void *f_log;
@property (readwrite,assign) void *f_sqrt;
@property (readwrite,assign) void*f_cos;
@property (readwrite,assign) void*f_sin;
@property (readwrite,assign) void *f_tan;			// (Function*) f_exp etc
@property (readwrite,assign) void *f_cosh;
@property (readwrite,assign) void*f_sinh;
@property (readwrite,assign) void*f_tanh;
@property (readwrite,assign) void*f_acos;
@property (readwrite,assign) void*f_asin;
@property (readwrite,assign) void *f_atan;	// (Function*) f_cosh etc
@property (readwrite,assign) void *f_atan2;
@property (readwrite,assign) void *f_fmod;	// (Function*) f_atan2 etc
@property (readwrite,assign) void *f_frandom;
@property (readwrite,assign) void*f_gaussian;	// (Function*) f_random, etc
@property (readwrite,assign) void *dsInP, *dsOutP, *dsResPf, *dsResPl;
@property (readwrite,assign) int eSF_was_const;
@property (readwrite,assign) double eSF_const_x;
@property (readwrite,assign) double eSF_const_y;
@property (readwrite,assign) char* postfixID;
@property (readwrite,assign) int emitStep;

//FSJitter* jitter;
//FSCustomDataManager* dataManager;
@property (readwrite,assign) void* customDataPtr;
@property (readwrite,assign) void* customQueryPtr;
@property (readwrite,assign) void** dataSource;
@property (readwrite,assign) void** mergeSource;


//---



//- (void) setDataManager: (FSCustomDataManager*) dm;
//- (BOOL) buildKernelFromCompiler: (FSECompiler*) newComp;
- (void) buildLLVMKernel;
- (void*) loadKernelFromFile: (NSString*) filename;

- (void) runKernelWithMode: (int) mde input: (double*) input ofLength: (int) length output: (double*) output maxIter: (int) maxIter maxNorm: (double) maxNorm minNorm: (double) minNorm;
- (void*) emit: (int) node;

@end


#endif
