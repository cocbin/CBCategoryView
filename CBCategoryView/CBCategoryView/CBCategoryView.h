//
//  CBCategoryView.h
//  CBViews
//
//  Created by Cocbin on 16/5/25.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCategoryView : UIView

/**
 *    CBCategoryView * categoryView = [[CBCategoryView alloc]init]
 *    .data(array)
 *    .decodeData(^(id category){
 *          return category.name;
 *    })
 *    .childControllerAdapter(^(id category){
 *          return [[ChildViewController alloc]initWithParams:category.id]
 *    });
 *    categoryView.cellWidth(100)
 *    categoryView.cellCount(4)
 *    categoryView.
 */

- (instancetype)initWithPosition:(CGPoint)position andHeight:(CGFloat)height;
- (CBCategoryView * (^)(UIViewController*))controller;
- (CBCategoryView * (^)(NSArray*))data;
- (CBCategoryView * (^)(NSString *(^)(id)))decodeData;
- (CBCategoryView * (^)(UIViewController * (^)(NSUInteger,id)))childControllerAdapter;
- (CBCategoryView * (^)())reloadData;
@end
