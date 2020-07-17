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

- (void)douban {
    NSLog(@"my name's %@--%@", self.title,self);
}

//- (NSString *)title {
//    NSLog(@"%@的name's 是豆瓣",self);
//    return @"豆瓣";
//}
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

@implementation MMDoubanItemModel

@end
