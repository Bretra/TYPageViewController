//
//  TYPageViewController.m
//  TYPageViewController
//
//  Created by 王智明 on 2017/11/9.
//  Copyright © 2017年 王智明. All rights reserved.
//

#import "TYPageViewController.h"
#import "TYPageViewControllerPluginBase.h"
#import "TYPageViewController+Extension.h"

typedef NS_ENUM(NSUInteger, TYPageViewScrollingDirection) {
    TYPageViewScrollingLeft, ///正在向左边滚动
    TYPageViewScrollingRight, ///正在向右边滚动
};

@interface TYPageViewController ()<UIScrollViewDelegate>
{
    struct {
    CGFloat headHeight;
    CGFloat bottomInset;
    CGFloat minHeadFrameOriginY;
} _headParameter;

struct {
    BOOL tabViewLoadFlag;
    BOOL pluginsLoadFlag;
} _loadParameter;

CGFloat  _contentOffsetY;
BOOL     _headViewScrollEnable;
BOOL     _viewDidAppearIsCalledBefore;
}

@property (nonatomic, strong) UIView           *containerView;
@property (nonatomic, strong) UIScrollView     *scrollView;
@property (nonatomic, strong) NSArray          *viewControllers;
@property (nonatomic, strong) UIView           *tabHeaderView;
@property (nonatomic, assign) NSInteger        curIndex;
@property (nonatomic, assign) NSInteger        showIndexAfterAppear;
@property (nonatomic, strong) NSMutableArray   *plugins;
@property (nonatomic, assign) BOOL scrollTop;
@property (nonatomic, assign) BOOL isTapScrollMoved;
@property (nonatomic, assign) CGFloat preOffsetX;
@property (nonatomic, assign) BOOL scrollAnimated;
@property (nonatomic, assign) CGFloat changeIndexWhenScrollProgress;
@end

@implementation TYPageViewController

- (void)dealloc {
    [self removeKVOObserver];
    for (TYPageViewControllerPluginBase *plugin in self.plugins.objectEnumerator) {
        [plugin removePlugin];
    }
    for (UIViewController *viewController in self.viewControllers.objectEnumerator) {
        viewController.pageViewController = nil;
    }
    self.scrollView.delegate = nil;
}

#pragma mark - VcLife cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadContainerView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (self.curIndex != self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame)) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self loadContentView];
    
    [self layoutSubViewWhenScrollViewFrameChange];
    
    if (self.showIndexAfterAppear > 0) {
        [self scrollToIndex:self.showIndexAfterAppear animated:NO];
        self.showIndexAfterAppear = 0;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_viewDidAppearIsCalledBefore) {
        _viewDidAppearIsCalledBefore = YES;
        [self viewDidScrollToIndex:self.curIndex];
        if (_headViewScrollEnable) {
            [self tabDelegateScrollViewVerticalScroll:0];
        }
    }
}

#pragma mark - Action
///获取某个index 的 UIViewController
- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    if (index < 0 || index >= self.viewControllers.count) {
        return nil;
    }
    return self.viewControllers[index];
}
/// 滚动到某个index
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (!_loadParameter.tabViewLoadFlag) {
        self.showIndexAfterAppear = index;
        return;
    }
    if (index < 0 || index >= self.viewControllers.count || index == self.curIndex) {
        return;
    }
    [self enableCurScrollViewScrollToTop:NO];
    [self viewControllersAutoFitToScrollToIndex:index];
    if ([self.Delegate respondsToSelector:@selector(pageViewController:scrollViewWillScrollFromIndex:)]) {
        [self.Delegate pageViewController:self scrollViewWillScrollFromIndex:self.curIndex];
    }
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *plugin, NSUInteger idx, BOOL *stop) {
        [plugin scrollViewWillScrollFromIndex:self.curIndex];
    }];
    [self scrollViewWillScrollToView:_scrollView animate:animated];
    
    [self.scrollView setContentOffset:CGPointMake(index * CGRectGetWidth(self.scrollView.bounds), 0) animated:animated];
    if (!animated) {
        [self scrollViewDidEndDecelerating:self.scrollView];
    }
}
/// 滚动到顶部 吸顶
- (void)enableCurScrollViewScrollToTop:(BOOL)enable {
    UIViewController *viewController = [self viewControllerForIndex:self.curIndex];
    viewController.pageContentScrollView.scrollsToTop = enable;
}

