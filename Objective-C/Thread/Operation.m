//
//  Operation.m
//  Objective-C
//
//  Created by xianghaitao on 16/7/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "Operation.h"

@implementation Operation

- (void)operationQueue {
  NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
  NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
  [currentQueue addOperationWithBlock:^{
    NSLog(@"234");
  }];
}

- (void)invocationOperation {
  NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testMethod) object:nil];
  //不使用quene直接启动
//  当前线程中启动
  [operation start];
//  
}

- (void)blockOperation {
  __weak typeof(self) weakSelf = self;
  NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
    [weakSelf testMethod];
  }];
  [operation addExecutionBlock:^{
    NSLog(@"1111");
  }];
  [operation addExecutionBlock:^{
    NSLog(@"1111");
  }];
 //三个block中的内容是异步实现的
  [operation start];
  NSInvocationOperation *operation2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testMethod) object:nil];
  [operation addDependency:operation2];
}

- (void)testMethod {
  
}

@end

@interface NonConcurrent : NSOperation

@property(nonatomic,strong) NSRecursiveLock *lock;
@property(nonatomic,strong) NSObject *testProperty;

@end

@implementation NonConcurrent
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.lock = [[NSRecursiveLock alloc] init];
  }
  return self;
}


- (void)main {
  // 新建一个自动释放池，如果是异步执行操作，那么将无法访问到主线程的自动释放池
  @autoreleasepool {
    //响应退出 耗时的操作，每次遍历时 调用
    if (self.cancelled) {
      return;
    }
    // ....
  }
}

- (void)setTestProperty:(NSObject *)testProperty {
  [self.lock lock];
  _testProperty = testProperty;
  [self.lock unlock];
}

@end

typedef NS_ENUM(NSInteger, AFOperationState) {
  AFOperationPausedState      = -1,
  AFOperationReadyState       = 1,
  AFOperationExecutingState   = 2,
  AFOperationFinishedState    = 3,
};

static inline NSString * AFKeyPathFromOperationState(AFOperationState state) {
  switch (state) {
    case AFOperationReadyState:
      return @"isReady";
    case AFOperationExecutingState:
      return @"isExecuting";
    case AFOperationFinishedState:
      return @"isFinished";
    case AFOperationPausedState:
      return @"isPaused";
    default: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunreachable-code"
      return @"state";
#pragma clang diagnostic pop
    }
  }
}

@interface Concurrent : NSOperation

@property(nonatomic,assign)AFOperationState state;
@property(nonatomic,strong) NSRecursiveLock *lock;

@end


@implementation Concurrent
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.lock = [[NSRecursiveLock alloc] init];
  }
  return self;
}

- (void)setState:(AFOperationState)state {
  if ([self isCancelled]) {
    return;
  }
  
  [self.lock lock];
  NSString *oldStateKey = AFKeyPathFromOperationState(self.state);
  NSString *newStateKey = AFKeyPathFromOperationState(state);
  
  [self willChangeValueForKey:newStateKey];
  [self willChangeValueForKey:oldStateKey];
  _state = state;
  [self didChangeValueForKey:oldStateKey];
  [self didChangeValueForKey:newStateKey];
  [self.lock unlock];
}

- (void)setCompletionBlock:(void (^)(void))block {
  [self.lock lock];
  if (!block) {
    [super setCompletionBlock:nil];
  } else {
    
  }
  [self.lock unlock];
}

- (BOOL)isReady {
  return self.state == AFOperationReadyState && [super isReady];
}

- (BOOL)isExecuting {
  return self.state == AFOperationExecutingState;
}

- (BOOL)isFinished {
  return self.state == AFOperationFinishedState;
}

- (void)start {
  [self.lock lock];
  if ([self isCancelled]) {
    return;
  } else if ([self isReady]) {
    self.state = AFOperationExecutingState;
    //dosomething
  }
  [self.lock unlock];
}

- (void)operationDidStart {
  [self.lock lock];
  if (![self isCancelled]) {
   
  }
  [self.lock unlock];
  
}

- (void)finish {
  [self.lock lock];
  self.state = AFOperationFinishedState;
  [self.lock unlock];
  
}

- (void)cancel {
  [self.lock lock];
  if (![self isFinished] && ![self isCancelled]) {
    [super cancel];
  }
  [self.lock unlock];
}

@end

