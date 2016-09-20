//
//  KVOVC.m
//  Objective-C
//
//  Created by xianghaitao on 16/6/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "KVOVC.h"

@interface KVOVC () {
  int key_4;
}
@property(nonatomic, strong) NSString *key_1;
@property(nonatomic, strong) NSString *test;
@property(nonatomic, assign) NSInteger key_2;
@property(nonatomic, strong) KVOVC *key3;
@property(nonatomic, assign) CGRect rectFrame;
@property(nonatomic, strong) KVOVC *child;
@property(nonatomic, strong) UIButton *changeValueButton;

@end

@implementation KVOVC

#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.child = [KVOVC new];
  [self addChildObserver];
  [self initSubviews];
  //  [self kvcSetValues];
  //  [self collectionOperation];
  //  [self objectOperation];
  // Do any additional setup after loading the view.
}

- (void)initSubviews {
  _changeValueButton =
      [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 150, 50)];
  [_changeValueButton.layer setCornerRadius:4.0];
  [_changeValueButton setTitle:@"changeValue" forState:UIControlStateNormal];
  _changeValueButton.backgroundColor = [UIColor redColor];
  [self.view addSubview:_changeValueButton];
  [_changeValueButton addTarget:self
                         action:@selector(changeKey1)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
  [_child removeObserver:self forKeyPath:@"key_1"];
}

#pragma mark - event response

- (void)changeKey1 {
  [self.child setValue:@"ssss" forKey:@"key_1"];
  [self.child setValue:@"ssssss" forKeyPath:@"key_1"];
}

#pragma mark - private method
- (void)kvcSetValues {
  //  set Dictionary
  NSDictionary *dict = @{ @"key_1" : @"sss", @"key_2" : @200, @"sss" : @"sss" };
  [self setValuesForKeysWithDictionary:dict];

  //    set Key keyPath
  [self setValue:@"ssss" forKey:@"key_1"];
  [self setValue:@100 forKey:@"key_2"];
  [self setValue:[KVOVC new] forKey:@"key3"];
  [self setValue:@3 forKey:@"key_4"];
  [self setValue:@4 forKeyPath:@"key3.key_4"];
  [self setValue:@"ss" forKeyPath:@"key3.test"];
  [self setValue:@"ss" forKey:@"sss"];

  //    setNil  set  nil
  [self setValue:nil
          forKey:@"key3"]; //不进入setNilValueForKey 会调用 setter方法
  [self setNilValueForKey:@"key3"];
  self.key3 = nil; //不进入setNilValueForKey

  //  NSValue
  NSValue *frameValue = [NSValue valueWithCGRect:CGRectMake(10, 20, 11, 12)];
  [self setValue:frameValue forKey:@"rectFrame"];
}

#pragma mark - override methods
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  NSLog(@"value= %@,key = %@", value, key);
}

- (void)setNilValueForKey:(NSString *)key {
  if ([key isEqualToString:@"key3"]) {

  } else {
    [super setNilValueForKey:key];
  }
  NSLog(@"nil key == %@", key);
}

- (BOOL)validateValue:(inout id _Nullable __autoreleasing *)ioValue
               forKey:(NSString *)inKey
                error:(out NSError *_Nullable __autoreleasing *)outError {
  if ([inKey isEqualToString:@"key3"] && *ioValue == nil) {
    if (outError != NULL) {
      NSString *errorString = NSLocalizedString(
          @"A Person's name must be at least two characters long",
          @"validation: key3, could not be null");
      NSDictionary *userInfoDict = @{NSLocalizedDescriptionKey : errorString};
      *outError = [[NSError alloc] initWithDomain:@"key3 null error"
                                             code:404
                                         userInfo:userInfoDict];
    }
    return NO;
  }
  return YES;
}

#pragma mark - collection Operators
#pragma mark simple collection Operation
- (void)collectionOperation {
  //    语法 keyPath
  //    的值为keypathToCollection.@collectionOperator.keypathToProperty
  //    除了@count 其他的都需要 keypathToProperty

  NSArray *arr = @[ @12, @13, @14, @14, @15, @100 ];
  NSNumber *max = [arr valueForKeyPath:@"@max.doubleValue"];
  NSNumber *min = [arr valueForKeyPath:@"@min.doubleValue"];
  NSNumber *avg = [arr valueForKeyPath:@"@avg.doubleValue"];
  NSNumber *count = [arr valueForKeyPath:@"@count"];
  NSNumber *sum = [arr valueForKeyPath:@"@sum.doubleValue"];
}

#pragma mark Object Operators
- (void)objectOperation {
  NSArray *arr = @[ @12, @13, @14, @14, @15, @100 ];
  NSArray *distinctArr =
      [arr valueForKeyPath:@"@distinctUnionOfObjects.doubleValue"];
  NSArray *unionArr = [arr valueForKeyPath:@"@unionOfObjects.doubleValue"];
}

#pragma mark - getter and setter
- (void)setKey3:(KVOVC *)key3 {
  [self validateValue:&key3 forKey:@"key3" error:nil];
  _key3 = key3;
}

#pragma mark - KVO
#pragma mark addObserver
- (void)addChildObserver {
  [_child
      addObserver:self
       forKeyPath:@"key_1"
          options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
          context:NULL];
}

#pragma mark implementation
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *, id> *)change
                       context:(void *)context {
  if ([keyPath isEqual:@"key_1"]) {
    NSLog(@"oldValue = %@,newValue = %@",
          [change objectForKey:NSKeyValueChangeOldKey],
          [change objectForKey:NSKeyValueChangeNewKey]);
  }
}

@end
