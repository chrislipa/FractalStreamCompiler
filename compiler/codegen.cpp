#include <iostream>

#include "node.h"
#include "codegen.h"
#include "FractalStreamScript_DialectA_parser.hpp"
#include "llvm/support/IRBuilder.h"
#include "llvm/BasicBlock.h"
#include "FSCodeGenerationContext.h"

//#include "llvm/DerivedTypes.h"
//#include "llvm/Instructions.h"
using namespace std;







/* Compile the AST into a module */
void CodeGenContext::generateCode(Node& root)
{

	std::cout << "Generating code...\n"<<endl;
	
	// Create the top level interpreter function to call as entry 
	ArrayRef<Type*> argTypes;

	
	
	
	FSCodeGenerationContext con;
	con.codeGenContext = this;
    LLVMContext llvmContext;
    llvm::Module module("my cool jit", llvmContext);
	llvm::IRBuilder<> builder(llvmContext);
    
    con.llvmContext = &llvmContext;
    con.module = &module;
    con.builder = &builder;
    
	FunctionType *ftype = FunctionType::get(Type::getVoidTy(getGlobalContext()), argTypes, false);
	mainFunction = Function::Create(ftype, GlobalValue::InternalLinkage, "main", con.module);
	BasicBlock *bblock = BasicBlock::Create(getGlobalContext(), "entry", mainFunction, 0);
	
	// Push a new variable/block context 
	pushBlock(bblock);
	Value* value = root.codeGen(con); // emit bytecode for the toplevel block 
	ReturnInst::Create(getGlobalContext(), bblock);
	popBlock();
	
	// to see if our program compiled properly
	 
	std::cout << "Code is generated: "<<value << endl;
	PassManager pm;
	pm.add(createPrintModulePass(&outs()));
	pm.run(*con.module);
}

/* Executes the AST by running the main function */
GenericValue CodeGenContext::runCode() {
	std::cout << "Running code...\n";

	
	ExecutionEngine *ee = EngineBuilder(module).create();
	vector<GenericValue> noargs;
	GenericValue v = ee->runFunction(mainFunction, noargs);
	std::cout << "Code was run.\n";
	return v;
}




