//
//  TYViewController.m
//  TYPageViewController
//
//  Created by 1130128166@qq.com on 12/12/2017.
//  Copyright (c) 2017 1130128166@qq.com. All rights reserved.
//

#import "TYViewController.h"

@interface TYViewController ()<UITableViewDataSource>

@end

@implementation TYViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
