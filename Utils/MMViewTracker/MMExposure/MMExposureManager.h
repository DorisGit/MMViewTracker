//
//  MMExposureManager.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIView+MM.h"
#import "UIViewController+MM.h"

NS_ASSUME_NONNULL_BEGIN

@interface MMExposureManager : NSObject

/// debug
@property (nonatomic, assign) BOOL debugLog;
+ (instancetype)sharedManager;

/// exposureDimThreshold
@property (nonatomic, assign) CGFloat exposureDimThreshold;

/// inBackground
@property (nonatomic, assign) BOOL inBackground;

/**
 设置当前view是否可见状态
 
 @param view view
 @param recursive 是否递归子view
 */
+ (void)fetchViewForVisibleState:(UIView *)view recursive:(BOOL)recursive;
@end

NS_ASSUME_NONNULL_END
