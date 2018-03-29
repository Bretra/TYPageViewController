//
//  TYCircleProgressView.h
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/2/23.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYCircleProgressView : UIView

@property (nonatomic, copy) void (^fillChangedBlock)(TYCircleProgressView *progressView, BOOL filled, BOOL animated);

@property (nonatomic, copy) void (^didSelectBlock)(TYCircleProgressView *progressView);


@property (nonatomic, copy) void (^progressChangedBlock)(TYCircleProgressView *progressView, CGFloat progress);

///中间是什么view
@property (nonatomic, strong) UIView *centralView;

@property (nonatomic, assign) BOOL fillOnTouch UI_APPEARANCE_SELECTOR;

//圆形宽度
@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat lineWidth UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CFTimeInterval animationDuration UI_APPEARANCE_SELECTOR;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

- (void)addFill;
@end
