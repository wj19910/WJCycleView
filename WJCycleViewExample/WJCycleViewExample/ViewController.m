//
//  ViewController.m
//  WJCycleViewExample
//
//  Created by Wangjing on 2019/10/11.
//  Copyright © 2019 Wangjing. All rights reserved.
//

#import "ViewController.h"
#import "WJCycleView.h"
#import "WJCycleItemView.h"
#import "UIKit+AFNetworking.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet WJCycleView *eg1;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WJCycleItemView setupItemHandling:^(WJCycleItemView *itemView, WJCycleItem *item) {
        if(item.type == WJCycleItemType_Local)
        {
            itemView.imageView.image = [UIImage imageNamed:item.localName];
        }
        else if(item.type == WJCycleItemType_Remote)
        {
            [itemView.imageView setImageWithURL:item.remoteUrl];
        }
    }];
    
    [self example1];
    [self example2];
}


- (void)example1
{
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[WJCycleItem itemWithLocalName:@"img1"]];
    [items addObject:[WJCycleItem itemWithLocalName:@"img2"]];
    [items addObject:[WJCycleItem itemWithLocalName:@"img3"]];
    [items addObject:[WJCycleItem itemWithLocalName:@"img4"]];
    
    [_eg1 reloadDataWithSource:items];

    _eg1.didSelectItem = ^(WJCycleView *cycleView, id<WJCycleItemProtocol> item) {
        WJCycleItem *obj = (WJCycleItem *)item;
        NSLog(@"%@", obj.localName);
    };
}

- (void)example2
{
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[WJCycleItem itemWithRemoteUrlString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1570983586685&di=6732f57d8da9815a196594a3b9be2269&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fe%2F5736dd532289d.jpg"]];
    [items addObject:[WJCycleItem itemWithRemoteUrlString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1570983586684&di=516f4507a43264623261cc3cdcd3c498&imgtype=0&src=http%3A%2F%2Fi1.mopimg.cn%2Fimg%2Ftt%2F2016-12%2F928%2F20161229204917696.jpg790x600.jpg"]];
    [items addObject:[WJCycleItem itemWithRemoteUrlString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1570983656929&di=142de64ede893069903017173fe0ec03&imgtype=0&src=http%3A%2F%2Fadmin.anzow.com%2Fpicture%2F2011052656296900.jpg"]];
    [items addObject:[WJCycleItem itemWithRemoteUrlString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1570983685024&di=3df450a28269ba64e704caa29720bc12&imgtype=0&src=http%3A%2F%2Fp1.pstatp.com%2Flarge%2Fpgc-image%2F15369390831534f32418ae5"]];
    
    
    WJCycleView *eg2 = [[WJCycleView alloc] init];
    eg2.scrollDirection = WJCycleScrollDirectionVertical;
    eg2.pageControlAlignment = WJCyclePageControlAlignmentRight;
    eg2.customItemView = ^{
        return  [[WJCycleItemView alloc] init];
    };
    [self.view addSubview:eg2];
    eg2.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0].active = YES;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0].active = YES;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0].active = YES;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:.0].active = YES;
    
    [eg2 reloadDataWithSource:items];
}


@end
