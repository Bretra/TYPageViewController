//
//  UINavigationController+SimpleNavigationBar.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/12/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UINavigationController+SimpleNavigationBar.h"
#import "UIViewController+SimpleNavigationBar.h"
#import "UIColor+SimpleNavgationBar.h"
#import "UINavigationBar+SimpleNavigationBar.h"
#import "SimpleNavgationBar.h"
#import "SimpleNavigationConst.h"
#import "UINavigationBar+SimpleNavigationBar.h"
#import "SimpleNavigationCustomBar.h"
#import <objc/runtime.h>

@implementation UINavigationController (SimpleNavigationBar)

#pragma mark - 状态
static void *sn_gesturePopStateValueKey = &sn_gesturePopStateValueKey;
- (void)setSn_gesturePopState:(SNTransitionState)sn_gesturePopState {
    SNTransitionState oldState = self.sn_gesturePopState;
    SNTransitionState newState = sn_gesturePopState;
    if (oldState != newState) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SNTransitionStateBeforeChangeNotification object:self userInfo:@{SNTransitionStateChangeOldValue:@(oldState), SNTransitionStateChangeNewValue:@(newState)}];
    }
    objc_setAssociatedObject(self, sn_gesturePopStateValueKey, @(sn_gesturePopState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (oldState != newState) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SNTransitionStateAfterChangeNotification object:self userInfo:@{SNTransitionStateChangeOldValue:@(oldState), SNTransitionStateChangeNewValue:@(newState)}];
    }
}
- (SNTransitionState)sn_gesturePopState {
    return (SNTransitionState)[objc_getAssociatedObject(self, sn_gesturePopStateValueKey) intValue];
}

#pragma mark - 添加手势监听
- (void)sn_addGuestTarget {
    UINavigationController *nav = [self isKindOfClass:[UINavigationController class]] ? (UINavigationController *)self : self.navigationController;
    [nav.interactivePopGestureRecognizer addTarget:nav action:@selector(updateInteractiveTransition:)]; // 增加手势方法,处理转场
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.childViewControllers.count > 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 处理手势返回
- (void)updateInteractiveTransition:(UIPanGestureRecognizer *)panGesture {
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:{
            self.sn_gesturePopState = SNTransitionStateBegan;
            [self addInteractionChangeNotify];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            self.sn_gesturePopState = SNTransitionStateMoving;
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            CGFloat persent = transitionX / panGesture.view.frame.size.width;
            UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];

            if (fromVC.sn_isCustomBar && !toVC.sn_isCustomBar) {
                NSLog(@"转场：自定义->系统");
                [self updateNavigationBarCustom2SystemWithFromVC:fromVC toVC:toVC progress:persent];
            } else if (fromVC.sn_isCustomBar && toVC.sn_isCustomBar) {
                NSLog(@"转场：自定义->自定义");
                [self updateNavigationBarCustom2CustomWithFromVC:fromVC toVC:toVC progress:persent];
            } else if (!fromVC.sn_isCustomBar && toVC.sn_isCustomBar) {
                NSLog(@"转场：系统->自定义");
                [self updateNavigationBarSystem2CustomWithFromVC:fromVC toVC:toVC progress:persent];
            } else {
                NSLog(@"转场：系统->系统");
            }

            break;
        }
        case UIGestureRecognizerStateCancelled: {
//            self.sn_gesturePopState = SNTransitionStateCancel;
        }
        case UIGestureRecognizerStateEnded:{
            self.sn_gesturePopState = SNTransitionStateNone;
        }
            break;
        default:
            
            break;
    }
}

#pragma mark - 处理手势结束情况
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    NSUInteger itemCount = self.navigationBar.items.count;
    NSUInteger n = self.viewControllers.count >= itemCount ? 2 : 1;
    UIViewController *popToVC = self.viewControllers[self.viewControllers.count - n];
    if (!popToVC.sn_isCustomBar) {  // pop到原生的,需要对原生vc进行reset【不知原因】
        [popToVC sn_reset];
    }
    if (self.sn_gesturePopState == SNTransitionStateNone) {
        [self popToViewController:popToVC animated:YES];
    }
    return YES;
}

