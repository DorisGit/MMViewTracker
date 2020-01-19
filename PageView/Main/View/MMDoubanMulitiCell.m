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
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.alwaysBounceHorizontal = YES;
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
        [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return _collectionView;
}

@end
