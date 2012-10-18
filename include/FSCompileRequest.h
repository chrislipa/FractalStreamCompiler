//
//  FSCompileRequest.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FSCompileRequest : NSObject {
    NSString* _sourceCode;
    NSString* _languageIdentifier;
    NSString* _languageVersion;
    
    int _maximumLoopDepth;
    int _numberOfVariables;

}

@property (readwrite,retain) NSString* sourceCode;
@property (readwrite,retain) NSString* languageIdentifier;
@property (readwrite,retain) NSString* languageVersion;

@property (readwrite,assign) int maximumLoopDepth;
@property (readwrite,assign) int numberOfVariables;


+(FSCompileRequest*) getCompileRequestWithSourceCode:(NSString*) sourceCode andLanguage:(NSString*) language;

@end
