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
@protocol MMPageViewProtocol <NSObject>

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

/// 获取当前展示的容器内容高度
/// @param pageView pageView
/// @param indexPath indexPath
- (CGFloat)pageView:(MMPageView *)pageView heightForContainerAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MMPageView : UITableView

/// pageDelegate
@property (nonatomic, copy) id<MMPageViewProtocol> delegate;

- (instancetype)initWithContainerController:(UIViewController *)container
                                controllers:(NSArray<UIViewController *> *)controllers
                                     titles:(NSArray *)titles;

@end

NS_ASSUME_NONNULL_END
