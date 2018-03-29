//
//  TYTabBar.m
//  HeiPa
//
//  Created by wyman on 2017/8/10.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "TYTabBar.h"
#import "TYCreateionRootViewController.h"

@interface TYTabBar ()

@property (nonatomic, weak) UIButton *centerBtn;

@end

@implementation TYTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *centerBtn = [UIButton new];
        
        centerBtn.frame = CGRectMake(0, 0, 44, 44);
        [centerBtn setImage:[UIImage imageNamed:@"toolbar_creation"] forState:UIControlStateNormal];
        [centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [centerBtn setTitle:@"创作" forState:UIControlStateNormal];
        [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        centerBtn.titleLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:centerBtn];
        self.centerBtn = centerBtn;
        
        // 透明背景
        self.backgroundImage = [UIImage imageNamed:@"toolbar_bg"];
        self.shadowImage = [[UIImage alloc]init];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.centerBtn.bounds = CGRectMake(0, 0, 44, 44);
    self.centerBtn.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
//#warning 此处不知为何需要调到最前面，待解决
    [self bringSubviewToFront:self.centerBtn];

    NSInteger index = 0;
    NSInteger itemCount = self.items.count;
    if (!itemCount) return;
    for (UIView *subView in self.subviews) {
        // 非tabBarButton 则不布局
        if (![[subView.class description] isEqualToString:@"UITabBarButton"]) continue;
        
        // 计算坐标
        CGFloat btnW = (self.bounds.size.width - self.centerBtn.bounds.size.width) / itemCount;
        CGFloat btnH = self.bounds.size.height;
        CGFloat btnX = (index < (itemCount/2)) ? index * btnW : index * btnW + self.centerBtn.bounds.size.width;
        CGFloat btnY = 0;
        subView.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        // 记录第几个
        index++;
    }

}

- (void)centerBtnClick:(UIButton *)btn {
  
    
    TYCreateionRootViewController *videoVc = [[TYCreateionRootViewController alloc] init];
    
        UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:videoVc];
        
        [rootVc presentViewController:nav animated:YES completion:nil];

}




@end
