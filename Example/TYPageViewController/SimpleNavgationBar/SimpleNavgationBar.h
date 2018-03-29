//
//  SimpleNavgationBar.h
//  HeiPa
//
//  Created by wyman on 2017/9/11.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SimpleNavgationBar)

/** 透明度 */
@property (nonatomic, assign) CGFloat sn_navBarAlpha;
/** 背景色 */
@property (nonatomic, strong) UIColor *sn_navBarBackgroundColor;
/** 底部线条隐藏 */
@property (nonatomic, assign) BOOL sn_navBarBottomLineHidden;
/** 高度[设置这个会在手势转场自动隐藏分割线] */
@property (nonatomic, assign) float sn_translationY;
/** 自定义bar，此属性在转场时有值，是否设置是系统原生的bar依赖sn_isCustomBar进行判断 */
@property (nonatomic, strong) UIView *sn_customBar;
/** 是否调用自定义属性，说明自定义bar */
@property (nonatomic, assign) BOOL sn_isCustomBar;
/** 重置 */
- (void)sn_reset;


/** 自定义bar，控制隐藏 */
@property (nonatomic, assign, readonly) BOOL sn_navBarHidden;
- (void)sn_navBarHidden:(BOOL)animated;
- (void)sn_navBarShow:(BOOL)animated;
- (void)sn_openScreenPop; // 开启侧滑



@end




