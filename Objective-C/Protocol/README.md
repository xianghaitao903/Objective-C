# protocol
## 简介
delegate 就是将多个callback集中在一个物体上，所谓的callback是指，当我们呼叫了一个function或method之后可能会划伤很多时间，我们并不要求马上得到传回结果，而是等到一段时间过后，计算结果才回透过另外一个function/method传回来
语法
我们可以在对象的头文件或单独的文件中声明
中声明protocol。如法如下
```
#import <UIKit/UIKit.h>
@protocol TestProtocol <NSObject>
@required
- (void)method01;
- (void)method02;
@optional
- (void)method03;
- (void)method04;
@end

@interface MyButton : UIButton

@property(nonatomic, weak) id<TestProtocol> delegate;
@end

//协议可以对象本身实现，也可以给其他对象实现
@interface MyObject : UIButton
<TestProtocol>
@end

MyObject *object = [MyObject new];
  MyButton *myButton = [MyButton new];
  myButton.delegate = Object;
```

@required 下面的方法MyObject 必需全部实现
@optional 下面的方法MyObject 可以不用实现
> 注意
Delegate对象不应该指定Class，我们将delegate 声明成id<TestProtocol> delegate; 意思是不需要管这个对象属于哪一个class，只要是Objective-C对象即可，这个对象必须实现TestProtocol协议。delegate 对象是什么class不重要，重要的是有没有我们想要呼叫的method.
Delegate对象属性应该用weak，而非Strong
需要设计delegate的对象，往往其delegate的成员变量。用strong会造成循环引用。

## Delegate Method的命名方法
delegate method，至少会穿入一个参数，就是把到底是谁呼叫这个delegate method传进来。同时这个method也往往以传入的class的名称开头，让我们可以辨别这是属于哪个class的delegate，例如：
```
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
```
