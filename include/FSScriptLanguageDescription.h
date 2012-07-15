//
//  FSScriptLanguageDescription.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FSScriptLanguageDescription : NSObject {
    
    NSString* _languageIdentifier;
    NSString* _languageVersion;
    NSString* _languageHumanReadableDescription;
    
    NSString* _flexConfigurationFile;
    NSString* _bisonConfigurationFile;
    
    
    
    int             (*_functionPointerTo_lex_init_extra)    (void*,void**);
    void* (*_functionPointerTo_scan_string)       (const char*, void*);
    void*   (*_functionPointerTo_get_extra)         (void*);
    int             (*_functionPointerTo_lex_destroy)       (void*);
    int             (*_functionPointerTo_parse)             (void*);
    
    NSStringEncoding _characterSetEncoding;
}

@property (readwrite,assign) NSStringEncoding characterSetEncoding;
@property (readwrite,retain) NSString* languageIdentifier;
@property (readwrite,retain) NSString* languageVersion;
@property (readwrite,retain) NSString* languageHumanReadableDescription;

@property (readwrite,retain) NSString* flexConfigurationFile;
@property (readwrite,retain) NSString* bisonConfigurationFile;

@property (readwrite,assign) int             (*functionPointerTo_lex_init_extra)  (void*,void**);
@property (readwrite,assign) void*          (*functionPointerTo_scan_string)     (const char * , void*);
@property (readwrite,assign) void*   (*functionPointerTo_get_extra)       (void*);
@property (readwrite,assign) int             (*functionPointerTo_lex_destroy)     (void*);
@property (readwrite,assign) int             (*functionPointerTo_parse)           (void*);


+(FSScriptLanguageDescription*) scriptLanguageWithIdentifier:(NSString*) identifier;


@end
