//
//  TYWJApplyBottomPurchaseView.h
//  TYWJBus
//
//  Created by tywj on 2020/3/13.
//  Copyright © 2020 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJApplyBottomPurchaseView : UIView

- (void)addPurchaceTarget:(id)target action:(nonnull SEL)action;
- (void)addInterestTarget:(id)target action:(nonnull SEL)action;
- (void)setPrice:(NSString *)price;
@end

NS_ASSUME_NONNULL_END
