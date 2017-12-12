#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "TYBasePageBar.h"
#import "TYBasePageBarLayout.h"
#import "TYPageBar.h"
#import "TYTabPagerBarCell.h"
#import "TYPageViewController+Extension.h"
#import "TYPageViewController+Private.h"
#import "TYPageViewController.h"
#import "TYPageViewControllerHeader.h"
#import "TYPageViewControllerPluginBase.h"
#import "TYPageViewControllerPluginHeaderScroll.h"
#import "TYPageViewControllerPluginTabBar.h"
#import "TYPageViewControllerPluginTabBottomInset.h"

FOUNDATION_EXPORT double TYPageViewControllerVersionNumber;
FOUNDATION_EXPORT const unsigned char TYPageViewControllerVersionString[];

