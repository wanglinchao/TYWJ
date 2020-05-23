//
//  TYWJStationToStationView.h
//  TYWJBus
//
//  Created by Harllan He on 2018/5/29.
//  Copyright © 2018 Harllan He. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface TYWJStationToStationView : UIView
/* getupLabel */
@property (strong, nonatomic) UITextField *getupTF;
/* getdownLabel */
@property (strong, nonatomic) UITextField *getdownTF;
/* 上车地点 点击 */
@property (copy, nonatomic) void(^getupBtnClicked)(void);
/* 下车地点 点击 */
@property (copy, nonatomic) void(^getdownBtnClicked)(void);

- (void)switchTF;

@end
