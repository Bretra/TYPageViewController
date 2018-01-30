//
//  MTTitleView.h
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/29.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TYBasePageBar;
@protocol MTTitleViewDelegate <NSObject>
///选了那个ItemBar
- (void)titlePagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar didSelectItemAtIndex:(NSInteger)index;
@end

@interface MTTitleView : UIView

/** 代理 */
@property (nonatomic , weak) id  <MTTitleViewDelegate> delegate;

- (void)statrAnimationing:(CGFloat)progresss;

- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate;

- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

- (void)pageBarCurrentSelectedIndex:(NSInteger)index;

NS_ASSUME_NONNULL_END;
@end
