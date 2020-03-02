//
//  MMPageItemCell.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/21.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMPageItemCell.h"

@implementation MMPageItemCell

- (void)setContainerController:(UIViewController *)containerController {
    
    if (_containerController != containerController) {
        [_containerController.view removeFromSuperview];
        [self.contentView addSubview:containerController.view];
        [containerController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
    }
    _containerController = containerController;
}

@end
