//
//  MTDemo2ViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/29.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "MTDemo2ViewController.h"

#import "TYRecommetViewController.h"
#import "TYViewController.h"

@interface MTDemo2ViewController ()

@end

@implementation MTDemo2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

#pragma mark - setupUI
- (void)setupUI {
    
    self.view.backgroundColor = [UIColor redColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"MTDemo2ViewController  --- %s" , __func__);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"MTDemo2ViewController  --- %s" , __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
