//
//  TYPageViewControllerPluginTabBottomInset.m
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewControllerPluginTabBottomInset.h"
#import "TYPageViewController+Private.h"
#import "TYPageViewController+Extension.h"
#import <objc/runtime.h>
@implementation UIScrollView (TabBottomInset)

- (CGFloat)tabBottomInset {
    return [objc_getAssociatedObject(self, @selector(tabBottomInset)) floatValue];
}

- (void)setTabBottomInset:(CGFloat)tabBottomInset {
    objc_setAssociatedObject(self, @selector(tabBottomInset), @(tabBottomInset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation TYPageViewControllerPluginTabBottomInset
- (void)removePlugin {
    [self.pageViewController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        UIScrollView *scrollView = viewController.pageContentScrollView;
        [scrollView removeObserver:self forKeyPath:@"contentSize"];
    }];
}

- (void)loadPlugin {
    if (!self.pageViewController.tabHeaderView) {
        return;
    }
    [self.pageViewController.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        UIScrollView *scrollView = viewController.pageContentScrollView;
        if (scrollView.tabBottomInset == 0 && scrollView.contentInset.bottom > 0) {
            scrollView.tabBottomInset = scrollView.contentInset.bottom;
        }
        if (scrollView) {
            [self autoFitBottomInset:scrollView];
            [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        }
    }];
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context {
    if (![keyPath isEqualToString:@"contentSize"]) {
        return;
    }
    [self autoFitBottomInset:object];
}

- (void)autoFitBottomInset:(UIScrollView *)scrollView {
    CGFloat barHeight = 0;
    if ([self.pageViewController.DataSource respondsToSelector:@selector(pageHeaderBottomInsetForPageViewController:)]) {
        barHeight = [self.pageViewController.DataSource pageHeaderBottomInsetForPageViewController:self.pageViewController];
    }
    
    CGFloat minBottom = scrollView.contentSize.height + barHeight - CGRectGetHeight(scrollView.frame);
    if (minBottom >= 0) {
        if (scrollView.contentInset.bottom == scrollView.tabBottomInset) {
            return;
        }
        minBottom = scrollView.tabBottomInset;
    } else {
        minBottom = MAX(-minBottom, scrollView.tabBottomInset);
    }
    
    UIEdgeInsets insets = scrollView.contentInset;
    insets.bottom = minBottom;
    scrollView.contentInset = insets;
}
@end
