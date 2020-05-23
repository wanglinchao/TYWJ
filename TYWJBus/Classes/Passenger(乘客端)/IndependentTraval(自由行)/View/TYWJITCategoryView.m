//
//  TYWJITCategoryView.m
//  TYWJBus
//
//  Created by Harley He on 2018/7/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJITCategoryView.h"
#import "TYWJCategoryModel.h"
#import "NGSVerticalButton.h"

static CGFloat const kPageControlH = 20.f;

@interface TYWJITCategoryView()<UIScrollViewDelegate>

/* dataArray */
@property (strong, nonatomic) NSArray *dataArray;
/* scrollView */
@property (strong, nonatomic) UIScrollView *scrollView;
/* pageControl */
@property (strong, nonatomic) UIPageControl *pageControl;


@end

@implementation TYWJITCategoryView
#pragma mark - lazy loading


- (void)setupSubView {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.bounds;
    _scrollView.zl_height -= kPageControlH;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.zl_size = CGSizeMake(100.f, kPageControlH);
    _pageControl.zl_y = self.zl_height - kPageControlH;
    _pageControl.zl_centerX = self.zl_width/2.f;
    _pageControl.pageIndicatorTintColor = ZLColorWithRGB(254, 235, 196);
    _pageControl.currentPageIndicatorTintColor = ZLColorWithRGB(253, 191, 70);
    
    [self addSubview:_scrollView];
    [self addSubview:_pageControl];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupView];
    
    NSMutableArray *dataArr = [NSMutableArray array];
    NSArray *titleArr = @[@"景区门票",@"演出票",@"跟团游",@"酒店客栈"];
    NSArray *iconArr = @[@"iconTicket",@"iconShowTicket",@"iconGroupTraval",@"iconRest"];
    NSInteger count = titleArr.count;
    for (NSInteger i = 0; i < count; i++) {
        TYWJCategoryModel *model = [[TYWJCategoryModel alloc] init];
        model.img = iconArr[i];
        model.title = titleArr[i];
        model.type = @"test";
        [dataArr addObject:model];
    }
    self.dataArray = dataArr;
    
    if (count < 6) {
        if (self.multiRows) {
            self.multiRows(NO);
        }
    }else {
        if (self.multiRows) {
            self.multiRows(YES);
        }
    }
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    [self setupSubView];
    
    NSInteger count = self.dataArray.count;
    NSInteger rowNum = 2;
    NSInteger colNum = 5;
    NSInteger row = 0;
    NSInteger col = 0;
    CGFloat margin = 10.f,startX = 0;
    CGFloat x = 0,y = 0,w = 0,h = 0;
    if (count < 6) {
        w = (self.scrollView.zl_width - (colNum + 1)*margin)/colNum;
        h = self.scrollView.zl_height;
    }else {
        w = (self.scrollView.zl_width - (colNum + 1)*margin)/colNum;
        h = (self.scrollView.zl_height)/rowNum - margin;
    }
    
    for (NSInteger i = 0; i < count; i++) {
        NSInteger tmpI = 0;
        TYWJCategoryModel *model = self.dataArray[i];
        if (i > 9) {
            tmpI = i - 10;
            startX = self.scrollView.zl_width;
        }else {
            tmpI = i;
            startX = 0;
        }
        row = tmpI/colNum;
        col = tmpI%colNum;
        x = startX + margin + col*(w + margin);
        if (count > 6) {
            y = margin + row*(h + margin);
        }
        
        NGSVerticalButton *btn = [[NGSVerticalButton alloc] init];
        btn.frame = CGRectMake(x, y, w, h);
        [btn setImage:[UIImage imageNamed:model.img] forState:UIControlStateNormal];
        btn.tag = i;
        [btn setTitle:model.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        btn.imgViewSize = CGSizeMake(btn.zl_width - 15.f, btn.zl_width - 15.f);
//        [btn.imageView setRoundView];
        [self.scrollView addSubview:btn];
    }
    
    self.scrollView.contentSize = CGSizeMake((count/10 + 1)*self.scrollView.zl_width, 0);
    self.pageControl.numberOfPages = count/10 + 1;
    self.pageControl.currentPage = 0;
}

- (void)btnClicked:(NGSVerticalButton *)sender {
    ZLFuncLog;
    if (self.categoryClicked) {
        TYWJCategoryModel *model = self.dataArray[sender.tag];
        self.categoryClicked(model.title, sender.tag);
    }
}

#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    ZLFuncLog;
    NSInteger index = scrollView.contentOffset.x/scrollView.zl_width;
    self.pageControl.currentPage = index;
}

@end
