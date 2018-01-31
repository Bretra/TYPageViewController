//
//  TYCreateionRootViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/31.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYCreateionRootViewController.h"
#import "TYDemo1ViewController.h"
#import "MTDemo2ViewController.h"
#import "MTTitleView.h"

@interface TYCreateionRootViewController ()<TYPageViewControllerDataSource , TYPageViewControllerDelagate , MTTitleViewDelegate>
/** 数据源 */
@property (nonatomic , strong) NSMutableArray <UIViewController *> *dataArray;
/** MTTitleView.h */
@property (nonatomic , weak) MTTitleView *titleView;
@end

@implementation TYCreateionRootViewController

- (NSMutableArray<UIViewController *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.Delegate = self;
    self.DataSource = self;
    self.scrollEnabled = NO;
    TYDemo1ViewController *demo1 = [[TYDemo1ViewController alloc] init];
    [self.dataArray addObject:demo1];
    MTDemo2ViewController *demo2 = [[MTDemo2ViewController alloc] init];
    [self.dataArray addObject:demo2];
    
    [self setupTitleView];
}

#pragma mark - setupTitleView
- (void)setupTitleView {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat H = [UIScreen mainScreen].bounds.size.height;
    
    /** MTTitleView.h */
    MTTitleView *titleView = [[MTTitleView alloc] initWithFrame:CGRectMake(0, H -44 , w, 44)];
    titleView.backgroundColor = [UIColor whiteColor];
    titleView.delegate = self;
    [self.view addSubview:titleView];
    self.titleView = titleView;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}


#pragma mark - TYPageViewControllerDataSource
/// 有多少个子视图控制器
- (NSInteger)numberOfViewControllerForTabViewController:(TYPageViewController *)pageViewController {
    
    return self.dataArray.count;
    
}
/// 对应index 的 ViewController
- (UIViewController *)pageViewController:(TYPageViewController *)pageViewController viewControllerForIndex:(NSInteger)index {
    UIViewController *vc = self.dataArray[index];
    return vc;
}

///选了那个ItemBar
- (void)titlePagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [self
     scrollToIndex:index animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