- (void)viewControllersAutoFitToScrollToIndex:(NSInteger)index {
    if (index < 0 || index >= self.viewControllers.count) {
        return;
    }
    NSInteger minIndex = 0;
    NSInteger maxIndex = self.viewControllers.count;
    if (index < self.curIndex) {
        minIndex = index;
        maxIndex = self.curIndex - 1;
    } else {
        minIndex = self.curIndex + 1;
        maxIndex = index;
    }
    for (NSInteger index = minIndex; index <= maxIndex; index++) {
        UIViewController *viewController = self.viewControllers[index];
        [self autoFitToViewController:viewController];
    }
}

- (void)autoFitToViewController:(UIViewController *)viewController {
    UIScrollView *scrollView = viewController.pageContentScrollView;
    if (!scrollView) {
        return;
    }
    CGFloat maxY = -MIN(CGRectGetMaxY(self.tabHeaderView.frame), _headParameter.headHeight);
    if (scrollView.contentOffset.y < maxY) {
        CGRect tempRect = self.tabHeaderView.frame;
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, maxY);
        self.tabHeaderView.frame = tempRect;
    }
    CGFloat minY = scrollView.contentSize.height - CGRectGetHeight(scrollView.frame);
    if (scrollView.contentOffset.y > minY) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, -CGRectGetMaxY(self.tabHeaderView.frame));
    }
}

#pragma mark - LoadView

- (void)reloadData {
    for (TYPageViewControllerPluginBase *plugin in self.plugins.objectEnumerator) {
        [plugin removePlugin];
    }
    [self.tabHeaderView removeFromSuperview];
    self.tabHeaderView = nil;
    
    [self removeKVOObserver];
    for (UIViewController *viewController in self.viewControllers.objectEnumerator) {
        viewController.pageViewController = nil;
        [viewController.view removeFromSuperview];
    }
    self.viewControllers = nil;
    self.scrollView.contentOffset = CGPointZero;
    self.curIndex = 0;
    _contentOffsetY = 0;
    _headViewScrollEnable = NO;
    
    _loadParameter.pluginsLoadFlag = NO;
    _loadParameter.tabViewLoadFlag = NO;
    [self loadContentView];
}

- (void)loadContentView {
    if (_loadParameter.tabViewLoadFlag) {
        return;
    }
    _loadParameter.tabViewLoadFlag = YES;
    [self layoutContainerView];
    [self loadViewControllersDateSource];
    [self loadHeadViewDateSource];
    [self loadPlugins];
    [self loadGeneralParam];
    [self loadControllerView];
    [self layoutHeaderView];
    [self layoutControllerView];
    [self enableCurScrollViewScrollToTop:YES];
    if (_headViewScrollEnable) {
        [self tabDelegateScrollViewVerticalScroll:0];
    }
}

- (void)loadViewControllersDateSource {
    NSInteger count = [self.DataSource numberOfViewControllerForTabViewController:self];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        UIViewController *vc = [self.DataSource pageViewController:self viewControllerForIndex:i];
        
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            vc.pageContentScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            vc.automaticallyAdjustsScrollViewInsets = NO;
        }
        
#endif
        [viewControllers addObject:vc];
    }
    self.viewControllers = viewControllers;
}

- (void)loadHeadViewDateSource {
    if ([self.DataSource respondsToSelector:@selector(pageHeaderViewForPageViewController:)]) {
        self.tabHeaderView = [self.DataSource pageHeaderViewForPageViewController:self];
        self.tabHeaderView.clipsToBounds = YES;
        _headViewScrollEnable = YES;
    }
}

