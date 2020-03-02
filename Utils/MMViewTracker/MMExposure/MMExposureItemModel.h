//
//  MMExposureItemModel.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/2/26.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 基于页面的精准曝光Item
@interface MMExposureItemModel : NSObject

/** 记录上滑总次数 */
@property (nonatomic, assign) NSInteger up_slide_times;
/** 记录下滑总次数 */
@property (nonatomic, assign) NSInteger down_slide_times;
/** 记录向上加载总次数 */
@property (nonatomic, assign) NSInteger up_loading_times;
/** 记录向下加载总次数 */
@property (nonatomic, assign) NSInteger down_loading_times;
/** 当前tab_name */
@property (nonatomic, copy) NSString *tab_name;
/** 当前page_name */
@property (nonatomic, copy) NSString *page_name;
/** 当前business_id */
@property (nonatomic, copy) NSString *business_id;
/** 当前referrer */
@property (nonatomic, copy) NSString *referrer;
/** 当前referrer */
@property (nonatomic, copy) NSString *referrerId;
/** 当前filter_f */
@property (nonatomic, copy) NSString *filter_f;
/** 曝光卡片数据 */
@property (nonatomic, strong) NSMutableArray *exposure_cards;
/** 是否精准曝光 */
@property (nonatomic, copy) NSString *is_exposure;


@end

NS_ASSUME_NONNULL_END
