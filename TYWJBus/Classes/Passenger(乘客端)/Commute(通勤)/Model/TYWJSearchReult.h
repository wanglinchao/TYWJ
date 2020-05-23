//
//  TYWJSearchReult.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/5.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TYWJSubRouteListInfo,TYWJRouteListInfo;

@interface TYWJSearchReult : NSObject

/* TYWJRouteListInfo */
@property (strong, nonatomic) TYWJRouteListInfo *routeInfo;
/* startStation */
@property (strong, nonatomic) TYWJSubRouteListInfo *startStation;
/* desStation */
@property (strong, nonatomic) TYWJSubRouteListInfo *desStation;
/* 开始站 */
@property (strong, nonatomic) TYWJSubRouteListInfo *beginStation;
/* 下车站 */
@property (strong, nonatomic) TYWJSubRouteListInfo *endStation;
/* 搜索上车地点 */
@property (copy, nonatomic) NSString *beginPlace;
/* 搜索下车地点 */
@property (copy, nonatomic) NSString *endPlace;
/* 上车点距离 */
@property (assign, nonatomic) CGFloat getupDistance;
/* 下车距离 */
@property (assign, nonatomic) CGFloat getdownDistance;
/* 票价 */
@property (copy, nonatomic) NSString *price;


@end
