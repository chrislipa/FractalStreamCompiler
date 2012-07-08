//
//  context.hpp
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FractalStreamCompiler_context_hpp
#define FractalStreamCompiler_context_hpp




#include <iostream>
using namespace std;
#include "node.h"
class YYContext
{
public:
	void* scanner;   // the scanner state
	Node* result;      // result of the program
	//int a;           // value of the next a
	//int b;           // value of the next b
	//istream* is;     // input stream
	//int esc_depth;   // escaping depth
	
public:
	YYContext(void* p_scanner) {scanner = p_scanner;result = NULL;}
	YYContext() {scanner = NULL;result = NULL;}
	virtual ~YYContext(){}
	
};




#endif
