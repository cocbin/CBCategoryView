//
//  CBCategoryView.m
//  CBViews
//
//  Created by Cocbin on 16/5/25.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "CBCategoryView.h"

#pragma mark -- default value
#define CELL_WIDTH 100
#define COLLECTION_ONE_LINE_COUNT 3
#pragma mark -- color
#define CB_CATEGORY_RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define COLOR_TEXT_NORMAL  CB_CATEGORY_RGB(147,157,147)
#define COLOR_TEXT_SELECT CB_CATEGORY_RGB(0,0,0)
#define COLOR_BOTTOM_SHADOWS CB_CATEGORY_RGB(233,233,233)
#define COLOR_CELL_NORMAL [UIColor whiteColor]
#define COLOR_CELL_HL CB_CATEGORY_RGB(243,243,243)
#define COLOR_TRIANGLE_BG_NORMAL COLOR_CELL_HL
#define COLOR_TRIANGLE_BG_HL CB_CATEGORY_RGB(230,230,230)
#pragma mark -- cell identifier
#define COLLECTION_VIEW_CELL @"LabelCollectionCell"

#pragma mark -- Triangle

@interface CBTriangle : UIControl
@end

@implementation CBTriangle
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint sPoints[3];
    sPoints[0] = CGPointMake(17, 18);
    sPoints[1] = CGPointMake(23, 18);
    sPoints[2] = CGPointMake(20, 22);
    CGContextSetRGBFillColor(context, 0.7, 0.7, 0.7, 1);
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 1);
    CGContextAddLines(context, sPoints, 3);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}
@end

#pragma mark -- Cell

@interface LabelCollectionCell : UICollectionViewCell
@property UILabel * label;
@end

@implementation LabelCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor whiteColor];
        _label.layer.borderColor = [COLOR_BOTTOM_SHADOWS CGColor];
        _label.layer.borderWidth = 0.25;
        _label.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label];
    }
    return self;
}
@end

#pragma mark -- CBCategoryView

@interface CBCategoryView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UIScrollView * scrollView;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, assign) bool showSubMenu;

@property(weak, nonatomic) UIViewController * superController;
@property(nonatomic, retain) NSMutableDictionary * childControllers;
//@property(nonatomic, copy) UIViewController * (^getChildController)(CBCategoryView *, NSInteger);

@end

@implementation CBCategoryView {
    CGFloat _centerOfScrollView;
    NSMutableArray * _btnList;
    CBTriangle * _triangle;
    UIControl * _backgroundView;
    UICollectionView * _collectionView;
    UIView * _triangleBackgroundView;
    CGFloat _collectionViewHeight;
    UIViewController * _currentController;
    NSArray * _category;

    UIView * subViewOfController;

    NSString * (^decodeDataBlock)(id);
    UIViewController * (^_childController)(NSUInteger, id);
}

- (instancetype)initWithPosition:(CGPoint)position andHeight:(CGFloat)height {
    CGFloat triangleViewWidth = 40;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.height = height;
    self = [super initWithFrame:CGRectMake(position.x, position.y, screenSize.width, height)];
    _centerOfScrollView = (screenSize.width - triangleViewWidth - CELL_WIDTH) / 2;
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width - triangleViewWidth, height)];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];

        _triangle = [[CBTriangle alloc] initWithFrame:CGRectMake(screenSize.width - triangleViewWidth, (height-40)/2, triangleViewWidth, 40)];
        _triangle.backgroundColor = [UIColor clearColor];
        [_triangle addTarget:self action:@selector(clickTriangle) forControlEvents:UIControlEventTouchUpInside];
        _triangleBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(_triangle.frame.origin.x,0,triangleViewWidth,height)];
        _triangleBackgroundView.backgroundColor = COLOR_TRIANGLE_BG_NORMAL;
        UIView * _triangleBorderView = [[UIView alloc] initWithFrame:
                CGRectMake(_triangleBackgroundView.frame.origin.x, _triangleBackgroundView.frame.origin.y, 1, height)];
        _triangleBorderView.backgroundColor = COLOR_BOTTOM_SHADOWS;
        [self addSubview:_triangleBackgroundView];
        [self addSubview:_triangle];
        [self addSubview:_triangleBorderView];

        UIView * bottomShadows = [[UIView alloc] initWithFrame:CGRectMake(0, (CGFloat) (height - 1), screenSize.width, 1)];
        bottomShadows.backgroundColor = COLOR_BOTTOM_SHADOWS;
        [self addSubview:bottomShadows];

        _backgroundView = [[UIControl alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + height, screenSize.width, screenSize.height)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backgroundView.opaque = NO;
        [_backgroundView addTarget:self action:@selector(clickTriangle) forControlEvents:UIControlEventTouchUpInside];

        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake((CGFloat) (screenSize.width / COLLECTION_ONE_LINE_COUNT), 36);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(position.x, (CGFloat) (position.y + height - 0.25), screenSize.width, 0) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[LabelCollectionCell class] forCellWithReuseIdentifier:COLLECTION_VIEW_CELL];
        self.showSubMenu = NO;
        self.selectedIndex = 0;
    }
    return self;
}

