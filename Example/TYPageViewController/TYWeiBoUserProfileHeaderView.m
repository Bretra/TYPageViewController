//
//  TYWeiBoUserProfileHeaderView.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/3/29.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYWeiBoUserProfileHeaderView.h"
@interface TYWeiBoUserProfileHeaderView ()
@property(nonatomic, weak) UIImageView *bgImageView;

@end

@implementation TYWeiBoUserProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *bgImageView = [[UIImageView alloc] init];
        bgImageView.image = [UIImage imageNamed:@"profile_bg_defult"];
        [self addSubview:bgImageView];
        self.bgImageView = bgImageView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
     self.bgImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 10);
}

@end
