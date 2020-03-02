//
//  GMCollectFlowView.m
//  Mikasa
//
//  Created by Mikasa on 2019/9/23.
//  Copyright © 2019 Mikasa. All rights reserved.
//

#import "GMCollectFlowView.h"
#import "GMViewFlowLayout.h"

@interface GMCollectFlowView ()<GMViewFlowLayoutDelegate, GMViewFlowLayoutDataSource>

@end

@implementation GMCollectFlowView

+ (instancetype)collectFlowView {
    
    GMViewFlowLayout *layout = [[GMViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = kCardLineSpacing;
    layout.minimumInteritemSpacing = kCardItemSpacing;
    layout.edge = UIEdgeInsetsMake(kCardTopBottomSpacing, kCardLeftRightSpacing, kCardTopBottomSpacing, kCardLeftRightSpacing);
    
    
//
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    layout.itemSize = CGSizeMake((MM_SCREEN_WIDTH - 20)/2, 200);
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 10;
    
    GMCollectFlowView *flowView = [[self alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    flowView.backgroundColor = [UIColor whiteColor];
    flowView.hidden = NO;
    flowView.scrollsToTop = NO;
//    flowView.showsVerticalScrollIndicator = NO;
    flowView.alwaysBounceVertical = YES;
//    flowView.isMultipleTouchEnabled
    [flowView mm_registerClassForCell:[UICollectionViewCell class]];
    if (@available(iOS 11.0, *)) {
        flowView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    // 渐变色
    layout.delegate = flowView;
    layout.datasource = flowView;
    return flowView;
}

#pragma mark - setter
- (void)setCardArray:(NSArray *)cardArray {
    _cardArray = cardArray;
    [self reloadData];
}

#pragma mark - GMViewFlowLayoutDataSource

- (NSInteger)numberOfColumnsInFlowLayout:(GMViewFlowLayout *)layout {
    return 2;
}

- (CGSize)flowLayout:(GMViewFlowLayout *)flowView sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kCardCellWidth, 300%3 + kCardCellWidth);
}

@end
