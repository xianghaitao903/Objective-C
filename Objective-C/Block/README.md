# Block
## 简介
Block 是Cocoa/Cocoa Touch Framework中的匿名函数，所谓的匿名函数就是一段一段具有对象特性的代码块，这段代码块可以当作函数执行，又可以当作对象传递。因为具有对象特性，所以block可以是某个对象的property，也可以当作method或是function的参数传递。
## 语法
```
returnType (^blockName)(ParameterTypes) = ^returnType(parameters) {...};
//例：
void (^blockName)(NSString *string) = ^void(NSString *string) {
  };
```
### block property的语法
```
@property(nonatomic, copy) returnType (^blockName)(ParameterTypes);
//例：
@property(nonatomic, copy) void (^blockName)(NSString *string);
```

### 作为method的参数
```
- (void)someMethodThatTakesABlock:(returnType (^)(ParameterTypes))blockName;
//调用
[self someMethodThatTakesABlock:^returnType(Parameters){
 }];
//把一种block声明成typedef
typedef returnType (^TypeName)(ParameterTypes);
TypeName type = ^returnType(Parameter*s) {...};
````

## 什么时候使用block与delegate
block 可以大幅度的取代delegate处理callback。如果一个method或function只有单一的callback。那么就用block,如果可能会有多个不同的callback，那么就用delegate。当一个method或function会呼叫多种callback，很可能某些callback是没有必要的。
如果使用delegate操作，我们可以用@required与@optional 关键字来区分哪些是一定要操作的delegate method。但是相对的用block处理callback，就会很难区分某个block是否是必须的。
## __block与__weak 关键字
### __block
在一个block里面如果使用了block之外的变量，会将这个变量先复制一份再使用，也就是说，在没有特别宣告的状况下，对我们目前所在的block来说，所有外部的变量都是只读的。至于block里面用到的Objective-C 对象,则都会被多retain一次。
如果我们想让某个block可以改变某个外部的变量，我们需要在这个变量前面加上__block 关键字
__block NSInteger i = 0;
  void (^block)(void) = ^void(void) {
    i = i + 2;
  };
### __weak
由于block中用到的Objective-C对象都会被多retain一次,这边所指的Objective-C对象也包括self，所以，假使有个对象的property是一个block，而这个block里面又用到了self，就会循环retain,而无法释放记忆内存的问题。self要被释放才会去释放这个property，但是这个property作为block又retain了self，导致self无法被释放。
 __weak typeof(self) weakSelf = self;
  self.block = ^void(void) {
    [weakSelf doSomething];
  };
