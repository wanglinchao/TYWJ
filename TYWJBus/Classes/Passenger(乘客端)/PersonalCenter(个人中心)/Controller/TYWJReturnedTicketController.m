//
//  TYWJReturnedTicketController.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJReturnedTicketController.h"
#import "TYWJComplaintController.h"
#import "TYWJTicketList.h"


@interface TYWJReturnedTicketController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *stationLabel;
@property (weak, nonatomic) IBOutlet UILabel *getupDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *cancelRouteTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *successTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnMethodLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnTicketReasonLabel;

@end

@implementation TYWJReturnedTicketController

- (void)dealloc {
    ZLFuncLog;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
    [self setupData];
}

- (void)setupView {
    self.navigationItem.title = @"已退行程费";
    [self.topView setRoundViewWithCornerRaidus:6.f];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self.topView setBorderWithColor:ZLGrayColorWithRGB(222.f)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"投诉" style:UIBarButtonItemStyleDone target:self action:@selector(complaintClicked)];
    
}

- (void)setupData {
    if (self.ticket) {
        self.stationLabel.text = [NSString stringWithFormat:@"%@——%@",self.ticket.beginStation,self.ticket.endStation];
        self.getupDateLabel.text = self.ticket.getupDate;
    }else {
        self.stationLabel.text = [NSString stringWithFormat:@"%@——%@",self.monthTicket.startStatation,self.monthTicket.desStation];
        self.getupDateLabel.text = [NSString stringWithFormat:@"%@.%@月行程费",self.monthTicket.year,self.monthTicket.month];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *nowTime = [formatter stringFromDate: [NSDate date]];
    
    
    self.cancelRouteTimeLabel.text = nowTime;
    self.handleTimeLabel.text = nowTime;
    self.successTimeLabel.text = nowTime;
    self.returnTicketReasonLabel.text = self.returnTicketReason;
}
#pragma mark - 按钮点击

- (void)complaintClicked {
    ZLFuncLog;
    TYWJComplaintController *vc = [[TYWJComplaintController alloc] init];
    vc.ticket = self.ticket;
    vc.monthTicket = self.monthTicket;
    vc.isRefundTicket = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
