//
//  FSScriptLanguage.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "FractalStreamScript_DialectA_parser.hpp"
#include "FractalStreamScript_DialectA_tokenizer.hpp"

@interface FSScriptLanguage : NSObject {
    
    NSString* _languageIdentifier;
    NSString* _languageVersion;
    NSString* _languageHumanReadableDescription;
    
    NSString* _flexConfigurationFile;
    NSString* _bisonConfigurationFile;
    
    
    
    int             (*_functionPointerTo_lex_init_extra)    (YY_EXTRA_TYPE,yyscan_t*);
    YY_BUFFER_STATE (*_functionPointerTo_scan_string)       (yyconst char*, yyscan_t);
    YY_EXTRA_TYPE   (*_functionPointerTo_get_extra)         (yyscan_t);
    int             (*_functionPointerTo_lex_destroy)       (yyscan_t);
    int             (*_functionPointerTo_parse)             (void*);
}


@property (readwrite,retain) NSString* languageIdentifier;
@property (readwrite,retain) NSString* languageVersion;
@property (readwrite,retain) NSString* languageHumanReadableDescription;

@property (readwrite,retain) NSString* flexConfigurationFile;
@property (readwrite,retain) NSString* bisonConfigurationFile;

@property (readwrite,assign) int             (*functionPointerTo_lex_init_extra)  (YY_EXTRA_TYPE,yyscan_t*);
@property (readwrite,assign) YY_BUFFER_STATE (*functionPointerTo_scan_string)     (yyconst char * , yyscan_t);
@property (readwrite,assign) YY_EXTRA_TYPE   (*functionPointerTo_get_extra)       (yyscan_t);
@property (readwrite,assign) int             (*functionPointerTo_lex_destroy)     (yyscan_t);
@property (readwrite,assign) int             (*functionPointerTo_parse)           (void*);


+(FSScriptLanguage*) scriptLanguageWithIdentifier:(NSString*) identifier;


@end
