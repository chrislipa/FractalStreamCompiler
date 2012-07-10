//
//  node.cpp
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>
#include "node.h"

std::ostream& operator<< (std::ostream& stream, const Node& node) {
	std::cout<<"jjj";
	return stream;
}
std::ostream& operator<< (std::ostream& stream, const NInteger& node) {
	stream << node.value;
	return stream;
}


std::ostream& operator<< (std::ostream& stream, const NBinaryOperator& node) {
	stream <<node.lhs << "[" << node.op << "]" << node.rhs;
	return stream;
}
