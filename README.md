# CBCategoryView

### 预览
![demo](./images/demo.gif)

### 用法
实例化 CBCategoryView

```
CBCategoryView * categoryView = [[CBCategoryView alloc] initWithPosition:CGPointMake(0,64) andHeight:40];
[self.view addSubview:categoryView];
```

添加数据 

```
[categoryView dataSource:self.category];
//self.category is a string array
```

使用block设置当切换tab时使用的ViewController

```
[categoryView controller:self
      getChildViewController:^(CBCategoryView * cbCategoryView, NSInteger index) {
          ChildViewController * childViewController = [[ChildViewController alloc] init];
          childViewController.param = self.category[(NSUInteger) index];
          return childViewController;
      }];
```

