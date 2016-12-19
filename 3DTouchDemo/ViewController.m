//
//  ViewController.m
//  3DTouchDemo
//
//  Created by Json on 16/12/7.
//  Copyright © 2016年 Json. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"

#define APPW ([UIScreen mainScreen].bounds.size.width)/*设备的宽*/
#define APPH ([UIScreen mainScreen].bounds.size.height)/*设备的高*/

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(traitCollection)]) {
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                // 支持3D Touch
                // 1.在控制器内为需要实现Peek & Pop交互的控件注册Peek & Pop功能
                [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
            } else {
                // 不支持3D Touch
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"3D Touch";
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, APPW, APPH) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView = tableView];
}

#pragma mark - UIViewControllerPreviewingDelegate
/**
 轻按进入浮动页面

 @param previewingContext previewingContext description
 @param location          坐标

 @return 浮动页
 */
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    // 如果没在单元格上 返回nil
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
    if ([self.tableView cellForRowAtIndexPath:newIndexPath] == nil) {
        return nil;
    }
    // previewingContext.sourceView: 触发Peek & Pop操作的视图
    // previewingContext.sourceRect: 设置触发操作的视图的不被虚化的区域
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    // 预览区域大小(可不设置)
    // searchVC.preferredContentSize = CGSizeMake(0, 300);
    searchVC.message = [NSString stringWithFormat:@"3D Touch Demo %@",@(indexPath.row)];
    return searchVC;
}
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
    //[self.navigationController pushViewController:viewControllerToCommit animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

#pragma mark - 初始化 单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"3D Touch Demo %@",@(indexPath.row)];
    cell.backgroundColor = [UIColor whiteColor];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    searchVC.message = [NSString stringWithFormat:@"3D Touch Demo %@",@(indexPath.row)];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (BOOL)isTrue3DTouch
{
    if ([self respondsToSelector:@selector(traitCollection)]) {
        if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                // 支持3D Touch
                // 1.在控制器内为需要实现Peek & Pop交互的控件注册Peek & Pop功能
                return YES;
            }
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
