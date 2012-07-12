//
//  FSScriptLanguageDialect.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSScriptLanguage.h"


@implementation FSScriptLanguage

+(NSArray*) allScriptLanguages {
    return [NSArray arrayWithObjects:
            [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             nil
             ],
            nil
            ];
            
    
}





static NSMutableDictionary* dictionaryByIdentifierOfDictionaryByVersionOfScripts = nil;
@synthesize languageIdentifier = _languageIdentifier;
@synthesize languageHumanReadableDescription = _languageHumanReadableDescription;
@synthesize functionPointerTo_lex_init_extra = _functionPointerTo_lex_init_extra;
@synthesize functionPointerTo_scan_string = _functionPointerTo_scan_string;
@synthesize functionPointerTo_get_extra = _functionPointerTo_get_extra;
@synthesize functionPointerTo_lex_destroy = _functionPointerTo_lex_destroy;
@synthesize functionPointerTo_parse = _functionPointerTo_parse;

-(id) initWithProperties:(NSDictionary*) properties {
    if  (self = [super init]) {
        self.languageIdentifier =          [properties objectForKey:@"languageIdentifier"];
        self.languageVersion          =          [properties objectForKey:@"languageVersion"];
        self.languageHumanReadableDescription =  [properties objectForKey:@"languageHumanReadableDescription"];
        self.functionPointerTo_lex_init_extra = [[properties objectForKey:@"lex_init_extra"] pointerValue];
        self.functionPointerTo_scan_string =    [[properties objectForKey:@"scan_string"] pointerValue];
        self.functionPointerTo_get_extra =      [[properties objectForKey:@"get_extra"] pointerValue];
        self.functionPointerTo_lex_destroy =    [[properties objectForKey:@"lex_destroy"] pointerValue];
        self.functionPointerTo_parse =          [[properties objectForKey:@"parse"] pointerValue];
        
    }
    return self;
}

+(void) addLanguageWithProperties:(NSDictionary*) properties {
    FSScriptLanguage* fssl = [[FSScriptLanguage alloc] initWithProperties:properties];
    NSString* identier  = fssl.languageIdentifier;
    NSString* version = fssl.languageVersion;
    NSMutableDictionary* dictionaryByVersionOfScripts = [dictionaryByIdentifierOfDictionaryByVersionOfScripts objectForKey:identier];
    if (dictionaryByVersionOfScripts == nil) {
        dictionaryByVersionOfScripts = [[NSMutableDictionary alloc] init];
        [dictionaryByIdentifierOfDictionaryByVersionOfScripts setObject:dictionaryByVersionOfScripts forKey:identier];
    }
    FSScriptLanguage* previouslySetLanguage = [dictionaryByVersionOfScripts objectForKey:version];
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



+(FSScriptLanguage*) scriptLanguage:(NSString*) identifier {
    NSMutableDictionary* dictionaryByVersionOfScripts = [dictionaryByIdentifierOfDictionaryByVersionOfScripts objectForKey:identier];
    if  (dictionaryByVersionOfScripts == nil) { return nil;}
    if  ([dictionaryByVersionOfScripts count] == 0) { return nil;}
    NSArray* allVersions = [dictionaryByVersionOfScripts allKeys];
    NSString* version = [allVersions objectAtIndex:[allVersions count]-1];
    return [dictionaryByVersionOfScripts objectForKey:version];
}

@end
