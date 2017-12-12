//
//  TYPageBar.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import <UIKit/UIKit.h>
static const CGFloat BarDefaultHeight = 44.0f;

@protocol TYPageBar

@required
/// 子类必须实现
- (void)reloadTabBar;

@optional
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate;

- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

- (void)tabScrollXPercent:(CGFloat)percent;

- (void)tabScrollXOffset:(CGFloat)contentOffsetX;

- (void)tabDidScrollToIndex:(NSInteger)index;

@end
@interface TYPageBar : UIView <TYPageBar>

@end
