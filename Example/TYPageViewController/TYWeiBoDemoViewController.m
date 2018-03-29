//
//  TYWeiBoDemoViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/3/29.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYWeiBoDemoViewController.h"
#import "TYWeiBoHomeViewController.h"
#import "TYWeiBoViewController.h"
#import "TYWeiBoVideoViewController.h"
#import "TYWeiBoPhotoViewController.h"
#import "SimpleNavgationBar.h"
#import "TYWeiBoUserProfileHeaderView.h"

@interface TYWeiBoDemoViewController ()<TYPageViewControllerDelagate,TYPageViewControllerDataSource,TYBasePageBarDataSource,TYBasePageBarDelegate>
@property(nonatomic, strong) NSMutableArray<UIViewController *> *pageViewControllers;
@end

@implementation TYWeiBoDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.sn_navBarBackgroundColor = [UIColor whiteColor];
    self.sn_navBarAlpha = 0.0;
    self.sn_navBarBottomLineHidden = YES;
}

#pragma mark - setupUI
- (void)setupUI {
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
    
}

#pragma mark - TYPageViewControllerDataSource
/// 有多少个子视图控制器
- (NSInteger)numberOfViewControllerForTabViewController:(TYPageViewController *)pageViewController {
    return self.pageViewControllers.count;
}
/// 对应index 的 ViewController
- (UIViewController *)pageViewController:(TYPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    UIViewController *pageVc = self.pageViewControllers[index];
    return pageVc;
}

- (UIView *)pageHeaderViewForPageViewController:(TYPageViewController *)pageViewController {
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, 300);
    
    TYWeiBoUserProfileHeaderView *userDetailContanirView = [[TYWeiBoUserProfileHeaderView alloc] initWithFrame:rect];
    return userDetailContanirView;
}

- (CGFloat)pageHeaderBottomInsetForPageViewController:(TYPageViewController *)pageViewController {
    return BarDefaultHeight + CGRectGetMaxY(self.navigationController.navigationBar.frame);
}

- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewVerticalScroll:(CGFloat)contentPercentY {
    self.sn_navBarAlpha = contentPercentY;
    self.sn_navBarBottomLineHidden = !(contentPercentY == 1);
}

//有多少个Bar
- (NSInteger)numberOfItemsInPagerTabBar {
    return self.pageViewControllers.count;
}
// 每个Bar的样式
- (UICollectionViewCell<TYTabPagerBarCellProtocol> *_Nullable)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    TYTabPagerBarCell <TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
     UIViewController *pageVc = self.pageViewControllers[index];
    cell.titleLabel.text = pageVc.title;
    return cell;
}
///选了那个ItemBar
- (void)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self scrollToIndex:index animated:YES];
}

- (NSMutableArray<UIViewController *> *)pageViewControllers {
    if (!_pageViewControllers) {
        _pageViewControllers = [NSMutableArray array];
    }
    return _pageViewControllers;
}

@end
