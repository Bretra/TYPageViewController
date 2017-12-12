//
//  TYBasePageBar.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/13.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageBar.h"
#import "TYBasePageBarLayout.h"
NS_ASSUME_NONNULL_BEGIN
@class TYBasePageBar;
///数据源
@protocol TYBasePageBarDataSource <NSObject>
//有多少个Bar
- (NSInteger)numberOfItemsInPagerTabBar;
// 每个Bar的样式
- (UICollectionViewCell<TYTabPagerBarCellProtocol> *_Nullable)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar cellForItemAtIndex:(NSInteger)index;
@end

///代理
@protocol TYBasePageBarDelegate <NSObject>

@optional
///配置布局
- (void)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar configureLayout:(TYBasePageBarLayout *_Nullable)layout;

///每个item的宽度 当cell的Width没有时可以使用这个方法返回高度
- (CGFloat)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar widthForItemAtIndex:(NSInteger)index;

///选了那个ItemBar
- (void)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar didSelectItemAtIndex:(NSInteger)index;

///item的过渡动画
- (void)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar transitionFromeCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> * _Nullable)fromCell toCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> * _Nullable)toCell animated:(BOOL)animated;

///动画的进度
- (void)pagerTabBar:(TYBasePageBar *_Nonnull)pagerTabBar transitionFromeCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> * _Nullable)fromCell toCell:(UICollectionViewCell<TYTabPagerBarCellProtocol> * _Nullable)toCell progress:(CGFloat)progress;
@end

@interface TYBasePageBar : TYPageBar

@property (nonatomic, weak, readonly) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *progressView;
// 自动设置为Self.bounds
@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, weak, nullable) id<TYBasePageBarDataSource> dataSource;

@property (nonatomic, weak, nullable) id<TYBasePageBarDelegate> delegate;

@property (nonatomic, strong) TYBasePageBarLayout *layout;

@property (nonatomic, assign, readonly) NSInteger countOfItems;

@property (nonatomic, assign, readonly) NSInteger curIndex;

@property (nonatomic, assign) UIEdgeInsets contentInset;
/// 类名注册 cell
- (void)registerClass:(Class)Class forCellWithReuseIdentifier:(NSString *)identifier;
/// xib注册 cell
- (void)registerNib:(UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;
///某个index的cell --->ItemBar 这个是从复用池中取
- (__kindof UICollectionViewCell<TYTabPagerBarCellProtocol> *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;
///当reloadData时会调用CollectionView的ReloadData--重新识别数据源
- (void)reloadData;
/// 非手势进度切换barView
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate;
///手势进度切换
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

/// 某一个item的的宽度
- (CGFloat)cellWidthForTitle:(NSString * _Nullable)title;
- (CGRect)cellFrameWithIndex:(NSInteger)index;//index的cell的Frame
//获取当前的index 的cell 真实的cell
- (nullable UICollectionViewCell<TYTabPagerBarCellProtocol> *)cellForIndex:(NSInteger)index;

@end
NS_ASSUME_NONNULL_END
