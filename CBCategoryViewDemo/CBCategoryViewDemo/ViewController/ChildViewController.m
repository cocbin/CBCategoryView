//
// Created by Cocbin on 16/5/27.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "ChildViewController.h"
#import "ChildViewModel.h"
#import "GoodsCell.h"

#define BACKGROUND_COLOR [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.00]
#define  IDENTIFIER_OF_GOODS_CELL @"IDENTIFIER_OF_GOODS_CELL"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation ChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)viewDidLayoutSubviews {
    [self collectionView];
}


- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.backgroundColor = BACKGROUND_COLOR;
        [_collectionView setContentInset:UIEdgeInsetsMake(8,4,8,4)];
        [_collectionView registerClass:[GoodsCell class] forCellWithReuseIdentifier:IDENTIFIER_OF_GOODS_CELL];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (ChildViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[ChildViewModel alloc] init];
    }
    return _viewModel;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.goods.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodsCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:IDENTIFIER_OF_GOODS_CELL forIndexPath:indexPath];
    NSDictionary * goods = self.viewModel.goods[(NSUInteger) indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:goods[@"image"]]];
    [cell.nameView setText:goods[@"name"]];
    [cell.priceView setText:[NSString stringWithFormat:@"￥%@",goods[@"price"]]];
    cell.addToShoppingCart = ^(UIImageView * imageView, CGPoint clickPosition) {
        // do something
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH / 2 - 6, SCREEN_WIDTH / 2 - 6 + 80);
}

@end