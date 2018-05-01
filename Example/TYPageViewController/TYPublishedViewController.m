//
//  TYPublishedViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/2/23.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYPublishedViewController.h"
#import "TYPublishTransitionDelegate.h"

@interface TYPublishedViewController ()
/**  TYPublishTransitionDelegate */
@property (nonatomic , strong) TYPublishTransitionDelegate *publishTransitionDelegate;
@end

@implementation TYPublishedViewController

- (TYPublishTransitionDelegate *)publishTransitionDelegate {
    if (!_publishTransitionDelegate) {
        _publishTransitionDelegate = [[TYPublishTransitionDelegate alloc] init];
    }
    return _publishTransitionDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    NSLog(@"哈哈哈");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.navigationController.delegate = self.publishTransitionDelegate;
    self.navigationController.transitioningDelegate = self.publishTransitionDelegate;
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
