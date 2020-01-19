//
//  MMDoubanHomeViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMDoubanHomeViewController.h"

#import "MMDoubanModel.h"
#import "MMDoubanMulitiCell.h"


@interface MMDoubanHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
/// table
@property (nonatomic, strong) UITableView *table;
@end

@implementation MMDoubanHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table];
    // subjects
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"top250.json" ofType:nil];
    NSData *topData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *topDict = [NSJSONSerialization JSONObjectWithData:topData options:0 error:nil];
    NSArray *subjects = [MMDoubanModel mj_objectArrayWithKeyValuesArray:topDict[@"subjects"]];
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView mm_dequeueReusableCell:[UITableViewCell class] forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell = [tableView mm_dequeueReusableCell:[MMDoubanMulitiCell class] forIndexPath:indexPath];
    }
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
        [_table mm_registerClassForCell:[MMDoubanMulitiCell class]];
    }
    return _table;
}

@end
