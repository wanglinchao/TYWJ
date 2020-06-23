//
//  TYWJShowAlertViewController.h
//  TYWJBus
//
//  Created by tywj on 2020/6/2.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJShowAlertViewController : UIViewController
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);
@property (copy, nonatomic) void(^getData)(id date);
- (void)showRefundsWithDic:(id)dic;
- (void)showRefundsStatusWithDic:(id)dic;

- (void)showShareViewWithDic:(NSDictionary *)dic;
- (void)showCalendarViewithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
