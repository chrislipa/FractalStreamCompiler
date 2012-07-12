//
//  FSCodeGenerationContext.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FractalStreamCompiler_FSCodeGenerationContext_h
#define FractalStreamCompiler_FSCodeGenerationContext_h

#include <llvm/support/IRBuilder.h>
#include <llvm/Value.h>
#include <llvm/LLVMContext.h>
#include <llvm/Module.h>




class CodeGenContext;

struct FSCodeGenerationContext {
	llvm::LLVMContext* llvmContext;
	CodeGenContext* codeGenContext;
	llvm::Module* module;
	llvm::IRBuilder<>* builder;
	//std::map<std::string, llvm::Value*> namedValues;
};


#endif
