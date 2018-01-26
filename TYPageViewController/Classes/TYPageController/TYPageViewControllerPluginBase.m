//
//  TYPageViewControllerPluginBase.m
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewControllerPluginBase.h"

@implementation TYPageViewControllerPluginBase

// 初始化
- (void)initPlugin {
    
}

// 当pageViewController调用
- (void)loadPlugin {
    
}

//  当pageViewController 调用了 reload 后调用
- (void)removePlugin {
    
}

#pragma mark - 默认协议实现
- (void)scrollViewVerticalScroll:(CGFloat)contentPercentY {
    
}
- (void)scrollViewHorizontalScroll:(CGFloat)contentOffsetX {
    
}
- (void)scrollViewWillScrollFromIndex:(NSInteger)index {
    
}
- (void)scrollViewDidScrollToIndex:(NSInteger)index {
    
}
/// 从哪个item滚动到某个Item
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate {
    
}
///从哪个item滚动到某个Item 带有滑动过程中的进度
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    
}
///更新tabBar的frame
- (void)updatePageTabBarFrame:(CGRect)tabBarFrame contentPercentY:(CGFloat)contentPercentY animate:(BOOL)animate {
    
}

@end
