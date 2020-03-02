//
//  GMCollectFlowView.h
//  Mikasa
//
//  Created by Mikasa on 2019/9/23.
//  Copyright © 2019 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMCollectFlowView : UICollectionView
@property (nonatomic, strong) NSArray *cardArray;// 卡片数组

+ (instancetype)collectFlowView;
@end

NS_ASSUME_NONNULL_END
