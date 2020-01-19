//
//  MMMainViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMMainViewController.h"
#import "MMDoubanHomeViewController.h"


@interface MMMainViewController ()<UITableViewDelegate,UITableViewDataSource>

/// tableView
@property (nonatomic, strong) UITableView *table;

@end

@implementation MMMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView mm_dequeueReusableCell:[UITableViewCell class] forIndexPath:indexPath];
    cell.backgroundColor = MMRandomColor;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Demo---%zd",indexPath.row];
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

- (UITableView *)table {
    
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0) style:UITableViewStyleGrouped];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
