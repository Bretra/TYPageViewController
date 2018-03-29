//
//  SimpleNavigationConst.h
//  SimpleNavigationBar
//
//  Created by wyman on 2017/12/7.
//  Copyright © 2017年 wyman. All rights reserved.
//

#ifndef SimpleNavigationConst_h
#define SimpleNavigationConst_h
#import <UIKit/UIKit.h>

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define STATUS_BAR_H 20
#define NAV_BAR_H 44

extern NSNotificationName _Nonnull SNTransitionStateBeforeChangeNotification;
extern NSNotificationName _Nonnull SNTransitionStateAfterChangeNotification;
extern NSString const * _Nonnull SNTransitionStateChangeOldValue;
extern NSString const * _Nonnull SNTransitionStateChangeNewValue;

#endif /* SimpleNavigationConst_h */
