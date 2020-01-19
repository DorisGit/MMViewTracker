//
//  UITableView+MM.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/1/17.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "UITableView+MM.h"

@implementation UITableView (MM)

- (void)mm_registerClassForCell:(Class)cellClass {
    [self registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
}

- (UITableViewCell *)mm_dequeueReusableCell:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath {
    
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
}

@end