- (void)addInteractionChangeNotify {
    id<UIViewControllerTransitionCoordinator> coor = [self.topViewController transitionCoordinator];
    __weak typeof (self) weakSelf = self;
    NSString *sysVersion = [[UIDevice currentDevice] systemVersion];
    // 状态回调都在控制器will生命周期前触发
    if ([sysVersion floatValue] >= 10) {
        if (@available(iOS 10.0, *)) {
            [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                __strong typeof (self) strongSelf = weakSelf;
                [strongSelf dealInteractionChanges:context];
            }];
        } else {
            // Fallback on earlier versions
        }
    } else {
        [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            __strong typeof (self) strongSelf = weakSelf;
            [strongSelf dealInteractionChanges:context];
        }];
    }
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context {

    UIViewController *fromVc = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [context viewControllerForKey:UITransitionContextToViewControllerKey];

    // 1.记录最终目标属性
    UIColor *targetColor = nil;
    float targetAlpha = 0.0;
    double cancelDuration = 0.0;
    CGFloat targetTranslationY = 0.0;
    UIViewController *finishVc = nil;
    if ([context isCancelled] == YES) { // 回到fromVc状态
        cancelDuration = [context transitionDuration] * [context percentComplete];
        targetColor = fromVc.sn_keepBackgroundColor;
        targetAlpha = fromVc.sn_keepAlpha;
        targetTranslationY = fromVc.sn_keepTranslationY;
        finishVc = fromVc;
    } else {
        cancelDuration = [context transitionDuration] * (1-[context percentComplete]);
        targetColor = toVc.sn_keepBackgroundColor;
        targetAlpha = toVc.sn_keepAlpha;
        targetTranslationY = toVc.sn_keepTranslationY;
        finishVc = toVc;
    }
    
    // 2.处理临界值
    // 如果没有时间触发动画则主动置为原始状态
    if (cancelDuration<=0) { // 注意！此处 cancelDuration<=0 此函数出栈后会立即回调控制器生命周期，所以补充动画的completion会在生命周期方法调用后触发，导致此处会出现闪一下的BUG
        if (!toVc.sn_isCustomBar) {
            // 如果是到系统导航栏，需要将模糊层隐藏
            self.navigationBar.sn_visualEffectHidden = YES;
            self.sn_gesturePopState = SNTransitionStateNone;
            return;
        }
        toVc.sn_navBarBackgroundColor = toVc.sn_keepBackgroundColor;
        toVc.sn_navBarAlpha = toVc.sn_keepAlpha;
        toVc.sn_translationY = toVc.sn_keepTranslationY;
        self.sn_gesturePopState = SNTransitionStateNone;
        return;
    }
    
    // 3.补充动画
    BOOL backFromVc = [context isCancelled];
    [UIView animateWithDuration:cancelDuration animations:^{
        toVc.sn_navBarBackgroundColor = targetColor;
        toVc.sn_navBarAlpha = targetAlpha;
        toVc.sn_translationY = targetTranslationY;
    } completion:^(BOOL finished) {
        NSLog(@"补充动画结束...");
        if (backFromVc == YES) {
            [hiddenBar.subviews makeObjectsPerformSelector:@selector(setAlpha:) withObject:@(1.0)];
            [showBar.subviews makeObjectsPerformSelector:@selector(setAlpha:) withObject:@(0.0)];
            // 回到fromVc状态时，将动画的导航栏置为本身保存的状态，转场的使命结束
            if (toVc.sn_isCustomBar) {
                toVc.sn_navBarBackgroundColor = toVc.sn_keepBackgroundColor;
                toVc.sn_navBarAlpha = toVc.sn_keepAlpha;
                toVc.sn_translationY = toVc.sn_keepTranslationY;
                toVc.sn_navBarBottomLineHidden = toVc.sn_keepBottomLineHidden;
            }
        } else {
            [hiddenBar.subviews makeObjectsPerformSelector:@selector(setAlpha:) withObject:@(0.0)];
            [showBar.subviews makeObjectsPerformSelector:@selector(setAlpha:) withObject:@(1.0)];
            // 回到toVc状态时，生命周期记录的属性将被修改，标示为不允许修改
            if (!finishVc.sn_isCustomBar) {
                // 到系统导航栏需要reset才可以【不知原因】
                [finishVc sn_reset];
            }
        }
        if (finishVc.sn_isCustomBar) {
            // 如果是自定义导航栏则将模糊层隐藏
            self.navigationBar.sn_visualEffectHidden = YES;
        }
        hiddenBar = nil;
        showBar = nil;
        self.sn_gesturePopState = SNTransitionStateNone;
    }];
}

