//
//  CBCategoryView.h
//  CBViews
//
//  Created by Cocbin on 16/5/25.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCategoryView : UIView

- (instancetype)initWithPosition:(CGPoint)position andHeight:(CGFloat)height;
- (void) dataSource:(NSArray *)dataSource;
- (void)controller:(UIViewController *)controller getChildViewController:(UIViewController * (^)(CBCategoryView * ,NSInteger))delegate;
@property (nonatomic, copy) void (^changeSelelct)(NSInteger index);
@end
