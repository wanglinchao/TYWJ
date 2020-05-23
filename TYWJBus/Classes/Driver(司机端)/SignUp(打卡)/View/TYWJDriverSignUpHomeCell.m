//
//  TYWJDriverSignUpHomeCell.m
//  TYWJBus
//
//  Created by MacBook on 2018/12/11.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJDriverSignUpHomeCell.h"
#import "TYWJDriverDetailRouteController.h"
#import "TYWJTripsModel.h"
#import "TYWJBorderButton.h"

NSString * const TYWJDriverSignUpHomeCellID = @"TYWJDriverSignUpHomeCellID";


@interface TYWJDriverSignUpHomeCell()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *disLabel;
@property (weak, nonatomic) IBOutlet UILabel *stationsLabel;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UILabel *rollLabel;
@property (weak, nonatomic) IBOutlet UIButton *currentBtn;
@property (weak, nonatomic) IBOutlet TYWJBorderButton *signInBtn;


@end

@implementation TYWJDriverSignUpHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setRoundViewWithCornerRaidus:6.f];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setBorderWithColor:ZLNavTextColor];
    [self setBorderWidth:0.3f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 按钮点击
/**
 行程单点击
 */
- (IBAction)routeListClicked:(id)sender {
    ZLFuncLog;
    TYWJDriverDetailRouteController *vc = [[TYWJDriverDetailRouteController alloc] init];
    vc.ID = self.trip.ID;
    [TYWJCommonTool pushToVc:vc];
}

/**
 设为当前点击
 */
- (IBAction)currentBtnClicked:(id)sender {
    ZLFuncLog;
    self.currentBtn.selected = !self.currentBtn.selected;
}

/**
 手动打卡
 */
- (IBAction)signInClicked:(id)sender {
    ZLFuncLog;
    if (self.mSignInClicked) {
        self.mSignInClicked(self.trip);
    }
}

#pragma mark --
- (void)setTrip:(TYWJTripsModel *)trip {
    _trip = trip;
    
    //1544581633000
    UIColor *c = ZLColorWithRGB(255, 100, 100);
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attString1 = [[NSAttributedString alloc] initWithString:@"乘客人数:" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName : [UIFont systemFontOfSize:12.f]}];
    
    NSAttributedString *attString2 = [[NSAttributedString alloc] initWithString:trip.occupiedSeats attributes:@{NSForegroundColorAttributeName : c,NSFontAttributeName : [UIFont systemFontOfSize:15.f]}];
    
    NSAttributedString *attString3 = [[NSAttributedString alloc] initWithString:@"人 讲解:" attributes:@{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName : [UIFont systemFontOfSize:12.f]}];
    
    NSString *instructorName = trip.instructorName ? trip.instructorName : @"暂未设置";
    NSAttributedString *attString4 = [[NSAttributedString alloc] initWithString:instructorName attributes:@{NSForegroundColorAttributeName : c,NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    
    [attString appendAttributedString:attString1];
    [attString appendAttributedString:attString2];
    [attString appendAttributedString:attString3];
    [attString appendAttributedString:attString4];
    self.tipsLabel.attributedText = attString;
    
    self.startTimeLabel.text = trip.schedule;
    self.statusLabel.text = [NSString stringWithFormat:@"%@---%@",trip.departStation.shortName,trip.arriveStation.shortName];
    self.disLabel.text = [NSString stringWithFormat:@"备用终点:%@",trip.backupStations];
    
    if (trip.roll.boolValue) {
        self.rollLabel.hidden = NO;
        self.currentBtn.hidden = NO;
    }else {
        self.rollLabel.hidden = YES;
        self.currentBtn.hidden = YES;
    }
    
    switch (trip.status.integerValue) {
        case 0://待发车
        {
            self.statusLabel.text = @"• 待发车";
            self.statusLabel.textColor = ZLColorWithRGB(73, 207, 104);
            self.statusView.hidden = YES;
            self.startTimeLabel.textColor = [UIColor blackColor];
            
            self.signInBtn.hidden = NO;
            [self.signInBtn setTitle:@"出发打卡" forState:UIControlStateNormal];
        }
            break;
        case 1://运行中
        {
            self.statusLabel.text = @"• 运行中";
            self.statusLabel.textColor = c;
            self.statusView.hidden = NO;
            self.startTimeLabel.textColor = [UIColor grayColor];
            
            self.signInBtn.hidden = NO;
            [self.signInBtn setTitle:@"到达打卡" forState:UIControlStateNormal];
        }
            break;
        case 2://已完成
        {
            self.statusLabel.text = @"• 已完成";
            self.statusLabel.textColor = [UIColor grayColor];
            self.statusView.hidden = YES;
            self.startTimeLabel.textColor = [UIColor blackColor];
            self.signInBtn.hidden = YES;
        }
            break;
        case 4://已完成
        {
            self.statusLabel.text = @"• 已失效";
            self.statusLabel.textColor = [UIColor grayColor];
            self.statusView.hidden = YES;
            self.startTimeLabel.textColor = [UIColor blackColor];
            self.signInBtn.hidden = YES;
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 10.f;
    frame.size.width -= 20.f;
    frame.origin.y += 10.f;
    frame.size.height -= 10.f;
    [super setFrame:frame];
}

@end
