# CBCategoryView

### 预览
![demo](./images/demo.gif)

### 用法
通过cocoapods下载

```
pod 'CBCategoryView', '~> 0.0.2'
```

导入库

``` objective-c
#import <CBCategoryView.h>
```

实例化 CBCategoryView

``` objective-c
CBCategoryView * categoryView = [[CBCategoryView alloc] initWithPosition:CGPointMake(0,64) andHeight:40];
[self.view addSubview:categoryView];
```

添加数据

``` objective-c
[categoryView dataSource:self.category];
//self.category is a string array
```

使用block设置当切换tab时使用的ViewController

``` objective-c
[categoryView controller:self getChildViewController:^(CBCategoryView * cbCategoryView, NSInteger index) {
    ChildViewController * childViewController = [[ChildViewController alloc] init];
    childViewController.param = self.category[(NSUInteger) index];
    return childViewController;
}];
```
