//
//  TimerVC.m
//  Objective-C
//
//  Created by xianghaitao on 16/6/30.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "TimerVC.h"

@interface TimerVC ()

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) UILabel *label2;
@property(nonatomic, strong) UILabel *label3;
@property(nonatomic, strong) UILabel *label4;
@property(nonatomic, strong) NSTimer *timer1;
@property(nonatomic, strong) NSTimer *timer2;
@property(nonatomic, strong) NSTimer *timer3;
@property(nonatomic, strong) NSTimer *timer4;
@property(nonatomic, assign) NSInteger timer1Count;
@property(nonatomic, assign) NSInteger timer2Count;
@property(nonatomic, assign) NSInteger timer3Count;
@property(nonatomic, assign) NSInteger timer4Count;

@end

@implementation TimerVC

#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self initSubview];
  [self setLayout];
  [self initTimer];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
  [self stopTimer];
  [super viewWillDisappear:animated];
}

- (void)initSubview {
  [self.view addSubview:self.scrollView];
  [self.scrollView addSubview:self.label1];
  [self.scrollView addSubview:self.label2];
  [self.scrollView addSubview:self.label3];
  [self.scrollView addSubview:self.label4];
}

- (void)setLayout {
  self.scrollView.frame = self.view.bounds;
  CGFloat width = self.view.bounds.size.width;
  CGFloat height = 44.0;
  CGFloat offsetY = 30;
  self.label1.frame = CGRectMake(0, offsetY, width, height);
  self.label2.frame = CGRectMake(0, offsetY + 50, width, height);
  self.label3.frame = CGRectMake(0, offsetY + 100, width, height);
  self.label4.frame = CGRectMake(0, offsetY + 150, width, height);
}

- (void)initTimer {
  [self timer1];
  [self timer2];
  [self timer3];
  [self timer4];
}

- (void)stopTimer {
  [_timer1 invalidate];
  _timer1 = nil;
  [_timer2 invalidate];
  [_timer3 invalidate];
  _timer3 = nil;
  [_timer4 invalidate];
  _timer4 = nil;
}

#pragma mark - timer Method
- (void)timer1Method {
  NSLog(@"timer1 run %ld times", (long)self.timer1Count++);
}

- (void)timer2Method {
  NSLog(@"timer2 run %ld times", (long)self.timer2Count++);
}

- (void)timer3Method {
  NSLog(@"timer3 run %ld times", (long)self.timer3Count++);
}

- (void)timer4Method {
  NSLog(@"timer4 run %ld times", (long)self.timer4Count++);
}

#pragma mark - getter and setter
- (UIScrollView *)scrollView {
  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(0, 789);
  }
  return _scrollView;
}

- (UILabel *)label1 {
  if (!_label1) {
    _label1 = [[UILabel alloc] init];
  }
  return _label1;
}

- (UILabel *)label2 {
  if (!_label2) {
    _label2 = [[UILabel alloc] init];
    ;
  }
  return _label2;
}

- (UILabel *)label3 {
  if (!_label3) {
    _label3 = [[UILabel alloc] init];
    ;
  }
  return _label3;
}

- (UILabel *)label4 {
  if (!_label4) {
    _label4 = [[UILabel alloc] init];
    ;
  }
  return _label4;
}

- (NSTimer *)timer1 {
  if (!_timer1) {
    NSMethodSignature *sign =
        [self methodSignatureForSelector:@selector(timer1Method)];
    NSInvocation *invocation =
        [NSInvocation invocationWithMethodSignature:sign];
    [invocation setTarget:self];
    [invocation setSelector:@selector(timer1Method)];
    _timer1 =
        [NSTimer timerWithTimeInterval:1 invocation:invocation repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer1 forMode:NSDefaultRunLoopMode];
  }
  return _timer1;
}

- (NSTimer *)timer2 {
  if (!_timer2) {
    _timer2 = [NSTimer timerWithTimeInterval:1
                                      target:self
                                    selector:@selector(timer2Method)
                                    userInfo:nil
                                     repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer2 forMode:NSRunLoopCommonModes];
  }
  return _timer2;
}

- (NSTimer *)timer3 {
  if (!_timer3) {
    NSMethodSignature *sign =
        [self methodSignatureForSelector:@selector(timer3Method)];
    NSInvocation *invocation =
        [NSInvocation invocationWithMethodSignature:sign];
    [invocation setTarget:self];
    [invocation setSelector:@selector(timer3Method)];
    _timer3 = [NSTimer scheduledTimerWithTimeInterval:1
                                           invocation:invocation
                                              repeats:YES];

    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer3 forMode:NSDefaultRunLoopMode];
  }
  return _timer3;
}

- (NSTimer *)timer4 {
  if (!_timer4) {
    _timer4 = [NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(timer4Method)
                                             userInfo:nil
                                              repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:_timer4 forMode:NSRunLoopCommonModes];
  }
  return _timer4;
}

@end
