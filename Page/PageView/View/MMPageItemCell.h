//
//  MMPageItemCell.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/21.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMPageItemCell : UITableViewCell

/// 当前所持有页面
@property (nonatomic, strong) UIViewController *containerController;

@end

NS_ASSUME_NONNULL_END
