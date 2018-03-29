//
//  TYMainModuleViewController.m
//  TYPageViewController_Example
//
//  Created by 王智明 on 2018/3/29.
//  Copyright © 2018年 1130128166@qq.com. All rights reserved.
//
#import "TYMainModuleViewController.h"
@interface TYMainModuleViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<NSString *> *titles;
@property (nonatomic, strong) NSMutableArray<NSString *> *classNames;
@property (nonatomic, strong) NSMutableArray<UIImage *> *images;

@end
static NSString *const kCellIdentifier = @"TYCell";
@implementation TYMainModuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupBasic];
}
#pragma mark - setupUI
- (void)setupUI {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.title = @"DemoList";
}
#pragma mark - setupBasic
- (void)setupBasic {
    [self addCell:@"Weibo" class:@"TYWeiBoDemoViewController" image:@"weibo_screenshot_share_qrcode_logo"];
    [self.tableView reloadData];
}

- (void)addCell:(NSString *)title class:(NSString *)className image:(NSString *)imageName{
    [self.titles addObject:title];
    [self.classNames addObject:className];
    [self.images addObject:[UIImage imageNamed:imageName]];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.imageView.image = _images[indexPath.row];
    cell.imageView.clipsToBounds = YES;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMainModuleCellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *demoListVc = class.new;
        [self.navigationController pushViewController:demoListVc animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSMutableArray<NSString *> *)titles {
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray<NSString *> *)classNames {
    if (!_classNames) {
        _classNames = [NSMutableArray array];
    }
    return _classNames;
}

- (NSMutableArray<UIImage *> *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

@end
