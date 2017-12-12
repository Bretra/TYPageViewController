//
//  TYPageViewController+Private.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewController.h"

@interface TYPageViewController (Private)

@property (nonatomic, readonly) UIScrollView  *scrollView;
@property (nonatomic, readonly) NSArray       *viewControllers;
@property (nonatomic, strong)   UIView        *tabHeaderView;

@end
