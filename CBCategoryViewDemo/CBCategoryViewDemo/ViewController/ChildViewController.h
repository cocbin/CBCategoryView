//
// Created by Cocbin on 16/5/27.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChildViewModel;

@interface ChildViewController : UIViewController <
        UICollectionViewDataSource,
        UICollectionViewDelegate>

@property(nonatomic, retain) ChildViewModel * viewModel;
@property(nonatomic, retain) UICollectionView * collectionView;

@end