//
//  MMInterfaceMacro.h
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#ifndef MMInterfaceMacro_h
#define MMInterfaceMacro_h

typedef void(^MMSuccessBlock)(id response);
typedef void(^MMFailureBlock)(NSInteger errorCode,NSString *message);
typedef void(^MMCompleteBlock)(BOOL isSuccess);

typedef NS_ENUM(NSInteger, MMCachePolicy) {
    MMCachePolicyNone = 0,// 无缓存
    MMCachePolicyIgnoryLocal = 0,// 忽略本地
    MMCachePolicyIgnoryNetWork = 0,// 忽略网络
};

typedef NS_ENUM(NSInteger, MMLoadingType) {
    MMLoadingTypeNone = 0,// 不展示
    MMLoadingTypeOne = 1,// 样式1
};

typedef NS_ENUM(NSInteger, MMHTTPMethod) {
  MMHTTPMethodGet = 0,
  MMHTTPMethodPost = 1,
  MMHTTPMethodDelete = 2,
  MMHTTPMethodPut = 3,
  MMHTTPMethodOptions = 4,
  MMHTTPMethodPatch = 5,
  MMHTTPMethodHead = 6,
  MMHTTPMethodTrace = 7,
  MMHTTPMethodConnect = 8,
};

#endif /* MMInterfaceMacro_h */
