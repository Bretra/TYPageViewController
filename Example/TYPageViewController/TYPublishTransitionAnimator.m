//
//  TYPublishTransitionAnimator.m
//  PublishDemo
//
//  Created by 王智明 on 2018/2/23.
//  Copyright © 2018年 cdtykj. All rights reserved.
//

#import "TYPublishTransitionAnimator.h"
#import "TYPublishProgressProtocol.h"

@implementation TYPublishTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    
    return 0.45;
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UITabBarController *tabVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UINavigationController *nav = [tabVc.childViewControllers firstObject];
    UIViewController<TYPublishProgressProtocol> *toVC = (UIViewController<TYPublishProgressProtocol> *)nav.topViewController;
    

    UIView *progressView;
    if ([toVC respondsToSelector:@selector(getProgressView)]) {
        progressView = [toVC getProgressView];
    }
    
    UIView *containerView =  transitionContext.containerView;
    
    UIView *fromView;
    UIView *toView;
    
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromVc.view;
        toView = toVC.view;
    }
    
    fromView.frame = [transitionContext initialFrameForViewController:fromVc];
    
    fromView.alpha = 1.0f;
    toView.alpha = 0.0f;
    
    [containerView addSubview:toView];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        fromView.frame = progressView.frame;
        fromView.backgroundColor = [UIColor redColor];
        toView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 animations:^{
            progressView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            BOOL wasCancelled = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!wasCancelled];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.3 animations:^{
                    progressView.alpha = 0.0f;
                }];
            });
            
        }];
        
    }];
}


@end
