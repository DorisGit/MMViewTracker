//
//  UIImage+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/3/4.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "UIImage+MM.h"

@implementation UIImage (MM)

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)mm_addImageRoundedCorners:(UIRectCorner)corners
                        withRadii:(CGSize)radii
                             rect:(CGRect)rect {
    
    //开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 1);
    //使用贝塞尔曲线画出一个圆形图
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    [[UIColor redColor] setStroke];
//    [[UIColor whiteColor] setFill];
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    [bezierPath addClip];
    bezierPath.lineCapStyle  = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineCapRound;
    CGContextAddPath(ctx, bezierPath.CGPath);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/// 绘制圆角图片
/// @param radius radius
+ (UIImage *)mm_addRounderCornerImageWithRadius:(CGFloat)radius size:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
//    CGContextSetFillColorWithColor(cxt, [UIColor whiteColor].CGColor);
//    CGContextSetStrokeColorWithColor(cxt, [UIColor redColor].CGColor);
    
    CGContextSetLineWidth(cxt, 0.5);
    CGContextMoveToPoint(cxt, 0, radius);
    CGContextAddArcToPoint(cxt, 0, 0, radius, 0, radius);// 左上角
    CGContextAddArcToPoint(cxt, size.width, 0, size.width, radius, radius);// 右上角
    CGContextAddArcToPoint(cxt, size.width, size.height ,size.width-radius, size.height, radius);// 右下角
    CGContextAddArcToPoint(cxt, 0, size.height, 0, size.height-radius, radius);// 左下角
    CGContextSetLineCap(cxt, kCGLineCapRound);
    CGContextSetLineJoin(cxt, kCGLineJoinRound);
    CGContextClosePath(cxt);
    
    CGContextDrawPath(cxt, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
