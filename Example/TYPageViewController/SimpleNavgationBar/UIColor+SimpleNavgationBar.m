//
//  UIColor+SimpleNavgationBar.m
//  SimpleNavigationBar
//
//  Created by wyman on 2017/12/8.
//  Copyright © 2017年 wyman. All rights reserved.
//

#import "UIColor+SimpleNavgationBar.h"

@implementation UIColor (SimpleNavgationBar)

+ (UIColor *)middleColor:(UIColor *)fromColor toColor:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = fromRed + (toRed - fromRed) * percent;
    CGFloat newGreen = fromGreen + (toGreen - fromGreen) * percent;
    CGFloat newBlue = fromBlue + (toBlue - fromBlue) * percent;
    CGFloat newAlpha = fromAlpha + (toAlpha - fromAlpha) * percent;
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

+ (BOOL)isSimilarColor:(UIColor *)fromColor toColor:(UIColor *)toColor {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = (toRed - fromRed) / 255.0;
    CGFloat newGreen = (toGreen - fromGreen) / 255.0;
    CGFloat newBlue = (toBlue - fromBlue) / 255.0;
    CGFloat newAlpha = (toAlpha - fromAlpha);
    if (newRed > 0.05 ||
        newGreen > 0.05 ||
        newBlue > 0.05 ||
        newAlpha > 0.05 ) {
        return NO;
    } else {
        return YES;
    }
}


@end
