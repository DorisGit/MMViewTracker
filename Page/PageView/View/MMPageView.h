//
//  MMPageView.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/21.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMPageView;

NS_ASSUME_NONNULL_BEGIN

/// MMPageViewProtocol
@protocol MMPageViewDataSource <NSObject>

/// 获取分组数量 默认为1
/// @param pageView pageView
- (NSInteger)numberOfSectionsInPageView:(MMPageView *)pageView;

/// 获取分组下Row 数量 默认为0
/// @param pageView pageView
/// @param section 当前section
- (NSInteger)pageView:(MMPageView *)pageView numberOfRowsInSection:(NSInteger)section;

/// 获取自定义的cell(默认展示 不实现的indexPath展示Container)
/// @param pageView pageView
/// @param indexPath indexPath
- (UITableViewCell *)pageView:(MMPageView *)pageView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/// 获取当前展示的容器内容页面
/// @param indexPath indexPath
- (UIViewController *)pageView:(MMPageView *)pageView cellForContainerAtIndexPath:(NSIndexPath *)indexPath;


@end

@protocol MMPageViewDelegate <NSObject>

/// 获取当前展示的容器内容高度
/// @param pageView pageView
/// @param indexPath indexPath
- (CGFloat)pageView:(MMPageView *)pageView heightForContainerAtIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)pageView:(MMPageView *)pageView heightForHeaderInSection:(NSInteger)section;

/// 获取当前展示的分组内容
/// @param pageView pageView
/// @param section section
- (UIView *)pageView:(MMPageView *)pageView viewForHeaderInSection:(NSInteger)section;

- (UIScrollView *)containerScrollView;
@end

//typedef void(^MMPageViewDidScrollView)(UIScrollView *scrollView);

@interface MMPageView : UITableView

/// container
@property (nonatomic, strong) UIViewController *container;
/// controllers
@property (nonatomic, strong) NSArray<UIViewController *> *controllers;
/// titles
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, weak) id<MMPageViewDataSource> pageDataSource;//dataSource
@property (nonatomic, weak) id<MMPageViewDelegate> pageDelegate;

- (instancetype)initWithContainerController:(UIViewController *)container
                                controllers:(NSArray<UIViewController *> *)controllers
                                     titles:(NSArray *)titles;

@end

NS_ASSUME_NONNULL_END
