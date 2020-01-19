//
//  MMInterfaceNetwork.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/19.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMInterfaceNetwork.h"

@implementation MMInterfaceNetwork

+ (instancetype)shareInterface {
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[[self class] alloc] init];
    });
    return _instance;
}

#pragma mark - custum Requst
- (NSURLSessionTask *)sendRequstWithApi:(NSString *)uri method:(MMHTTPMethod)method parameters:(NSDictionary *)params successBlock:(MMSuccessBlock)successBlock failureBlock:(MMFailureBlock)failureBlock {
    
    return [self sendRequstWithApi:uri method:method parameters:params cachePolicy:MMCachePolicyNone loadingType:MMLoadingTypeNone successBlock:successBlock failureBlock:failureBlock];
}

- (NSURLSessionTask *)sendRequstWithApi:(NSString *)uri method:(MMHTTPMethod)method parameters:(NSDictionary *)params cachePolicy:(MMCachePolicy)cachePolicy loadingType:(MMLoadingType)loadingType successBlock:(MMSuccessBlock)successBlock failureBlock:(MMFailureBlock)failureBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30;
    
    NSURLSessionTask *dataTask = nil;
    if (method == MMHTTPMethodGet) {
        dataTask = [manager GET:uri parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) {
                failureBlock(error.code,error.localizedFailureReason);
            }
        }];
    } else if (method == MMHTTPMethodGet) {
        dataTask = [manager POST:uri parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock) {
                successBlock(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) {
                failureBlock(error.code,error.localizedFailureReason);
            }
        }];
    }
    
    return dataTask;
}

@end
