//
//  TYWJSchedulingDetailStateView.h
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJTripList.h"
NS_ASSUME_NONNULL_BEGIN

@interface TYWJSchedulingDetailStateView : UIView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height3;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);
@property (weak, nonatomic) IBOutlet UIImageView *checkStateImage;
@property (weak, nonatomic) IBOutlet UILabel *line_name;
@property (weak, nonatomic) IBOutlet UILabel *line_time;
@property (weak, nonatomic) IBOutlet UILabel *startL;
@property (weak, nonatomic) IBOutlet UILabel *endL;
@property (weak, nonatomic) IBOutlet UILabel *carNumL;
@property (weak, nonatomic) IBOutlet UILabel *ticketNumL;








- (void)confirgViewWithModel:(TYWJTripList *)model;

@end

NS_ASSUME_NONNULL_END
