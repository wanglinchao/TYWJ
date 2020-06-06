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

- (void)showRefundsWithDic:(NSDictionary *)dic;
- (void)showShareViewWithDic:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
