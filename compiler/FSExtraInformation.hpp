//
//  ExtraInformation.hpp
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef FractalStreamCompiler_FSExtraInformation_hpp
#define FractalStreamCompiler_FSExtraInformation_hpp

#include "FSCompilerErrorTypeDefinitions.h"


#include <iostream>
#include <vector>

#include "node.h"
using namespace std;

class FSParsingError {
    string errorMessage;
    string sourceCodeSubstring;
    int firstLine, firstColumn, lastLine, lastColumn;
    
};



class FSExtraInformation
{
public:
	void* scanner;   
	Node* result;    
    vector<void*> errors;
public:
	FSExtraInformation(void* p_scanner) {scanner = p_scanner;result = NULL;}
	FSExtraInformation() {scanner = NULL;result = NULL;}
	virtual ~FSExtraInformation(){}
	
};




#endif
