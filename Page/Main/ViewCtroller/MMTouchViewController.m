//
//  MMTouchViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/5/15.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMTouchViewController.h"

@interface MMHitView : UIView


@end

@implementation MMHitView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 判断当前View是否能接受事件
    if (!self.userInteractionEnabled || self.alpha < 0 || self.hidden) {
        return nil;
    }
    
    // 判断当前点击是否在控件内
    if (![self pointInside:point withEvent:event]) {
        return nil;
    }
    
    for (NSInteger i = self.subviews.count-1; i >= 0 ; i--) {
        UIView *childView = self.subviews[i];
        CGPoint chilePoint = [self convertPoint:point toView:childView];
        
        UIView *findView = [childView hitTest:chilePoint withEvent:event];
        if (findView) {
            return findView;
        }
    }
    return self;
}

@end

@interface MMTouchViewController ()
/// hitView
@property (nonatomic, strong) MMHitView *hitView;
@end

@implementation MMTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    
    self.hitView = [[MMHitView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.hitView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.hitView];
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    oneView.userInteractionEnabled = YES;
    oneView.backgroundColor = MMRandomColor;
    [oneView addGestureRecognizer:tapGesture];
    [self.hitView addSubview:oneView];
    
    UIView *twoView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 200)];
    twoView.backgroundColor = MMRandomColor;
    twoView.userInteractionEnabled = YES;
    [twoView addGestureRecognizer:tapGesture];
    [self.hitView addSubview:twoView];
    
//    mm_dispatch_barrier_async();
    mm_dispatch_after();
}

- (void)tapClick:(UITapGestureRecognizer *)gesture {
    
    NSLog(@"%@",gesture.view);
}

// 并行队列
dispatch_queue_t mm_queue_concurrent() {
    dispatch_queue_t queue = dispatch_queue_create("com.dubinbin.Demo.mm_queue_concurrent", DISPATCH_QUEUE_CONCURRENT);
    return queue;
}

// 串行队列
dispatch_queue_t mm_queue_serial() {
    dispatch_queue_t queue = dispatch_queue_create("com.dubinbin.Demo.mm_queue_serial", DISPATCH_QUEUE_SERIAL);
    return queue;
}

void mm_print_currentThread(int i) {
    NSLog(@"%d--%@",i,[NSThread currentThread]);
}

/// dispatch_barrier_async
/// 会等待追加到dispatch_barrier_asyn之前队列中的任务执行完毕后，
/// 再执行追加到dispatch_barrier_async之后队列中的任务,
/// Tips: 无论是串行队列还是并行队列，队列中的任务执行，都会等待dispatch_barrier_async前面的任务执行完毕后再执行后面的
void mm_dispatch_barrier_async() {
    
    dispatch_queue_t queue = dispatch_queue_create("com.dubinbin.Demo", DISPATCH_QUEUE_CONCURRENT);

    dispatch_async(queue, ^{
        mm_print_currentThread(1);
    });

    dispatch_async(queue, ^{
        mm_print_currentThread(2);
    });

    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier");
    });
    
    dispatch_async(queue, ^{
        mm_print_currentThread(3);
    });
    
    dispatch_async(queue, ^{
        mm_print_currentThread(4);
    });
    
    NSLog(@"end");
}


/// dispatch_after
void mm_dispatch_after () {
    dispatch_queue_t queue = mm_queue_concurrent();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        mm_print_currentThread(1);
    });
    mm_print_currentThread(0);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
