//
//  TYPageViewController+Extension.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewController.h"

@interface UIViewController (pageExtension)

@property (nonatomic, weak) TYPageViewController *pageViewController;

@property (nonatomic, weak) UIScrollView   *pageContentScrollView;
@end
