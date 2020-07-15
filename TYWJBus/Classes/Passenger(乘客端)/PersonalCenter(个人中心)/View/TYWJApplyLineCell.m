//
//  TYWJApplyLineCell.m
//  TYWJBus
//
//  Created by tywj on 2020/3/10.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import "TYWJApplyLineCell.h"
#import "TYWJSingleLocation.h"
#import "TYWJLoginTool.h"
#import "TYWJTextVeiw.h"
@interface TYWJApplyLineCell ()

@property (weak, nonatomic) IBOutlet UITextField *numField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upTimeTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upTimeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downTimeTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downTimeHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upTimeLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downTimeLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *onDutyBtn;
@property (weak, nonatomic) IBOutlet UIButton *offDutyBtn;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet TYWJTextVeiw *tv;

@property (copy, nonatomic) NSString *kind;//种类

@end

@implementation TYWJApplyLineCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.tv showPlaceholder];
    self.tv.phText = @"选填，不超过30个字。";    
    WeakSelf;
    TYWJSingleLocation *loc = [TYWJSingleLocation stantardLocation];
    [loc startBasicLocation];
    loc.locationDataDidChange = ^(AMapLocationReGeocode *reGeocode,CLLocation *location) {
        if (reGeocode) {
            //           weakSelf.startField.text = [NSString stringWithFormat:@"%@（可更改）",reGeocode.POIName];
            weakSelf.startField.text = reGeocode.POIName;
            self.upLat = location.coordinate.latitude;
            self.upLong = location.coordinate.longitude;
        }
    };
    self.phoneField.text = [TYWJLoginTool sharedInstance].phoneNum;
}

+ (instancetype)cellForTableView:(UITableView *)tableView
{
    static NSString *cellID = @"applyLineCell";
    TYWJApplyLineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    }
    return cell;
}

- (IBAction)upBtnClicked:(UIButton *)sender {
    [self.numField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    if (self.upBtnClicked) {
        self.upBtnClicked();
    }
}

- (IBAction)downBtnClicked:(UIButton *)sender {
    [self.numField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    if (self.downBtnClicked) {
        self.downBtnClicked();
    }
}


- (IBAction)upTimeBtnClicked:(UIButton *)sender {
    [self.numField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    if (self.upTimeBtnClicked) {
        self.upTimeBtnClicked();
    }
}

- (IBAction)downTimeBtnClicked:(UIButton *)sender {
    [self.numField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    if (self.downTimeBtnClicked) {
        self.downTimeBtnClicked();
    }
}

- (IBAction)applyBtnClicked:(UIButton *)sender {
    [self.numField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    if ([self.startField.text length] == 0) {
        [MBProgressHUD zl_showError:@"请选择上车地点"];
        return;
    }
    
    if ([self.endField.text length] == 0) {
        [MBProgressHUD zl_showError:@"请选择下车地点"];
        return;
    }
    
    if ([self.startTimeField.text length] == 0) {
        [MBProgressHUD zl_showError:@"请选择出发时间"];
        return;
    }
    if ([self.endTimeField.text length] == 0) {
        [MBProgressHUD zl_showError:@"请选择返回时间"];
        return;
    }
    if ([self.numField.text length] == 0) {
        self.numField.text = @"1";
    }
    
    NSString *startTimeStr;
    NSString *endTimeStr;
    
    if ([self.kind isEqualToString:@"上班线路"]) {
        if ([self.startTimeField.text length] == 0) {
            startTimeStr = @"09:00";
        }else {
            startTimeStr = self.startTimeField.text;
        }
        endTimeStr = @"";
    }else if ([self.kind isEqualToString:@"下班线路"]) {
        if ([self.endTimeField.text length] == 0) {
            endTimeStr = @"18:00";
        }else {
            endTimeStr = self.startTimeField.text;
        }
        startTimeStr = @"";
    }else {
        if ([self.startTimeField.text length] == 0) {
            startTimeStr = @"09:00";
        }else {
            startTimeStr = self.startTimeField.text;
        }
        
        if ([self.endTimeField.text length] == 0) {
            endTimeStr = @"18:00";
        }else {
            endTimeStr = self.startTimeField.text;
        }
    }
    if (self.applyBtnClicked) {
        self.applyBtnClicked(self.startField.text, self.endField.text, self.numField.text, self.kind, startTimeStr, endTimeStr, self.phoneField.text);
    }
}

- (IBAction)shareBtnClicked:(UIButton *)sender {
    [self.numField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    if (self.shareBtnClicked) {
        self.shareBtnClicked();
    }
}

// 判断是否是手机号
- (BOOL)isValidPhone:(NSString *)phone
{
    if (phone.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:phone];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:phone];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:phone];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
@end
