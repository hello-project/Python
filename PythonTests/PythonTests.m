//
//  PythonTests.m
//  PythonTests
//
//  Created by zengxs on 2019/6/30.
//  Copyright © 2019 zengxs. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Python/Python.h>
#import <Python/framework-init.h>

@interface PythonTests : XCTestCase

@end

@implementation PythonTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    PyFramework_Initialize();
    Py_Initialize();
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    Py_Finalize();
}

- (void)testHello {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    PyRun_SimpleString("print('hello, world')");
    PyRun_SimpleString("import sys; print(sys.version)");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
