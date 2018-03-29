//
//  TYPublishTransitionDelegate.m
//  PublishDemo
//
//  Created by 王智明 on 2018/2/23.
//  Copyright © 2018年 cdtykj. All rights reserved.
//

#import "TYPublishTransitionDelegate.h"
#import "TYPublishTransitionAnimator.h"
@interface TYPublishTransitionDelegate ()
/** TYPublishTransitionAnimator */
@property (nonatomic , strong) TYPublishTransitionAnimator *publishTransitionAnimator;
@end

@implementation TYPublishTransitionDelegate

- (TYPublishTransitionAnimator *)publishTransitionAnimator {
    if (!_publishTransitionAnimator) {
        _publishTransitionAnimator = [[TYPublishTransitionAnimator alloc] init];
    }
    return _publishTransitionAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC  {
    return self.publishTransitionAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    
    return self.publishTransitionAnimator;
}

@end
