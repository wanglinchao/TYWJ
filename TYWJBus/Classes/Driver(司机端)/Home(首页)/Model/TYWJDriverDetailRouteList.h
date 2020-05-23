//
//  TYWJDriverDetailRouteList.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/31.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJDriverDetailRouteListInfo : NSObject

/* 线路编号 */
@property (copy, nonatomic) NSString *xlbh;
/* 站编号 */
@property (copy, nonatomic) NSString *text;
/* 站名 */
@property (copy, nonatomic) NSString *station;
/* 经度 */
@property (copy, nonatomic) NSString *longitude;
/* 纬度 */
@property (copy, nonatomic) NSString *latitude;
/* 发车时间 */
@property (copy, nonatomic) NSString *startTime;


@end

@interface TYWJDriverDetailRouteList : NSObject

/* xlbh */
@property (copy, nonatomic) NSString *xlbh;
/* text */
@property (copy, nonatomic) NSString *text;
/* listInfo */
@property (strong, nonatomic) TYWJDriverDetailRouteListInfo *listInfo;

@end
