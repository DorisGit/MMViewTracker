//
//  MMExposureItemModel.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/2/26.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMExposureItemModel.h"

@implementation MMExposureItemModel

- (instancetype)init {
    if (self = [super init]) {
        _exposure_cards = [NSMutableArray array];
        _is_exposure = @"1";
    }
    return self;
}

@end
