//
//  TYRecommetViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/25.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYRecommetViewController.h"
#import "MJRefresh.h"

@interface TYRecommetViewController ()<UITableViewDataSource>
/** tableView */
@property (nonatomic , weak) UITableView *tableView;
@end

@implementation TYRecommetViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:0];
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    //初始化下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.tableView.mj_header = header;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"TYViewController  --- %s" , __func__);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"TYViewController  --- %s" , __func__);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


#pragma mark - loadData
- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    });
}



#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zd" , indexPath.row];
    return cell;
    
}


@end
