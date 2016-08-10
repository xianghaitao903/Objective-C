# 线程
## 简介


## NSOperation
### 简介
NSOperation为抽象类，不能够直接使用，只能使用它的子类 NSInvocationOperation NSBlockOperation
NSOperation是线程安全的，不需要增加线程锁

### NSInvocationOperation
  NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(testMethod) object:nil];
  //不使用quene直接启动
  //  当前线程中启动
  [operation start];

### NSBlockOperation
  __weak typeof(self) weakSelf = self;
  NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
  [weakSelf testMethod];
  }];
  [operation start];

### Dependencies
addDependency: 增加依赖
removeDependcy: 移除依赖
dependencies 
增加依赖后,只有当后面的任务完成过后（无论执行成功或者执行失败，取消也相当于完成），前面的任务才能够被读取和执行

### KVO
NSOpeartion 是遵循kvc 和 kvo 的设计，
如果需要，可以对他的属性使用KVO进行监听
可以使用下面的key

#### read-only
isCancelled
isAsynchronous
isExecuting
isFinish
isReady
dependencies

#### readable and writable
queuePriority
completionBlock

### 同步和异步
不用队列
直接在一个同步操作中调用start方法，那么operation会在当前线程中执行，直到完成过后才返回
如果在一个异步操作中调用start方法，在operation执行前就会反回，会创建一个新的线程完成这个operation

使用队列
如果将一个operation加入到一个异步队列中，总会在一个单独的线程中调用start方法。

### 自定义NSOperation
需要自己相应取消事件，定义属性的getter和setter需要确保属性调用时的线程安全，自定义并发的Operation需要更新执行状态（支持KVO）

#### 自定义非并发的Operation
需要重写 main

#### 自定义并发的Operation
需要重写
start  
asynchronous
executing
finished
需要更新执行状态（支持KVO）

### NSOpeartionQueue
#### 简介
NSOperationQueue是一个NSOperation的集合,当NSOperation被加入一个队列中之后
设置maxConcurrentOperationCount 为1时，是串行队列，－1表示无限制大于1为并行队列
直到这个NSOperation执行完成或者被取消才会从队列中移出，NSOperationQueue是线程安全的

#### currentQueue 
获取当前线程所在的队列

#### mainQueue 
主线程

## NSThread
### 初始化
  [NSThread detachNewThreadSelector:@selector(downloadImage:)
                           toTarget:self
                         withObject:@"s"];
自动开始
  
  NSThread *thread = [[NSThread alloc] initWithTarget:self
                                             selector:@selector(downloadImage:)
                                               object:@"s"];
  [thread start];
调用start方法过后才开始

### 同步和异步
  performSelector:onThread:withObject:waitUntilDone: 
  waitUntilDone 为YES 为同步， NO为异步
 
  performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array

  modes runLoopModel 组成的数组 例：[NSSet setWithObject:NSRunLoopCommonModes];

### 线程安全
一个数据同时可以被多个线程使用（修改和读取）时，数据可能会出现无意义的值，如买票（票数可能会出现负数）这时需要加锁
  NSLock *theLock = [NSLock new];
  [theLock lock];
  // 数据的操作
  [theLock unlock];

  条件锁（）
  NSCondition *theCondition = [NSCondition new];
  [theCondition lock];
  [theCondition wait]; //可以在其他线程，或本线程中执行 [theCondition signal];才会继续操作
  //操作
  [theCondition unlock];

##RunLoop
### 简介


##GCD