- (void)initScrollView {
    //clear button
    for (UIView * v in self.scrollView.subviews) {
        [v removeFromSuperview];
    }

    //clear child view controller
    if (_childControllers && _superController) {
        for (UIViewController * child in _childControllers) {
            [child.view removeFromSuperview];
            [child removeFromParentViewController];
        }
    }
    _childControllers = nil;
    _childControllers = [[NSMutableDictionary alloc] init];

    _btnList = nil;
    _btnList = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < _category.count; ++ i) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * CELL_WIDTH, 0, CELL_WIDTH, self.height)];
        NSString * title;
        if (decodeDataBlock) {
            title = decodeDataBlock(_category[(NSUInteger) i]);
        } else {
            NSAssert([_category[(NSUInteger) i] isKindOfClass:[NSString class]],
                    @"[CBCategoryView Error]:data is not a string , "
                            "please post a String Array or use decodeData() to decode data.");
            title = _category[(NSUInteger) i];
        }

        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:1000 + i];
        [_btnList addObject:btn];
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(_category.count * CELL_WIDTH, self.height);
}

- (void)initView {
    _selectedIndex = 0;

    UIButton * currentBtn = _btnList[0];
    [currentBtn setTitleColor:COLOR_TEXT_SELECT forState:UIControlStateNormal];
    currentBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (_childController && self.superController && _category.count > 0) {
            UIViewController * childViewController = _childController(0, _category[0]);
            _childControllers[@(0)] = childViewController;
            [self.superController addChildViewController:childViewController];
            [self.superController.view bringSubviewToFront:self];
            [childViewController.view setFrame:subViewOfController.bounds];
            [subViewOfController addSubview:childViewController.view];
            _currentController = childViewController;
        }
    });
}

- (void)selectCategory:(UIView *)sender {
    NSInteger index = sender.tag - 1000;
    self.selectedIndex = (NSUInteger) index;
}

- (void)clickTriangle {
    self.showSubMenu = ! self.showSubMenu;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    static BOOL animating = NO;

    if (animating) {
        return;
    }

    if (selectedIndex == _selectedIndex) {
        return;
    }
    if (self.showSubMenu) {
        self.showSubMenu = NO;
    }

    [_collectionView reloadData];

    UIButton * lastBtn = _btnList[_selectedIndex];
    UIButton * currentBtn = _btnList[selectedIndex];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [lastBtn setTitleColor:COLOR_TEXT_NORMAL forState:UIControlStateNormal];
    lastBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [currentBtn setTitleColor:COLOR_TEXT_SELECT forState:UIControlStateNormal];
    currentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.scrollView.contentOffset = CGPointMake(selectedIndex * CELL_WIDTH - _centerOfScrollView, 0);
    [UIView commitAnimations];

    _selectedIndex = selectedIndex;

    if (_childController && self.superController) {
        animating = YES;
        UIViewController * nextController;
        if (_childControllers[@(selectedIndex)]) {
            nextController = _childControllers[@(selectedIndex)];
        } else {
            UIViewController * childViewController = _childController(selectedIndex,_category[selectedIndex]);
            _childControllers[@(selectedIndex)] = childViewController;
            nextController = childViewController;
            [childViewController.view setFrame:subViewOfController.bounds];
            [self.superController addChildViewController:childViewController];
        }
        [self.superController transitionFromViewController:_currentController
                                     toViewController:_childControllers[@(selectedIndex)] duration:0.3
                                              options:UIViewAnimationOptionTransitionCrossDissolve
                                           animations:nil
                                           completion:^(BOOL finish) {
                                               animating = ! finish;
                                           }];
        _currentController = nextController;

    }
}

