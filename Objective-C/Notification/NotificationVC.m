//
//  NotificationVC.m
//  Objective-C
//
//  Created by xianghaitao on 16/6/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "NotificationVC.h"

@interface NotificationVC ()

@end

@implementation NotificationVC

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self initSubview];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubview {
    UIButton *postNotificationBtn = [[UIButton alloc ] initWithFrame:CGRectMake(100, 100, 150, 50)];
    [postNotificationBtn.layer setCornerRadius:4.0];
    [postNotificationBtn setTitle:@"PostNotification" forState:UIControlStateNormal];
    [postNotificationBtn addTarget:self action:@selector(postSingal:) forControlEvents:UIControlEventTouchUpInside];
    postNotificationBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:postNotificationBtn];
    
    UIButton *postNotificationQueueBtn = [[UIButton alloc ] initWithFrame:CGRectMake(100, 200, 150, 50)];
    [postNotificationQueueBtn.layer setCornerRadius:4.0];
    [postNotificationQueueBtn setTitle:@"PostNotificationQueue" forState:UIControlStateNormal];
    [postNotificationQueueBtn addTarget:self action:@selector(postSingalQueue:) forControlEvents:UIControlEventTouchUpInside];
    postNotificationQueueBtn.backgroundColor = [UIColor redColor];
    [self.view addSubview:postNotificationQueueBtn];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - events response 
- (void)postSingal:(UIButton *)sender {
    NSLog(@"Notification start");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"testName" object:self];
    NSLog(@"Notification end");
}

- (void)postSingalQueue:(UIButton *)sender {
    NSNotification *notification = [NSNotification notificationWithName:@"testName" object:self];
    NSLog(@"Notification start");
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostASAP coalesceMask:NSNotificationCoalescingOnName|NSNotificationCoalescingOnSender forModes:nil];
     NSLog(@"Notification end");
}

#pragma mark - private methods
- (void)addNotification {
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(valueChanged:) name:@"testName" object:nil];
}

- (void)valueChanged:(NSNotification *)notification {
    NSLog(@"--------");
}

@end
