//
//  TYWJHomeHeaderView.h
//  TYWJBus
//
//  Created by tywj on 2020/5/21.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJHomeHeaderView : UIView
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meassageViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIView *messageVIew;
@property (weak, nonatomic) IBOutlet UIButton *rightV;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
@property (weak, nonatomic) IBOutlet UIView *stationView;
- (void)showMessage:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
