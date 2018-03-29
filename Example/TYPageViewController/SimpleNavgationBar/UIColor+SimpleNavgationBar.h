//
//  UIColor+SimpleNavgationBar.h
//  SimpleNavigationBar
//
//  Created by wyman on 2017/12/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SimpleNavgationBar)

+ (BOOL)isSimilarColor:(UIColor *)fromColor toColor:(UIColor *)toColor;

+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent;

@end
