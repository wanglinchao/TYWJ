//
//  TYWJDetailStationCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/6.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJDetailStationCell.h"
#import "TYWJSubRouteList.h"


#define TYWJDetailStationCellGreenColor [[UIColor greenColor] colorWithAlphaComponent:TYWJEffectViewAlpha]
#define TYWJDetailStationCellRedColor [[UIColor redColor] colorWithAlphaComponent:TYWJEffectViewAlpha]

NSString * const TYWJDetailStationCellID = @"TYWJDetailStationCellID";

@interface TYWJDetailStationCell()

/* timeLabel */
@property (strong, nonatomic) UILabel *timeLabel;
/* stationLabel */
@property (strong, nonatomic) UILabel *stationLabel;
/* line1 */
@property (strong, nonatomic) UIView *line1;
/* line2 */
@property (strong, nonatomic) UIView *line2;

@end

@implementation TYWJDetailStationCell
#pragma mark - lazy loading

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = ZLGrayColorWithRGB(150.f);
        _timeLabel.font = [UIFont systemFontOfSize:12.f];
        
    }
    return _timeLabel;
}
- (UILabel *)stationLabel {
    if (!_stationLabel) {
        _stationLabel = [[UILabel alloc] init];
        _stationLabel.textAlignment = NSTextAlignmentLeft;
         _stationLabel.font = [UIFont systemFontOfSize:12.f];
        _stationLabel.textColor = ZLGrayColorWithRGB(150.f);
    }
    return _stationLabel;
}

- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.zl_height = 0.5f;
        _line1.zl_width = 8.f;
        _line1.backgroundColor = TYWJDetailStationCellRedColor;
        _line1.hidden = YES;
    }
    return _line1;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.zl_height = 0.5f;
        _line2.zl_width = 8.f;
        _line2.backgroundColor = TYWJDetailStationCellRedColor;
        _line2.hidden = YES;
    }
    return _line2;
}
#pragma mark - set up view
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupView];
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.timeLabel];
    
    [self addSubview:self.line1];
    [self addSubview:self.line2];
    
    [self addSubview:self.stationLabel];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGFloat cycleR = 3.f;
    CGRect cycleF = CGRectMake(CGRectGetMaxX(self.line1.frame) + 2.f, self.timeLabel.zl_centerY - cycleR, 2.f*cycleR, 2.f*cycleR);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:cycleF];
    path.lineWidth = 0.5f;
    UIColor *cColor = nil;
    if (self.isStartStation) {
        cColor = TYWJDetailStationCellGreenColor;
    }else {
        cColor = TYWJDetailStationCellRedColor;
    }
    [cColor set];
    [path stroke];
    if (self.isRealHeart) {
        CGFloat r = 1.5f;
        CGRect f = CGRectMake(CGRectGetMaxX(self.line1.frame) + 3.5f, self.timeLabel.zl_centerY - r, 2.f*r, 2.f*r);
        UIBezierPath *realHeartPath = [UIBezierPath bezierPathWithOvalInRect:f];
        [realHeartPath fill];
    }
    
    CGPoint upDashStartP = CGPointMake(cycleF.origin.x + cycleR, cycleF.origin.y);
    CGPoint downDashStartP = CGPointMake(cycleF.origin.x + cycleR, cycleF.origin.y + 2.f*cycleR);
    CGPoint upDashEndP = CGPointMake(cycleF.origin.x + cycleR, 0);
    CGPoint downDashEndP = CGPointMake(cycleF.origin.x + cycleR, self.zl_height);
    UIColor *c = nil;
    if (self.isStartStation) {
        c = TYWJDetailStationCellGreenColor;
    }else {
        c = TYWJDetailStationCellRedColor;
    }
    if (self.hasUpDash) {
        [TYWJCommonTool drawDashWithStartPoint:upDashStartP endPoint:upDashEndP dashColor:c];
    }
    if (self.hasDownDash) {
        [TYWJCommonTool drawDashWithStartPoint:downDashStartP endPoint:downDashEndP dashColor:c];
    }
}

- (void)setTime:(NSString *)time {
    _time = time;
    if (self.isRealHeart && !self.isStartStation) {
        time = [NSString stringWithFormat:@"预计%@",time];
    }
    self.timeLabel.text = time;
}

- (void)setStation:(NSString *)station {
    _station = station;
    
    self.stationLabel.text = station;
}

- (void)setListInfo:(TYWJSubRouteListInfo *)listInfo {
    _listInfo = listInfo;
    
    NSString *time = listInfo.time;
    if (!self.isStartStation) {
        time = [NSString stringWithFormat:@"预计%@",time];
    }
    self.timeLabel.text = time;
    self.stationLabel.text = listInfo.station;
}

- (void)setIsRealHeart:(BOOL)isRealHeart {
    _isRealHeart = isRealHeart;
    if (isRealHeart) {
        _stationLabel.font = [UIFont systemFontOfSize:14.f];
        _stationLabel.textColor = [UIColor darkGrayColor];
        
        _timeLabel.textColor = [UIColor darkGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14.f];
        
        _line1.hidden = NO;
        _line2.hidden = NO;
    }else {
        _stationLabel.font = [UIFont systemFontOfSize:12.f];
        _stationLabel.textColor = ZLGrayColorWithRGB(150.f);
        
        _timeLabel.textColor = ZLGrayColorWithRGB(150.f);
        _timeLabel.font = [UIFont systemFontOfSize:12.f];
        
        _line1.hidden = YES;
        _line2.hidden = YES;
    }
}

- (void)setIsStartStation:(BOOL)isStartStation {
    _isStartStation = isStartStation;
    if (isStartStation) {
        _line1.backgroundColor = TYWJDetailStationCellGreenColor;
        _line2.backgroundColor = TYWJDetailStationCellGreenColor;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _timeLabel.frame = CGRectMake(0, 0, self.zl_width/3.f, 20.f);
    _timeLabel.zl_centerY = self.zl_height/2.f;
    
    
    _line1.zl_x = CGRectGetMaxX(self.timeLabel.frame) + 2.f;
    _line1.zl_centerY = self.timeLabel.zl_centerY;
    
    _line2.zl_x = CGRectGetMaxX(self.line1.frame) + 10.f;
    _line2.zl_centerY = self.timeLabel.zl_centerY;
    
    CGFloat x = CGRectGetMaxX(self.line2.frame) + 2.f;
    _stationLabel.frame = CGRectMake(x, 0, self.zl_width - x, 20.f);
    _stationLabel.zl_centerY = self.zl_height/2.f;
   
}
@end
