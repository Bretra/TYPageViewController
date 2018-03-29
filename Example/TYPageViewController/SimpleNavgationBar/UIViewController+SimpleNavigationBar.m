//
//  UIViewController+SimpleNavigationBar.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/12/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIViewController+SimpleNavigationBar.h"
#import <objc/runtime.h>

@implementation UIViewController (SimpleNavigationBar)

/** 颜色 */
static void *sn_keepBackgroundColorValueKey = &sn_keepBackgroundColorValueKey;
- (void)setSn_keepBackgroundColor:(UIColor *)sn_keepBackgroundColor {
    objc_setAssociatedObject(self, sn_keepBackgroundColorValueKey, sn_keepBackgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)sn_keepBackgroundColor {
    return objc_getAssociatedObject(self, sn_keepBackgroundColorValueKey);
}

/** 透明度 */
static void *sn_keepAlphaValueKey = &sn_keepAlphaValueKey;
- (void)setSn_keepAlpha:(float)sn_keepAlpha {
    if (sn_keepAlpha >= 1.0) {
        sn_keepAlpha = 1.0;
    }
    objc_setAssociatedObject(self, sn_keepAlphaValueKey, @(sn_keepAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (float)sn_keepAlpha {
    return [objc_getAssociatedObject(self, sn_keepAlphaValueKey) floatValue];
}

/** 模糊层是否隐藏 */
static void *sn_keepVisualEffectHiddenValueKey = &sn_keepVisualEffectHiddenValueKey;
- (void)setSn_keepVisualEffectHidden:(BOOL)sn_keepVisualEffectHidden {
    objc_setAssociatedObject(self, sn_keepVisualEffectHiddenValueKey, @(sn_keepVisualEffectHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)sn_keepVisualEffectHidden {
    return [objc_getAssociatedObject(self, sn_keepVisualEffectHiddenValueKey) boolValue];
}

/** 分割线是否隐藏 */
static void *sn_keepBottomLineHiddenValueKey = &sn_keepBottomLineHiddenValueKey;
- (void)setSn_keepBottomLineHidden:(BOOL)sn_keepBottomLineHidden {
    objc_setAssociatedObject(self, sn_keepBottomLineHiddenValueKey, @(sn_keepBottomLineHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)sn_keepBottomLineHidden {
    return [objc_getAssociatedObject(self, sn_keepBottomLineHiddenValueKey) boolValue];
}

/** 增加高度 */
static void *sn_keepTranslationYValueKey = &sn_keepTranslationYValueKey;
- (void)setSn_keepTranslationY:(float)sn_keepTranslationY {
    objc_setAssociatedObject(self, sn_keepTranslationYValueKey, @(sn_keepTranslationY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (float)sn_keepTranslationY {
    return [objc_getAssociatedObject(self, sn_keepTranslationYValueKey) floatValue];
}

/** 自定义bar */
static void *sn_keepCustomBarValueKey = &sn_keepCustomBarValueKey;
- (void)setSn_keepCustomBar:(UIView *)sn_keepCustomBar {
    objc_setAssociatedObject(self, sn_keepCustomBarValueKey, sn_keepCustomBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)sn_keepCustomBar {
    return objc_getAssociatedObject(self, sn_keepCustomBarValueKey);
}

@end
