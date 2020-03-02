//
//  MMPageView.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/21.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMPageView.h"
#import "MMPageItemCell.h"

@interface MMPageView ()<UITableViewDelegate, UITableViewDataSource>

/// table
@property (nonatomic, strong) UITableView *table;
/// container
@property (nonatomic, strong) UIViewController *container;
/// controllers
@property (nonatomic, strong) NSArray<UIViewController *> *controllers;
/// titles
@property (nonatomic, strong) NSArray *titles;




@end

@implementation MMPageView

- (instancetype)initWithContainerController:(UIViewController *)container controllers:(NSArray<UIViewController *> *)controllers titles:(NSArray *)titles {
    
    if (self = [super init]) {
        // 当前容器
        _container = container;
        // 子页面
        _controllers = controllers;
        // meun
        _titles = titles;
    }
    
    return self;
}

- (instancetype)initWithControllers:(NSArray<UIViewController *> *)controllers titles:(NSArray *)titles {
    
    if (self = [super init]) {
        // 子页面
        _controllers = controllers;
        // meun
        _titles = titles;
    }
    
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.delegate respondsToSelector:@selector(numberOfSectionsInPageView:)]) {
        [self.delegate numberOfSectionsInPageView:self];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(pageView:numberOfRowsInSection:)]) {
        return [self.delegate pageView:self numberOfRowsInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 头部信息
    if ([self.delegate respondsToSelector:@selector(pageView:cellForRowAtIndexPath:)]) {
        return [self.delegate pageView:self cellForRowAtIndexPath:indexPath];
    } else {
        // 内容容器
        MMPageItemCell *itemCell = (MMPageItemCell *)[tableView mm_dequeueReusableCell:[MMPageItemCell class] forIndexPath:indexPath];
        // 内容容器页面
        if ([self.delegate respondsToSelector:@selector(pageView:cellForContainerAtIndexPath:)]) {
            itemCell.containerController = [self.delegate pageView:self cellForContainerAtIndexPath:indexPath];
        }
        // 更新子容器的高度
        CGFloat containerHeight = 0;
        if ([self.delegate respondsToSelector:@selector(pageView:heightForContainerAtIndexPath:)]) {
            containerHeight = [self.delegate pageView:self heightForContainerAtIndexPath:indexPath];
        }
        [itemCell.pageCtrl.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(containerHeight);
        }];
        return itemCell;
    }
//    return [tableView mm_dequeueReusableCell:[UITableViewCell class] forIndexPath:indexPath];
}


#pragma mark - setupSubView
//- (void)setupAddSubView {
//
//}


#pragma mark - lazy loading
- (UITableView *)table {
    
    if (!_table) {
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MM_SCREEN_WIDTH, 0) style:UITableViewStylePlain];
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

@end
