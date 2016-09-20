//
//  ProtocolVC.h
//  Objective-C
//
//  Created by xianghaitao on 16/6/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestProtocol <NSObject>

@optional
- (void)optionalMethod1;
- (void)optionalMethod2;

@required
- (void)requireDmethod1;
- (void)requireDmethod2;
- (void)requireDmethod3;

@end

@interface ProtocolVC : UIViewController <TestProtocol>

@property(nonatomic, weak) id<TestProtocol> testProtocol;

@end
