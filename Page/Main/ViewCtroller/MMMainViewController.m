//
//  MMMainViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMMainViewController.h"
#import "MMDoubanHomeViewController.h"
#import "MMFlowViewController.h"
#import "MMOffseScreenRenderViewController.h"
#import "MMPageViewController.h"
#import "MMMessageForwarding.h"
#import "MMTouchViewController.h"
#import "MMThreadLiveViewController.h"

@interface MMMainViewController ()<UITableViewDelegate,UITableViewDataSource>

/// tableView
@property (nonatomic, strong) UITableView *table;

@end

@implementation MMMainViewController

- (instancetype)init {
    if (self = [super init]) {
        self.needExpo = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(UINavigationBar.barHeight);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView mm_dequeueReusableCell:[UITableViewCell class] forIndexPath:indexPath];
    cell.backgroundColor = MMRandomColor;
    cell.textLabel.textColor = MMColor282828;
    cell.textLabel.text = [NSString stringWithFormat:@"Demo---%zd",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *clickCellString = [NSString stringWithFormat:@"clickCell_%zd",indexPath.row];
    if ([self respondsToSelector:NSSelectorFromString(clickCellString)]) {
        [self performSelector:NSSelectorFromString([NSString stringWithFormat:@"clickCell_%zd",indexPath.row])];
    } else {
        NSLog(@"----%@---未实现",clickCellString);
    }
}

- (void)clickCell_0 {
    MMDoubanHomeViewController *doubanCtrl = [MMDoubanHomeViewController new];
    [self.navigationController pushViewController:doubanCtrl animated:YES];
}

- (void)clickCell_1 {
    MMFlowViewController *doubanCtrl = [MMFlowViewController new];
    [self.navigationController pushViewController:doubanCtrl animated:YES];
}

- (void)clickCell_2 {
    
    MMOffseScreenRenderViewController *doubanCtrl = [MMOffseScreenRenderViewController new];
    [self.navigationController pushViewController:doubanCtrl animated:YES];
}

- (void)clickCell_3 {
    
    MMPageViewController *doubanCtrl = [MMPageViewController new];
    [self.navigationController pushViewController:doubanCtrl animated:YES];
}

- (void)clickCell_4 {
    MMMessageForwarding *message = [MMMessageForwarding new];
    [message forwarding];
}

- (void)clickCell_5 {
    
    MMTouchViewController *doubanCtrl = [MMTouchViewController new];
    [self.navigationController pushViewController:doubanCtrl animated:YES];
    
}
- (void)clickCell_6 {
    
    MMThreadLiveViewController *doubanCtrl = [MMThreadLiveViewController new];
    [self.navigationController pushViewController:doubanCtrl animated:YES];
}
- (UITableView *)table {
    
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0) style:UITableViewStylePlain];
        _table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = UITableViewAutomaticDimension;
        _table.estimatedRowHeight = 80;
        _table.sectionHeaderHeight = UITableViewAutomaticDimension;
        _table.sectionFooterHeight = UITableViewAutomaticDimension;
        [_table mm_registerClassForCell:[UITableViewCell class]];
    }
    return _table;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"");
}
@end
