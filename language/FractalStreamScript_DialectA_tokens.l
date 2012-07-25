%option prefix="FractalStreamScript_DialectA_"
%option header-file="build/FractalStreamScript_DialectA_tokenizer.hpp"  outfile="build/FractalStreamScript_DialectA_tokenizer.cpp" 
%option warn nodefault
%option 8bit stack
%option reentrant
%option bison-bridge bison-locations
%option yylineno
%option noyywrap
%option never-interactive


%{
	#include <string>
	#include "FSExtraInformation.hpp"
    #include "FSParsingError.h"
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


  


%%

"if"					return TOKEN(TIF);
"do"                    return TOKEN(TDO);
"iterate"				return TOKEN(TITERATE);
"until"					return TOKEN(TUNTIL);
"while"					return TOKEN(TWHILE);
"."						return TOKEN(TPERIOD);
"escapes"				return TOKEN(TESCAPES);
"vanishes"				return TOKEN(TVANISHES);
"par"                   return TOKEN(TPAR);
"dyn"                   return TOKEN(TDYN);
"not"                   return TOKEN(TNOT);

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
"^"						return TOKEN(TEXP);
"!"						return TOKEN(TNOT);

[^ \t\n\*\+\^\=\!\-\<\>\(\)\{\}\,]+              {SAVE_TOKEN;printf("Unknown token: '%s' [%d,%d]->[%d,%d]\n",yylval->string->c_str(),yylloc->first_line, yylloc->first_column, yylloc->last_line, yylloc->last_column);FSParsingError error;  error.isFatal = 1;  error.firstLine = yylloc->first_line; error.firstColumn = yylloc->first_column; error.lastLine = yylloc->last_line;  error.lastColumn = yylloc->last_column; char fmt[] = "Unrecognized token: '%s'"; char* buffer = (char*)malloc(strlen(fmt)+strlen(yylval->string->c_str())+1); sprintf(buffer,fmt,  yylval->string->c_str()); error.errorMessage = buffer; error.errorType =  FSCompileErrorType_UnrecognizedToken;  error.errorSeverity = FSCompileErrorSeverity_Error; error.sourceCodeSubstring = strdup(yylval->string->c_str()); FSExtraInformation* extraInformationStructure = (FSExtraInformation*)( yyg->yyextra_r); extraInformationStructure->errors.push_back(error);return TOKEN(TUNRECOGNIZED); }


%%
