//
//  UINavigationBar+SimpleNavigationBar.m
//  9-16NavigationBar
//
//  Created by wyman on 2017/9/16.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UINavigationBar+SimpleNavigationBar.h"
#import "SimpleNavigationConst.h"
#import "UINavigationBar+SimpleNavigationBarPrivateProperty.h"
#import "UINavigationController+SimpleNavigationBar.h"
#import <objc/runtime.h>

@implementation UINavigationBar (SimpleNavigationBar)

#pragma mark - 拓展属性

/** 自定义bar */
static void *sn_customBarViewValueKey = &sn_customBarViewValueKey;
- (void)setSn_customBarView:(UIView *)sn_customBarView {
    [self sn_reset];
    sn_customBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    objc_setAssociatedObject(self, sn_customBarViewValueKey, sn_customBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (nil!=sn_customBarView) {
        [[self _sn_UIBarBackground] insertSubview:sn_customBarView atIndex:0];
    }
}
- (UIView *)sn_customBarView {
    UIView *sn_customBarView = objc_getAssociatedObject(self, sn_customBarViewValueKey);
    if (sn_customBarView) {
        if ([[self _sn_UIBarBackground].subviews containsObject:sn_customBarView]) {
            [[self _sn_UIBarBackground] bringSubviewToFront:sn_customBarView];
        } else {
            [[self _sn_UIBarBackground] insertSubview:sn_customBarView atIndex:0];
        }
    };
    return sn_customBarView;
}

/** 颜色 */
static void *sn_backgroundColorValueKey = &sn_backgroundColorValueKey;
- (void)setSn_backgroundColor:(UIColor *)sn_backgroundColor {
    self.sn_customBarView.backgroundColor = sn_backgroundColor;
    objc_setAssociatedObject(self, sn_backgroundColorValueKey, sn_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)sn_backgroundColor {
    return objc_getAssociatedObject(self, sn_backgroundColorValueKey);
}

/** 透明度 */
static void *sn_alphaValueKey = &sn_alphaValueKey;
- (void)setSn_alpha:(float)sn_alpha {
    self.sn_customBarView.alpha = sn_alpha;
    objc_setAssociatedObject(self, sn_alphaValueKey, @(sn_alpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (float)sn_alpha {
    return [objc_getAssociatedObject(self, sn_alphaValueKey) floatValue];
}

/** 隐藏模糊层 */
static void *sn_visualEffectHiddenValueKey = &sn_visualEffectHiddenValueKey;
- (void)setSn_visualEffectHidden:(BOOL)sn_visualEffectHidden {
    if (sn_visualEffectHidden) {
        if ([self.delegate isKindOfClass:[UINavigationController class]]) {
            UINavigationController *curNav = (UINavigationController *)self.delegate;
            if (curNav.sn_gesturePopState != SNTransitionStateBegan) { // 非手势开启时则直接隐藏
                self._sn_UIVisualEffectView.hidden = YES;
            } else {
                // 手势中...
            }
        }
        [self setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self._sn_UIVisualEffectView.hidden = NO;
    }
    objc_setAssociatedObject(self, sn_visualEffectHiddenValueKey, @(sn_visualEffectHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)sn_visualEffectHidden {
    return [objc_getAssociatedObject(self, sn_visualEffectHiddenValueKey) boolValue];
}

/** 底部线 */
static void *sn_bottomLineHiddenValueKey = &sn_bottomLineHiddenValueKey;
- (void)setSn_bottomLineHidden:(BOOL)sn_bottomLineHidden {
    [self _sn_UIImageViewBottomLine].hidden = sn_bottomLineHidden;
    objc_setAssociatedObject(self, sn_bottomLineHiddenValueKey, @(sn_bottomLineHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)sn_bottomLineHidden {
    return [objc_getAssociatedObject(self, sn_bottomLineHiddenValueKey) boolValue];
}

/** 高度 */
static void *sn_translationYValueKey = &sn_translationYValueKey;
- (void)setSn_translationY:(float)sn_translationY {
    [self setTitleVerticalPositionAdjustment:-sn_translationY forBarMetrics:UIBarMetricsDefault];
    CGFloat navBarH = NAV_BAR_H;
    if (KIsiPhoneX) {
        navBarH += 24;
    }
    CGRect f = self.frame;
    f.size.height = NAV_BAR_H + sn_translationY;
    self.frame = f;
    
    CGFloat statusH = 20;
    NSLog(@"%f", self._sn_UIBarBackground.frame.size.height-f.size.height);
    CGFloat delH = self._sn_UIBarBackground.frame.size.height-f.size.height;
    if (delH!=STATUS_BAR_H && delH!=(STATUS_BAR_H+24)) { // 无导航栏 +24是在iphoneX的高度
        statusH= 0;
    }
    self.sn_customBarView.frame = CGRectMake(self.sn_customBarView.frame.origin.x, self.sn_customBarView.frame.origin.y, self.sn_customBarView.frame.size.width, navBarH + statusH + sn_translationY);
    objc_setAssociatedObject(self, sn_translationYValueKey, @(sn_translationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (float)sn_translationY {
    return [objc_getAssociatedObject(self, sn_translationYValueKey) floatValue];
}

#pragma mark - 操作
/** 重置操作 */
- (void)sn_reset {
    [self.sn_customBarView removeFromSuperview];
}





@end

