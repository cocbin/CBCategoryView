//
// Created by Cocbin on 16/5/28.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "GoodsCell.h"
#import <Masonry/Masonry.h>
#import "CBIconfont.h"


#define COLOR_GOODS_NAME [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.00]
#define COLOR_ADD_TO_SHOPPING_CART_ICON [UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1.00]
#define COLOR_GOODS_PRICE [UIColor colorWithRed:0.92 green:0.40 blue:0.25 alpha:1.00]

@implementation GoodsCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UIImageView *)imageView {
    if(!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(_imageView.mas_width).multipliedBy(1);
        }];
    }
    return _imageView;
}

- (UILabel *)nameView {
    if(!_nameView) {
        _nameView = [[UILabel alloc] init];
        [self addSubview:_nameView];
        _nameView.textColor = COLOR_GOODS_NAME;
        _nameView.numberOfLines = 2;
        _nameView.font = [UIFont systemFontOfSize:14];
        [_nameView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(8);
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-8);
            make.height.offset(36);
        }];
    }
    return _nameView;
}

- (UILabel *)priceView {
    if(!_priceView) {
        _priceView = [[UILabel alloc] init];
        _priceView.font = [UIFont systemFontOfSize:16];
        [self addSubview:_priceView];
        _priceView.textColor = [UIColor blackColor];
        [_priceView mas_makeConstraints:^(MASConstraintMaker * make) {
            make.top.equalTo(self.nameView.mas_bottom).offset(8);
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(8);
            make.height.offset(20);
        }];
        _priceView.textColor = COLOR_GOODS_PRICE;
    }
    return _priceView;
}

- (UIButton *)btnAddToShoppingCart {
    if(!_btnAddToShoppingCart) {
        UIColor * btnColor = COLOR_ADD_TO_SHOPPING_CART_ICON;
        _btnAddToShoppingCart = IFButtonMake(@"ic_add_to_shopping_cart",btnColor,20);
        //_btnAddToShoppingCart =  [[CBIconfont instance] buttonWithIdentify:@"ic_add_to_shopping_cart" color:btnColor size:18];
        [self addSubview:_btnAddToShoppingCart];
        [_btnAddToShoppingCart mas_makeConstraints:^(MASConstraintMaker * make) {
            make.bottom.equalTo(self);
            make.right.equalTo(self);
            make.width.offset(40);
            make.height.offset(40);
        }];
    }
    return _btnAddToShoppingCart;
}

- (UIButton *)btnAddToCollection {
    if(!_btnAddToCollection) {
        UIColor * btnColor = COLOR_ADD_TO_SHOPPING_CART_ICON;
        _btnAddToCollection = IFButtonMake(@"ic_add_to_collection",btnColor,20);
        [self addSubview:_btnAddToCollection];
        [_btnAddToCollection mas_makeConstraints:^(MASConstraintMaker * make) {
            make.bottom.equalTo(self);
            make.right.equalTo(self.btnAddToShoppingCart.mas_left);
            make.width.offset(40);
            make.height.offset(40);
        }];
    }
    return _btnAddToCollection;
}

- (void)setAddToShoppingCart:(void (^)(UIImageView *,CGPoint))addToShoppingCart {
    [self.btnAddToShoppingCart addTarget:self action:@selector(addGoodsToShoppingCart:withEvent:) forControlEvents:UIControlEventTouchUpInside];
    _addToShoppingCart = addToShoppingCart ;
}


- (void)addGoodsToShoppingCart:(UIView *)sender withEvent:(UIEvent *)event {
    UITouch* touch = [[event touchesForView:sender] anyObject];
    CGPoint rootViewLocation = [touch locationInView:self.superview.superview];
    if(self.addToShoppingCart) {
        self.addToShoppingCart(self.imageView,rootViewLocation);
    }
}

@end