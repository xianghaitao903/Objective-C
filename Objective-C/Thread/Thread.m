//
//  Thread.m
//  Objective-C
//
//  Created by xianghaitao on 16/7/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "Thread.h"
#import <UIKit/UIKit.h>

@interface Thread () {
  NSLock *theLock;
  NSCondition *theCondition;
  NSThread *threadOne;
  NSThread *threadTwo;
  NSThread *threadThree;
  NSInteger tickets;
  NSInteger count;
}
@end

@implementation Thread

- (void)threadStart2 {
  [NSThread detachNewThreadSelector:@selector(downloadImage:)
                           toTarget:self
                         withObject:@"s"];
}

- (void)threadStart {
  NSThread *thread = [[NSThread alloc] initWithTarget:self
                                             selector:@selector(downloadImage:)
                                               object:@"s"];
  [thread start];
//  [thread cancel];
}

- (void)downloadImage:(NSString *)kurl {
  NSData *data =
  [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:kurl]];
  UIImage *image = [[UIImage alloc] initWithData:data];
  if (image == nil) {
    
  } else {
    [self performSelectorOnMainThread:@selector(updateUI:)
                           withObject:image
                        waitUntilDone:YES];
  }
}

- (void)addLockAndCondition {
  tickets = 100;
  count = 0;
  theLock = [[NSLock alloc] init];
  theCondition = [[NSCondition alloc] init];
  
  threadOne =
  [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
  [threadOne setName:@"Thread-1"];
  [threadOne start];
  
  threadTwo =
  [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
  [threadTwo setName:@"Thread-2"];
  [threadTwo start];
  
  threadThree = [[NSThread alloc] initWithTarget:self
                                        selector:@selector(run3)
                                          object:nil];
  [threadThree setName:@"Thread-3"];
  [threadThree start];
}

- (void)run3 {
  while (YES) {
    [theCondition lock];
    [NSThread sleepForTimeInterval:3];
    [theCondition signal];
    [theCondition unlock];
  }
}

- (void)run {
  while (TRUE) {
    [theCondition lock];
    [theCondition wait];
    [theLock lock];
    if (tickets > 0) {
      tickets = tickets - 1;
      count += 1;
      NSString *threadName = [[NSThread currentThread] name];
      NSLog(@"执行了%ld次，还剩下%ld张票,线程名：%@", (long)count,
            (long)tickets, threadName);
    } else {
      break;
    }
    [theCondition unlock];
    [theLock unlock];
  }
}

@end
