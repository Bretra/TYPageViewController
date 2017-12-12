//
//  TYPageViewControllerPluginTabBar.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewControllerPluginBase.h"
@class TYPageBar;
@protocol TYPageViewBarPluginDelagate <NSObject>

@optional

- (void)pageViewController:(TYPageViewController *)pageViewController pageViewBarDidLoad:(TYPageBar *)tabViewBar;

@end

@interface TYPageViewControllerPluginTabBar : TYPageViewControllerPluginBase
////只要继承自 TYPageBar 完成自定制
- (instancetype)initWithTabViewBar:(TYPageBar *)tabViewBar delegate:(id<TYPageViewBarPluginDelagate>)delegate;
@end
