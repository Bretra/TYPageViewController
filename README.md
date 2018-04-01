# TYPageViewController

[![CI Status](http://img.shields.io/travis/1130128166@qq.com/TYPageViewController.svg?style=flat)](https://travis-ci.org/1130128166@qq.com/TYPageViewController)
[![Version](https://img.shields.io/cocoapods/v/TYPageViewController.svg?style=flat)](http://cocoapods.org/pods/TYPageViewController)
[![License](https://img.shields.io/cocoapods/l/TYPageViewController.svg?style=flat)](http://cocoapods.org/pods/TYPageViewController)
[![Platform](https://img.shields.io/cocoapods/p/TYPageViewController.svg?style=flat)](http://cocoapods.org/pods/TYPageViewController)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

TYPageViewController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'TYPageViewController'
```

## Author

1130128166@qq.com, wangzhiming@tuyabeat.com

# 使用方法

```
继承TYPageViewController
1.设置数据源
 self.DataSource = self;
    self.Delegate = self;
    self.title = @"个人主页";
    TYWeiBoHomeViewController *homeVc = [TYWeiBoHomeViewController new];
    homeVc.title = @"主页";
    [self.pageViewControllers addObject:homeVc];
    
    TYWeiBoViewController *weiboVc = [TYWeiBoViewController new];
    weiboVc.title = @"微博";
    [self.pageViewControllers addObject:weiboVc];
    
    TYWeiBoVideoViewController *videoVc = [TYWeiBoVideoViewController new];
    videoVc.title = @"视频";
    [self.pageViewControllers addObject:videoVc];
    
    TYWeiBoPhotoViewController *photoVc = [TYWeiBoPhotoViewController new];
    photoVc.title = @"相册";
    [self.pageViewControllers addObject:photoVc];
    
 2.初始化PageBar
  TYBasePageBar *pageBar = [[TYBasePageBar alloc] init];
    pageBar.dataSource = self;
    pageBar.collectionView.backgroundColor = [UIColor whiteColor];
    pageBar.delegate = self;
    pageBar.layout.progressWidth = 50;
    pageBar.layout.progressHeight = 4;
    pageBar.layout.progressRadius = 2;
    pageBar.layout.cellWidth = (self.view.bounds.size.width - 30) / 4;
    pageBar.layout.textAnimateEnable = YES;
    pageBar.layout.selectedTextColor = [UIColor blackColor];
    pageBar.layout.normalTextColor = [UIColor darkGrayColor];
    pageBar.layout.progressColor = [UIColor orangeColor];
    pageBar.layout.normalTextFont = [UIFont systemFontOfSize:16];
    pageBar.layout.selectedTextFont = [UIFont systemFontOfSize:16];
    [pageBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    
    TYPageViewControllerPluginTabBar *tabViewBarPlugin = [[TYPageViewControllerPluginTabBar alloc] initWithTabViewBar:pageBar delegate:nil];
    [self enablePlugin:tabViewBarPlugin];
    
    [self enablePlugin:[[TYPageViewControllerPluginHeaderScroll alloc] init]];
```

# 数据源

```
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
```

# 代理

```
/// 垂直滚动偏移的百分比
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewVerticalScroll:(CGFloat)contentPercentY;
/// 水平滚动的偏移量
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewHorizontalScroll:(CGFloat)contentOffsetX;
/// will 滚动到那个index
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewWillScrollFromIndex:(NSInteger)index;
/// did 滚动到某个index
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewDidScrollToIndex:(NSInteger)index;
/// 从哪个item滚动到某个Item
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate;
///从哪个item滚动到某个Item 带有滑动过程中的进度
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;
```



## License

TYPageViewController is available under the MIT license. See the LICENSE file for more info.
