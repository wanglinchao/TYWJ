//
//  TYWJTipsViewRefunds.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/25.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJBaseView.h"
#import "TYWJTripList.h"
@interface TYWJTipsViewRefunds : TYWJBaseView

@property (weak, nonatomic) IBOutlet UILabel *line_name;
@property (weak, nonatomic) IBOutlet UILabel *line_time;
@property (weak, nonatomic) IBOutlet UILabel *refundFeeL;
@property (weak, nonatomic) IBOutlet UILabel *refundAmountL;

@property (weak, nonatomic) IBOutlet UIButton *changePhoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);

@end