#pragma mark - 处理手势

- (void)updateNavigationBarCustom2CustomWithFromVC:(UIViewController *)fromVc toVC:(UIViewController *)toVc progress:(CGFloat)progress {
    [self updateNavigationBarFromVC:fromVc toVC:toVc progress:progress];
}

- (void)updateNavigationBarSystem2CustomWithFromVC:(UIViewController *)fromVc toVC:(UIViewController *)toVc progress:(CGFloat)progress {
    [self updateNavigationBarFromVC:fromVc toVC:toVc progress:progress];
}

- (void)updateNavigationBarCustom2SystemWithFromVC:(UIViewController *)fromVc toVC:(UIViewController *)toVc progress:(CGFloat)progress {
    [self updateNavigationBarFromVC:fromVc toVC:toVc progress:progress];
}

static UIView *hiddenBar = nil;
static UIView *showBar = nil;
- (void)updateNavigationBarFromVC:(UIViewController *)fromVc toVC:(UIViewController *)toVc progress:(CGFloat)progress {
    
    // 颜色
    UIColor *fromBarColor = fromVc.sn_keepBackgroundColor;
    UIColor *toBarColor = toVc.sn_keepBackgroundColor;
    UIColor *newBarTintColor = [UIColor middleColor:fromBarColor toColor:toBarColor percent:progress];
    
    // 透明度
    CGFloat fromBarAlpha = fromVc.sn_keepAlpha;
    CGFloat toBarAlpha = toVc.sn_keepAlpha;
    CGFloat newBarAlpha = fromBarAlpha + (toBarAlpha-fromBarAlpha)*progress;
    
    // 高度
    CGFloat fromBarTranslationY = fromVc.sn_keepTranslationY;
    CGFloat toBarTranslationY = toVc.sn_keepTranslationY;
    CGFloat newBarTranslationY = fromBarTranslationY + (toBarTranslationY-fromBarTranslationY)*progress;
    
    // 调整隐藏导航栏问题
    if (toVc.sn_navBarHidden &&
        !fromVc.sn_navBarHidden) {
        newBarTintColor = fromBarColor;
        newBarAlpha = fromBarAlpha;
    }
    if (!toVc.sn_navBarHidden &&
        fromVc.sn_navBarHidden) {
        newBarTintColor = toBarColor;
        newBarAlpha = toBarAlpha;
    }
    
    // 自定义导航
    if (![fromVc.sn_keepCustomBar isKindOfClass:[SimpleNavigationCustomBar class]]) {
        // 用户自定义导航 -> 默认自定义导航
        hiddenBar = fromVc.sn_keepCustomBar;
        [fromVc.sn_keepCustomBar.subviews makeObjectsPerformSelector:@selector(setAlpha:) withObject:@(1-progress)];
    } else if (![toVc.sn_keepCustomBar isKindOfClass:[SimpleNavigationCustomBar class]] ) {
        // 默认自定义导航 -> 用户自定义导航
        showBar = toVc.sn_keepCustomBar;
        [toVc.sn_keepCustomBar.subviews makeObjectsPerformSelector:@selector(setAlpha:) withObject:@(progress)];
    } else if (![fromVc.sn_keepCustomBar isKindOfClass:[SimpleNavigationCustomBar class]] && ![toVc.sn_keepCustomBar isKindOfClass:[SimpleNavigationCustomBar class]]) {
        // 用户自定义导航 ->  用户自定义导航
        [toVc.sn_keepCustomBar.subviews makeObjectsPerformSelector:@selector(setAlpha:) withObject:@(progress)];
    }
    
    // 设置转场的状态
    toVc.sn_navBarBackgroundColor = newBarTintColor;
    toVc.sn_navBarAlpha = newBarAlpha;
    toVc.sn_translationY = newBarTranslationY;
    if (fromBarTranslationY!=toBarTranslationY) { // 存在高度切换时将下划线干掉
        toVc.sn_navBarBottomLineHidden = YES;
    }
}



@end
