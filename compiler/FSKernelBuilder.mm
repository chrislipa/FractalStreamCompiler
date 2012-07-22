//
//  KernelBuilder.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSKernelBuilder.h"
#include "llvm/Constants.h"
#include "llvm/DerivedTypes.h"
#include "llvm/Instructions.h"
#include "llvm/Function.h"
#include "llvm/CallingConv.h"
#include "llvm/Analysis/Verifier.h"
#include "llvm/Module.h"
#include <llvm/Value.h>
#include <llvm/LLVMContext.h>
#include "llvm/ExecutionEngine/JIT.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/PassManager.h"
#include "llvm/Assembly/PrintModulePass.h"
#include "llvm/Support/IRBuilder.h"
#include "llvm/Target/TargetData.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/support/IRBuilder.h"
#include "llvm/BasicBlock.h"
#include "FractalStreamCompilerDefinitions.h"
#include "llvm/Type.h"

#import "FSCompileResult.h"
#import "node.h"
using namespace llvm;

void fsBuildFractalStreamKernel(FSCompileResult* result) {
    Node* root = result.abstractSyntaxTree;
    
    llvm::LLVMContext llvmContext;
    llvm::Module* mod = new llvm::Module("LLVM Kernel", llvmContext);
    
    
    
    
    
    // Build the kernel function's interface
    Constant* c = mod -> getOrInsertFunction("kernel",
                                             Type::getVoidTy(llvmContext),							/* (void)			*/
                                             IntegerType::get(32),					/* int program		*/
                                             PointerType::get(Type::DoubleTy, 0),	/* double* input	*/
                                             IntegerType::get(32),					/* int length		*/
                                             PointerType::get(Type::DoubleTy, 0),	/* double* output	*/
                                             IntegerType::get(32),					/* int maxIter		*/
                                             Type::DoubleTy,							/* double maxRadius */
                                             Type::DoubleTy,							/* double minRadius */
                                             NULL);
    Function* llvmKernel = cast<Function>(c);
    llvmKernel -> setCallingConv(CallingConv::C);
    Function::arg_iterator args = llvmKernel -> arg_begin();
    Value* program = args++;	program ->	setName("program");
    Value* input = args++;		input ->	setName("input");
    Value* length = args++;		length ->	setName("length");
    Value* output = args++;		output ->	setName("output");
    Value* maxIter = args++;	maxIter ->	setName("maxIter");
    Value* maxRadius = args++;	maxRadius-> setName("maxRadius");
    Value* minRadius = args++;	minRadius->	setName("minRadius");
    
    std::vector<const Type*> nothing(0, Type::DoubleTy);
    std::vector<const Type*> oneDouble(1, Type::DoubleTy);
    std::vector<const Type*> twoDoubles(2, Type::DoubleTy);
    FunctionType* ft = FunctionType::get(Type::DoubleTy, oneDouble, false);
    FunctionType* ft2 = FunctionType::get(Type::DoubleTy, twoDoubles, false);
    /*FunctionType* ft0 = */FunctionType::get(Type::DoubleTy, nothing, false);
    Function* mathf;
    
    /*** Build extern declarations for math functions ***/
    mathf = Function::Create(ft, Function::ExternalLinkage,   "exp", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_exp = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "log", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_log = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "sqrt", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_sqrt = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "cos", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_cos = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "sin", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_sin = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "tan", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_tan = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "acos", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_acos = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "asin", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_asin = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "atan", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_atan = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "cosh", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_cosh = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "sinh", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_sinh = (void*) mathf;
    
    mathf = Function::Create(ft, Function::ExternalLinkage,   "tanh", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_tanh = (void*) mathf;
    
    mathf = Function::Create(ft2, Function::ExternalLinkage,  "atan2", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_atan2 = (void*) mathf;
    
    mathf = Function::Create(ft2, Function::ExternalLinkage,  "fmod", mod);
    mathf -> setCallingConv(CallingConv::C);				_f_fmod = (void*) mathf;
    
    ExecutionEngine* EE = (ExecutionEngine*) [[FSJitter jitter] engine];
    
    mathf = cast<Function> (mod -> getOrInsertFunction("frandom", Type::DoubleTy, (Type *)0));
    mathf -> setCallingConv(CallingConv::C);				_f_frandom = (void*) mathf;
    EE -> addGlobalMapping(mathf, (void*) frandom);
    
    mathf = cast<Function> (mod -> getOrInsertFunction("gaussian", Type::DoubleTy, (Type *)0));
    mathf -> setCallingConv(CallingConv::C);				_f_gaussian = (void*) mathf;
    EE -> addGlobalMapping(mathf, (void*) gaussian);
    
    /*** end of externs ***/
    
    BasicBlock* block = BasicBlock::Create("entry", llvmKernel);
    IRBuilder<> builder(block);
    bldr = (void*) &builder;
    
    BasicBlock* initModeBlock = BasicBlock::Create("initialization modes", llvmKernel);
    BasicBlock* runModeBlock = BasicBlock::Create("execution modes");
    
    GetElementPtrInst *x, /**j,*/ *tmpP/*, *tmp2P, *tmp3P*/;
    Value *tmp/*, *tmp2, *tmp3*/;
    AllocaInst* jP = builder.CreateAlloca(Type::Int32Ty, LLVMi32([compiler maximumLoopDepth]), "j[]");	
    AllocaInst* xP = builder.CreateAlloca(Type::DoubleTy, LLVMi32([compiler numberOfVariables]), "x[]");
    AllocaInst* flagP = builder.CreateAlloca(IntegerType::get(32), 0, "&flag");
    AllocaInst* probeP = builder.CreateAlloca(IntegerType::get(32), 0, "&probe");
    AllocaInst* lengthP = builder.CreateAlloca(IntegerType::get(32), 0, "&length");
    //AllocaInst* crP = builder.CreateAlloca(Type::DoubleTy, 0, "cr");
    //AllocaInst* ciP = builder.CreateAlloca(Type::DoubleTy, 0, "ci");
    AllocaInst* reportedP = builder.CreateAlloca(IntegerType::get(32), 0, "&reported");
    AllocaInst* reportxP = builder.CreateAlloca(Type::DoubleTy, 0, "reportX");
    AllocaInst* reportyP = builder.CreateAlloca(Type::DoubleTy, 0, "reportY");
    AllocaInst* dsInP = builder.CreateAlloca(Type::DoubleTy, LLVMi32(2), "dataSourceIn[]");
    AllocaInst* dsOutP = builder.CreateAlloca(Type::DoubleTy, LLVMi32(512), "dataSourceOut[]");
    AllocaInst* dsResPl = builder.CreateAlloca(Type::DoubleTy, LLVMi32(512), "dataSourceResLoc[]");
    AllocaInst* dsResPf = builder.CreateAlloca(IntegerType::get(32), LLVMi32(512), "dataSourceResFlag[]");
    
    Value* big2 = builder.CreateMul(maxRadius, maxRadius, "huge");
    Value* tiny2 = builder.CreateMul(minRadius, minRadius, "tiny");
    builder.CreateStore(length, lengthP);
    builder.CreateStore(LLVMi32(0), flagP);
    builder.CreateStore(LLVMi32(0), reportedP); 
    builder.CreateStore(LLVMi32(0), probeP);
    Value* cond;
    
    BasicBlock* useProbeBlock = BasicBlock::Create("using a probe", llvmKernel);
    BasicBlock* endUseProbeBlock = BasicBlock::Create("select mode", llvmKernel);
    Value* useProbe = builder.CreateICmpSLT(length, LLVMi32(0));
    builder.CreateCondBr(useProbe, useProbeBlock, endUseProbeBlock);
    builder.SetInsertPoint(useProbeBlock);
    Value* probeNumber = builder.CreateMul(length, LLVMi32(-1));
    builder.CreateStore(probeNumber, probeP);
    builder.CreateStore(LLVMi32(1), lengthP);
    builder.CreateBr(endUseProbeBlock);
    builder.SetInsertPoint(endUseProbeBlock);
    Value* initCond = builder.CreateICmpSLE(program, LLVMi32(0), "initCond");
    builder.CreateCondBr(initCond, initModeBlock, runModeBlock);
    
    bldr = (void*) &builder;
    _llvmKernel = (void*) llvmKernel;
    _inputP = (void*) input; _outputP = (void*) output; _flagP = (void*) flagP;
    _xP = (void*) xP; _jP = (void*) jP;
    _reportxP = (void*) reportxP; _reportyP = (void*) reportyP;
    _reportedP = (void*) reportedP; _probeP = (void*) probeP;
    _maxIt = (void*) maxIter; _big2 = (void*) big2; _tiny2 = (void*) tiny2;
    _dsInP = (void*) dsInP; _dsOutP = (void*) dsOutP;
    _dsResPf = (void*) dsResPf; _dsResPl = (void*) dsResPl;
    
    defaults = 0; pass = 0;
    
    builder.SetInsertPoint(initModeBlock);
    BasicBlock* initBlock = BasicBlock::Create("initialization", llvmKernel);
    BasicBlock* elseBlock = BasicBlock::Create("else");
    cond = builder.CreateICmpEQ(program, LLVMi32(-1), "initializationCond");
    builder.CreateCondBr(cond, initBlock, elseBlock);
    builder.SetInsertPoint(initBlock);
    
    /* * * * * */
    /* emit the initialization block */
    /* * * * * */
    _loop_i = NULL; _commenceBlock = NULL;
    mode = -1;
    [self emit: node];
    node = tree[node].nextSibling;
    
    builder.CreateRetVoid();
    llvmKernel -> getBasicBlockList().push_back(elseBlock);
    builder.SetInsertPoint(elseBlock);
    BasicBlock* defcntBlock = BasicBlock::Create("defaults count", llvmKernel);
    elseBlock = BasicBlock::Create("else");
    cond = builder.CreateICmpEQ(program, LLVMi32(-2), "defcntCond");
    builder.CreateCondBr(cond, defcntBlock, elseBlock);
    builder.SetInsertPoint(defcntBlock);
    
    /* * * * * */
    /* emit defaults count */
    /* * * * * */
    mode = 0;
    _loop_i = NULL; _commenceBlock = NULL;
    [self emit: node];
    GetElementPtrInst* defCountPtr = GetElementPtrInst::Create(output, LLVMi32(0), "tmp", defcntBlock);
    builder.CreateStore(LLVMd((double) defaults), defCountPtr);
    
    builder.CreateRetVoid();
    llvmKernel -> getBasicBlockList().push_back(elseBlock);
    builder.SetInsertPoint(elseBlock);
    BasicBlock* defvalBlock = BasicBlock::Create("defaults values", llvmKernel);
    elseBlock = BasicBlock::Create("else");
    cond = builder.CreateICmpEQ(program, LLVMi32(-3), "defvalCond");
    builder.CreateCondBr(cond, defvalBlock, elseBlock);
    builder.SetInsertPoint(defvalBlock);
    
    /* * * * * */
    /* emit defaults values */
    /* * * * * */
    mode = 1;
    _loop_i = NULL; _commenceBlock = NULL;
    defaults = 0;
    [self emit: node];
    
    builder.CreateRetVoid();
    llvmKernel -> getBasicBlockList().push_back(elseBlock);
    builder.SetInsertPoint(elseBlock);
    builder.CreateRetVoid();
    llvmKernel -> getBasicBlockList().push_back(runModeBlock);
    builder.SetInsertPoint(runModeBlock);
    /* run mode stuff here */
    BasicBlock* parBlock = BasicBlock::Create("parameter space code", llvmKernel);
    BasicBlock* dynBlock = BasicBlock::Create("dynamical space code");
    cond = builder.CreateICmpEQ(program, LLVMi32(1), "programCond");
    builder.CreateCondBr(cond, parBlock, dynBlock);
    builder.SetInsertPoint(parBlock);
    { // main iteration loop for working in parameter space
        /* Input processing loop */
        BasicBlock* InputLoop = BasicBlock::Create("input loop for parameter space", llvmKernel);
        BasicBlock* commenceBlock = BasicBlock::Create("commence", llvmKernel);
        builder.CreateBr(InputLoop);
        builder.SetInsertPoint(InputLoop);
        PHINode *loop_i = builder.CreatePHI(IntegerType::get(32), "i");
        loop_i -> addIncoming(LLVMi32(0), parBlock);
        {
            GetElementPtrInst* in0 = GetElementPtrInst::Create(input, LLVMi32(0), "&in[0]", InputLoop);
            GetElementPtrInst* in1 = GetElementPtrInst::Create(input, LLVMi32(1), "&in[1]", InputLoop);
            GetElementPtrInst* in2 = GetElementPtrInst::Create(input, LLVMi32(2), "&in[2]", InputLoop);
            Value* c0 = builder.CreateLoad(in0, "in[0]");
            Value* c1 = builder.CreateLoad(in1, "in[1]");
            Value* step = builder.CreateLoad(in2, "in[2]");
            Value* doublei = builder.CreateUIToFP(loop_i, Type::DoubleTy, "(double) i");
            Value* istep = builder.CreateMul(step, doublei, "i * step");
            Value* c00 = builder.CreateAdd(c0, istep, "in[0] + i * in[2]");
            builder.CreateStore(LLVMi32(0), flagP);
            builder.CreateStore(LLVMi32(0), reportedP);
            x = GetElementPtrInst::Create(xP, LLVMi32(0), "&x[0]", thisBlock);
            builder.CreateStore(LLVMd(0.0), x);
            x = GetElementPtrInst::Create(xP, LLVMi32(1), "&x[1]", thisBlock);
            builder.CreateStore(LLVMd(0.0), x);
            x = GetElementPtrInst::Create(xP, LLVMi32(2), "&x[2]", thisBlock);
            builder.CreateStore(c00, x);
            x = GetElementPtrInst::Create(xP, LLVMi32(3), "&x[3]", thisBlock);
            builder.CreateStore(c1, x);
            tmpP = GetElementPtrInst::Create(input, LLVMi32(5), "&in[5]", thisBlock);
            x = GetElementPtrInst::Create(xP, LLVMi32(4), "&x[4]", thisBlock);
            tmp = builder.CreateLoad(tmpP, "in[5]");
            builder.CreateStore(tmp, x);
            tmpP = GetElementPtrInst::Create(input, LLVMi32(6), "&in[6]", thisBlock);
            x = GetElementPtrInst::Create(xP, LLVMi32(5), "&x[5]", thisBlock);
            tmp = builder.CreateLoad(tmpP, "in[6]");
            builder.CreateStore(tmp, x);
            {
                tmpP = GetElementPtrInst::Create(jP, LLVMi32(0), "&j[0]", thisBlock);
                builder.CreateStore(LLVMi32(0), tmpP);
                mode = 2;		/*** Emit parameter space code ***/
                _loop_i = (void*) loop_i; _commenceBlock = (void*) commenceBlock;
                [self emit: node];
            }
            tmpP = GetElementPtrInst::Create(jP, LLVMi32(0), "&j[0]", thisBlock);
            Value* lastJ = builder.CreateLoad(tmpP, "last-j");
            Value* lastJp1 = builder.CreateAdd(lastJ, LLVMi32(1), "last-j + 1");
            Value* shiftedJ = builder.CreateShl(lastJp1, LLVMi32(8), "shifted j");
            Value* flg = builder.CreateLoad(flagP, "flag");
            Value* retStatus = builder.CreateOr(shiftedJ, flg, "int status");
            {
                Value* reported = builder.CreateLoad(reportedP);
                Value* reportedCond = builder.CreateICmpEQ(reported, LLVMi32(0));
                BasicBlock* createReportBlock = BasicBlock::Create("default report", llvmKernel);
                BasicBlock* reportReadyBlock = BasicBlock::Create("report ready", llvmKernel);
                builder.CreateCondBr(reportedCond, createReportBlock, reportReadyBlock);
                builder.SetInsertPoint(createReportBlock);
                GetElementPtrInst *ptr = GetElementPtrInst::Create(xP, LLVMi32(0), "&x[0]", thisBlock);
                Value* x0 = builder.CreateLoad(ptr, "x[0]");
                builder.CreateStore(x0, reportxP);
                ptr = GetElementPtrInst::Create(xP, LLVMi32(1), "&x[1]", thisBlock);
                Value* x1 = builder.CreateLoad(ptr, "x[1]");
                builder.CreateStore(x1, reportyP);
                builder.CreateBr(reportReadyBlock);
                builder.SetInsertPoint(reportReadyBlock);
                Value* r0 = builder.CreateLoad(reportxP, "reportX");
                Value* r1 = builder.CreateLoad(reportyP, "reportY");
                Value* idx = builder.CreateMul(LLVMi32(3), loop_i, "3i");
                Value* idx1 = builder.CreateAdd(idx, LLVMi32(0), "3*i + 0");
                Value* idx2 = builder.CreateAdd(idx, LLVMi32(1), "3*i + 1");
                Value* idx3 = builder.CreateAdd(idx, LLVMi32(2), "3*i + 2");
                GetElementPtrInst* out1 = GetElementPtrInst::Create(output, idx1, "out[(3*i) + 0]", thisBlock);
                builder.CreateStore(r0, out1);
                GetElementPtrInst* out2 = GetElementPtrInst::Create(output, idx2, "out[(3*i) + 1]", thisBlock);
                builder.CreateStore(r1, out2);
                GetElementPtrInst* out3 = GetElementPtrInst::Create(output, idx3, "out[(3*i) + 2]", thisBlock);
                Value* o3 = builder.CreateUIToFP(retStatus, Type::DoubleTy, "status");
                builder.CreateStore(o3, out3);
            }
            // end of main body for i loop	
        }
        builder.CreateBr(commenceBlock);
        builder.SetInsertPoint(commenceBlock);
        Value* next_i = builder.CreateAdd(loop_i, LLVMi32(1), "iplus1");
        Value* iMax = builder.CreateLoad(lengthP, "iMax");
        Value* loop_cond = builder.CreateICmpEQ(next_i, iMax, "input loop condition");
        BasicBlock* currentBlock = builder.GetInsertBlock();  // we've changed which block we are writing to
        BasicBlock* PostBlock = BasicBlock::Create("postblock", llvmKernel);
        builder.CreateCondBr(loop_cond, PostBlock, InputLoop);
        builder.SetInsertPoint(PostBlock);
        loop_i -> addIncoming(next_i, currentBlock);
        builder.CreateRetVoid();
    }
    llvmKernel -> getBasicBlockList().push_back(dynBlock);
    builder.SetInsertPoint(dynBlock);
    { // main iteration loop for working in dynamical space
        /* Input processing loop */
        BasicBlock* InputLoop = BasicBlock::Create("input loop for dynamical space", llvmKernel);
        BasicBlock* commenceBlock = BasicBlock::Create("commence", llvmKernel);
        builder.CreateBr(InputLoop);
        builder.SetInsertPoint(InputLoop);
        PHINode *loop_i = builder.CreatePHI(IntegerType::get(32), "i");
        loop_i -> addIncoming(LLVMi32(0), dynBlock);
        {
            /* Script code here */
            GetElementPtrInst* in3 = GetElementPtrInst::Create(input, LLVMi32(3), "&in[3]", InputLoop);
            GetElementPtrInst* in4 = GetElementPtrInst::Create(input, LLVMi32(4), "&in[4]", InputLoop);
            Value* c0 = builder.CreateLoad(in3, "in[3]");
            Value* c1 = builder.CreateLoad(in4, "in[4]");
            GetElementPtrInst* in2 = GetElementPtrInst::Create(input, LLVMi32(2), "&in[2]", InputLoop);
            Value* step = builder.CreateLoad(in2, "in[2]");
            Value* doublei = builder.CreateUIToFP(loop_i, Type::DoubleTy, "(double) i");
            Value* istep = builder.CreateMul(step, doublei, "i * step");
            GetElementPtrInst* x0p = GetElementPtrInst::Create(input, LLVMi32(0), "&in[0]", InputLoop);
            Value* x0 = builder.CreateLoad(x0p, "in[0]");
            Value* x00 = builder.CreateAdd(x0, istep, "in[0] + i * in[2]");
            builder.CreateStore(LLVMi32(0), flagP);
            builder.CreateStore(LLVMi32(0), reportedP);
            x = GetElementPtrInst::Create(xP, LLVMi32(0), "&x[0]", thisBlock);
            builder.CreateStore(x00, x);
            x = GetElementPtrInst::Create(xP, LLVMi32(1), "&x[1]", thisBlock);
            tmpP = GetElementPtrInst::Create(input, LLVMi32(1), "&in[1]", InputLoop);
            tmp = builder.CreateLoad(tmpP, "in[1]");
            builder.CreateStore(tmp, x);
            x = GetElementPtrInst::Create(xP, LLVMi32(2), "&x[2]", thisBlock);
            builder.CreateStore(c0, x);
            x = GetElementPtrInst::Create(xP, LLVMi32(3), "&x[3]", thisBlock);
            builder.CreateStore(c1, x);
            tmpP = GetElementPtrInst::Create(input, LLVMi32(5), "&in[5]", thisBlock);
            x = GetElementPtrInst::Create(xP, LLVMi32(4), "&x[4]", thisBlock);
            tmp = builder.CreateLoad(tmpP, "in[5]");
            builder.CreateStore(tmp, x);
            tmpP = GetElementPtrInst::Create(input, LLVMi32(6), "&in[6]", thisBlock);
            x = GetElementPtrInst::Create(xP, LLVMi32(5), "&x[5]", thisBlock);
            tmp = builder.CreateLoad(tmpP, "in[6]");
            builder.CreateStore(tmp, x);
            {
                tmpP = GetElementPtrInst::Create(jP, LLVMi32(0), "&j[0]", thisBlock);
                builder.CreateStore(LLVMi32(0), tmpP);
                mode = 3;		/*** Emit dynamical space code ***/
                _loop_i = (void*) loop_i; _commenceBlock = (void*) commenceBlock;
                [self emit: node];
            }	
            tmpP = GetElementPtrInst::Create(jP, LLVMi32(0), "&j[0]", thisBlock);
            Value* lastJ = builder.CreateLoad(tmpP, "last-j");
            Value* lastJp1 = builder.CreateAdd(lastJ, LLVMi32(1), "last-j + 1");
            Value* shiftedJ = builder.CreateShl(lastJp1, LLVMi32(8), "shifted j");
            Value* flg = builder.CreateLoad(flagP, "flag");
            Value* retStatus = builder.CreateOr(shiftedJ, flg, "int status");
            {
                Value* reported = builder.CreateLoad(reportedP);
                Value* reportedCond = builder.CreateICmpEQ(reported, LLVMi32(0));
                BasicBlock* createReportBlock = BasicBlock::Create("default report", llvmKernel);
                BasicBlock* reportReadyBlock = BasicBlock::Create("report ready", llvmKernel);
                builder.CreateCondBr(reportedCond, createReportBlock, reportReadyBlock);
                builder.SetInsertPoint(createReportBlock);
                GetElementPtrInst *ptr = GetElementPtrInst::Create(xP, LLVMi32(0), "&x[0]", thisBlock);
                Value* x0 = builder.CreateLoad(ptr, "x[0]");
                builder.CreateStore(x0, reportxP);
                ptr = GetElementPtrInst::Create(xP, LLVMi32(1), "&x[1]", thisBlock);
                Value* x1 = builder.CreateLoad(ptr, "x[1]");
                builder.CreateStore(x1, reportyP);
                builder.CreateBr(reportReadyBlock);
                builder.SetInsertPoint(reportReadyBlock);
                Value* r0 = builder.CreateLoad(reportxP, "reportX");
                Value* r1 = builder.CreateLoad(reportyP, "reportY");
                Value* idx = builder.CreateMul(LLVMi32(3), loop_i, "3i");
                Value* idx1 = builder.CreateAdd(idx, LLVMi32(0), "3*i + 0");
                Value* idx2 = builder.CreateAdd(idx, LLVMi32(1), "3*i + 1");
                Value* idx3 = builder.CreateAdd(idx, LLVMi32(2), "3*i + 2");
                GetElementPtrInst* out1 = GetElementPtrInst::Create(output, idx1, "out[(3*i) + 0]", thisBlock);
                builder.CreateStore(r0, out1);
                GetElementPtrInst* out2 = GetElementPtrInst::Create(output, idx2, "out[(3*i) + 1]", thisBlock);
                builder.CreateStore(r1, out2);
                GetElementPtrInst* out3 = GetElementPtrInst::Create(output, idx3, "out[(3*i) + 2]", thisBlock);
                Value* o3 = builder.CreateUIToFP(retStatus, Type::DoubleTy, "status");
                builder.CreateStore(o3, out3);
            }
            // end of main body for i loop	
        }		
        builder.CreateBr(commenceBlock);
        builder.SetInsertPoint(commenceBlock);
        Value* next_i = builder.CreateAdd(loop_i, LLVMi32(1), "iplus1");
        Value* iMax = builder.CreateLoad(lengthP, "iMax");
        Value* loop_cond = builder.CreateICmpEQ(next_i, iMax, "input loop condition");
        BasicBlock* currentBlock = builder.GetInsertBlock();  // we've changed which block we are writing to
        BasicBlock* PostBlock = BasicBlock::Create("postblock", llvmKernel);
        builder.CreateCondBr(loop_cond, PostBlock, InputLoop);
        builder.SetInsertPoint(PostBlock);
        loop_i -> addIncoming(next_i, currentBlock);
        builder.CreateRetVoid();
    }
    
    
    if(verifyModule(*mod, PrintMessageAction)) { NSLog(@"module did not verify\n"); llvmKernel -> dump(); return; }
    else NSLog(@"module verified\n");
    
    ExistingModuleProvider* MP = new ExistingModuleProvider(mod);
    [jitter addModuleProvider: (void*) MP];
    
    PassManager PM;	
    PM.add(new TargetData(*((TargetData*) [jitter targetData])));
    PM.add(createPromoteMemoryToRegisterPass());
    PM.add(createInstructionCombiningPass());
    PM.add(createGVNPREPass());
    PM.add(createGVNPass());
    PM.add(createReassociatePass());
    
    PM.run(*mod);
    
    //	llvmKernel -> dump();
    
    kernelPtr = (void (*)(int, double*, int, double*, int, double, double)) [jitter getPointerToFunction: (void*) llvmKernel];
    
    return kernelPtr;
}