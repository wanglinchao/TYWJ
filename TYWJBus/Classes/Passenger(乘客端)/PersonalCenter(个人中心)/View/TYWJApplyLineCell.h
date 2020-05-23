//
//  TYWJApplyLineCell.h
//  TYWJBus
//
//  Created by tywj on 2020/3/10.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJApplyLineCell : UITableViewCell
+ (instancetype)cellForTableView:(UITableView *)tableView;
/* 上车地点点击 */
@property (copy, nonatomic) void(^upBtnClicked)(void);
/* 下车地点点击 */
@property (copy, nonatomic) void(^downBtnClicked)(void);
/* 上班线路点击 */
@property (copy, nonatomic) void(^onDutyBtnClicked)(void);
/* 下班线路点击 */
@property (copy, nonatomic) void(^offDutyBtnClicked)(void);
/* 往返线路点击 */
@property (copy, nonatomic) void(^allBtnclicked)(void);
/* 上班时间点击 */
@property (copy, nonatomic) void(^upTimeBtnClicked)(void);
/* 下班时间点击 */
@property (copy, nonatomic) void(^downTimeBtnClicked)(void);
/* 提交线路申请 */
@property (copy, nonatomic) void(^applyBtnClicked)(NSString *upStaion, NSString *downStaion, NSString *num, NSString *kind, NSString *upTime, NSString *downTime, NSString *phone);
/* 分享 */
@property (copy, nonatomic) void(^shareBtnClicked)(void);

@property (weak, nonatomic) IBOutlet UITextField *startField;
@property (weak, nonatomic) IBOutlet UITextField *endField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeField;
/* upLat */
@property (assign, nonatomic) CGFloat upLat;//上车维度
/* upLong */
@property (assign, nonatomic) CGFloat upLong;//上车精度
/* downLat */
@property (assign, nonatomic) CGFloat downLat;//下车维度
/* downLong */
@property (assign, nonatomic) CGFloat downLong;//下车精度
@end

NS_ASSUME_NONNULL_END
