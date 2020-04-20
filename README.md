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
[WJCycleItemView setupItemHandling:^(WJCycleItemView *itemView, WJCycleItem *item) {
    if(item.type == WJCycleItemType_Local)
    {
		// 加载本地图片
       itemView.image = [UIImage imageNamed:item.localName];
    }
    else if(item.type == WJCycleItemType_Remote)
    {
    	// 加载网络图片，本轮播组件没有内部实现对 SDWebImage 或 AFNetworking 的依赖，故这里需要自己实现网图图片加载方法
      	[itemView setImageWithURL:item.remoteUrl];  // setImageWithURL: 是AFNetworking中定义的方法
    }
}];
```

配置数据源并刷新

```objc
// 添加数据源
NSMutableArray *items = [NSMutableArray array];
[items addObject:[WJCycleItem itemWithLocalName:@"img1"]];
[items addObject:[WJCycleItem itemWithLocalName:@"img2"]];
[items addObject:[WJCycleItem itemWithLocalName:@"img3"]];
[items addObject:[WJCycleItem itemWithLocalName:@"img4"]];

// 刷新数据
[_eg1 reloadDataWithSource:items];
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

