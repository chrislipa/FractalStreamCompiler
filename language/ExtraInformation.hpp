//
//  ExtraInformation.hpp
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FractalStreamCompiler_ExtraInformation_hpp
#define FractalStreamCompiler_ExtraInformation_hpp




#include <iostream>
using namespace std;
#include "node.h"
class ExtraInformation
{
public:
	void* scanner;   
	Node* result;    
	
public:
	ExtraInformation(void* p_scanner) {scanner = p_scanner;result = NULL;}
	ExtraInformation() {scanner = NULL;result = NULL;}
	virtual ~ExtraInformation(){}
	
};




#endif
