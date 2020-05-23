//
//  TYWJZYXWebController.h
//  TYWJBus
//
//  Created by MacBook on 2018/8/13.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "TYWJBaseController.h"

@interface TYWJZYXWebController : TYWJBaseController

/* navTitle */
@property (copy, nonatomic) NSString *navTitle;
/* url */
@property (copy, nonatomic) NSString *url;
/* 有navTitle情况下，是否设置contentinfset */
@property (assign, nonatomic) BOOL isNotSetInset;
/* 推荐码 */
@property (copy, nonatomic) NSString *recommendationCode;

@end
