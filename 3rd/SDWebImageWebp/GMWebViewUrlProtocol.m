//
//  GMWebPUrlProtocol.m
//  Mikasa
//
//  Created by Mikasa on 2019/9/17.
//  Copyright © 2019 Mikasa. All rights reserved.
//

#import "GMWebViewUrlProtocol.h"
#import <WebKit/WebKit.h>


static NSString * const HttpProtocolKey = @"http";
static NSString * const HttpsProtocolKey = @"https";
static NSString * const kURLProtocolHandledKey = @"image_handle";

FOUNDATION_STATIC_INLINE Class ContextControllerClass() {
    /* 防止苹果静态检查 将 WKBrowsingContextController 拆分，然后再拼凑起来
     NSArray *privateStrArr = @[@"Controller", @"Context", @"Browsing", @"K", @"W"];
     NSString *className =  [[[privateStrArr reverseObjectEnumerator] allObjects] componentsJoinedByString:@""];
     Class cls = NSClassFromString(className);
     SEL sel = NSSelectorFromString(@"registerSchemeForCustomProtocol:");
     NSLog(@"%@",className);
     */
    static Class cls;
    if (!cls) {
        cls = [[[WKWebView new] valueForKey:@"browsingContextController"] class];
    }
    return cls;
}

FOUNDATION_STATIC_INLINE SEL RegisterSchemeSelector() {
    return NSSelectorFromString(@"registerSchemeForCustomProtocol:");
}

FOUNDATION_STATIC_INLINE SEL UnregisterSchemeSelector() {
    return NSSelectorFromString(@"unregisterSchemeForCustomProtocol:");
}


@interface GMWebViewUrlProtocol ()<NSURLSessionDataDelegate>
@property (nonnull,strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSString *jsSavePath;
@end

@implementation GMWebViewUrlProtocol

+ (void)wk_registerScheme:(NSString *)scheme {
    
    Class cls = ContextControllerClass();
    SEL sel = RegisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)wk_unregisterScheme:(NSString *)scheme {
    Class cls = ContextControllerClass();
    SEL sel = UnregisterSchemeSelector();
    if ([(id)cls respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [(id)cls performSelector:sel withObject:scheme];
#pragma clang diagnostic pop
    }
}

+ (void)registerClass {
    // 注册http协议
     [self wk_registerScheme:HttpProtocolKey];
    // 注册https协议
     [self wk_registerScheme:HttpsProtocolKey];
    // SechemaURLProtocol 自定义类 继承于 NSURLProtocol
    [NSURLProtocol registerClass:[GMWebViewUrlProtocol class]];
}

+ (void)unregisterClass {
    // 注册http协议
    [self wk_unregisterScheme:HttpProtocolKey];
    // 注册https协议
    [self wk_unregisterScheme:HttpsProtocolKey];
    // SechemaURLProtocol 自定义类 继承于 NSURLProtocol
    [NSURLProtocol unregisterClass:[GMWebViewUrlProtocol class]];
}

// 判断请求是否进入自定义的NSURLProtocol加载器
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (!request || !request.URL || ![request.URL.absoluteString isNonEmpty]) {
        return NO;
    }
    NSString *scheme = [[request URL] scheme];
    if (([scheme caseInsensitiveCompare:HttpProtocolKey] == NSOrderedSame ||
         [scheme caseInsensitiveCompare:HttpsProtocolKey] == NSOrderedSame )) {
       //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:kURLProtocolHandledKey inRequest:request]){
            return NO;
        }else{
            //处理post请求问题
            if ([request.HTTPMethod isEqualToString:@"POST"]) {
                if (!request.HTTPBody) {
                    return YES;
                }
            }
            //拦截css js
            if ([request.URL.absoluteString containsString:@".js"] || [request.URL.absoluteString containsString:@".css"]) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark -  重新设置NSURLRequest的信息, 这方法里面我们可以对请求做些自定义操作，如添加统一的请求头等
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

#pragma mark - 是否加载缓存
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

#pragma mark - 开始的方法
- (void)startLoading {
    NSMutableURLRequest* request = [self.request mutableCopy];
    if ([request.URL.absoluteString containsString:@".js"] || [request.URL.absoluteString containsString:@".css"]) {
        request = [self redefineURLRequest:self.request];
    }
    if ([request.HTTPMethod isEqualToString:@"POST"]) {
        if (!request.HTTPBody) {
            request = [self handlePostRequestBodyWithRequest:self.request];
        }
    }
    [NSURLProtocol setProperty:@YES forKey:kURLProtocolHandledKey inRequest:request];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    self.task = [session dataTaskWithRequest:request];
    [self.task resume];
}

#pragma mark - 重定义JS或是CSS request
- (NSMutableURLRequest *)redefineURLRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
//    NSString *path = [[GMWebViewJsDowloadManager sharedJSDownloadManager] downloadFiledPath];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, [request.URL.absoluteString lastPathComponent]];
//    BOOL status = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
////    NSLog(@"文件路径:%@ 名称：%@ 命中状态：%d",filePath, [request.URL.absoluteString lastPathComponent],status);
//    if (status) {
//       //request截取重定向
//       NSURL * url = [NSURL fileURLWithPath:filePath];
//       mutableReqeust.URL = url;
//    }
    return mutableReqeust;
}

#pragma mark - 处理POST请求BODY体
- (NSMutableURLRequest *)handlePostRequestBodyWithRequest:(NSURLRequest *)request {
    NSMutableURLRequest * req = [request mutableCopy];
    if ([request.HTTPMethod isEqualToString:@"POST"]) {
        if (!request.HTTPBody) {
            NSString *bodyStr = [request valueForHTTPHeaderField:@"gm-wk-body"];
            if ([bodyStr isNonEmpty]) {
                NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
                req.HTTPBody = [bodyData copy];
            }
        }
    }
    return req;
}

#pragma mark - 结束的方法
- (void)stopLoading {
    if (self.task != nil) {
        [self.task  cancel];
    }
}

#pragma mark - 协议方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    [self.client URLProtocolDidFinishLoading:self];
}
@end
