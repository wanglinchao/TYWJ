//
//  TYWJComplaintFooter.m
//  TYWJBus
//
//  Created by Harley He on 2018/6/21.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJComplaintFooter.h"
#import "TYWJBorderButton.h"
#import "TYWJTextVeiw.h"


@interface TYWJComplaintFooter()

@property (weak, nonatomic) IBOutlet TYWJTextVeiw *tv;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet TYWJBorderButton *commitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commitTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewH;

@end

@implementation TYWJComplaintFooter

#pragma mark - 按钮点击

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.commitBtn setBorderColor:ZLNavTextColor];
    [self.contentView setRoundViewWithCornerRaidus:6.f];
    self.backgroundColor = ZLGlobalBgColor;
    
    if (ZLScreenHeight == 568) {
        self.contentViewH.constant = 130.f;
        self.commitTop.constant = 30.f;
    }else {
        self.commitTop.constant = 50.f;
        self.contentViewH.constant = 160.f;
    }
    
    self.tv.phText = @"还有什么想说的?";
    
}


- (IBAction)commitClicked:(TYWJBorderButton *)sender {
    ZLFuncLog;
    //这里不写也行
    
    
    
    if (self.isRefundTicket) {
        //退票,进入退票界面
        if (self.quitTicketClicked) {
            self.quitTicketClicked(self.tv.text);
        }
        self.tv.text = @"";
        [self.tv showPlaceholder];
    }else {
        //投诉，投诉成功直接返回上一级
        if (self.complaintClicked) {
            self.complaintClicked(self.tv.text);
        }
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.commitBtn setRoundViewWithCornerRaidus:8.f];
}


@end
