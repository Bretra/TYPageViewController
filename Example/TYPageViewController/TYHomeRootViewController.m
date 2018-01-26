//
//  TYHomeRootViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/25.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYHomeRootViewController.h"
#import <TYPageViewController/TYPageViewControllerHeader.h>
#import "TYViewController.h"
#import "TYRecommetViewController.h"


@interface TYHomeRootViewController ()<TYPageViewControllerDataSource ,TYPageViewControllerDelagate,TYBasePageBarDataSource ,TYBasePageBarDelegate>
/** bar */
@property (nonatomic , weak) TYBasePageBar *pageBar;
/** 数据源 */
@property (nonatomic , strong) NSMutableArray <UIViewController *> *dataArray;
/** 垂直滚动的百分比 */
@property (nonatomic , assign) CGFloat offsetPrecent;
@end

@implementation TYHomeRootViewController
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - setupBasic
- (void)setupBasic {
    
    self.DataSource = self;
    self.Delegate = self;
    TYRecommetViewController *vc1 = [[TYRecommetViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.title = @"推荐";
    TYViewController *vc2 = [TYViewController new];
    vc2.title = @"关注";
    vc2.view.backgroundColor = [UIColor blueColor];
    
    [self.dataArray addObject:vc1];
    [self.dataArray addObject:vc2];

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
    pageBar.layout.cellWidth = (375 - 90) / 3;
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 88)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
/// headerView 的高度
- (CGFloat)pageHeaderBottomInsetForPageViewController:(TYPageViewController *)pageViewController {
    return BarDefaultHeight;
}

///修改TaBar的frame
- (CGRect)pageHeaderTabBarFrameForPageViewController:(TYPageViewController *)pageViewController {
    
    return  CGRectMake(0, 44, 200, 44);
}

/// 垂直滚动偏移的百分比
- (void)pageViewController:(TYPageViewController *)pageViewController scrollViewVerticalScroll:(CGFloat)contentPercentY {

      self.offsetPrecent = contentPercentY;
    
}
///选了那个ItemBar
- (void)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    
    [self scrollToIndex:index animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end