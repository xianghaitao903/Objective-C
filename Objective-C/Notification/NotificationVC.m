//
//  NotificationVC.m
//  Objective-C
//
//  Created by xianghaitao on 16/6/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "NotificationVC.h"

@interface NotificationVC ()

@property(nonatomic, strong) UIButton *postNotificationBtn;
@property(nonatomic, strong) UIButton *postQueueNotificationBtn;

@end

@implementation NotificationVC

#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self addNotification];
  [self initSubview];
  [self initEvents];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)initSubview {
  _postNotificationBtn =
      [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 50)];
  [_postNotificationBtn.layer setCornerRadius:4.0];
  [_postNotificationBtn setTitle:@"PostNotification"
                        forState:UIControlStateNormal];
  _postNotificationBtn.backgroundColor = [UIColor redColor];
  [self.view addSubview:_postNotificationBtn];

  _postQueueNotificationBtn =
      [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 150, 50)];
  [_postQueueNotificationBtn.layer setCornerRadius:4.0];
  [_postQueueNotificationBtn setTitle:@"PostNotificationQueue"
                             forState:UIControlStateNormal];
  _postQueueNotificationBtn.backgroundColor = [UIColor redColor];
  [self.view addSubview:_postQueueNotificationBtn];
}

- (void)initEvents {
  [_postNotificationBtn addTarget:self
                           action:@selector(postSingal:)
                 forControlEvents:UIControlEventTouchUpInside];

  [_postQueueNotificationBtn addTarget:self
                                action:@selector(postSingalQueue:)
                      forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - events response
- (void)postSingal:(UIButton *)sender {
  NSLog(@"Notification start");
  [[NSNotificationCenter defaultCenter] postNotificationName:@"testName"
                                                      object:self];
  NSLog(@"Notification end");
}

// NSNotificationQueue
// 合并相同的消息，只能在很短的时间之内合并（如一个循环之中）
- (void)postSingalQueue:(UIButton *)sender {
  for (int i = 0; i < 10; i++) {
    NSNotification *notification =
        [NSNotification notificationWithName:@"testName" object:self];
    NSLog(@"Notification start");
    [[NSNotificationQueue defaultQueue]
        enqueueNotification:notification
               postingStyle:NSPostASAP
               coalesceMask:NSNotificationCoalescingOnName |
                            NSNotificationCoalescingOnSender
                   forModes:nil];
    NSLog(@"Notification end");
  }
}

#pragma mark - private methods
- (void)addNotification {
  NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
  [notification addObserver:self
                   selector:@selector(valueChanged:)
                       name:@"testName"
                     object:nil];
}

- (void)valueChanged:(NSNotification *)notification {
  NSLog(@"--------");
}

@end
