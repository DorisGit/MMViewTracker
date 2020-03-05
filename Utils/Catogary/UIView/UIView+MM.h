//
//  UIView+MM.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/3/4.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImage+MM.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MM)

/// 使用Core Graphics 绘制圆角
/// @param corners 圆角位置
/// @param radii 弧度
- (void)mm_addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii;

/// 使用贝塞尔曲线UIBezierPath和Core Graphics框架绘制圆角
/// @param radius radius
- (void)mm_addRounderCornerWithRadius:(CGFloat)radius;

/// 使用CAShapeLayer和UIBezierPath设置圆角
/// @param corners 圆角位置
/// @param radii 弧度
/// @param fillColor 填充颜色
/// @param borderColor 边框颜色
/// @param borderWidth 边框宽度
- (void)mm_addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii fillColor:(CGColorRef)fillColor borderColor:(CGColorRef)borderColor borderWidth:(CGFloat)borderWidth;

#pragma mark - 设置四边阴影效果
- (void)addShadow:(UIColor *)shadowColor
    shadowOpacity:(CGFloat)shadowOpacity
     shadowRadius:(CGFloat)shadowRadius
     shadowOffset:(CGSize)shadowOffset;

#pragma mark - 设置单边阴影效果
- (void)addShadow:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowFrame:(CGRect)shadowFrame;

@end

NS_ASSUME_NONNULL_END
