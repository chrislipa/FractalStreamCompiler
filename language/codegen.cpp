#include <iostream>

#include "node.h"
#include "codegen.h"
#include "parser.hpp"
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



/* Returns an LLVM type based on the identifier */
static Type *typeOf(const NIdentifier& type) 
{
	if (type.name.compare("int") == 0) {
		return  Type::getInt64Ty(getGlobalContext());
	}
	else if (type.name.compare("double") == 0) {
		return  Type::getDoubleTy(getGlobalContext());
	}
	return  Type::getVoidTy(getGlobalContext());
}

/* -- Code Generation -- */

Value* NInteger::codeGen(FSCodeGenerationContext& context)
{
	std::cout << "Creating integer: " << value << endl;
	return ConstantInt::get(Type::getInt64Ty(*context.llvmContext), value, true);
}

Value*   NDouble::codeGen(FSCodeGenerationContext& context)
{
	std::cout << "Creating double: " << value << endl;

	return ConstantFP::get(Type::getDoubleTy(*context.llvmContext), value);
}

Value* NIdentifier::codeGen(FSCodeGenerationContext& context)
{
	std::cout << "Creating identifier reference: " << name << endl;
	if (context.codeGenContext->locals().find(name) == context.codeGenContext->locals().end()) {
		std::cerr << "undeclared variable " << name << endl;
		return NULL;
	}
	return  NULL;//new LoadInst(context.locals()[name], "", false, context.currentBlock());
}

Value* NMethodCall::codeGen(FSCodeGenerationContext& context)
{
	return NULL;
	
	Function *function = context.module->getFunction(id.name.c_str());
	if (function == NULL) {
		std::cerr << "no such function " << id.name << endl;
	}
	std::vector<Value*> args;

	ExpressionList::const_iterator it;
	for (it = arguments.begin(); it != arguments.end(); it++) {
		args.push_back((**it).codeGen(context));
	}
	MutableArrayRef<Value*> ref = MutableArrayRef<Value*>::MutableArrayRef<Value*>(args);
	
	CallInst *call =  NULL;//CallInst::Create(function, ref, "", context.currentBlock());
	std::cout << "Creating method call: " << id.name << endl;
	return call;
}

Value* NBinaryOperator::codeGen(FSCodeGenerationContext& context)
{
	
	
	std::cout << "Creating binary operation " << op << endl;
	Instruction::BinaryOps instr;
	switch (op) {
		case TPLUS: 	instr = Instruction::Add; goto math;
		case TMINUS: 	instr = Instruction::Sub; goto math;
		case TMUL: 		instr = Instruction::Mul; goto math;
		case TDIV: 		instr = Instruction::SDiv; goto math;
				
		// TODO comparison 
	}

	return NULL;
math:
	return BinaryOperator::Create(instr, lhs.codeGen(context), 
	rhs.codeGen(context), "", context.codeGenContext->currentBlock());

}

Value* NAssignment::codeGen(FSCodeGenerationContext& context)
{
	return NULL;
	
	std::cout << "Creating assignment for " << lhs.name << endl;
	if (context.codeGenContext->locals().find(lhs.name) == context.codeGenContext->locals().end()) {
		std::cerr << "undeclared variable " << lhs.name << endl;
		return NULL;
	}
	
	return new StoreInst((Value*)rhs.codeGen(context), (Value*)context.codeGenContext->locals()[lhs.name], false,(BasicBlock *) context.codeGenContext->currentBlock());
	 
}

Value* NBlock::codeGen(FSCodeGenerationContext& context)
{
	
	
	StatementList::const_iterator it;
	Value *last = NULL;
	for (it = statements.begin(); it != statements.end(); it++) {
		std::cout << "Generating code for " << typeid(**it).name() << endl;
		last = (**it).codeGen(context);
	}
	std::cout << "Creating block" << endl;
	return last;
}

Value* NProgramPart::codeGen(FSCodeGenerationContext& context)
{
	return expression.codeGen(context);
}

Value* NProgramParts::codeGen(FSCodeGenerationContext& context)
{
	ProgramPartList::const_iterator it;
	Value *last = NULL;
	//BasicBlock *bblock = BasicBlock::Create(*context.llvmContext);
	//context.builder->SetInsertPoint(bblock);
    //context.codeGenContext->pushBlock(bblock);
	for (it = parts.begin(); it != parts.end(); it++) {
        std::cout << "Generating code for " << typeid(**it).name() << endl;
        last = (**it).codeGen(context);
    }
    //ReturnInst::Create(*context.llvmContext, bblock);
	//context.codeGenContext->popBlock();
	//std::cout << "Creating block" << endl;
    return last;
}

Value* NProgram::codeGen(FSCodeGenerationContext& context)
{
	
	NProgramParts* programParts = &this->parts;
	
	ProgramPartList::const_iterator it;
	Value *last = NULL;
	BasicBlock *bblock = BasicBlock::Create(*context.llvmContext, NULL, 0, 0);
	
    
    context.builder->SetInsertPoint(bblock);
    
    
	context.codeGenContext->pushBlock(bblock);
	
	for (it = programParts->parts.begin(); it != programParts->parts.end(); it++) {
		
		std::cout << "Generating code for " << typeid(**it).name() << endl;
		last = (**it).codeGen(context);
	}
	
	
	
	ReturnInst::Create(*context.llvmContext, bblock);
	
	context.codeGenContext->popBlock();
	std::cout << "Creating block" << endl;
	return last;
}

Value* NExpressionStatement::codeGen(FSCodeGenerationContext& context)
{
	std::cout << "Generating code for " <</* typeid(expression).name() << */endl;
	return expression.codeGen(context);
}

Value* NVariableDeclaration::codeGen(FSCodeGenerationContext& context)
{

	std::cout << "Creating variable declaration " << type.name << " " << id.name << endl;
	//Type *t = typeOf(type);

	AllocaInst *alloc =  NULL;//new AllocaInst(t, id.name.c_str(), context.currentBlock());
	context.codeGenContext->locals()[id.name] = alloc;
	if (assignmentExpr != NULL) {
		NAssignment assn(id, *assignmentExpr);
		assn.codeGen(context);
	}
	return alloc;
}

Value* NFakeToHoldLineNumber::codeGen(FSCodeGenerationContext& context)
{
	return NULL;
}

Value* NFunctionDeclaration::codeGen(FSCodeGenerationContext& context)
{

	vector<const Type*> argTypes;
	VariableList::const_iterator it;
	for (it = arguments.begin(); it != arguments.end(); it++) {
		argTypes.push_back(typeOf((**it).type));
	}
    
	ArrayRef<Type*> arg;
    
	FunctionType *ftype = FunctionType::get(typeOf(type), arg, false);
    
	Function *function = Function::Create(ftype, GlobalValue::InternalLinkage, id.name.c_str(), context.module);
	BasicBlock *bblock = BasicBlock::Create(getGlobalContext(), "entry", function, 0);

	context.codeGenContext->pushBlock(bblock);

	for (it = arguments.begin(); it != arguments.end(); it++) {
		(**it).codeGen(context);
	}
	
	block.codeGen(context);
	ReturnInst::Create(getGlobalContext(), bblock);

	context.codeGenContext->popBlock();
	std::cout << "Creating function: " << id.name << endl;
	return function;
}
