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
}

@property (readwrite,retain) NSString* sourceCode;
@property (readwrite,retain) NSString* languageIdentifier;
@property (readwrite,retain) NSString* languageVersion;

+(FSCompileRequest*) getCompileRequestWithSourceCode:(NSString*) sourceCode andLanguage:(NSString*) language;

@end
