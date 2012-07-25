#ifndef FSNode
#define FSNode
#include <iostream>
#include <vector>
#include <llvm/Value.h>
#include <llvm/LLVMContext.h>
#include "FSCodeGenerationContext.h"

class CodeGenContext;
class NStatement;
class NExpression;
class NVariableDeclaration;
class NProgramPart;

typedef std::vector<NProgramPart*> ProgramPartList;
typedef std::vector<NStatement*> StatementList;
typedef std::vector<NExpression*> ExpressionList;
typedef std::vector<NVariableDeclaration*> VariableList;


class Node {
public:
	virtual ~Node() {}
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context) {return NULL; }
	
};

class NExpression : public Node {
};

class NStatement : public Node {
};

class NInteger : public NExpression {
public:
	long long value;
	NInteger(long long value) : value(value) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};

class NDouble : public NExpression {
public:
	double value;
	NDouble(double value) : value(value) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};

class NIdentifier : public NExpression {
public:
	std::string name;
	NIdentifier(const std::string& name) : name(name) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};

class NUnrecognized : public Node {
public:
	std::string name;
	NUnrecognized(const std::string& name) : name(name) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};

class NMethodCall : public NExpression {
public:
	const NIdentifier& id;
	ExpressionList arguments;
	NMethodCall(const NIdentifier& id, ExpressionList& arguments) :
		id(id), arguments(arguments) { }
	NMethodCall(const NIdentifier& id) : id(id) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};

class NBinaryOperator : public NExpression {
public:
	int op;
	NExpression& lhs;
	NExpression& rhs;
	NBinaryOperator(NExpression& lhs, int op, NExpression& rhs) :
		lhs(lhs), rhs(rhs), op(op) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};


class NUnaryOperator : public NExpression {
public:
	int op;
	
	NExpression& e;
	NUnaryOperator(int op, NExpression& e) :
    e(e), op(op) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context) {return NULL; };


};




class NAssignment : public NExpression {
public:
	NIdentifier& lhs;
	NExpression& rhs;
	NAssignment(NIdentifier& lhs, NExpression& rhs) : 
		lhs(lhs), rhs(rhs) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};



class NBlock : public NExpression {
public:
	StatementList statements;
	NBlock() { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};

class NProgramPart : public Node {
public:
	
	NProgramPart()  { }
    
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};


class NParameterBlock : public NProgramPart {
    
public:
    NBlock block;
    NParameterBlock(NBlock& a): NProgramPart() {block = a; };
	
};

class NDynamicBlock : public NProgramPart {
public:
    NBlock block;
	NDynamicBlock(NBlock& a) : NProgramPart() { block = a; };
};


class NUntilLoop : public NStatement {
public:
    NBlock block;
    NExpression expression;
    NUntilLoop(NBlock& a, NExpression& b) {block = a; expression = b;};
};



class NProgramParts : public NExpression {
public:
	ProgramPartList parts;
	NProgramParts() { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};

class NProgram : public NExpression {
public:
	NProgramParts parts;
	NProgram() { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};





class NExpressionStatement : public NStatement {
public:
	NExpression& expression;
	NExpressionStatement(NExpression& expression) : 
		expression(expression) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};

class NVariableDeclaration : public NStatement {
public:
	const NIdentifier& type;
	NIdentifier& id;
	NExpression *assignmentExpr;
	NVariableDeclaration(const NIdentifier& type, NIdentifier& id) :
		type(type), id(id) { }
	NVariableDeclaration(const NIdentifier& type, NIdentifier& id, NExpression *assignmentExpr) :
		type(type), id(id), assignmentExpr(assignmentExpr) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};

class NFunctionDeclaration : public NStatement {
public:
	const NIdentifier& type;
	const NIdentifier& id;
	VariableList arguments;
	NBlock& block;
	NFunctionDeclaration(const NIdentifier& type, const NIdentifier& id, 
			const VariableList& arguments, NBlock& block) :
		type(type), id(id), arguments(arguments), block(block) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
};


#endif