- (void)loadGeneralParam {
    if ([self.DataSource respondsToSelector:@selector(pageHeaderBottomInsetForPageViewController:)]) {
        _headParameter.bottomInset = [self.DataSource pageHeaderBottomInsetForPageViewController:self];
    }
    if (self.tabHeaderView) {
        _headParameter.headHeight = CGRectGetHeight(self.tabHeaderView.frame);
    } else {
        _headParameter.headHeight = _headParameter.bottomInset;
    }
    _headParameter.minHeadFrameOriginY = -_headParameter.headHeight + _headParameter.bottomInset;
}

- (void)layoutContainerView {
    if (![self.DataSource respondsToSelector:@selector(containerInsetsForPageViewController:)]) {
        return;
    }
    UIEdgeInsets insets = [self.DataSource containerInsetsForPageViewController:self];
    self.containerView.frame = UIEdgeInsetsInsetRect(self.view.bounds, insets);
}

- (void)loadControllerView {
    NSInteger count = self.viewControllers.count;
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    CGFloat height = CGRectGetHeight(self.scrollView.bounds);
    self.scrollView.contentSize = CGSizeMake(width * count, height);
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
        viewController.view.frame = CGRectMake(width * idx, 0, width, height);
        viewController.pageViewController = self;
        
        UIScrollView *scrollView = viewController.pageContentScrollView;
        UIEdgeInsets inset = scrollView.contentInset;
        inset.top += _headParameter.headHeight;
        scrollView.contentInset = inset;
        scrollView.scrollIndicatorInsets = inset;
        scrollView.contentOffset = CGPointMake(0, -inset.top);
        scrollView.scrollsToTop = NO;
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
#endif
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld context:nil];

    }];
}

- (void)layoutHeaderView {
    if (!self.tabHeaderView) {
        return;
    }
    self.tabHeaderView.clipsToBounds = YES;
    self.tabHeaderView.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), _headParameter.headHeight);
    [self.containerView insertSubview:self.tabHeaderView aboveSubview:self.scrollView];
}

- (void)layoutControllerView {
    CGFloat width = CGRectGetWidth(self.scrollView.bounds);
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *childController, NSUInteger idx, BOOL *stop) {
        CGFloat pageOffsetForChild = idx * width;
        if (fabs(self.scrollView.contentOffset.x - pageOffsetForChild) < width) {
            if (!childController.parentViewController) {
                [childController willMoveToParentViewController:self];
                [self addChildViewController:childController];
                [childController beginAppearanceTransition:YES animated:YES];
                [self.scrollView addSubview:childController.view];
                [childController didMoveToParentViewController:self];
                if (_viewDidAppearIsCalledBefore) {
                    [childController endAppearanceTransition];
                }
                [self autoFitLayoutControllerView:childController];
            }
        } else {
            if (childController.parentViewController) {
                [childController willMoveToParentViewController:nil];
                [childController beginAppearanceTransition:NO animated:YES];
                [childController.view removeFromSuperview];
                [childController removeFromParentViewController];
                [childController endAppearanceTransition];
            }
        }
    }];
}

- (void)autoFitLayoutControllerView:(UIViewController *)viewController {
    UIScrollView *scrollView = viewController.pageContentScrollView;
    if (!scrollView) {
        return;
    }
    CGFloat maxY = -MIN(CGRectGetMaxY(self.tabHeaderView.frame), _headParameter.headHeight);
    if (scrollView.contentOffset.y < maxY) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, maxY);
    }
}

#pragma mark - VerticalScroll