- (void)setShowSubMenu:(bool)showSubMenu {
    if (showSubMenu == _showSubMenu) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^() {
        if (showSubMenu) {
            _triangle.transform = CGAffineTransformMakeRotation((CGFloat) M_PI);
            [self.superview addSubview:_backgroundView];
            [self.superview addSubview:_collectionView];
            CGRect frame = _collectionView.frame;
            frame.size.height = _collectionViewHeight;
            [UIView animateWithDuration:0.2 animations:^{
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
                _collectionView.frame = frame;
                _triangleBackgroundView.backgroundColor = COLOR_TRIANGLE_BG_HL;
            }];
        } else {
            _triangle.transform = CGAffineTransformMakeRotation((CGFloat) (M_PI * 2.0f));
            CGRect frame = _collectionView.frame;
            frame.size.height = 0;
            [UIView animateWithDuration:0.2 animations:^{
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
                _collectionView.frame = frame;
                _triangleBackgroundView.backgroundColor = COLOR_TRIANGLE_BG_NORMAL;
            }                completion:^(BOOL finish) {
                [_backgroundView removeFromSuperview];
                [_collectionView removeFromSuperview];
            }];
        }
    }                completion:^(BOOL finish) {
        if (! showSubMenu) {
            _triangle.transform = CGAffineTransformMakeRotation(0);
        }
    }];
    _showSubMenu = showSubMenu;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _category.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LabelCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_VIEW_CELL forIndexPath:indexPath];
    NSString * title;
    if (decodeDataBlock) {
        title = decodeDataBlock(_category[(NSUInteger) indexPath.row]);
    } else {
        NSAssert([_category[(NSUInteger) indexPath.row] isKindOfClass:[NSString class]],
                @"[CBCategoryView Error]:data is not a string , "
                        "please post a String Array or use decodeData() to decode data.");
        title = _category[(NSUInteger) indexPath.row];
    }
    cell.label.text = title;
    if (_selectedIndex == indexPath.row) {
        cell.label.backgroundColor = COLOR_CELL_HL;
        cell.label.textColor = COLOR_TEXT_SELECT;
    } else {
        cell.label.backgroundColor = COLOR_CELL_NORMAL;
        cell.label.textColor = COLOR_TEXT_NORMAL;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = (NSUInteger) indexPath.row;
}

- (CBCategoryView * (^)(UIViewController*))controller {
    return ^CBCategoryView *(UIViewController * vc) {
        self.superController = vc;
        CGRect frame = vc.view.bounds;
        frame.origin.y = self.frame.origin.y + self.frame.size.height;
        frame.size.height -= frame.origin.y;
        subViewOfController = [[UIView alloc] initWithFrame:frame];
        [vc.view addSubview:subViewOfController];
        return self;
    };
}


- (CBCategoryView * (^)(NSArray *))data {
    return ^CBCategoryView *(NSArray * array) {
        _category = array;
        return self;
    };
}

- (CBCategoryView * (^)(NSString * (^)(id)))decodeData {
    return ^CBCategoryView *(NSString * (^pFunction)(id)) {
        decodeDataBlock = pFunction;
        return self;
    };
}

- (CBCategoryView * (^)(UIViewController * (^)(NSUInteger, id)))childControllerAdapter {
    return ^CBCategoryView *(UIViewController * (^pFunction)(NSUInteger, id)) {
        _childController = pFunction;
        return self;
    };
}

- (CBCategoryView * (^)())reloadData {
    return ^CBCategoryView * {
        _collectionViewHeight = ((_category.count - 1) / COLLECTION_ONE_LINE_COUNT + 1) * 36;
        [self initScrollView];
        [self initView];
        return self;
    };
}


@end