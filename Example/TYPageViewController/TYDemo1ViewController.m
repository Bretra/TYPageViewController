//
//  TYDemo1ViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/31.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYDemo1ViewController.h"

@interface TYDemo1ViewController ()

@end

@implementation TYDemo1ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"TYDemo1ViewController  --- %s" , __func__);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"TYDemo1ViewController  --- %s" , __func__);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
