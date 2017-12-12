//
//  TYTabPagerBarCell.h
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/13.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol TYTabPagerBarCellProtocol <NSObject>

/**
 font ,textColor w textFont,textColor 默认只有一个Label
 */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@end

@interface TYTabPagerBarCell : UICollectionViewCell<TYTabPagerBarCellProtocol>
@property (nonatomic, weak,readonly) UILabel *titleLabel;

+ (NSString *)cellIdentifier;
@end
NS_ASSUME_NONNULL_END
