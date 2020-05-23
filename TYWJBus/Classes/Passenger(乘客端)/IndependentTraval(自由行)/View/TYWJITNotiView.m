//
//  TYWJITNotiView.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITNotiView.h"
#import "TYWJBaseLayout.h"
#import "TYWJITNotiCell.h"
#import "ZLPopoverView.h"


@interface TYWJITNotiView()<UICollectionViewDelegate,UICollectionViewDataSource>

/* collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation TYWJITNotiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self configCollectionView];
}

- (void)configCollectionView {
    TYWJBaseLayout *layout = [[TYWJBaseLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"TYWJITNotiCell" bundle:nil] forCellWithReuseIdentifier:TYWJITNotiCellID];
    
    [self addSubview:_collectionView];
    
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

//返回每个cell  的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.collectionView.zl_size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TYWJITNotiCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TYWJITNotiCellID forIndexPath:indexPath];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ZLFuncLog;
    //显示通知具体内容
    [[ZLPopoverView sharedInstance] showITNotiView];
}

@end
