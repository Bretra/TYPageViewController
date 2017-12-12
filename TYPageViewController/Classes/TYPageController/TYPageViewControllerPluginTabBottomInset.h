//
//  TYPageViewControllerPluginTabBottomInset.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewControllerPluginBase.h"
@interface UIScrollView (TabBottomInset)

@property (nonatomic, assign) CGFloat tabBottomInset;

@end

@interface TYPageViewControllerPluginTabBottomInset : TYPageViewControllerPluginBase

@end
