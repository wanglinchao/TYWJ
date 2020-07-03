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
        _nameL = [[UILabel alloc] initWithFrame:CGRectMake(17, 34, self.frame.size.width - 17 - 98, 25)];
        _nameL.font = [UIFont systemFontOfSize:18];
        _nameL.textColor = [UIColor colorWithHexString:@"333333"];
        [_headerView addSubview:_nameL];
        
        _tipL = [[UILabel alloc] initWithFrame:CGRectMake(_nameL.zl_x + _nameL.zl_width + 14, 34, 72, 25)];
        _tipL.textAlignment = NSTextAlignmentCenter;
        _tipL.textColor = [UIColor whiteColor];
        _tipL.text = @"班次时刻表";
        _tipL.font = [UIFont systemFontOfSize:12];
        _tipL.backgroundColor = [UIColor colorWithHexString:@"#23C371"];
        _tipL.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_tipL addGestureRecognizer:tap];
        [_tipL setRoundViewWithCornerRaidus:3];
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
- (void)tapAction{
    if (self.buttonSeleted)
       {
           self.buttonSeleted();
       }
}



- (UIView *)stopsView {
    if (!_stopsView) {
        _stopsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headerView.zl_height, self.zl_width, self.zl_height - kHeaderViewH - 10)];
        _stopsView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];

    }
    return _stopsView;
}
- (void)configView:(NSDictionary *)dic{
    _nameL.text = [dic objectForKey:@"name"];
    _fildnameL.text = [dic objectForKey:@"fied_name"];
    NSArray *arr = [dic objectForKey:@"timeList"];
    NSString *first = [[arr firstObject] objectForKey:@"line_time"];
    NSString *end = [[arr lastObject] objectForKey:@"line_time"];
    NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"首%@ 末%@ | #周一及节假日提前十分钟发车",first,end]];
    [timeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:64/255.0 blue:64/255.0 alpha:1.0] range:NSMakeRange(timeStr.length - 14, 14)];
    _timeL.attributedText = timeStr;

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
