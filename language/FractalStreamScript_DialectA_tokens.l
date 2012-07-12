%option prefix="FractalStreamScript_DialectA_"
%option header-file="build/FractalStreamScript_DialectA_tokenizer.hpp"  outfile="build/FractalStreamScript_DialectA_tokenizer.cpp" 
%option warn nodefault
%option 8bit stack
%option reentrant
%option bison-bridge bison-locations
%option noyywrap yylineno
%option never-interactive


%{
	#include <string>
	#include "FSExtraInformation.hpp"
	#include "node.h"
	#include "FractalStreamScript_DialectA_parser.hpp"
	#define SAVE_TOKEN yylval->string = new std::string(yytext, yyleng)
	#define TOKEN(t) (yylval->token = t)
	#define YY_EXTRA_TYPE void*
    
    /* handle locations */
    //int yycolumn = 1;
    
    #define YY_USER_ACTION yylloc->first_line = yylloc->last_line = yylineno;\
                            yylloc->first_column = yycolumn; \
                            yylloc->last_column = yycolumn+yyleng-1; yycolumn += yyleng;    
    
    
    
%}
/*[^ \t\n*]+   printf("Unknown token!  Attemptin to recover (%d,%d) - (%d,%d)\n",yylloc->first_line, yylloc->first_column, yylloc->last_line, yylloc->last_column); SAVE_TOKEN; return TUNRECOGNIZED;*/

  


%%
.+ 	SAVE_TOKEN; return TIDENTIFIER;
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




%%
