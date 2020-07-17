//
//  MMBaseViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/15.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMBaseViewController.h"

@interface MMBaseViewController ()

@end

@implementation MMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = MMRandomColor;
    
}

- (void)dealloc {
    NSLog(@"");
}

@end