- (void)removeKVOObserver {
    for (UIViewController *viewController in self.viewControllers) {
        @try {
            [viewController.pageContentScrollView removeObserver:self forKeyPath:@"contentOffset"];
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if (!_headViewScrollEnable) {
        return;
    }
    UIViewController *viewController = self.viewControllers[self.curIndex];
    UIScrollView *scrollView = viewController.pageContentScrollView;
    if (scrollView != object) {
        return;
    }
  
    CGFloat verticalPercent = ABS(scrollView.contentOffset.y / _headParameter.headHeight);
    [self pageScrollViewVerticalScroll:verticalPercent];
    
    CGFloat disY = _contentOffsetY - scrollView.contentOffset.y;
    _contentOffsetY = scrollView.contentOffset.y;
    if (disY > 0 && _contentOffsetY > -CGRectGetMaxY(self.tabHeaderView.frame)) {
        return;
    }
    CGRect headRect = self.tabHeaderView.frame;
    if (_contentOffsetY > -_headParameter.headHeight) {
        headRect.size.height = _headParameter.headHeight;
        headRect.origin.y += disY;
        headRect.origin.y = MIN(CGRectGetMinY(headRect), 0);
        headRect.origin.y = MAX(CGRectGetMinY(headRect), _headParameter.minHeadFrameOriginY);
        headRect.origin.y = MAX(CGRectGetMinY(headRect), -_contentOffsetY - _headParameter.headHeight);
    } else {
        headRect.origin.y = 0;
        headRect.size.height = self.headerZoomIn ? -scrollView.contentOffset.y : _headParameter.headHeight;
    }
    self.tabHeaderView.frame = headRect;
    CGFloat percent = 1;
    if (_headParameter.minHeadFrameOriginY != 0) {
        percent = MAX(0, CGRectGetMinY(headRect) / _headParameter.minHeadFrameOriginY);
        percent = MIN(1, percent);
    }
   
    [self tabDelegateScrollViewVerticalScroll:percent];
    [self tabDelegateScrollViewVerticalScroll:percent contentOffset:scrollView.contentOffset];
  
}

- (void)pageScrollViewVerticalScroll:(CGFloat)percent {
    if (percent == 1) {
        [self scrolViewVerticalAutoFit];
    }
}

- (void)scrolViewVerticalAutoFit {
    
    for (UIViewController *viewController in self.viewControllers) {
        [viewController.pageContentScrollView setContentOffset:CGPointMake(0, -self.tabHeaderView.frame.size.height) animated:NO];
    }
}

- (void)tabDelegateScrollViewVerticalScroll:(float)percent {
    if ([self.Delegate respondsToSelector:@selector(pageViewController:scrollViewVerticalScroll:)]) {
        [self.Delegate pageViewController:self scrollViewVerticalScroll:percent];
    }
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *plugin, NSUInteger idx, BOOL *stop) {
        [plugin scrollViewVerticalScroll:percent];
            CGRect tabBarFrame = CGRectZero;
            if ([self.DataSource respondsToSelector:@selector(pageHeaderTabBarFrameForPageViewController:)]) {
                tabBarFrame = [self.DataSource pageHeaderTabBarFrameForPageViewController:self];
                [plugin updatePageTabBarFrame:tabBarFrame contentPercentY:percent animate:YES];
            }
        
    }];
}

- (void)tabDelegateScrollViewVerticalScroll:(float)percent contentOffset:(CGPoint)contentOffset {
    
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *plugin, NSUInteger idx, BOOL *stop) {
        CGRect tabBarFrame = CGRectZero;
        if ([self.DataSource respondsToSelector:@selector(pageHeaderTabBarFrameForPageViewController:)]) {
            tabBarFrame = [self.DataSource pageHeaderTabBarFrameForPageViewController:self];
            [plugin updatePageTabBarFrame:tabBarFrame contentPercentY:percent contentOffset:contentOffset];
        }
        
    }];
    
}

#pragma mark - HorizontalScroll

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    self.preOffsetX = scrollView.contentOffset.x;
    [self enableCurScrollViewScrollToTop:NO];
    [self viewControllersAutoFitToScrollToIndex:self.curIndex - 1];
    [self viewControllersAutoFitToScrollToIndex:self.curIndex + 1];
    if ([self.Delegate respondsToSelector:@selector(pageViewController:scrollViewWillScrollFromIndex:)]) {
        [self.Delegate pageViewController:self scrollViewWillScrollFromIndex:self.curIndex];
    }
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *plugin, NSUInteger idx, BOOL *stop) {
        [plugin scrollViewWillScrollFromIndex:self.curIndex];
    }];
    
}

