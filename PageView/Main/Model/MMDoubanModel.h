//
//  MMDoubanModel.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MMImagesModel,MMRatingModel,MMCastsModel,MMDirectorsModel,MMAvatarsModel;

@interface MMDoubanModel : NSObject
@property (nonatomic, strong) MMRatingModel *rating;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *original_title;
@property (nonatomic, assign) NSInteger collect_count;
@property (nonatomic, strong) NSArray<MMDirectorsModel *> *directors;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, strong) NSArray<MMCastsModel *> *casts;
@property (nonatomic, strong) NSArray *genres;
@property (nonatomic, strong) MMImagesModel *images;
@property (nonatomic, copy) NSString *subtype;
@property (nonatomic, copy) NSString *alt;
@end

@interface MMImagesModel : NSObject

@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *large;
@property (nonatomic, copy) NSString *medium;

@end

@interface MMRatingModel : NSObject

@property (nonatomic, copy) NSString *stars;
@property (nonatomic, assign) CGFloat average;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;

@end

@interface MMCastsModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *alt;
@property (nonatomic, strong) MMAvatarsModel *avatars;
@property (nonatomic, copy) NSString *name;

@end

@interface MMAvatarsModel : NSObject

@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *large;
@property (nonatomic, copy) NSString *medium;

@end

@interface MMDirectorsModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *alt;
@property (nonatomic, strong) MMAvatarsModel *avatars;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
