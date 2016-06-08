//
// Created by Cocbin on 16/6/8.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "ChildViewModel.h"


@implementation ChildViewModel

- (NSArray *)goods {
    if(!_goods) {
        switch (_categoryId) {
            case 0:
            case 5:
                _goods = @[
                        @{
                                @"name":@"日本进口森永BAKE烘培巧克力38g（代可可脂）",
                                @"price":@"12.80",
                                @"image":@"goods1.jpg"
                        },@{
                                @"name":@"福临门 香粘米 5kg/袋  纤盈精巧 色泽柔润 中粮出品",
                                @"price":@"31",
                                @"image":@"goods2.png"
                        },@{
                                @"name":@"德芙士力架全家桶巧克力460g桶装 休闲零食 生日",
                                @"price":@"28.9",
                                @"image":@"goods3.jpg"
                        },@{
                                @"name":@"箭牌糖果益达木糖醇清爽草莓味40粒口香糖56g零",
                                @"price":@"21.2",
                                @"image":@"goods4.jpg"
                        },@{
                                @"name":@"德国进口Woogie水果糖柠檬味200g/罐清新柠檬",
                                @"price":@"14.5",
                                @"image":@"goods5.jpg"
                        },@{
                                @"name":@"阿尔卑斯 草莓牛奶硬糖150g/袋 甜蜜美味滋味",
                                @"price":@"8.5",
                                @"image":@"goods6.jpg"
                        }];
                break;
            case 1:
            case 6:
                _goods = @[
                        @{
                                @"name":@"阿尔卑斯 草莓牛奶硬糖150g/袋 甜蜜美味滋味",
                                @"price":@"8.5",
                                @"image":@"goods6.jpg"
                        },@{
                                @"name":@"亿滋 怡口莲榛仁巧克力太妃糖90g休闲零食 糖果",
                                @"price":@"9.89",
                                @"image":@"goods7.jpg"
                        },@{
                                @"name":@"客嘟麦清凉奶糖16g/支经典怀旧休闲零食薄荷糖",
                                @"price":@"1.0",
                                @"image":@"goods8.jpg"
                        }
                ];
                break;
            case 2:
            case 7:
                _goods = @[
                        @{
                                @"name":@"德芙士力架全家桶巧克力460g桶装 休闲零食 生日",
                                @"price":@"28.9",
                                @"image":@"goods3.jpg"
                        },@{
                                @"name":@"箭牌糖果益达木糖醇清爽草莓味40粒口香糖56g零",
                                @"price":@"21.2",
                                @"image":@"goods4.jpg"
                        },@{
                                @"name":@"德国进口Woogie水果糖柠檬味200g/罐清新柠檬",
                                @"price":@"14.5",
                                @"image":@"goods5.jpg"
                        },@{
                                @"name":@"阿尔卑斯 草莓牛奶硬糖150g/袋 甜蜜美味滋味",
                                @"price":@"8.5",
                                @"image":@"goods6.jpg"
                        },@{
                                @"name":@"亿滋 怡口莲榛仁巧克力太妃糖90g休闲零食 糖果",
                                @"price":@"9.89",
                                @"image":@"goods7.jpg"
                        }
                ];
                break;
            case 3:
            case 8:
                _goods = @[
                        @{
                                @"name":@"福临门 香粘米 5kg/袋  纤盈精巧 色泽柔润 中粮出品",
                                @"price":@"31",
                                @"image":@"goods2.png"
                        },@{
                                @"name":@"德芙士力架全家桶巧克力460g桶装 休闲零食 生日",
                                @"price":@"28.9",
                                @"image":@"goods3.jpg"
                        },@{
                                @"name":@"箭牌糖果益达木糖醇清爽草莓味40粒口香糖56g零",
                                @"price":@"21.2",
                                @"image":@"goods4.jpg"
                        },@{
                                @"name":@"德国进口Woogie水果糖柠檬味200g/罐清新柠檬",
                                @"price":@"14.5",
                                @"image":@"goods5.jpg"
                        }
                ];
                break;
            case 4:
            case 9:
                _goods = @[
                    @{
                            @"name":@"亿滋 怡口莲榛仁巧克力太妃糖90g休闲零食 糖果",
                            @"price":@"9.89",
                            @"image":@"goods7.jpg"
                    },@{
                        @"name":@"客嘟麦清凉奶糖16g/支经典怀旧休闲零食薄荷糖",
                        @"price":@"1.0",
                        @"image":@"goods8.jpg"
                }];
                break;

            default:_goods = @[
                        @{
                                @"name":@"德芙士力架全家桶巧克力460g桶装 休闲零食 生日",
                                @"price":@"28.9",
                                @"image":@"goods3.jpg"
                        },@{
                                @"name":@"箭牌糖果益达木糖醇清爽草莓味40粒口香糖56g零",
                                @"price":@"21.2",
                                @"image":@"goods4.jpg"
                        },@{
                                @"name":@"德国进口Woogie水果糖柠檬味200g/罐清新柠檬",
                                @"price":@"14.5",
                                @"image":@"goods5.jpg"
                        }];
        }
    }
    return _goods;
}
@end