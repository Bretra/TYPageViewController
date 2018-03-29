//
//  UINavigationController+SimpleNavigationBar.h
//  SimpleNavigationBar
//
//  Created by wyman on 2017/12/7.
//  Copyright © 2017年 wyman. All rights reserved.
//
//  导航状态的转场过渡逻辑

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SNTransitionState) {
    SNTransitionStateNone,      // 无状态
    SNTransitionStateBegan,     // 开始侧滑
    SNTransitionStateMoving,    // 侧滑中
    SNTransitionStateCancel,    // 侧滑取消
    SNTransitionStateAnimating, // 取消后的后续动画
};

@interface UINavigationController (SimpleNavigationBar) <UIGestureRecognizerDelegate>

#pragma mark - 手势转场状态
@property (nonatomic, assign) SNTransitionState sn_gesturePopState;

#pragma mark - 添加手势监听
- (void)sn_addGuestTarget;


@end
