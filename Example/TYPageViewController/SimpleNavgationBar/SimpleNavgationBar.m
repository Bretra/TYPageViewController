//
//  SimpleNavgationBar.m
//  HeiPa
//
//  Created by wyman on 2017/9/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "SimpleNavgationBar.h"
#import "SimpleNavigationConst.h"
#import "UINavigationBar+SimpleNavigationBar.h"
#import "UINavigationBar+SimpleNavigationBarPrivateProperty.h"
#import "UINavigationController+SimpleNavigationBar.h"
#import "UIViewController+SimpleNavigationBar.h"
//#import "NSObject+DeallocNoti.h"
#import "SimpleNavigationCustomBar.h"
#import <objc/runtime.h>

typedef void(^SNSetPropertyTask)();

@implementation UIViewController (SimpleNavgationBar)

#pragma mark - 设置任务

static void *setPropertyTaskListValueKey = &setPropertyTaskListValueKey;
- (NSMutableArray<SNSetPropertyTask> *)propertyTaskList {
    NSMutableArray<SNSetPropertyTask> *_setPropertyTaskList = objc_getAssociatedObject(self, setPropertyTaskListValueKey);
    if (_setPropertyTaskList == nil) {
        _setPropertyTaskList = [NSMutableArray array];
        objc_setAssociatedObject(self, setPropertyTaskListValueKey, _setPropertyTaskList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return _setPropertyTaskList;
}

- (void)appendSetPropertyTask:(SNSetPropertyTask)task {
    // 在手势开始时丢弃此任务，因为在手势取消的时候会再次触发生命周期，在手势完成的时候会是正常动画结果
    if ([self getCurrentNav].sn_gesturePopState != SNTransitionStateBegan) {
        task();
    }
}

#pragma mark - 获取当前导航栏

- (UINavigationController *)getCurrentNav {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    return nav;
}

#pragma mark - 设置导航栏
/** 透明度 */
- (void)setSn_navBarAlpha:(CGFloat)sn_navBarAlpha {
    [self loadDefaultNavBar];
    __weak typeof(self)weakSelf = self;
    [self appendSetPropertyTask:^{
        [weakSelf getCurrentNav].navigationBar.sn_alpha = sn_navBarAlpha;
    }];
}
- (CGFloat)sn_navBarAlpha {
    return [self getCurrentNav].navigationBar.sn_alpha;
}

/** 背景色 */
- (void)setSn_navBarBackgroundColor:(UIColor *)sn_navBarBackgroundColor {
    [self loadDefaultNavBar];
    __weak typeof(self)weakSelf = self;
    [self appendSetPropertyTask:^{
        [weakSelf getCurrentNav].navigationBar.sn_backgroundColor = sn_navBarBackgroundColor;
    }];
}
- (UIColor *)sn_navBarBackgroundColor {
    return [self getCurrentNav].navigationBar.sn_backgroundColor;
}

/** 底部分割线 */
- (void)setSn_navBarBottomLineHidden:(BOOL)sn_navBarBottomLineHidden {
    [self getCurrentNav].navigationBar.sn_bottomLineHidden = sn_navBarBottomLineHidden;
}
- (BOOL)sn_navBarBottomLineHidden {
    return  [self getCurrentNav].navigationBar.sn_bottomLineHidden;
}

/** 高度 */
- (void)setSn_translationY:(float)sn_translationY {
    [self getCurrentNav].navigationBar.sn_translationY = sn_translationY;
}
- (float)sn_translationY {
    return  [self getCurrentNav].navigationBar.sn_translationY;
}

/** 自定义bar*/
//// 导航栏
- (void)setSn_customBar:(UIView *)sn_customBar {
    [self getCurrentNav].navigationBar.sn_customBarView = sn_customBar;
    if (![sn_customBar isKindOfClass:[SimpleNavigationCustomBar class]] && sn_customBar) { // 如果不是SimpleNavigationCustomBar则直接就是外面赋值的控件
        self.sn_isCustomBar = YES;
        [self getCurrentNav].navigationBar.sn_visualEffectHidden = YES;
    }
}
- (UIView *)sn_customBar {
   return [self getCurrentNav].navigationBar.sn_customBarView;
}

#pragma mark - 重置

- (void)sn_reset {
    if (self.sn_isCustomBar) {
        [self sn_keepBarStatus];
    }
    __weak typeof(self)weakSelf = self;
    SNSetPropertyTask task= ^{
        weakSelf.sn_translationY = 0;
        weakSelf.sn_customBar = nil;
        [weakSelf getCurrentNav].navigationBar.sn_visualEffectHidden = NO;
        weakSelf.sn_navBarBottomLineHidden = NO;
    };
    // 在手势开始时丢弃此任务，因为在手势取消的时候会再次触发生命周期，在手势完成的时候会是正常动画结果
    if ([self getCurrentNav].sn_gesturePopState != SNTransitionStateBegan) {
        task();
    } else {
        // 如果是pop到原生也马上执行，因为系统原生有模糊效果
        UIViewController *toVC = [self.navigationController.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        if (!toVC.sn_isCustomBar && !toVC.sn_navBarHidden) { // pop到原生控制器
            task();
        }
    }
}

- (void)sn_keepBarStatus {
    self.sn_keepAlpha = [self getCurrentNav].navigationBar.sn_alpha;
    self.sn_keepBackgroundColor = [self getCurrentNav].navigationBar.sn_backgroundColor;
    self.sn_keepBottomLineHidden = [self getCurrentNav].navigationBar.sn_bottomLineHidden;
    self.sn_keepTranslationY = [self getCurrentNav].navigationBar.sn_translationY;
    self.sn_keepVisualEffectHidden = [self getCurrentNav].navigationBar.sn_bottomLineHidden;
    self.sn_keepCustomBar = [self getCurrentNav].navigationBar.sn_customBarView;
}

#pragma mark - 加载自定义导航栏
- (void)loadDefaultNavBar {
    if (self.sn_customBar) {
        return;
    };
    if ([self getCurrentNav].sn_gesturePopState == SNTransitionStateNone) {
        // 只有在非转场中触发loadDefaultNavBar的才是自定义
        self.sn_isCustomBar = YES;
    }
    CGFloat statusBarH = STATUS_BAR_H;
    if ([self prefersStatusBarHidden] && !KIsiPhoneX) { // 仅在iphoneX中适配状态条，因为x没有隐藏的说法
        statusBarH = 0;
    }
    if (KIsiPhoneX) { // 适配iphoneX
        statusBarH += 24;
    }
    UIView *customView = [[SimpleNavigationCustomBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([self getCurrentNav].navigationBar.bounds), CGRectGetHeight([self getCurrentNav].navigationBar.bounds) + statusBarH)];
    customView.backgroundColor = [UIColor clearColor];
    self.sn_customBar = customView;
    if (self.sn_isCustomBar) {
        // 自定义bar才会触发
        [self getCurrentNav].navigationBar.sn_visualEffectHidden = YES;
        [self getCurrentNav].navigationBar.sn_alpha = 1.0;
        [self getCurrentNav].navigationBar.sn_backgroundColor = [UIColor clearColor];
    }
    [[self getCurrentNav] sn_addGuestTarget];
}

#pragma mark - 是否自定义
static void *sn_isCustomBarValueKey = &sn_isCustomBarValueKey;
- (void)setSn_isCustomBar:(BOOL)sn_isCustomBar {
    objc_setAssociatedObject(self, sn_isCustomBarValueKey, @(sn_isCustomBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)sn_isCustomBar {
    return [objc_getAssociatedObject(self, sn_isCustomBarValueKey) boolValue];
}

#pragma mark - 隐藏和手势开关
// 转场时系统手势代理
static void *sn_bavBarHiddenKey = &sn_bavBarHiddenKey;
- (BOOL)sn_navBarHidden {
    return [objc_getAssociatedObject(self, &sn_bavBarHiddenKey) boolValue];
}
// 隐藏
- (void)sn_navBarHidden:(BOOL)animated {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    objc_setAssociatedObject(self, &sn_bavBarHiddenKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [nav setNavigationBarHidden:YES animated:animated];
}
- (void)sn_navBarShow:(BOOL)animated {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav setNavigationBarHidden:NO animated:animated];
}
// 侧滑开关
// 转场时系统手势代理
static void *sn_interactivePopGestureRecognizerDelegateKey = &sn_interactivePopGestureRecognizerDelegateKey;
- (void)setSn_interactivePopGestureRecognizerDelegate:(id)sn_interactivePopGestureRecognizerDelegate {
    objc_setAssociatedObject(self, &sn_interactivePopGestureRecognizerDelegateKey, sn_interactivePopGestureRecognizerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)sn_interactivePopGestureRecognizerDelegate {
    return (id)objc_getAssociatedObject(self, &sn_interactivePopGestureRecognizerDelegateKey);
}

- (void)sn_openScreenPop {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    if (!self.sn_interactivePopGestureRecognizerDelegate) { // 保存代理
        self.sn_interactivePopGestureRecognizerDelegate = nav.interactivePopGestureRecognizer.delegate;
        nav.interactivePopGestureRecognizer.delegate = (id)nav;
    }
}

@end






