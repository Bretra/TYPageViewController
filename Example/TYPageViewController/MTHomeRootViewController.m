//
//  TYHomeRootViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/25.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "MTHomeRootViewController.h"
#import <TYPageViewController/TYPageViewControllerHeader.h>
#import "TYViewController.h"
#import "TYRecommetViewController.h"
#import "MTTitleView.h"
#import "TYDemo1ViewController.h"
#import <MJRefresh/MJRefresh.h>


@interface MTHomeRootViewController ()<TYPageViewControllerDataSource ,TYPageViewControllerDelagate,TYBasePageBarDataSource ,TYBasePageBarDelegate ,MTTitleViewDelegate>
/** bar */
@property (nonatomic , weak) TYBasePageBar *pageBar;
/** 数据源 */
@property (nonatomic , strong) NSMutableArray <UIViewController *> *dataArray;
/** 垂直滚动的百分比 */
@property (nonatomic , assign) CGFloat offsetPrecent;
/** TitleView */
@property (nonatomic , weak) MTTitleView *titleView;
/** 进度view */
@property (nonatomic , weak) UIView *progressView;
@end

@implementation
MTHomeRootViewController
- (NSMutableArray<UIViewController *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    [self setupBasic];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - setupBasic
- (void)setupBasic {
    
    self.DataSource = self;
    self.Delegate = self;
//    self.headerZoomIn = NO;
    
    TYDemo1ViewController *vc1 = [[TYDemo1ViewController alloc] init];
    vc1.title = @"推荐";
    
    TYViewController *vc2 = [TYViewController new];
    vc2.title = @"关注";

    TYViewController *vc3 = [TYViewController new];
    vc3.title = @"喜欢";
    
    [self.dataArray addObject:vc1];
    [self.dataArray addObject:vc2];
    [self.dataArray addObject:vc3];
    
    
}



#pragma mark - seupUI
- (void)setupUI {
    
    TYBasePageBar *pageBar = [[TYBasePageBar alloc] init];
    pageBar.dataSource = self;
    pageBar.collectionView.backgroundColor = [UIColor whiteColor];
    pageBar.delegate = self;
    pageBar.layout.adjustContentCellsCenter = YES;
    pageBar.layout.cellSpacing = 0;
    pageBar.layout.progressHeight = 4;
    pageBar.layout.progressWidth = 60;
    pageBar.layout.cellEdging = 0;
    pageBar.layout.cellWidth = 100;
    pageBar.layout.textAnimateEnable = YES;
    pageBar.layout.selectedTextColor = [UIColor blackColor];
    pageBar.layout.normalTextColor = [UIColor darkGrayColor];
    pageBar.layout.progressColor = [UIColor redColor];
    pageBar.layout.normalTextFont = [UIFont boldSystemFontOfSize:30];
    pageBar.layout.selectedTextFont = [UIFont boldSystemFontOfSize:50];
    [pageBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    self.pageBar = pageBar;
    
 TYPageViewControllerPluginTabBar *pagePlugin =   [[TYPageViewControllerPluginTabBar alloc] initWithTabViewBar:self.pageBar delegate:nil];
    [self enablePlugin:pagePlugin];
    
    CGRect frame = CGRectMake(0 , 0, [UIScreen mainScreen].bounds.size.width, 44);
    /** TitleView */
    MTTitleView *titleView = [[MTTitleView alloc] initWithFrame:frame];
    titleView.delegate = self;
//    [self.view addSubview:titleView];
    self.titleView = titleView;
    
    /** 进度view */
    UIView *progressView = [[UIView alloc] init];
    progressView.backgroundColor = [UIColor redColor];
    progressView.frame = CGRectMake(15, 15, 87, 129);
    progressView.alpha = 0.0;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    
}

- (void)loadData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
    
}

#pragma mark - TYPublishProgressProtocol
- (UIView *)getProgressView {
    return self.progressView;
}

/// 有多少个子视图控制器
- (NSInteger)numberOfViewControllerForTabViewController:(TYPageViewController *)pageViewController {
    
    return self.dataArray.count;
}
/// 对应index 的 ViewController
- (UIViewController *)pageViewController:(TYPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    
    return self.dataArray[index];
    
}
//有多少个Bar
- (NSInteger)numberOfItemsInPagerTabBar {
    
    return self.dataArray.count;
}
// 每个Bar的样式
- (UICollectionViewCell<TYTabPagerBarCellProtocol> *_Nullable)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    TYTabPagerBarCell <TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.dataArray[index].title;
    return cell;
}

- (UIView *)pageHeaderViewForPageViewController:(TYPageViewController *)pageViewController {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 200)];
    view.backgroundColor = [UIColor redColor];
    return view;
}
/// headerView 的高度
- (CGFloat)pageHeaderBottomInsetForPageViewController:(TYPageViewController *)pageViewController {
    return BarDefaultHeight + CGRectGetMaxY(self.navigationController.navigationBar.frame);
}
/////修改TaBar的frame
//- (CGRect)pageHeaderTabBarFrameForPageViewController:(TYPageViewController *)pageViewController {
//
//    return  CGRectMake(0, 44, 200, 44);
//}

/// 垂直滚动偏移的百分比
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewVerticalScroll:(CGFloat)contentPercentY {
    
//    if (contentPercentY >= 0 && contentPercentY < 1) {
//        self.pageBar.alpha = 1- contentPercentY;
//        [self.titleView statrAnimationing:contentPercentY];
//    }else {
//        [self.titleView statrAnimationing:contentPercentY];
//    }
}
/// 从哪个item滚动到某个Item
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate {
    
//    NSLog(@"FromIndex%zd ----toIndex%zd" ,fromIndex , toIndex);
    [self.titleView scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animate];
}
///从哪个item滚动到某个Item 带有滑动过程中的进度
- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
//    NSLog(@"FromIndex%zd ----toIndex%zd----progress%f" ,fromIndex , toIndex , progress);
    [self.titleView scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

///选了那个ItemBar
- (void)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    
    [self scrollToIndex:index animated:YES];
    [self.titleView pageBarCurrentSelectedIndex:index];
}

#pragma mark - MTTitleViewDelegate
///选了那个ItemBar
- (void)titlePagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    
    [self scrollToIndex:index animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
