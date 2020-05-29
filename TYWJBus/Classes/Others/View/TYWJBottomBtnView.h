//
//  TYWJBottomBtnView.h
//  TYWJBus
//
//  Created by tywj on 2020/5/29.
//  Copyright © 2020 MacBook. All rights reserved.
//
/*
 
 TYWJBottomBtnView *view = [[TYWJBottomBtnView alloc] initWithFrame:CGRectMake(0, 0, ZLScreenWidth, 60)];
 view.titleArr = @[@"1"];
 view.buttonSeleted = ^(NSInteger index) {
     switch (index -200) {
         case 0:
             
             break;
             
         default:
             break;
     }
 };
 [self.contentView addSubview:view];
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYWJBottomBtnView : UIView
@property (strong, nonatomic) NSArray *titleArr;
@property (copy, nonatomic) void(^buttonSeleted)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
