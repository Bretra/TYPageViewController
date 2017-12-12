//
//  TYPageViewControllerPluginTabBar.m
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewControllerPluginTabBar.h"
#import "TYPageViewController+Private.h"
#import "TYPageBar.h"
@interface TYPageViewControllerPluginTabBar ()
{
    BOOL _loadFlag;
    NSInteger _tabCount;
    CGFloat _maxIndicatorX;
}
@property (nonatomic, weak) id<TYPageViewBarPluginDelagate> delegate;

@property (nonatomic, strong) TYPageBar *tabViewBar;

@end

@implementation TYPageViewControllerPluginTabBar

- (instancetype)initWithTabViewBar:(TYPageBar *)tabViewBar delegate:(id<TYPageViewBarPluginDelagate>)delegate; {
    if (self = [super init]) {
        self.tabViewBar = tabViewBar;
        self.tabViewBar.backgroundColor = [UIColor whiteColor];
        self.delegate = delegate;
    }
    return self;
}


- (void)removePlugin {
    [self.tabViewBar removeFromSuperview];
    _loadFlag = NO;
}

- (void)initPlugin {
    if (CGRectGetHeight(self.tabViewBar.frame) == 0) {
        self.tabViewBar.frame = CGRectMake(0, 0, 0, BarDefaultHeight);
    }
}

- (void)loadPlugin {
    _tabCount = [self.pageViewController.DataSource numberOfViewControllerForTabViewController:self.pageViewController];
    _maxIndicatorX = CGRectGetWidth(self.pageViewController.scrollView.frame) * (_tabCount - 1);
    
    [self layoutTabViewBar];
    [self.tabViewBar reloadTabBar];
    
    if ([self.delegate respondsToSelector:@selector(pageViewController:pageViewBarDidLoad:)]) {
        [self.delegate pageViewController:self.pageViewController pageViewBarDidLoad:self.tabViewBar];
    }
}

- (void)layoutTabViewBar {
    if (_loadFlag) {
        return;
    }
    _loadFlag = YES;
    
    CGFloat tabBarHeight = CGRectGetHeight(self.tabViewBar.frame);
    if (!self.pageViewController.tabHeaderView) {
        self.tabViewBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.pageViewController.scrollView.frame), tabBarHeight);
        self.pageViewController.tabHeaderView = self.tabViewBar;
        return;
    }
    
    CGFloat tabBarFrameMinY = CGRectGetHeight(self.pageViewController.tabHeaderView.frame) - tabBarHeight;
    self.tabViewBar.frame = CGRectMake(0, tabBarFrameMinY, CGRectGetWidth(self.pageViewController.scrollView.frame), tabBarHeight);
    self.tabViewBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.pageViewController.tabHeaderView addSubview:self.tabViewBar];
}

#pragma mark - tabbar滚动

- (void)scrollViewHorizontalScroll:(CGFloat)contentOffsetX {
    NSLog(@"scrollViewHorizontalScroll");
    if ([self.tabViewBar respondsToSelector:@selector(tabScrollXOffset:)]) {
        [self.tabViewBar tabScrollXOffset:contentOffsetX];
    }
    CGFloat percent = contentOffsetX / _maxIndicatorX;
    if ([self.tabViewBar respondsToSelector:@selector(tabScrollXPercent:)]) {
        [self.tabViewBar tabScrollXPercent:percent];
    }
   
}

- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    NSLog(@"%s",__func__);
    if ([self.tabViewBar respondsToSelector:@selector(scrollToItemFromIndex:toIndex:progress:)]) {
        [self.tabViewBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
    }
}

- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate {
    
    NSLog(@"%s",__func__);
    
    if ([self.tabViewBar respondsToSelector:@selector(scrollToItemFromIndex:toIndex:animate:)]) {
        [self.tabViewBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animate];
    }
}


- (void)scrollViewDidScrollToIndex:(NSInteger)index {
    NSLog(@"scrollViewDidScrollToIndex");
    if ([self.tabViewBar respondsToSelector:@selector(tabDidScrollToIndex:)]) {
        [self.tabViewBar tabDidScrollToIndex:index];
    }
    
   
}



@end
