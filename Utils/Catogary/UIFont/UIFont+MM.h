//
//  UIFont+MM.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (MM)
+ (UIFont *)mm_regularFont:(NSInteger)size;

+ (UIFont *)mm_mediumFont:(NSInteger)size;

+ (UIFont *)mm_lightFont:(NSInteger)size;
@end

NS_ASSUME_NONNULL_END
