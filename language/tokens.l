
%option header-file="tokens.hpp"  outfile="tokens.cpp" 

%option warn nodefault

%option 8bit
%option reentrant
%option bison-bridge
%option bison-locations
%option noyywrap
%option yylineno

%{
#include <string>
	#include "context.hpp"
	#include "node.h"
	#include "parser.hpp"
	#define SAVE_TOKEN yylval->string = new std::string(yytext, yyleng)
	#define TOKEN(t) (yylval->token = t)
#define YY_EXTRA_TYPE void*
%}

%%
"if"					return TOKEN(IF);
"iterate"				return TOKEN(ITERATE);
"until"					return TOKEN(UNTIL);
"."						return TOKEN(PERIOD);
"escapes"				return TOKEN(ESCAPES);


[ \t\n]					;
[a-zA-Z_][a-zA-Z0-9_]* 	SAVE_TOKEN; return TIDENTIFIER;
[0-9]+\.[0-9]* 			SAVE_TOKEN; return TDOUBLE;
[0-9]+					SAVE_TOKEN; return TINTEGER;

"="						return TOKEN(TEQUAL);
"=="					return TOKEN(TCEQ);
"!="					return TOKEN(TCNE);
"<"						return TOKEN(TCLT);
"<="					return TOKEN(TCLE);
">"						return TOKEN(TCGT);
">="					return TOKEN(TCGE);
"("						return TOKEN(TLPAREN);
")"						return TOKEN(TRPAREN);
"{"						return TOKEN(TLBRACE);
"}"						return TOKEN(TRBRACE);

","						return TOKEN(TCOMMA);
"+"						return TOKEN(TPLUS);
"-"						return TOKEN(TMINUS);
"*"						return TOKEN(TMUL);
"/"						return TOKEN(TDIV);

.						printf("Unknown token!\n"); yyterminate();

%%
