//
//  FSScriptLanguageDialect.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSScriptLanguageDescription.h"
//#include "FractalStreamScript_DialectA_parser.hpp"
//#include "FractalStreamScript_DialectA_tokenizer.hpp"



int FractalStreamScript_DialectA_lex_init_extra(void* yy_user_defined,void** ptr_yy_globals);
void* FractalStreamScript_DialectA__scan_string (const char * yystr , void* yyscanner);
int FractalStreamScript_DialectA_parse(void* scanner);
void* FractalStreamScript_DialectA_get_extra  (void* yyscanner);
int FractalStreamScript_DialectA_lex_destroy  (void* yyscanner);

@implementation FSScriptLanguageDescription

+(NSArray*) allScriptLanguages {
    return [NSArray arrayWithObjects:
            
            [NSDictionary dictionaryWithObjectsAndKeys:
             @"fsa",  @"languageIdentifier",
             @"1.0",                            @"languageVersion",
             @"FractalStream Script",           @"languageHumanReadableDescription",
             [NSNumber numberWithInt:NSASCIIStringEncoding],                                @"characterSetEncoding",
             [NSValue valueWithPointer:(void*)FractalStreamScript_DialectA_lex_init_extra], @"lex_init_extra",
             [NSValue valueWithPointer:(void*)FractalStreamScript_DialectA__scan_string],   @"scan_string", 
             [NSValue valueWithPointer:(void*)FractalStreamScript_DialectA_get_extra],      @"get_extra", 
             [NSValue valueWithPointer:(void*)FractalStreamScript_DialectA_lex_destroy],    @"lex_destroy", 
             [NSValue valueWithPointer:(void*)FractalStreamScript_DialectA_parse],          @"parse",
             
             nil
             ],
            
            
            nil
            ];
            
    
}





static NSMutableDictionary* dictionaryByIdentifierOfDictionaryByVersionOfScripts = nil;
@synthesize languageIdentifier = _languageIdentifier;
@synthesize languageHumanReadableDescription = _languageHumanReadableDescription;
@synthesize languageVersion  = _languageVersion;
@synthesize functionPointerTo_lex_init_extra = _functionPointerTo_lex_init_extra;
@synthesize functionPointerTo_scan_string = _functionPointerTo_scan_string;
@synthesize functionPointerTo_get_extra = _functionPointerTo_get_extra;
@synthesize functionPointerTo_lex_destroy = _functionPointerTo_lex_destroy;
@synthesize functionPointerTo_parse = _functionPointerTo_parse;
@synthesize flexConfigurationFile = _flexConfigurationFile;
@synthesize bisonConfigurationFile = _bisonConfigurationFile;
@synthesize characterSetEncoding = _characterSetEncoding;


-(id) initWithProperties:(NSDictionary*) properties {
    if  (self = [super init]) {
        self.languageIdentifier =          [properties objectForKey:@"languageIdentifier"];
        self.languageVersion          =          [properties objectForKey:@"languageVersion"];
        self.languageHumanReadableDescription =  [properties objectForKey:@"languageHumanReadableDescription"];
        self.functionPointerTo_lex_init_extra = (int (*) (void*,void**)) [[properties objectForKey:@"lex_init_extra"] pointerValue];
        self.functionPointerTo_scan_string =    (void* (*) (const char * , void*)) [[properties objectForKey:@"scan_string"] pointerValue];
        self.functionPointerTo_get_extra =      (void* (*) (void*)) [[properties objectForKey:@"get_extra"] pointerValue];
        self.functionPointerTo_lex_destroy =    (int   (*) (void*))[[properties objectForKey:@"lex_destroy"] pointerValue];
        self.functionPointerTo_parse =          (int (*) (void*)) [[properties objectForKey:@"parse"] pointerValue];
        self.characterSetEncoding =             [[properties objectForKey:@"characterSetEncoding"] intValue];
    }
    return self;
}

+(void) addLanguageWithProperties:(NSDictionary*) properties {
    FSScriptLanguageDescription* fssl = [[FSScriptLanguageDescription alloc] initWithProperties:properties];
    NSString* identier  = fssl.languageIdentifier;
    NSString* version = fssl.languageVersion;
    NSMutableDictionary* dictionaryByVersionOfScripts = [dictionaryByIdentifierOfDictionaryByVersionOfScripts objectForKey:identier];
    if (dictionaryByVersionOfScripts == nil) {
        dictionaryByVersionOfScripts = [[NSMutableDictionary alloc] init];
        [dictionaryByIdentifierOfDictionaryByVersionOfScripts setObject:dictionaryByVersionOfScripts forKey:identier];
    }
    FSScriptLanguageDescription* previouslySetLanguage = [dictionaryByVersionOfScripts objectForKey:version];
    if  (previouslySetLanguage != nil) {
        //! two languages with identifier and version collision
        return;
    }
    [dictionaryByVersionOfScripts setObject:fssl forKey:version];
    [fssl release];
}
                                         
                                         

+(void) initialize {
    dictionaryByIdentifierOfDictionaryByVersionOfScripts = [[NSMutableDictionary alloc] init];
    NSArray* allScriptLanguages = [self allScriptLanguages];
    for (NSDictionary* d in allScriptLanguages) {
        [self addLanguageWithProperties:d];
    }
}



+(FSScriptLanguageDescription*) scriptLanguageWithIdentifier:(NSString*) identifier {
    NSMutableDictionary* dictionaryByVersionOfScripts = [dictionaryByIdentifierOfDictionaryByVersionOfScripts objectForKey:identifier];
    if  (dictionaryByVersionOfScripts == nil) { return nil;}
    if  ([dictionaryByVersionOfScripts count] == 0) { return nil;}
    NSArray* allVersions = [dictionaryByVersionOfScripts allKeys];
    NSString* version = [allVersions objectAtIndex:[allVersions count]-1];
    return [dictionaryByVersionOfScripts objectForKey:version];
}

@end
