# 内存管理
所谓的内存管理只有两件事情
用与不用，用的时候就用，不用的时候就释放。
用与释放不成对就会出现两个结果，用完之后不释放，会导致内存占用越来越大，就会出现内存泄漏；反之访问一个已经被释放掉的对象，就会出现EXC_BAD_ACCESS的crash；
iOS上不支持垃圾回收(GC)，Mac OS X 上面支持

## 手动内存管理 (MRC)

Reference Count/Ratain/Release
Objective-C通过引用计数(reference Count)来管理内存，
只要一个对象被某个地方用到一次，这个地方就对这个对象的Reference Count 加一，反之就减一，如果数字减到零，就释放这块记忆。
一个对象使用alloc 、init产生，初始的reference count 为1，接着，我们可以使用ratain增加reference count
```
[anObject retain];
```

反之就用 release

```
[anObject release];
````

我们可以使用retainCount检查某个对象被retain了多少次
```
NSLog(@"Reatin count:%d",[anObject retainCount]);
id a = [[NSObject alloc] init];
[a release];
[a release];//EXC_BAD_ACCESS

id a = [[NSObject alloc] init];
id b = [[NSObject alloc] init];
b = a;
[a release];
[b release];//EXC_BAD_ACCESS
```
b 原来指向的对象没有被释放，内存泄漏

### Auto-release
有一个返回Objective-C对象的method
```
- (NSNumber *)one {
    return [[NSNumber alloc] initWithInt:1];
}
```
每次由这个method产生的对象，用完之后都要release这个对象，容易造成疏忽，我们让这个对象回传auto-release对象
```
- (NSNumber *)one {
    return [[[NSNumber alloc] initWithInt:1] autorelease] ;
}
```
所谓的autorelease就是在这一轮的Run loop中我们先不释放这个对象，在这一轮的run loop中都可以使用，先打上一个标签，到了下一轮run loop开始时，让runtime判断有哪些前一轮被标成auto-release的对象，这个时候才减少retain count 决定是否要释放对象

### 基本原则
* 如果是init、new、copy这些method产生的对象，用完就应该呼叫release,
* 如果是其它一般method产生出来的对象，就会回传auto-release对象、或是Singleton对象,就不需要呼叫release
* 如果在一般的程序代码中用了某个对象，用完就要release 或是auto-release，
* 如果是要将某个Objective-C对象，变成另外一个对象的成员变量，就要将对象先retain，但是delegate对象是不应该retain;
* 一个对象在释放的时候同时要释放自己的成员变量，也就是要在操作dealloc的时候，释放自己的成员变量。
* 要将某个对象设置为另一个对象的成员变量，需要写一组getter/setter。
### getter/setter 与property
getter就是用来获取对象的成员变量的方法，
setter是用来设置成员变量的方法。
如果是C的类型getter ,setter如下
```
@interface MyClass:NSObject {
    int number;
}
-(int)number;
-(void)setNumber:(int)inNumber;
@end
```
成员变量是number，getter方法为number;
setter 方法为setNumber: ,
操作则是
```
- (int)number {
  return number;
}
- (void)setNumber:(int)inNumber {
  number - inNumber;
}
```
如果是Objective-C对象，我们就要将原本成员变量指向的记忆位释放，然后将传入的对象retain起来；
```
- (id)myVar {
  return myVar;
}
- (void)setMyVar:(id)inMyVar {
  id tem = myVar;
  myVar = [inMyVar retain];
  [tem release];
}
```
property  可以直接生成getter setter 方法，

## 自动内存管理（ARC）
ARC禁止使用retain ,release, auto-release ，由编译器决定应该在哪些地方加入retain、release.
### 循环retain 
就是A对象本身retain了B对象，但是B对象又retain了A对象，结果我们在释放A的时候才有办法释放B，但是释放B 又必需先释放A。
这些状况可能出现在
1. 把delegate设为strong reference，
2. 对象的某个property是一个block，但是在这个block中把对象自己retain了一份。
3. 使用timer的时候，到了dealloc 的时候才停止timer
### Toll-Free Bridged
Foundation里面的每个对象，都有对应的C操作（Core Foundation）,当我们在使用Core Foundation里面的C 类型的时候，像CFString、CFArray等，我们可以让这些对象接受ARC管理。
让Core Foundation对象可以被当作Objective-C对象，接受ARC内存管理的方式叫做Toll-Free Bridge。
Toll-Free Bridged 有三个关键字 他们都会把Core Foundation  的对象转换为Objective-C对象，
__bridge    不会多retain 与release;
__bridge_retained  会做一次retain ，但之后必需由我们自己手动呼叫CFRelease释放记忆内存
__bridge_transfer  让ARC主动retain与release。

### 内存警告
当系统内存不够的时候，会给我们的应用发送内存警告，我们可以在UIViewController 的didReceiveMemoryWarning:的method,
在内存不足时释放不在最前面的View Controller 的view 释放掉。
UIViewController与View的关系。
UIViewController 的主要property 是UIView ,是用Lazy Loading 的方式操作的，即在要使用的时候才会去创建，创建VIew 会呼叫loadView，在View加载之后呼叫viewDidLoad

在didReceiveMemoryWaring:中做的操作
```
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil) {
        self.view = nil;
    }
}
```
