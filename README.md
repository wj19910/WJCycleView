# WJCycleView

iOS 无限轮播组件 ( Objective-C )。

## 安装方法

WJCycleView 可以通过 [CocoaPods](https://cocoapods.org) 安装。

方法： 添加以下代码到你项目中的 Podfile 中

```ruby
pod 'WJCycleView'
```

## 使用用法

框架自带默认效果

为子视图（cell）配置数据源处理方式， 只需要调用一次。

```objc
 [WJCycleItemView setupItemHandleAction:^(WJCycleItemView *itemView) {
        if(nil == itemView.item)
        {
            itemView.image = nil;
            return;
        }
        
        if(itemView.item.type == WJCycleItemTypeLocal)
        {
            itemView.image = [UIImage imageNamed:itemView.item.imgSrc];
        }
        else if(itemView.item.type == WJCycleItemTypeUrl)
        {
            NSURL *url = [NSURL URLWithString:itemView.item.imgSrc];
            if(nil != url)
            {
                [itemView setImageWithURL: url];
            }
        }
    }];
```

配置数据源

```objc
[_eg1 reloadData:@[
    [WJCycleItem itemWithType:WJCycleItemTypeLocal imageSource:@"img1"],
    [WJCycleItem itemWithType:WJCycleItemTypeLocal imageSource:@"img2"],
    [WJCycleItem itemWithType:WJCycleItemTypeLocal imageSource:@"img3"],
    [WJCycleItem itemWithType:WJCycleItemTypeLocal imageSource:@"img4"]
]];
```

点击事件

```objc 
_eg1.didSelectItem = ^(WJCycleView *cycleView, id<WJCycleItemProtocol> item) {
        if([item isKindOfClass:[WJCycleItem class]])
        {
            WJCycleItem *cycleItem = (WJCycleItem *)item;
            NSLog(@"%@", cycleItem.imgSrc);
        }
    };
```

你还可以通过 `customItemView` 属性自定义轮播视图的显示样式：

```objc
_eg1.customItemView = ^UIView<WJCycleItemViewProtocol> *{
	// 在这里返回一个遵循 WJCycleItemViewProtocol 协议的视图
};
```

[完整版 Demo 地址](https://github.com/wj19910/WJCycleView)

## 作者

Wangjing, 827476559@qq.com

