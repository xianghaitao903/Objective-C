//
//  Copy.h
//  Objective-C
//
//  Created by xianghaitao on 16/8/10.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Copy : NSObject <NSCopying, NSMutableCopying>

@property(nonatomic, strong) NSString *string;

@property(nonatomic, copy) NSString *string_1;
@property(nonatomic, copy) NSMutableString *string_2;

@property(nonatomic, copy) NSArray *array_1;
@property(nonatomic, copy) NSMutableArray *array_2;

@property(nonatomic, copy) NSDictionary *dict_1;
@property(nonatomic, copy) NSMutableDictionary *dict_2;

- (void)stringCopy;
- (void)mutableStringCopy;
- (void)arrayCopy;
- (void)mArrayCopy;

@end
