//
//  TYPageViewController.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYPageViewController , TYPageViewControllerPluginBase;

///代理
@protocol TYPageViewControllerDelagate <NSObject>

@optional
/// 垂直滚动偏移的百分比
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewVerticalScroll:(CGFloat)contentPercentY;
/// 水平滚动的偏移量
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewHorizontalScroll:(CGFloat)contentOffsetX;
/// will 滚动到那个index
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewWillScrollFromIndex:(NSInteger)index;
/// did 滚动到某个index
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewDidScrollToIndex:(NSInteger)index;
@end

///数据源
@protocol TYPageViewControllerDataSource <NSObject>

@required
/// 有多少个子视图控制器
- (NSInteger)numberOfViewControllerForTabViewController:(TYPageViewController *)pageViewController;
/// 对应index 的 ViewController
- (UIViewController *)pageViewController:(TYPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index;

@optional
/// 自定制的headerView
- (UIView *)pageHeaderViewForPageViewController:(TYPageViewController *)pageViewController;
/// headerView 的高度
- (CGFloat)pageHeaderBottomInsetForPageViewController:(TYPageViewController *)pageViewController;
/// 内容边距
- (UIEdgeInsets)containerInsetsForPageViewController:(TYPageViewController *)pageViewController;
///修改TaBar的frame
- (CGRect)pageHeaderTabBarFrameForPageViewController:(TYPageViewController *)pageViewController;

@end

@interface TYPageViewController : UIViewController
////数据源
@property (nonatomic, weak)      id<TYPageViewControllerDataSource>  DataSource;
///代理
@property (nonatomic, weak)      id<TYPageViewControllerDelagate>    Delegate;
///当header没有的时候 默认为NO
@property (nonatomic, assign)    BOOL            headerZoomIn;
///当前的下标
@property (nonatomic, assign, readonly)  NSInteger       curIndex;
/// 滚动到某个index
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;
/// 获取某个index的ViewController
- (UIViewController *)viewControllerForIndex:(NSInteger)index;
/// 刷新 ---会刷新 整体scroll 当前的偏移量 归位--tabBar 归位 重置状态
- (void)reloadData;
///加载插件
- (void)enablePlugin:(TYPageViewControllerPluginBase *)plugin;
///移除插件
- (void)removePlugin:(TYPageViewControllerPluginBase *)plugin;
@end
