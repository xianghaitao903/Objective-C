//
//  BlockVC.m
//  Objective-C
//
//  Created by xianghaitao on 16/6/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "BlockVC.h"

@interface BlockVC ()

@end

@implementation BlockVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.blockName = ^(NSString *s) {
    NSLog(@"%@", s);
  };

  [self testBlock:^NSString *(NSString *parameter) {
    NSString *result = [NSString stringWithFormat:@"%@ world", parameter];
    return result;
  }];

  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)testBlock:(NSString * (^)(NSString *parameter))callBack {
  NSString *hello = @"hello ";
  NSString *world = callBack(hello);
  NSLog(@"%@", world);
}

@end
