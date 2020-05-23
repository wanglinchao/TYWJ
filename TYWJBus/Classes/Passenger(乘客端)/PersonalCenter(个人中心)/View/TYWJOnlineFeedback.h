//
//  TYWJOnlineFeedback.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/19.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYWJTextVeiw;

@interface TYWJOnlineFeedback : UIView

@property (weak, nonatomic,readonly) IBOutlet TYWJTextVeiw *tv;

- (void)addTarget:(id)target action:(nonnull SEL)action;


@end
