//
// Created by Cocbin on 16/5/28.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsCell : UICollectionViewCell

@property (nonatomic, retain) UIImageView * imageView;
@property (nonatomic, retain) UILabel * nameView;
@property (nonatomic, retain) UILabel * priceView;
@property (nonatomic, retain) UIButton * btnAddToCollection;
@property (nonatomic, retain) UIButton * btnAddToShoppingCart;

@property(nonatomic, copy) void(^addToShoppingCart)(UIImageView * goodsImageView,CGPoint clickPosition);

@end