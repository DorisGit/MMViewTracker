//
//  MMDoubanItemViewCell.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDoubanModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MMDoubanItemViewCell : UICollectionViewCell
/// model
@property (nonatomic, strong) MMDoubanModel *model;
@end

NS_ASSUME_NONNULL_END
