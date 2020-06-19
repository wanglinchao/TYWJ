//
//  TYWJChooseStopsCell.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/12.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJChooseStopsCell.h"
#import "TYWJChooseStationView.h"

NSString * const TYWJChooseStopsCellID = @"TYWJChooseStopsCellID";

@interface TYWJChooseStopsCell()


@end

@implementation TYWJChooseStopsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];

    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    imageV.frame = CGRectMake(16, 17, 4, 16);
    imageV.backgroundColor = kMainYellowColor;
    [self addSubview:imageV];
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    tipsLabel.font = [UIFont systemFontOfSize:16.f];
    tipsLabel.textAlignment = NSTextAlignmentLeft;
    tipsLabel.frame = CGRectMake(32.f, 0, ZLScreenWidth - 20.f, 50.f);
    tipsLabel.text = @"选择上下车站点";
    [self addSubview:tipsLabel];
    
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.frame = CGRectMake(16, tipsLabel.zl_height, ZLScreenWidth - 32, 100.f);
    contentView.layer.cornerRadius = 15.f;
    [self addSubview:contentView];
    
    TYWJChooseStationView *getupStationView = [TYWJChooseStationView chooseStationWithFrame:CGRectMake(0, 0, contentView.zl_width, 50.f)];
    getupStationView.backgroundColor = [UIColor clearColor];
    [getupStationView setPlaceholder:@"亲哪儿上车?"];
    [getupStationView setCircleColor: [UIColor colorWithHexString:@"#23C371"]];
    [getupStationView addTarget:self action:@selector(getupClicked)];
    [contentView addSubview:getupStationView];
    _getupView = getupStationView;
    
    TYWJChooseStationView *getdownStationView = [TYWJChooseStationView chooseStationWithFrame:CGRectMake(0, CGRectGetMaxY(getupStationView.frame), getupStationView.zl_width, 50.f)];
    getdownStationView.backgroundColor = [UIColor clearColor];
    [getdownStationView setPlaceholder:@"亲哪儿下车?"];
    [getdownStationView setCircleColor: [UIColor colorWithHexString:@"#FF4040"]];
    getdownStationView.isShowSeparator = NO;
    [getdownStationView addTarget:self action:@selector(getdownClicked)];
    [contentView addSubview:getdownStationView];
    _getdownView = getdownStationView;
}

#pragma mark - 按钮点击
- (void)getupClicked {
    ZLFuncLog;
    if (self.getupStatonClicked) {
        self.getupStatonClicked();
    }
}

- (void)getdownClicked {
    ZLFuncLog;
    if (self.gedownStatonClicked) {
        self.gedownStatonClicked();
    }
}

#pragma mark - 外部方法

- (void)setGetupStation:(NSString *)station {
    if (station) {
        [self.getupView setStation:station];
    }
}

- (void)setGetdownStation:(NSString *)station {
    if (station) {
        [self.getdownView setStation:station];
    }
}

- (void)setGetupTime:(NSString *)time{
        if (time) {
            [self.getupView setTime:time];
        }
    
}
- (void)setGetdownTime:(NSString *)time{
        if (time) {
            [self.getdownView setTime:time];
        }
    }

@end
