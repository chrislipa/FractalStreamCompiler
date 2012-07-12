//
//  FSSourceRange.m
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FSSourceRange.h"

@implementation FSSourceRange 

@synthesize hasRange = _hasRange;
@synthesize startLine = _startLine;
@synthesize startColumn = _startColumn;
@synthesize endLine = _endLine;
@synthesize endColumn = _endColumn;


+(FSSourceRange*) sourceRange {
    return [[[self alloc] init] autorelease];
}


+(FSSourceRange*) sourceRangeWithBeginning:(int) startLine :(int)startColumn andEnd:(int)endLine :(int) endColumn {
    FSSourceRange* r = [self sourceRange];
    r.startLine = startLine;
    r.startColumn = startColumn;
    r.endLine = endLine;
    r.endColumn = endColumn;
    r.hasRange = YES;
    return r;
}

@end
