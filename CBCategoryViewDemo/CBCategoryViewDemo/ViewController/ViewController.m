//
//  ViewController.m
//  CBCategoryViewDemo
//
//  Created by Cocbin on 16/5/27.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "ViewController.h"
#import "ChildViewController.h"
#import "ChildViewModel.h"
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
    categoryView.controller(self)
    .data(self.category)
    .decodeData(^(NSDictionary * data){
        return data[@"name"];
    })
    .childControllerAdapter(^(NSUInteger index,NSDictionary * data){
        ChildViewController * childViewController = [[ChildViewController alloc] init];
        childViewController.viewModel = [[ChildViewModel alloc]init];
        childViewController.viewModel.categoryId = index;
        return childViewController;
    })
    .reloadData();
}

- (NSArray *) category {
    if(!_category) {
        _category = @[
                @{@"name":@"苹果"},
                @{@"name":@"香蕉"},
                @{@"name":@"梨子"},
                @{@"name":@"西瓜"},
                @{@"name":@"芒果"},
                @{@"name":@"蜜桃"},
                @{@"name":@"橙子"},
                @{@"name":@"菠萝"},
                @{@"name":@"葡萄"}];
    }
    return _category;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
