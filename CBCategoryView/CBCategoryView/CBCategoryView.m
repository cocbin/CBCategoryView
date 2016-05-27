//
//  CBCategoryView.m
//  CBViews
//
//  Created by Cocbin on 16/5/25.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "CBCategoryView.h"

#define CELL_WIDTH 100
#define TEXT_NORMAL_COLOR  [UIColor colorWithRed:147/255.0 green:157/255.0 blue:147/255.0 alpha:1]
#define TEXT_SELECT_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:1]
#define BOTTOM_SHADOWS_COLOR [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1]
#define COLLECTION_CELL_HEIGHT_LIGHT_COLOR [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]
#define TRIANGLE_BG_COLOR_NORMAL [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1]
#define TRIANGLE_BG_COLOR_HL [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]

#define COLLECTION_CELL_NORMAL_COLOR [UIColor whiteColor]

#define COLLECTION_ONE_LINE_COUNT 3

#define COLLECTION_VIEW_CELL @"LabelCollectionCell"


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
    CGContextSetRGBStrokeColor(context,0.7, 0.7, 0.7, 1);
    CGContextAddLines(context, sPoints, 3);//添加线
    CGContextClosePath(context);//封起来
    CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
}
@end


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
        _label.layer.borderColor = [BOTTOM_SHADOWS_COLOR CGColor];
        _label.layer.borderWidth = 0.25;
        _label.font = [UIFont systemFontOfSize:14];
        [self addSubview:_label];
    }
    return self;
}
@end


@interface CBCategoryView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) UIScrollView * scrollView;
@property(nonatomic, retain) NSArray * category;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, assign) bool showSubMenu;

@property (weak, nonatomic)UIViewController * controller;
@property (nonatomic, retain) NSMutableDictionary * childControllers;
@property (nonatomic, copy) UIViewController * (^getChildController)(CBCategoryView *,NSInteger);

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
}

- (instancetype)initWithPosition:(CGPoint)position andHeight:(CGFloat)height {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.height = height;
    self = [super initWithFrame:CGRectMake(position.x, position.y, screenSize.width, height)];
    _centerOfScrollView = (screenSize.width - 40 - CELL_WIDTH) / 2;
    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width - 40, height)];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];

        _triangle = [[CBTriangle alloc] initWithFrame:CGRectMake(screenSize.width - 40, 0, 40, height)];
        _triangle.backgroundColor = [UIColor clearColor];
        [_triangle addTarget:self action:@selector(clickTriangle) forControlEvents:UIControlEventTouchUpInside];

        _triangleBackgroundView = [[UIView alloc] initWithFrame:_triangle.frame];
        _triangleBackgroundView.backgroundColor = TRIANGLE_BG_COLOR_NORMAL;

        UIView * _triangleBorderView = [[UIView alloc] initWithFrame:
                CGRectMake(_triangle.frame.origin.x,_triangle.frame.origin.y,1,height)];
        _triangleBorderView.backgroundColor = BOTTOM_SHADOWS_COLOR;

        [self addSubview:_triangleBackgroundView];
        [self addSubview:_triangle];
        [self addSubview:_triangleBorderView];
        UIView * bottomShadows = [[UIView alloc] initWithFrame:CGRectMake(0, (CGFloat) (height - 1), screenSize.width, 1)];
        bottomShadows.backgroundColor = BOTTOM_SHADOWS_COLOR;
        [self addSubview:bottomShadows];

        _backgroundView = [[UIControl alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + height, screenSize.width, screenSize.height)];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
        _backgroundView.opaque = NO;
        [_backgroundView addTarget:self action:@selector(clickTriangle) forControlEvents:UIControlEventTouchUpInside];

        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.itemSize = CGSizeMake((CGFloat) (screenSize.width / COLLECTION_ONE_LINE_COUNT), 36);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(position.x, (CGFloat) (position.y + height -0.25), screenSize.width, 0) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[LabelCollectionCell class] forCellWithReuseIdentifier:COLLECTION_VIEW_CELL];
        self.showSubMenu = NO;
        self.selectedIndex = 0;
    }
    return self;
}

- (void)dataSource:(NSArray *)dataSource {
    self.category = dataSource;
    _collectionViewHeight = ((self.category.count-1) / COLLECTION_ONE_LINE_COUNT + 1) * 36;
    [self initScrollView];
    [self initView];
}

