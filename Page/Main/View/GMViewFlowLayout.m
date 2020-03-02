//
//  GMViewFlowLayout.m
//  Mikasa
//
//  Created by Mikasa on 2020/2/8.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "GMViewFlowLayout.h"

@interface GMViewFlowLayout ()<UICollectionViewDelegateFlowLayout>
/// colum
@property (nonatomic, assign) NSInteger numberOfColumns;

/// newBoundsSize
@property (nonatomic, assign) CGSize newBoundsSize;

/// 布局属性
@property (nonatomic, strong) NSMutableArray *itemAttrs;

@end

@implementation GMViewFlowLayout

/**
* 用来做布局的初始化操作,以保证layout实例的正确（不建议在init方法中进行布局的初始化操作）
*/
- (void)prepareLayout {
    [super prepareLayout];
    // do something in sub class......
    
    [self.itemAttrs removeAllObjects];
    self.contentHeight = 0;
    
    //开始创建每一组cell的布局属性
    NSInteger sectionCount =  [self.collectionView numberOfSections];
    for(NSInteger section = 0; section < sectionCount; section++) {
        //开始创建组内的每一个cell的布局属性
        NSInteger rowCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger row = 0; row < rowCount; row++) {
            //创建位置
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:row inSection:section];
            //获取indexPath位置cell对应的布局属性
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            // 根据内容不断进行更新
            self.contentHeight = MAX(self.contentHeight, attrs.frame.origin.y + attrs.frame.size.height) ;
        }
    }
}

/**
UICollectionViewLayoutAttributes *attrs;
1.一个cell对应一个UICollectionViewLayoutAttributes对象
2.UICollectionViewLayoutAttributes对象决定了cell的frame
*/
/// 获取对应于indexPath的位置的cell的布局属性
/// @param indexPath indexPath
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   //创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //设置布局属性item的frame
    CGSize size = [self.delegate flowLayout:self sizeForItemAtIndexPath:indexPath];
    CGFloat w =  size.width;
    CGFloat h =  size.height;
    
    CGFloat x = self.edge.left;
    CGFloat y = self.edge.right;
    
    // 换行展示在左侧还是右侧
    NSMutableArray *leftArray = self.itemAttrs[0];
    UICollectionViewLayoutAttributes *leftAttr = [leftArray lastObject];
    
    NSMutableArray *rightArray = self.itemAttrs[1];
    UICollectionViewLayoutAttributes *rightAttr = [rightArray lastObject];
    
    BOOL left = NO;
    if (!leftAttr) {
        left = YES;
    } else {
        if (!rightAttr) {
            x = leftAttr.frame.origin.x + leftAttr.frame.size.width + self.minimumInteritemSpacing;
            y = leftAttr.frame.origin.y;
        } else {
            CGFloat leftH = leftAttr.frame.origin.y + leftAttr.frame.size.height;
            CGFloat rightH = rightAttr.frame.origin.y + rightAttr.frame.size.height;
            if (leftH > rightH) {
                y = rightH + self.minimumLineSpacing;
                x = rightAttr.frame.origin.x;
            } else {
                left = YES;
                y = leftH + self.minimumLineSpacing;
                x = leftAttr.frame.origin.x;;
            }
        }
    }
    attrs.frame = CGRectMake(x, y, w, h);
    //设置item的frame
    if (left) {
        [leftArray addObject:attrs];
    } else {
        [rightArray addObject:attrs];
    }
    return attrs;
}

/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 * 检测每一项的边界是否贯穿layoutAttributesForElementsInRect:方法中传进来的矩形中
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 获得super已经计算好的布局属性
//    NSArray * superAttrs = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *itemAttrs = [NSMutableArray array];
    for (NSMutableArray *itemArray in self.itemAttrs) {
        for (UICollectionViewLayoutAttributes *attribute in itemArray) {
            if (CGRectIntersectsRect(rect, attribute.frame)) {
                [itemAttrs addObject:attribute];
            }
        }
    }
    
    
    return itemAttrs;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, _contentHeight);
}

/**
 * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
 * 一旦重新刷新布局，就会重新调用下面的方法：
 1.prepareLayout
 2.layoutAttributesForElementsInRect:方法
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    if (CGSizeEqualToSize(self.newBoundsSize, newBounds.size)) {
        return NO;
    }
    self.newBoundsSize = newBounds.size;
    return YES;
}

- (NSMutableArray *)itemAttrs {
    if (!_itemAttrs) {
        _itemAttrs = [NSMutableArray array];
    }
    if (!_itemAttrs.count) {
        NSInteger colum = 2;
//        if ([self.datasource respondsToSelector:@selector(numberOfColumnsInFlowLayout:)]) {
//           colum = [self.datasource numberOfColumnsInFlowLayout:self];
//        }
        while (colum) {
            NSMutableArray *columAttrs = [NSMutableArray array];
            [_itemAttrs addObject:columAttrs];
            colum--;
        }
    }
    return _itemAttrs;
}


@end

