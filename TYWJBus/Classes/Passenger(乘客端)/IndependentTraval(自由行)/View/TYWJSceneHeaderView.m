//
//  TYWJSceneHeaderView.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJSceneHeaderView.h"
#import "TYWJScenesLayout.h"
#import "TYWJScenesReusableView.h"
#import "TYWJScenesA.h"
#import "YDYBSearchCollectionCell.h"
#import <MJExtension.h>

@interface TYWJSceneHeaderView()<UICollectionViewDelegate,UICollectionViewDataSource>

/* collectionView */
@property (strong, nonatomic) UICollectionView *collectionView;
/* dataArray */
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation TYWJSceneHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        TYWJScenesLayout *layout = [[TYWJScenesLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"TYWJScenesReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TYWJScenesReusableViewID];
        [_collectionView registerNib:[UINib nibWithNibName:@"YDYBSearchCollectionCell" bundle:nil] forCellWithReuseIdentifier:YDYBSearchCollectionCellID];
        
    }
    return _collectionView;
}

+ (instancetype)headerWithFrame:(CGRect)frame {
    TYWJSceneHeaderView *header = [[TYWJSceneHeaderView alloc] initWithFrame:frame];
    return header;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
        [self loadData];
    }
    return self;
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:TYWJScenesPlist ofType:nil];
    if (path) {
        self.dataArray = [NSArray arrayWithContentsOfFile:path];
        self.dataArray = [TYWJScenesA mj_objectArrayWithKeyValuesArray:self.dataArray];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

#pragma mark - 在布局对象的代理协议方法中设置header的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.zl_width, 40.f);
}

#pragma mark - 返回header对象 UICollectionViewDataSource的协议方法(也可以用来返回footer对象)
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        // header类型
        
        // 从重用队列里面获取
        TYWJScenesReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:TYWJScenesReusableViewID forIndexPath:indexPath];
        TYWJScenesA *sa = self.dataArray[indexPath.section];
        // 设置背景颜色
        header.backgroundColor = [[UIColor cyanColor] colorWithAlphaComponent:0.75f];;
        header.titleLabel.text = sa.type;
        // 显示数据
        return header;
        
    }
    return [UICollectionReusableView new];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    TYWJScenesA *sa = self.dataArray[section];
    return sa.scenes.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 2.设置每个格子的尺寸
    //    layout.itemSize = CGSizeMake(250, 250);
    TYWJScenesA *sa = self.dataArray[indexPath.section];
    NSString *text = sa.scenes[indexPath.row];
    CGFloat w = [text sizeWithMaxSize:CGSizeMake(MAXFLOAT, 0) font:14.f].width + 10.f;
    
    return CGSizeMake(w, 30.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YDYBSearchCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:YDYBSearchCollectionCellID forIndexPath:indexPath];
    TYWJScenesA *sa = self.dataArray[indexPath.section];
    cell.text = sa.scenes[indexPath.row];
    return cell;
}


@end
