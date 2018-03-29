//
//  TYTabBarController.m
//  HeiPa
//
//  Created by wyman on 2017/8/10.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "TYTabBarController.h"
#import "TYTabBar.h"
#import "MTHomeRootViewController.h"
#import "TYTestOneViewController.h"
#import "TYTestTwoViewController.h"
#import "TYThreeViewController.h"
@interface TYTabBarController ()

@end

@implementation TYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupChildVcs];
    
    [self setValue:[[TYTabBar alloc] init] forKey:@"tabBar"];
    self.tabBar.translucent = NO;
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];

}

- (void)setupChildVcs {
   
     [self addChildVcWithVcClass:[MTHomeRootViewController class] title:@"首页" image:@"toolbar_home_nor" selectedImage:@"toolbar_home_sel"];
     [self addChildVcWithVcClass:[TYTestOneViewController class] title:@"发现" image:@"toolbar_found_nor" selectedImage:@"toolbar_found_sel"];
    [self addChildVcWithVcClass:[TYTestTwoViewController class] title:@"消息" image:@"toolbar_message_nor" selectedImage:@"toolbar_message_sel"];
     [self addChildVcWithVcClass:[TYThreeViewController class] title:@"我的" image:@"toolbar_my_nor" selectedImage:@"toolbar_my_sel"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.selectedIndex = 0;
}

- (void)addChildVcWithVcClass:(Class)vcClass title:(NSString *)title  image:(NSString *) image selectedImage:(NSString *) selectedImage {
    UIViewController *vc = [[vcClass alloc] init];
    vc.title = title;
    vc.tabBarItem.title = title;
    //设置自控制器的图片
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置文字的样式
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    
    attrs[NSForegroundColorAttributeName] =  [UIColor darkGrayColor];
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    [vc.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    [vc .tabBarItem setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:navVc];
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    return;
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    return;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {

}


@end
