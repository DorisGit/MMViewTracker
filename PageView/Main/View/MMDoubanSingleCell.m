//
//  MMDoubanSingleCell.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMDoubanSingleCell.h"

@interface MMDoubanSingleCell ()
/// image
@property (nonatomic, strong) UIImageView *altImageView;

/// title
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MMDoubanSingleCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    _altImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_altImageView];
    [_altImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_offset(10);
        make.width.height.mas_equalTo(80);
        make.bottom.mas_equalTo(-10);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont mm_regularFont:13];
    _titleLabel.textColor = MMColor282828;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_altImageView.mas_right).mas_offset(8);
        make.right.mas_equalTo(-10);
        make.top.equalTo(_altImageView);
    }];
}

- (void)setModel:(MMDoubanModel *)model {
    _model = model;
    
    [_altImageView sd_setImageWithURL:[NSURL URLWithString:model.images.small]];
    self.titleLabel.text = model.original_title;
}

@end
