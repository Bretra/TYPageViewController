//
//  TYPageViewControllerPluginHeaderScroll.m
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewControllerPluginHeaderScroll.h"
#import "TYPageViewController+Private.h"
#import "TYPageViewController+Extension.h"

@interface TYPageViewControllerPluginHeaderScroll ()
@property (nonatomic, assign) NSInteger index;
@end

@implementation TYPageViewControllerPluginHeaderScroll

- (void)removePlugin {
    [self removePanGestureForIndex:self.pageViewController.curIndex];
}

- (void)loadPlugin {
    [self addPanGestureForIndex:self.pageViewController.curIndex];
    self.index = self.pageViewController.curIndex;
}

- (void)scrollViewWillScrollFromIndex:(NSInteger)index {
    self.index = index;
}

- (void)scrollViewDidScrollToIndex:(NSInteger)index {
    if (self.index == index) {
        return;
    }
    [self removePanGestureForIndex:self.index];
    [self addPanGestureForIndex:index];
    self.index = index;
}

#pragma mark - 拖拽手势

- (void)addPanGestureForIndex:(NSInteger)index {
    UIViewController *vc = [self.pageViewController viewControllerForIndex:index];
    UIScrollView *tabContentScrollView = vc.pageContentScrollView;
    if (tabContentScrollView) {
        [self.pageViewController.view addGestureRecognizer:tabContentScrollView.panGestureRecognizer];
    }
}

- (void)removePanGestureForIndex:(NSInteger)index {
    UIViewController *vc = [self.pageViewController viewControllerForIndex:index];
    UIScrollView *tabContentScrollView = vc.pageContentScrollView;
    if (tabContentScrollView) {
        [self.pageViewController.view removeGestureRecognizer:tabContentScrollView.panGestureRecognizer];
    }
}
@end
