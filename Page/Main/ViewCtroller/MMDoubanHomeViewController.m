//
//  MMDoubanHomeViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMDoubanHomeViewController.h"
#import "MMDoubanMulitiCell.h"
#import "MMDoubanSingleCell.h"
#import "MMPageView.h"

@interface MMDoubanHomeViewController ()<UITableViewDelegate, UITableViewDataSource>
/// array
@property (nonatomic, strong) NSArray *subjects;
@end

@implementation MMDoubanHomeViewController

- (instancetype)init {
    if (self = [super init]) {
        self.needExpo = YES;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.needExpo = YES;
    
    // Do any additional setup after loading the view.
    [self.view addSubview:self.table];
    
    // subjects
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"top250.json" ofType:nil];
    NSData *topData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *topDict = [NSJSONSerialization JSONObjectWithData:topData options:0 error:nil];
    NSArray *subjects = [MMDoubanModel mj_objectArrayWithKeyValuesArray:topDict[@"subjects"]];
    self.subjects = subjects;
    
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);//UINavigationBar.barHeight
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subjects.count - 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        MMDoubanMulitiCell *doubanCell = (MMDoubanMulitiCell *)[tableView mm_dequeueReusableCell:[MMDoubanMulitiCell class] forIndexPath:indexPath];
        doubanCell.subjects = self.subjects;
        cell = doubanCell;
    } else {
        MMDoubanModel *model = self.subjects[indexPath.row + 8];
        MMDoubanSingleCell *singleCell = (MMDoubanSingleCell *)[tableView mm_dequeueReusableCell:[MMDoubanSingleCell class] forIndexPath:indexPath];
        singleCell.model = model;
        cell = singleCell;
    }
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"");
}

- (UITableView *)table {
    
    if (!_table) {
//        self.navigationController.navigationBar
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0) style:UITableViewStylePlain];
        _table.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = UITableViewAutomaticDimension;
        _table.estimatedRowHeight = 80;
        _table.sectionHeaderHeight = UITableViewAutomaticDimension;
        _table.sectionFooterHeight = UITableViewAutomaticDimension;
        
        MMAdjustsScrollViewInsets_Never(_table);
        [_table mm_registerClassForCell:[UITableViewCell class]];
        [_table mm_registerClassForCell:[MMDoubanMulitiCell class]];
        [_table mm_registerClassForCell:[MMDoubanSingleCell class]];
    }
    return _table;
}

@end
