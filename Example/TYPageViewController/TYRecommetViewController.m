//
//  TYRecommetViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/25.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYRecommetViewController.h"

@interface TYRecommetViewController ()<UITableViewDataSource>

@end

@implementation TYRecommetViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UITableView *tab = [[UITableView alloc] initWithFrame:self.view.bounds style:0];
    tab.dataSource = self;
    [self.view addSubview:tab];
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
    return cell;
    
}


@end
