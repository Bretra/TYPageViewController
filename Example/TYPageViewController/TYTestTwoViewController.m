//
//  TYTestTwoViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/2/23.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYTestTwoViewController.h"
#import "TYCircleProgressView.h"

@interface TYTestTwoViewController ()

@end

@implementation TYTestTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
    TYCircleProgressView *progressView = [[TYCircleProgressView alloc] init];
    progressView.tintColor = [UIColor blueColor];
    progressView.fillColor = [UIColor redColor];
    progressView.borderWidth = 10;
    progressView.frame = CGRectMake(100, 100, 200, 200);
    [self.view addSubview:progressView];
    
    
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
