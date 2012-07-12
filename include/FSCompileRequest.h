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
}

@property (readwrite,retain) NSString* sourceCode;

+(FSCompileRequest*) getCompileRequestWithSourceCode:(NSString*) sourceCode;

@end
