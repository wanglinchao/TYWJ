//
//  TYWJTableViewControllerCell.h
//  TYWJBus
//
//  Created by tywj on 2020/6/11.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYWJBaseCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface TYWJDriverHomeCell : TYWJBaseCell
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);
@property (weak, nonatomic) IBOutlet UIButton *singnBtn;

@end

NS_ASSUME_NONNULL_END
