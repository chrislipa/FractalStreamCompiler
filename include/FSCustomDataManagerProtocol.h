//
//  FSCustomDataManagerProtocol.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 10/26/12.
//
//

#ifndef FractalStreamCompiler_FSCustomDataManagerProtocol_h
#define FractalStreamCompiler_FSCustomDataManagerProtocol_h

#import "FSTool.h"

@protocol FSTool;

@protocol FSCustomDataManagerProtocol <NSObject>
- (void) addDataNamed: (NSString*) name usingObject: (NSObject<FSTool>*) ob;
@end


#endif
