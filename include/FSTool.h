//
//  FSTool.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 10/27/12.
//
//

#ifndef FractalStreamCompiler_FSTool_h
#define FractalStreamCompiler_FSTool_h

#import "FSCustomDataManagerProtocol.h"

@protocol FSTool
+ (BOOL) preload: (NSBundle*) theBundle;
+ (void) destroy;
- (void) unfreeze;
- (void) activate;
- (void) deactivate;
- (void) configure;
- (void) setOwnerTo: (id) theOwner;
- (BOOL) is: (int) type;
- (NSString*) name;
- (NSString*) menuName;
- (NSString*) keyEquivalent;
- (void) mouseEntered: (NSEvent*) theEvent;
- (void) mouseExited: (NSEvent*) theEvent;
- (void) mouseMoved: (NSEvent*) theEvent;
- (void) mouseDragged: (NSEvent*) theEvent;
- (void) mouseUp: (NSEvent*) theEvent;
- (void) mouseDown: (NSEvent*) theEvent;
- (void) rightMouseDown: (NSEvent*) theEvent;
- (void) scrollWheel: (NSEvent*) theEvent;


@optional
- (void*) dataNamed: (NSString*) name;
- (void*) evalNamed: (NSString*) name;
- (void*) queryNamed: (NSString*) name;
- (void) setDataManager: (NSObject<FSCustomDataManagerProtocol>*) Dm;
@end

#endif
