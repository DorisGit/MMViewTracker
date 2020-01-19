//
//  MMDoubanModel.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMDoubanModel.h"

@implementation MMDoubanModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"casts":[MMCastsModel class],
             @"directors":[MMDirectorsModel class]
    };
}

@end

@implementation MMImagesModel

@end

@implementation MMRatingModel

@end

@implementation MMCastsModel

@end

@implementation MMAvatarsModel

@end

@implementation MMDirectorsModel

@end
