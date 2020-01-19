//
//  UICollectionView+MM.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (MM)

- (void)mm_registerClassForCell:(Class)cellClass;

- (UICollectionViewCell *)mm_dequeueReusableCell:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
