//
//  ViewController.m
//  Objective-C
//
//  Created by xianghaitao on 16/6/21.
//  Copyright © 2016年 xianghaitao. All rights reserved.
//

#import "BlockVC.h"
#import "CategoryVC.h"
#import "KVOVC.h"
#import "NotificationVC.h"
#import "ProtocolVC.h"
#import "SelectorVC.h"
#import "ThreadVC.h"
#import "ViewController.h"

@interface ViewController ()

@property(nonatomic, strong) NSArray *cellTitleArr;

@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
  [super viewDidLoad];
  self.title = @"Objective-C";
  self.tableView.tableFooterView = [UIView new];
    [self addNotification];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UIViewController *detailVC;
  NSInteger row = indexPath.row;
  switch (row) {
  case 0:
    detailVC = [SelectorVC new];
    break;
  case 1:
    detailVC = [CategoryVC new];
    break;
  case 2:
    detailVC = [ProtocolVC new];
    break;
  case 3:
    detailVC = [BlockVC new];
    break;
  case 4:
    detailVC = [NotificationVC new];
    break;
  case 5:
    detailVC = [KVOVC new];
    break;
  case 6:
    detailVC = [ThreadVC new];
    break;
  default:
    break;
  }
  detailVC.title = self.cellTitleArr[row];
  detailVC.view.backgroundColor = [UIColor whiteColor];
  [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - tableView datasoure
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return self.cellTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellId = @"cellId";
  UITableViewCell *cell =
      [self.tableView dequeueReusableCellWithIdentifier:cellId];
  if (!cell) {
    cell = [UITableViewCell new];
  }
  cell.textLabel.text = self.cellTitleArr[indexPath.row];
  return cell;
}

#pragma mark - private methods 
- (void)addNotification {
    NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
    [notification addObserver:self selector:@selector(valueChanged:) name:@"testName" object:nil];
}

- (void)valueChanged:(NSNotification *)notification {
    NSLog(@"--------");
}


#pragma getter and setter
- (NSArray *)cellTitleArr {
  if (!_cellTitleArr) {
    _cellTitleArr = @[
      @"selector",
      @"Category",
      @"protocol",
      @"Block",
      @"Notification",
      @"KVO/KVC",
      @"Thread"
    ];
  }
  return _cellTitleArr;
}

@end
