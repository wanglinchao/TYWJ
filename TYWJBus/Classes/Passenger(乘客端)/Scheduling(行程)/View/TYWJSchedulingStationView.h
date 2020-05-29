//
//  TYWJSchedulingStationView.h
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJSchedulingStationView : UIView
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numLheight;
-(void)hiddenView;
@end

NS_ASSUME_NONNULL_END
