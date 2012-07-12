//
//  ExtraInformation.hpp
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FractalStreamCompiler_FSExtraInformation_hpp
#define FractalStreamCompiler_FSExtraInformation_hpp




#include <iostream>
#include "node.h"
using namespace std;

class FSExtraInformation
{
public:
	void* scanner;   
	Node* result;    
	
public:
	FSExtraInformation(void* p_scanner) {scanner = p_scanner;result = NULL;}
	FSExtraInformation() {scanner = NULL;result = NULL;}
	virtual ~FSExtraInformation(){}
	
};




#endif
