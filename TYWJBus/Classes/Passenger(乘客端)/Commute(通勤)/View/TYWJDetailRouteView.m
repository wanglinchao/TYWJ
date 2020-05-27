//
//  TYWJDetailRouteView.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/1.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDetailRouteView.h"

#pragma mark - 常量
static CGFloat const kHeaderViewH = 126.f;
static CGFloat const kAlpha = 0.75f;

#pragma mark - class - TYWJDetailRouteView
@interface TYWJDetailRouteView()

/* headerView */
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UILabel *nameL;
@property (strong, nonatomic) UILabel *tipL;
@property (strong, nonatomic) UILabel *fildnameL;
@property (strong, nonatomic) UILabel *timeL;


@end

@implementation TYWJDetailRouteView
#pragma mark - 懒加载
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.zl_width, kHeaderViewH)];
        _headerView.backgroundColor = [UIColor clearColor];
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(17, 24, self.frame.size.width - 17 - 98, 25)];
        _nameL.font = [UIFont systemFontOfSize:18];
        _nameL.textColor = [UIColor colorWithHexString:@"333333"];
        [_headerView addSubview:_nameL];
        
        _tipL = [[UILabel alloc] initWithFrame:CGRectMake(_nameL.zl_x + _nameL.zl_width + 14, 24, 72, 25)];
        [_headerView addSubview:_tipL];
        
        _fildnameL = [[UILabel alloc] initWithFrame:CGRectMake(17, _nameL.zl_y + _nameL.zl_height +  8, self.zl_width - 34, 20)];
        _fildnameL.font = [UIFont systemFontOfSize:14];
        _fildnameL.textColor = [UIColor colorWithHexString:@"333333"];
        [_headerView addSubview:_fildnameL];
        
        
        _timeL = [[UILabel alloc] initWithFrame:CGRectMake(17, _fildnameL.zl_y + _fildnameL.zl_height + 8, self.zl_width - 34, 17)];
        _timeL.font = [UIFont systemFontOfSize:12];
            _timeL.textColor = [UIColor colorWithHexString:@"666666"];
        [_headerView addSubview:_timeL];
        
        
    }
    return _headerView;
}




- (UIView *)stopsView {
    if (!_stopsView) {
        _stopsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.zl_height, self.zl_width, self.zl_height - kHeaderViewH)];
        _stopsView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    return _stopsView;
}
- (void)configView:(NSDictionary *)dic{
    _nameL.text = [dic objectForKey:@"name"];
    _fildnameL.text = [dic objectForKey:@"fied_name"];
    _timeL.text = @"首 07:00 末 15:30   |   ";
}


#pragma mark - 工厂方法
+ (instancetype)detailRouteViewWithFrame:(CGRect)frame {
    return [[TYWJDetailRouteView alloc] initWithFrame:frame];
}

#pragma mark - 初始化设置
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor whiteColor];
    [self setRoundViewWithCornerRaidus:6.f];
    [self setBorderWithColor:ZLGlobalTextColor];
    
    [self addSubview:self.headerView];
    [self addSubview:self.stopsView];
}



@end
