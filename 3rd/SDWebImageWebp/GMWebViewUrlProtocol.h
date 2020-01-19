//
//  GMWebPUrlProtocol.h
//  Gengmei
//
//  Created by MoMo on 2019/9/17.
//  Copyright © 2019 更美互动信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMWebViewUrlProtocol : NSURLProtocol

/// 注册方法一般用在viewDidload中
+ (void)registerClass;

/// 取消注册一般用在viewWillAppear
+ (void)unregisterClass;
@end

NS_ASSUME_NONNULL_END
