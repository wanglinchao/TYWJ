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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meassageViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightV;
- (void)showMessage;
@end

NS_ASSUME_NONNULL_END
