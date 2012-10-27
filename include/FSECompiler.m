#import "FSECompiler.h"
#import <stdlib.h>
#import "FSECompilerSymbols.H"


@implementation FSECompiler

- (id) init {

	self = [super init];
	flags = [[NSMutableArray alloc] init];
	[flags addObject:  @"Default Exit Condition"];
	probes = [[NSMutableArray alloc] init];
	currentFlagID = 1;
	specialTools = nil;
	source = symbol = title = nil;

	nextvar = 0;

	return self;
}








- (BOOL) usesCustom { return useCustom; }
- (NSString*) customPath { /*NSLog(@"customPath is \"%@\"\n", customPath);*/ return customPath; }

- (NSArray*) specialTools { return [NSArray arrayWithArray: specialTools]; }

- (IBAction) compile
{
	
    
	[error release];
	error = nil;
	[flags release];
	[probes release];
	flags = [[NSMutableArray alloc] init];
	probes = [[NSMutableArray alloc] init];
	[specialTools release];
	specialTools = [[NSMutableArray alloc] init];
	[flags addObject:@"Default Exit Condition"];
	currentFlagID = 1;
	dataSourceID = 0;
	

	
	probecount = 0;
	nextvar = 0;
	loopDepth = 0;
	
	//tree = [[FSEParseTree alloc] init];
	//node = [tree newOrphanOfType: FSE_RootNode];
	//rootblock = node;
	//orphan = [tree newOrphanOfType: FSE_Nil];  /* orphan node gets used as a temporary root as subtrees get built */
	/*prefixblock = *///[tree newNodeOfType: FSE_Command | FSE_Block at: rootblock]; /* this is where prefix code should go */
	//codeblock = [tree newNodeOfType: FSE_Command | FSE_Block at: rootblock];
	useComplexVars = YES;
	
	index = 0;
	//savednode = -1;
	
	
	if(useComplexVars) {
		[self indexOfVariableWithName: @"z"]; [self indexOfVariableWithName: @"c"];
		var[[self indexOfVariableWithName: @"pixel"]].par = YES;
		[self setVariableWithName: @"pixel" toType: 0]; --nextvar;
	}
	else {
		[self indexOfVariableWithName: @"x"]; [self indexOfVariableWithName: @"y"];
		[self indexOfVariableWithName: @"a"]; [self indexOfVariableWithName: @"b"];
		var[[self indexOfVariableWithName: @"pixel"]].par = YES;
	}
	
	
	
	if([error isEqualToString: @"script ended unexpectedly"]) error = nil;
	if(error) return;
	
	

	
	//[tree setTempVar: [self indexOfVariableWithName: @".temp"]];
	//error = [tree realifyFrom: FSE_RootNode];
	if(error) {  NSLog(@"ERROR -----> \"%@\", tree is:\n", error);  return; }

	[self printVariableStack];

	symbol = nil;
}

- (void) setTitle: (NSString*) newTitle source: (NSString*) newSource andDescription: (NSTextStorage*) newDescription
{
//	if(title != nil) [title release]; title = [newTitle retain];
//	if(source != nil) [source release];
	source = [NSString stringWithString: [newSource lowercaseString]];
	literalSource = [NSString stringWithString: newSource];
//	if(description != nil) [description release]; description = [newDescription retain];
}

- (int) dataSources { return dataSourceID; }


- (void) buildScript: (NSString*) newSource {
	if([[newSource lowercaseString] isEqualToString: source] != YES) {
//		NSLog(@"Compiler is going to build script \"%@\"\n", newSource);
		NSTextStorage* desc = [[NSTextStorage alloc] initWithString:@""];
		[self setTitle: @"" source: newSource andDescription: desc];
		[self compile];
		[desc release];
	}
}

- (NSArray*) flagArray { 
	NSArray* ar;
	ar = [NSArray arrayWithArray: flags];
	return ar;
}

- (NSArray*) probeArray {
	NSArray* ar;
	ar = [NSArray arrayWithArray: probes];
	return ar;
}

- (int) addVariable: (NSString*) name
{
	if(nextvar == FSECOMPILER_VARIABLES) return -1;
	var[nextvar].word = name;
	var[nextvar].code = nextvar;
	var[nextvar].par = NO;
	var[nextvar].type = (useComplexVars == YES)? 1 : 0;
	++nextvar;
	return nextvar;
}

- (void) setVariableWithName: (NSString*) name toType: (int) type { var[[self indexOfVariableWithName: name]].type = type; }

- (NSString*) nameOfVariableAtIndex: (int) idx
{
	if((idx >= nextvar) || (idx < 0)) return nil;
	return [NSString stringWithString: var[idx].word];
}


- (int) indexOfVariableWithName: (NSString*) name
{
	int i, r;


	for(i = 0; i < nextvar; i++) if([var[i].word isEqualToString: name] == YES) return i;
	r = [self addVariable: name] - 1;
	if(useComplexVars) [self addVariable: name];
	return r;
}

- (int) parameterNumberOfVariableAtIndex: (int) idx {
	int i, j;
	j = -1;
	for(i = 0; i <= idx; i++) if(var[i].par == YES) ++j;
	return j;
}

- (void) printVariableStack {
	int i;
	NSLog(@"variable stack:\n");
	for(i = 0; i < nextvar; i++) NSLog(@"        \"%@\" : %i\n", var[i].word, var[i].code);
}

- (int) numberOfVariables { return nextvar; }
- (int) maximumLoopDepth { return 16; }	/* hack, should track the loop depth as we parse */

- (void) setOutputFilename: (NSString*) newFilename { filename = [newFilename retain]; }

- (BOOL) isParametric {

	return NO;
}

- (NSArray*) parameters {
	NSMutableArray* p;
	int i;
	p = [[[NSMutableArray alloc] init] autorelease];
	for(i = 5; i < nextvar; i++) if(var[i].par == YES) [p addObject: [self nameOfVariableAtIndex: i]];
	return [NSArray arrayWithArray: p];
}



- (NSString*) errorMessage { return (error == nil)? nil : [NSString stringWithString: error]; }
- (NSRange) errorRange { return lastRange; }

@end

