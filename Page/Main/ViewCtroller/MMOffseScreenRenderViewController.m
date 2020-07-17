//
//  MMOffseScreenRenderViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/3/4.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMOffseScreenRenderViewController.h"
#import "UIView+MM.h"

@interface MMOffseScreenRenderViewController ()

@end

@implementation MMOffseScreenRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self demo0];
    
    [self demo1];
}


/// 为一个简单的View绘制圆角
- (void)demo0 {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 120, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
//    [view mm_addRounderCornerWithRadius:20];
    
    [view addShadow:[UIColor blueColor] shadowOpacity:1 shadowRadius:2 shadowOffset:CGSizeMake(0, 10)];
}

/// 为一个简单的View绘制圆角
- (void)demo1 {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(150, 120, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(150, 120, 100, 100)];
    //[view addSubview:view2];
    
    [view mm_addRoundedCorners:UIRectCornerAllCorners withRadii:CGSizeMake(20, 20)];
    
//    [view addShadow:[UIColor blueColor] shadowOpacity:1 shadowRadius:2 shadowOffset:CGSizeMake(0, 10) shadowFrame:CGRectMake(0, view.mm_height, view.mm_width, 10)];

}

@end
