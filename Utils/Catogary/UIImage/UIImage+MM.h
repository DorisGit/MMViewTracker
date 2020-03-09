//
//  UIImage+MM.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/3/4.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (MM)

+ (UIImage *)mm_addImageRoundedCorners:(UIRectCorner)corners
                        withRadii:(CGSize)radii
                             rect:(CGRect)rect;
/// 绘制圆角图片
/// @param radius radius
+ (UIImage *)mm_addRounderCornerImageWithRadius:(CGFloat)radius
                                           size:(CGSize)size;

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin;

+ (UIImage *)mm_imageWithColor:(UIColor *)color;
+ (UIImage *)mm_imageWithColor:(UIColor *)color size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
