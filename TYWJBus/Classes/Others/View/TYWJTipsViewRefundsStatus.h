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
@interface TYWJTipsViewRefundsStatus : TYWJBaseView
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIButton *registerBtn;


@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);

@end
