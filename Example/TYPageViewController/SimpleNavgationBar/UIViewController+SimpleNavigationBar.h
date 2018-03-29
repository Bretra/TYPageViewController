//
//  UIViewController+SimpleNavigationBar.h
//  SimpleNavigationBar
//
//  Created by wyman on 2017/12/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SimpleNavigationBar)

/** 颜色 */
@property (nonatomic, strong) UIColor *sn_keepBackgroundColor;
/** 透明度 */
@property (nonatomic, assign) float sn_keepAlpha;
/** 模糊层是否隐藏 */
@property (nonatomic, assign) BOOL sn_keepVisualEffectHidden;
/** 分割线是否隐藏 */
@property (nonatomic, assign) BOOL sn_keepBottomLineHidden;
/** 增加高度 */
@property (nonatomic, assign) float sn_keepTranslationY;
/** 自定义bar */
@property (nonatomic, strong) UIView *sn_keepCustomBar;

@end
