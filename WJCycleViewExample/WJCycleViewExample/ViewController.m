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
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WJCycleItemView setupItemHandling:^(WJCycleItemView *itemView, WJCycleItem *item) {
        if(item.type == WJCycleItemType_Local)
        {
            itemView.image = [UIImage imageNamed:item.localName];
        }
        else if(item.type == WJCycleItemType_Remote)
        {
            [itemView setImageWithURL:item.remoteUrl placeholderImage:[UIImage imageNamed:@"img1"]];
        }
    }];
    
    [self example1];
    [self example2];
}


- (void)example1
{
    _eg1.didSelectItem = ^(WJCycleView *cycleView, id<WJCycleItemProtocol> item) {
        NSLog(@"%@", item.localName);
    };

    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[WJCycleItem itemWithLocalName:@"img1"]];
    [items addObject:[WJCycleItem itemWithLocalName:@"img2"]];
    [items addObject:[WJCycleItem itemWithLocalName:@"img3"]];
    [items addObject:[WJCycleItem itemWithLocalName:@"img4"]];
    
    [_eg1 reloadDataWithSource:items];

}

- (void)example2
{
    WJCycleView *eg2 = [[WJCycleView alloc] initWithFrame:CGRectMake(0, _eg1.bounds.size.height, self.view.bounds.size.width, _eg1.bounds.size.height)];
    [self.view addSubview:eg2];
    eg2.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeBottom multiplier:1.0 constant:.0].active = YES;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeLeft multiplier:1.0 constant:.0].active = YES;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeRight multiplier:1.0 constant:.0].active = YES;
    [NSLayoutConstraint constraintWithItem:eg2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_eg1 attribute:NSLayoutAttributeHeight multiplier:1.0 constant:.0].active = YES;


    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[WJCycleItem itemWithRemoteUrlString:@"http://pic1.win4000.com/wallpaper/e/5736dd532289d.jpg"]];
//    [items addObject:[WJCycleItem itemWithRemoteUrlString:@"http://i1.mopimg.cn/img/tt/2016-12/928/20161229204917696.jpg"]];
//    [items addObject:[WJCycleItem itemWithRemoteUrlString:@"http://admin.anzow.com/picture/2011052656296900.jpg"]];
//    [items addObject:[WJCycleItem itemWithRemoteUrlString:@"http://p1.pstatp.com/large/pgc-image/15369390831534f32418ae5.jpg"]];

    eg2.scrollDirection = WJCycleScrollDirectionVertical;
    [eg2 reloadDataWithSource:items];
    eg2.didSelectItem = ^(WJCycleView *cycleView, id<WJCycleItemProtocol> item) {
        NSLog(@"%@", item.remoteUrl);
    };

}



@end
