//
//  ConvenienceMacros.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 10/18/12.
//
//

#ifndef FractalStreamCompiler_ConvenienceMacros_h
#define FractalStreamCompiler_ConvenienceMacros_h

#define i32Type IntegerType::get(*(context.llvmContext), 32)
#define dType Type::getDoubleTy(*(context.llvmContext))
#define LLVMi32(x) ConstantInt::get(i32Type, (x), true)
#define LLVMu32(x) ConstantInt::get(i32Type, (x), false)
#define LLVMd(x) ConstantFP::get(dType, (x))
#define thisBlock context.builder->GetInsertBlock()

#endif