- (void)initScrollView {
    //clear button
    for (UIView * v in self.scrollView.subviews) {
        [v removeFromSuperview];
    }

    //clear child view controller
    if(_childControllers&&_controller) {
        for(UIViewController * child in _childControllers) {
            [child.view removeFromSuperview];
            [child removeFromParentViewController];
        }
    }
    _childControllers = nil;
    _childControllers = [[NSMutableDictionary alloc] init];

    _btnList = nil;
    _btnList = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < self.category.count; ++ i) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * CELL_WIDTH, 0, CELL_WIDTH, self.height)];
        [btn setTitle:self.category[(NSUInteger) i] forState:UIControlStateNormal];
        [btn setTitleColor:TEXT_NORMAL_COLOR forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(selectCategory:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:1000 + i];
        [_btnList addObject:btn];
        [self.scrollView addSubview:btn];
    }
    self.scrollView.contentSize = CGSizeMake(self.category.count * CELL_WIDTH, self.height);
}

- (void) initView {
    _selectedIndex = 0;

    UIButton * currentBtn = _btnList[0];
    [currentBtn setTitleColor:TEXT_SELECT_COLOR forState:UIControlStateNormal];
    currentBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController * childViewController = self.getChildController(self,0);
        _childControllers[@(0)] = childViewController;
        [self.controller addChildViewController:childViewController];
        CGRect frame = childViewController.view.frame;
        frame.origin.y = self.frame.origin.y+self.height;
        childViewController.view.frame = frame;
        [self.controller.view addSubview:childViewController.view];
        _currentController = childViewController;
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
    [lastBtn setTitleColor:TEXT_NORMAL_COLOR forState:UIControlStateNormal];
    lastBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [currentBtn setTitleColor:TEXT_SELECT_COLOR forState:UIControlStateNormal];
    currentBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.scrollView.contentOffset = CGPointMake(selectedIndex * CELL_WIDTH - _centerOfScrollView, 0);
    [UIView commitAnimations];
    if(_changeSelelct) {
        _changeSelelct(selectedIndex);
    }
    _selectedIndex = selectedIndex;

    // change sub view controller

    if(self.getChildController&&self.controller) {
        if(_childControllers[@(selectedIndex)]) {
            [self.controller transitionFromViewController:_currentController
                                         toViewController:_childControllers[@(selectedIndex)] duration:0.2
                                                  options:UIViewAnimationOptionTransitionNone
                                               animations:nil
                                               completion:nil];
            _currentController = _childControllers[@(selectedIndex)];
        } else {
            UIViewController * childViewController = self.getChildController(self,selectedIndex);
            _childControllers[@(selectedIndex)] = childViewController;
            [self.controller addChildViewController:childViewController];
            CGRect frame = childViewController.view.frame;
            frame.origin.y = self.frame.origin.y+self.height;
            childViewController.view.frame = frame;
            [self.controller transitionFromViewController:_currentController
                                         toViewController:_childControllers[@(selectedIndex)] duration:0.2
                                                  options:UIViewAnimationOptionTransitionNone
                                               animations:nil
                                               completion:nil];
            _currentController = childViewController;
        }
    }
}

- (void)setShowSubMenu:(bool)showSubMenu {
    if (showSubMenu == _showSubMenu) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^() {
        if (showSubMenu) {
            _triangle.transform = CGAffineTransformMakeRotation(M_PI);
            [self.superview addSubview:_backgroundView];
            [self.superview addSubview:_collectionView];
            CGRect frame = _collectionView.frame;
            frame.size.height = _collectionViewHeight;
            [UIView animateWithDuration:0.2 animations:^{
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.3];
                _collectionView.frame = frame;
                _triangleBackgroundView.backgroundColor = TRIANGLE_BG_COLOR_HL;
            }];
        } else {
            _triangle.transform = CGAffineTransformMakeRotation(M_PI * 2);
            CGRect frame = _collectionView.frame;
            frame.size.height = 0;
            [UIView animateWithDuration:0.2 animations:^{
                _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0];
                _collectionView.frame = frame;
                _triangleBackgroundView.backgroundColor = TRIANGLE_BG_COLOR_NORMAL;
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


- (NSArray *)category {
    if (_category == nil) {
        _category = @[@"类别1", @"类别2", @"类别3", @"类别4", @"类别5", @"类别5"];
    }
    return _category;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _category.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LabelCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:COLLECTION_VIEW_CELL forIndexPath:indexPath];
    cell.label.text = _category[(NSUInteger) indexPath.row];
    if(_selectedIndex == indexPath.row) {
        cell.label.backgroundColor = COLLECTION_CELL_HEIGHT_LIGHT_COLOR;
        cell.label.textColor = TEXT_SELECT_COLOR;
    } else {
        cell.label.backgroundColor = COLLECTION_CELL_NORMAL_COLOR;
        cell.label.textColor = TEXT_NORMAL_COLOR;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = (NSUInteger) indexPath.row;
}

- (void)controller:(UIViewController *)controller getChildViewController:(UIViewController * (^)(CBCategoryView * ,NSInteger))delegate {
    self.controller = controller;
    self.getChildController = delegate;
}

@end