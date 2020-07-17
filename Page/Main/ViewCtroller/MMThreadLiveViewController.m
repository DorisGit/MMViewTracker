//
//  MMThreadLiveViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/5/15.
//  Copyright © 2020 Mikasa. All rights reserved.

/// 线程保活

#import "MMThreadLiveViewController.h"

@interface MMThreadLiveViewController ()
/// stopped
@property (nonatomic, assign,getter=isStoped) BOOL stopped;
/// thread
@property (nonatomic, strong) NSThread *thread;
@end

@implementation MMThreadLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *stopButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 100, 50)];
    stopButton.backgroundColor = MMRandomColor;
    [stopButton addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:stopButton];
    
    
    __weak typeof(self) weakSelf = self;
    
    self.stopped = NO;
    self.thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"%@----begin----", [NSThread currentThread]);
        
        // 往RunLoop里面添加Source\Timer\Observer
//        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//        while (!weakSelf.isStoped) {
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        }
        [weakSelf test];
        NSLog(@"%@----end----", [NSThread currentThread]);
    }];
    
    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 子线程需要执行的任务
- (void)test {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
    int i = 10;
    while (i) {
        NSLog(@"test----------%d",i);
        i--;
        sleep(1);
    }
}

- (void)stop {
    // 在子线程调用stop
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 用于停止子线程的RunLoop
- (void)stopThread {
    // 设置标记为NO
    self.stopped = YES;
    
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

- (void)dealloc {
    NSLog(@"");
}


@end
