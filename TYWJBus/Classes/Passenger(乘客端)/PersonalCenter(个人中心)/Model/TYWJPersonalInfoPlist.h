//
//  TYWJPersonalInfoPlist.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/11.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJPersonalInfoPlist : NSObject

/* title */
@property (copy, nonatomic) NSString *title;
/* isInfoEnable */
@property (assign, nonatomic) BOOL isInfoEnable;
/* index */
@property (copy, nonatomic) NSString *index;
/* isShowArrow */
@property (assign, nonatomic) BOOL isShowArrow;
/* isShowInfo */
@property (assign, nonatomic) BOOL isShowInfo;
/* isShowAvatar */
@property (assign, nonatomic) BOOL isShowAvatar;
/* isShowChooseGender */
@property (assign, nonatomic) BOOL isShowChooseGender;


@end
