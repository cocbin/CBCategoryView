//
// Created by Cocbin on 16/5/27.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "ChildViewController.h"


@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(_param) {
        CGFloat r = (CGFloat) ((arc4random() % 256)/256.0);
        CGFloat g = (CGFloat) ((arc4random() % 256)/256.0);
        CGFloat b = (CGFloat) ((arc4random() % 256)/256.0);
        self.view.backgroundColor = [UIColor colorWithRed:r green:g blue:b alpha:1];
        UILabel * label = [[UILabel alloc] initWithFrame:self.view.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.param;
        [self.view addSubview:label];
    }
}

- (NSString *)param {
    if(!_param) {
        _param = @"Loading";
    }
    return _param;
}

@end