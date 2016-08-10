//
//  CopyTest.m
//  Objective-C
//
//  Created by xianghaitao on 16/8/10.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "Copy.h"
#import <XCTest/XCTest.h>

@interface CopyTest : XCTestCase

@property(nonatomic, strong) Copy *testCopy;

@end

@implementation CopyTest

- (void)setUp {
  [super setUp];
  _testCopy = [Copy new];
  // Put setup code here. This method is called before the invocation of each
  // test method in the class.
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each
  // test method in the class.
  [super tearDown];
}

- (void)testExample {
  // This is an example of a functional test case.
  // Use XCTAssert and related functions to verify your tests produce the
  // correct results.
}

- (void)testMethodInCopy {
  [_testCopy mArrayCopy];
  [_testCopy arrayCopy];
}

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{
      // Put the code you want to measure the time of here.
  }];
}

@end
