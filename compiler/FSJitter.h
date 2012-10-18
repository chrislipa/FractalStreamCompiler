//
//  FSJitter.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "llvm/Module.h"

@interface FSJitter : NSObject {
	void* eng;
}

+ (FSJitter*) jitter;
- (void) remover: (NSNotification*) note;
- (void) startup;
- (void*) getPointerToFunction: (void*) f;
- (void) addModule: (llvm::Module*) mod;
- (bool) removeModule: (llvm::Module*) mod;
- (void*) engine;
- (void*) targetData;

@end
