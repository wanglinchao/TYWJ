//
//  TYWJContactCustomerServiceView.h
//  TYWJBus
//
//  Created by Harley He on 2018/5/28.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYWJBorderButton,TYWJCombineTextButton;

@interface TYWJContactCustomerServiceView : UIView

@property (weak, nonatomic) IBOutlet TYWJBorderButton *nextBtn;

/* combineViewClicked */
@property (copy, nonatomic) void(^combineViewClicked)(void);

@end
