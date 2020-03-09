//
//  MMPageViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/20.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMPageViewController.h"
#import "MMDoubanHomeViewController.h"

#import "MMPageView.h"
#import "MMDoubanSingleCell.h"

#import "MMDoubanModel.h"

@interface MMPageViewController ()<MMPageViewDelegate, MMPageViewDataSource>

/// MMPageView
@property (nonatomic, strong) MMPageView *pageView;
/// subjects
@property (nonatomic, strong) NSArray *subjects;
/// N
@property (nonatomic, strong) NSMutableArray *tabViewControllers;
/// index
@property (nonatomic, assign) NSInteger index;
@end

@implementation MMPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // subjects
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"top250.json" ofType:nil];
    NSData *topData = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *topDict = [NSJSONSerialization JSONObjectWithData:topData options:0 error:nil];
    NSArray *subjects = [MMDoubanModel mj_objectArrayWithKeyValuesArray:topDict[@"subjects"]];
    self.subjects = subjects;
    
    self.index = 0;
    [self setupSubView];
}

- (void)setupSubView {
    
    [self.view addSubview:self.pageView];
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(UINavigationBar.barHeight);
    }];
}

- (NSInteger)numberOfSectionsInPageView:(MMPageView *)pageView {
    return 2;
}

- (NSInteger)pageView:(MMPageView *)pageView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else {
        return 1;
    }
}

- (UITableViewCell *)pageView:(MMPageView *)pageView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MMDoubanModel *model = self.subjects[indexPath.row];
            MMDoubanSingleCell *singleCell = (MMDoubanSingleCell *)[pageView mm_dequeueReusableCell:[MMDoubanSingleCell class] forIndexPath:indexPath];
            singleCell.model = model;
        //    cell = singleCell;
            return singleCell;
    }
    return nil;
    
}

- (UIViewController *)pageView:(MMPageView *)pageView cellForContainerAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *tabViewCtrl = self.tabViewControllers[self.index];
    return tabViewCtrl;
}

- (CGFloat)pageView:(MMPageView *)pageView heightForContainerAtIndexPath:(NSIndexPath *)indexPath {
    return MM_SCREEN_HEIGHT;
}

- (UIView *)pageView:(MMPageView *)pageView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MM_SCREEN_WIDTH, 40)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, MM_SCREEN_WIDTH/3, 40)];
        button.tag = 100;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button setTitle:@"精选" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage mm_imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(MM_SCREEN_WIDTH/3, 0, MM_SCREEN_WIDTH/3, 40)];
        button2.tag = 101;
        [button setBackgroundImage:[UIImage mm_imageWithColor:[UIColor darkGrayColor]] forState:UIControlStateSelected];
        [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setTitle:@"视频" forState:UIControlStateNormal];
        [view addSubview:button2];
        return view;
    }
    return nil;
}

- (CGFloat)pageView:(MMPageView *)pageView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0;
}

- (UIScrollView *)containerScrollView {
    MMDoubanHomeViewController *tabViewCtrl = self.tabViewControllers[self.index];
    return tabViewCtrl.table;
}

- (void)buttonClick:(UIButton *)sender {
    self.index = sender.tag - 100;
    [self.pageView reloadData];
}

- (NSMutableArray *)tabViewControllers {
    if (!_tabViewControllers) {
        _tabViewControllers = [NSMutableArray array];
        int i = 10;
        while (i) {
            MMDoubanHomeViewController *douban = [MMDoubanHomeViewController new];
            [_tabViewControllers addObject:douban];
            i--;
        }
    }
    return _tabViewControllers;
}

- (MMPageView *)pageView {
    
    if (!_pageView) {
        _pageView = [[MMPageView alloc] initWithFrame:CGRectMake(0, 0, MM_SCREEN_WIDTH, 0) style:UITableViewStyleGrouped];
        _pageView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _pageView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _pageView.pageDelegate = self;
        _pageView.pageDataSource = self;
        _pageView.rowHeight = UITableViewAutomaticDimension;
        _pageView.estimatedRowHeight = 80;
        _pageView.sectionHeaderHeight = UITableViewAutomaticDimension;
        _pageView.sectionFooterHeight = UITableViewAutomaticDimension;
        [_pageView mm_registerClassForCell:[MMDoubanSingleCell class]];
    }
    return _pageView;
}
@end
