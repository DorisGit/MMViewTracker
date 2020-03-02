//
//  MMFlowViewController.m
//  MMViewTracker
//
//  Created by Mikasa on 2020/2/11.
//  Copyright © 2020 Mikasa. All rights reserved.
//

#import "MMFlowViewController.h"
#import "GMCollectFlowView.h"
@interface MMFlowViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) GMCollectFlowView *collectView;

@end

@implementation MMFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((MM_SCREEN_WIDTH - 20)/2, 200);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    // Do any additional setup after loading the view.
//    self.collectView = [[GMCollectFlowView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
//    [self.collectView mm_registerClassForCell:[UICollectionViewCell class]];
    
    self.collectView = [GMCollectFlowView collectFlowView];
    self.collectView.frame = self.view.bounds;
    self.collectView.dataSource = self;
    self.collectView.delegate = self;
    [self.view addSubview:self.collectView];
    
    self.collectView.frame = self.view.bounds;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cardCell = [collectionView mm_dequeueReusableCell:[UICollectionViewCell class] forIndexPath:indexPath];
    cardCell.contentView.backgroundColor = MMRandomColor;
    return cardCell;
}
@end
