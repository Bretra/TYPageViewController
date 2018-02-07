//
//  MTTitleView.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/29.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "MTTitleView.h"
#import <TYPageViewController/TYPageViewControllerHeader.h>

@interface MTTitleView ()<TYBasePageBarDataSource ,TYBasePageBarDelegate>
/** bar */
@property (nonatomic , weak) TYBasePageBar *titlePageBar;
/** 数据源 */
@property (nonatomic , strong) NSMutableArray<NSString *> *dataArray;
@end


@implementation MTTitleView

- (NSMutableArray<NSString *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.dataArray addObject:@"推荐"];
        [self.dataArray addObject:@"关注"];
        [self setupTitleBar];
        

    }
    return self;
}

- (void)setupTitleBar {
    
    TYBasePageBar *pageBar = [[TYBasePageBar alloc] init];
    pageBar.dataSource = self;
    pageBar.collectionView.backgroundColor = [UIColor whiteColor];
    pageBar.delegate = self;
    pageBar.layout.adjustContentCellsCenter = YES;
    pageBar.layout.cellSpacing = 0;
    pageBar.layout.progressHeight = 4;
    pageBar.layout.progressWidth = 40;
    pageBar.layout.cellEdging = 0;
    pageBar.layout.cellWidth = 100;
    pageBar.layout.textAnimateEnable = YES;
    pageBar.layout.selectedTextColor = [UIColor blackColor];
    pageBar.layout.normalTextColor = [UIColor darkGrayColor];
    pageBar.layout.progressColor = [UIColor redColor];
    pageBar.layout.normalTextFont = [UIFont boldSystemFontOfSize:20];
    pageBar.layout.selectedTextFont = [UIFont boldSystemFontOfSize:20];
    [pageBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    [self addSubview:pageBar];
    [pageBar reloadData];
    self.titlePageBar = pageBar;
    
}

///选了那个ItemBar
- (void)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    
    if ([self.delegate respondsToSelector:@selector(titlePagerTabBar:didSelectItemAtIndex:)]) {
        [self.delegate titlePagerTabBar:pagerTabBar didSelectItemAtIndex:index];
    }
    
}

//有多少个Bar
- (NSInteger)numberOfItemsInPagerTabBar {
    
    return self.dataArray.count;
}
// 每个Bar的样式
- (UICollectionViewCell<TYTabPagerBarCellProtocol> *_Nullable)pagerTabBar:(TYBasePageBar *_Nullable)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    TYTabPagerBarCell <TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = self.dataArray[index];
    return cell;
}

- (void)statrAnimationing:(CGFloat)progresss {
    
    if (progresss == 0) {
        self.titlePageBar.alpha = progresss;
        return;
    }
    self.titlePageBar.alpha = progresss;
    [UIView animateWithDuration:0.15 animations:^{
        
    }];
}

- (void)pageBarCurrentSelectedIndex:(NSInteger)index {
    
  [self.titlePageBar scrollToItemFromIndex:self.titlePageBar.curIndex toIndex:index animate:NO];
    
}

- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animate:(BOOL)animate {
    
    [self.titlePageBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:toIndex];
}

- (void)scrollToItemFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self.titlePageBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titlePageBar.frame = self.bounds;
    self.titlePageBar.center = self.center;
//    self.titlePageBar.center = CGPointMake([UIScreen mainScreen].bounds.size.width*0.5, self.frame.origin.y + 22);
}

@end
