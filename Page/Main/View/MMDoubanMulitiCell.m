//
//  MMDoubanMulitiCell.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMDoubanMulitiCell.h"
#import "MMDoubanItemViewCell.h"

@interface MMDoubanMulitiCell ()<UICollectionViewDelegate, UICollectionViewDataSource>

/// collection
@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation MMDoubanMulitiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
//    self.collectionView
//    self.contentView.alpha = 0.3;
    self.contentView.layer.edgeAntialiasingMask = true;
}

- (void)setSubjects:(NSArray *)subjects {
    
    _subjects = subjects;
    [self.collectionView reloadData];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MMDoubanModel *model = self.subjects[indexPath.row];
    MMDoubanItemViewCell *cell = (MMDoubanItemViewCell *)[collectionView mm_dequeueReusableCell:[MMDoubanItemViewCell class] forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(self.subjects.count, 8);
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((MM_SCREEN_WIDTH - 20)/1.5, 100);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 8;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        MMAdjustsScrollViewInsets_Never(_collectionView);
        
        if (@available(iOS 10.0, *)) {
            self.collectionView.prefetchingEnabled = NO;
        }
        if(@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView mm_registerClassForCell:[MMDoubanItemViewCell class]];
    }
    if (!_collectionView.superview) {
        [self.contentView addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
            make.height.mas_equalTo(100);
        }];
    }
    return _collectionView;
}


@end
