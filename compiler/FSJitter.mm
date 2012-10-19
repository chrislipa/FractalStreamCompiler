//
//  FSJitter.mm
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 10/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSJitter.h"

#include "llvm/Module.h"
#include "llvm/LLVMContext.h"
#include "llvm/ExecutionEngine/JIT.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/Support/TargetSelect.h"

using namespace llvm;

@implementation FSJitter

static FSJitter* sharedJitter = nil;

+ (FSJitter*) jitter {
	if(sharedJitter == nil) {
        @synchronized(self) {
            if(sharedJitter == nil) {
                sharedJitter = [[FSJitter alloc] init];
                [sharedJitter startup];
                [[NSNotificationCenter defaultCenter]
                 addObserver: sharedJitter selector: @selector(remover:)
                 name: NSApplicationWillTerminateNotification object: NSApp
                 ];
            }
        }
	}
	return sharedJitter;
}

- (void) remover : (NSNotification*) note {
	if(sharedJitter) {
        @synchronized(self) {
            if(sharedJitter) {
                [[NSNotificationCenter defaultCenter] removeObserver: sharedJitter];
                [sharedJitter release];
                sharedJitter = nil;
            }
        }
	}
}

- (void) startup {
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();
    
	/* Build the module provider and execution engine that every document will use */
    llvm::LLVMContext* llvmContext = new llvm::LLVMContext();
	llvm::Module* rootModule = new llvm::Module("root module",*llvmContext);
	ExecutionEngine* engine = ExecutionEngine::create(rootModule);
	eng = (void*) engine;
}


- (void) addModule: (llvm::Module*) mod {
	ExecutionEngine* engine = (ExecutionEngine*) eng;
	@synchronized(self) {
        engine -> addModule(mod);
		
	}
}

- (bool) removeModule: (llvm::Module*) mod {
	ExecutionEngine* engine = (ExecutionEngine*) eng;
	bool r;
	@synchronized(self) {
		r = engine -> removeModule( mod);
	}
	return r;
}

- (void*) getPointerToFunction: (void*) f {
	ExecutionEngine* engine = (ExecutionEngine*) eng;
	void* r;
	@synchronized(self) {
		r = engine -> getPointerToFunction((Function*) f);
	}
	return r;
}

- (void*) targetData { 
	ExecutionEngine* engine = (ExecutionEngine*) eng;
	return (void*) engine -> getTargetData();
}

- (void*) engine { return eng; }

@end
