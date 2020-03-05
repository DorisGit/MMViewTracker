//
//  UIView+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/3/4.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "UIView+MM.h"

@implementation UIView (MM)

/// 使用Core Graphics 绘制圆角
/// @param corners 圆角位置
/// @param radii 弧度
- (void)mm_addRoundedCorners:(UIRectCorner)corners withRadii:(CGSize)radii {
    
    CGSize size = self.bounds.size;
    UIImage *image = [UIImage mm_addImageRoundedCorners:corners withRadii:radii rect:self.bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImage:image];
//    self.maskView = imageView;
    [self insertSubview:imageView atIndex:0];
}

/// 使用贝塞尔曲线UIBezierPath和Core Graphics框架绘制圆角
/// @param radius radius
- (void)mm_addRounderCornerWithRadius:(CGFloat)radius {
    
    CGSize size = self.bounds.size;
    UIImage *image = [UIImage mm_addRounderCornerImageWithRadius:radius size:size];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.backgroundColor = [UIColor redColor];
    [imageView setImage:image];
    [self insertSubview:imageView atIndex:0];
}

/// 使用CAShapeLayer和UIBezierPath设置圆角
/// @param corners 圆角位置
/// @param radii 弧度
/// @param fillColor 填充颜色
/// @param borderColor 边框颜色
/// @param borderWidth 边框宽度
- (void)mm_addRoundedCorners:(UIRectCorner)corners
                   withRadii:(CGSize)radii
                   fillColor:(CGColorRef)fillColor
                 borderColor:(CGColorRef)borderColor
                 borderWidth:(CGFloat)borderWidth {
    
    UIBezierPath *rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shape = [[CAShapeLayer alloc] init];
    shape.frame = self.bounds;
    shape.strokeColor = borderColor;
    shape.fillColor = fillColor;
    shape.lineWidth = borderWidth;
    shape.path = rounded.CGPath;
    [self.layer addSublayer:shape];
}

#pragma mark - 设置四边阴影效果
- (void)addShadow:(UIColor *)shadowColor
    shadowOpacity:(CGFloat)shadowOpacity
     shadowRadius:(CGFloat)shadowRadius
     shadowOffset:(CGSize)shadowOffset {
    
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowRadius = shadowRadius;
    self.layer.masksToBounds = NO;
}

#pragma mark - 设置单边阴影效果
- (void)addShadow:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize)shadowOffset shadowFrame:(CGRect)shadowFrame {
    
    self.layer.shadowColor = shadowColor.CGColor;
    self.layer.shadowOffset = shadowOffset;
    self.layer.shadowOpacity = shadowOpacity;
    self.layer.shadowRadius = shadowRadius;
    self.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:shadowFrame];
    self.layer.shadowPath = path.CGPath;
}
@end
