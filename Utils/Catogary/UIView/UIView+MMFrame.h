//
//  UIView+MMFrame.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/3/5.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MMFrame)
// < Shortcut for frame.origin.x.
@property (nonatomic, readwrite, assign) CGFloat mm_left;
/// < Shortcut for frame.origin.y
@property (nonatomic, readwrite, assign) CGFloat mm_top;
/// < Shortcut for frame.origin.x + frame.size.width
@property (nonatomic, readwrite, assign) CGFloat mm_right;
/// < Shortcut for frame.origin.y + frame.size.height
@property (nonatomic, readwrite, assign) CGFloat mm_bottom;

/// < Shortcut for frame.origin.x.
@property (nonatomic, readwrite, assign) CGFloat mm_x;
/// < Shortcut for frame.origin.y
@property (nonatomic, readwrite, assign) CGFloat mm_y;
/// < Shortcut for frame.size.width
@property (nonatomic, readwrite, assign) CGFloat mm_width;
/// < Shortcut for frame.size.height
@property (nonatomic, readwrite, assign) CGFloat mm_height;

/// < Shortcut for center.x
@property (nonatomic, readwrite, assign) CGFloat mm_centerX;
///< Shortcut for center.y
@property (nonatomic, readwrite, assign) CGFloat mm_centerY;

/// < Shortcut for frame.size.
@property (nonatomic, readwrite, assign) CGSize mm_size;
/// < Shortcut for frame.origin.
@property (nonatomic, readwrite, assign) CGPoint mm_origin;
@end

NS_ASSUME_NONNULL_END
