//
//  Copy.m
//  Objective-C
//
//  Created by xianghaitao on 16/8/10.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "Copy.h"

@implementation Copy

- (void)stringCopy {
  NSString *string = @"origin";
  NSString *stringCopy = [string copy];
  NSMutableString *mutableString = [string mutableCopy];

  NSLog(@" string === %p,\n stringCopy === %p,\n mutableString === %p,\n ",
        string, stringCopy, mutableString);
  stringCopy = @"456";
  [mutableString appendString:@"1234"];
  NSLog(@" string === %@,\n stringCopy === %@,\n mutableString === %@,\n ",
        string, stringCopy, mutableString);
  NSLog(@" string === %p,\n stringCopy === %p,\n mutableString === %p,\n ",
        string, stringCopy, mutableString);
}

- (void)mutableStringCopy {
  NSMutableString *string = [[NSMutableString alloc] initWithString:@"origin"];
  NSString *stringCopy = [string copy];
  NSMutableString *mStringCopy = [string copy];
  NSMutableString *stringMCopy = [string mutableCopy];

  NSLog(@" string === %p,\n stringCopy === %p,\n mutableString === %p,\n ",
        string, stringCopy, mStringCopy);
  //  [mStringCopy appendString:@"1234"]; // cash
  [stringMCopy appendString:@"1234"];
  NSLog(@" string === %@,\n stringCopy === %@,\n mutableString === %@,\n ",
        string, stringCopy, mStringCopy);
  NSLog(@" string === %p,\n stringCopy === %p,\n mutableString === %p,\n ",
        string, stringCopy, mStringCopy);
}

- (void)arrayCopy {
  Copy *copy01 = [Copy new];
  Copy *copy02 = [Copy new];
  Copy *copy03 = [Copy new];
  NSArray *array = @[ copy01, copy02, copy03 ];
  NSMutableArray *marray = [array mutableCopy];
  NSArray *copyArray = [array copy];

  NSArray *copyArray_1 = [[NSArray alloc] initWithArray:array copyItems:NO];
  NSArray *copyArray_2 = [[NSArray alloc] initWithArray:array copyItems:YES];
}

- (void)mArrayCopy {
  Copy *copy01 = [Copy new];
  Copy *copy02 = [Copy new];
  Copy *copy03 = [Copy new];
  NSArray *array = @[ copy01, copy02, copy03 ];
  NSMutableArray *marray = [[NSMutableArray alloc] initWithArray:array];
  NSMutableArray *marray_2 =
      [[NSMutableArray alloc] initWithArray:array copyItems:NO];
  NSMutableArray *marray_3 =
      [[NSMutableArray alloc] initWithArray:array copyItems:YES];
  NSArray *copyArray = [marray copy];
  NSMutableArray *mutableCopyArray = [marray mutableCopy];
}

#pragma mark - delegate
#pragma mark NSCopying
- (id)copyWithZone:(nullable NSZone *)zone {
  Copy *copy = [[self class] allocWithZone:zone];
  copy.array_1 = self.array_1;
  copy.array_2 = self.array_2;
  copy.string = self.string;
  copy.dict_1 = self.dict_1;
  copy.dict_2 = self.dict_2;
  copy.string_1 = self.string_1;
  copy.string_2 = self.string_2;
  return copy;
}

#pragma mark NSMutableCopying
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
  Copy *copy = [[self class] allocWithZone:zone];
  //...
  return copy;
}

@end
