%pure-parser
%lex-param {void * context}
%parse-param { void* context }


%{
	#include "node.h"
	#include "parser.hpp"
	#include <cstdio>
	#include <cstdlib>
	#include "context.hpp"
	#include "tokens.h"
	NExpression *programBlock; /* the top level root node of our final AST */
	
	typedef void* yyscan_t; 
	extern int yylex (YYSTYPE * yylval_param ,YYLTYPE * yylloc_param , yyscan_t yyscanner);
	void yyerror(YYLTYPE*  yylval_param, yyscan_t yyscanner,  const char *s) { std::printf("Error: %s\n", s);std::exit(1); }
%}

/* Represents the many different ways we can access our data */
%union {
	NProgram *program;
	NProgramPart *programPart;
	NProgramParts* programParts;
	Node *node;
	NBlock *block;
	NExpression *expr;
	NStatement *stmt;
	NIdentifier *ident;
	NVariableDeclaration *var_decl;
	std::vector<NVariableDeclaration*> *varvec;
	std::vector<NExpression*> *exprvec;
	std::string *string;
	int token;
	NProgramPart* program_part;
	NFakeToHoldLineNumber* fakeToHoldLineNumber;
}

/* Define our terminal symbols (tokens). This should
   match our tokens.l lex file. We also define the node type
   they represent.
 */
%token <string> TIDENTIFIER TINTEGER TDOUBLE
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TEQUAL
%token <token> TLPAREN TRPAREN TLBRACE TRBRACE TCOMMA TDOT
%token <token> TPLUS TMINUS TMUL TDIV
%token <token> IF ITERATE UNTIL PERIOD ESCAPES

 
/* Define the type of node our nonterminal symbols represent.
   The types refer to the %union declaration above. Ex: when
   we call an ident (defined by union type ident) we are really
   calling an (NIdentifier*). It makes the compiler happy.
 */
%type <ident> ident
%type <expr> numeric expr 
%type <varvec> func_decl_args
%type <exprvec> call_args
%type <block> stmts block
%type <stmt> stmt var_decl func_decl
%type <token> comparison

%type <programPart> program_part
%type <programParts> program_parts


%type <fakeToHoldLineNumber> fakeToHoldLineNumber
/* Operator precedence for mathematical operators */
%left TPLUS TMINUS
%left TMUL TDIV

%start program

%%
program : program_parts { YYContext* extraInformationStructure = (YYContext*)( yyget_extra(context));
	extraInformationStructure->result = $1;
}


program_parts : program_part { $$ = new NProgramParts(); $$->parts.push_back($<program_part>1); }
			  | program_parts program_part {$1->parts.push_back($<program_part>2); }
              ;

program_part : stmts {$$ = new NProgramPart(*$1);}
             ;

numeric : TINTEGER { $$ = new NInteger(atol($1->c_str())); delete $1; }
		| TDOUBLE { $$ = new NDouble(atof($1->c_str())); delete $1; }
	    ;


		
stmts : stmt { $$ = new NBlock(); $$->statements.push_back($<stmt>1); }
	  | stmts stmt { $1->statements.push_back($<stmt>2); }
	  ;

stmt : var_decl | func_decl
	 | expr { $$ = new NExpressionStatement(*$1); }
     ;

block : TLBRACE stmts TRBRACE { $$ = $2; }
	  | TLBRACE TRBRACE { $$ = new NBlock(); }
	  ;

var_decl : ident ident { $$ = new NVariableDeclaration(*$1, *$2); }
		 | ident ident TEQUAL expr { $$ = new NVariableDeclaration(*$1, *$2, $4); }
		 ;
		
func_decl : ident ident TLPAREN func_decl_args TRPAREN block 
			{ $$ = new NFunctionDeclaration(*$1, *$2, *$4, *$6); delete $4; }
		  ;
	
func_decl_args : /*blank*/  { $$ = new VariableList(); }
		  | var_decl { $$ = new VariableList(); $$->push_back($<var_decl>1); }
		  | func_decl_args TCOMMA var_decl { $1->push_back($<var_decl>3); }
		  ;

ident : TIDENTIFIER { $$ = new NIdentifier(*$1); delete $1; }
	  ;


	
expr : ident TEQUAL expr { $$ = new NAssignment(*$<ident>1, *$3); }
	 | ident TLPAREN call_args TRPAREN { $$ = new NMethodCall(*$1, *$3); delete $3; }
	 | ident { $<ident>$ = $1; }
	 | numeric { $$ = $1; } 
 	 | expr comparison expr { $$ = new NBinaryOperator(*$1, $2, *$3); }
     | TLPAREN expr TRPAREN { $$ = $2; }
	 ;
	
call_args : /*blank*/  { $$ = new ExpressionList(); }
		  | expr { $$ = new ExpressionList(); $$->push_back($1); }
		  | call_args TCOMMA expr  { $1->push_back($3); }
		  ;

comparison : TCEQ | TCNE | TCLT | TCLE | TCGT | TCGE 
		   | TPLUS | TMINUS | TMUL | TDIV
		   ;


/* This rule (fakeToHoldLineNumber) is unused.  It's present
   because of (IMO) buggy behavior on the part of Bison that
   the functions generated change their signature depending
   on whether the line number symbol (@$) is present in the 
   rule set.  In order to more easily facilitate debugging
   and experimentation, the symbol is always represented 
   here so that no other files need to be altered when
   modifying other rules.*/
fakeToHoldLineNumber : { $$ = new FakeToHoldLineNumber(@$); }

%%
