//
//  TYBasePageBarLayout.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/13.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYTabPagerBarCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TYPageBarStyle) {
    TYPageBarStyleNoneView, //没有效果
    TYPageBarStyleProgressView, //进度滑动效果
    TYPageBarStyleProgressBounceView, // 进度滑动效果--->带有弹簧效果
    TYPageBarStyleProgressElasticView, //伸缩效果
    TYPageBarStyleCoverView,
};
@class  TYBasePageBar;
@interface TYBasePageBarLayout <__covariant ItemType>: NSObject
@property (nonatomic, weak, readonly) TYBasePageBar *pagerTabBar;

@property (nonatomic, assign, readonly) CGFloat selectFontScale;

@property (nonatomic, assign) TYPageBarStyle barStyle; // default TYPageBarStyleProgressElasticView

@property (nonatomic, assign) UIEdgeInsets sectionInset;

// 进度 view
@property (nonatomic, assign) CGFloat progressHeight;   // default 2.0f
@property (nonatomic, assign) CGFloat progressWidth; //如果有Item 这个进度的宽度等于cell的宽度
@property (nonatomic, strong, nullable) UIColor *progressColor;

@property (nonatomic, assign) CGFloat progressRadius;   // height/2
@property (nonatomic, assign) CGFloat progressBorderWidth;
@property (nonatomic, strong, nullable) UIColor *progressBorderColor;

@property (nonatomic, assign) CGFloat progressHorEdging; // default 6, if < 0 width + edge ,if >0 width - edge
@property (nonatomic, assign) CGFloat progressVerEdging; // default 0, cover style is 3.

// cell frame
@property (nonatomic, assign) CGFloat cellWidth; // default 0, if>0 如果不设置cell的宽度那么会以Label的Title的文字宽度来计算
@property (nonatomic, assign) CGFloat cellSpacing; // default 2,cell space
@property (nonatomic, assign) CGFloat cellEdging;  // default 3,cell 左边和右边的间距 当cell的宽度为0时 会失效
@property (nonatomic, assign) BOOL adjustContentCellsCenter;// default NO, cells center if contentSize < bar's width ,会设置 sectionInset

// 默认的cell只有一个Label
@property (nonatomic, strong) UIFont *normalTextFont;       // default 15
@property (nonatomic, strong) UIFont *selectedTextFont;     // default 17
@property (nonatomic, strong) UIColor *normalTextColor;     // default 51.51.51
@property (nonatomic, strong) UIColor *selectedTextColor;   // default white

@property (nonatomic, assign) BOOL textColorProgressEnable; // default YES
///是否开启文字的放大动画
@property (nonatomic, assign) BOOL textAnimateEnable;// default YES

///动画时间
@property (nonatomic, assign) CGFloat animateDuration;  // m默认 0.3

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
///初始化
- (instancetype)initWithPagerTabBar:(TYBasePageBar *)pagerTabBar NS_DESIGNATED_INITIALIZER;

- (void)layoutIfNeed;

- (void)invalidateLayout;

- (void)layoutSubViews;
///自动将所有的Item居中
- (void)adjustContentCellsCenterInBar;

// 重写
- (void)transitionFromCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> *_Nullable)fromCell toCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> *_Nullable)toCell animate:(BOOL)animate;

- (void)transitionFromCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> *_Nullable)fromCell toCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> *_Nullable)toCell progress:(CGFloat)progress;

- (void)setUnderLineFrameWithIndex:(NSInteger)index animated:(BOOL)animated;

- (void)setUnderLineFrameWithfromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;
@end
NS_ASSUME_NONNULL_END
