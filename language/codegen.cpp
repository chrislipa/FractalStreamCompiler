#include <iostream>

#include "node.hpp"
#include "codegen.h"
#include "parser.hpp"
//#include "llvm/DerivedTypes.h"
//#include "llvm/Instructions.h"
using namespace std;

/* Compile the AST into a module */
void CodeGenContext::generateCode(NBlock& root)
{
	return;
	/*
	//std::cout << "Generating code...\n";
	
	// Create the top level interpreter function to call as entry 
	ArrayRef<Type*> argTypes;

	
	
	
	
	FunctionType *ftype = FunctionType::get(Type::getVoidTy(getGlobalContext()), argTypes, false);
	mainFunction = Function::Create(ftype, GlobalValue::InternalLinkage, "main", module);
	BasicBlock *bblock = BasicBlock::Create(getGlobalContext(), "entry", mainFunction, 0);
	
	// Push a new variable/block context 
	pushBlock(bblock);
	root.codeGen(*this); // emit bytecode for the toplevel block 
	ReturnInst::Create(getGlobalContext(), bblock);
	popBlock();
	
	// to see if our program compiled properly
	 
	std::cout << "Code is generated.\n";
	PassManager pm;
	pm.add(createPrintModulePass(&outs()));
	pm.run(*module);*/
}

/* Executes the AST by running the main function */
GenericValue CodeGenContext::runCode() {
	std::cout << "Running code...\n";

	
	//ExecutionEngine *ee = EngineBuilder(module).create();
	//vector<GenericValue> noargs;
	GenericValue v ;//= ee->runFunction(mainFunction, noargs);
	//std::cout << "Code was run.\n";
	return v;
}

/* Returns an LLVM type based on the identifier */
static Type *typeOf(const NIdentifier& type) 
{
	if (type.name.compare("int") == 0) {
		return  NULL;//Type::getInt64Ty(getGlobalContext());
	}
	else if (type.name.compare("double") == 0) {
		return  NULL;//Type::getDoubleTy(getGlobalContext());
	}
	return  NULL;//Type::getVoidTy(getGlobalContext());
}

/* -- Code Generation -- */

Value* NInteger::codeGen(/*CodeGenContext& context*/ void* x)
{
	std::cout << "Creating integer: " << value << endl;
	return  NULL;//ConstantInt::get(Type::getInt64Ty(getGlobalContext()), value, true);
}

Value*   NDouble::codeGen(CodeGenContext& context)
{
	//std::cout << "Creating double: " << value << endl;
	return  NULL;//ConstantFP::get(Type::getDoubleTy(getGlobalContext()), value);
}

Value* NIdentifier::codeGen(CodeGenContext& context)
{
	std::cout << "Creating identifier reference: " << name << endl;
	if (context.locals().find(name) == context.locals().end()) {
		std::cerr << "undeclared variable " << name << endl;
		return NULL;
	}
	return  NULL;//new LoadInst(context.locals()[name], "", false, context.currentBlock());
}

Value* NMethodCall::codeGen(CodeGenContext& context)
{
	return NULL;
	/*
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
	return call;*/
}

Value* NBinaryOperator::codeGen(CodeGenContext& context)
{
	return NULL;
	/*
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
	return NULL;//BinaryOperator::Create(instr, lhs.codeGen(context), 
		//rhs.codeGen(context), "", context.currentBlock());
*/
}

Value* NAssignment::codeGen(CodeGenContext& context)
{
	return NULL;
	/*
	std::cout << "Creating assignment for " << lhs.name << endl;
	if (context.locals().find(lhs.name) == context.locals().end()) {
		std::cerr << "undeclared variable " << lhs.name << endl;
		return NULL;
	}
	
	return NULL;//new StoreInst((Value*)rhs.codeGen(context), (Value*)context.locals()[lhs.name], false,(BasicBlock *) context.currentBlock());
	 */
}

Value* NBlock::codeGen(CodeGenContext& context)
{
	return NULL;
	/*
	StatementList::const_iterator it;
	Value *last = NULL;
	for (it = statements.begin(); it != statements.end(); it++) {
		std::cout << "Generating code for " << typeid(**it).name() << endl;
		last = (**it).codeGen(context);
	}
	std::cout << "Creating block" << endl;
	return last;*/
}

Value* NExpressionStatement::codeGen(CodeGenContext& context)
{
	std::cout << "Generating code for " <</* typeid(expression).name() << */endl;
	return NULL;//expression.codeGen(context);
}

Value* NVariableDeclaration::codeGen(CodeGenContext& context)
{
	return NULL;/*
	std::cout << "Creating variable declaration " << type.name << " " << id.name << endl;
	Type *t = typeOf(type);

	AllocaInst *alloc =  NULL;//new AllocaInst(t, id.name.c_str(), context.currentBlock());
	context.locals()[id.name] = alloc;
	if (assignmentExpr != NULL) {
		NAssignment assn(id, *assignmentExpr);
		assn.codeGen(context);
	}
	return alloc;*/
}

Value* NFunctionDeclaration::codeGen(CodeGenContext& context)
{
	return NULL;/*
	vector<const Type*> argTypes;
	VariableList::const_iterator it;
	for (it = arguments.begin(); it != arguments.end(); it++) {
		argTypes.push_back(typeOf((**it).type));
	}
	ArrayRef<Type*> arg;
	FunctionType *ftype = FunctionType::get(typeOf(type), arg, false);
	Function *function = Function::Create(ftype, GlobalValue::InternalLinkage, id.name.c_str(), context.module);
	BasicBlock *bblock = BasicBlock::Create(getGlobalContext(), "entry", function, 0);

	context.pushBlock(bblock);

	for (it = arguments.begin(); it != arguments.end(); it++) {
		(**it).codeGen(context);
	}
	
	block.codeGen(context);
	ReturnInst::Create(getGlobalContext(), bblock);

	context.popBlock();
	std::cout << "Creating function: " << id.name << endl;
	return function;*/
}