- (void)scrollViewWillScrollToView:(UIScrollView *)scrollView animate:(BOOL)animate {
    _preOffsetX = scrollView.contentOffset.x;
    _isTapScrollMoved = YES;
    _scrollAnimated = animate;
  
}
- (BOOL)progressCaculateEnable  {
    //如果可以动画滚动 和不是手势触发的点击
    return _scrollAnimated && !_isTapScrollMoved;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutControllerView];
    if ([self.Delegate respondsToSelector:@selector(pageViewController:scrollViewHorizontalScroll:)]) {
        [self.Delegate pageViewController:self scrollViewHorizontalScroll:scrollView.contentOffset.x];
    }
    self.isTapScrollMoved = NO;
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *plugin, NSUInteger idx, BOOL *stop) {
        [plugin scrollViewHorizontalScroll:scrollView.contentOffset.x];
    }];
    CGFloat offsetX = scrollView.contentOffset.x;
     TYPageViewScrollingDirection direction = offsetX >= _preOffsetX ? TYPageViewScrollingLeft : TYPageViewScrollingRight;
    
    [self caculateIndexWithOffsetX:offsetX direction:direction];
    
    if ([self progressCaculateEnable]) {
        [self caculateIndexByProgressWithOffsetX:offsetX direction:direction];
    }

}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.curIndex = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    UIViewController *viewController = [self viewControllerForIndex:self.curIndex];
    UIScrollView *curScrollView = viewController.pageContentScrollView;
    UIEdgeInsets insets = curScrollView.contentInset;
    CGFloat maxY = insets.bottom + curScrollView.contentSize.height - curScrollView.bounds.size.height;
    if (curScrollView.contentOffset.y > maxY) {
        [curScrollView setContentOffset:CGPointMake(0, -insets.top) animated:YES];
    }
    _contentOffsetY = curScrollView.contentOffset.y;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        if (_contentOffsetY < 0 && _contentOffsetY < -CGRectGetMaxY(self.tabHeaderView.frame)) {
            [self observeValueForKeyPath:@"contentOffset" ofObject:curScrollView change:nil context:nil];
        }
    }
#endif
    [self enableCurScrollViewScrollToTop:YES];
    [self viewDidScrollToIndex:self.curIndex];
}

- (void)viewDidScrollToIndex:(NSInteger)index {
    if ([self.Delegate respondsToSelector:@selector(pageViewController:scrollViewDidScrollToIndex:)]) {
        [self.Delegate pageViewController:self scrollViewDidScrollToIndex:index];
    }
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *plugin, NSUInteger idx, BOOL *stop) {
        [plugin scrollViewDidScrollToIndex:index];
        
    }];
   
}

///计算非手势触发的滑动
- (void)caculateIndexWithOffsetX:(CGFloat)offsetX direction:(TYPageViewScrollingDirection)direction{
    if (CGRectIsEmpty(_scrollView.frame)) {
        return;
    }
    if (self.viewControllers.count <= 0) {
        _curIndex = -1;
        return;
    }
    // scrollView width
    CGFloat width = CGRectGetWidth(_scrollView.frame);
    NSInteger index = 0;
    
    double percentChangeIndex = _changeIndexWhenScrollProgress;
    if (_changeIndexWhenScrollProgress >= 1.0 || [self progressCaculateEnable]) {
        percentChangeIndex = 0.999999999;
    }
    
    // 计算当前的index
    if (direction == TYPageViewScrollingLeft) {
        index = ceil(offsetX/width-percentChangeIndex);
    }else {
        index = floor(offsetX/width+percentChangeIndex);
    }
    
    if (index < 0) {
        index = 0;
    }else if (index >= self.viewControllers.count) {
        index = self.viewControllers.count-1;
    }
    if (index == _curIndex) {
        return;
    }
    
    NSInteger fromIndex = MAX(_curIndex, 0);
    _curIndex = index;
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *plugin, NSUInteger idx, BOOL * _Nonnull stop) {
        [plugin scrollToItemFromIndex:fromIndex toIndex:_curIndex animate:_scrollAnimated];
    }];
    _scrollAnimated = YES;
    
    //告诉自己的代理
    if ([self.Delegate respondsToSelector:@selector(scrollToItemFromIndex:toIndex:animate:)]) {
        [self.Delegate scrollToItemFromIndex:fromIndex toIndex:_curIndex animate:_scrollAnimated];
    }
    
}

