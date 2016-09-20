//
//  Parent.h
//  Objective-C
//
//  Created by xianghaitao on 16/8/22.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Parent : NSObject {
@private
  NSString *test;
}
@property(nonatomic, strong) NSString *name;

- (void)eat;

- (void)testMethod;

@end
