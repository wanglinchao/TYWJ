//
//  TYWJContactCustomerServiceView.m
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJContactCustomerServiceView.h"
#import "TYWJBorderButton.h"
#import "TYWJCombineTextButton.h"
#import "NSObject+ZLAlertView.h"


@interface TYWJContactCustomerServiceView()

@property (weak, nonatomic) IBOutlet TYWJCombineTextButton *combineView;

@end

@implementation TYWJContactCustomerServiceView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupView];
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    [self.combineView setTips:@"遇到问题？您可以" protocol:@"联系客服"];
    self.combineView.hasUnderLine = YES;
    self.combineView.hidden = YES;
    
    self.nextBtn.enabled = NO;
    
    WeakSelf;
    self.combineView.btnClicked = ^{
        //这里弹出拨打客服电话窗口
        
        [weakSelf alertWithTitle:@"拨打客服电话" message:TYWJCustomerServicePhoneNum finish:^{
            ZLFuncLog;
            
            //拨打电话号码
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",TYWJCustomerServicePhoneNum]]];
        }];
        if (self.combineViewClicked) {
            self.combineViewClicked();
        }
    };
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nextBtn setRoundViewWithCornerRaidus:8.f];
}


@end
