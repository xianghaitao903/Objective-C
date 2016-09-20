# Notification (通知中心)
## 简介
Notification Center 是在Cocoa/Cocoa Touch Framework中，对象之间可以不必相互知道彼此的存在，也可以相互传递信息的机制。
我们可以把Notification Center 想象是一种广播系统，当一个对象A的状态发生改变，而多个对象需要知道这个对象发生改变的情况下，对象A不必直接对这些对象发出呼叫，而是告诉一个广播中心，我的状态改变了，，至于其他需要获取状态的对象，只需要在这个广播中心订阅这个指定的通知，所以当对象A发出通知的时候，这个广播中心就会通知所有订阅通知的其它对象。
## 语法
接收Notification
一个通知分为三个部分
1 object：发送者，是谁发送了这个通知。
2 name：这个通知叫做什么名字
3 user info：这个通知带了那些额外的信息
例：
```
- (void)test2:(void (^)(NSString *s))blockName {
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(localeDidChange:)
             name:NSCurrentLocaleDidChangeNotification
           object:nil];
}

- (void)localeDidChange:(NSNotification *)notification {
  // do something
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
```
意思是我们要指定NSCurrentLocaleDidChangeNotification 的通知，交由localeDidChange:处理。object设置为nil，代表不管是哪个对象送出的，只要符合NSCurrentLocaleDidChangeNotification 的通知，我们统统处理。
每个通知中，还可能会有额外的讯息，会夹带在NSNotification对象的userInfo（NSDictionary类型）中，
如果name 设置为nil，代表订阅所有的通知
我们不需要订阅某项通知的时候，要对NOtification Center 呼叫 -removeObserver:,在remove observer的时候，要传入self，通常在dealloc的时候停止订阅。
可以用block的形式订阅
```
self.observer = [[NSNotificationCenter defaultCenter]
      addObserverForName:NSCurrentLocaleDidChangeNotification
                  object:self
                   queue:[NSOperationQueue mainQueue]
              usingBlock:^(NSNotification *_Nonnull note){
                  // dosomething
              }];


- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}
```
发送Notification
在建立了notification对象之后,对NSNotificationCenter呼叫 -postNotifiation:即可。
```
- (void)postNotification:(NSNotification *)notification;
- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject;
- (void)postNotificationName:(NSString *)aName object:(nullable id)anObject userInfo:(nullable NSDictionary *)aUserInfo;
```
## NSNotificationQueue
NSNotificationQueue（通告队列）的作用是充当通告中心（NSNotificationCenter的实例）的缓冲区。通告队列通常以先进先出的顺序通告，当一个通告上升到队列的前面时，队列就把它发送给通知中心，通知中心随后把它派发给所有注册为观察者的对象。
NSNotificationQueue为通知机制增加了两个重要的特性，即通告的聚结和异步发送。
```
self.notificationQueue = [[NSNotificationQueue alloc]
      initWithNotificationCenter:[NSNotificationCenter defaultCenter]];

[self.notificationQueue enqueueNotification:notification
                                 postingStyle:NSPostASAP
                                 coalesceMask:NSNotificationCoalescingOnName |
                                              NSNotificationCoalescingOnSender
                                     forModes:nil];
/*
代表notificationQueue 合并名称与发送者都相同的通知
postingStyle:
NSPostASAP:尽快发送，进入队列的通告会在运行循环的当前迭代完成时被发送给通知中心。
NSPostWhenIdle:空闲时发送，进入队列的通告只在运行循环处于等待状态时才被发送。
NSPostNow:立即发送，进入队列的通告会在聚结之后，立即发送到通告中心。
*/
```
