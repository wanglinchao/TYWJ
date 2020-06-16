//
//  TYWJBuyTicketController.h
//  TYWJBus
//
//  Created by Harley He on 2018/6/6.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import "TYWJBaseController.h"
@class TYWJRouteListInfo,TYWJSearchReult;

@interface TYWJBuyTicketController : TYWJBaseController


/* 搜索结果模型 */
@property (strong, nonatomic) TYWJSearchReult *result;
/* routeLists */
@property (strong, nonatomic) NSMutableArray *routeLists;
@property (strong, nonatomic) NSMutableDictionary *startAndEndStation;
//首页购票需要传此参数
@property (assign, nonatomic) NSString * line_info_id;
@property (assign, nonatomic) NSString * line_name;
@property (assign, nonatomic) NSString * line_time;
@end
