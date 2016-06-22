//
//  KVOVCTest.m
//  Objective-C
//
//  Created by xianghaitao on 16/6/22.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "KVOVC.h"
#import <XCTest/XCTest.h>

@interface KVOVCTest : XCTestCase

@property(nonatomic, strong) KVOVC *kvoVc;

@end

@implementation KVOVCTest

- (void)setUp {
  [super setUp];
  self.kvoVc = [KVOVC new];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each
  // test method in the class.
  [super tearDown];
}

- (void)testExample {
}

@end
