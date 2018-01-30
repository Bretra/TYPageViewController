//
//  MTDemo2ViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/29.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "MTDemo2ViewController.h"
#import <SwipeTableView/SwipeTableView.h>
#import "TYRecommetViewController.h"
#import "TYViewController.h"

@interface MTDemo2ViewController ()<SwipeTableViewDataSource , SwipeTableViewDelegate>
@property (nonatomic, strong) SwipeTableView * swipeTableView;
@property (nonatomic, strong) STHeaderView * tableViewHeader;
@property (nonatomic, strong) UIView *pageBar;
@property (nonatomic, strong) NSMutableArray <UIViewController *> *dataArray;
@end

@implementation MTDemo2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark - setupUI
- (void)setupUI {
    // init swipetableview
    self.swipeTableView = [[SwipeTableView alloc]initWithFrame:self.view.bounds];
    _swipeTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _swipeTableView.delegate = self;
    _swipeTableView.dataSource = self;
    _swipeTableView.shouldAdjustContentSize = YES;
    _swipeTableView.swipeHeaderView = self.tableViewHeader;
    _swipeTableView.swipeHeaderBar = self.pageBar;
    _swipeTableView.swipeHeaderTopInset = 0;
    [self.view addSubview:_swipeTableView];
    TYRecommetViewController *vc1 = [[TYRecommetViewController alloc] init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.title = @"推荐";
    TYViewController *vc2 = [TYViewController new];
    vc2.title = @"关注";
    vc2.view.backgroundColor = [UIColor redColor];
    
    [self.dataArray addObject:vc1];
    [self.dataArray addObject:vc2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - SwipeTableViewDataSource
- (NSInteger)numberOfItemsInSwipeTableView:(SwipeTableView *)swipeView {
    
    return self.dataArray.count;
}

- (UIScrollView *)swipeTableView:(SwipeTableView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIScrollView *)view {
    
    UIScrollView *scrollView = (UIScrollView *)self.dataArray[index].view;
    return scrollView;
}


#pragma mark - 懒加载
- (STHeaderView *)tableViewHeader {
    if (!_tableViewHeader) {
        _tableViewHeader = [[STHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
        _tableViewHeader.backgroundColor = [UIColor redColor];
    }
    return _tableViewHeader;
}

- (UIView *)pageBar {
    if (!_pageBar) {
        _pageBar = [[UIView alloc] init];
        _pageBar.backgroundColor = [UIColor orangeColor];
        _pageBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 40);
    }
    return _pageBar;
}

- (NSMutableArray<UIViewController *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
