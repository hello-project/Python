//
//  init.m
//  Python
//
//  Created by zengxs on 2019/6/30.
//  Copyright © 2019 zengxs. All rights reserved.
//

#include "Python.h"
#include "framework-init.h"

#import <Foundation/Foundation.h>

void PyFramework_Initialize() {
    const char* cpath = PyFramework_GetInitialPythonPath();
    wchar_t* path_buffer = (wchar_t*)malloc(sizeof(wchar_t) * (strlen(cpath) + 1));

    mbstowcs(path_buffer, cpath, strlen(cpath));
    Py_SetPath(path_buffer);
    free(path_buffer);
}

const char* PyFramework_GetInitialPythonPath() {
    NSBundle* bundle = [NSBundle bundleWithIdentifier:@"org.python.Python"];
    
    NSMutableArray* python_paths = [NSMutableArray array];
    [python_paths addObject:[bundle pathForResource:@"lib/python3.6" ofType:nil]];
    [python_paths addObject:[bundle pathForResource:@"lib/python3.6/lib-dynload" ofType:nil]];
    [python_paths addObject:[bundle pathForResource:@"lib/python3.6/site-packages" ofType:nil]];
    
    return [[python_paths componentsJoinedByString:@":"] cStringUsingEncoding:NSUTF8StringEncoding];
}
