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
@property(nonatomic, weak) KVOVC *key3;
@property(nonatomic, assign) CGRect rectFrame;

@end

@implementation KVOVC

#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  [self kvcSetValues];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (void)kvcSetValues {
  NSDictionary *dict = @{ @"key_1" : @"sss", @"key_2" : @200, @"sss" : @"sss" };
  [self setValuesForKeysWithDictionary:dict];

  [self setValue:@"ssss" forKey:@"key_1"];
  [self setValue:@100 forKey:@"key_2"];
  [self setValue:[KVOVC new] forKey:@"key3"];
  [self setValue:@3 forKey:@"key_4"];
  [self setValue:@4 forKeyPath:@"key3.key_4"];
  [self setValue:@"ss" forKeyPath:@"key3.test"];
  [self setValue:@"ss" forKey:@"sss"];

  [self setValue:nil
          forKey:@"key3"]; //不进入setNilValueForKey 会调用 setter方法
  [self setNilValueForKey:@"key3"];
  self.key3 = nil; //不进入setNilValueForKey

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

#pragma mark - getter and setter
- (void)setKey3:(KVOVC *)key3 {
  [self validateValue:&key3 forKey:@"key3" error:nil];
  _key3 = key3;
}

@end
