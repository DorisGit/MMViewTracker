//
//  MMDoubanItemViewCell.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMDoubanItemViewCell.h"

@interface MMDoubanItemViewCell ()
/// image
@property (nonatomic, strong) UIImageView *imageView;

/// title
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MMDoubanItemViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.width.height.mas_equalTo(80);
        make.bottom.mas_equalTo(-10);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont mm_regularFont:13];
    _titleLabel.textColor = MMColor282828;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imageView.mas_right).mas_offset(8);
        make.right.mas_equalTo(-10);
        make.top.equalTo(_imageView);
    }];
}

- (void)setModel:(MMDoubanModel *)model {
    _model = model;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.images.small]];
    self.titleLabel.text = model.original_title;
}

@end
