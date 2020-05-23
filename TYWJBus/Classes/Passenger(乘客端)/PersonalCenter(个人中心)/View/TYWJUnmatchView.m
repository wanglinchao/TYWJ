//
//  TYWJUnmatchView.m
//  TYWJBus
//
//  Created by tywj on 2020/3/16.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJUnmatchView.h"
#import "TYWJApplyList.h"

@interface TYWJUnmatchView ()
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UITextField *upStationField;
@property (weak, nonatomic) IBOutlet UITextField *downStationField;
@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UIImageView *upImageView;
@property (weak, nonatomic) IBOutlet UIImageView *downImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backIamgeView;
@property (weak, nonatomic) IBOutlet UITextField *upTimeField;
@property (weak, nonatomic) IBOutlet UITextField *downTimeField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upTimeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *uptimeTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downTimeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downtimeTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upTimeLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downTimeLabelHeightConstraint;
@end

@implementation TYWJUnmatchView

+ (instancetype)unmatchView
{
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        [self setupUI];
    }
    
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupUI];
}
- (void)setupUI{
    _upStationField.userInteractionEnabled = NO;
    _downStationField.userInteractionEnabled = NO;
    _numField.userInteractionEnabled = NO;
    _upTimeField.userInteractionEnabled = NO;
    _downTimeField.userInteractionEnabled = NO;
    _phoneField.userInteractionEnabled = NO;
}
- (void)setApplyListInfo:(TYWJApplyListInfo *)applyListInfo
{
    _applyListInfo = applyListInfo;
    self.startTimeLabel.text = [NSString stringWithFormat:@"发起时间:%@",applyListInfo.update_time];
    self.stateLabel.text = applyListInfo.status;
    self.upStationField.placeholder = applyListInfo.jtzz;
    self.downStationField.placeholder = applyListInfo.gsdz;
    self.numField.placeholder = applyListInfo.ccrs;
    self.upTimeField.placeholder = applyListInfo.sbsj;
    self.downTimeField.placeholder = applyListInfo.xbsj;
    self.phoneField.placeholder = applyListInfo.yhm;
    if ([applyListInfo.kind isEqualToString:@"上班线路"]) {
        self.upImageView.image = [UIImage imageNamed:@"icon／choose"];
        self.downImageView.image = [UIImage imageNamed:@"checkbox_20x20_"];
        self.backIamgeView.image = [UIImage imageNamed:@"checkbox_20x20_"];
        self.upTimeField.hidden = NO;
        self.downTimeField.hidden = YES;
        self.upTimeHeightConstraint.constant = 34.0f;
        self.uptimeTopConstraint.constant = 20.0f;
        self.downTimeHeightConstraint.constant = 0.0f;
        self.downtimeTopConstraint.constant = 0.0f;
        self.upTimeLabelHeightConstraint.constant = 18.0f;
        self.downTimeLabelHeightConstraint.constant = 0.0f;
    }else if ([applyListInfo.kind isEqualToString:@"下班线路"]) {
        self.upTimeField.hidden = YES;
        self.downTimeField.hidden = NO;
        self.downImageView.image = [UIImage imageNamed:@"icon／choose"];
        self.upImageView.image = [UIImage imageNamed:@"checkbox_20x20_"];
        self.backIamgeView.image = [UIImage imageNamed:@"checkbox_20x20_"];
        self.upTimeHeightConstraint.constant = 0.0f;
        self.uptimeTopConstraint.constant = 0.0f;
        self.downTimeHeightConstraint.constant = 34.0f;
        self.downtimeTopConstraint.constant = 10.0f;
        self.downTimeLabelHeightConstraint.constant = 18.0f;
        self.upTimeLabelHeightConstraint.constant = 0.0f;
    }else {
        self.upTimeField.hidden = NO;
        self.downTimeField.hidden = NO;
        self.backIamgeView.image = [UIImage imageNamed:@"icon／choose"];
        self.downImageView.image = [UIImage imageNamed:@"checkbox_20x20_"];
        self.upImageView.image = [UIImage imageNamed:@"checkbox_20x20_"];
        self.upTimeHeightConstraint.constant = 34.0f;
        self.uptimeTopConstraint.constant = 20.0f;
        self.downTimeHeightConstraint.constant = 34.0f;
        self.downtimeTopConstraint.constant = 10.0f;
        self.upTimeLabelHeightConstraint.constant = 18.0f;
        self.downTimeLabelHeightConstraint.constant = 18.0f;
    }
}

@end
