# WJCycleView

An infinite automatic scroll loop effect for ios.


[中文文档](https://github.com/wj19910/WJCycleView/README.md)



## Installation

WJCycleView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WJCycleView'
```

## Usage

For default effect:

1. Config how to handle item for each itemView, like this:

	```objc
	[WJCycleItemView setupItemHandling:^(WJCycleItemView *itemView, WJCycleItem *item) {
	    if(item.type == WJCycleItemType_Local)
	    {
			// handle a loacal image.
	       itemView.image = [UIImage imageNamed:item.localName];
	    }
	    else if(item.type == WJCycleItemType_Remote)
	    {
	    	// handle a remote url image.
	      	[itemView setImageWithURL:item.remoteUrl];
	    }
	}];
	```

2. Config the dataSource than reload it.

	```
	NSMutableArray *items = [NSMutableArray array];
   [items addObject:[WJCycleItem itemWithLocalName:@"img1"]];
   [items addObject:[WJCycleItem itemWithLocalName:@"img2"]];
   [items addObject:[WJCycleItem itemWithLocalName:@"img3"]];
   [items addObject:[WJCycleItem itemWithLocalName:@"img4"]];
   [_eg1 reloadDataWithSource:items];  // _eg1 is a instance of WJCycleView
	```

Otherwise, you can custom your own effect through the flow block attributes:

```
@property (nonatomic, copy) UIView<WJCycleItemViewProtocol> * (^customItemView)(void);
```
for example:

```
_eg1.customItemView = ^UIView<WJCycleItemViewProtocol> *{
	// return your own itemView here.
};
```





You can see the full example demo [here](https://github.com/wj19910/WJCycleView).


## Author

Wangjing, 827476559@qq.com

## License

WJCycleView is available under the MIT license. See the LICENSE file for more info.
