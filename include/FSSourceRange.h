//
//  FSSourceRange.h
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSSourceRange : NSObject {
    bool _hasRange;
    int _startLine;
    int _startColumn;
    int _endLine;
    int _endColumn;
}

@property (readwrite,assign) bool hasRange;
@property (readwrite,assign) int startLine;
@property (readwrite,assign) int startColumn;
@property (readwrite,assign) int endLine;
@property (readwrite,assign) int endColumn;

@end
