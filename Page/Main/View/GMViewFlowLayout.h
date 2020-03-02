//
//  GMViewFlowLayout.h
//  Mikasa
//
//  Created by Mikasa on 2020/2/8.
//  Copyright © 2020 Mikasa. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@class GMViewFlowLayout;

@protocol GMViewFlowLayoutDelegate <NSObject>

- (CGSize)flowLayout:(GMViewFlowLayout *)flowView sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol GMViewFlowLayoutDataSource <NSObject>

- (NSInteger)numberOfColumnsInFlowLayout:(GMViewFlowLayout *)layout;

@end

@interface GMViewFlowLayout : UICollectionViewFlowLayout
@property(nonatomic,assign) UIEdgeInsets edge;
@property (nonatomic, weak) id<GMViewFlowLayoutDelegate> delegate;
@property (nonatomic, weak) id<GMViewFlowLayoutDataSource> datasource;

/// 每一个的宽度
//@property (nonatomic, assign) CGFloat itemWidth;


/// contentHeight
@property (nonatomic, assign) CGFloat contentHeight;// 记录内容高度

@end

NS_ASSUME_NONNULL_END