- (void)caculateIndexByProgressWithOffsetX:(CGFloat)offsetX direction:(TYPageViewScrollingDirection)direction{
    if (CGRectIsEmpty(_scrollView.frame)) {
        return;
    }
    if (_viewControllers.count <= 0) {
        _curIndex = -1;
        return;
    }
    CGFloat width = CGRectGetWidth(_scrollView.frame);
    CGFloat floadIndex = offsetX/width;
    NSInteger floorIndex = floor(floadIndex);
    if (floorIndex < 0 || floorIndex >= _viewControllers.count || floadIndex > _viewControllers.count-1) {
        return;
    }
    
    CGFloat progress = offsetX/width-floorIndex;
    NSInteger fromIndex = 0, toIndex = 0;
    if (direction == TYPageViewScrollingLeft) {
        fromIndex = floorIndex;
        toIndex = MIN(_viewControllers.count -1, fromIndex + 1);
        if (fromIndex == toIndex && toIndex == _viewControllers.count-1) {
            fromIndex = _viewControllers.count-2;
            progress = 1.0;
        }
    }else {
        toIndex = floorIndex;
        fromIndex = MIN(_viewControllers.count-1, toIndex +1);
        progress = 1.0 - progress;
    }
    
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *plugin, NSUInteger idx, BOOL * _Nonnull stop) {
        [plugin scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
    }];
    //告诉代理
    if ([self.Delegate respondsToSelector:@selector(scrollToItemFromIndex:toIndex:progress:)]) {
        [self.Delegate scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
    }
    
}



#pragma mark - Plugin

- (void)loadPlugins {
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *plugin, NSUInteger idx, BOOL *stop) {
        [plugin loadPlugin];
    }];
    _loadParameter.pluginsLoadFlag = YES;
}

- (void)enablePlugin:(TYPageViewControllerPluginBase *)plugin {
    if (!self.plugins) {
        self.plugins = [NSMutableArray new];
    }
    [self.plugins enumerateObjectsUsingBlock:^(TYPageViewControllerPluginBase *existPlugin, NSUInteger idx, BOOL *stop) {
        if ([existPlugin isMemberOfClass:[plugin class]]) {
            [existPlugin removePlugin];
            [self.plugins removeObject:existPlugin];
            *stop = YES;
        }
    }];
    [self.plugins addObject:plugin];
    plugin.pageViewController = self;
    [plugin initPlugin];
    if (_loadParameter.pluginsLoadFlag) {
        [plugin loadPlugin];
    }
}

- (void)removePlugin:(TYPageViewControllerPluginBase *)plugin {
    [plugin removePlugin];
    plugin.pageViewController = nil;
    [self.plugins removeObject:plugin];
}

#pragma mark -

- (void)setViewControllers:(NSArray *)viewControllers {
    if ((!_viewControllers && !viewControllers)
        || [_viewControllers isEqualToArray:viewControllers]) {
        return;
    }
    _viewControllers = viewControllers;
}

- (void)loadContainerView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.headerZoomIn = YES;
    self.isTapScrollMoved = NO;
    self.scrollAnimated = YES;
    self.preOffsetX = 0;
    self.changeIndexWhenScrollProgress = 0.5;
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.clipsToBounds = YES;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.containerView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.containerView.bounds];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.delegate = self;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.delaysContentTouches = NO;
    self.scrollView.scrollEnabled = self.scrollEnabled;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.containerView addSubview:self.scrollView];
}


- (void)layoutSubViewWhenScrollViewFrameChange {
   if (CGRectGetHeight(self.scrollView.frame) == self.scrollView.contentSize.height) {
            return;
        }
      NSInteger count = self.viewControllers.count;
      CGFloat width = CGRectGetWidth(self.scrollView.bounds);
        CGFloat height = CGRectGetHeight(self.scrollView.bounds);
        self.scrollView.contentSize = CGSizeMake(width * count, height);
        [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *viewController, NSUInteger idx, BOOL *stop) {
            viewController.view.frame = CGRectMake(width * idx, 0, width, height);
            }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
