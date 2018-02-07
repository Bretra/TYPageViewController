//
//  UIPlaceHolderTextView.h
//  HeiPa
//
//  Created by wyman on 2017/3/21.
//  Copyright © 2017年 tykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
