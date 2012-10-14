#ifndef FSNode
#define FSNode
#include <iostream>
#include <vector>
#include <list>
#include <llvm/Value.h>
#include <llvm/LLVMContext.h>
#include "FSCodeGenerationContext.h"
#include "FSCompilerUtility.h"
class CodeGenContext;
class NStatement;
class NExpression;
class NVariableDeclaration;
class NProgramPart;

typedef std::vector<NProgramPart*> ProgramPartList;
typedef std::list<NStatement*> StatementList;
typedef std::vector<NExpression*> ExpressionList;
typedef std::vector<NVariableDeclaration*> VariableList;


class Node {
public:
	virtual ~Node() {}
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context) {return NULL; }
    virtual std::string stringOfThisNode() {
        return "undef";
    };
    virtual std::vector<Node*> children() {std::vector<Node*> x;  return x;};
    const virtual const std::string description() {
        return description(0);
    }
    const virtual const std::string description(int i) {
        std::vector<Node*> children = this->children();
        std::string thisNodeString = this->stringOfThisNode();
        int indexOfSubNodes =(int)( i + thisNodeString.length()+3);
        
        std::string childrenStr = "";
        bool first =true;
        for (std::vector<Node*>::iterator it = children.begin(); it != children.end() ; ++it) {
            if (!first) {
                childrenStr += "\n"+spaces(indexOfSubNodes);
            } else {
                first = false;
            }
            childrenStr += (*it)->description(indexOfSubNodes);
        }
        if (first) {
            return thisNodeString;
        } else {
            return "("+thisNodeString+": "+ childrenStr +")";
        }
    }
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
    virtual std::string stringOfThisNode() {return longToString(value);};
};

class NDouble : public NExpression {
public:
	double value;
	NDouble(double value) : value(value) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return doubleToString(value);};
    
    
};

class NIdentifier : public NExpression {
public:
	std::string name;
	NIdentifier(const std::string& name) : name(name) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return name;};
};

class NUnrecognized : public Node {
public:
	std::string name;
	NUnrecognized(const std::string& name) : name(name) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "undef:"+name;};
    
};

class NMethodCall : public NExpression {
public:
	NIdentifier& id;
	ExpressionList arguments;
	NMethodCall(NIdentifier& id, ExpressionList& arguments) :
		id(id), arguments(arguments) { }
	NMethodCall(NIdentifier& id) : id(id) { }
    llvm::Value* codeGen(FSCodeGenerationContext& context);
	virtual std::string stringOfThisNode() {return "function";};
    virtual std::vector<Node*> children() {
        std::vector<Node*> x; 
        x.push_back(&id);  
        for (ExpressionList::iterator it = arguments.begin(); it != arguments.end(); ++it) {
            x.push_back(*it);
        }
        return x;
    };
    
};

class NBinaryOperator : public NExpression {
public:
	int op;
	NExpression& lhs;
	NExpression& rhs;
	NBinaryOperator(NExpression& lhs, int op, NExpression& rhs) :
		lhs(lhs), rhs(rhs), op(op) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "operator-"+intToString(op);};
    virtual std::vector<Node*> children() {std::vector<Node*> x;  x.push_back(&lhs); x.push_back(&rhs); return x;};
    
};


class NUnaryOperator : public NExpression {
public:
	int op;
	
	NExpression& e;
	NUnaryOperator(int op, NExpression& e) :
    e(e), op(op) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context) {return NULL; };
    virtual std::string stringOfThisNode() {return "operator-"+intToString(op);};
    virtual std::vector<Node*> children() {std::vector<Node*> x;  x.push_back(&e); return x;};
    

};




class NAssignment : public NExpression {
public:
	NIdentifier& lhs;
	NExpression& rhs;
	NAssignment(NIdentifier& lhs, NExpression& rhs) : 
		lhs(lhs), rhs(rhs) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "assign";};
    virtual std::vector<Node*> children() {std::vector<Node*> x;  x.push_back(&lhs); x.push_back(&rhs); return x;};
    
};



class NBlock : public NExpression {
public:
	StatementList statements;
	NBlock() { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "block";};
    virtual std::vector<Node*> children() {
        std::vector<Node*> x;
        for (StatementList::iterator it = statements.begin(); it != statements.end(); ++it) {
            x.push_back(*it);
        }
        return x;
    };
    
};

