//
//  TYWJCarLocation.h
//  TYWJBus
//
//  Created by Harley He on 2018/7/3.
//  Copyright © 2018 Harley He. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYWJCarLocationInfo : NSObject

/* 线路编号 */
@property (copy, nonatomic) NSString *routeNum;
/* 经度 */
@property (copy, nonatomic) NSString *longitude;
/* 纬度 */
@property (copy, nonatomic) NSString *latitude;
/* 城市 */
@property (copy, nonatomic) NSString *city;

@end

@interface TYWJCarLocation : NSObject

/* text */
@property (copy, nonatomic) NSString *text;
/* info */
@property (strong, nonatomic) TYWJCarLocationInfo *info;

@end
