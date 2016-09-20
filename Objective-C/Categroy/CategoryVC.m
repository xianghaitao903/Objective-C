//
//  CategoryVC.m
//  Objective-C
//
//  Created by xianghaitao on 16/6/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "CategoryVC.h"
#import <objc/runtime.h>

@interface CategoryVC (Test)

- (void)newMethod;

- (NSString *)name;
- (void)setName:(NSString *)name;

@end

@implementation CategoryVC (Test)

- (void)newMethod {
  NSLog(@"hello new method");
}

- (NSString *)name {

  return objc_getAssociatedObject(self, "name");
}
- (void)setName:(NSString *)name {
  objc_setAssociatedObject(self, "name", name,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@interface CategoryVC ()

@end

@implementation CategoryVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.name = @"xxxxx";

  NSLog(@"name == %@", self.name);
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
