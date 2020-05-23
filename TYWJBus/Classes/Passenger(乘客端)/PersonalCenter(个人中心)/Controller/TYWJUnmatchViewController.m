//
//  TYWJUnmatchViewController.m
//  TYWJBus
//
//  Created by tywj on 2020/3/16.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJUnmatchViewController.h"
#import "TYWJApplyList.h"

@interface TYWJUnmatchViewController ()
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

@implementation TYWJUnmatchViewController

- (void)setupUI{
    _upStationField.userInteractionEnabled = false;
    _downStationField.userInteractionEnabled = false;
    _numField.userInteractionEnabled = false;
    _upTimeField.userInteractionEnabled = false;
    _downTimeField.userInteractionEnabled = false;
    _phoneField.userInteractionEnabled = false;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    // Do any additional setup after loading the view from its nib.
    self.startTimeLabel.text = [NSString stringWithFormat:@"发起时间:%@",self.applyListInfo.update_time];
    self.stateLabel.text = self.applyListInfo.status;
    self.upStationField.placeholder = self.applyListInfo.jtzz;
    self.downStationField.placeholder = self.applyListInfo.gsdz;
    self.numField.placeholder = self.applyListInfo.ccrs;
    self.upTimeField.placeholder = self.applyListInfo.sbsj;
    self.downTimeField.placeholder = self.applyListInfo.xbsj;
    self.phoneField.placeholder = self.applyListInfo.yhm;
    if ([self.applyListInfo.kind isEqualToString:@"上班线路"]) {
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
    }else if ([self.applyListInfo.kind isEqualToString:@"下班线路"]) {
        self.downImageView.image = [UIImage imageNamed:@"icon／choose"];
        self.upImageView.image = [UIImage imageNamed:@"checkbox_20x20_"];
        self.backIamgeView.image = [UIImage imageNamed:@"checkbox_20x20_"];
        self.upTimeField.hidden = YES;
        self.downTimeField.hidden = NO;
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
