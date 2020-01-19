//
//  UIView+MM.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMExposureProtocol.h"
#import "NSObject+Swizzle.h"



NS_ASSUME_NONNULL_BEGIN

@interface UIView (MM)<MMExposureProtocol,GMViewExposureProtocol>
- (UIViewController *)currentPageCtrl;
@end

NS_ASSUME_NONNULL_END
