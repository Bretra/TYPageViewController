//
//  TYDemo1ViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/1/31.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//

#import "TYDemo1ViewController.h"
#import "TYPublishedViewController.h"

@interface TYDemo1ViewController ()<UICollectionViewDataSource ,UICollectionViewDelegate>
/** collectionView */
@property (nonatomic , weak) UICollectionView *collectionView;
@end
static NSString  * const kHomeCellIdentifier = @"TYHomeCollectionViewCell";
@implementation TYDemo1ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 40;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);    
    layout.itemSize = CGSizeMake(370, 140);
    UICollectionView *collectView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectView.dataSource = self;
    collectView.delegate = self;
    collectView.alwaysBounceVertical = YES;
    collectView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [collectView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kHomeCellIdentifier];
    collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:collectView];
    self.collectionView = collectView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"TYDemo1ViewController  --- %s" , __func__);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"TYDemo1ViewController  --- %s" , __func__);
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHomeCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor magentaColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
