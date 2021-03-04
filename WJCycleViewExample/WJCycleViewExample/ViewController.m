//
//  ViewController.m
//  WJCycleViewExample
//
//  Created by Wangjing on 2019/10/11.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import "ViewController.h"
#import "WJCycleView.h"

#import "UIKit+AFNetworking.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet WJCycleView *eg1;
@end

@implementation ViewController

- (void)dealloc
{
    NSLog(@"%s, dealloc 打印，WJCycleView 释放正常", __func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    /// 自定义示例Item视图对数据源的处理方式
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
    
    
    
    // 示例1 轮播本地图片
    [_eg1 reloadData:@[
        [WJCycleItem itemWithType:WJCycleItemTypeLocal imageSource:@"img1"],
        [WJCycleItem itemWithType:WJCycleItemTypeLocal imageSource:@"img2"],
        [WJCycleItem itemWithType:WJCycleItemTypeLocal imageSource:@"img3"],
        [WJCycleItem itemWithType:WJCycleItemTypeLocal imageSource:@"img4"]
    ]];
    _eg1.customItemView = ^UIView<WJCycleItemViewProtocol> *{
        return [[WJCycleItemView alloc] init];
    };
    
    _eg1.didSelectItem = ^(WJCycleView *cycleView, id<WJCycleItemProtocol> item) {
        if([item isKindOfClass:[WJCycleItem class]])
        {
            WJCycleItem *cycleItem = (WJCycleItem *)item;
            NSLog(@"%@", cycleItem.imgSrc);
        }
    };
    
    
    
    // 示例2
    WJCycleView *eg2 = [[WJCycleView alloc] initWithFrame:CGRectMake(0, _eg1.bounds.size.height, self.view.bounds.size.width, _eg1.bounds.size.height)];
    eg2.scrollDirection = WJCycleScrollDirectionVertical;
    [self.view addSubview:eg2];
    eg2.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0].active = YES;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0].active = YES;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0].active = YES;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:.0].active = YES;

    [eg2 reloadData:@[
        [WJCycleItem itemWithType:WJCycleItemTypeUrl imageSource:@"http://pic1.win4000.com/wallpaper/e/5736dd532289d.jpg"],
        [WJCycleItem itemWithType:WJCycleItemTypeUrl imageSource:@"http://i1.mopimg.cn/img/tt/2016-12/928/20161229204917696.jpg"],
        [WJCycleItem itemWithType:WJCycleItemTypeUrl imageSource:@"http://admin.anzow.com/picture/2011052656296900.jpg"],
        [WJCycleItem itemWithType:WJCycleItemTypeUrl imageSource:@"http://p1.pstatp.com/large/pgc-image/15369390831534f32418ae5.jpg"]
    ]];
    eg2.didSelectItem = ^(WJCycleView *cycleView, id<WJCycleItemProtocol> item) {
        if([item isKindOfClass:[WJCycleItem class]])
        {
            WJCycleItem *cycleItem = (WJCycleItem *)item;
            NSLog(@"%@", cycleItem.imgSrc);
        }
    };
}


@end
