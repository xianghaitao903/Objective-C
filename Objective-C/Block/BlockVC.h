//
//  BlockVC.h
//  Objective-C
//
//  Created by xianghaitao on 16/6/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BlockName)(NSString *);

@interface BlockVC : UIViewController

@property(nonatomic, strong) BlockName blockName;

- (void)testBlock:(NSString * (^)(NSString *parameter))callBack;

@end
