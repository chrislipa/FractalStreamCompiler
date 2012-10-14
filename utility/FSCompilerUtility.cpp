//
//  FSCompilerUtility.c
//  FractalStreamCompiler
//
//  Created by Christopher Lipa on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "FSCompilerUtility.h"

#include <sstream>

using namespace std;
std::string intToString(int i)
{
    std::stringstream ss;
    std::string s;
    ss << i;
    s = ss.str();
    return s;
}

std::string longToString(long long i)
{
    std::stringstream ss;
    std::string s;
    ss << i;
    s = ss.str();
    return s;
}

std::string doubleToString(double i)
{
    std::stringstream ss;
    std::string s;
    ss << i;
    s = ss.str();
    
    return s;
}

std::string spaces(int n) {
    std::string o = "";
    for (int i = 0; i<n; i++) {
        o+=" ";
    }
    return o;
}