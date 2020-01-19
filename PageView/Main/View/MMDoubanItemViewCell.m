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
    
    
}

- (void)setModel:(MMDoubanModel *)model {
    _model = model;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.alt]];
}

@end
