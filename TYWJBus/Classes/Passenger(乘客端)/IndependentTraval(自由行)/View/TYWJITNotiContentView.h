//
//  TYWJITNotiContentView.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/23.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYWJITNotiContentView : UIView

- (void)addTarget:(id)target action:(nonnull SEL)action;
@property (weak, nonatomic, readonly) IBOutlet UITextView *bodyTV;

@end