class NProgramPart : public Node {
public:
	
	NProgramPart()  { }
    
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "ProgramPart";};
    virtual std::vector<Node*> children() {std::vector<Node*> x;  return x;};
    
};


class NParameterBlock : public NProgramPart {
    
public:
    NBlock block;
    NParameterBlock(NBlock& a): NProgramPart() {block = a; };
	virtual std::string stringOfThisNode() {return "paramBlock";};
    virtual std::vector<Node*> children() {std::vector<Node*> x;  x.push_back(&block); return x;};
    
};

class NDynamicBlock : public NProgramPart {
public:
    NBlock block;
	NDynamicBlock(NBlock& a) : NProgramPart() { block = a; };
    virtual std::string stringOfThisNode() {return "dynamBlock";};
    virtual std::vector<Node*> children() {
        std::vector<Node*> x;  
        x.push_back(&block); 
        return x;
    };
    
};


class NUntilLoop : public NStatement {
public:
    NBlock block;
    NExpression expression;
    NUntilLoop(NBlock& a, NExpression& b) {
        block = a; 
        expression = b;
    };
    virtual std::string stringOfThisNode() {
        return "until";
    };
    virtual std::vector<Node*> children() {
        std::vector<Node*> x;
        x.push_back(&block); 
        x.push_back(&expression); 
        return x;
    };
    
};

class NIterateUntilLoop : public NStatement {
public:
    NBlock block;
    NExpression expression;
    NIterateUntilLoop(NBlock& a, NExpression& b) {
        block = a;
        expression = b;
    };
    virtual std::string stringOfThisNode() {
        return "iterate_until";
    };
    virtual std::vector<Node*> children() {
        std::vector<Node*> x;
        x.push_back(&block);
        x.push_back(&expression);
        return x;
    };
    
};



class NProgramParts : public NExpression {
public:
	ProgramPartList parts;
	NProgramParts() { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "progparts";};
    virtual std::vector<Node*> children() {
        std::vector<Node*> x;
        for (ProgramPartList::iterator it = parts.begin(); it != parts.end(); ++it) {
            x.push_back(*it);
        }
        return x;
    };
    
};

class NProgram : public NExpression {
public:
	NProgramParts parts;
	NProgram() { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "program";};
    virtual std::vector<Node*> children() {
        std::vector<Node*> x;
        x.push_back(&parts);
        return x;
    };
};


class NEscapesStatement : public NStatement {
public:
	NExpression& expression;
	NEscapesStatement(NExpression& expression) :
        expression(expression) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "escapes";};
    virtual std::vector<Node*> children() {std::vector<Node*> x; x.push_back(&expression);  return x;};
    
};


class NExpressionStatement : public NStatement {
public:
	NExpression& expression;
	NExpressionStatement(NExpression& expression) : 
		expression(expression) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "exprstmt";};
    virtual std::vector<Node*> children() {std::vector<Node*> x; x.push_back(&expression);  return x;};
    
};

class NVariableDeclaration : public NStatement {
public:
	NIdentifier& type;
	NIdentifier& id;
	NExpression *assignmentExpr;
	NVariableDeclaration(NIdentifier& type, NIdentifier& id) :
		type(type), id(id) { }
	NVariableDeclaration(NIdentifier& type, NIdentifier& id, NExpression *assignmentExpr) :
		type(type), id(id), assignmentExpr(assignmentExpr) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "vardef";};
    virtual std::vector<Node*> children() {std::vector<Node*> x; x.push_back(&type); x.push_back(&id); x.push_back(assignmentExpr); return x;};
    
};

class NFunctionDeclaration : public NStatement {
public:
	NIdentifier& type;
	NIdentifier& id;
	VariableList arguments;
	NBlock& block;
	NFunctionDeclaration(NIdentifier& type, NIdentifier& id, 
			 VariableList& arguments, NBlock& block) :
		type(type), id(id), arguments(arguments), block(block) { }
	virtual llvm::Value* codeGen(FSCodeGenerationContext& context);
    virtual std::string stringOfThisNode() {return "funcdef";};
    virtual std::vector<Node*> children() {
        std::vector<Node*> x; 
        x.push_back(&id); 
        x.push_back(&type); 
        for (VariableList::iterator it = arguments.begin() ; it != arguments.end(); ++it) {
            x.push_back(*it);
        }
        return x;
    };
    
};


#endif