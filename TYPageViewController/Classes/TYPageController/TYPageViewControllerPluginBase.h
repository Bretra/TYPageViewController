//
//  TYPageViewControllerPluginBase.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  TYPageViewController;

/*子类实现-----协议*/
@protocol TYPageViewControllerPlugin <NSObject>
///ScrollView垂直滚动 contentPercentY 内容偏移的百分比
- (void)scrollViewVerticalScroll:(CGFloat)contentPercentY;
/// ScrollView 水平滚动
- (void)scrollViewHorizontalScroll:(CGFloat)contentOffsetX;
/// will 从哪个滚动过来
- (void)scrollViewWillScrollFromIndex:(NSInteger)index;
/// did 滚动到哪里去了
- (void)scrollViewDidScrollToIndex:(NSInteger)index;
/// 从哪个item滚动到某个Item
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate;
///从哪个item滚动到某个Item 带有滑动过程中的进度
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;
@end
@interface TYPageViewControllerPluginBase : NSObject<TYPageViewControllerPlugin>

@property (nonatomic, assign) TYPageViewController  *pageViewController;

// 初始化插件
- (void)initPlugin;

// 当pageViewController调用
- (void)loadPlugin;

//  当pageViewController 调用了 reload 后调用
- (void)removePlugin;
@end
