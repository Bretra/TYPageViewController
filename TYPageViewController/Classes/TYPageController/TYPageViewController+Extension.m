//
//  TYPageViewController+Extension.m
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewController+Extension.h"
#import <objc/runtime.h>

@implementation UIViewController (pageExtension)
@dynamic pageViewController, pageContentScrollView;

- (TYPageViewController *)pageViewController {
    return objc_getAssociatedObject(self, @selector(pageViewController));
}

- (void)setPageViewController:(TYPageViewController *)pageViewController    {
    objc_setAssociatedObject(self, @selector(pageViewController), pageViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (UIScrollView *)pageContentScrollView {
    UIScrollView *scrollView = objc_getAssociatedObject(self, @selector(pageContentScrollView));
    if (scrollView) {
        return scrollView;
    }
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        [self setPageContentScrollView:(UIScrollView *)self.view];
    } else {
        for (UIScrollView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]] && CGSizeEqualToSize(subview.frame.size, self.view.frame.size)) {
                [self setPageContentScrollView:subview];
                break;
            }
        }
    }
    return objc_getAssociatedObject(self, @selector(pageContentScrollView));
}

- (void)setPageContentScrollView:(UIScrollView *)pageContentScrollView {
    objc_setAssociatedObject(self, @selector(pageContentScrollView), pageContentScrollView, OBJC_ASSOCIATION_ASSIGN);
}
@end
