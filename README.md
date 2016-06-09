# CBCategoryView

### 简介
一个简单易用的选项卡管理器视图。允许横向滚动选择选项卡，也可以点击右边菜单展开以选择选项卡。
主要特点是，通过适配器适配子视图控制器。该组件会通过传进的数据，向主视图控制器请求子视图控制器，并传递必要的参数。

### 预览
![demo](./images/demo.gif)

### 用法
通过cocoapods下载

```
pod 'CBCategoryView', '~> 0.0.2'
```

导入库

``` objective-c
#import <CBCategoryView/CBCategoryView.h>
```

使用

``` objective-c
CBCategoryView * categoryView = [[CBCategoryView alloc] initWithPosition:CGPointMake(0,64) andHeight:30];
[self.view addSubview:categoryView];
categoryView.controller(self)
    .data(self.category)
    .decodeData(^(NSDictionary * data){
       return data[@"name"];
    })
    .childControllerAdapter(^(NSUInteger index,NSDictionary * data){
       ChildViewController * childViewController = [[ChildViewController alloc] init];
       childViewController.viewModel = [[ChildViewModel alloc]init];
       childViewController.viewModel.categoryId = index;
       return childViewController;
    })
    .reloadData();
```

* controller(UIViewController *controller)

绑定controller，用于绑定子视图控制器，和切换子视图控制器

* data(NSArray* data)

绑定数据，可以是一个字符串数组，也可以是一个model数组

* decodeData(^ (id *data))

如果绑定的data不是字符串数组，需要用decodeData将数据转换成字符串。传递过来的参数是数组中的一个，可以从该元素中取出要显示在组件上的字符串即可，以返回值的形式传递回去。
如：

``` objective-c
//data绑定的是如下数据
//@[@{@"name":@"xxxxx",@"id:"xxxx"},@{@"name":@"xxxxx",@"id:"xxxx"},...]
//
.decodeData(^ (NSDictionary * data){
    return data[@"name"];
})
```

* childControllerAdater(^ (NSInterger index,NSDictionary * data))

用于获取子视图控制器，当选择某一类别时，程序会调用该block，获取指定的子视图，并显示在界面上。
传递的参数包括当前选择类别的下标和数据，返回一个UIViewController。
这里已经做好了缓存，不需要担心性能的问题。

* reloadData()
当重新绑定数据的时候，调用reloadData方法，用于刷新数据。

