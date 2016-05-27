//
//  ViewController.m
//  CBCategoryViewDemo
//
//  Created by Cocbin on 16/5/27.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "ViewController.h"
#import "ChildViewController.h"
#import <CBCategoryView/CBCategoryView.h>

@interface ViewController ()

@property (nonatomic, retain) NSArray * category;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"DEMO";
    CBCategoryView * categoryView = [[CBCategoryView alloc] initWithPosition:CGPointMake(0,64) andHeight:40];
    [self.view addSubview:categoryView];
    [categoryView dataSource:self.category];
    [categoryView controller:self
      getChildViewController:^(CBCategoryView * cbCategoryView, NSInteger index) {
          ChildViewController * childViewController = [[ChildViewController alloc] init];
          childViewController.param = self.category[(NSUInteger) index];
          return childViewController;
      }];
}

- (NSArray *) category {
    if(!_category) {
        _category = @[@"苹果",@"香蕉",@"梨子",@"西瓜",@"芒果",@"蜜桃",@"橙子",@"菠萝",@"葡萄"];
    }
    return _category;
}

@end
